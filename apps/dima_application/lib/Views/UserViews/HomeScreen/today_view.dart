import 'package:dima_application/Views/UserViews/HomeScreen/progress_card.dart';
import 'package:dima_application/Views/UserViews/MyPlansScreen/my_plans_page.dart';
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

/// A ConsumerWidget that displays the main "Today" screen content.
///
/// This widget observes the `todayPageProvider` to react to changes in the
/// data loading status, errors, and available meal plan information. It
/// renders different UI states (loading, data loaded, error, no plan selected)
/// and allows refreshing the data via a pull-to-refresh gesture.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider's state to rebuild the widget when the state changes.
    final todayState = ref.watch(todayPageProvider);
    // Read the provider's notifier to access methods that can change the state.
    final notifier = ref.read(todayPageProvider.notifier);

    // Determina se il RefreshIndicator dovrebbe essere abilitato
    final bool canRefresh = todayState.status != DataStatus.errorNoPlan && 
                           todayState.status != DataStatus.errorInvalidPlanId;

                           // Se non c'è piano, mostra direttamente il contenuto senza RefreshIndicator
    if (!canRefresh) {
      return Center(
        child: ChoosePlanCard(
          onChoosePlan: () async {
            // Naviga alla pagina di selezione piano
            await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyPlansPage(),
        ),
      );
            // Refresh solo dopo che l'utente torna dalla selezione
            // e potenzialmente ha selezionato un piano
            if (context.mounted) {
              notifier.refreshData();
            }
          },
        ),
      );
    }

    // Altrimenti usa RefreshIndicator normalmente
    return RefreshIndicator(
      displacement: 60.0,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onRefresh: () => notifier.refreshData(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _buildBody(context, todayState, notifier),
              )
            ],
          );
        },
      ),
    );
  }

  // --- START: REFACTORED _buildBody Method ---
  /// Builds the main content widget based on the current `TodayPageState`.
  ///
  /// This method orchestrates the display of different UI states:
  /// loading skeleton, data loaded (with or without stale data indicator),
  /// error views, or the "Choose Plan" card.
  Widget _buildBody(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    // Optional widget to display a StaleDataIndicator at the top.
    Widget? topIndicator;
    // Flags to control which main content view is displayed.
    bool showErrorView = false; // True to show the large ErrorView card.
    bool showPlanDetails = false; // True to show ProgressCard and MealCards.
    bool showNoMealsView = false; // True to show the "No Meals For Today" message.

    // --- Determine the state and set flags/indicators ---
    switch (state.status) {
      case DataStatus.loading:
        // If it's the initial load, show the full-screen shimmer skeleton.
        if (state.isInitialLoad) {
          return const LoadingShimmer();
        } else {
          // If it's a refresh loading (not initial), show the previous data
          // if available, and the RefreshIndicator spinner handles the loading feedback.
          // Determine if previous data exists to show plan details or 'no meals' view.
          showPlanDetails =
              (state.todaysMeals != null && state.todaysMeals!.isNotEmpty);
          showNoMealsView =
              (state.todaysMeals != null && state.todaysMeals!.isEmpty);

          // If no previous data exists at all during a refresh, show a simple spinner.
          if (!showPlanDetails && !showNoMealsView) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator()));
          }
          // If previous data exists, the code will fall through to build the
          // layout with that data, and the RefreshIndicator shows the loading.
        }
        break;

      case DataStatus.loadedOnline:
        // Data loaded successfully from an online source.
        showPlanDetails =
            (state.todaysMeals != null && state.todaysMeals!.isNotEmpty);
        showNoMealsView = !showPlanDetails; // If no plan details, show no meals view.
        // No stale data indicator needed for online loaded data.
        break;

      case DataStatus.loadedOffline:
        // Data loaded successfully from offline cache (stale data).
        showPlanDetails =
            (state.todaysMeals != null && state.todaysMeals!.isNotEmpty);
        showNoMealsView = !showPlanDetails; // If no plan details, show no meals view.
        // Show the stale data indicator.
        topIndicator = StaleDataIndicator(
          message: state.errorMessage ?? "Showing stale data.", // Use custom message or default
          lastFetched: state.planLastFetched, // Provide the last fetched time
          onRefresh: () => notifier.refreshData(), // Provide refresh callback
        );
        break;

      case DataStatus.errorNetwork:
      case DataStatus.errorOther:
        // An error occurred (network or other).
        // Check if any previous data is available to display.
        final bool hasPreviousData =
            state.todaysMeals != null && state.todaysMeals!.isNotEmpty;
        final bool hadPreviousDataButNoMeals =
            state.todaysMeals != null && state.todaysMeals!.isEmpty;

        if (hasPreviousData) {
          // If previous meal data exists, show it along with a stale data indicator.
          showPlanDetails = true;
          topIndicator = StaleDataIndicator(
            message: state.errorMessage ??
                "Refresh failed. Displaying previous data.", // Use custom message or default
            lastFetched: state.planLastFetched, // Provide the last fetched time
            onRefresh: () => notifier.refreshData(), // Provide refresh callback
          );
        } else if (hadPreviousDataButNoMeals) {
          // If there was previous data, but it indicated no meals for today,
          // show the "No Meals" view along with a stale data indicator.
           showNoMealsView = true;
           topIndicator = StaleDataIndicator(
             message:
                 state.errorMessage ?? "Refresh failed. No meals scheduled.", // Use custom message or default
             lastFetched: state.planLastFetched, // Provide the last fetched time
             onRefresh: () => notifier.refreshData(), // Provide refresh callback
           );
        }
        else {
          // If no previous data exists at all, show the large ErrorView card.
          showErrorView = true;
        }
        break;
      case DataStatus.initial:
      default:
        // Default state, show a simple loading spinner.
        return const Center(child: CircularProgressIndicator());
    }

    // --- Build the final layout based on the determined flags ---

    // If the showErrorView flag is true, display the large ErrorView card centered.
    if (showErrorView) {
      return Center(
          child: ErrorView(
        message: state.errorMessage ?? "Failed to load data. Check connection.", // Use custom message or default
        onRetry: () => notifier.refreshData(), // Provide retry callback
      )
      );
    }

    // If the showNoMealsView flag is true, display the "No Meals For Today" view.
    // Use a Column to stack the optional top indicator above the no meals view.
    // Expanded ensures the _buildNoMealsView takes up the remaining space.
    if (showNoMealsView) {
      return Column(
        children: [
          if (topIndicator != null) topIndicator, // Show the stale data indicator if present
          Expanded(child: _buildNoMealsView(context, notifier, state.status)), // Show the no meals view, centered vertically
        ],
      );
    }

    // If the showPlanDetails flag is true, display the ProgressCard and MealCards.
    // Use a Column to stack the optional top indicator above the plan details content.
    // No Expanded or inner SingleChildScrollView is needed here, as the outer ListView
    // handles scrolling for the entire page content.
    if (showPlanDetails) {
      return Column(
        // This column's size will be determined by the total height of its children
        // within the ListView item, allowing the ListView to scroll if needed.
        children: [
          if (topIndicator != null)
            Padding(
              // Add padding around the stale data indicator if it's displayed.
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: topIndicator,
            ), // Show indicator if needed

          // Apply padding directly around the main content helper method's output.
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildPlanDetailsViewContent(
                context, state, notifier), // Call the helper to build the content
          ),
        ],
      );
    }

    // Fallback case: If none of the expected states are met, show a generic error message.
    return const Center(
        child: Text("Something went wrong determining view state.")); // Hardcoded string
  }
  // --- END: REFACTORED _buildBody Method ---

  // --- START: _buildPlanDetailsViewContent Helper Method ---
  /// Builds ONLY the content part of the plan details view.
  ///
  /// This includes the `ProgressCard` and the list of `MealCard` widgets.
  /// It assumes that `state.todaysMeals` is not null or empty when called.
  Widget _buildPlanDetailsViewContent(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    // Although assumed not null by the calling logic, a defensive check is good practice.
    if (state.todaysMeals == null) {
      return const Center(child: Text("Error: Meal data is missing.")); // Hardcoded error message
    }

    // Calculate total macros from the list of meals.
    final totalMacros = _calculateTotalMacros(state.todaysMeals);
    // Access localization delegate.
    final localizations = AppLocalizations.of(context)!;

    // Return a Column containing the ProgressCard and the list of MealCards.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
      children: [
        // Display the ProgressCard with calculated macro percentages.
        ProgressCard(
          calories:
              "${state.consumedMacros.calories.round()} / ${totalMacros.calories.round()} kCal", // Format calories string
          fatPercent:
              _calculatePercent(state.consumedMacros.fats, totalMacros.fats), // Calculate fat percentage
          proteinPercent: _calculatePercent(
              state.consumedMacros.proteins, totalMacros.proteins), // Calculate protein percentage
          carbPercent: _calculatePercent(
              state.consumedMacros.carbohydrates, totalMacros.carbohydrates), // Calculate carb percentage
          isLoading: false, // Not in a loading state for the ProgressCard itself here
          isInitialLoad: state.isInitialLoad, // Pass initial load status for animation handling
        ),
        const SizedBox(height: 24), // Space between ProgressCard and meal list title
        // Title for the list of today's meals.
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // Padding below the title
          child: Text(localizations.todaysMeals, // Localized title text
              style: Theme.of(context).textTheme.headlineSmall), // Apply headline small style
        ),
        // Map the list of Meal objects to a list of MealCard widgets.
        ...state.todaysMeals!.map((meal) {
          // Determine if the current meal is completed based on the state.
          final isCompleted = state.isMealCompleted(meal.name);
          // Wrap each MealCard in Padding for spacing.
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Space below each meal card
            child: MealCard(
              meal: meal, // Pass the meal data
              mealPlanId: state.mealPlanId!,
              isCompleted: isCompleted, // Pass the completion status
              imageUrl: _getMealImageUrl(meal.name), // Get the image URL for the meal type
              // onToggle: () => notifier.toggleMealCompletion(meal.name), // Optional: Callback for toggling completion
              isLoading: false, // MealCard is not in a loading state here
            ),
          );
        }).toList(), // Convert the mapped iterable to a List of Widgets
      ],
    );
  }
  // --- END: _buildPlanDetailsViewContent Helper Method ---

  // --- Keep Existing Helper Methods ---
  /// Builds the view displayed when there are no meals scheduled for today.
  ///
  /// Includes an icon, message, and a refresh button.
  Widget _buildNoMealsView(BuildContext context, TodayPageNotifier notifier,
      DataStatus currentStatus) {
    // Removed the internal StaleDataIndicator as it's now handled in _buildBody.
    return Center(
      // Center the column content vertically and horizontally.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0), // Padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the column's children
          children: [
            // Icon for no meals
            Icon(Icons.restaurant_menu_outlined,
                size: 50, color: Theme.of(context).colorScheme.secondary), // Icon and color
            const SizedBox(height: 16), // Space below icon
            // Title text
            Text("No Meals For Today", // Hardcoded title (could be localized)
                style: Theme.of(context).textTheme.headlineSmall, // Apply headline small style
                textAlign: TextAlign.center), // Center align text
            const SizedBox(height: 8), // Space below title
            // Explanatory text
            Text(
                "Your current meal plan doesn't have any meals scheduled for ${DateFormat('EEEE').format(DateTime.now())}.", // Hardcoded message with formatted day
                style: Theme.of(context).textTheme.bodyMedium, // Apply body medium style
                textAlign: TextAlign.center), // Center align text
            const SizedBox(height: 24), // Space below text
            // Refresh button
            TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18), // Refresh icon
              label: const Text("Refresh Now"), // Button label (hardcoded)
              onPressed: () => notifier.refreshData(), // Trigger refresh on press
            ),
          ],
        ),
      ),
    );
  }

  /// Calculates the total macros from a list of meals.
  ///
  /// Returns a `Macros` object with the sum of calories, proteins, carbs, and fats.
  Macros _calculateTotalMacros(List<Meal>? meals) {
    if (meals == null || meals.isEmpty) {
      // Return zero macros if the list is null or empty.
      return Macros(
          calories: 0.0, carbohydrates: 0.0, fats: 0.0, proteins: 0.0);
    }
    double totalCalories = 0;
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    // Iterate through the meals and sum their total macros.
    for (final meal in meals) {
      totalCalories += meal.totalMacros.calories;
      totalProteins += meal.totalMacros.proteins;
      totalCarbs += meal.totalMacros.carbohydrates;
      totalFats += meal.totalMacros.fats;
    }
    // Return a new Macros object with the calculated totals.
    return Macros(
        calories: totalCalories,
        proteins: totalProteins,
        carbohydrates: totalCarbs,
        fats: totalFats);
  }

  /// Calculates a percentage (0.0 to 1.0) of consumed value relative to a total value.
  ///
  /// Returns 0.0 if the total is zero or negative. Clamps the result between 0.0 and 1.0.
  double _calculatePercent(double consumed, double total) {
    if (total <= 0) return 0.0; // Avoid division by zero or negative total
    return (consumed / total).clamp(0.0, 1.0); // Calculate and clamp the percentage
  }

  /// Returns an image URL string for a given meal type.
  ///
  /// Uses Unsplash images for specific meal types and a placeholder for others.
  String _getMealImageUrl(MealNameEnum meal) {
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
        // Use a placeholder image with the meal name encoded in the text.
        return 'https://via.placeholder.com/600x250.png/grey/white?text=${Uri.encodeComponent(meal.name.toString())}';
    }
  }
  // --- End Keep Existing Helper Methods ---
} // End of TodayPage class
