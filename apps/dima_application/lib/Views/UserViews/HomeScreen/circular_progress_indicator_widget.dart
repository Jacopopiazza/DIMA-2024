import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double percent; // The actual progress value (0.0 to 1.0)
  final double radius;
  final double lineWidth;
  final String label;
  final Color progressColor;
  final Color backgroundColor;
  final Color centerTextColor;
  final Color labelTextColor;
  final double? animationValue; // Optional: For direct animation control

  const CircularProgressIndicatorWidget({
    super.key,
    required this.percent,
    required this.label,
    required this.progressColor,
    required this.backgroundColor,
    required this.centerTextColor,
    required this.labelTextColor,
    this.radius = 28.0,
    this.lineWidth = 6.0,
    this.animationValue, // Pass animation value if animating externally
  });

  @override
  Widget build(BuildContext context) {
    // Use animationValue if provided, otherwise use static percent
    final displayPercent = animationValue ?? percent;
    // Ensure percent doesn't go out of bounds during animation
    final clampedPercent = displayPercent.clamp(0.0, 1.0);

    return Column(
      children: [
        CircularPercentIndicator(
          radius: radius,
          lineWidth: lineWidth,
          percent: clampedPercent, // Use clamped animation or static value
          center: Text(
            // Always display the final target percentage text
            '${(percent * 100).toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: centerTextColor,
            ),
          ),
          progressColor: progressColor,
          backgroundColor: backgroundColor,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: labelTextColor, fontSize: 12),
        )
      ],
    );
  }
}