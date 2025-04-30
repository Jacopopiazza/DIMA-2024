import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'circular_progress_indicator_widget.dart'; // Import the custom circular progress indicator widget

/// A stateful widget that displays a card showing daily progress for calories
/// and macronutrient percentages (Fat, Protein, Carbs).
///
/// This card includes:
/// - A title for "Today's Progress".
/// - Display of total calories consumed.
/// - Animated circular progress indicators for Fat, Protein, and Carbs percentages.
/// - Support for loading states, including an initial loading skeleton.
/// - An error state display if data is missing.
///
/// The progress indicators animate when the data changes or after initial load.
class ProgressCard extends StatefulWidget {
  /// The total calories consumed for the day, as a formatted string.
  final String? calories;

  /// The percentage of daily Fat consumed (0.0 to 1.0).
  final double? fatPercent;

  /// The percentage of daily Protein consumed (0.0 to 1.0).
  final double? proteinPercent;

  /// The percentage of daily Carbohydrates consumed (0.0 to 1.0).
  final double? carbPercent;

  /// Flag to indicate if the card is currently in a loading state (shows skeleton if isInitialLoad is also true).
  final bool isLoading;

  /// Flag to indicate if this is the very first load, used to determine if the skeleton should be shown.
  final bool isInitialLoad;

  /// Creates a ProgressCard widget.
  ///
  /// Parameters:
  ///   [calories] - Optional string representing total calories.
  ///   [fatPercent] - Optional double for fat percentage (0.0-1.0).
  ///   [proteinPercent] - Optional double for protein percentage (0.0-1.0).
  ///   [carbPercent] - Optional double for carb percentage (0.0-1.0).
  ///   [isLoading] - Optional flag for general loading state (defaults to false).
  ///   [isInitialLoad] - Optional flag for initial loading state (defaults to false).
  const ProgressCard({
    super.key,
    this.calories,
    this.fatPercent,
    this.proteinPercent,
    this.carbPercent,
    this.isLoading = false,
    this.isInitialLoad = false,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

/// The state class for the ProgressCard widget.
///
/// Manages the animation controller and animations for the progress indicators,
/// and handles state updates based on new data or loading status changes.
class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin {
  // Animation setup for the circular progress indicators.
  late AnimationController _animationController;
  late Animation<double> _fatAnimation;
  late Animation<double> _proAnimation;
  late Animation<double> _carbAnimation;

  // Flag to track if the initial animation has been performed.
  bool _hasAnimated = false;

  // Store previous percentage values to detect significant changes for re-animation.
  double? _prevFatPercent;
  double? _prevProPercent;
  double? _prevCarbPercent;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller.
    _animationController = AnimationController(
      vsync: this, // Use the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 1200), // Duration of the animation
    );

    // Initialize previous values with the widget's initial values.
    _prevFatPercent = widget.fatPercent;
    _prevProPercent = widget.proteinPercent;
    _prevCarbPercent = widget.carbPercent;

    // Set up the animations, initially targeting 0.0 if data is null, or the actual value.
    _updateAnimations();

    // Schedule a post-frame callback to start the animation after the first build
    // if not loading and hasn't animated yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.isLoading && !_hasAnimated) {
        _startAnimation();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Flag to determine if animation should be triggered after updates.
    bool shouldAnimate = false;

    // Check if the loading state has just finished.
    if (oldWidget.isLoading && !widget.isLoading && mounted && !_hasAnimated) {
      _updateAnimations(); // Update animation targets with the new, loaded data.
      shouldAnimate = true; // Trigger animation.
    }
    // Check if the widget is transitioning into a loading state.
    else if (!oldWidget.isLoading && widget.isLoading) {
      _resetAnimation(); // Reset animation if going back to loading.
    }
    // Check if the widget is not loading and any of the percentage values have
    // changed significantly since the last update. This is key for re-animating
    // when data is updated while the card is already displayed.
    else if (!widget.isLoading &&
        (_significantlyDifferent(widget.fatPercent, _prevFatPercent) ||
            _significantlyDifferent(widget.proteinPercent, _prevProPercent) ||
            _significantlyDifferent(widget.carbPercent, _prevCarbPercent))) {
      _updateAnimations(); // Update animation targets with the new values.
      shouldAnimate = true; // Trigger animation.
    }

    // Always update the previous values to the current widget values for the next comparison.
    _prevFatPercent = widget.fatPercent;
    _prevProPercent = widget.proteinPercent;
    _prevCarbPercent = widget.carbPercent;

    // Start the animation if the 'shouldAnimate' flag is true.
    if (shouldAnimate) {
      _startAnimation();
    }
  }

  /// Helper method to check if two double values differ by more than a small threshold.
  /// Used to avoid unnecessary re-animations for minor floating-point variations.
  bool _significantlyDifferent(double? newValue, double? oldValue) {
    // If either value is null, consider them significantly different (e.g., transitioning from no data).
    if (newValue == null || oldValue == null) return true;
    // Check if the absolute difference is greater than a small threshold (e.g., 0.01 or 1%).
    return (newValue - oldValue).abs() > 0.01; // 1% threshold
  }

  /// Updates the animation tweens to target the current percentage values.
  ///
  /// This method is called when data is loaded or updated. It ensures the
  /// animations will go from 0.0 to the new target percentages.
  void _updateAnimations() {
    if (!mounted) return; // Ensure the widget is still in the widget tree.
    // Create a curved animation for smoother transitions.
    final curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubic);

    // Define Tweens for each macronutrient animation.
    // The animation will go from 0.0 to the current widget percentage (or 0.0 if null).
    _fatAnimation = Tween<double>(begin: 0.0, end: widget.fatPercent ?? 0.0)
        .animate(curvedAnimation);
    _proAnimation = Tween<double>(begin: 0.0, end: widget.proteinPercent ?? 0.0)
        .animate(curvedAnimation);
    _carbAnimation = Tween<double>(begin: 0.0, end: widget.carbPercent ?? 0.0)
        .animate(curvedAnimation);
  }

  /// Starts or restarts the animation controller.
  void _startAnimation() {
    if (!mounted) return; // Ensure the widget is still in the widget tree.
    // Check if the controller is already animating or completed.
    if (_animationController.isAnimating || _animationController.isCompleted) {
      // If already animating or completed, restart from the beginning.
      _animationController.forward(from: 0.0);
    } else {
      // Otherwise, start the animation from the current position (usually 0.0).
      _animationController.forward();
    }
    _hasAnimated = true; // Mark that the animation has been triggered.
  }

  /// Resets the animation controller and state.
  ///
  /// This is typically called when the widget transitions back to a loading state.
  void _resetAnimation() {
    if (!mounted) return; // Ensure the widget is still in the widget tree.
    _animationController.reset(); // Reset the controller to the beginning.
    _hasAnimated = false; // Reset the animated flag.
    // Re-create the Tweens starting from 0.0 to ensure the next animation starts correctly.
    _updateAnimations();
  }

  @override
  void dispose() {
    // Dispose the animation controller to prevent memory leaks.
    _animationController.dispose();
    super.dispose();
  }

  // --- Helper method to build the loading skeleton UI ---
  /// Builds a placeholder widget that mimics the card's structure while data is loading.
  Widget _buildLoadingSkeleton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Determine colors for the skeleton background and placeholder elements based on theme.
    final skeletonColor = Theme.of(context).brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest
            .withAlpha(128) // Muted dark background
        : Colors.grey[300]!; // Light grey background
    final placeholderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
            .withAlpha(25) // Very subtle white for elements in dark mode
        : Colors.grey[400]!; // Slightly darker grey for elements in light mode

    return Container(
      padding:
          const EdgeInsets.all(16.0), // Padding inside the skeleton container
      decoration: BoxDecoration(
        color: skeletonColor, // Background color of the skeleton
        borderRadius:
            BorderRadius.circular(15.0), // Rounded corners matching the card
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start (left)
        children: [
          // Header Row Skeleton (simulates the "Today's Progress" title area)
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space out children
            children: [
              // Placeholder container for the title text
              Container(width: 150, height: 18, color: placeholderColor),
            ],
          ),
          const SizedBox(height: 15), // Space between header and content
          // Content Row Skeleton (simulates the calories and progress indicators area)
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space out children
            crossAxisAlignment:
                CrossAxisAlignment.center, // Vertically center children
            children: [
              // Calories Section Skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align children to the start (left)
                children: [
                  // Placeholder for the "Calories" label
                  Container(width: 60, height: 14, color: placeholderColor),
                  const SizedBox(height: 8), // Space between label and value
                  // Placeholder for the calorie value
                  Container(width: 80, height: 24, color: placeholderColor),
                ],
              ),
              // Indicators Skeleton (simulates the circular progress indicators)
              Row(
                children: [
                  // Placeholder circle for Fat indicator
                  Container(
                      decoration: BoxDecoration(
                          color: placeholderColor, shape: BoxShape.circle),
                      width: 56,
                      height: 56),
                  const SizedBox(width: 15), // Space between indicators
                  // Placeholder circle for Protein indicator
                  Container(
                      decoration: BoxDecoration(
                          color: placeholderColor, shape: BoxShape.circle),
                      width: 56,
                      height: 56),
                  const SizedBox(width: 15), // Space between indicators
                  // Placeholder circle for Carbs indicator
                  Container(
                      decoration: BoxDecoration(
                          color: placeholderColor, shape: BoxShape.circle),
                      width: 56,
                      height: 56),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  // --- End of skeleton helper method ---

  // Helper method to build a single circular progress indicator widget.
  /// Configures and returns an `AnimatedBuilder` wrapping the `CircularProgressIndicatorWidget`.
  ///
  /// This allows the `CircularProgressIndicatorWidget` to rebuild whenever the
  /// provided animation updates, showing the progress animation.
  Widget _buildProgressIndicator({
    required double percent, // The target percentage (0.0 to 1.0)
    required Animation<double> animation, // The animation controlling the value
    required String label, // The label for the indicator (e.g., "Fats")
    required Color progressColor, // Color of the progress arc
    required Color backgroundColor, // Color of the background circle
    required Color
        centerTextColor, // Color of the text in the center (percentage)
    required Color labelTextColor, // Color of the label text below the circle
    required double radius, // Radius of the circular indicator
    required double lineWidth, // Width of the progress line
    required double centerFontSize, // Font size for the percentage text
    required double labelFontSize, // Font size for the label text
  }) {
    return AnimatedBuilder(
      animation: animation, // Rebuilds when the animation changes value
      builder: (ctx, ch) => CircularProgressIndicatorWidget(
        percent: percent, // Pass the target percentage
        animationValue: animation
            .value, // Pass the current animation value (0.0 to percent)
        label: label, // Pass the label
        progressColor: progressColor, // Pass the progress color
        backgroundColor: backgroundColor, // Pass the background color
        centerTextColor: centerTextColor, // Pass the center text color
        labelTextColor: labelTextColor, // Pass the label text color
        fixedRadius: radius, // Pass the calculated radius
        fixedLineWidth: lineWidth, // Pass the calculated line width
        fixedCenterFontSize:
            centerFontSize, // Pass the calculated center font size
        fixedLabelFontSize:
            labelFontSize, // Pass the calculated label font size
        // Optional: Add semantics label for accessibility
        // semanticsLabel: '$label ${(animation.value * 100).toInt()}%',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access theme and color scheme for consistent styling.
    final colorScheme = Theme.of(context).colorScheme;
    final Color cardColor =
        Theme.of(context).cardColor; // Background color of the Card
    final Color textColor = colorScheme.onSurface; // Primary text color
    final Color secondaryTextColor =
        colorScheme.onSurfaceVariant; // Secondary text color
    // Define specific colors for each macronutrient indicator.
    final Color fatColor = colorScheme.tertiary;
    final Color proColor = colorScheme.primary;
    final Color carbColor = colorScheme.secondary;
    final Color progressBackgroundColor = colorScheme
        .surfaceContainerHighest; // Background color for the progress circles

    // Access localization delegate for translated strings.
    final localizations = AppLocalizations.of(context)!;

    // --- Conditional Rendering based on State ---

    // Show loading skeleton if it's the initial load and data is not yet available.
    if (widget.isInitialLoad && widget.calories == null) {
      return _buildLoadingSkeleton(context);
    }

    // Show an error state card if essential data is missing after initial load.
    if (widget.calories == null ||
        widget.fatPercent == null ||
        widget.proteinPercent == null ||
        widget.carbPercent == null) {
      return Card(
        color: cardColor, // Card background color
        elevation: 2.0, // Card shadow
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)), // Rounded corners
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 24.0), // Vertical padding for content
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Column takes minimum vertical space
                children: [
                  // Error icon
                  Icon(
                    Icons.error_outline_rounded,
                    color: secondaryTextColor, // Color for the icon
                    size: 36, // Size of the icon
                  ),
                  const SizedBox(height: 12), // Space between icon and text
                  // Error message text
                  Text(
                    "No progress data available", // Hardcoded error message (could be localized)
                    style: TextStyle(
                      color: secondaryTextColor, // Color for the error text
                      fontSize: 16, // Font size for the error text
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // --- Main Content Display (when data is available) ---

    return Card(
      color: cardColor, // Card background color
      elevation: 2.0, // Card shadow
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)), // Rounded corners
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the start (left)
          children: [
            // Header Row: Contains the title "Today's Progress"
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Space out children (though only one child here)
              children: [
                Text(
                  localizations.todayProgress, // Localized title text
                  style: TextStyle(
                      fontSize: 18, // Font size for the title
                      fontWeight: FontWeight.bold, // Bold font weight
                      color: textColor), // Text color
                ),
              ],
            ),
            const SizedBox(height: 10), // Add some space after the title
            // Content Row: Contains the Calories section and the Progress Indicators section
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Space out the two main sections
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Vertically align items in the row
              children: [
                // Calories Section: Displays the calorie icon and value
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align children to the start (left)
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Vertically center children within the column
                  children: [
                    // "Calories" label
                    Text(
                      localizations.calories, // Localized label
                      style: TextStyle(
                          color: secondaryTextColor, // Muted text color
                          fontSize: 16), // Font size
                    ),
                    const SizedBox(
                        height: 5), // Space between label and value row
                    // Row containing calorie icon and value
                    Row(
                      children: [
                        // Calorie icon
                        Icon(
                          Icons.local_fire_department_rounded,
                          color:
                              fatColor, // Using fatColor for the calorie icon color
                          size: 20, // Icon size
                        ),
                        const SizedBox(width: 4), // Space between icon and text
                        // Calorie value text
                        Text(
                          widget
                              .calories!, // Display the calorie value (non-null assertion used as handled above)
                          style: TextStyle(
                              fontSize: 18, // Font size
                              fontWeight: FontWeight.bold, // Bold font weight
                              color: textColor), // Text color
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                    width:
                        10), // Add spacing between the Calories section and the Indicators section

                // --- Progress Indicators Section ---
                Expanded(
                  // This section takes up the remaining horizontal space in the Row
                  child: LayoutBuilder(
                    // Use LayoutBuilder to get the available width for the indicators
                    builder: (context, constraints) {
                      // --- Calculate proportional sizes for indicators based on available width ---
                      final double totalIndicatorWidth = constraints.maxWidth;

                      // Estimate the diameter for each indicator.
                      // The multiplier (0.28) is a heuristic to leave some space between indicators.
                      // The clamp ensures the diameter stays within a reasonable range.
                      final double diameter = (totalIndicatorWidth * 0.28)
                          .clamp(30.0, 90.0); // e.g. min 30, max 90 diameter
                      final double radius =
                          diameter / 2.0; // Radius is half the diameter

                      // Calculate derived sizes (line width, font sizes) based on the radius.
                      // Clamping is used again to keep sizes within reasonable bounds.
                      final double lineWidth =
                          (radius * 0.18).clamp(3.0, 12.0); // min 3, max 12
                      final double centerFontSize =
                          (radius * 0.38).clamp(9.0, 18.0); // min 9, max 18
                      final double labelFontSize = centerFontSize *
                          0.9; // Label font size slightly smaller than center

                      // Row containing the three circular progress indicators
                      return Row(
                        // Distribute space evenly between and around the indicators
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Fat Progress Indicator
                          _buildProgressIndicator(
                            percent: widget.fatPercent!, // Target percentage
                            animation: _fatAnimation, // Animation controller
                            label: localizations.fats, // Localized label
                            progressColor:
                                fatColor, // Color for the progress arc
                            backgroundColor:
                                progressBackgroundColor, // Background circle color
                            centerTextColor:
                                textColor, // Color for the percentage text
                            labelTextColor:
                                secondaryTextColor, // Color for the label text
                            radius: radius, // Calculated radius
                            lineWidth: lineWidth, // Calculated line width
                            centerFontSize:
                                centerFontSize, // Calculated center font size
                            labelFontSize:
                                labelFontSize, // Calculated label font size
                          ),
                          // Protein Progress Indicator
                          _buildProgressIndicator(
                            percent:
                                widget.proteinPercent!, // Target percentage
                            animation: _proAnimation, // Animation controller
                            label: localizations.proteins, // Localized label
                            progressColor:
                                proColor, // Color for the progress arc
                            backgroundColor:
                                progressBackgroundColor, // Background circle color
                            centerTextColor:
                                textColor, // Color for the percentage text
                            labelTextColor:
                                secondaryTextColor, // Color for the label text
                            radius: radius, // Calculated radius
                            lineWidth: lineWidth, // Calculated line width
                            centerFontSize:
                                centerFontSize, // Calculated center font size
                            labelFontSize:
                                labelFontSize, // Calculated label font size
                          ),
                          // Carbohydrates Progress Indicator
                          _buildProgressIndicator(
                            percent: widget.carbPercent!, // Target percentage
                            animation: _carbAnimation, // Animation controller
                            label: localizations.carbs, // Localized label
                            progressColor:
                                carbColor, // Color for the progress arc
                            backgroundColor:
                                progressBackgroundColor, // Background circle color
                            centerTextColor:
                                textColor, // Color for the percentage text
                            labelTextColor:
                                secondaryTextColor, // Color for the label text
                            radius: radius, // Calculated radius
                            lineWidth: lineWidth, // Calculated line width
                            centerFontSize:
                                centerFontSize, // Calculated center font size
                            labelFontSize:
                                labelFontSize, // Calculated label font size
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
