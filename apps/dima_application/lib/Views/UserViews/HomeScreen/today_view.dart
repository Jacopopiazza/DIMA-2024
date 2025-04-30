import 'package:dima_application/Views/UserViews/HomeScreen/progress_card.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/today_page_provider.dart'; // Updated provider
import 'package:dima_application/views/UserViews/HomeScreen/choose_plan_card.dart'; // Keep UI component
import 'package:dima_application/views/UserViews/HomeScreen/meal_card.dart'; // Keep UI component
import 'package:dima_application/views/UserViews/HomeScreen/stale_data_indicator.dart'; // Keep UI component
import 'package:dima_application/views/UserViews/HomeScreen/today_error_view.dart'; // Keep UI component
import 'package:dima_application/views/UserViews/HomeScreen/today_view_loading_shimmer.dart'; // Keep UI component
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// TodayPage displays the user's daily meal plan and nutrition progress.
/// It handles various states using the updated TodayPageNotifier.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state provided by the updated provider
    final todayState = ref.watch(todayPageProvider);
    // Get the notifier instance to call methods like refreshData, toggleMealCompletion
    final notifier = ref.read(todayPageProvider.notifier);

    return RefreshIndicator(
      displacement: 60.0, // Adjust position as needed
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Trigger refresh action in the notifier
      onRefresh: () => notifier.refreshData(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use a ListView for scrollability and RefreshIndicator compatibility
          return ListView(
            // Add padding around the content
            padding: const EdgeInsets.all(16.0),
            // Ensure scrolling is always possible for RefreshIndicator
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              // Use ConstrainedBox to ensure content fills viewport height
              // enabling RefreshIndicator even when content is short.
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight - 32), // Account for padding
                // Delegate building the main body based on the state
                child: _buildBody(context, todayState, notifier),
              )
            ],
          );
        },
      ),
    );
  }

  /// Builds the main content of the page based on the current TodayPageState.
  Widget _buildBody(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    // --- Loading State ---
    // Show shimmer only during the very first load
    if (state.isInitialLoad && state.status == DataStatus.loading) {
      return const LoadingShimmer();
    }

    // --- Error States ---
    // Handle critical initial load error
    if (state.isInitialLoad && state.status == DataStatus.errorOther) {
      return ErrorView(
        message: state.errorMessage ??
            "Failed to load initial data. Please try again.",
        onRetry: () => notifier.refreshData(), // Pass retry function
      );
    }
    // Handle case where user has no active plan selected
    if (state.status == DataStatus.errorNoPlan) {
      return Center(
        child: ChoosePlanCard(
          // Navigate to plan selection and refresh afterwards
          onChoosePlan: () => Navigator.pushNamed(context, '/choosePlan')
              .then((_) => notifier.refreshData()),
        ),
      );
    }
    // Handle network errors or other errors after initial load attempt
    if (state.status == DataStatus.errorNetwork ||
        state.status == DataStatus.errorOther) {
      // If there are meals available (likely from a previous stale load),
      // show them along with the error view on top. Otherwise, show only error view.
      final bool hasPreviousData =
          state.todaysMeals != null && state.todaysMeals!.isNotEmpty;
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center error if shown alone
        children: [
          ErrorView(
            message: state.errorMessage ?? "An error occurred.",
            onRetry: () => notifier.refreshData(),
          ),
          if (hasPreviousData) ...[
            const SizedBox(height: 24),
            _buildPlanDetailsView(
                context, state, notifier) // Show previous data below error
          ]
        ],
      );
    }

    // --- Success States (Online or Offline/Stale) ---
    if (state.status == DataStatus.loadedOffline ||
        state.status == DataStatus.loadedOnline) {
      // Check if meals are available for today
      if (state.todaysMeals == null || state.todaysMeals!.isEmpty) {
        // Show message indicating no meals scheduled for today
        return _buildNoMealsView(context, notifier, state.status);
      } else {
        // Meals are available, display the plan details
        return _buildPlanDetailsView(context, state, notifier);
      }
    }

    // --- Fallback/Intermediate Loading State ---
    // If loading during a refresh, the RefreshIndicator shows the spinner.
    // We can optionally show a small indicator or nothing here,
    // as the previous content might still be visible underneath.
    if (state.status == DataStatus.loading && !state.isInitialLoad) {
      // Show previous data if available while loading refresh
      if (state.todaysMeals != null && state.todaysMeals!.isNotEmpty) {
        return _buildPlanDetailsView(context, state, notifier);
      } else if (state.dailyCompletion != null) {
        // Check if maybe just completion exists from previous load
        return _buildNoMealsView(context, notifier, state.status);
      }
      // If no previous data, show a minimal loading indicator or SizedBox
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3)),
      ));
    }

    // Default fallback - should ideally not be reached if all statuses are handled
    return const Center(child: Text("Unexpected state."));
  }

  /// Builds the view shown when no meals are scheduled for the current day.
  Widget _buildNoMealsView(BuildContext context, TodayPageNotifier notifier,
      DataStatus currentStatus) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show stale data indicator if relevant
            if (currentStatus == DataStatus.loadedOffline)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: StaleDataIndicator(
                  lastFetched: null, // Pass timestamp if needed/available
                  message:
                      "Offline mode: Plan structure loaded, but no meals for today.",
                ),
              ),
            Icon(Icons.restaurant_menu_outlined, // Changed Icon
                size: 50,
                color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 16),
            Text("No Meals For Today", // Changed Text
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                "Your current meal plan doesn't have any meals scheduled for ${DateFormat('EEEE').format(DateTime.now())}.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Refresh"),
              onPressed: () => notifier.refreshData(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main view displaying progress and meal cards when a plan is loaded.
  Widget _buildPlanDetailsView(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    // Calculate total macros for the day from the list of today's meals
    final totalMacros = _calculateTotalMacros(state.todaysMeals);
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show indicator if data is stale (loaded offline)
        if (state.status == DataStatus.loadedOffline)
          StaleDataIndicator(
            lastFetched: state.planLastFetched, // Pass the timestamp from state
            message: state.errorMessage, // Use message from state if available
          ),

        // Display nutrition progress card
        ProgressCard(
          // Use calculated total macros and consumed macros from state
          calories:
              "${state.consumedMacros.calories.round()} / ${totalMacros.calories.round()} kCal",
          fatPercent:
              _calculatePercent(state.consumedMacros.fats, totalMacros.fats),
          proteinPercent: _calculatePercent(
              state.consumedMacros.proteins, totalMacros.proteins),
          carbPercent: _calculatePercent(
              state.consumedMacros.carbohydrates, totalMacros.carbohydrates),
          // Indicate loading state maybe based on refresh status? For now, false.
          isLoading: state.status == DataStatus.loading && !state.isInitialLoad,
        ),
        const SizedBox(height: 24),

        // Header for the meals list
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
              // Generic title as weekday is implicit
              localizations.todaysMeals,
              style: Theme.of(context).textTheme.headlineSmall),
        ),

        // Generate MealCards for each meal in today's list
        // Check explicitly for null before mapping
        if (state.todaysMeals != null)
          ...state.todaysMeals!.map((meal) {
            // Iterate over domain model List<Meal>
            // Determine if the meal is marked complete using the state's helper method
            // Use meal.recipeName or the correct unique identifier used in toggleMealCompletion
            final isCompleted = state.isMealCompleted(meal.name);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MealCard(
                // Pass the domain Meal object
                meal: meal,
                isCompleted: isCompleted,
                imageUrl: _getMealImageUrl(
                    meal.name), // Use recipe name for image lookup
                // Call the notifier to toggle completion status on tap/check
                // Make sure MealCard has an onToggle callback or similar interaction mechanism
                //onToggle: () => notifier.toggleMealCompletion(meal.recipeName!),
                // Pass loading state if needed (e.g., during toggle action) - simplified for now
                isLoading: false,
              ),
            );
          }).toList(),
      ],
    );
  }

  /// Calculates the total macros by summing up macros from a list of meals.
  /// Returns a Macros object (domain model).
  Macros _calculateTotalMacros(List<Meal>? meals) {
    if (meals == null || meals.isEmpty) {
      return Macros(
          calories: 0.0, carbohydrates: 0.0, fats: 0.0, proteins: 0.0);
    }

    double totalCalories = 0;
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (final meal in meals) {
      // Sum macros from each meal's totalMacros (domain model)
      totalCalories += meal.totalMacros.calories;
      totalProteins += meal.totalMacros.proteins;
      totalCarbs += meal.totalMacros.carbohydrates;
      totalFats += meal.totalMacros.fats;
    }
    return Macros(
        calories: totalCalories,
        proteins: totalProteins,
        carbohydrates: totalCarbs,
        fats: totalFats);
  }

  /// Helper function to calculate percentage, clamped between 0.0 and 1.0.
  double _calculatePercent(double consumed, double total) {
    if (total <= 0) return 0.0; // Avoid division by zero or negative totals
    return (consumed / total).clamp(0.0, 1.0);
  }

  /// Provides placeholder image URLs based on meal name (example).
  String _getMealImageUrl(MealNameEnum meal) {
    // Simple example - replace with your actual image logic
    const baseUrl = 'https://images.unsplash.com/photo-';

    switch(meal){
      case MealNameEnum.BREAKFAST:
        return '${baseUrl}1484723091739-30a097e8f929?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80';
      case MealNameEnum.LUNCH:
        return '${baseUrl}1540189549336-e6e99c3679fe?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80';
      case MealNameEnum.DINNER:
        return '${baseUrl}1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80';
      case MealNameEnum.SNACK_AFTERNOON:
      case MealNameEnum.SNACK_MORNING:
      case MealNameEnum.SNACK_EVENING:
        return '${baseUrl}1551709076-39f3910593f4?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80';
      default:
        // Fallback placeholder
        return 'https://via.placeholder.com/600x250.png/grey/white?text=${Uri.encodeComponent(meal.name.toString())}';
    }
  }
}


// Ensure your UI Components (MealCard, ProgressCard, StaleDataIndicator, ErrorView, ChoosePlanCard)
// accept the parameters as used above. Specifically:
// - MealCard: Needs `Meal meal` (domain model), `bool isCompleted`, `String imageUrl`, `VoidCallback onToggle`, `bool isLoading`.
// - ProgressCard: Needs `String calories`, `double fatPercent`, `double proteinPercent`, `double carbPercent`, `bool isLoading`.
// - StaleDataIndicator: Needs `DateTime? lastFetched`, `String? message`.
// - ErrorView: Needs `String message`, `VoidCallback onRetry`.
// - ChoosePlanCard: Needs `VoidCallback onChoosePlan`.