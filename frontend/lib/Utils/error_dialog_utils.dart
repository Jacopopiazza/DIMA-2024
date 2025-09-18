import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorDialogUtils {
  /// Shows a database error dialog when meal completion operations fail
  static Future<void> showMealCompletionError(BuildContext context,
      {VoidCallback? onRetry}) async {
    final localizations = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.error,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Failed to store in database... try again later",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            if (onRetry != null)
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Text(localizations.tryAgain),
              ),
          ],
        );
      },
    );
  }

  /// Shows a network error dialog when operations fail due to connectivity issues
  static Future<void> showNetworkError(BuildContext context,
      {VoidCallback? onRetry}) async {
    final localizations = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: theme.colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Connection Error",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            localizations.checkInternetConnection,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            if (onRetry != null)
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Text(localizations.retry),
              ),
          ],
        );
      },
    );
  }

  /// Shows a generic error dialog with custom message
  static Future<void> showGenericError(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) async {
    final localizations = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: theme.colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.somethingWentWrong,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            if (onRetry != null)
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Text(localizations.tryAgain),
              ),
          ],
        );
      },
    );
  }
}
