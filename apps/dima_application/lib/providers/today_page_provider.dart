import 'dart:async'; // For StreamSubscription if using connectivity listener

// Import Domain/Amplify Models (assuming ApiService returns these)
// Using the domain models directly as specified in the original snippet
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

// Import Isar Models (needed for DailyCompletion)
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';

// Import Providers and Services
import 'package:dima_application/providers/isar_provider.dart';
// **Import the ApiService and its exceptions**
import 'package:dima_application/services/api_service.dart' as api_service;

// Riverpod and Isar
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart'; // For date formatting

import "package:amplify_flutter/amplify_flutter.dart"; // For Amplify safePrint

// --- Data Status Enum ---
/// Represents the loading status of data, including offline states
enum DataStatus {
  initial,
  loading,
  loadedOnline, // Fresh data from API or valid cache
  loadedOffline, // Stale data from cache after network failure
  errorNoPlan, // User has no active plan
  errorNetwork, // Network/API error, no cache available
  // 'error_cache_stale' isn't strictly needed if loaded_offline implies stale
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

  TodayPageState({
    this.status = DataStatus.initial,
    this.todaysMeals,
    this.dailyCompletion,
    Macros? consumedMacros,
    this.errorMessage,
    this.planLastFetched,
    this.isInitialLoad = true,
  }) : consumedMacros = consumedMacros ??
            Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0); // Initialize domain Macros

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
  }) {
    // Clear meals if requested or if specifically null is passed
    final List<Meal>? finalTodaysMeals = clearTodaysMeals == true
        ? null
        : (todaysMeals ?? this.todaysMeals);

    // Clear completion if requested or if specifically null is passed
    final DailyCompletion? finalDailyCompletion = clearDailyCompletion == true
        ? null
        : (dailyCompletion ?? this.dailyCompletion);

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
        ? DateFormat.yMd().add_Hms().format(planLastFetched!.toLocal()) // Display in local time
        : 'N/A';
    return 'TodayPageState(status: $status, isInitial: $isInitialLoad, todaysMeals: $mealsInfo, completion: $completionInfo, consumed: ${consumedMacros.calories.round()} kCal, lastFetched: $lastFetchedInfo, error: $errorMessage)';
  }
}

// --- Provider Definition ---
final todayPageProvider =
    StateNotifierProvider<TodayPageNotifier, TodayPageState>((ref) {
  final isar = ref.watch(isarProvider); // Assuming isarProvider provides Isar instance
  final apiService = ref.watch(api_service.apiServiceProvider); // Use the ApiService provider
  return TodayPageNotifier(isar, apiService);
});

// --- Notifier Implementation ---
class TodayPageNotifier extends StateNotifier<TodayPageState> {
  final Isar _isar;
  final api_service.ApiService _apiService; // Use the injected ApiService

  TodayPageNotifier(this._isar, this._apiService) : super(TodayPageState()) {
    _loadUserPlanAndData();
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
          ? Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0) // Reset if initial
          : state.consumedMacros,
      planLastFetched: stillInitialLoad ? null : state.planLastFetched,
      isInitialLoad: stillInitialLoad, // Preserve flag during load
    );

    String? chosenPlanId;
    MealPlan? mealPlan; // Domain model (will hold fresh or stale data)
    DailyCompletion? todaysCompletionRecord;
    DataStatus finalStatus = DataStatus.errorOther; // Default status
    String? errorMessage;
    DateTime? planFetchTime; // UTC time when plan data was obtained

    try {
      // 1. Get Chosen Plan ID using ApiService
      // This implicitly uses getMyUserDetails -> network/cache handled there
      chosenPlanId = await _apiService.getChosenPlanId();

      if (chosenPlanId == null || chosenPlanId.isEmpty) {
        safePrint("[TodayPageNotifier] No active meal plan ID found.");
        if (!mounted) return;
        state = state.copyWith(
          status: DataStatus.errorNoPlan,
          clearTodaysMeals: true,
          clearDailyCompletion: true,
          consumedMacros: Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0), // Reset
          planLastFetched: null,
          errorMessage: "No meal plan selected. Please choose one in settings.",
          isInitialLoad: false, // Load attempt finished
        );
        return;
      }
      safePrint("[TodayPageNotifier] User has plan ID: $chosenPlanId. Fetching via ApiService...");

      // 2. Fetch Meal Plan using ApiService
      // ApiService handles network request, cache fallback, and stale data logic
      try {
        mealPlan = await _apiService.fetchMealPlan(chosenPlanId, forceRefresh: forceRefresh);

        // SUCCESS: Data is fresh (from network or valid cache)
        finalStatus = DataStatus.loadedOnline;
        // Try to get a meaningful timestamp (e.g., when it was last updated on backend)
        // Fallback to now if updatedAt is null
        planFetchTime = mealPlan.updatedAt?.getDateTimeInUtc() ?? DateTime.now().toUtc();
        safePrint("[TodayPageNotifier] ApiService success. Status: $finalStatus. Plan Updated/Fetched At (UTC): $planFetchTime");

      } on api_service.CacheExpiredException catch (e) {
        safePrint("[TodayPageNotifier] ApiService CacheExpiredException: ${e.message}. Network failed, providing stale data.");

        // STALE DATA: Network failed, but ApiService provided stale cached data
        finalStatus = DataStatus.loadedOffline; // Indicate offline/stale data
        errorMessage = "Offline mode: Displaying previously saved plan.";
        mealPlan = e.staleData; // *** Use the stale data directly from the exception ***

        if (mealPlan != null) {
           // Try to get the timestamp from the stale data itself (e.g., when it was generated/updated)
           // If this isn't available/meaningful, we know it's old data anyway.
           planFetchTime = mealPlan.generatedAt?.getDateTimeInUtc() ?? mealPlan.updatedAt?.getDateTimeInUtc();
           safePrint("[TodayPageNotifier] Using stale plan. Stale Plan Updated/Generated At (UTC): $planFetchTime");
        } else {
           // This case *shouldn't* happen if CacheExpiredException has staleData, but handle defensively.
           safePrint("[TodayPageNotifier] Error: CacheExpiredException but staleData was null. Plan ID: $chosenPlanId");
           finalStatus = DataStatus.errorNetwork; // Fallback to network error
           errorMessage = "Failed to load plan: Network error and cache issue.";
           planFetchTime = null;
        }

      } on api_service.CacheMissException catch (e) {
         safePrint("[TodayPageNotifier] ApiService CacheMissException: ${e.message}. Network failed, no cache.");
         finalStatus = DataStatus.errorNetwork;
         errorMessage = "Failed to load plan: Network error and no offline data available.";
         planFetchTime = null;
      } on api_service.NetworkException catch (e) {
         // Includes SocketException, TimeoutException from ApiService
         safePrint("[TodayPageNotifier] ApiService NetworkException: ${e.message}.");
         finalStatus = DataStatus.errorNetwork;
         errorMessage = "Failed to load plan: Check network connection.";
         planFetchTime = null;
      } on api_service.ApiExceptionWrapper catch (e) {
         // GraphQL errors or other API issues from ApiService
         safePrint("[TodayPageNotifier] ApiService ApiExceptionWrapper: ${e.message}.");
         finalStatus = DataStatus.errorNetwork; // Treat as network/server issue
         errorMessage = "Failed to load plan: Server error (${e.errors?.first.message ?? 'details unavailable'}).";
         planFetchTime = null;
      } on api_service.OperationFailedException catch (e) {
         // Other failures reported by ApiService (e.g., mock data loading failed)
         safePrint("[TodayPageNotifier] ApiService OperationFailedException: ${e.message}.");
         finalStatus = DataStatus.errorOther;
         errorMessage = "Failed to process plan data: ${e.message}";
         planFetchTime = null;
      }
      // No need to catch generic Exception here if ApiService wraps errors well

      // 3. Process the loaded MealPlan (if successful OR stale data was provided)
      if (mealPlan != null) {
        // Use the domain model `mealPlan.dailyPlan`
        final todaysMeals = _getMealsForToday(mealPlan.dailyPlan); // Domain model Meal list

        if (todaysMeals == null || todaysMeals.isEmpty) {
          safePrint("[TodayPageNotifier] No meals found for today (Plan ID: $chosenPlanId).");
          if (!mounted) return;
          // Keep status (loaded_online or loaded_offline) but indicate no meals
          state = state.copyWith(
            status: finalStatus, // Preserve loaded status
            clearTodaysMeals: true,
            clearDailyCompletion: true,
            consumedMacros: Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0), // Reset
            planLastFetched: planFetchTime, // Record when the plan *structure* was fetched/valid
            errorMessage: errorMessage ?? "No meals scheduled for today.", // Keep offline msg or add specific one
            isInitialLoad: false, // Load attempt finished
          );
          return;
        }
        safePrint("[TodayPageNotifier] Found ${todaysMeals.length} meals for today. Loading completion...");

        // 4. Load Today's DailyCompletion record from Isar (local state, independent of plan fetch)
        final todayDateOnly = _dateOnly(DateTime.now());
        todaysCompletionRecord = await _isar.dailyCompletions
            .filter() // Use filter for potential optimization with index
            .dateEqualTo(todayDateOnly)
            .findFirst();
        safePrint("[TodayPageNotifier] Loaded completion record: ${todaysCompletionRecord?.completedMealNames ?? 'None'}");

        // 5. Calculate initial consumed macros based on loaded completion and today's meals
        final initialConsumed = _calculateConsumedMacros(todaysCompletionRecord, todaysMeals); // Uses domain models
        safePrint("[TodayPageNotifier] Initial consumed macros: ${initialConsumed.calories.round()} kCal");

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
        );
        safePrint("[TodayPageNotifier] Load complete. Final State: $state");

      } else if (finalStatus != DataStatus.errorNetwork && finalStatus != DataStatus.errorNoPlan ) {
         // This case indicates an error occurred, but mealPlan ended up null unexpectedly.
         // Errors handled by specific catches should have already set the state.
         safePrint("[TodayPageNotifier] Error: MealPlan is null despite not having explicit network/no-plan error status ($finalStatus).");
         // Update state to reflect the error if not already set
         if (mounted && state.status != DataStatus.errorNetwork && state.status != DataStatus.errorOther) {
            state = state.copyWith(
               status: DataStatus.errorOther,
               errorMessage: errorMessage ?? "Failed to load meal plan data.",
               clearTodaysMeals: true,
               clearDailyCompletion: true,
               consumedMacros: Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0),
               planLastFetched: null,
               isInitialLoad: false,
            );
         }
      } // else: Error status was already set correctly by a catch block or no-plan condition.

    } catch (e, stackTrace) {
      // Catch-all for unexpected errors *outside* the ApiService calls or Isar reads
      safePrint("[TodayPageNotifier] Unhandled Error during load: $e\n$stackTrace");
      if (mounted) {
        state = state.copyWith(
          status: DataStatus.errorOther,
          errorMessage: "An unexpected error occurred: ${e.toString()}",
          clearTodaysMeals: true,
          clearDailyCompletion: true,
          consumedMacros: Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0), // Reset
          planLastFetched: null,
          isInitialLoad: false, // Load attempt finished
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
  Future<void> toggleMealCompletion(MealNameEnum meal) async {
    // Ensure we have meals loaded before allowing toggling
    if (!mounted ||
        state.todaysMeals == null ||
        state.todaysMeals!.isEmpty || // Check if list is empty too
        state.status == DataStatus.loading) {
      safePrint(
          "[TodayPageNotifier] Skipping toggle meal (invalid state: ${state.status}, meals loaded: ${state.todaysMeals != null && state.todaysMeals!.isNotEmpty})");
      return;
    }
    safePrint("[TodayPageNotifier] Toggling completion for: $meal");

    final todayDateOnly = _dateOnly(DateTime.now());
    // Get current completion or create a new one for today if null
    final DailyCompletion currentCompletion =
        state.dailyCompletion ?? DailyCompletion.forDate(todayDateOnly);

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
      id: currentCompletion.id, // Preserve Isar ID if it exists for update
      date: todayDateOnly,
      completedMealNames: updatedNamesSet.toList(), // Convert back to list for storage
    );

    // Recalculate consumed macros using the updated completion status
    final newConsumed =
        _calculateConsumedMacros(updatedCompletion, state.todaysMeals); // Uses domain models

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
    if (dailyCompletion == null ||
        todaysMeals == null ||
        todaysMeals.isEmpty) {
      return Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0); // Return default domain Macros
    }

    double calories = 0;
    double proteins = 0;
    double carbs = 0;
    double fats = 0;
    // Use a set for efficient lookup
    final completedNames = dailyCompletion.completedMealNames.toSet();

    for (var meal in todaysMeals) { // Iterate over domain model Meal list
      // IMPORTANT: Assumes `meal.recipeName` is the identifier stored in `completedMealNames`.
      // Adjust if a different identifier (like a unique meal ID) is used.
      if (completedNames.contains(meal.name)) {
        // Access the domain Macros object within the domain Meal object
        final macros = meal.totalMacros; // Assuming Meal has a `Macros totalMacros` field
        if (macros != null) {
          calories += macros.calories;
          proteins += macros.proteins;
          carbs += macros.carbohydrates;
          fats += macros.fats;
        } else {
           safePrint("[TodayPageNotifier] Warning: Meal '${meal.recipeName}' is completed but has null macros.");
        }
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
  List<Meal>? _getMealsForToday(DailyPlanData? dailyPlan) { // Expects domain DailyPlan
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
         safePrint("[TodayPageNotifier] Warning: Unknown weekday '$currentWeekday'.");
         return null; // Should not happen with DateFormat('EEEE')
     }
  }

  /// Returns a DateTime object with time components set to zero (start of the day).
  DateTime _dateOnly(DateTime dt) {
    return DateTime.utc(dt.year, dt.month, dt.day); // Use UTC for consistency
  }

  @override
  void dispose() {
    safePrint("[TodayPageNotifier] Disposed");
    super.dispose();
  }
}

