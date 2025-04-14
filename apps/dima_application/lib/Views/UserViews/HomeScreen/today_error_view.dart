import 'package:flutter/material.dart';
import 'package:dima_application/providers/today_page_provider.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final TodayPageNotifier notifier;

  const ErrorView({
    super.key,
    required this.message,
    required this.notifier,
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
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: () => notifier.refreshData(),
            )
          ],
        ),
      ),
    );
  }
}