import 'package:dima_application/Utils/localization_helpers.dart';
import 'package:dima_application/generated/flutter-models/Ingredient.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/today_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealDetailsDraggablePage extends ConsumerWidget {
  // Constants for UI measurements
  static const double _cardOverlap = 30.0;
  static const double _handleHeight = 5.0;
  static const double _handleWidth = 40.0;
  static const double _buttonHeight = 50.0;
  static const BorderRadius _sheetBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  final Meal meal;
  final String mealPlanId;
  final String defaultImageUrl = 'https://i.imgur.com/Vrt2j1I.jpeg';

  const MealDetailsDraggablePage({
    super.key,
    required this.meal,
    required this.mealPlanId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Use the meal's image if available, otherwise use the default
    final String imageUrl = _getMealImageUrl(meal.name);

    // Watch the completion status to update the UI accordingly
    final todayPageState = ref.watch(todayPageProvider);
    final bool isMealCompleted = todayPageState
            .dailyCompletion?.completedMealNames
            .contains(meal.name) ??
        false;

    // Calculations for draggable sheet
    final double imageHeight = screenSize.height * 0.40;
    final double initialSheetHeight =
        screenSize.height - (imageHeight - _cardOverlap);
    final double initialSheetFraction =
        (initialSheetHeight / screenSize.height).clamp(0.3, 0.9);
    final double minSheetFraction = initialSheetFraction;
    final double maxSheetFraction = 1.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: <Widget>[
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(Icons.broken_image_outlined,
                        color: colorScheme.outline, size: 40),
                  ),
                );
              },
            ),
          ),

          // Draggable Sheet
          DraggableScrollableSheet(
            initialChildSize: initialSheetFraction,
            minChildSize: minSheetFraction,
            maxChildSize: maxSheetFraction,
            snap: true,
            snapSizes: [minSheetFraction, maxSheetFraction],
            shouldCloseOnMinExtent: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return _buildContentSheet(
                  context,
                  scrollController,
                  isMealCompleted,
                  ref,
                  safeAreaPadding,
                  textTheme,
                  colorScheme);
            },
          ),

          // App Bar Icons
          _buildAppBarIcons(context, safeAreaPadding),
        ],
      ),
    );
  }

  Widget _buildContentSheet(
      BuildContext context,
      ScrollController scrollController,
      bool isMealCompleted,
      WidgetRef ref,
      EdgeInsets safeAreaPadding,
      TextTheme textTheme,
      ColorScheme colorScheme) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: _sheetBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.zero,
        children: [
          // Overlap space and handle
          SizedBox(height: _cardOverlap + 10),

          // Grabber Handle
          Center(
            child: Container(
              height: _handleHeight,
              width: _handleWidth,
              margin: const EdgeInsets.only(bottom: 15.0),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withAlpha(100),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // Meal Title
                Text(
                  localizeMealName(context, meal.name),
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),

                // Nutrition Info
                _buildNutritionInfo(context, meal.totalMacros),
                const SizedBox(height: 24),

                // Ingredients Title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.ingredients,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Ingredients List
          ...meal.ingredients
              .map((ingredient) => _buildIngredientItem(context, ingredient)),

          const SizedBox(height: 24),

          // Recipe Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // Recipe Title
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizations.recipe,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    )),
                const SizedBox(height: 20),

                // Recipe Content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    meal.recipe ?? localizations.noRecipe,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),

          // Meal Done Button
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 25.0, bottom: 10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Use the existing provider to toggle meal status
                ref
                    .read(todayPageProvider.notifier)
                    .toggleMealCompletion(meal.name, mealPlanId);
              },
              icon: Icon(
                isMealCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: colorScheme.onPrimary,
              ),
              label: Text(isMealCompleted
                  ? localizations.mealCompleted
                  : localizations.mealToBeCompleted),
              style: ElevatedButton.styleFrom(
                backgroundColor: isMealCompleted
                    ? colorScheme.primary.withAlpha(204)
                    : colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: Size(double.infinity, _buttonHeight),
                textStyle:
                    textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 2,
              ),
            ),
          ),

          // Bottom safe area padding
          SizedBox(height: safeAreaPadding.bottom + 10),
        ],
      ),
    );
  }

  Widget _buildAppBarIcons(BuildContext context, EdgeInsets safeAreaPadding) {
    final localizations = AppLocalizations.of(context)!;
    return Positioned(
      top: safeAreaPadding.top,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              tooltip: localizations.back,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withAlpha(100),
                padding: const EdgeInsets.all(8),
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods (same as before, not modified for brevity)
  Widget _buildNutritionInfo(BuildContext context, Macros totalMacros) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: _buildNutritionItem(
                context,
                totalMacros.calories.toStringAsFixed(0),
                'kcal',
                localizations.energy)),
        Flexible(
            child: _buildNutritionItem(
                context,
                totalMacros.proteins.toStringAsFixed(1),
                'g',
                localizations.proteins)),
        Flexible(
            child: _buildNutritionItem(
                context,
                totalMacros.carbohydrates.toStringAsFixed(1),
                'g',
                localizations.carbs)),
        Flexible(
            child: _buildNutritionItem(context,
                totalMacros.fats.toStringAsFixed(1), 'g', localizations.carbs)),
      ],
    );
  }

  Widget _buildNutritionItem(
      BuildContext context, String value, String unit, String label) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold, color: colorScheme.primary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          unit,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.bodyMedium
              ?.copyWith(color: colorScheme.onSurfaceVariant),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildIngredientItem(BuildContext context, Ingredient ingredient) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final String amountString = ingredient.amount == ingredient.amount.round()
        ? '${ingredient.amount.round()}g'
        : '${ingredient.amount.toStringAsFixed(1)}g';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ingredient.name,
              style:
                  textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amountString,
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  /// Returns an image URL string for a given meal type.
  ///
  /// Uses Unsplash images for specific meal types and a placeholder for others.
  String _getMealImageUrl(MealNameEnum meal) {
    const baseUrl = 'assets/';
    switch (meal) {
      case MealNameEnum.BREAKFAST:
        return '${baseUrl}colazione.jpg';
      case MealNameEnum.LUNCH:
        return '${baseUrl}pranzo.jpg';
      case MealNameEnum.DINNER:
        return '${baseUrl}cena.png';
      case MealNameEnum.SNACK_AFTERNOON:
        return '${baseUrl}snack-pomeridiano.png';
      case MealNameEnum.SNACK_MORNING:
        return '${baseUrl}snack-mattino.jpg';
      case MealNameEnum.SNACK_EVENING:
        return '${baseUrl}snack-serale.png';
    }
  }
}
