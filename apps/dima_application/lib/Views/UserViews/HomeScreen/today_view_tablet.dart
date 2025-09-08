import 'package:dima_application/Views/UserViews/HomeScreen/progress_card.dart';
import 'package:dima_application/Views/UserViews/MyPlansScreen/my_plans_page.dart';
// Ensure StaleDataIndicator is imported
import 'package:dima_application/Views/UserViews/HomeScreen/stale_data_indicator.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/today_page_provider.dart';
import 'package:dima_application/Views/UserViews/HomeScreen/choose_plan_card.dart';
import 'package:dima_application/Views/UserViews/HomeScreen/meal_card.dart';
import 'package:dima_application/Views/UserViews/HomeScreen/today_error_view.dart'; // Keep ErrorView import
import 'package:dima_application/Views/UserViews/HomeScreen/today_view_loading_shimmer.dart';
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

/// A tablet-optimized ConsumerWidget that displays the main "Today" screen content.
///
/// This widget is specifically designed for tablet/iPad devices and provides
/// a more spacious, two-column layout that takes advantage of the larger screen real estate.
/// It observes the `todayPageProvider` to react to changes in data loading status,
/// errors, and available meal plan information, similar to the phone version but with
/// tablet-specific UI adaptations.
class TodayPageTablet extends ConsumerWidget {
  final VoidCallback? onNavigateToMealPlans;
  
  const TodayPageTablet({super.key, this.onNavigateToMealPlans});

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

  /// Wraps content with RefreshIndicator and responsive layout optimized for tablet
  Widget _buildRefreshWrapper({
    required BuildContext context,
    required Future<void> Function() onRefresh,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      displacement: 80.0, // Increased for tablet
      color: theme.colorScheme.primary,
      backgroundColor: theme.scaffoldBackgroundColor,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Tablet padding
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40), // Account for padding
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

  /// Builds the no-plan selection view - tablet optimized
  Widget _buildNoPlanView(BuildContext context, TodayPageNotifier notifier) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // Constrain width on large screens
        child: ChoosePlanCard(
          onChoosePlan: () async {
            if (onNavigateToMealPlans != null) {
              // On tablet, use the callback to switch tabs
              onNavigateToMealPlans!();
              // Refresh after a short delay to allow navigation to complete
              Future.delayed(const Duration(milliseconds: 100), () {
                if (context.mounted) {
                  notifier.refreshData();
                }
              });
            } else {
              // Fallback to modal navigation (e.g., if used standalone)
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const MyPlansPage(showBackButton: true)),
              );
              if (context.mounted) {
                notifier.refreshData();
              }
            }
          },
        ),
      ),
    );
  }

  /// Configuration for different UI states
  /// Gets localized state config message
  Map<String, dynamic> _getStateConfig(BuildContext context, DataStatus status) {
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
      return _buildTabletLoadingSkeleton(context);
    }

    // Handle loading with no previous data
    if (state.status == DataStatus.loading && !_hasMealData(state)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0), // More padding for tablet
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

  /// Builds tablet-specific loading skeleton
  Widget _buildTabletLoadingSkeleton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        
        if (isLandscape) {
          // Two-column layout for landscape
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Progress card
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const LoadingShimmer(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Right column - Meal cards
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerText(180, 28),
                    const SizedBox(height: 16),
                    ...List.generate(3, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildMealCardSkeleton(context),
                    )),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Single column layout for portrait
          return Column(
            children: [
              const LoadingShimmer(),
              const SizedBox(height: 32),
              _buildShimmerText(180, 28),
              const SizedBox(height: 16),
              ...List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMealCardSkeleton(context),
              )),
            ],
          );
        }
      },
    );
  }

  /// Builds a shimmer text placeholder
  Widget _buildShimmerText(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Builds a meal card skeleton for loading state
  Widget _buildMealCardSkeleton(BuildContext context) {
    return Container(
      height: 120, // Tablet-appropriate height
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Determines the appropriate view configuration based on state
  _ViewConfiguration _determineViewConfiguration(BuildContext context, TodayPageState state) {
    final hasMeals = _hasMealData(state);
    final hasEmptyMealData =
        state.todaysMeals != null && state.todaysMeals!.isEmpty;
    final config = _getStateConfig(context, state.status);
    final localizations = AppLocalizations.of(context)!;

    // Determine view type
    _ViewType viewType;
    if (state.status == DataStatus.loadedOnline) {
      viewType = hasMeals ? _ViewType.planDetails : _ViewType.noMeals;
    } else if (config.isNotEmpty) {
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
        config['requiresIndicator'] == true && (viewType != _ViewType.error);

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
    
    // Check if this looks like a network error (use raw error for detection)
    final rawError = state.errorMessage ?? "";
    final isNetworkError = rawError.toLowerCase().contains('network') ||
        rawError.toLowerCase().contains('connection') ||
        rawError.toLowerCase().contains('timeout') ||
        rawError.toLowerCase().contains('socket') ||
        rawError.toLowerCase().contains('unreachable') ||
        rawError.contains('SocketException') ||
        rawError.contains('HttpException');
    
    // Always show localized message to user, never raw error
    final displayMessage = isNetworkError
        ? localizations.failedToLoadDataCheckConnection
        : config['fallbackMessage'] ?? localizations.somethingWentWrong;
        
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600), // Constrain width on tablets
        child: ErrorView(
          message: displayMessage,
          onRetry: () => notifier.refreshData(),
        ),
      ),
    );
  }

  /// Builds no meals layout with optional indicator - tablet optimized
  Widget _buildNoMealsLayout(BuildContext context, TodayPageState state,
      TodayPageNotifier notifier, _ViewConfiguration config) {
    if (!config.requiresIndicator) {
      return _buildNoMealsView(context, notifier, state.status);
    }

    return Column(
      children: [
        _buildStaleDataIndicator(config.indicatorMessage!, state, notifier),
        const SizedBox(height: 24), // More spacing for tablet
        _buildNoMealsView(context, notifier, state.status),
      ],
    );
  }

  /// Builds plan details layout with optional indicator - tablet optimized
  Widget _buildPlanDetailsLayout(BuildContext context, TodayPageState state,
      TodayPageNotifier notifier, _ViewConfiguration config) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isWideEnough = constraints.maxWidth > 800; // Minimum width for two-column layout
        
        return Column(
          children: [
            if (config.requiresIndicator) ...[
              _buildStaleDataIndicator(config.indicatorMessage!, state, notifier),
              const SizedBox(height: 24),
            ],
            isLandscape && isWideEnough
                ? _buildTwoColumnLayout(context, state, notifier)
                : _buildSingleColumnLayout(context, state, notifier),
          ],
        );
      },
    );
  }

  /// Builds two-column layout for landscape tablets
  Widget _buildTwoColumnLayout(BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column - Progress card
          Expanded(
            flex: 2,
            child: _buildProgressCardSection(context, state),
          ),
          const SizedBox(width: 32), // More spacing between columns
          // Right column - Meals
          Expanded(
            flex: 3,
            child: _buildMealsSection(context, state),
          ),
        ],
      ),
    );
  }

  /// Builds single column layout for portrait tablets
  Widget _buildSingleColumnLayout(BuildContext context, TodayPageState state, TodayPageNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressCardSection(context, state),
        const SizedBox(height: 32), // More spacing for tablet
        _buildMealsSection(context, state),
      ],
    );
  }

  /// Builds the progress card section
  Widget _buildProgressCardSection(BuildContext context, TodayPageState state) {
    if (state.todaysMeals == null) {
      final localizations = AppLocalizations.of(context)!;
      return Center(child: Text(localizations.errorMealDataMissing));
    }

    final totalMacros = _calculateTotalMacros(state.todaysMeals);

    return ProgressCard(
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
    );
  }

  /// Builds the meals section
  Widget _buildMealsSection(BuildContext context, TodayPageState state) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          localizations.todaysMeals,
          style: theme.textTheme.headlineMedium?.copyWith( // Larger for tablet
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20), // More spacing for tablet

        // Meal cards grid for tablet
        LayoutBuilder(
          builder: (context, constraints) {
            final isWideEnough = constraints.maxWidth > 600;
            final mealCount = state.todaysMeals!.length;
            
            if (isWideEnough && mealCount > 2) {
              // Grid layout for wider screens with multiple meals
              return _buildMealsGrid(context, state);
            } else {
              // Single column for narrow screens or few meals
              return _buildMealsList(context, state);
            }
          },
        ),
      ],
    );
  }

  /// Builds meals in a grid layout for tablets
  Widget _buildMealsGrid(BuildContext context, TodayPageState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5, // Wider cards for tablets
      ),
      itemCount: state.todaysMeals!.length,
      itemBuilder: (context, index) {
        final meal = state.todaysMeals![index];
        return _buildMealCard(meal, state);
      },
    );
  }

  /// Builds meals in a list layout
  Widget _buildMealsList(BuildContext context, TodayPageState state) {
    return Column(
      children: state.todaysMeals!.map((meal) => 
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildMealCard(meal, state),
        ),
      ).toList(),
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

  /// Builds individual meal card widget
  Widget _buildMealCard(Meal meal, TodayPageState state) {
    final isCompleted = state.isMealCompleted(meal.name);

    return MealCard(
      meal: meal,
      mealPlanId: state.mealPlanId!,
      isCompleted: isCompleted,
      imageUrl: _getMealImageUrl(meal.name),
      isLoading: false,
    );
  }

  // --- Keep Existing Helper Methods ---
  /// Meal image URL mappings
  static const Map<MealNameEnum, String> _mealImages = {
    MealNameEnum.BREAKFAST: 'assets/colazione.jpg',
    MealNameEnum.LUNCH: 'assets/pranzo.jpg',
    MealNameEnum.DINNER: 'assets/cena.png',
    MealNameEnum.SNACK_AFTERNOON: 'assets/snack-pomeridiano.png',
    MealNameEnum.SNACK_MORNING: 'assets/snack-mattino.jpg',
    MealNameEnum.SNACK_EVENING: 'assets/snack-serale.png',
  };

  /// Builds the view displayed when there are no meals scheduled for today - tablet optimized
  Widget _buildNoMealsView(BuildContext context, TodayPageNotifier notifier,
      DataStatus currentStatus) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final today = DateFormat('EEEE').format(DateTime.now());

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // Constrain width on large screens
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0), // More padding for tablet
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu_outlined,
                size: 80, // Larger icon for tablet
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 24), // More spacing
              Text(
                localizations.noMealsForToday,
                style: theme.textTheme.headlineMedium, // Larger text for tablet
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                localizations.currentMealPlanNoMealsScheduled(today),
                style: theme.textTheme.bodyLarge, // Larger body text for tablet
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32), // More spacing
              FilledButton.icon( // More prominent button for tablet
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(localizations.refreshNow),
                onPressed: () => notifier.refreshData(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
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
} // End of TodayPageTablet class