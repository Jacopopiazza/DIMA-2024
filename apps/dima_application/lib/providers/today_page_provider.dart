import 'dart:async'; // For StreamSubscription if using connectivity listener

import "package:amplify_flutter/amplify_flutter.dart"; // For Amplify safePrint
import 'package:connectivity_plus/connectivity_plus.dart'; // For network connectivity
// Import Domain/Amplify Models (assuming ApiService returns these)
// Using the domain models directly as specified in the original snippet
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
// Import Isar Models (needed for DailyCompletion and ActivePlanCache)
import 'package:dima_application/models/ActivePlanCache/active_plan_cache.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
// Import Providers and Services
import 'package:dima_application/providers/isar_provider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
// **Import MealPlansService for real meal plan data**
import 'package:dima_application/services/meal_plans_service.dart';
// Riverpod and Isar
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:isar/isar.dart';

// --- Data Status Enum ---
/// Represents the loading status of data, including offline states
enum DataStatus {
  initial,
  loading,
  loadedOnline, // Fresh data from API or valid cache
  loadedOffline, // Stale data from cache after network failure
  errorNoPlan, // Server confirmed user has no active plan
  errorNetwork, // Network/API error, no cache available
  errorNetworkWithCache, // Network error but showing cached data
  errorInvalidPlanId, // Invalid plan ID
  errorOther // Unexpected error
}

// --- State Definition ---
/// State class for the Today Page using Domain models and DailyCompletion object
class TodayPageState {
  final DataStatus status;
  final List<Meal>? todaysMeals; // Domain model
  final DailyCompletion? dailyCompletion; // Isar model
  final Macros consumedMacros; // Domain model
  final String? errorMessage;
  final DateTime? planLastFetched; // When the plan data was obtained (UTC)
  final bool isInitialLoad;
  final String? mealPlanId; // ID of the fetch meal plan

  TodayPageState({
    this.status = DataStatus.initial,
    this.todaysMeals,
    this.dailyCompletion,
    Macros? consumedMacros,
    this.errorMessage,
    this.planLastFetched,
    this.isInitialLoad = true,
    this.mealPlanId,
  }) : consumedMacros = consumedMacros ??
            Macros(
                calories: 0,
                proteins: 0,
                carbohydrates: 0,
                fats: 0); // Initialize domain Macros

  TodayPageState copyWith({
    DataStatus? status,
    List<Meal>? todaysMeals, // Domain model
    DailyCompletion? dailyCompletion,
    bool? clearDailyCompletion,
    Macros? consumedMacros, // Domain model
    String? errorMessage,
    DateTime? planLastFetched,
    bool? clearError,
    bool? clearTodaysMeals,
    bool? isInitialLoad,
    String? mealPlanId,
  }) {
    // Clear meals if requested or if specifically null is passed
    final List<Meal>? finalTodaysMeals =
        clearTodaysMeals == true ? null : (todaysMeals ?? this.todaysMeals);

    // Clear completion if requested or if specifically null is passed
    final DailyCompletion? finalDailyCompletion =
        clearDailyCompletion == true ? null : dailyCompletion;

    // Clear error if requested
    final String? finalErrorMessage =
        clearError == true ? null : (errorMessage ?? this.errorMessage);

    // Handle consumed macros update or default
    final Macros finalConsumedMacros = consumedMacros ?? this.consumedMacros;

    return TodayPageState(
      status: status ?? this.status,
      todaysMeals: finalTodaysMeals,
      dailyCompletion: finalDailyCompletion,
      consumedMacros: finalConsumedMacros,
      errorMessage: finalErrorMessage,
      planLastFetched: planLastFetched ?? this.planLastFetched,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
      mealPlanId: mealPlanId ?? this.mealPlanId,
    );
  }

  bool isMealCompleted(MealNameEnum mealName) {
    // Use recipeName as the identifier assumed to be stored
    return dailyCompletion?.completedMealNames.contains(mealName) ?? false;
  }

  @override
  String toString() {
    final mealsInfo =
        todaysMeals != null ? '${todaysMeals!.length} meals' : 'null';
    final completionInfo = dailyCompletion != null
        ? '${dailyCompletion!.completedMealNames.length} completed'
        : 'null';
    // Format planLastFetched if not null, otherwise show N/A
    final lastFetchedInfo = planLastFetched != null
        ? DateFormat.yMd()
            .add_Hms()
            .format(planLastFetched!.toLocal()) // Display in local time
        : 'N/A';
    return 'TodayPageState(status: $status, isInitial: $isInitialLoad, mealPlanId: $mealPlanId, todaysMeals: $mealsInfo, completion: $completionInfo, consumed: ${consumedMacros.calories.round()} kCal, lastFetched: $lastFetchedInfo, error: $errorMessage)';
  }
}

// --- Simplified Provider Definition ---
final todayPageProvider =
    StateNotifierProvider<TodayPageNotifier, TodayPageState>((ref) {
  final isar = ref.watch(isarProvider);
  final mealPlansService = MealPlansService(isar: isar);
  final notifier = TodayPageNotifier(isar, mealPlansService, ref);

  // Watch for changes in the active meal plan ID specifically
  ref.listen(activeMealPlanIdProvider, (previous, next) {
    if (!notifier.mounted) return;
    safePrint(
        "[TodayPageProvider] Active plan ID listener triggered: $previous -> $next (loading: ${notifier.state.status == DataStatus.loading})");
    if (previous != next && notifier.state.status != DataStatus.loading) {
      safePrint(
          "[TodayPageProvider] Active meal plan changed from $previous to $next, refreshing...");
      notifier.refreshTodayData();
    }
  });

  // ADDITIONAL: Watch for meal plans list changes to catch deletions
  ref.listen(mealPlansProvider, (previous, next) {
    if (!notifier.mounted) return;
    // Only trigger if we currently have an active plan loaded
    if (notifier.state.mealPlanId != null &&
        notifier.state.status != DataStatus.loading) {
      next.when(
        data: (currentPlans) {
          // Check if our current active plan still exists in the list
          final currentActivePlanId = notifier.state.mealPlanId;
          final planStillExists = currentPlans
              .any((plan) => plan.mealPlanId == currentActivePlanId);

          if (!planStillExists) {
            safePrint(
                "[TodayPageProvider] Current active plan ($currentActivePlanId) no longer exists in plans list, refreshing...");
            notifier.refreshTodayData();
          }
        },
        loading: () {
          // Don't trigger on loading states
        },
        error: (error, stack) {
          // Don't trigger on error states
        },
      );
    }
  });

  return notifier;
});

// --- Notifier Implementation ---
class TodayPageNotifier extends StateNotifier<TodayPageState> {
  final Isar _isar;
  final MealPlansService _mealPlansService; // Use the injected MealPlansService
  late final StateNotifierProviderRef<TodayPageNotifier, TodayPageState> _ref;

  TodayPageNotifier(this._isar, this._mealPlansService, this._ref)
      : super(TodayPageState()) {
    _loadUserPlanAndData();
  }

  /// Checks if device has internet connectivity
  Future<bool> _hasNetworkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasConnection =
          connectivityResult.contains(ConnectivityResult.mobile) ||
              connectivityResult.contains(ConnectivityResult.wifi) ||
              connectivityResult.contains(ConnectivityResult.ethernet);
      safePrint(
          "[TodayPageNotifier] Network connectivity: $hasConnection ($connectivityResult)");
      return hasConnection;
    } catch (e) {
      safePrint("[TodayPageNotifier] Error checking connectivity: $e");
      // Assume we have connection if we can't check
      return true;
    }
  }

  /// Gets the current user ID (simplified - you might want to get this from auth)
  String? _getCurrentUserId() {
    // This is a placeholder - replace with actual user ID from your auth system
    return "current_user"; // You should get this from Amplify auth or wherever you store user info
  }

  /// Gets cached active plan data from Isar
  Future<ActivePlanCache?> _getCachedActivePlan() async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) return null;

      final cached = await _isar.activePlanCaches
          .where()
          .userIdEqualTo(userId)
          .findFirst();

      safePrint("[TodayPageNotifier] Cached active plan: $cached");
      return cached;
    } catch (e) {
      safePrint("[TodayPageNotifier] Error getting cached active plan: $e");
      return null;
    }
  }

  /// Caches the active plan state (or lack thereof) to Isar
  Future<void> _cacheActivePlan(String? activePlanId,
      {required bool confirmedFromServer}) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) return;

      final ActivePlanCache cacheEntry;
      if (activePlanId != null) {
        cacheEntry = ActivePlanCache.confirmedActivePlan(
          userId: userId,
          activeMealPlanId: activePlanId,
        );
      } else {
        cacheEntry = ActivePlanCache.confirmedNoPlan(
          userId: userId,
        );
      }

      await _isar.writeTxn(() async {
        // Remove old cache entries for this user
        await _isar.activePlanCaches.where().userIdEqualTo(userId).deleteAll();
        // Add new cache entry
        await _isar.activePlanCaches.put(cacheEntry);
      });

      safePrint("[TodayPageNotifier] Cached active plan state: $cacheEntry");
    } catch (e) {
      safePrint("[TodayPageNotifier] Error caching active plan: $e");
    }
  }

  /// Smart network-aware active meal plan ID detection
  /// Returns a tuple of (activePlanId, wasFromCache, networkError)
  Future<(String?, bool, bool)> _getActiveMealPlanIdSmart() async {
    safePrint("[TodayPageNotifier] Smart active plan ID detection starting...");

    // 1. First check network connectivity
    final hasNetwork = await _hasNetworkConnection();

    if (!hasNetwork) {
      safePrint("[TodayPageNotifier] No network - checking cache...");

      // Check our local cache
      final cached = await _getCachedActivePlan();
      if (cached != null && cached.isUsable) {
        safePrint(
            "[TodayPageNotifier] Using cached active plan: ${cached.activeMealPlanId}");
        return (
          cached.activeMealPlanId,
          true,
          true
        ); // fromCache=true, networkError=true
      }

      safePrint("[TodayPageNotifier] No network and no usable cache");
      return (null, false, true); // No plan, not from cache, network error
    }

    // 2. We have network - try to get fresh data from provider
    safePrint("[TodayPageNotifier] Network available - getting fresh data...");

    // Try provider first (might have fresh data)
    final activePlanId = _ref.read(activeMealPlanIdProvider);
    if (activePlanId != null) {
      safePrint(
          "[TodayPageNotifier] Got active plan from provider: $activePlanId");
      await _cacheActivePlan(activePlanId, confirmedFromServer: true);
      return (activePlanId, false, false); // Fresh data
    }

    // Try meal plans provider
    final mealPlansAsync = _ref.read(mealPlansProvider);
    final currentActivePlanId = mealPlansAsync.when(
      data: (plans) =>
          _ref.read(mealPlansProvider.notifier).cachedActiveMealPlanId,
      loading: () => null,
      error: (error, stack) => null,
    );

    if (currentActivePlanId != null) {
      safePrint(
          "[TodayPageNotifier] Got active plan from meal plans cache: $currentActivePlanId");
      await _cacheActivePlan(currentActivePlanId, confirmedFromServer: true);
      return (currentActivePlanId, false, false); // Fresh data
    }

    // 3. Need to fetch from server
    try {
      safePrint("[TodayPageNotifier] Fetching fresh meal plans...");
      await _ref.read(mealPlansProvider.notifier).listMyMealPlans();
      final freshActivePlanId =
          _ref.read(mealPlansProvider.notifier).cachedActiveMealPlanId;

      // Cache the result (even if null - server confirmed no active plan)
      await _cacheActivePlan(freshActivePlanId, confirmedFromServer: true);

      safePrint("[TodayPageNotifier] Fresh active plan ID: $freshActivePlanId");
      return (freshActivePlanId, false, false); // Fresh data
    } catch (e) {
      safePrint("[TodayPageNotifier] Network request failed: $e");

      // Network request failed - try cache as fallback
      final cached = await _getCachedActivePlan();
      if (cached != null && cached.isUsable) {
        safePrint(
            "[TodayPageNotifier] Network failed, using cached: ${cached.activeMealPlanId}");
        return (
          cached.activeMealPlanId,
          true,
          true
        ); // fromCache=true, networkError=true
      }

      safePrint("[TodayPageNotifier] Network failed and no usable cache");
      return (null, false, true); // No plan, not from cache, network error
    }
  }

  /// Loads the user's active meal plan and associated data (today's meals, completion status).
  /// Uses ApiService for fetching the MealPlan, handling network/cache logic internally.
  Future<void> _loadUserPlanAndData({bool forceRefresh = false}) async {
    if (!mounted) return;
    safePrint(
        "[TodayPageNotifier] Loading user plan and data (forceRefresh: $forceRefresh, isInitialLoad: ${state.isInitialLoad})...");
    final bool stillInitialLoad = state.isInitialLoad;

    // Set loading state, potentially keeping old data visible unless it's the first load
    state = state.copyWith(
      status: DataStatus.loading,
      clearError: true, // Clear previous errors
      // Keep stale data visible during refresh unless initial load
      todaysMeals: stillInitialLoad ? null : state.todaysMeals,
      dailyCompletion: stillInitialLoad ? null : state.dailyCompletion,
      consumedMacros: stillInitialLoad
          ? Macros(
              calories: 0,
              proteins: 0,
              carbohydrates: 0,
              fats: 0) // Reset if initial
          : state.consumedMacros,
      planLastFetched: stillInitialLoad ? null : state.planLastFetched,
      isInitialLoad: stillInitialLoad, // Preserve flag during load
      mealPlanId: stillInitialLoad ? null : state.mealPlanId,
    );

    String? chosenPlanId;
    MealPlan? mealPlan; // Domain model (will hold fresh or stale data)
    DailyCompletion? todaysCompletionRecord;
    DataStatus finalStatus = DataStatus.errorOther; // Default status
    String? errorMessage;
    DateTime? planFetchTime; // UTC time when plan data was obtained

    try {
      // 1. Smart active plan ID detection with network awareness
      final (activePlanId, wasFromCache, hasNetworkError) =
          await _getActiveMealPlanIdSmart();
      chosenPlanId = activePlanId;

      if (chosenPlanId == null || chosenPlanId.isEmpty) {
        safePrint(
            "[TodayPageNotifier] No active meal plan ID found. FromCache: $wasFromCache, NetworkError: $hasNetworkError");
        if (!mounted) return;

        // Determine appropriate error state and message
        DataStatus errorStatus;
        String errorMsg;

        if (hasNetworkError && !wasFromCache) {
          // Network is down and no cache - this is a network error, not "no plan"
          errorStatus = DataStatus.errorNetwork;
          errorMsg =
              "Unable to connect to server. Please check your internet connection.";
        } else if (hasNetworkError && wasFromCache) {
          // This case shouldn't happen (if wasFromCache=true, activePlanId shouldn't be null)
          // But handle it just in case
          errorStatus = DataStatus.errorNetwork;
          errorMsg = "Connection failed. Unable to verify meal plan status.";
        } else {
          // Network is fine, server confirmed no active plan
          errorStatus = DataStatus.errorNoPlan;
          errorMsg = "No meal plan selected. Please choose one in settings.";
        }

        state = state.copyWith(
          status: errorStatus,
          clearTodaysMeals: true,
          clearDailyCompletion: true,
          consumedMacros: Macros(
              calories: 0, proteins: 0, carbohydrates: 0, fats: 0), // Reset
          planLastFetched: null,
          errorMessage: errorMsg,
          isInitialLoad: false, // Load attempt finished
          mealPlanId: null, // Clear plan ID
        );
        return;
      }

      // We have an active plan ID - determine if we should show cached data indicator
      if (wasFromCache && hasNetworkError) {
        safePrint(
            "[TodayPageNotifier] Using cached active plan due to network issues: $chosenPlanId");
      }
      safePrint(
          "[TodayPageNotifier] User has plan ID: $chosenPlanId. Fetching via MealPlansService...");

      // 2. Fetch Meal Plan using working getMealPlanById (but simplified)
      // Let's go back to using getMealPlanById but with better error handling
      try {
        safePrint(
            "[TodayPageNotifier] Fetching meal plan by ID: $chosenPlanId");
        mealPlan = await _mealPlansService.getMealPlanById(chosenPlanId);

        if (mealPlan == null) {
          throw Exception("Meal plan not found or returned null");
        }

        // SUCCESS: Data is fresh from the network (or cached if network issues)
        finalStatus = (wasFromCache && hasNetworkError)
            ? DataStatus.errorNetworkWithCache
            : DataStatus.loadedOnline;
        // Try to get a meaningful timestamp (e.g., when it was last updated on backend)
        // Fallback to now if updatedAt is null
        planFetchTime =
            mealPlan.updatedAt?.getDateTimeInUtc() ?? DateTime.now().toUtc();
        safePrint(
            "[TodayPageNotifier] MealPlansService success using listMyMealPlans. Status: $finalStatus. Plan Updated/Fetched At (UTC): $planFetchTime");
      } catch (e) {
        // Handle any errors from MealPlansService
        safePrint("[TodayPageNotifier] MealPlansService error: $e");

        finalStatus = DataStatus.errorNetwork;
        errorMessage = "Failed to load meal plan: $e";
        planFetchTime = null;
      }
      // No need to catch generic Exception here if ApiService wraps errors well

      if (finalStatus == DataStatus.errorNetwork ||
          finalStatus == DataStatus.errorOther ||
          finalStatus == DataStatus.errorNoPlan) {
        // Determine the specific error message
        String displayErrorMessage =
            errorMessage ?? "An error occurred while loading data.";
        // *** UPDATE THIS SPECIFIC CONDITION'S MESSAGE ***
        if (finalStatus == DataStatus.errorNetwork &&
            state.todaysMeals != null) {
          // Network failed, but we ARE showing previous data
          displayErrorMessage = "Refresh failed. Displaying previous data.";
        } else if (finalStatus ==
            DataStatus.errorNetwork /* && state.todaysMeals == null */) {
          // Network failed, AND we have NO previous data (CacheMiss likely led here too)
          // Keep the original message or make it clearer
          displayErrorMessage = "Network error. No offline data available.";
        }

        // Update state with the error, preserving existing data
        if (mounted) {
          safePrint(
              "[TodayPageNotifier] Updating state for ERROR ($finalStatus), preserving existing data via copyWith defaults.");
          state = state.copyWith(
            status: finalStatus,
            errorMessage: displayErrorMessage,
            planLastFetched: null, // Set plan fetch time to null as it failed
            isInitialLoad: false,
            mealPlanId: null, // Clear plan ID
          );
          safePrint("[TodayPageNotifier] Error State Set: $state");
        }
        return; // IMPORTANT: Exit the function here after setting error state
      }

      // 3. Process the loaded MealPlan (if successful OR stale data was provided)
      if (mealPlan != null) {
        // Use the domain model `mealPlan.dailyPlan`
        final todaysMeals =
            _getMealsForToday(mealPlan.dailyPlan); // Domain model Meal list

        if (todaysMeals == null || todaysMeals.isEmpty) {
          safePrint(
              "[TodayPageNotifier] No meals found for today (Plan ID: $chosenPlanId).");
          if (!mounted) return;
          // Keep status (loaded_online or loaded_offline) but indicate no meals
          state = state.copyWith(
            status: finalStatus, // Preserve loaded status
            clearTodaysMeals: true,
            clearDailyCompletion: true,
            consumedMacros: Macros(
                calories: 0, proteins: 0, carbohydrates: 0, fats: 0), // Reset
            planLastFetched:
                planFetchTime, // Record when the plan *structure* was fetched/valid
            errorMessage: errorMessage ??
                "No meals scheduled for today.", // Keep offline msg or add specific one
            isInitialLoad: false, // Load attempt finished
            mealPlanId: chosenPlanId, // Clear plan ID
          );
          return;
        }
        safePrint(
            "[TodayPageNotifier] Found ${todaysMeals.length} meals for today. Loading completion...");

        // 4. Load Today's DailyCompletion record from Isar (local state, independent of plan fetch)

        final todayDateOnly = DailyCompletion.dateOnly(DateTime.now());
        safePrint(
            '[TodayPageNotifier] Looking for completition record for mealPlanId: $chosenPlanId & date: $todayDateOnly');

        todaysCompletionRecord = await _isar.dailyCompletions
            .where() // Use filter for potential optimization with index
            .planIdDateEqualTo(chosenPlanId, todayDateOnly)
            .findFirst();
        safePrint(
            "[TodayPageNotifier] Loaded completion record: ${todaysCompletionRecord?.completedMealNames ?? 'None'}");

        // 5. Calculate initial consumed macros based on loaded completion and today's meals
        final initialConsumed = _calculateConsumedMacros(
            todaysCompletionRecord, todaysMeals); // Uses domain models
        safePrint(
            "[TodayPageNotifier] Initial consumed macros: ${initialConsumed.calories.round()} kCal");

        // 6. Update state with final data
        if (!mounted) return;
        state = state.copyWith(
          status: finalStatus, // loaded_online or loaded_offline
          todaysMeals: todaysMeals, // Domain model list
          dailyCompletion: todaysCompletionRecord, // Isar model
          consumedMacros: initialConsumed, // Domain model
          planLastFetched: planFetchTime, // UTC timestamp
          errorMessage: errorMessage, // Keep potential offline message
          isInitialLoad: false, // Load attempt finished
          mealPlanId: chosenPlanId, // Set the plan ID
        );
        safePrint("[TodayPageNotifier] Load complete. Final State: $state");
      } else if (finalStatus != DataStatus.errorNetwork &&
          finalStatus != DataStatus.errorNoPlan) {
        // This case indicates an error occurred, but mealPlan ended up null unexpectedly.
        // Errors handled by specific catches should have already set the state.
        safePrint(
            "[TodayPageNotifier] Error: MealPlan is null despite not having explicit network/no-plan error status ($finalStatus).");
        // Update state to reflect the error if not already set
        if (mounted &&
            state.status != DataStatus.errorNetwork &&
            state.status != DataStatus.errorOther) {
          state = state.copyWith(
            status: DataStatus.errorOther,
            errorMessage: errorMessage ?? "Failed to load meal plan data.",
            clearTodaysMeals: true,
            clearDailyCompletion: true,
            consumedMacros:
                Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0),
            planLastFetched: null,
            isInitialLoad: false,
            mealPlanId: null, // Clear plan ID
          );
        }
      } // else: Error status was already set correctly by a catch block or no-plan condition.
    } catch (e, stackTrace) {
      // Catch-all for unexpected errors *outside* the ApiService calls or Isar reads
      safePrint(
          "[TodayPageNotifier] Unhandled Error during load: $e\n$stackTrace");
      if (mounted) {
        state = state.copyWith(
          status: DataStatus.errorOther,
          errorMessage: "An unexpected error occurred: ${e.toString()}",
          clearTodaysMeals: true,
          clearDailyCompletion: true,
          consumedMacros: Macros(
              calories: 0, proteins: 0, carbohydrates: 0, fats: 0), // Reset
          planLastFetched: null,
          isInitialLoad: false, // Load attempt finished
          mealPlanId: null, // Clear plan ID
        );
      }
    }
  }

  /// Refreshes data, forcing a network attempt via ApiService.
  Future<void> refreshData() async {
    safePrint("[TodayPageNotifier] Refresh triggered.");
    // Set isInitialLoad to false explicitly if needed, though loadUserPlanData handles it.
    // state = state.copyWith(isInitialLoad: false); // Optional: ensure refresh isn't treated as initial
    await _loadUserPlanAndData(forceRefresh: true);
  }

  /// Toggles the completion status of a specific meal. Persists locally to Isar.
  /// This logic remains primarily local Isar interaction.
  Future<void> toggleMealCompletion(
      MealNameEnum meal, String mealPlanId) async {
    // Ensure we have meals loaded before allowing toggling
    if (!mounted ||
        state.todaysMeals == null ||
        state.todaysMeals!.isEmpty || // Check if list is empty too
        state.status == DataStatus.loading) {
      safePrint(
          "[TodayPageNotifier] Skipping toggle meal (invalid state: ${state.status}, meals loaded: ${state.todaysMeals != null && state.todaysMeals!.isNotEmpty})");
      return;
    }

    final todayDateOnly = DailyCompletion.dateOnly(DateTime.now());
    // Get current completion or create a new one for today if null
    final DailyCompletion currentCompletion = state.dailyCompletion ??
        DailyCompletion.forDate(planId: mealPlanId, date: todayDateOnly);

    // Use a Set for efficient checking and manipulation
    final Set<MealNameEnum> updatedNamesSet =
        currentCompletion.completedMealNames.toSet();
    final bool wasCompleted = updatedNamesSet.contains(meal);

    if (wasCompleted) {
      updatedNamesSet.remove(meal);
      safePrint("[TodayPageNotifier] Marking '$meal' as incomplete.");
    } else {
      updatedNamesSet.add(meal);
      safePrint("[TodayPageNotifier] Marking '$meal' as complete.");
    }

    // Create the updated Isar object
    final updatedCompletion = DailyCompletion(
      planId: mealPlanId, // Use the active plan ID
      id: currentCompletion.id, // Preserve Isar ID if it exists for update
      date: todayDateOnly,
      latestUpdate: DateTime.now(), // Update timestamp
      completedMealNames:
          updatedNamesSet.toList(), // Convert back to list for storage
    );

    // Recalculate consumed macros using the updated completion status
    final newConsumed = _calculateConsumedMacros(
        updatedCompletion, state.todaysMeals); // Uses domain models

    // Update state optimistically
    state = state.copyWith(
      dailyCompletion: updatedCompletion, // Update the Isar model in state
      consumedMacros: newConsumed, // Update the domain model in state
      // Preserve other relevant state fields
      status: state.status,
      todaysMeals: state.todaysMeals,
      planLastFetched: state.planLastFetched,
      errorMessage: state.errorMessage,
      // Don't change isInitialLoad here
    );
    safePrint("[TodayPageNotifier] Optimistically updated state: $state");

    // Persist change to Isar asynchronously
    try {
      await _isar.writeTxn(() async {
        // `put` handles insert or update based on Isar ID (@Id)
        await _isar.dailyCompletions.put(updatedCompletion);
        safePrint(
            "[Isar] Saved DailyCompletion for $todayDateOnly: ${updatedCompletion.completedMealNames}");
      });
    } catch (e, stackTrace) {
      safePrint(
          "[TodayPageNotifier] Error saving completion to Isar: $e\n$stackTrace");
      // Consider implementing state reversal or showing a specific error message
      // For simplicity here, we just log the error.
      state = state.copyWith(
          errorMessage: "Error saving completion status. Please try again.");
    }
  }

  /// Calculates total consumed macros based on completed meals.
  /// Uses domain model Meal and Macros.
  Macros _calculateConsumedMacros(
      DailyCompletion? dailyCompletion, List<Meal>? todaysMeals) {
    if (dailyCompletion == null || todaysMeals == null || todaysMeals.isEmpty) {
      return Macros(
          calories: 0,
          proteins: 0,
          carbohydrates: 0,
          fats: 0); // Return default domain Macros
    }

    double calories = 0;
    double proteins = 0;
    double carbs = 0;
    double fats = 0;
    // Use a set for efficient lookup
    final completedNames = dailyCompletion.completedMealNames.toSet();

    for (var meal in todaysMeals) {
      // Iterate over domain model Meal list
      // IMPORTANT: Assumes `meal.recipeName` is the identifier stored in `completedMealNames`.
      // Adjust if a different identifier (like a unique meal ID) is used.
      if (completedNames.contains(meal.name)) {
        // Access the domain Macros object within the domain Meal object
        final macros =
            meal.totalMacros; // Meal.totalMacros is required, not nullable
        calories += macros.calories;
        proteins += macros.proteins;
        carbs += macros.carbohydrates;
        fats += macros.fats;
      }
    }
    // Return a new domain Macros object
    return Macros(
        calories: calories,
        proteins: proteins,
        carbohydrates: carbs,
        fats: fats);
  }

  /// Extracts the list of meals for the current day of the week from the domain DailyPlan.
  List<Meal>? _getMealsForToday(DailyPlanData? dailyPlan) {
    // Expects domain DailyPlan
    if (dailyPlan == null) {
      safePrint("[TodayPageNotifier] _getMealsForToday: dailyPlan is null.");
      return null;
    }
    // Use current system time to determine the weekday
    final String currentWeekday =
        DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    safePrint("[TodayPageNotifier] Getting meals for weekday: $currentWeekday");
    switch (currentWeekday) {
      case 'monday':
        return dailyPlan.monday;
      case 'tuesday':
        return dailyPlan.tuesday;
      case 'wednesday':
        return dailyPlan.wednesday;
      case 'thursday':
        return dailyPlan.thursday;
      case 'friday':
        return dailyPlan.friday;
      case 'saturday':
        return dailyPlan.saturday;
      case 'sunday':
        return dailyPlan.sunday;
      default:
        safePrint(
            "[TodayPageNotifier] Warning: Unknown weekday '$currentWeekday'.");
        return null; // Should not happen with DateFormat('EEEE')
    }
  }

  /// Public method to refresh the today page data
  /// This can be called when the active meal plan changes
  Future<void> refreshTodayData() async {
    safePrint("[TodayPageNotifier] Refreshing data due to external trigger...");
    if (!mounted) return;
    await _loadUserPlanAndData(forceRefresh: true);
  }

  @override
  void dispose() {
    if (!mounted) return;
    super.dispose();
  }
}
