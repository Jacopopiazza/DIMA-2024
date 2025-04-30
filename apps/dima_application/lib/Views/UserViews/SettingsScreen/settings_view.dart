import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/UserViews/SettingsScreen/preferences_view.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/models/TodayPage/today_page_data.dart';
import 'package:dima_application/providers/isar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// If you use package_info_plus
// import 'package:package_info_plus/package_info_plus.dart';

// Import your localizations
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:isar/isar.dart';

// Provider to handle loading state for cache clearing
final isClearingCacheProvider = StateProvider<bool>((ref) => false);

// Use StatefulWidget to easily access `mounted` property
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  // --- Helper Methods ---

  Future<void> _clearCache() async {
    // Capture context-dependent variables before async gap
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context); // Capture theme if needed in dialog/snackbar

    // Check mounted before showing dialog
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context, // Use the original context to show the dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.confirmClearCacheTitle),
          content: Text(localizations.confirmClearCacheMessage),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error), // Use captured theme
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.clear),
            ),
          ],
        );
      },
    );

    // Check if dialog returned true and widget is still mounted
    if (confirmed != true || !mounted) return;

    ref.read(isClearingCacheProvider.notifier).state = true;

    try {
      final Isar isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        // Clear relevant collections - adjust based on ALL your cached models
        // Use the collection accessors directly on the Isar instance.
        await isar.mealPlanCaches.clear();
        await isar.todayPageDatas.clear();
        await isar.dailyCompletions.clear();
        // Add other Isar collection clear calls here if needed
        // e.g., await isar.chatMessages.clear(); // If you cache chats
      });

      // Check mounted AFTER await before showing SnackBar
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(localizations.cacheClearedSuccessfully)),
        );
      }
    } catch (e) {
      safePrint('Error clearing cache: $e');
      // Check mounted AFTER await before showing SnackBar
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(localizations.errorClearingCache),
            backgroundColor: theme.colorScheme.error, // Use captured theme
          ),
        );
      }
    } finally {
      // Update provider state regardless of mounted status
      // Check if provider is still active if necessary, but usually safe
       ref.read(isClearingCacheProvider.notifier).state = false;
    }
  }

  Future<void> _signOut() async {
    // Capture context-dependent variables before async gap
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.confirmSignOutTitle),
          content: Text(localizations.confirmSignOutMessage),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error), // Use captured theme
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.signOut),
            ),
          ],
        );
      },
    );

     if (confirmed != true || !mounted) return;

    try {
      await Amplify.Auth.signOut();
      // IMPORTANT: Navigation to the login/auth screen should be handled
      // by your main app's auth state listener (e.g., in main.dart).
      // No explicit navigation needed here typically.
    } on AuthException catch (e) {
      safePrint('Error signing out: ${e.message}');
      // Check mounted AFTER await
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: theme.colorScheme.error, // Use captured theme
          ),
        );
      }
    }
  }

   Future<void> _deleteAccount() async {
     // Capture context-dependent variables before async gap
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    // Capture navigator for potentially popping the loading dialog later
    final navigator = Navigator.of(context);

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.confirmDeleteAccountTitle, style: TextStyle(color: theme.colorScheme.error)), // Use captured theme
          content: Text(localizations.confirmDeleteAccountMessage),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: theme.colorScheme.error), // Use captured theme
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.deleteAccount),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;


    // Show a loading indicator dialog. Use `context` directly here as it's synchronous.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool deleteSuccess = false;
    String? errorMessage;

    try {
      await Amplify.Auth.deleteUser();
      deleteSuccess = true; // Mark success

    } on AuthException catch (e) {
      safePrint('Error deleting account: ${e.message}');
      errorMessage = localizations.errorDeletingAccount;
      if (e.message.contains("recently signed in")) {
           errorMessage = localizations.errorDeleteAccountRequiresRecentLogin;
      } else {
          errorMessage = e.message; // Use Amplify's message if not the specific one
      }
    } catch (e) {
       safePrint('Generic error deleting account: $e');
       errorMessage = localizations.errorDeletingAccount;
    }

    // Check mounted AFTER await operations, BEFORE interacting with context/navigator
    if (!mounted) return;

    // Pop the loading indicator using the captured navigator
    navigator.pop();

    // Show appropriate SnackBar using captured scaffoldMessenger and theme
    if (deleteSuccess) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(localizations.accountDeletedSuccessfully)),
        );
        // IMPORTANT: Let the main app structure handle navigation based on auth state change.
    } else if (errorMessage != null) {
        scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // No async gaps here, direct context usage is safe
    final localizations = AppLocalizations.of(context)!;
    final isClearing = ref.watch(isClearingCacheProvider);
    final currentTheme = Theme.of(context); // Use if needed directly in build

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: Text(localizations.changePreferences),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Synchronous navigation is safe
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: isClearing
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: currentTheme.colorScheme.primary),
                  )
                : const Icon(Icons.cleaning_services),
            title: Text(localizations.clearCache),
            // Disable tap while clearing, call helper function
            onTap: isClearing ? null : _clearCache,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: currentTheme.colorScheme.error),
            title: Text(localizations.signOut, style: TextStyle(color: currentTheme.colorScheme.error)),
            onTap: _signOut, // Call helper function
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: currentTheme.colorScheme.error),
            title: Text(localizations.deleteAccount, style: TextStyle(color: currentTheme.colorScheme.error)),
            onTap: _deleteAccount, // Call helper function
          ),
           const Divider(),
           // Optional: Add App Version
           // FutureBuilder is safe as it manages its own state and context rebuilds
           // FutureBuilder<PackageInfo>(
           //   future: PackageInfo.fromPlatform(),
           //   builder: (context, snapshot) {
           //     if (snapshot.hasData) {
           //       final packageInfo = snapshot.data!;
           //       final localizations = AppLocalizations.of(context)!; // Safe inside builder
           //       return ListTile(
           //         title: Text(localizations.appVersion),
           //         subtitle: Text('${packageInfo.version} (${packageInfo.buildNumber})'),
           //         enabled: false,
           //       );
           //     }
           //     return const SizedBox.shrink();
           //   },
           // ),
        ],
      ),
    );
  }
}