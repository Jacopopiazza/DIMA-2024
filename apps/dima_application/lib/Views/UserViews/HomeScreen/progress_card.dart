import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'circular_progress_indicator_widget.dart'; // Import the widget

class ProgressCard extends StatefulWidget {
  final String? calories;
  final double? fatPercent;
  final double? proteinPercent;
  final double? carbPercent;
  final bool isLoading;
  final bool isInitialLoad;

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

class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin {
  // Animation setup remains the same
  late AnimationController _animationController;
  late Animation<double> _fatAnimation;
  late Animation<double> _proAnimation;
  late Animation<double> _carbAnimation;
  bool _hasAnimated = false;

  // Store previous values to detect changes
  double? _prevFatPercent;
  double? _prevProPercent;
  double? _prevCarbPercent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Initialize previous values
    _prevFatPercent = widget.fatPercent;
    _prevProPercent = widget.proteinPercent;
    _prevCarbPercent = widget.carbPercent;

    _updateAnimations(); // Initialize with potential 0.0 targets

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.isLoading && !_hasAnimated) {
        _startAnimation();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Always update previous values after checks to preserve comparison logic
    bool shouldAnimate = false;

    // Check if loading state changed
    if (oldWidget.isLoading && !widget.isLoading && mounted && !_hasAnimated) {
      _updateAnimations(); // Update targets with real data
      shouldAnimate = true;
    } else if (!oldWidget.isLoading && widget.isLoading) {
      _resetAnimation(); // Reset if going back to loading
    }
    // Check if any percentage values changed significantly - this is the key improvement
    else if (!widget.isLoading &&
        (_significantlyDifferent(widget.fatPercent, _prevFatPercent) ||
            _significantlyDifferent(widget.proteinPercent, _prevProPercent) ||
            _significantlyDifferent(widget.carbPercent, _prevCarbPercent))) {
      _updateAnimations();
      shouldAnimate = true;
    }

    // Always update previous values
    _prevFatPercent = widget.fatPercent;
    _prevProPercent = widget.proteinPercent;
    _prevCarbPercent = widget.carbPercent;

    // Start animation if needed
    if (shouldAnimate) {
      _startAnimation();
    }
  }

  // Helper method to check if values differ enough to justify animation
  bool _significantlyDifferent(double? newValue, double? oldValue) {
    if (newValue == null || oldValue == null) return true;
    return (newValue - oldValue).abs() > 0.01; // 1% threshold
  }

  void _updateAnimations() {
    if (!mounted) return; // Good practice to keep this check
    final curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubic);

    // Always define Tweens starting from 0.0 to the current target percent
    // The controller's forward(from: 0.0) handles the visual restart.
    _fatAnimation = Tween<double>(begin: 0.0, end: widget.fatPercent ?? 0.0)
        .animate(curvedAnimation);
    _proAnimation = Tween<double>(begin: 0.0, end: widget.proteinPercent ?? 0.0)
        .animate(curvedAnimation);
    _carbAnimation = Tween<double>(begin: 0.0, end: widget.carbPercent ?? 0.0)
        .animate(curvedAnimation);
  }

  void _startAnimation() {
    if (!mounted) return;
    // Check if already animating or completed to avoid issues
    if (_animationController.isAnimating || _animationController.isCompleted) {
      _animationController.forward(from: 0.0); // Restart if needed
    } else {
      _animationController.forward();
    }
    _hasAnimated = true;
  }

  void _resetAnimation() {
    if (!mounted) return;
    _animationController.reset();
    _hasAnimated = false;
    // Crucially, also reset the animation values when resetting
    _updateAnimations(); // Re-create Tweens starting from 0
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // --- Helper to build the skeleton ---
  Widget _buildLoadingSkeleton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Use a color that fits the shimmer base/highlight scheme
    final skeletonColor = Theme.of(context).brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest.withAlpha(128)
        : Colors.grey[300]!;
    final placeholderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withAlpha(25) // Placeholder elements within skeleton
        : Colors.grey[400]!;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: skeletonColor, // Matches MealCard skeleton bg
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 18, color: placeholderColor),
            ],
          ),
          const SizedBox(height: 15),
          // Content Row Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Calories Skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 60, height: 14, color: placeholderColor),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 24, color: placeholderColor),
                ],
              ),
              // Indicators Skeleton
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: placeholderColor, shape: BoxShape.circle),
                      width: 56,
                      height: 56),
                  const SizedBox(width: 15),
                  Container(
                      decoration: BoxDecoration(
                          color: placeholderColor, shape: BoxShape.circle),
                      width: 56,
                      height: 56),
                  const SizedBox(width: 15),
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
  // --- End of skeleton helper ---

  // Helper method to build a progress indicator
  Widget _buildProgressIndicator({
    required double percent,
    required Animation<double> animation,
    required String label,
    required Color progressColor,
    required Color backgroundColor,
    required Color centerTextColor,
    required Color labelTextColor,
    required double radius,
    required double lineWidth,
    required double centerFontSize,
    required double labelFontSize,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (ctx, ch) => CircularProgressIndicatorWidget(
        percent: percent,
        animationValue: animation.value,
        label: label,
        progressColor: progressColor,
        backgroundColor: backgroundColor,
        centerTextColor: centerTextColor,
        labelTextColor: labelTextColor,
        fixedRadius: radius,
        fixedLineWidth: lineWidth,
        fixedCenterFontSize: centerFontSize,
        fixedLabelFontSize: labelFontSize,
        //semanticsLabel: '$label ${(animation.value * 100).toInt()}%',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color cardColor = Theme.of(context).cardColor;
    final Color textColor = colorScheme.onSurface;
    final Color secondaryTextColor = colorScheme.onSurfaceVariant;
    final Color fatColor = colorScheme.tertiary;
    final Color proColor = colorScheme.primary;
    final Color carbColor = colorScheme.secondary;
    final Color progressBackgroundColor = colorScheme.surfaceContainerHighest;

    final localizations = AppLocalizations.of(context)!;

    if (widget.isInitialLoad && widget.calories == null) {
      // Show loading skeleton if initial load and no data
      return _buildLoadingSkeleton(context);
    }

    // Improved error state with consistent design
    if (widget.calories == null ||
        widget.fatPercent == null ||
        widget.proteinPercent == null ||
        widget.carbPercent == null) {
      return Card(
        color: cardColor,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: secondaryTextColor,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No progress data available",
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      color: cardColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (same as before)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.todayProgress,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 10), // Add some space after title
            // Content Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align items vertically
              children: [
                // Calories Section (same as before)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically if needed
                  children: [
                    Text(
                      localizations.calories,
                      style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 16), // Slightly smaller?
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: fatColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.calories!,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                    width: 10), // Add spacing between calories and indicators

                // --- Progress Indicators Section ---
                Expanded(
                  // Takes remaining space
                  child: LayoutBuilder(
                    // Gets width available for indicators
                    builder: (context, constraints) {
                      // --- Calculate proportional sizes ---
                      final double totalIndicatorWidth = constraints.maxWidth;

                      // Estimate diameter per indicator (leaving space)
                      // Adjust the multiplier (e.g., 0.28-0.3) based on desired spacing
                      final double diameter = (totalIndicatorWidth * 0.28)
                          .clamp(30.0, 90.0); // e.g. min 30, max 90 diameter
                      final double radius = diameter / 2.0;

                      // Calculate derived sizes, also clamped for sanity
                      final double lineWidth =
                          (radius * 0.18).clamp(3.0, 12.0); // min 3, max 12
                      final double centerFontSize =
                          (radius * 0.38).clamp(9.0, 18.0); // min 9, max 18
                      final double labelFontSize =
                          centerFontSize * 0.9; // Label slightly smaller

                      return Row(
                        // Use spaceEvenly or spaceBetween depending on visual preference
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
