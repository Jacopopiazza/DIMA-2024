import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// A customizable circular progress indicator widget that displays both a percentage
/// and a label.
///
/// This widget creates a circular progress indicator with configurable colors,
/// sizes, and animations. It displays a percentage in the center and a label
/// underneath.
class CircularProgressIndicatorWidget extends StatelessWidget {
  // Required parameters
  final double percent; // Progress value (0.0 to 1.0)
  final String label; // Text label shown below the indicator
  final Color progressColor; // Color of the progress arc
  final Color backgroundColor; // Color of the unfilled circle
  final Color centerTextColor; // Color of the percentage text
  final Color labelTextColor; // Color of the label text

  // Optional parameters
  final double?
      animationValue; // Current animation value for smooth transitions

  // Fixed size parameters (typically provided by parent)
  final double? fixedRadius; // Outer radius of the circle
  final double? fixedLineWidth; // Thickness of the progress line
  final double? fixedCenterFontSize; // Font size of the center percentage
  final double? fixedLabelFontSize; // Font size of the label text

  const CircularProgressIndicatorWidget({
    super.key,
    required this.percent,
    required this.label,
    required this.progressColor,
    required this.backgroundColor,
    required this.centerTextColor,
    required this.labelTextColor,
    this.animationValue,
    this.fixedRadius,
    this.fixedLineWidth,
    this.fixedCenterFontSize,
    this.fixedLabelFontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Use animation value if provided, otherwise use static percent
    final displayPercent = animationValue ?? percent;
    // Ensure the percentage stays between 0 and 100%
    final clampedPercent = displayPercent.clamp(0.0, 1.0);

    // Calculate sizes with sensible defaults if fixed values aren't provided
    final double radius = fixedRadius ?? 35.0;
    final double lineWidth = fixedLineWidth ?? radius * 0.18;
    final double centerFontSize = fixedCenterFontSize ?? radius * 0.4;
    final double labelFontSize = fixedLabelFontSize ?? centerFontSize * 0.9;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular progress indicator
        CircularPercentIndicator(
          radius: radius,
          lineWidth: lineWidth,
          percent: clampedPercent,
          center: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${(percent * 100).toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: centerFontSize,
                color: centerTextColor,
              ),
            ),
          ),
          progressColor: progressColor,
          backgroundColor: backgroundColor,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 3),
        // Label text with better overflow handling
        Container(
          width: radius * 2.4, // Ensure enough space for the text
          constraints: BoxConstraints(maxWidth: radius * 2.4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: labelTextColor,
                fontSize: labelFontSize,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
