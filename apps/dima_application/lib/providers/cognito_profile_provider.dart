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

/// Provider for getting current user profile attributes
final userProfileAttributesProvider =
    FutureProvider<Map<String, String>>((ref) async {
  print('[CognitoProfileProvider] Fetching current user profile attributes...');
  try {
    final service = ref.read(cognitoProfileServiceProvider);
    print(
        '[CognitoProfileProvider] Service instance retrieved, calling getUserProfileAttributes()');

    final attributes = await service.getUserProfileAttributes();
    print('[CognitoProfileProvider] Current profile attributes: $attributes');

    return attributes;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error fetching profile attributes: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});

/// Provider for updating user profile attributes
final updateUserProfileAttributesProvider =
    FutureProvider.family<bool, Map<String, String>>((ref, attributes) async {
  print('[CognitoProfileProvider] Starting profile attributes update...');
  try {
    final service = ref.read(cognitoProfileServiceProvider);
    print(
        '[CognitoProfileProvider] Service instance retrieved, calling updateUserProfileAttributes()');

    final result = await service.updateUserProfileAttributes(
      givenName: attributes['given_name'],
      familyName: attributes['family_name'],
      gender: attributes['gender'],
      birthdate: attributes['birthdate'],
    );

    if (result) {
      print('[CognitoProfileProvider] Profile attributes update successful');
      // Invalidate the profile attributes provider to refresh the data
      ref.invalidate(userProfileAttributesProvider);
    } else {
      print('[CognitoProfileProvider] Profile attributes update failed');
    }

    return result;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error updating profile attributes: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});

/// Provider for refreshing user profile attributes (forces fresh fetch)
final refreshUserProfileAttributesProvider =
    FutureProvider<Map<String, String>>((ref) async {
  print('[CognitoProfileProvider] Force refreshing user profile attributes...');
  try {
    // Invalidate the cached profile attributes to force fresh fetch
    ref.invalidate(userProfileAttributesProvider);
    print(
        '[CognitoProfileProvider] Invalidated cached profile attributes, fetching fresh data...');

    final service = ref.read(cognitoProfileServiceProvider);
    final attributes = await service.getUserProfileAttributes();
    print('[CognitoProfileProvider] Fresh profile attributes: $attributes');

    return attributes;
  } catch (e, stackTrace) {
    print('[CognitoProfileProvider] Error refreshing profile attributes: $e');
    print('[CognitoProfileProvider] Stack trace: $stackTrace');
    rethrow;
  }
});
