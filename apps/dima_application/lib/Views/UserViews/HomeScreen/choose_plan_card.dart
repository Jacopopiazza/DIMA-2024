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

  /// Creates a ChoosePlanCard widget.
  ///
  /// Parameters:
  ///   [onChoosePlan] - Required callback for handling plan selection action
  const ChoosePlanCard({
    super.key,
    required this.onChoosePlan,
  });

  @override
  Widget build(BuildContext context) {
    // Access theme for consistent styling across the app
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
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
              "No Meal Plan Selected",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Explanatory text
            Text(
              "Select a meal plan to start tracking your daily meals and nutritional progress.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),

            // Call-to-action button
            ElevatedButton.icon(
              icon: const Icon(Icons.add_task_outlined),
              label: const Text("Choose a Plan"),
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
  }
}
