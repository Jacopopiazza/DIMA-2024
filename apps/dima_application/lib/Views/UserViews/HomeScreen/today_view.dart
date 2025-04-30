import 'package:dima_application/Views/UserViews/HomeScreen/progress_card.dart';
// Ensure StaleDataIndicator is imported
import 'package:dima_application/views/UserViews/HomeScreen/stale_data_indicator.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/today_page_provider.dart';
import 'package:dima_application/views/UserViews/HomeScreen/choose_plan_card.dart';
import 'package:dima_application/views/UserViews/HomeScreen/meal_card.dart';
import 'package:dima_application/views/UserViews/HomeScreen/today_error_view.dart'; // Keep ErrorView import
import 'package:dima_application/views/UserViews/HomeScreen/today_view_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayState = ref.watch(todayPageProvider);
    final notifier = ref.read(todayPageProvider.notifier);

    // Keep RefreshIndicator and LayoutBuilder structure
    return RefreshIndicator(
      displacement: 60.0,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onRefresh: () => notifier.refreshData(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use a ListView for scrollability and RefreshIndicator
          // ListView provides vertical scrolling.
          return ListView(
            // prevent scrolling when content fits for better RefreshIndicator experience
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              // Use ConstrainedBox to ensure content fills viewport height at minimum
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                // Delegate building the main body based on the state using NEW logic
                child: _buildBody(context, todayState, notifier),
              )
            ],
          );
        },
      ),
    );
  }

  // --- START: REFACTORED _buildBody Method ---
  /// Builds the main content based on TodayPageState, using indicators appropriately.
  Widget _buildBody(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    Widget? topIndicator; // Widget for StaleDataIndicator
    bool showErrorView = false; // Flag for large ErrorView
    bool showPlanDetails = false; // Flag for ProgressCard + MealCards area
    bool showNoMealsView = false; // Flag for "No Meals Scheduled" view

    // --- Determine state ---
    switch (state.status) {
      case DataStatus.loading:
        if (state.isInitialLoad) {
          // Full screen shimmer only on initial load
          return const LoadingShimmer();
        } else {
          // Refresh loading: Show previous data, rely on RefreshIndicator spinner.
          // Determine if previous data exists to show details or 'no meals' view
          showPlanDetails =
              (state.todaysMeals != null && state.todaysMeals!.isNotEmpty);
          showNoMealsView =
              (state.todaysMeals != null && state.todaysMeals!.isEmpty);

          if (!showPlanDetails && !showNoMealsView) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator()));
          }
        }
        break;

      case DataStatus.loadedOnline:
        showPlanDetails =
            (state.todaysMeals != null && state.todaysMeals!.isNotEmpty);
        showNoMealsView = !showPlanDetails;
        break;

      case DataStatus.loadedOffline: // Stale data was loaded
        showPlanDetails =
            (state.todaysMeals != null && state.todaysMeals!.isNotEmpty);
        showNoMealsView = !showPlanDetails;
        topIndicator = StaleDataIndicator(
          message: state.errorMessage ?? "Showing stale data.",
          lastFetched: state.planLastFetched,
          onRefresh: () => notifier.refreshData(),
        );
        break;

      case DataStatus.errorNetwork:
      case DataStatus.errorOther:
        final bool hasPreviousData =
            state.todaysMeals != null && state.todaysMeals!.isNotEmpty;
        final bool hadPreviousDataButNoMeals =
            state.todaysMeals != null && state.todaysMeals!.isEmpty;

        if (hasPreviousData) {
          showPlanDetails = true;
          topIndicator = StaleDataIndicator(
            message: state.errorMessage ??
                "Refresh failed. Displaying previous data.",
            lastFetched: state.planLastFetched,
            onRefresh: () => notifier.refreshData(),
          );
        } else if (hadPreviousDataButNoMeals) {
          showNoMealsView = true;
          topIndicator = StaleDataIndicator(
            message:
                state.errorMessage ?? "Refresh failed. No meals scheduled.",
            lastFetched: state.planLastFetched,
            onRefresh: () => notifier.refreshData(),
          );
        } else {
          showErrorView = true;
        }
        break;

      case DataStatus.errorNoPlan:
      case DataStatus
            .errorInvalidPlanId: // Make sure this status exists in your enum
        return Center(
          child: ChoosePlanCard(
            //message: state.errorMessage ?? "Please select a meal plan.",
            onChoosePlan: () => Navigator.pushNamed(context, '/choosePlan')
                .then((_) => notifier.refreshData()),
          ),
        );

      case DataStatus.initial:
      default:
        return const Center(child: CircularProgressIndicator());
    }

    // --- Build the final layout based on flags ---

    if (showErrorView) {
      return Center(
          child: ErrorView(
        message: state.errorMessage ?? "Failed to load data. Check connection.",
        onRetry: () => notifier.refreshData(),
      )
      );
    }

    if (showNoMealsView) {
      // Using Column + Expanded ensures _buildNoMealsView can center itself
      // within the remaining space after the indicator.
      return Column(
        children: [
          if (topIndicator != null) topIndicator,
          Expanded(child: _buildNoMealsView(context, notifier, state.status)),
        ],
      );
    }

    if (showPlanDetails) {
      // *** CORRECTED LAYOUT: No Expanded, No inner SingleChildScrollView ***

      return Column(
        // This column will be sized by its children within the ListView item
        children: [
          if (topIndicator != null)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: topIndicator,
            ), // Show indicator if needed

          // Apply padding directly around the content helper
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildPlanDetailsViewContent(
                context, state, notifier), // Call the content helper
          ),
        ],
      );
      // *** END CORRECTION ***
    }

    // Fallback
    return const Center(
        child: Text("Something went wrong determining view state."));
  }
  // --- END: REFACTORED _buildBody Method ---

  // --- START: NEW _buildPlanDetailsViewContent Helper Method ---
  /// Builds ONLY the content part of the plan details (ProgressCard, Meals).
  /// Assumes state.todaysMeals is not null/empty when called.
  Widget _buildPlanDetailsViewContent(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    if (state.todaysMeals == null) {
      return const Center(child: Text("Error: Meal data is missing."));
    }

    final totalMacros = _calculateTotalMacros(state.todaysMeals);
    final localizations = AppLocalizations.of(context)!;

    // Return just the column of widgets for the content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProgressCard(
          calories:
              "${state.consumedMacros.calories.round()} / ${totalMacros.calories.round()} kCal",
          fatPercent:
              _calculatePercent(state.consumedMacros.fats, totalMacros.fats),
          proteinPercent: _calculatePercent(
              state.consumedMacros.proteins, totalMacros.proteins),
          carbPercent: _calculatePercent(
              state.consumedMacros.carbohydrates, totalMacros.carbohydrates),
          isLoading: false,
          isInitialLoad: state.isInitialLoad,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(localizations.todaysMeals,
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        ...state.todaysMeals!.map((meal) {
          final isCompleted = state.isMealCompleted(meal.name);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MealCard(
              meal: meal,
              isCompleted: isCompleted,
              imageUrl: _getMealImageUrl(meal.name),
              // onToggle: () => notifier.toggleMealCompletion(meal.name),
              isLoading: false,
            ),
          );
        }).toList(),
      ],
    );
  }
  // --- END: NEW _buildPlanDetailsViewContent Helper Method ---

  // --- Keep Existing Helper Methods ---
  Widget _buildNoMealsView(BuildContext context, TodayPageNotifier notifier,
      DataStatus currentStatus) {
    // Removed the internal StaleDataIndicator
    return Center(
      // Ensure content is centered
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Icon(Icons.restaurant_menu_outlined,
                size: 50, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 16),
            Text("No Meals For Today",
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
              label: const Text("Refresh Now"),
              onPressed: () => notifier.refreshData(),
            ),
          ],
        ),
      ),
    );
  }

  Macros _calculateTotalMacros(List<Meal>? meals) {
    // (Keep your existing implementation)
    if (meals == null || meals.isEmpty) {
      return Macros(
          calories: 0.0, carbohydrates: 0.0, fats: 0.0, proteins: 0.0);
    }
    double totalCalories = 0;
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    for (final meal in meals) {
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

  double _calculatePercent(double consumed, double total) {
    // (Keep your existing implementation)
    if (total <= 0) return 0.0;
    return (consumed / total).clamp(0.0, 1.0);
  }

  String _getMealImageUrl(MealNameEnum meal) {
    // (Keep your existing implementation)
    const baseUrl = 'https://images.unsplash.com/photo-';
    switch (meal) {
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
        return 'https://via.placeholder.com/600x250.png/grey/white?text=${Uri.encodeComponent(meal.name.toString())}';
    }
  }
  // --- End Keep Existing Helper Methods ---
} // End of TodayPage class
