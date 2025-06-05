import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart'; // For Amplify safePrint
import 'package:collection/collection.dart'; // Added for firstWhereOrNull
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart'; // Added for MealPlanCache
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
import 'package:dima_application/providers/isar_provider.dart';
import 'package:dima_application/services/api_service.dart' as api_service;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// --- Data Status Enum ---
enum MealPlanListStatus {
  initial,
  loading,
  loaded, // Combined online/offline for simplicity, can be expanded
  error,
  // Specific errors could be added, e.g., errorNoPlansFound
}

// --- State Definition ---
class MealPlanListState {
  final MealPlanListStatus status;
  final MealPlanList
      mealPlanListData; // Contains currentMealPlan and allMealPlans
  final String? errorMessage;
  final DateTime? lastFetched; // When the list was last successfully fetched

  MealPlanListState({
    this.status = MealPlanListStatus.initial,
    MealPlanList? mealPlanListData,
    this.errorMessage,
    this.lastFetched,
  }) : mealPlanListData = mealPlanListData ?? MealPlanList.initial();

  MealPlanListState copyWith({
    MealPlanListStatus? status,
    MealPlanList? mealPlanListData,
    String? errorMessage,
    DateTime? lastFetched,
    bool? clearError,
  }) {
    return MealPlanListState(
      status: status ?? this.status,
      mealPlanListData: mealPlanListData ?? this.mealPlanListData,
      errorMessage:
          clearError == true ? null : (errorMessage ?? this.errorMessage),
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }

  @override
  String toString() {
    return 'MealPlanListState(status: $status, currentPlanId: ${mealPlanListData.currentMealPlan?.mealPlanId}, allPlansCount: ${mealPlanListData.allMealPlans.length}, error: $errorMessage, lastFetched: $lastFetched)';
  }
}

// --- Provider Definition ---
final mealPlanListProvider =
    StateNotifierProvider<MealPlanListNotifier, MealPlanListState>((ref) {
  final isar = ref.watch(isarProvider);
  final apiService = ref.watch(api_service.apiServiceProvider);
  return MealPlanListNotifier(isar, apiService, ref);
});

// --- Notifier Implementation ---
class MealPlanListNotifier extends StateNotifier<MealPlanListState> {
  final Isar _isar;
  final api_service.ApiService _apiService;
  final Ref _ref; // To read other providers if needed, e.g., user ID

  MealPlanListNotifier(this._isar, this._apiService, this._ref)
      : super(MealPlanListState()) {
    fetchAllMealPlans(); // Initial fetch
  }

  Future<void> fetchAllMealPlans({bool forceRefresh = false}) async {
    if (!mounted) return;
    safePrint(
        "[MealPlanListNotifier] Fetching all meal plans (forceRefresh: $forceRefresh)...");
    state =
        state.copyWith(status: MealPlanListStatus.loading, clearError: true);

    try {
      // Attempt to load from cache first
      final String? userId = await _apiService
          .getUserId(); // Assuming a method to get current user ID
      if (userId == null) {
        throw Exception("User ID not available. Cannot fetch meal plans.");
      }

      MealPlanList? cachedList;
      if (!forceRefresh) {
        final mealPlanListCache = await _isar.mealPlanListCaches
            .filter()
            .userIdEqualTo(userId)
            .findFirst();
        if (mealPlanListCache != null) {
          cachedList = await mealPlanListCache.toDomain(_isar);
          if (mounted) {
            state = state.copyWith(
              status: MealPlanListStatus
                  .loaded, // Consider this loaded_offline if we distinguish
              mealPlanListData: cachedList,
              lastFetched:
                  DateTime.now().toUtc(), // Or a cached timestamp if available
            );
            safePrint(
                "[MealPlanListNotifier] Loaded meal plans from cache. Count: ${cachedList.allMealPlans.length}");
          }
        }
      }

      // Fetch from API
      // The ApiService's fetchAllMealPlansForUser should handle its own caching/network logic
      // and return a list of Amplify MealPlan models.
      final List<MealPlan> fetchedAmplifyPlans = await _apiService
          .fetchAllMealPlansForUser(forceRefresh: forceRefresh);
      final String? currentPlanId = await _apiService.getChosenPlanId();

      final MealPlanList domainList = MealPlanList.fromAmplifyModels(
        fetchedAmplifyPlans,
        currentMealPlanId: currentPlanId,
        determineCurrentByStatus: true, // Default behavior from model
      );

      if (mounted) {
        state = state.copyWith(
          status: MealPlanListStatus.loaded,
          mealPlanListData: domainList,
          lastFetched: DateTime.now().toUtc(),
        );
        safePrint(
            "[MealPlanListNotifier] Successfully fetched/updated meal plans from API. Count: ${domainList.allMealPlans.length}, Current: ${domainList.currentMealPlan?.mealPlanId}");

        // Update cache
        await _updateCache(domainList, userId);
      }
    } on api_service.NetworkException catch (e) {
      safePrint("[MealPlanListNotifier] NetworkException: ${e.message}");
      if (mounted) {
        if (state.mealPlanListData.allMealPlans.isNotEmpty) {
          state = state.copyWith(
            status: MealPlanListStatus.loaded, // Effectively loaded_offline
            errorMessage:
                "Network error. Displaying cached plans. ${e.message}",
          );
        } else {
          state = state.copyWith(
            status: MealPlanListStatus.error,
            errorMessage:
                "Network error. Could not load meal plans. ${e.message}",
          );
        }
      }
    } on Exception catch (e, stackTrace) {
      safePrint(
          "[MealPlanListNotifier] Error during fetchAllMealPlans: $e\n$stackTrace");
      if (mounted) {
        state = state.copyWith(
          status: MealPlanListStatus.error,
          errorMessage: "An error occurred while fetching meal plans: $e",
        );
      }
    }
  }

  Future<void> _updateCache(MealPlanList domainList, String userId) async {
    try {
      final cacheData = MealPlanListCache.fromDomain(domainList, userId);
      await _isar.writeTxn(() async {
        // Save individual MealPlans to their cache first
        for (var plan in domainList.allMealPlans) {
          final planCache = MealPlanCache.fromMealPlan(
              plan); // Assuming MealPlanCache has this
          await _isar.mealPlanCaches.put(planCache);
        }
        // Save the list cache
        await _isar.mealPlanListCaches.put(cacheData);
      });
      safePrint(
          "[MealPlanListNotifier] Meal plan list and individual plans cached successfully for user $userId.");
    } catch (e) {
      safePrint("[MealPlanListNotifier] Error updating cache: $e");
      // Non-fatal, data is still in memory state
    }
  }

  // Method to set a new current meal plan
  Future<void> setCurrentMealPlan(String mealPlanId) async {
    if (!mounted) return;
    safePrint(
        "[MealPlanListNotifier] Attempting to set current meal plan to $mealPlanId");

    final currentList = state.mealPlanListData;
    final newCurrentPlan = currentList.allMealPlans
        .firstWhereOrNull((mp) => mp.mealPlanId == mealPlanId);

    if (newCurrentPlan != null) {
      // Update chosen plan ID via ApiService (which should handle persistence)
      try {
        final success = await _apiService.setChosenPlanId(mealPlanId);
        if (!success) {
          throw Exception("ApiService failed to set chosen plan ID.");
        }

        final updatedList =
            currentList.copyWith(currentMealPlan: newCurrentPlan);
        if (mounted) {
          state = state.copyWith(
              mealPlanListData: updatedList, status: MealPlanListStatus.loaded);
          safePrint(
              "[MealPlanListNotifier] Current meal plan set to ${newCurrentPlan.mealPlanId}");

          // Update the cache with the new current meal plan ID
          final String? userId = await _apiService.getUserId();
          if (userId != null) {
            await _updateCache(updatedList, userId);
          }
        }
      } catch (e) {
        safePrint("[MealPlanListNotifier] Error setting current meal plan: $e");
        if (mounted) {
          state = state.copyWith(
            status: MealPlanListStatus
                .error, // Or keep previous status if preferred
            errorMessage: "Failed to set new current meal plan: $e",
          );
        }
      }
    } else {
      safePrint(
          "[MealPlanListNotifier] Meal plan with ID $mealPlanId not found in the list.");
      if (mounted) {
        state = state.copyWith(
          errorMessage:
              "Could not find the selected meal plan in the local list.",
          // status: MealPlanListStatus.error, // Optional: set an error status
        );
      }
    }
  }

  // Method to add a new meal plan (e.g., after generation)
  // This assumes the newMealPlan is an Amplify Model
  void addMealPlan(MealPlan newMealPlan) {
    if (!mounted) return;
    final updatedAllMealPlans =
        List<MealPlan>.from(state.mealPlanListData.allMealPlans)
          ..add(newMealPlan);
    final updatedList =
        state.mealPlanListData.copyWith(allMealPlans: updatedAllMealPlans);

    // Potentially set as current if no other current plan or based on some logic
    // For now, just adds to the list. Setting current would be a separate action.

    state = state.copyWith(mealPlanListData: updatedList);
    safePrint(
        "[MealPlanListNotifier] Added new meal plan: ${newMealPlan.mealPlanId}");

    // Persist this change (e.g., by re-saving the whole list or adding to cache)
    _apiService.getUserId().then((userId) {
      if (userId != null) {
        _updateCache(state.mealPlanListData, userId);
      }
    });
  }

  // Method to remove a meal plan
  Future<void> removeMealPlan(String mealPlanId) async {
    if (!mounted) return;
    safePrint(
        "[MealPlanListNotifier] Attempting to remove meal plan: $mealPlanId");

    try {
      // Call ApiService to delete from backend and local Amplify cache
      await _apiService.deleteMealPlan(mealPlanId);

      final updatedAllMealPlans = state.mealPlanListData.allMealPlans
          .where((mp) => mp.mealPlanId != mealPlanId)
          .toList();

      MealPlan? newCurrentPlan = state.mealPlanListData.currentMealPlan;
      if (newCurrentPlan?.mealPlanId == mealPlanId) {
        // If the deleted plan was current, clear current or pick another
        // For simplicity, clearing it. Could try to pick another active one.
        newCurrentPlan = null;
        // Also clear it from persistent storage if necessary
        await _apiService.clearChosenPlanId();
      }

      final updatedList = state.mealPlanListData.copyWith(
        allMealPlans: updatedAllMealPlans,
        currentMealPlan: newCurrentPlan,
      );

      if (mounted) {
        state = state.copyWith(
            mealPlanListData: updatedList, status: MealPlanListStatus.loaded);
        safePrint("[MealPlanListNotifier] Removed meal plan: $mealPlanId");

        final String? userId = await _apiService.getUserId();
        if (userId != null) {
          await _updateCache(updatedList, userId);
          // Also remove the individual MealPlanCache entry
          await _isar.writeTxn(() async {
            await _isar.mealPlanCaches
                .filter()
                .mealPlanIdEqualTo(mealPlanId)
                .deleteAll();
          });
        }
      }
    } catch (e) {
      safePrint(
          "[MealPlanListNotifier] Error removing meal plan $mealPlanId: $e");
      if (mounted) {
        state = state.copyWith(
          errorMessage: "Failed to remove meal plan: $e",
          // status: MealPlanListStatus.error, // Optional
        );
      }
    }
  }

  // Consider adding a refresh method that simply calls fetchAllMealPlans(forceRefresh: true)
  Future<void> refreshMealPlans() async {
    await fetchAllMealPlans(forceRefresh: true);
  }
}

// Helper to get MealNameEnum from string, returning null if not found
// Potentially move to a utility file if used elsewhere
MealNameEnum? mealNameFromString(String name) {
  try {
    return MealNameEnum.values.byName(name);
  } catch (_) {
    return null; // Not found
  }
}

extension MealPlanListCacheIsarQueries on IsarCollection<MealPlanListCache> {
  Future<MealPlanListCache?> getByUserId(String userId) {
    return filter().userIdEqualTo(userId).findFirst();
  }
}

// Extension for MealPlanCache might be in its own model file or here if closely tied
// This assumes MealPlanCache has a 'mealPlanId' field that is indexed.
extension MealPlanCacheIsarQueries on IsarCollection<MealPlanCache> {
  Future<MealPlanCache?> getByMealPlanId(String mealPlanId) {
    return filter().mealPlanIdEqualTo(mealPlanId).findFirst();
  }
}

// Note: Ensure MealPlanCache.fromMealPlan(MealPlan plan) exists or is implemented.
// Example:
// class MealPlanCache {
//   // ... other fields
//   late String mealPlanId;
//   // ... other fields
//
//   MealPlanCache(); // Isar needs a default constructor
//
//   factory MealPlanCache.fromMealPlan(MealPlan plan) {
//     // Logic to map MealPlan (Amplify) to MealPlanCache (Isar)
//     // This is crucial and depends on your MealPlanCache definition.
//     // For example:
//     final cache = MealPlanCache();
//     cache.mealPlanId = plan.mealPlanId;
//     // ... map all other necessary fields ...
//     // You'll need to serialize complex objects like DailyPlanData into simpler forms or related Isar objects.
//     // For simplicity, this example is minimal. A full implementation would be required.
//     return cache;
//   }
//
//   MealPlan toMealPlan() {
//    // Logic to map MealPlanCache (Isar) back to MealPlan (Amplify)
//    // This is also crucial.
//    // For example:
//    // return MealPlan(id: this.id, mealPlanId: this.mealPlanId, ...);
//     throw UnimplementedError("toMealPlan not implemented in placeholder");
//   }
// }
