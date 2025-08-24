import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class NutritionistActionsSection extends StatelessWidget {
  const NutritionistActionsSection({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final result = await Amplify.Auth.signOut(
        options: const SignOutOptions(globalSignOut: true),
      );
      if (result is CognitoCompleteSignOut) {
        safePrint('Sign out completed successfully');
      } else if (result is CognitoPartialSignOut) {
        final globalSignOutException = result.globalSignOutException!;
        safePrint('Error signing user out: ${globalSignOutException.message}');
      } else if (result is CognitoFailedSignOut) {
        safePrint('Error signing user out: ${result.exception.message}');
      }
    } on AuthException catch (e) {
      safePrint('Error signing out: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await Amplify.Auth.deleteUser();
      safePrint('Delete user succeeded');
    } on AuthException catch (e) {
      safePrint('Error deleting user: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Delete Account'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and will remove all your nutritionist data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _deleteAccount(context);
    }
  }

  Future<void> _showSignOutConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Actions Section
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.secondary.withOpacity(0.1)
                : theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.toc, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Actions',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    onTap: () => _showSignOutConfirmation(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hoverColor: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Danger Zone Section
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.errorContainer.withOpacity(0.3)
                : theme.colorScheme.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.error.withOpacity(isDark ? 0.5 : 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.error.withOpacity(isDark ? 0.2 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: theme.colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Danger Zone',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.error.withOpacity(0.1)
                        : theme.colorScheme.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.error
                          .withOpacity(isDark ? 0.2 : 0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'The actions below are destructive and cannot be undone. This will permanently delete your nutritionist profile and all associated data.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.delete_forever,
                      color: theme.colorScheme.onError,
                      size: 20,
                    ),
                    label: const Text('Delete Account'),
                    onPressed: () => _showDeleteConfirmation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      elevation: 2,
                      iconColor: theme.colorScheme.onError,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
