import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

/// A widget that displays an indicator when data might be stale or the app is offline.
///
/// This widget provides visual feedback to the user about the data status,
/// optionally showing the time the data was last fetched and a refresh button
/// to trigger a data update.
class StaleDataIndicator extends StatelessWidget {
  /// Optional message explaining the situation (e.g., network error, stale cache).
  final String? message;

  /// Optional timestamp indicating when the stale data was fetched or was last valid.
  /// Used to display how old the data is.
  final DateTime? lastFetched;

  /// Optional callback function to trigger a refresh action.
  /// If provided, a refresh icon button is displayed.
  final VoidCallback? onRefresh;

  /// Creates a StaleDataIndicator widget.
  ///
  /// Parameters:
  ///   [message] - Optional: Custom message text.
  ///   [lastFetched] - Optional: Timestamp of the last data fetch.
  ///   [onRefresh] - Optional: Callback for the refresh button.
  const StaleDataIndicator({
    super.key,
    this.message,
    this.lastFetched,
    this.onRefresh,
  });

  /// Formats the given DateTime for display in the indicator message.
  ///
  /// Shows time for today, "Yesterday, time" for yesterday, and "Month Day, time"
  /// for older dates, based on the current locale.
  String _formatStaleTime(DateTime dt, BuildContext context) {
    final now = DateTime.now();
    final localDt = dt.toLocal(); // Ensure comparison is in local time
    final locale =
        Localizations.localeOf(context).toString(); // Get current locale

    // Check if the date is today
    if (now.difference(localDt).inDays == 0 && now.day == localDt.day) {
      return DateFormat.jm(locale)
          .format(localDt); // Format as time (e.g., 10:30 AM)
    }
    // Check if the date is yesterday
    else if (now.difference(localDt).inDays == 1 ||
        (now.day == localDt.day + 1 && now.difference(localDt).inHours < 48)) {
      return 'Yesterday, ${DateFormat.jm(locale).format(localDt)}'; // Format as "Yesterday, time"
    }
    // For older dates
    else {
      return DateFormat.Md(locale).add_jm().format(
          localDt); // Format as "Month Day, time" (e.g., Apr 25, 10:30 AM)
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access theme and color scheme for consistent styling.
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // --- Determine Colors based on Theme ---
    // Using tertiaryContainer and onTertiaryContainer provides a distinct color
    // often used for emphasis or alerts, based on the app's theme.
    // Adjust alpha (179) for desired transparency.
    final backgroundColor = colorScheme.tertiaryContainer.withAlpha(179);
    final foregroundColor = colorScheme.onTertiaryContainer;
    // --- End Color Determination ---

    // --- Construct the display message ---
    String displayMessage;
    if (message != null) {
      // If a custom message is provided, use it.
      displayMessage = message!;
      // If lastFetched is also provided and the custom message doesn't already
      // contain "data from", append the formatted time.
      if (lastFetched != null &&
          !message!.toLowerCase().contains("data from")) {
        final formattedTime = _formatStaleTime(lastFetched!, context);
        displayMessage += " (Data from $formattedTime)";
      }
    } else if (lastFetched != null) {
      // If no custom message but lastFetched is available, show a default offline message with time.
      final formattedTime = _formatStaleTime(lastFetched!, context);
      displayMessage =
          "Offline mode. Showing old data from $formattedTime"; // Hardcoded string
    } else {
      // If neither message nor lastFetched is available, show a generic offline message.
      displayMessage =
          "Offline mode. Displaying cached data."; // Hardcoded string
    }
    // --- End message construction ---

    // Wrap the indicator content in Padding for spacing below it.
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 12.0), // Add padding below the indicator
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6), // Inner padding within the container
        decoration: BoxDecoration(
          color: backgroundColor, // Background color derived from theme
          borderRadius: BorderRadius.circular(8), // Apply rounded corners
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // Row takes maximum available width
          children: [
            // Icon indicating stale data or offline status
            Icon(
              Icons
                  .wifi_off_rounded, // Icon choice (could also be Icons.cloud_off_outlined)
              size: 18, // Size of the icon
              color: foregroundColor, // Color derived from theme
            ),
            const SizedBox(width: 8), // Space between icon and text
            // Expanded widget to allow the text to take up available space
            Expanded(
              child: Text(
                displayMessage, // The constructed message to display
                // Use bodySmall text style for a compact look, copying theme style
                style: theme.textTheme.bodySmall?.copyWith(
                  color: foregroundColor, // Apply foreground color
                  // fontWeight: FontWeight.w500, // Optional: Keep slightly bolder?
                ),
                maxLines: 2, // Limit text to 2 lines
                overflow:
                    TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
            ),
            // Conditionally add a refresh button if onRefresh callback is provided
            if (onRefresh != null)
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0), // Add space to the left of the button
                child: InkWell(
                  onTap: onRefresh, // Execute the callback when tapped
                  borderRadius: BorderRadius.circular(
                      20), // Apply rounded corners for the splash effect
                  child: Padding(
                    padding: const EdgeInsets.all(
                        4.0), // Padding inside the InkWell for tap target size
                    child: Icon(
                      Icons.refresh, // Refresh icon
                      size: 20, // Size of the refresh icon
                      color: foregroundColor, // Color derived from theme
                      semanticLabel:
                          "Retry connection", // Accessibility label for screen readers
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
