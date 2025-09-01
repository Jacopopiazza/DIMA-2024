import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_details_provider.dart';
import 'widgets/user_details_form_riverpod.dart';
import 'widgets/password_change_form_riverpod.dart';
import 'widgets/danger_zone_section_riverpod.dart';
import 'widgets/actions_section_riverpod.dart';

class SettingsScreenRiverpod extends ConsumerStatefulWidget {
  const SettingsScreenRiverpod({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreenRiverpod> createState() => _SettingsScreenRiverpodState();
}

class _SettingsScreenRiverpodState extends ConsumerState<SettingsScreenRiverpod>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userIdAsync = ref.watch(userIdProvider);
    final userDetailsAsync = ref.watch(userDetailsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: Text(
          'Settings',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: userIdAsync.when(
          loading: () => _buildLoadingState(colorScheme, theme),
          error: (error, stackTrace) => _buildErrorState(error.toString(), colorScheme, theme),
          data: (userId) {
            if (userId == null) {
              return _buildNotSignedInState(colorScheme, theme);
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: RefreshIndicator(
                  onRefresh: () => ref.read(userDetailsProvider.notifier).loadUserDetails(userId),
                  backgroundColor: colorScheme.surface,
                  color: colorScheme.primary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Header section
                      _buildHeaderSection(colorScheme, theme),
                      const SizedBox(height: 32),

                      // User details section
                      userDetailsAsync.when(
                        skipLoadingOnRefresh: true,
                        loading: () => _buildSectionLoadingState(colorScheme),
                        error: (error, stackTrace) => _buildSectionErrorState(error.toString(), colorScheme, theme),
                        data: (data) {
                          final userDetails = data.$1;
                          final uniqueId = data.$2;

                          if (userDetails == null) {
                            return _buildNoDetailsState(colorScheme, theme);
                          }

                          return Column(
                            children: [
                              UserDetailsFormRiverpod(
                                key: ValueKey(uniqueId),
                                userDetails: userDetails,
                                onUpdate: (updatedDetails) async {
                                  return await ref
                                      .read(userDetailsProvider.notifier)
                                      .updateUserDetails(updatedDetails);
                                },
                              ),
                              const SizedBox(height: 24),
                              PasswordChangeFormRiverpod(
                                onChangePassword: (oldPassword, newPassword) async {
                                  return await ref
                                      .read(userDetailsProvider.notifier)
                                      .changePassword(oldPassword, newPassword);
                                },
                              ),
                              const SizedBox(height: 24),
                              ActionsSectionRiverpod(userId: userId),
                              const SizedBox(height: 24),
                              DangerZoneSectionRiverpod(userId: userId),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading settings...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load settings',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.refresh(userIdProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotSignedInState(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_circle_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Not signed in',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please sign in to access your settings',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.login_rounded),
              label: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.settings_rounded,
              size: 32,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Account Settings',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your profile, preferences, and account security settings.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLoadingState(ColorScheme colorScheme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildSectionErrorState(String error, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 32,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading user details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onErrorContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDetailsState(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No user details available',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}