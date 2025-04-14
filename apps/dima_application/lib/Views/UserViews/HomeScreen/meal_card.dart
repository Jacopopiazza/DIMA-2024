import 'package:dima_application/Views/UserViews/MealScreen/meal_details_view.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:flutter/material.dart';

/// A card widget that displays meal information with loading states and completion status
class MealCard extends StatelessWidget {
  // Core properties
  final Meal meal;
  final bool isCompleted;
  final bool isLoading;
  final String? imageUrl;

  const MealCard({
    super.key,
    required this.meal,
    required this.isCompleted,
    this.isLoading = false,
    this.imageUrl,
  });

  /// Creates a loading skeleton version of the card
  static Widget loading(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? Colors.grey[850]! : Colors.grey[300]!;
    final skeletonColor =
        isDarkMode ? Colors.white.withAlpha(25) : Colors.grey[400]!;

    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [baseColor.withAlpha(200), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          // Title placeholder
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(width: 100, height: 20, color: skeletonColor),
          ),
          // Completion status placeholder
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: skeletonColor.withAlpha(128), shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Default to placeholder image if no image URL provided
    final String displayImageUrl = imageUrl ??
        'https://via.placeholder.com/600x250.png/grey/white?text=Meal';

    // Configure completion status styling
    final IconData statusIconData =
        isCompleted ? Icons.check_circle : Icons.check_circle_outline;
    final Color iconColor = isCompleted
        ? colorScheme.primary
        : colorScheme.onSurface.withAlpha(253);
    final Color iconBackgroundColor = isCompleted
        ? colorScheme.surface.withAlpha(217)
        : Colors.black.withAlpha(90);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isLoading ? 0 : 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MealDetailsDraggablePage(meal: meal)),
        ),
        child: Ink(
          color: Colors.transparent,
          height: 180,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              // Meal image with loading and error states
              _buildMealImage(displayImageUrl, colorScheme),

              // Gradient overlay for better text readability
              _buildGradientOverlay(),

              // Meal title
              _buildMealTitle(),

              // Completion status indicator
              _buildCompletionStatus(
                  iconBackgroundColor, statusIconData, iconColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the meal image with loading and error handling
  Widget _buildMealImage(String url, ColorScheme colorScheme) {
    return Image.network(
      url,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildImageLoadingIndicator(colorScheme, loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildImageErrorPlaceholder(colorScheme);
      },
    );
  }

  /// Builds loading indicator for image
  Widget _buildImageLoadingIndicator(
      ColorScheme colorScheme, ImageChunkEvent loadingProgress) {
    return Container(
      height: 180,
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  /// Builds error placeholder for failed image loads
  Widget _buildImageErrorPlaceholder(ColorScheme colorScheme) {
    return Container(
      height: 180,
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: colorScheme.onSurfaceVariant.withAlpha(153),
          size: 40,
        ),
      ),
    );
  }

  /// Builds gradient overlay for better text contrast
  Widget _buildGradientOverlay() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withAlpha(179), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  /// Builds the meal title with styling
  Widget _buildMealTitle() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        meal.name.substring(0, 1).toUpperCase() + meal.name.substring(1),
        style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  blurRadius: 4.0, color: Colors.black87, offset: Offset(1, 1))
            ]),
      ),
    );
  }

  /// Builds the completion status indicator
  Widget _buildCompletionStatus(
      Color backgroundColor, IconData icon, Color iconColor) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}
