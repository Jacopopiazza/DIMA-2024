import 'package:dima_application/Views/UserViews/HomeScreen/stale_data_indicator.dart';
import 'package:dima_application/Views/UserViews/HomeScreen/today_error_view.dart';
import 'package:dima_application/Views/UserViews/HomeScreen/today_view_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dima_application/providers/today_page_provider.dart';
import 'choose_plan_card.dart';
import 'progress_card.dart';
import 'meal_card.dart';

/// TodayPage displays the user's daily meal plan and nutrition progress.
/// It handles various states including loading, errors, and no plan selected scenarios.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayState = ref.watch(todayPageProvider);
    final notifier = ref.read(todayPageProvider.notifier);

    return RefreshIndicator(
      displacement: 60.0,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onRefresh: () async => await notifier.refreshData(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: _buildBody(context, todayState, notifier, constraints),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, TodayPageState state,
      TodayPageNotifier notifier, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;

    // Initial loading state
    if (state.isInitialLoad && state.status == DataStatus.loading) {
      return const LoadingShimmer();
    }

    // Critical error state
    if (state.isInitialLoad && state.status == DataStatus.error) {
      return ErrorView(
        message: state.errorMessage ?? "Failed to load initial data.",
        notifier: notifier,
      );
    }

    // No plan selected state
    if (!state.hasChosenPlan && state.status != DataStatus.loading) {
      return Center(
        child: ChoosePlanCard(
          onChoosePlan: () => Navigator.pushNamed(context, '/choosePlan')
              .then((_) => notifier.refreshData()),
        ),
      );
    }

    // Plan selected states
    if (state.hasChosenPlan) {
      // No meals for today
      if (state.dailyPlan == null && state.status != DataStatus.loading) {
        return _buildNoMealsView(context, notifier);
      }

      // Plan details available
      if (state.dailyPlan != null) {
        return _buildPlanDetailsView(context, state, colorScheme);
      }

      // Error loading daily plan
      if (state.status == DataStatus.error) {
        return ErrorView(
          message: state.errorMessage ?? "Failed to load today's plan details.",
          notifier: notifier,
        );
      }
    }

    // Fallback for refreshing with no plan
    if (!state.isInitialLoad &&
        state.status == DataStatus.loading &&
        !state.hasChosenPlan) {
      return const SizedBox.shrink();
    }

    // Final fallback
    return state.status == DataStatus.loading
        ? const SizedBox.shrink()
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildNoMealsView(BuildContext context, TodayPageNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 50, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 16),
            Text("No Meals Scheduled",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                "Your current plan doesn't have meals scheduled for ${DateFormat('EEEE').format(DateTime.now())}.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Check Again"),
              onPressed: () => notifier.refreshData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetailsView(
      BuildContext context, TodayPageState state, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.status == DataStatus.error)
          StaleDataIndicator(
              errorMessage: state.errorMessage, colorScheme: colorScheme),
        ProgressCard(
          calories:
              "${state.consumedMacros.calories.round()} / ${state.dailyPlan!.totalMacros.calories.round()} kCal",
          fatPercent: _calculatePercent(
              state.consumedMacros.fats, state.dailyPlan!.totalMacros.fats),
          proteinPercent: _calculatePercent(state.consumedMacros.proteins,
              state.dailyPlan!.totalMacros.proteins),
          carbPercent: _calculatePercent(state.consumedMacros.carbohydrates,
              state.dailyPlan!.totalMacros.carbohydrates),
          isLoading: false,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
              "${state.dailyPlan!.weekday.substring(0, 1).toUpperCase()}${state.dailyPlan!.weekday.substring(1)}'s Meals",
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        ...state.dailyPlan!.meals.map((meal) {
          final isCompleted = state.mealCompletionStatus[meal.name] ?? false;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MealCard(
              meal: meal,
              isCompleted: isCompleted,
              imageUrl: _getMealImageUrl(meal.name),
              isLoading: false,
            ),
          );
        }).toList(),
      ],
    );
  }

  double _calculatePercent(double consumed, double total) {
    if (total == 0) return 0.0;
    return (consumed / total).clamp(0.0, 1.0);
  }

  String _getMealImageUrl(String mealName) {
    const baseUrl = 'https://images.unsplash.com/photo-';
    switch (mealName.toLowerCase()) {
      case 'breakfast':
        return '${baseUrl}1484723091739-30a097e8f929?ixlib=rb-4.0.3&auto=format&fit=crop&w=1949&q=80';
      case 'lunch':
        return '${baseUrl}1540189549336-e6e99c3679fe?ixlib=rb-4.0.3&auto=format&fit=crop&w=1887&q=80';
      case 'dinner':
        return '${baseUrl}1512621776951-a57141f2eefd?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80';
      default:
        return 'https://via.placeholder.com/600x250.png/grey/white?text=${Uri.encodeComponent(mealName)}';
    }
  }
}
