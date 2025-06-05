import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_details_provider.dart';
import 'widgets/user_details_form_riverpod.dart';
import 'widgets/password_change_form_riverpod.dart';
import 'widgets/danger_zone_section_riverpod.dart';

class SettingsScreenRiverpod extends ConsumerWidget {
  const SettingsScreenRiverpod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdAsync = ref.watch(userIdProvider);
    final userDetailsAsync = ref.watch(userDetailsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: userIdAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Error loading settings',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('Return to Login'),
                ),
              ],
            ),
          ),
          data: (userId) {
            if (userId == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle_outlined, size: 48, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Not signed in',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Sign In'),
                    ),
                  ],
                ),
              );
            }

            return userDetailsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading user details',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => ref.read(userDetailsProvider.notifier).loadUserDetails(userId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (userDetails) => RefreshIndicator(
                onRefresh: () => ref.read(userDetailsProvider.notifier).loadUserDetails(userId),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    if (userDetails != null) ...[
                      UserDetailsFormRiverpod(
                        userDetails: userDetails,
                      ),
                      const SizedBox(height: 24),
                    ],
                    const PasswordChangeFormRiverpod(),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Actions',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.cleaning_services),
                                    label: const Text('Clear Cache'),
                                    onPressed: () async {
                                      await ref.read(userDetailsProvider.notifier).clearCache(userId);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cache cleared successfully')),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.logout),
                                    label: const Text('Sign Out'),
                                    onPressed: () async {
                                      await ref.read(userDetailsProvider.notifier).signOut(userId);
                                      if (context.mounted) {
                                        Navigator.of(context).pushReplacementNamed('/login');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.secondary,
                                      foregroundColor: theme.colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DangerZoneSectionRiverpod(userId: userId),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 