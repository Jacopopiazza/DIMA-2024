import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/cognito_profile_service.dart';

/// Provider for the CognitoProfileService
final cognitoProfileServiceProvider = Provider<CognitoProfileService>((ref) {
  print('[CognitoProfileProvider] Creating CognitoProfileService instance');
  return CognitoProfileService();
});

/// Provider for subscribing user (FREE -> PRO)
final subscribeProvider = FutureProvider<bool>((ref) async {
  print('[CognitoProfileProvider] Starting subscription process...');
  try {
    final service = ref.read(cognitoProfileServiceProvider);
    print(
        '[CognitoProfileProvider] Service instance retrieved, calling subscribe()');

    final result = await service.subscribe();
    print(
        '[CognitoProfileProvider] Subscribe service call completed with result: $result');

    if (result) {
      print(
          '[CognitoProfileProvider] Subscription successful, user upgraded to PRO');
    } else {
      print(
          '[CognitoProfileProvider] Subscription failed, service returned false');
    }

    return result;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error during subscription: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});

/// Provider for unsubscribing user (PRO -> FREE)
final unsubscribeProvider = FutureProvider<bool>((ref) async {
  print('[CognitoProfileProvider] Starting unsubscription process...');
  try {
    final service = ref.read(cognitoProfileServiceProvider);
    print(
        '[CognitoProfileProvider] Service instance retrieved, calling unsubscribe()');

    final result = await service.unsubscribe();
    print(
        '[CognitoProfileProvider] Unsubscribe service call completed with result: $result');

    if (result) {
      print(
          '[CognitoProfileProvider] Unsubscription successful, user downgraded to FREE');
    } else {
      print(
          '[CognitoProfileProvider] Unsubscription failed, service returned false');
    }

    return result;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error during unsubscription: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});

/// Provider for getting current subscription status
final subscriptionStatusProvider = FutureProvider<String?>((ref) async {
  print('[CognitoProfileProvider] Fetching current subscription status...');
  try {
    final service = ref.read(cognitoProfileServiceProvider);
    print(
        '[CognitoProfileProvider] Service instance retrieved, calling getSubscriptionStatus()');

    final status = await service.getSubscriptionStatus();
    print('[CognitoProfileProvider] Current subscription status: $status');

    return status;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error fetching subscription status: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});

/// Provider for refreshing subscription status (forces fresh fetch)
final refreshSubscriptionStatusProvider = FutureProvider<String?>((ref) async {
  print('[CognitoProfileProvider] Force refreshing subscription status...');
  try {
    // Invalidate the cached subscription status to force fresh fetch
    ref.invalidate(subscriptionStatusProvider);
    print(
        '[CognitoProfileProvider] Invalidated cached status, fetching fresh data...');

    final service = ref.read(cognitoProfileServiceProvider);
    final status = await service.getSubscriptionStatus();
    print('[CognitoProfileProvider] Fresh subscription status: $status');

    return status;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error refreshing subscription status: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});
