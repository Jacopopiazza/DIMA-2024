import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/user_details_provider.dart';

class ActionsSectionRiverpod extends ConsumerWidget {
  final String userId;

  const ActionsSectionRiverpod({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
            _buildActionsList(context, ref, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsList(
      BuildContext context, WidgetRef ref, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              // Show confirmation dialog
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
                await ref.read(userDetailsProvider.notifier).signOut(userId);
                // No need to navigate - Amplify Auth will handle the UI transition
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hoverColor: theme.colorScheme.primary.withOpacity(0.1),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Clear Cache & Refresh'),
            onTap: () {
              ref.read(userDetailsProvider.notifier).loadUserDetails(userId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared and data refreshed.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hoverColor: theme.colorScheme.primary.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
