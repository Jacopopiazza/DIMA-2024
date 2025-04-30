import 'dart:math';

import 'package:flutter/material.dart';

/// A widget that displays an error message within a styled card.
///
/// This widget is shown when data fetching fails. It presents:
/// - An error icon
/// - A clear title indicating the failure
/// - The specific error message
/// - A retry button to attempt the action again
///
/// The card uses the app's theme for consistent styling and follows
/// the visual structure of the `ChoosePlanCard`.
class ErrorView extends StatelessWidget {
  /// The specific error message to display.
  final String message;

  /// Callback function executed when the "Retry" button is pressed.
  final VoidCallback onRetry;

  /// The percentage of the screen width to use for the card.
  /// This allows the card to adapt to different screen sizes.
  /// Default is set to 90% of the screen width.
  final double smallScreenPercentage;

  /// The screen width threshold (in logical pixels) to switch between
  /// small screen percentage behavior and large screen fixed width behavior.
  /// Common values are around 600 or 720.
  final double breakpoint;

  /// The fixed width (in logical pixels) the card should have on screens
  /// equal to or wider than the breakpoint.
  final double largeScreenWidth;

  /// Creates an ErrorView widget.
  ///
  /// Parameters:
  ///   [message] - Required error message text
  ///   [onRetry] - Required callback for handling the retry action
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.smallScreenPercentage = 0.9, // Default to 90%
    this.breakpoint = 600, // Default: Switch behavior at 600px width
    this.largeScreenWidth = 500, // Default: Fixed width of 400px
  });

  @override
  Widget build(BuildContext context) {
    // Access theme for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final mediaQueryData = MediaQuery.maybeOf(context);
    final screenWidth = mediaQueryData?.size.width ?? 0.0;

    double calculatedWidth;

    // --- Determine Width Logic ---
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
      elevation: 3.0, // Similar elevation to ChoosePlanCard
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Similar shape to ChoosePlanCard
      ),
      child: Padding(
        // Adjust padding to match ChoosePlanCard's style
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Ensure the card only takes necessary vertical space
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error Icon
            Icon(
              Icons.error_outline,
              size: 50, // Match icon size
              color: colorScheme.error, // Use theme error color
            ),
            const SizedBox(height: 20), // Match spacing

            // Main heading
            Text(
              "Failed to Load Data",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, // Make title bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12), // Match spacing

            // Specific error message
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme
                    .onSurfaceVariant, // Use a slightly muted text color
              ),
            ),
            const SizedBox(height: 28), // Match spacing

            // Retry Button
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              // Apply similar button styling
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: theme.textTheme.labelLarge,
                // Optional: Match button color scheme if needed
                // backgroundColor: colorScheme.primary,
                // foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: onRetry, // Execute the passed-in callback
            )
          ],
        ),
      ),
    );

    return SizedBox(width: finalWidth, child: card);
  }
}
