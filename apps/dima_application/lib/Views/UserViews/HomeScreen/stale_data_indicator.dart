import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class StaleDataIndicator extends StatelessWidget {
  /// Optional message explaining the situation (e.g., network error, stale cache).
  final String? message;

  /// Optional timestamp indicating when the stale data was fetched/valid.
  final DateTime? lastFetched;

  /// Optional callback to trigger a refresh action. If provided, a refresh button is shown.
  final VoidCallback? onRefresh;

  const StaleDataIndicator({
    super.key,
    this.message,
    this.lastFetched,
    this.onRefresh,
  });

  /// Formats the DateTime for display in the indicator.
  String _formatStaleTime(DateTime dt, BuildContext context) {
    // (Keep your existing _formatStaleTime logic)
    final now = DateTime.now();
    final localDt = dt.toLocal();
    final locale = Localizations.localeOf(context).toString();

    if (now.difference(localDt).inDays == 0 && now.day == localDt.day) {
      return DateFormat.jm(locale).format(localDt);
    } else if (now.difference(localDt).inDays == 1 ||
        (now.day == localDt.day + 1 && now.difference(localDt).inHours < 48)) {
      return 'Yesterday, ${DateFormat.jm(locale).format(localDt)}';
    } else {
      return DateFormat.Md(locale).add_jm().format(localDt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // --- Reverted Color Scheme (closer to your original) ---
    // Using tertiaryContainer (often mapped to browns/oranges/purples depending on theme)
    // with some transparency might achieve the look. Adjust alpha (179) as needed.
    final backgroundColor = colorScheme.tertiaryContainer.withAlpha(179);
    final foregroundColor = colorScheme.onTertiaryContainer;
    // --- End Reverted Color Scheme ---


    // Construct the display message (same logic as before)
    String displayMessage;
    if (message != null) {
      displayMessage = message!;
      if (lastFetched != null && !message!.toLowerCase().contains("data from")) {
         final formattedTime = _formatStaleTime(lastFetched!, context);
         displayMessage += " (Data from $formattedTime)";
      }
    } else if (lastFetched != null) {
      final formattedTime = _formatStaleTime(lastFetched!, context);
      displayMessage = "Offline mode. Showing old data from $formattedTime";
    } else {
      displayMessage = "Offline mode. Displaying cached data.";
    }

    // Restore outer Padding structure
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Add padding below the indicator
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6), // Inner padding
        decoration: BoxDecoration(
          color: backgroundColor, // Use the reverted theme color
          borderRadius: BorderRadius.circular(8), // Keep rounded corners
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.wifi_off_rounded, // Or Icons.cloud_off_outlined
              size: 18, // Restored icon size
              color: foregroundColor,
            ),
            const SizedBox(width: 8), // Reduced space slightly
            Expanded(
              child: Text(
                displayMessage,
                // Use bodySmall for a compact look, adjust if needed
                style: theme.textTheme.bodySmall?.copyWith(
                    color: foregroundColor,
                    // fontWeight: FontWeight.w500, // Keep slightly bolder? Or remove?
                 ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Conditionally add refresh button
            if (onRefresh != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: onRefresh,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.refresh,
                      size: 20, // Slightly larger refresh icon?
                      color: foregroundColor,
                      semanticLabel: "Retry connection",
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}