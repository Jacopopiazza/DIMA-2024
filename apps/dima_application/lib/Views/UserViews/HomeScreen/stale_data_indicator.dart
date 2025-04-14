import 'package:flutter/material.dart';

class StaleDataIndicator extends StatelessWidget {
  final String? errorMessage;
  final ColorScheme colorScheme;

  const StaleDataIndicator({
    super.key,
    required this.errorMessage,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(38),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded,
                size: 16, color: Colors.orange.shade800),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                errorMessage ?? "Showing older data.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
