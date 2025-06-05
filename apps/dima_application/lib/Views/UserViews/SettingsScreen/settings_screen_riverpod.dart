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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              userIdAsync.whenData((userId) {
                if (userId != null) {
                  ref.read(userDetailsProvider.notifier).loadUserDetails(userId);
                }
              });
            },
          ),
        ],
      ),
      body: userIdAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error loading settings'),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                child: const Text('Return to Login'),
              ),
            ],
          ),
        ),
        data: (userId) {
          if (userId == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                child: const Text('Return to Login'),
              ),
            );
          }

          return userDetailsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading user details'),
                  ElevatedButton(
                    onPressed: () => ref.read(userDetailsProvider.notifier).loadUserDetails(userId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (userDetails) => RefreshIndicator(
              onRefresh: () => ref.read(userDetailsProvider.notifier).loadUserDetails(userId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if ( userDetails != null)
                      UserDetailsFormRiverpod(
                        userDetails: userDetails,
                      ),
                    const SizedBox(height: 24),
                    const PasswordChangeFormRiverpod(),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
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
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      onPressed: () async {
                        await ref.read(userDetailsProvider.notifier).signOut(userId);
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    DangerZoneSectionRiverpod(userId: userId),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 