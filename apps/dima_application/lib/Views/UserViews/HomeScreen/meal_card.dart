import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap; // Optional tap callback

  const MealCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector( // Wrap in GestureDetector for onTap
      onTap: onTap,
      child: Card(
        elevation: 3.0, // Keep the desired elevation
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Background Image
            Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
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
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: colorScheme.surfaceContainerHighest,
                child: Center(
                    child: Icon(
                  Icons.broken_image,
                  color: colorScheme.onSurfaceVariant.withAlpha(153),
                  size: 40,
                )),
              ),
            ),
            // Gradient overlay
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withAlpha(179), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            // Title Text
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          blurRadius: 4.0,
                          color: Colors.black87,
                          offset: Offset(1, 1))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}