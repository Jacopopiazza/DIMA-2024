import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/user_details_provider.dart';

class DangerZoneSectionRiverpod extends ConsumerWidget {
  final String userId;

  const DangerZoneSectionRiverpod({
    Key? key,
    required this.userId,
  }) : super(key: key);

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
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
          'Are you sure you want to delete your account? This action cannot be undone.',
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
      final success = await ref.read(userDetailsProvider.notifier).deleteAccount(userId);
      
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully')),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete account. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
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
                  color: theme.colorScheme.error.withOpacity(isDark ? 0.2 : 0.1),
                  width: 1,
                ),
              ),
              child: Text(
                'The actions below are destructive and cannot be undone. Please proceed with caution.',
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
                onPressed: () => _showDeleteConfirmation(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 2,
                  iconColor: theme.colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 