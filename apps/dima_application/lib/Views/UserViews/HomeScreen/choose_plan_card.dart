import 'dart:math'; // Import dart:math for max function

import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A card widget that prompts the user to choose a meal plan.
///
/// This widget is displayed when no meal plan is currently selected. It presents:
/// - An illustrative food icon
/// - A clear title indicating no plan is selected
/// - Descriptive text explaining the next step
/// - A call-to-action button to select a plan
///
/// The card uses the app's theme for consistent styling and maintains
/// accessibility standards with proper contrast and spacing.
class ChoosePlanCard extends StatelessWidget {
  /// Callback function executed when the "Choose a Plan" button is pressed.
  /// Must be provided to handle the user's interaction.
  final VoidCallback onChoosePlan;

  /// The percentage of the screen width to use for the card on small screens.
  /// Default is set to 90% of the screen width.
  final double smallScreenPercentage;

  /// The screen width threshold (in logical pixels) to switch between
  /// small screen percentage behavior and large screen fixed width behavior.
  /// Common values are around 600 or 720.
  final double breakpoint;

  /// The fixed width (in logical pixels) the card should have on screens
  /// equal to or wider than the breakpoint.
  final double largeScreenWidth;

  /// Creates a ChoosePlanCard widget.
  ///
  /// Parameters:
  ///   [onChoosePlan] - Required callback for handling plan selection action
  const ChoosePlanCard({
    super.key,
    required this.onChoosePlan,
    this.smallScreenPercentage = 0.9, // Default to 90%
    this.breakpoint = 600, // Default: Switch behavior at 600px width
    this.largeScreenWidth = 500, // Default: Fixed width of 400px
  });

  @override
  Widget build(BuildContext context) {
    // Access theme for consistent styling across the app
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    final mediaQueryData = MediaQuery.maybeOf(context);
    final screenWidth = mediaQueryData?.size.width ?? 0.0;

    double calculatedWidth;

    // Determine Width Logic based on breakpoint
    if (screenWidth < breakpoint) {
      // Screen is SMALLER than the breakpoint -> Use percentage
      calculatedWidth = screenWidth * smallScreenPercentage;
    } else {
      // Screen is LARGER than or equal to the breakpoint -> Use fixed large width
      calculatedWidth = largeScreenWidth;
    }

    // Ensure the final width is not negative
    final finalWidth = max(0.0, calculatedWidth);

    Widget card = Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visual indicator - Food icon
            Icon(
              Icons.ramen_dining_outlined,
              size: 50,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 20),

            // Main heading
            Text(
              localizations.noMealPlanSelected,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Explanatory text
            Text(
              localizations.selectMealPlanToStart,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),

            // Call-to-action button
            ElevatedButton.icon(
              icon: const Icon(Icons.add_task_outlined),
              label: Text(localizations.choosePlan),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: theme.textTheme.labelLarge,
              ),
              onPressed: onChoosePlan,
            )
          ],
        ),
      ),
    );

    // Wrap the card in a SizedBox to control its width
    return SizedBox(width: finalWidth, child: card);
  }
}
