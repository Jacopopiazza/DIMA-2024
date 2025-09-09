import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import required providers
import 'user_details_provider.dart';
import 'cognito_profile_provider.dart';
import 'meal_plans_provider.dart';
import 'subscription_status_provider.dart';
import 'today_page_provider.dart';
import 'meal_plan_notification_provider.dart';
import 'chat_messages_provider.dart';
import 'package:dima_application/services/chat_service.dart';

/// Enum representing different authentication states
enum AuthState {
  unknown,
  signedIn,
  signedOut,
  signingOut,
}

/// Provider that listens to Amplify Auth Hub events
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

/// AuthStateNotifier manages authentication state changes
class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  StreamSubscription<AuthHubEvent>? _authSubscription;

  AuthStateNotifier(this.ref) : super(AuthState.unknown) {
    _initialize();
  }

  Future<void> _initialize() async {
    print('[AuthStateProvider] Initializing auth state listener...');

    // Check current auth status
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        state = AuthState.signedIn;
        print(
            '[AuthStateProvider] Initial auth state: signed in - starting chat service');

        // Start chat service for already signed-in user
        try {
          await ChatService.instance.startListening();
          print(
              '[AuthStateProvider] Chat service started for existing session');
        } catch (e) {
          print(
              '[AuthStateProvider] Error starting chat service for existing session: $e');
        }
      } else {
        state = AuthState.signedOut;
        print('[AuthStateProvider] Initial auth state: signed out');
      }
    } catch (e) {
      print('[AuthStateProvider] Error checking initial auth state: $e');
      // Keep state as unknown when we can't determine auth status
      // (e.g., when Amplify is not configured in tests)
      if (e.toString().contains('plugin has not been added')) {
        print(
            '[AuthStateProvider] Amplify not configured, keeping unknown state');
        // state remains AuthState.unknown
      } else {
        state = AuthState.signedOut;
      }
    }

    // Listen to auth events
    _authSubscription = Amplify.Hub.listen(HubChannel.Auth, _handleAuthEvent);
    print('[AuthStateProvider] Auth hub listener established');
  }

  void _handleAuthEvent(AuthHubEvent event) {
    print('[AuthStateProvider] Auth event received: ${event.type}');

    switch (event.type) {
      case AuthHubEventType.signedIn:
        print('[AuthStateProvider] User signed in - resetting to fresh state');
        state = AuthState.signedIn;
        // Optionally trigger data refresh for new user
        _onUserSignedIn();
        break;

      case AuthHubEventType.signedOut:
        print('[AuthStateProvider] User signed out - clearing all cached data');
        state = AuthState.signedOut;
        _onUserSignedOut();
        break;

      case AuthHubEventType.sessionExpired:
        print('[AuthStateProvider] Session expired - treating as sign out');
        state = AuthState.signedOut;
        _onUserSignedOut();
        break;

      default:
        print('[AuthStateProvider] Other auth event: ${event.type}');
        break;
    }
  }

  void _onUserSignedIn() {
    print(
        '[AuthStateProvider] Processing sign-in: refreshing providers for new user...');
    // Note: We refresh providers for the new user, but we don't need to clear them
    // since each provider handles user-specific data through userIdProvider
    Future.microtask(() async {
      if (mounted) {
        // Small delay to allow auth state to fully stabilize
        await Future.delayed(const Duration(milliseconds: 500));

        // Start chat service for new user session
        try {
          await ChatService.instance.startListening();
          print('[AuthStateProvider] Chat service started for new user');
        } catch (e) {
          print('[AuthStateProvider] Error starting chat service: $e');
        }

        _refreshAllProviders();
      }
    });
  }

  void _onUserSignedOut() {
    print(
        '[AuthStateProvider] Processing sign-out: invalidating all user data...');
    // Clear/reset all user-related providers when user signs out
    Future.microtask(() async {
      if (mounted) {
        // Stop chat service when user signs out
        try {
          await ChatService.instance.stopListening();
          print('[AuthStateProvider] Chat service stopped for signed out user');
        } catch (e) {
          print('[AuthStateProvider] Error stopping chat service: $e');
        }

        _invalidateAllProviders();
      }
    });
  }

  void _refreshAllProviders() {
    try {
      // Refresh critical providers for new user session
      print('[AuthStateProvider] Refreshing providers for new user session...');

      // For sign-in, we need to invalidate userIdProvider to detect new user
      ref.invalidate(userIdProvider);

      // For other providers, try to use refresh methods to preserve state
      try {
        final todayNotifier = ref.read(todayPageProvider.notifier);
        todayNotifier.refreshData();
      } catch (e) {
        ref.invalidate(todayPageProvider);
      }

      try {
        final mealPlansNotifier = ref.read(mealPlansProvider.notifier);
        mealPlansNotifier.backgroundRefresh();
      } catch (e) {
        ref.invalidate(mealPlansProvider);
      }

      // These need to be invalidated to load new user data
      ref.invalidate(userDetailsProvider);
      ref.invalidate(cognitoProfileProvider);
      ref.invalidate(subscriptionStatusProvider);
      ref.invalidate(mealPlanNotificationProvider);
      ref.invalidate(chatNotificationProvider);

      print('[AuthStateProvider] All providers refreshed for new user');
    } catch (e) {
      print('[AuthStateProvider] Error refreshing providers: $e');
    }
  }

  void _invalidateAllProviders() {
    try {
      // Invalidate all user-related providers to clear cached data
      print(
          '[AuthStateProvider] Invalidating all providers due to sign-out...');

      ref.invalidate(userIdProvider);
      ref.invalidate(userDetailsProvider);
      ref.invalidate(cognitoProfileProvider);
      ref.invalidate(mealPlansProvider);
      ref.invalidate(subscriptionStatusProvider);
      ref.invalidate(todayPageProvider);
      ref.invalidate(mealPlanNotificationProvider);
      ref.invalidate(chatNotificationProvider);

      print('[AuthStateProvider] All providers invalidated');
    } catch (e) {
      print('[AuthStateProvider] Error invalidating providers: $e');
    }
  }

  @override
  void dispose() {
    print('[AuthStateProvider] Disposing auth state listener...');

    // Check if already disposed to prevent multiple dispose calls
    if (!mounted) {
      print('[AuthStateProvider] Already disposed, skipping...');
      return;
    }

    _authSubscription?.cancel();
    super.dispose();
  }
}
