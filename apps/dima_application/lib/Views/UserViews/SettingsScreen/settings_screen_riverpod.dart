import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/user_details_provider.dart';
import 'widgets/actions_section_riverpod.dart';
import 'widgets/danger_zone_section_riverpod.dart';
import 'widgets/password_change_form_riverpod.dart';
import 'widgets/pro_subscription_section_riverpod.dart';
import 'widgets/user_details_form_riverpod.dart';
import 'widgets/user_profile_section_riverpod.dart';

class SettingsScreenRiverpod extends ConsumerWidget {
  const SettingsScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdAsync = ref.watch(userIdProvider);
    final userDetailsAsync = ref.watch(userDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: userIdAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
          data: (userId) {
            if (userId == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle_outlined,
                        size: 48, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Not signed in',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // This should not be needed since the user should already be signed out
                        // The Amplify Authenticator will handle showing the sign-in screen
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Sign In'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              displacement: 60.0,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: () => ref
                  .read(userDetailsProvider.notifier)
                  .loadUserDetails(userId),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Stack(
                          children: [
                            // Main content
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  userDetailsAsync.when(
                                    // By using `skipLoadingOnRefresh: true`, we keep the old data visible.
                                    skipLoadingOnRefresh: true,
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                    error: (error, stackTrace) =>
                                        Center(child: Text('Error: $error')),
                                    data: (data) {
                                      final userDetails = data.$1;
                                      final uniqueId = data.$2;

                                      if (userDetails == null) {
                                        return const Center(
                                            child: Text(
                                                'No user details available.'));
                                      }

                                      return Column(
                                        children: [
                                          const UserProfileSectionRiverpod(),
                                          const SizedBox(height: 24),
                                          UserDetailsFormRiverpod(
                                            key: ValueKey(
                                                uniqueId), // Use the unique ID for the key
                                            userDetails: userDetails,
                                            onUpdate: (updatedDetails) async {
                                              return await ref
                                                  .read(userDetailsProvider
                                                      .notifier)
                                                  .updateUserDetails(
                                                      updatedDetails);
                                            },
                                          ),
                                          const SizedBox(height: 24),
                                          PasswordChangeFormRiverpod(
                                            onChangePassword: (oldPassword,
                                                newPassword) async {
                                              return await ref
                                                  .read(userDetailsProvider
                                                      .notifier)
                                                  .changePassword(
                                                      oldPassword, newPassword);
                                            },
                                          ),
                                          const SizedBox(height: 24),
                                          ActionsSectionRiverpod(
                                              userId: userId),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  const ProSubscriptionSectionRiverpod(),
                                  const SizedBox(height: 24),
                                  DangerZoneSectionRiverpod(userId: userId),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
