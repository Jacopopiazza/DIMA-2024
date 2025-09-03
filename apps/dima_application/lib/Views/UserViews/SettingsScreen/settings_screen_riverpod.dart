import 'package:dima_application/Views/UserViews/SettingsScreen/widgets/pro_subscription_section_riverpod.dart';
import 'package:dima_application/providers/subscription_status_provider.dart';
import 'package:dima_application/navigation/route_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_details_provider.dart';
import '../../../providers/cognito_profile_provider.dart';
import 'widgets/user_details_form_riverpod.dart';
import 'widgets/user_profile_section_riverpod.dart';
import 'widgets/password_change_form_riverpod.dart';
import 'widgets/danger_zone_section_riverpod.dart';
import 'widgets/actions_section_riverpod.dart';

class SettingsScreenRiverpod extends ConsumerStatefulWidget {
  const SettingsScreenRiverpod({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreenRiverpod> createState() =>
      _SettingsScreenRiverpodState();
}

class _SettingsScreenRiverpodState extends ConsumerState<SettingsScreenRiverpod>
    with SingleTickerProviderStateMixin, RouteAware {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  DateTime? _lastVisitTime;

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
    _lastVisitTime = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register with route observer for navigation callbacks
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when user navigates back to this page
    print('[SettingsScreen] User navigated back to settings page');
    _checkAndRefreshIfStale();
    super.didPopNext();
  }

  void _checkAndRefreshIfStale() {
    final now = DateTime.now();
    if (_lastVisitTime != null) {
      final timeSinceLastVisit = now.difference(_lastVisitTime!);
      print('[SettingsScreen] Time since last visit: ${timeSinceLastVisit.inSeconds} seconds');
      
      // If user was away for more than 60 seconds, refresh the data
      if (timeSinceLastVisit.inSeconds > 60) {
        print('[SettingsScreen] Data potentially stale, refreshing...');
        _refreshAllData();
      }
    }
    _lastVisitTime = now;
  }

  void _refreshAllData() {
    // Refresh all data providers used by settings screen
    final refreshTasks = <Future<void>>[];
    
    try {
      refreshTasks.add(ref.read(cognitoProfileProvider.notifier).refresh());
      
      // Get current user ID and refresh user details
      ref.read(userIdProvider.future).then((userId) {
        if (userId != null) {
          ref.read(userDetailsProvider.notifier).loadUserDetails(userId);
        }
      });
      
      refreshTasks.add(ref.read(subscriptionStatusProvider.notifier).refresh());
      
      print('[SettingsScreen] All data refresh tasks initiated');
    } catch (e) {
      print('[SettingsScreen] Error initiating refresh: $e');
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

    final showAppBar = Navigator.canPop(context);
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: showAppBar ? AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ) : null,
      body: SafeArea(
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
                    refreshTasks.add(
                        ref.read(cognitoProfileProvider.notifier).refresh());
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
                            colorScheme, 'Loading subscription...'),
                        error: (error, stackTrace) =>
                            _buildSubscriptionSectionErrorState(colorScheme, theme),
                        data: (data) {
                          final subscriptionData = data.$1;
                          final uniqueId = data.$2;

                          return Column(
                            children: [
                              ProSubscriptionSectionRiverpod(
                                key: ValueKey('subscription_status_$uniqueId'),
                                subscriptionStatus:
                                    subscriptionData.subscriptionStatus,
                                onSubscribe: () async {
                                  return await ref
                                      .read(subscriptionStatusProvider.notifier)
                                      .subscribe();
                                },
                                onUnsubscribe: () async {
                                  return await ref
                                      .read(subscriptionStatusProvider.notifier)
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
                            colorScheme, 'Loading profile...'),
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
                                      .read(cognitoProfileProvider.notifier)
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
                            colorScheme, 'Loading preferences...'),
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
                'Profile Unavailable',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Personal data are currently unavailable. Please try refreshing or check back later.',
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
              'Preferences Unavailable',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your preferences and settings data are currently unavailable. Please try refreshing or check back later.',
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

  Widget _buildSubscriptionSectionErrorState(ColorScheme colorScheme, ThemeData theme) {
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
              'Subscription Status Unavailable',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your subscription status is currently unavailable. Please try refreshing or check back later.',
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
