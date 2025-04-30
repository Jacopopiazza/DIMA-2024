import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  // Changed from TodayPageNotifier to a simple VoidCallback
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    // Updated constructor parameter
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 50, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              "Failed to Load Data",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message, // Display the specific error message passed in
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              // Execute the passed-in onRetry callback when pressed
              onPressed: onRetry,
            )
          ],
        ),
      ),
    );
  }
}