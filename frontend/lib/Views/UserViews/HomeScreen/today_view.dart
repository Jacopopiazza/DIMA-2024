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

/// Enum representing different view types
enum _ViewType { error, noMeals, planDetails }

/// Configuration class for view state
class _ViewConfiguration {
  final _ViewType viewType;
  final bool requiresIndicator;
  final String? indicatorMessage;
  final String errorMessage;

  const _ViewConfiguration({
    required this.viewType,
    required this.requiresIndicator,
    this.indicatorMessage,
    required this.errorMessage,
  });
}

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
    final todayState = ref.watch(todayPageProvider);
    final notifier = ref.read(todayPageProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildRefreshWrapper(
        context: context,
        onRefresh: () => notifier.refreshData(),
        child: _shouldShowNoPlanView(todayState.status)
            ? _buildNoPlanView(context, notifier)
            : _buildBody(context, todayState, notifier),
      ),
    );
  }

  /// Wraps content with RefreshIndicator and responsive layout
  Widget _buildRefreshWrapper({
    required BuildContext context,
    required Future<void> Function() onRefresh,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      displacement: 60.0,
      color: theme.colorScheme.primary,
      backgroundColor: theme.scaffoldBackgroundColor,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Determines if the no-plan view should be shown
  bool _shouldShowNoPlanView(DataStatus status) {
    return status == DataStatus.errorNoPlan ||
        status == DataStatus.errorInvalidPlanId;
  }

  /// Builds the no-plan selection view
  Widget _buildNoPlanView(BuildContext context, TodayPageNotifier notifier) {
    return Center(
      child: ChoosePlanCard(
        onChoosePlan: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const MyPlansPage(showBackButton: true)),
          );
          if (context.mounted) {
            notifier.refreshData();
          }
        },
      ),
    );
  }

  /// Configuration for different UI states
  /// Gets localized state config message
  Map<String, dynamic> _getStateConfig(
      BuildContext context, DataStatus status) {
    final localizations = AppLocalizations.of(context)!;

    switch (status) {
      case DataStatus.loadedOffline:
        return {
          'defaultMessage': localizations.showingStaleData,
          'requiresIndicator': true,
        };
      case DataStatus.errorNetworkWithCache:
        return {
          'defaultMessage': localizations.networkUnavailableCachedData,
          'requiresIndicator': true,
        };
      case DataStatus.errorNetwork:
        return {
          'defaultMessage': localizations.refreshFailedPreviousData,
          'fallbackMessage': localizations.failedToLoadDataCheckConnection,
          'requiresIndicator': true,
        };
      case DataStatus.errorOther:
        return {
          'defaultMessage': localizations.refreshFailedPreviousData,
          'fallbackMessage': localizations.failedToLoadDataCheckConnection,
          'requiresIndicator': true,
        };
      default:
        return {};
    }
  }

  /// Builds the main content widget based on the current TodayPageState
  Widget _buildBody(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    // Handle initial loading
    if (state.status == DataStatus.loading && state.isInitialLoad) {
      return const LoadingShimmer();
    }

    // Handle loading with no previous data
    if (state.status == DataStatus.loading && !_hasMealData(state)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle initial or unknown states
    if (state.status == DataStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    // Determine view type based on meal data
    final viewConfig = _determineViewConfiguration(context, state);

    // Build appropriate view
    switch (viewConfig.viewType) {
      case _ViewType.error:
        return _buildErrorView(context, state, notifier);
      case _ViewType.noMeals:
        return _buildNoMealsLayout(context, state, notifier, viewConfig);
      case _ViewType.planDetails:
        return _buildPlanDetailsLayout(context, state, notifier, viewConfig);
    }
  }

  /// Determines the appropriate view configuration based on state
  _ViewConfiguration _determineViewConfiguration(
      BuildContext context, TodayPageState state) {
    final hasMeals = _hasMealData(state);
    final hasEmptyMealData =
        state.todaysMeals != null && state.todaysMeals!.isEmpty;
    final config = _getStateConfig(context, state.status);
    final localizations = AppLocalizations.of(context)!;

    // Determine view type
    _ViewType viewType;
    if (state.status == DataStatus.loadedOnline) {
      viewType = hasMeals ? _ViewType.planDetails : _ViewType.noMeals;
    } else if (config != null) {
      if (hasMeals) {
        viewType = _ViewType.planDetails;
      } else if (hasEmptyMealData) {
        viewType = _ViewType.noMeals;
      } else {
        viewType = _ViewType.error;
      }
    } else {
      viewType = hasMeals ? _ViewType.planDetails : _ViewType.noMeals;
    }

    // Determine if indicator is needed
    final requiresIndicator =
        config?['requiresIndicator'] == true && (viewType != _ViewType.error);

    // Determine indicator message
    String? indicatorMessage;
    if (requiresIndicator) {
      if (viewType == _ViewType.noMeals && hasEmptyMealData) {
        indicatorMessage =
            state.errorMessage ?? localizations.refreshFailedNoMealsScheduled;
      } else {
        indicatorMessage = state.errorMessage ?? config['defaultMessage'];
      }
    }

    return _ViewConfiguration(
      viewType: viewType,
      requiresIndicator: requiresIndicator,
      indicatorMessage: indicatorMessage,
      errorMessage: state.errorMessage ??
          config['fallbackMessage'] ??
          localizations.somethingWentWrong,
    );
  }

  /// Builds error view
  Widget _buildErrorView(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    final config = _getStateConfig(context, state.status);
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: ErrorView(
        message: state.errorMessage ??
            config['fallbackMessage'] ??
            localizations.failedToLoadDataCheckConnection,
        onRetry: () => notifier.refreshData(),
      ),
    );
  }

  /// Builds no meals layout with optional indicator
  Widget _buildNoMealsLayout(BuildContext context, TodayPageState state,
      TodayPageNotifier notifier, _ViewConfiguration config) {
    if (!config.requiresIndicator) {
      return _buildNoMealsView(context, notifier, state.status);
    }

    return Column(
      children: [
        _buildStaleDataIndicator(config.indicatorMessage!, state, notifier),
        Expanded(child: _buildNoMealsView(context, notifier, state.status)),
      ],
    );
  }

  /// Builds plan details layout with optional indicator
  Widget _buildPlanDetailsLayout(BuildContext context, TodayPageState state,
      TodayPageNotifier notifier, _ViewConfiguration config) {
    return Column(
      children: [
        if (config.requiresIndicator)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: _buildStaleDataIndicator(
                config.indicatorMessage!, state, notifier),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _buildPlanDetailsViewContent(context, state, notifier),
        ),
      ],
    );
  }

  /// Builds stale data indicator widget
  Widget _buildStaleDataIndicator(
      String message, TodayPageState state, TodayPageNotifier notifier) {
    return StaleDataIndicator(
      message: message,
      lastFetched: state.planLastFetched,
      onRefresh: () => notifier.refreshData(),
    );
  }

  /// Checks if state has meal data
  bool _hasMealData(TodayPageState state) {
    return state.todaysMeals != null && state.todaysMeals!.isNotEmpty;
  }

  /// Builds the content part of the plan details view
  Widget _buildPlanDetailsViewContent(
      BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    if (state.todaysMeals == null) {
      final localizations = AppLocalizations.of(context)!;
      return Center(child: Text(localizations.errorMealDataMissing));
    }

    final totalMacros = _calculateTotalMacros(state.todaysMeals);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress card showing macro tracking
        ProgressCard(
          calories:
              "${state.consumedMacros.calories.round()} / ${totalMacros.calories.round()}",
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

        // Section title
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            localizations.todaysMeals,
            style: theme.textTheme.headlineSmall,
          ),
        ),

        // Meal cards list
        ...state.todaysMeals!.map((meal) => _buildMealCard(meal, state)),
      ],
    );
  }

  /// Builds individual meal card widget
  Widget _buildMealCard(Meal meal, TodayPageState state) {
    final isCompleted = state.isMealCompleted(meal.name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: MealCard(
        meal: meal,
        mealPlanId: state.mealPlanId!,
        isCompleted: isCompleted,
        imageUrl: _getMealImageUrl(meal.name),
        isLoading: false,
      ),
    );
  }

  // --- Keep Existing Helper Methods ---
  /// Meal image URL mappings
  static const Map<MealNameEnum, String> _mealImages = {
    MealNameEnum.BREAKFAST: 'assets/colazione.png',
    MealNameEnum.LUNCH: 'assets/pranzo.jpg',
    MealNameEnum.DINNER: 'assets/cena.png',
    MealNameEnum.SNACK_AFTERNOON: 'assets/snack-pomeridiano.png',
    MealNameEnum.SNACK_MORNING: 'assets/snack-mattino.png',
    MealNameEnum.SNACK_EVENING: 'assets/snack-serale.png',
  };

  /// Builds the view displayed when there are no meals scheduled for today
  Widget _buildNoMealsView(BuildContext context, TodayPageNotifier notifier,
      DataStatus currentStatus) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final today = DateFormat('EEEE').format(DateTime.now());

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 50,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noMealsForToday,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.currentMealPlanNoMealsScheduled(today),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(localizations.refreshNow),
              onPressed: () => notifier.refreshData(),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculates the total macros from a list of meals
  Macros _calculateTotalMacros(List<Meal>? meals) {
    if (meals == null || meals.isEmpty) {
      return Macros(
          calories: 0.0, carbohydrates: 0.0, fats: 0.0, proteins: 0.0);
    }

    return meals.fold(
      Macros(calories: 0.0, carbohydrates: 0.0, fats: 0.0, proteins: 0.0),
      (total, meal) => Macros(
        calories: total.calories + meal.totalMacros.calories,
        proteins: total.proteins + meal.totalMacros.proteins,
        carbohydrates: total.carbohydrates + meal.totalMacros.carbohydrates,
        fats: total.fats + meal.totalMacros.fats,
      ),
    );
  }

  /// Calculates a percentage (0.0 to 1.0) of consumed value relative to a total value
  double _calculatePercent(double consumed, double total) {
    return total <= 0 ? 0.0 : (consumed / total).clamp(0.0, 1.0);
  }

  /// Returns an image URL string for a given meal type
  String _getMealImageUrl(MealNameEnum meal) {
    return _mealImages[meal] ??
        'https://via.placeholder.com/600x250.png/grey/white?text=${Uri.encodeComponent(meal.name.toString())}';
  }
} // End of TodayPage class
