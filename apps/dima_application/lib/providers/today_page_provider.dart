// lib/providers/today_page_provider.dart
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull method
import 'package:intl/intl.dart'; // For date formatting

import 'isar_provider.dart';
import 'package:dima_application/services/api_service.dart';

/// Represents the loading status of data
enum DataStatus { initial, loading, loaded, error }

/// State class for the Today Page
/// Contains all data needed to display the user's daily meal plan
class TodayPageState {
  /// Current status of data loading
  final DataStatus status;
  
  /// Whether the user has selected a meal plan
  final bool hasChosenPlan;
  
  /// Today's specific meal plan (null if not available or not loaded)
  final DailyPlan? dailyPlan;
  
  /// Map tracking which meals have been completed today
  /// Keys are meal names, values are completion status (true = completed)
  final Map<String, bool> mealCompletionStatus;
  
  /// Total macros consumed from completed meals
  final Macros consumedMacros;
  
  /// Error message if data loading failed
  final String? errorMessage;
  
  /// Flag to track initial loading state
  final bool isInitialLoad;

  /// Creates a new TodayPageState instance
  TodayPageState({
    this.status = DataStatus.initial,
    this.hasChosenPlan = false,
    this.dailyPlan,
    this.mealCompletionStatus = const {}, 
    Macros? consumedMacros,
    this.errorMessage,
    this.isInitialLoad = true,
  }) : consumedMacros = consumedMacros ?? Macros(); // Initialize with empty macros if null

  /// Creates a copy of this state with specified fields updated
  TodayPageState copyWith({
    DataStatus? status,
    bool? hasChosenPlan,
    DailyPlan? dailyPlan,
    Map<String, bool>? mealCompletionStatus,
    Macros? consumedMacros,
    String? errorMessage,
    bool? clearError,
    bool? clearDailyPlan,
    bool? isInitialLoad,
  }) {
    // Determine if dailyPlan should be cleared
    final bool shouldClearPlan = clearDailyPlan == true;
    final DailyPlan? finalDailyPlan = shouldClearPlan
        ? null
        : (dailyPlan ?? this.dailyPlan);

    return TodayPageState(
      status: status ?? this.status,
      hasChosenPlan: hasChosenPlan ?? this.hasChosenPlan,
      dailyPlan: finalDailyPlan,
      mealCompletionStatus: mealCompletionStatus ?? this.mealCompletionStatus,
      consumedMacros: consumedMacros ?? this.consumedMacros,
      errorMessage: clearError == true ? null : (errorMessage ?? this.errorMessage),
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
    );
  }

  @override
  String toString() {
    // Format daily plan info for debugging
    final planInfo = dailyPlan != null
        ? 'Plan(${dailyPlan!.weekday}, ${dailyPlan!.meals.length} meals)'
        : 'null';
    return 'TodayPageState(status: $status, isInitial: $isInitialLoad, hasPlan: $hasChosenPlan, dailyPlan: $planInfo, completed: $mealCompletionStatus, consumed: ${consumedMacros.calories.round()} kCal, error: $errorMessage)';
  }
}

/// Provider for the Today Page state
/// Manages meal plan data, completion status, and consumed macros
final todayPageProvider =
    StateNotifierProvider<TodayPageNotifier, TodayPageState>((ref) {
  final isar = ref.watch(isarProvider);
  final apiService = ref.watch(apiServiceProvider);
  return TodayPageNotifier(isar, apiService);
});

/// Notifier class that manages the Today Page state
class TodayPageNotifier extends StateNotifier<TodayPageState> {
  final Isar _isar;
  final ApiService _apiService;

  /// Creates a new TodayPageNotifier and immediately loads data
  TodayPageNotifier(this._isar, this._apiService) : super(TodayPageState()) {
    _loadUserPlanAndData(); // Initialize data when provider is created
  }

  /// Loads the user's meal plan and completion data
  /// 
  /// [forceRefresh] - If true, forces a refresh from the API instead of using cached data
  Future<void> _loadUserPlanAndData({bool forceRefresh = false}) async {
    if (!mounted) return;
    print(
        "[TodayPageNotifier] Loading user plan and data (isInitialLoad: ${state.isInitialLoad})...");
    final bool stillInitialLoad = state.isInitialLoad;

    // Set loading state while preserving existing data for smoother UX
    state = state.copyWith(
      status: DataStatus.loading,
      clearError: true, // Clear any previous errors
      // Keep potentially stale data while loading new data
      dailyPlan: state.dailyPlan,
      mealCompletionStatus: state.mealCompletionStatus,
      consumedMacros: state.consumedMacros,
      hasChosenPlan: state.hasChosenPlan,
      isInitialLoad: stillInitialLoad,
    );

    try {
      // 1. Check if user has a chosen meal plan
      final String? chosenPlanId = await _apiService.getChosenPlanId();

      if (chosenPlanId == null) {
        print("[TodayPageNotifier] No chosen plan found.");
        if (!mounted) return;
        
        // Update state to reflect no chosen plan
        state = state.copyWith(hasChosenPlan: false);
        
        // Update state to reflect no plan selected
        state = state.copyWith(
          status: DataStatus.loaded,
          hasChosenPlan: false,
          clearDailyPlan: true, // Clear the daily plan
          mealCompletionStatus: {},
          consumedMacros: Macros(), // Reset consumed macros
          isInitialLoad: false,
        );
        return;
      }

      print("[TodayPageNotifier] User has plan ID: $chosenPlanId. Fetching plan details...");
      
      // Mark that user has chosen a plan while keeping loading state
      if (!state.hasChosenPlan) {
        state = state.copyWith(
          hasChosenPlan: true,
          dailyPlan: state.dailyPlan,
          isInitialLoad: state.isInitialLoad,
        );
      }

      // 2. Fetch the full meal plan (API service handles caching in Isar)
      final MealPlan fullPlan = await _apiService.fetchMealPlan(
        chosenPlanId,
        forceRefresh: forceRefresh
      );

      // 3. Find today's specific plan from the full weekly plan
      final String currentWeekday =
          DateFormat('EEEE').format(DateTime.now()).toLowerCase();
      final DailyPlan? todaysPlan = fullPlan.dailyPlans.firstWhereOrNull(
        (dp) => dp.weekday.toLowerCase() == currentWeekday,
      );

      if (todaysPlan == null) {
        print("[TodayPageNotifier] No plan data found for today ($currentWeekday).");
        if (!mounted) return;
        
        // Plan exists but not for today's weekday
        state = state.copyWith(
          status: DataStatus.loaded,
          clearDailyPlan: true, // Clear the daily plan
          mealCompletionStatus: {},
          consumedMacros: Macros(),
          isInitialLoad: false,
        );
        return;
      }
      
      print("[TodayPageNotifier] Found plan for $currentWeekday. Loading completion status from Isar...");

      // 4. Load today's meal completion status from local database
      final todayDateOnly = DateTime(
        DateTime.now().year, 
        DateTime.now().month, 
        DateTime.now().day
      );
      
      final existingCompletion = await _isar.dailyCompletions
          .where()
          .dateEqualTo(todayDateOnly)
          .findFirst();

      // Convert list of completed meal names to a map for easier access
      final initialStatus = {
        for (var item in existingCompletion?.completedMealNames ?? [])
          item as String: true
      };
      
      print("[TodayPageNotifier] Loaded completion status: $initialStatus");

      // 5. Calculate initial consumed macros based on completed meals
      final initialConsumed =
          _calculateConsumedMacros(initialStatus, todaysPlan);
      
      print("[TodayPageNotifier] Initial consumed macros: ${initialConsumed.calories.round()} kCal");

      // 6. Update state with all loaded data
      if (!mounted) return;
      
      state = state.copyWith(
        status: DataStatus.loaded,
        dailyPlan: todaysPlan,
        mealCompletionStatus: initialStatus,
        consumedMacros: initialConsumed,
        isInitialLoad: false,
      );
      
      print("[TodayPageNotifier] Load complete. Final State: $state");
    } catch (e, stackTrace) {
      print("[TodayPageNotifier] Error during load/refresh: $e\n$stackTrace");
      
      if (mounted) {
        // Show error but preserve any existing data for better UX
        state = state.copyWith(
          status: DataStatus.error,
          errorMessage: "Failed to load data: ${e.toString()}",
          // Keep existing data
          dailyPlan: state.dailyPlan,
          mealCompletionStatus: state.mealCompletionStatus,
          consumedMacros: state.consumedMacros,
          hasChosenPlan: state.hasChosenPlan,
          isInitialLoad: false,
        );
      }
    }
  }

  /// Refreshes all data from source
  /// Used when user manually triggers refresh
  Future<void> refreshData() async {
    print("[TodayPageNotifier] Refresh triggered.");
    await _loadUserPlanAndData(forceRefresh: true);
  }

  /// Toggles the completion status of a specific meal
  /// Updates consumed macros and persists the change to database
  /// 
  /// [mealName] - The name of the meal to toggle
  Future<void> toggleMealCompletion(String mealName) async {
    // Validate we have necessary data before proceeding
    if (!mounted ||
        state.dailyPlan == null ||
        state.status == DataStatus.loading) return;
        
    print("[TodayPageNotifier] Toggling completion for: $mealName");

    // 1. Create updated state optimistically (before DB update)
    final currentStatus = Map<String, bool>.from(state.mealCompletionStatus);
    currentStatus[mealName] = !(currentStatus[mealName] ?? false); // Toggle status
    
    // Recalculate consumed macros based on new completion status
    final newConsumed = _calculateConsumedMacros(currentStatus, state.dailyPlan);

    // 2. Update state immediately for responsive UI
    state = state.copyWith(
      mealCompletionStatus: currentStatus,
      consumedMacros: newConsumed,
      dailyPlan: state.dailyPlan // Preserve existing dailyPlan
    );
    
    print("[TodayPageNotifier] Optimistically updated state: $state");

    // 3. Persist change to database asynchronously
    try {
      final todayDateOnly = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day
      );
      
      // Get list of completed meal names
      final updatedNames = currentStatus.entries
          .where((entry) => entry.value) // Only include completed meals
          .map((entry) => entry.key)
          .toList();

      // Save to database in a transaction
      await _isar.writeTxn(() async {
        final existing = await _isar.dailyCompletions
            .where()
            .dateEqualTo(todayDateOnly)
            .findFirst();

        if (existing != null) {
          // Update existing record
          existing.completedMealNames = updatedNames;
          await _isar.dailyCompletions.put(existing);
        } else {
          // Create new record
          final newRecord = DailyCompletion.forDate(
            todayDateOnly,
            completedMeals: updatedNames
          );
          await _isar.dailyCompletions.put(newRecord);
        }
        
        print("[Isar] Saved completion for $todayDateOnly: $updatedNames");
      });
    } catch (e, stackTrace) {
      print("[TodayPageNotifier] Error saving completion status to Isar: $e\n$stackTrace");
      // Error handling is silent - we don't revert UI state
      // Could optionally show an error message to user
    }
  }

  /// Calculates total consumed macros based on completed meals
  /// 
  /// [completionStatus] - Map of meal names to completion status
  /// [plan] - The daily plan containing meal data
  /// 
  /// Returns a Macros object with totals of all completed meals
  Macros _calculateConsumedMacros(
      Map<String, bool> completionStatus, DailyPlan? plan) {
    if (plan == null) return Macros();

    Macros consumed = Macros();
    for (var meal in plan.meals) {
      // Add macros if meal is marked as completed
      if (completionStatus.containsKey(meal.name) &&
          completionStatus[meal.name] == true) {
        consumed += meal.totalMacros;
      }
    }
    return consumed;
  }

  @override
  void dispose() {
    print("[TodayPageNotifier] Disposed");
    super.dispose();
  }
}