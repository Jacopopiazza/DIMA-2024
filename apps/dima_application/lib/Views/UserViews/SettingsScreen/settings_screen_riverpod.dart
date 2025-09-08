import 'package:dima_application/Views/UserViews/SettingsScreen/widgets/pro_subscription_section_riverpod.dart';
import 'package:dima_application/navigation/route_observer.dart';
import 'package:dima_application/providers/subscription_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';

import '../../../providers/cognito_profile_provider.dart';
import '../../../providers/user_details_provider.dart';
import 'widgets/actions_section_riverpod.dart';
import 'widgets/danger_zone_section_riverpod.dart';
import 'widgets/password_change_form_riverpod.dart';
import 'widgets/user_details_form_riverpod.dart';
import 'widgets/user_profile_section_riverpod.dart';

class SettingsScreenRiverpod extends ConsumerStatefulWidget {
  final bool showBackButton;

  const SettingsScreenRiverpod({Key? key, this.showBackButton = false})
      : super(key: key);

  @override
  ConsumerState<SettingsScreenRiverpod> createState() =>
      _SettingsScreenRiverpodState();
}

class _SettingsScreenRiverpodState extends ConsumerState<SettingsScreenRiverpod>
    with SingleTickerProviderStateMixin, RouteAware {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  // Variables kept for potential future auto-refresh implementation
  // DateTime? _lastVisitTime;
  // bool _navigatedToOtherScreen = false;

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
    // _lastVisitTime = DateTime.now(); // Disabled for auto-refresh
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register with route observer for navigation callbacks
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // RouteObserver methods - currently not used for auto-refresh
  // These are kept for potential future implementation of proper app lifecycle detection

  @override
  void didPushNext() {
    print('[SettingsScreen] Navigation away detected (auto-refresh disabled)');
    super.didPushNext();
  }

  @override
  void didPopNext() {
    print('[SettingsScreen] Navigation back detected (auto-refresh disabled)');
    super.didPopNext();
  }

  void _checkAndRefreshIfStale() {
    // TEMPORARILY DISABLED: Auto-refresh disabled to prevent data loss
    // Only refresh manually via pull-to-refresh gesture
    print(
        '[SettingsScreen] Auto-refresh disabled - use pull-to-refresh to update data');
    return;

    // TODO: Implement proper app lifecycle detection for real app close/reopen
    // Current issue: Can't reliably distinguish between modal dialogs and real navigation
    // Risk: Users lose unsaved form data due to automatic refresh
  }

  void _refreshAllData() {
    try {
      print('[SettingsScreen] Refreshing all data for settings page...');

      // For settings page, we need fresh user data, so invalidation is appropriate
      // This ensures we get the latest user details, profile, and subscription status

      // Refresh cognito profile
      ref.read(cognitoProfileProvider.notifier).refresh();
      print('[SettingsScreen] Cognito profile refresh initiated');

      // Refresh user details for current user
      ref.read(userIdProvider.future).then((userId) {
        if (userId != null) {
          ref.read(userDetailsProvider.notifier).loadUserDetails(userId);
          print(
              '[SettingsScreen] User details refresh initiated for user: $userId');
        } else {
          print(
              '[SettingsScreen] No user ID found, skipping user details refresh');
        }
      }).catchError((error) {
        print('[SettingsScreen] Error getting user ID for refresh: $error');
      });

      // Refresh subscription status
      ref.read(subscriptionStatusProvider.notifier).refresh();
      print('[SettingsScreen] Subscription status refresh initiated');

      print('[SettingsScreen] All settings data refresh tasks completed');
    } catch (e) {
      print('[SettingsScreen] Error refreshing settings data: $e');
    }
  }

  @override
  void dispose() {
    // Unregister from route observer
    routeObserver.unsubscribe(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userIdAsync = ref.watch(userIdProvider);
    final userDetailsAsync = ref.watch(userDetailsProvider);
    final cognitoProfileAsync = ref.watch(cognitoProfileProvider);
    final subscriptionStatusAsync = ref.watch(subscriptionStatusProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: userIdAsync.when(
              loading: () => _buildLoadingState(colorScheme, theme),
              error: (error, stackTrace) =>
                  _buildErrorState(error.toString(), colorScheme, theme),
              data: (userId) {
                if (userId == null) {
                  return _buildNotSignedInState(colorScheme, theme);
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final refreshTasks = <Future<void>>[];
                        refreshTasks.add(ref
                            .read(cognitoProfileProvider.notifier)
                            .refresh());
                        refreshTasks.add(ref
                            .read(userDetailsProvider.notifier)
                            .loadUserDetails(userId));
                        refreshTasks.add(ref
                            .read(subscriptionStatusProvider.notifier)
                            .refresh());
                        await Future.wait(refreshTasks);
                      },
                      backgroundColor: colorScheme.surface,
                      color: colorScheme.primary,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            // Header section
                            _buildHeaderSection(colorScheme, theme),
                            const SizedBox(height: 32),

                            subscriptionStatusAsync.when(
                              skipLoadingOnRefresh: true,
                              loading: () => _buildSectionLoadingState(
                                  colorScheme, AppLocalizations.of(context)!.loadingSubscription),
                              error: (error, stackTrace) =>
                                  _buildSubscriptionSectionErrorState(
                                      colorScheme, theme),
                              data: (data) {
                                final subscriptionData = data.$1;
                                final uniqueId = data.$2;

                                return Column(
                                  children: [
                                    ProSubscriptionSectionRiverpod(
                                      key: ValueKey(
                                          'subscription_status_$uniqueId'),
                                      subscriptionStatus:
                                          subscriptionData.subscriptionStatus,
                                      onSubscribe: () async {
                                        return await ref
                                            .read(subscriptionStatusProvider
                                                .notifier)
                                            .subscribe();
                                      },
                                      onUnsubscribe: () async {
                                        return await ref
                                            .read(subscriptionStatusProvider
                                                .notifier)
                                            .unsubscribe();
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              },
                            ),

                            // Cognito profile section
                            cognitoProfileAsync.when(
                              skipLoadingOnRefresh: true,
                              loading: () => _buildSectionLoadingState(
                                  colorScheme, AppLocalizations.of(context)!.loadingProfile),
                              error: (error, stackTrace) =>
                                  _buildNoProfileState(colorScheme, theme),
                              data: (data) {
                                final profileData = data.$1;
                                final uniqueId = data.$2;

                                return Column(
                                  children: [
                                    // User Profile Section
                                    UserProfileSectionRiverpod(
                                      key: ValueKey('profile_$uniqueId'),
                                      profileData: profileData,
                                      uniqueId: uniqueId,
                                      onUpdateProfile: ({
                                        String? givenName,
                                        String? familyName,
                                        String? gender,
                                        String? birthdate,
                                      }) async {
                                        return await ref
                                            .read(
                                                cognitoProfileProvider.notifier)
                                            .updateUserProfileAttributes(
                                              gender: gender,
                                              birthdate: birthdate,
                                            );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              },
                            ),

                            // User details section
                            userDetailsAsync.when(
                              skipLoadingOnRefresh: true,
                              loading: () => _buildSectionLoadingState(
                                  colorScheme, AppLocalizations.of(context)!.loadingPreferences),
                              error: (error, stackTrace) =>
                                  _buildSectionErrorState(colorScheme, theme),
                              data: (data) {
                                final userDetails = data.$1;
                                final uniqueId = data.$2;

                                return Column(
                                  children: [
                                    UserDetailsFormRiverpod(
                                      key: ValueKey('details_$uniqueId'),
                                      userDetails: userDetails,
                                      onUpdate: (updatedDetails) async {
                                        return await ref
                                            .read(userDetailsProvider.notifier)
                                            .updateUserDetails(updatedDetails);
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    PasswordChangeFormRiverpod(
                                      onChangePassword:
                                          (oldPassword, newPassword) async {
                                        return await ref
                                            .read(userDetailsProvider.notifier)
                                            .changePassword(
                                                oldPassword, newPassword);
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
                  ),
                );
              },
            ),
          ),
          // Floating back button positioned on top
          if (widget.showBackButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
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
            AppLocalizations.of(context)!.loadingSettings,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      String error, ColorScheme colorScheme, ThemeData theme) {
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
              AppLocalizations.of(context)!.somethingWentWrong,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.unableToLoadSettings,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.refresh(userIdProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)!.tryAgain),
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
              AppLocalizations.of(context)!.notSignedIn,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.pleaseSignInToAccessSettings,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.login_rounded),
              label: Text(AppLocalizations.of(context)!.signIn),
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
            AppLocalizations.of(context)!.accountSettings,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.manageYourProfilePreferencesAndSecurity,
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

  Widget _buildSectionLoadingState(ColorScheme colorScheme, String message) {
    return Column(children: [
      Container(
        height: 200,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
    ]);
  }

  Widget _buildNoProfileState(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.profileUnavailable,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.personalDataCurrentlyUnavailable,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionErrorState(ColorScheme colorScheme, ThemeData theme) {
    return Column(children: [
      Container(
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
              AppLocalizations.of(context)!.preferencesUnavailable,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.preferencesDataCurrentlyUnavailable,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24)
    ]);
  }

  Widget _buildSubscriptionSectionErrorState(
      ColorScheme colorScheme, ThemeData theme) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.monetization_on_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.subscriptionStatusUnavailable,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.subscriptionStatusCurrentlyUnavailable,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24)
    ]);
  }
}
