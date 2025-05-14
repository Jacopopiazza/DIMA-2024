import 'package:dima_application/Utils/localization_helpers.dart';
import 'package:dima_application/Views/UserViews/MealScreen/meal_details_view.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:flutter/material.dart';

/// A card widget that displays meal information with loading states and completion status.
///
/// This card is designed to present a single meal item within a list or grid.
/// It shows the meal's image, title, and an indicator for its completion status.
/// The card supports a loading skeleton state and navigates to a detailed view
/// when the user taps on it.
class MealCard extends StatelessWidget {
  /// The meal data object containing details like name, image, etc.
  final Meal meal;

  /// The id of the mealPlan to which this meal belongs.
  final String mealPlanId;

  /// A boolean flag indicating whether this meal has been marked as completed.
  final bool isCompleted;

  /// A boolean flag to show a loading skeleton instead of the actual meal data.
  /// Defaults to `false`.
  final bool isLoading;

  /// The URL string for the meal's image. If null, a placeholder image is used.
  final String? imageUrl;

  /// Creates a MealCard widget.
  ///
  /// Parameters:
  ///   [meal] - Required: The meal data object.
  ///   [isCompleted] - Required: The completion status of the meal.
  ///   [isLoading] - Optional: Set to true to display the loading skeleton.
  ///   [imageUrl] - Optional: The URL for the meal image.
  const MealCard({
    super.key,
    required this.meal,
    required this.isCompleted,
    required this.mealPlanId,
    this.isLoading = false,
    this.imageUrl,
  });

  /// Creates a loading skeleton version of the card.
  ///
  /// This static method provides a visual placeholder that mimics the card's
  /// structure while the actual meal data is being fetched.
  static Widget loading(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Determine base color for the skeleton background based on theme
    final baseColor = isDarkMode ? Colors.grey[850]! : Colors.grey[300]!;
    // Determine color for the placeholder elements within the skeleton
    final skeletonColor =
        isDarkMode ? Colors.white.withAlpha(25) : Colors.grey[400]!;

    return Container(
      height: 180, // Fixed height matching the actual card
      margin: const EdgeInsets.only(
          bottom: 16), // Consistent spacing below the card
      decoration: BoxDecoration(
        color: baseColor, // Background color for the skeleton container
        borderRadius:
            BorderRadius.circular(15.0), // Rounded corners matching the card
      ),
      child: Stack(
        alignment: Alignment.bottomLeft, // Align children to the bottom left
        children: [
          // Gradient overlay placeholder to simulate image overlay area
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
          // Title placeholder (a colored container simulating text block)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(width: 100, height: 20, color: skeletonColor),
          ),
          // Completion status placeholder (a colored circle simulating the icon)
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
    // Access theme and color scheme for consistent styling across the app
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Default to a placeholder image URL if no image URL is provided
    final String displayImageUrl = imageUrl ??
        'https://via.placeholder.com/600x250.png/grey/white?text=Meal';

    // Determine the icon and colors for the completion status indicator
    final IconData statusIconData =
        isCompleted ? Icons.check_circle : Icons.check_circle_outline;
    final Color iconColor = isCompleted
        ? colorScheme.primary // Use primary color for completed status icon
        : colorScheme.onSurface
            .withAlpha(253); // Use a muted color for not completed
    final Color iconBackgroundColor = isCompleted
        ? colorScheme.surface
            .withAlpha(217) // Muted surface color for completed icon background
        : Colors.black.withAlpha(
            90); // Semi-transparent black for not completed icon background

    return Card(
      margin: const EdgeInsets.only(
          bottom: 16), // Margin below the card for spacing in lists
      elevation: isLoading
          ? 0
          : 3.0, // No elevation when loading, slight elevation when displaying data
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.0)), // Apply rounded corners to the card
      clipBehavior: Clip
          .antiAlias, // Ensure content (especially the image) is clipped to the rounded corners
      child: InkWell(
        // Wrap the card content in InkWell to make it tappable
        onTap: () => Navigator.push(
          context,
          // Navigate to the MealDetailsDraggablePage when the card is tapped
          MaterialPageRoute(
              builder: (context) => MealDetailsDraggablePage(meal: meal, mealPlanId: mealPlanId,)),
        ),
        child: Ink(
          color: Colors
              .transparent, // Allows the InkWell splash effect to show through
          height: 180, // Fixed height for the card content area
          width: double.infinity, // Card content takes the full available width
          child: Stack(
            alignment: Alignment
                .bottomLeft, // Position children within the Stack relative to the bottom left
            children: [
              // The meal image, covering the card area
              _buildMealImage(displayImageUrl, colorScheme),

              // A gradient overlay on top of the image for better text readability
              _buildGradientOverlay(),

              // The meal title text, positioned at the bottom left over the gradient
              _buildMealTitle(context),

              // The completion status indicator icon, positioned at the top right
              _buildCompletionStatus(
                  iconBackgroundColor, statusIconData, iconColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the meal image widget with integrated loading and error handling.
  ///
  /// Uses `Image.network` and provides `loadingBuilder` and `errorBuilder`
  /// to show appropriate widgets during image loading or on failure.
  Widget _buildMealImage(String url, ColorScheme colorScheme) {
    return Image.network(
      url,
      height: 180, // Match the height of the card
      width: double.infinity, // Image takes the full width of its container
      fit: BoxFit
          .cover, // Scale the image to cover the available space without distortion
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null)
          return child; // If loading is complete, show the image
        // Show a loading indicator while the image is downloading
        return _buildImageLoadingIndicator(colorScheme, loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        // Show an error placeholder if the image fails to load
        return _buildImageErrorPlaceholder(colorScheme);
      },
    );
  }

  /// Builds a circular progress indicator displayed while the image is loading.
  Widget _buildImageLoadingIndicator(
      ColorScheme colorScheme, ImageChunkEvent loadingProgress) {
    return Container(
      height: 180, // Match image height
      color: colorScheme
          .surfaceContainerHighest, // Background color for the loading area
      child: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary, // Use primary color for the indicator
          // Calculate the progress value if total bytes are known
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null, // Value is null for indeterminate progress
        ),
      ),
    );
  }

  /// Builds an error placeholder widget displayed when the image fails to load.
  Widget _buildImageErrorPlaceholder(ColorScheme colorScheme) {
    return Container(
      height: 180, // Match image height
      color: colorScheme
          .surfaceContainerHighest, // Background color for the error area
      child: Center(
        child: Icon(
          Icons.broken_image, // Icon indicating a broken image
          color: colorScheme.onSurfaceVariant
              .withAlpha(153), // Muted color for the icon
          size: 40, // Size of the error icon
        ),
      ),
    );
  }

  /// Builds a linear gradient overlay positioned at the bottom of the card.
  ///
  /// This gradient helps improve the readability of text (like the meal title)
  /// placed over the image by providing a darker background.
  Widget _buildGradientOverlay() {
    return Container(
      height: 180, // Cover the full height of the card
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black
                .withAlpha(179), // Dark color at the bottom (more opaque)
            Colors.transparent // Transparent at the top
          ],
          begin: Alignment.bottomCenter, // Start the dark color at the bottom
          end: Alignment.topCenter, // End the gradient at the top
        ),
      ),
    );
  }

  /// Builds the meal title text widget.
  ///
  /// Displays the localized meal name with styling for visibility over the image.
  Widget _buildMealTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Padding around the title text
      child: Text(
        localizeMealName(context, meal.name), // Get the localized meal name
        style: const TextStyle(
            color: Colors.white, // White text color for contrast
            fontSize: 22, // Font size for the title
            fontWeight: FontWeight.bold, // Bold font weight
            shadows: [
              // Add a text shadow for better definition against the background
              Shadow(
                  blurRadius: 4.0, color: Colors.black87, offset: Offset(1, 1))
            ]),
      ),
    );
  }

  /// Builds the completion status indicator icon.
  ///
  /// This is a small circular icon positioned at the top right of the card
  /// indicating whether the meal is completed.
  Widget _buildCompletionStatus(
      Color backgroundColor, IconData icon, Color iconColor) {
    return Positioned(
      top: 10, // Distance from the top edge of the Stack
      right: 10, // Distance from the right edge of the Stack
      child: Container(
        padding:
            const EdgeInsets.all(3), // Padding inside the circular container
        decoration: BoxDecoration(
          color: backgroundColor, // Background color of the circular container
          shape: BoxShape.circle, // Make the container circular
        ),
        child: Icon(
          icon, // The icon data (check or outline)
          color: iconColor, // Color of the icon
          size: 24, // Size of the icon
        ),
      ),
    );
  }
}
