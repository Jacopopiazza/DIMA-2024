import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class StaleDataIndicator extends StatelessWidget {
  /// Optional message explaining the situation (e.g., network error).
  final String? message;
  /// Optional timestamp indicating when the stale data was fetched/valid.
  final DateTime? lastFetched;

  const StaleDataIndicator({
    super.key,
    this.message, // Make message optional
    this.lastFetched, // Add optional lastFetched timestamp
    // colorScheme removed, will get from Theme context
  });

  /// Formats the DateTime for display in the indicator.
  String _formatStaleTime(DateTime dt, BuildContext context) {
      final now = DateTime.now();
      final localDt = dt.toLocal(); // Convert to local time for comparison/display

      // Use locale from context if possible for formatting
      final locale = Localizations.localeOf(context).toString();

      if (now.difference(localDt).inDays == 0 && now.day == localDt.day) {
        // Today: show time
        return DateFormat.jm(locale).format(localDt); // e.g., "10:30 AM"
      } else if (now.difference(localDt).inDays == 1 || (now.day == localDt.day + 1 && now.difference(localDt).inHours < 48)) {
         // Yesterday: show "Yesterday" + time
         return 'Yesterday, ${DateFormat.jm(locale).format(localDt)}';
      } else {
         // Older: show date + time
         return DateFormat.Md(locale).add_jm().format(localDt); // e.g., "4/29, 10:30 AM"
      }
  }


  @override
  Widget build(BuildContext context) {
    // Get the color scheme from the current theme
    final colorScheme = Theme.of(context).colorScheme;

    // Define colors - using tertiary or secondary container often works well for warnings/info
    // Adjust these based on your theme's definition and desired look
    final backgroundColor = colorScheme.tertiaryContainer.withAlpha(179);
    final foregroundColor = colorScheme.onTertiaryContainer;
    // Fallback if tertiary isn't distinct (e.g., if same as secondary)
    // final backgroundColor = colorScheme.secondaryContainer.withOpacity(0.7);
    // final foregroundColor = colorScheme.onSecondaryContainer;
     // Or stick to a specific color if needed:
     // final backgroundColor = Colors.orange.withAlpha(50);
     // final foregroundColor = Colors.orange.shade900;


    // Construct the display message
    String displayMessage = message ?? "Offline mode."; // Default if no specific message
    if (lastFetched != null) {
      final formattedTime = _formatStaleTime(lastFetched!, context);
      // Append time info clearly
      displayMessage += " (Data from $formattedTime)";
    } else if (message == null) {
        // If no message and no timestamp, use a more generic stale message
        displayMessage = "Showing older data.";
    }

    return Padding(
      // Add padding only if there's something to show
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Slightly adjusted padding
        decoration: BoxDecoration(
          color: backgroundColor, // Use theme-derived color
          borderRadius: BorderRadius.circular(8),
           // Optional: add a subtle border
           // border: Border.all(color: foregroundColor.withOpacity(0.3), width: 0.5),
        ),
        child: Row(
          // Changed to MainAxisSize.max to fill width, looks better usually
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.wifi_off_rounded, // Changed icon to be more specific to offline/stale
              size: 18, // Slightly larger icon
              color: foregroundColor, // Use theme-derived color
            ),
            const SizedBox(width: 8),
            // Use Expanded to allow text to fill available space
            Expanded(
              child: Text(
                displayMessage,
                style: TextStyle(
                  fontSize: 13, // Slightly adjusted font size
                  color: foregroundColor, // Use theme-derived color
                  fontWeight: FontWeight.w500, // Slightly bolder
                ),
                // Allow text to wrap if needed
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}