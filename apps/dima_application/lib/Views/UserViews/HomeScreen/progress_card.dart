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
        elevation: 4.0, // Increased card shadow for better visibility
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
          side: BorderSide(
            color: colorScheme.outline
                .withAlpha(76), // Subtle border color (30% opacity)
            width: 0.5, // Thin border width
          ),
        ),
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
      elevation: 4.0, // Increased card shadow for better visibility
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
        side: BorderSide(
          color: colorScheme.outline
              .withAlpha(76), // Subtle border color (30% opacity)
          width: 0.5, // Thin border width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section: Title + Calories
            Expanded(
              flex: 2, // Takes more space for content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title "Today's Progress"
                  Text(
                    localizations.todayProgress,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Calories Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.calories,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize:
                              MediaQuery.of(context).size.width < 375 ? 12 : 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: fatColor,
                            size: MediaQuery.of(context).size.width < 375
                                ? 18
                                : 20,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.calories!,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width < 375
                                        ? 12
                                        : 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12), // Spacing between sections
            // Right Section: Progress Indicators (now taller and bigger)
            Expanded(
              flex: 3, // Takes less space but full height
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final mediaQuery = MediaQuery.of(context);
                  final screenWidth = mediaQuery.size.width;

                  // Available space for indicators (full height now!)
                  final double availableWidth = constraints.maxWidth;
                  final double availableHeight = constraints.maxHeight;

                  // Enhanced screen size detection with width constraints
                  final bool isVerySmallScreen =
                      screenWidth < 375; // iPhone SE, iPhone 13 mini
                  final bool isSmallScreen =
                      screenWidth < 390; // Standard small category
                  final bool isCompactDevice =
                      availableWidth < 200; // Tight space
                  final bool isVeryCompactDevice =
                      availableWidth < 180; // Very tight space

                  // More aggressive spacing reduction for small screens
                  double minSpacing, rightPadding;
                  if (isVeryCompactDevice) {
                    minSpacing = 2.0; // Minimal spacing
                    rightPadding = 4.0;
                  } else if (isCompactDevice) {
                    minSpacing = 3.0;
                    rightPadding = 5.0;
                  } else if (isVerySmallScreen) {
                    minSpacing = 4.0;
                    rightPadding = 6.0;
                  } else if (isSmallScreen) {
                    minSpacing = 6.0;
                    rightPadding = 8.0;
                  } else {
                    minSpacing = 8.0;
                    rightPadding = 8.0;
                  }

                  final double totalSpacing = (2 * minSpacing) + rightPadding;
                  final double availableForCircles =
                      availableWidth - totalSpacing;

                  // More conservative width-based calculation
                  final double rawWidthDiameter = availableForCircles / 3;

                  // Apply screen-specific limits with safety margin
                  double maxWidthDiameter, minWidthDiameter;
                  if (isVeryCompactDevice) {
                    maxWidthDiameter = 44.0;
                    minWidthDiameter = 20.0;
                  } else if (isCompactDevice) {
                    maxWidthDiameter = 49.0;
                    minWidthDiameter = 22.0;
                  } else if (isVerySmallScreen) {
                    maxWidthDiameter = 55.0;
                    minWidthDiameter = 24.0;
                  } else if (isSmallScreen) {
                    maxWidthDiameter = 60.0;
                    minWidthDiameter = 27.0;
                  } else {
                    maxWidthDiameter = 70.0;
                    minWidthDiameter = 30.0;
                  }

                  final double widthBasedDiameter = rawWidthDiameter.clamp(
                      minWidthDiameter, maxWidthDiameter);

                  // Height-based calculation with screen-specific limits
                  double heightMultiplier = isVeryCompactDevice
                      ? 0.6
                      : (isCompactDevice
                          ? 0.65
                          : (isVerySmallScreen
                              ? 0.7
                              : (isSmallScreen ? 0.75 : 0.8)));
                  double maxHeightDiameter = isVeryCompactDevice
                      ? 49.0
                      : (isCompactDevice
                          ? 55.0
                          : (isVerySmallScreen
                              ? 60.0
                              : (isSmallScreen ? 65.0 : 75.0)));
                  double minHeightDiameter = isVeryCompactDevice
                      ? 20.0
                      : (isCompactDevice
                          ? 22.0
                          : (isVerySmallScreen
                              ? 24.0
                              : (isSmallScreen ? 27.0 : 30.0)));

                  final double heightBasedDiameter =
                      (availableHeight * heightMultiplier)
                          .clamp(minHeightDiameter, maxHeightDiameter);

                  // Use the smaller of the two to ensure it fits, with additional safety margin
                  double diameter = [widthBasedDiameter, heightBasedDiameter]
                      .reduce((a, b) => a < b ? a : b);

                  // Apply safety margin to prevent overflow
                  diameter = diameter * 0.98; // 2% safety margin

                  final double radius = diameter / 2.0;

                  // Calculate sizes based on radius with screen-specific adjustments
                  final double lineWidth = (radius * 0.15).clamp(1.5, 6.0);

                  // Font sizes optimized for screen categories with more granular control
                  double centerFontSize = radius * 0.32;
                  double labelFontSize;

                  if (isVeryCompactDevice) {
                    centerFontSize = centerFontSize.clamp(6.0, 9.0);
                    labelFontSize = (centerFontSize * 0.85).clamp(5.0, 7.5);
                  } else if (isCompactDevice) {
                    centerFontSize = centerFontSize.clamp(6.5, 10.0);
                    labelFontSize = (centerFontSize * 0.85).clamp(5.5, 8.5);
                  } else if (isVerySmallScreen) {
                    centerFontSize = centerFontSize.clamp(7.0, 11.0);
                    labelFontSize = (centerFontSize * 0.85).clamp(6.0, 9.0);
                  } else if (isSmallScreen) {
                    centerFontSize = centerFontSize.clamp(8.0, 12.0);
                    labelFontSize = (centerFontSize * 0.85).clamp(7.0, 10.0);
                  } else {
                    centerFontSize = centerFontSize.clamp(9.0, 14.0);
                    labelFontSize = (centerFontSize * 0.85).clamp(7.5, 12.0);
                  }

                  // Position indicators towards the right
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: rightPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Fat Progress Indicator
                          _buildProgressIndicator(
                            percent: widget.fatPercent!,
                            animation: _fatAnimation,
                            label: localizations.fats,
                            progressColor: fatColor,
                            backgroundColor: progressBackgroundColor,
                            centerTextColor: textColor,
                            labelTextColor: secondaryTextColor,
                            radius: radius,
                            lineWidth: lineWidth,
                            centerFontSize: centerFontSize,
                            labelFontSize: labelFontSize,
                          ),
                          SizedBox(width: minSpacing),
                          // Protein Progress Indicator
                          _buildProgressIndicator(
                            percent: widget.proteinPercent!,
                            animation: _proAnimation,
                            label: localizations.proteins,
                            progressColor: proColor,
                            backgroundColor: progressBackgroundColor,
                            centerTextColor: textColor,
                            labelTextColor: secondaryTextColor,
                            radius: radius,
                            lineWidth: lineWidth,
                            centerFontSize: centerFontSize,
                            labelFontSize: labelFontSize,
                          ),
                          SizedBox(width: minSpacing),
                          // Carbohydrates Progress Indicator
                          _buildProgressIndicator(
                            percent: widget.carbPercent!,
                            animation: _carbAnimation,
                            label: localizations.carbs,
                            progressColor: carbColor,
                            backgroundColor: progressBackgroundColor,
                            centerTextColor: textColor,
                            labelTextColor: secondaryTextColor,
                            radius: radius,
                            lineWidth: lineWidth,
                            centerFontSize: centerFontSize,
                            labelFontSize: labelFontSize,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
