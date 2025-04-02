import 'package:flutter/material.dart';
import 'circular_progress_indicator_widget.dart'; // Import the new widget

class ProgressCard extends StatefulWidget {
  final String calories;
  final double fatPercent;
  final double proteinPercent;
  final double carbPercent;
  final VoidCallback? onViewMorePressed;

  const ProgressCard({
    super.key,
    required this.calories,
    required this.fatPercent,
    required this.proteinPercent,
    required this.carbPercent,
    this.onViewMorePressed,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin { // Mixin for AnimationController vsync
  late AnimationController _controller;
  late Animation<double> _fatAnimation;
  late Animation<double> _proAnimation;
  late Animation<double> _carbAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Animation duration
    );

    // Create curved animations for smoother effect
    final curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic, // Choose a curve
     );

    // Define tweens from 0.0 to the target percentage
    _fatAnimation = Tween<double>(begin: 0.0, end: widget.fatPercent).animate(curvedAnimation);
    _proAnimation = Tween<double>(begin: 0.0, end: widget.proteinPercent).animate(curvedAnimation);
    _carbAnimation = Tween<double>(begin: 0.0, end: widget.carbPercent).animate(curvedAnimation);

    // Start the animation when the widget is initialized
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Determine colors based on theme within the build method
    final Color cardColor = Theme.of(context).cardColor; // Or colorScheme.surface
    final Color textColor = colorScheme.onSurface;
    final Color secondaryTextColor = colorScheme.onSurfaceVariant;
    final Color fatColor = colorScheme.tertiary;
    final Color proColor = colorScheme.primary;
    final Color carbColor = colorScheme.secondary;
    final Color progressBackgroundColor = colorScheme.surfaceContainerHighest;

    return Card(
      color: cardColor,
      elevation: 2.0, // Or keep your preferred elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Progress",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                TextButton(
                  onPressed: widget.onViewMorePressed,
                  child: Text(
                    'View more',
                    style: TextStyle(
                        color: colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Content Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Calories Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories',
                      style: TextStyle(color: secondaryTextColor, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: fatColor, // Color related to one of the macros
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.calories, // Use data from widget
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                // Animated Progress Indicators Section
                Row(
                  children: [
                    // Use AnimatedBuilder to listen to animation values
                    AnimatedBuilder(
                      animation: _fatAnimation,
                      builder: (context, child) {
                        return CircularProgressIndicatorWidget(
                          percent: widget.fatPercent, // Target value
                          animationValue: _fatAnimation.value, // Current value
                          label: 'Fat',
                          progressColor: fatColor,
                          backgroundColor: progressBackgroundColor,
                          centerTextColor: textColor,
                          labelTextColor: secondaryTextColor,
                        );
                      }
                    ),
                    const SizedBox(width: 15),
                    AnimatedBuilder(
                      animation: _proAnimation,
                      builder: (context, child) {
                         return CircularProgressIndicatorWidget(
                          percent: widget.proteinPercent,
                          animationValue: _proAnimation.value,
                          label: 'Pro',
                          progressColor: proColor,
                          backgroundColor: progressBackgroundColor,
                          centerTextColor: textColor,
                          labelTextColor: secondaryTextColor,
                        );
                      }
                    ),
                    const SizedBox(width: 15),
                     AnimatedBuilder(
                      animation: _carbAnimation,
                      builder: (context, child) {
                         return CircularProgressIndicatorWidget(
                          percent: widget.carbPercent,
                          animationValue: _carbAnimation.value,
                          label: 'Carb',
                          progressColor: carbColor,
                          backgroundColor: progressBackgroundColor,
                          centerTextColor: textColor,
                          labelTextColor: secondaryTextColor,
                        );
                      }
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}