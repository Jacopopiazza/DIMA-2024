import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../services/cognito_profile_service.dart';

/// Provider for the CognitoProfileService
final cognitoProfileServiceProvider = Provider<CognitoProfileService>((ref) {
  print('[CognitoProfileProvider] Creating CognitoProfileService instance');
  return CognitoProfileService();
});

/// Model class to hold cognito profile data
class CognitoProfileData {
  final String subscriptionStatus;
  final Map<String, String> userAttributes;

  const CognitoProfileData({
    this.subscriptionStatus = '',
    this.userAttributes = const {},
  });

  CognitoProfileData copyWith({
    String? subscriptionStatus,
    Map<String, String>? userAttributes,
  }) {
    return CognitoProfileData(
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      userAttributes: userAttributes ?? this.userAttributes,
    );
  }

  @override
  String toString() {
    return 'CognitoProfileData(subscriptionStatus: $subscriptionStatus, userAttributes: $userAttributes)';
  }
}

/// Provider for the cognito profile state. The String is a unique ID to force rebuilds.
final cognitoProfileProvider = StateNotifierProvider<CognitoProfileNotifier,
    AsyncValue<(CognitoProfileData, String)>>((ref) {
  return CognitoProfileNotifier(ref);
});

/// Notifier class to manage cognito profile state
class CognitoProfileNotifier
    extends StateNotifier<AsyncValue<(CognitoProfileData, String)>> {
  final Ref ref;

  CognitoProfileNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await loadCognitoProfile();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadCognitoProfile() async {
    print('[CognitoProfileNotifier] Loading cognito profile...');
    final previousState = state;
    // Set state to loading, but `copyWithPrevious` will keep the old data and set isRefreshing to true.
    state = AsyncValue<(CognitoProfileData, String)>.loading()
        .copyWithPrevious(previousState);

    try {
      final service = ref.read(cognitoProfileServiceProvider);
      
      // Fetch subscription status and user attributes concurrently
      final results = await Future.wait([
        service.getSubscriptionStatus(),
        service.getUserProfileAttributes(),
      ]);

      final subscriptionStatus = results[0] as String;
      final userAttributes = results[1] as Map<String, String>;

      final profileData = CognitoProfileData(
        subscriptionStatus: subscriptionStatus,
        userAttributes: userAttributes,
      );

      print('[CognitoProfileNotifier] Profile data loaded: $profileData');
      // On success, update the state with the new data and a unique ID.
      state = AsyncValue.data((profileData, const Uuid().v4()));
    } catch (error, stackTrace) {
      print('[CognitoProfileNotifier] Error loading profile: $error');
      print('[CognitoProfileNotifier] Stack trace: $stackTrace');
      // On error, report the error but keep the previous data.
      state = AsyncValue<(CognitoProfileData, String)>.error(error, stackTrace)
          .copyWithPrevious(previousState);
    }
  }

  Future<bool> subscribe() async {
    print('[CognitoProfileNotifier] Starting subscription process...');
    final previousState = state;
    final previousTuple = previousState.value;

    try {
      final service = ref.read(cognitoProfileServiceProvider);
      print('[CognitoProfileNotifier] Service instance retrieved, calling subscribe()');

      final result = await service.subscribe();
      print('[CognitoProfileNotifier] Subscribe service call completed with result: $result');

      if (result) {
        print('[CognitoProfileNotifier] Subscription successful, user upgraded to PRO');
        
        // Optimistically update the subscription status
        if (previousTuple != null) {
          final updatedProfileData = previousTuple.$1.copyWith(subscriptionStatus: 'PRO');
          state = AsyncValue.data((updatedProfileData, const Uuid().v4()));
        }
        
        // Refresh the profile to get the latest data
        await loadCognitoProfile();
      } else {
        print('[CognitoProfileNotifier] Subscription failed, service returned false');
      }

      return result;
    } catch (e, stackTrace) {
      print('[CognitoProfileNotifier] Error during subscription: $e');
      print('[CognitoProfileNotifier] Stack trace: $stackTrace');
      
      // On error, keep the previous state
      state = AsyncValue<(CognitoProfileData, String)>.error(e, stackTrace)
          .copyWithPrevious(previousState);
      return false;
    }
  }

  Future<bool> unsubscribe() async {
    print('[CognitoProfileNotifier] Starting unsubscription process...');
    final previousState = state;
    final previousTuple = previousState.value;

    try {
      final service = ref.read(cognitoProfileServiceProvider);
      print('[CognitoProfileNotifier] Service instance retrieved, calling unsubscribe()');

      final result = await service.unsubscribe();
      print('[CognitoProfileNotifier] Unsubscribe service call completed with result: $result');

      if (result) {
        print('[CognitoProfileNotifier] Unsubscription successful, user downgraded to FREE');
        
        // Optimistically update the subscription status
        if (previousTuple != null) {
          final updatedProfileData = previousTuple.$1.copyWith(subscriptionStatus: 'FREE');
          state = AsyncValue.data((updatedProfileData, const Uuid().v4()));
        }
        
        // Refresh the profile to get the latest data
        await loadCognitoProfile();
      } else {
        print('[CognitoProfileNotifier] Unsubscription failed, service returned false');
      }

      return result;
    } catch (e, stackTrace) {
      print('[CognitoProfileNotifier] Error during unsubscription: $e');
      print('[CognitoProfileNotifier] Stack trace: $stackTrace');
      
      // On error, keep the previous state
      state = AsyncValue<(CognitoProfileData, String)>.error(e, stackTrace)
          .copyWithPrevious(previousState);
      return false;
    }
  }

  Future<bool> updateUserProfileAttributes({
    String? givenName,
    String? familyName,
    String? gender,
    String? birthdate,
  }) async {
    print('[CognitoProfileNotifier] Starting profile attributes update...');
    final previousState = state;
    final previousTuple = previousState.value;

    if (previousTuple == null) {
      // Cannot update if there's no previous state
      return false;
    }

    // Create optimistic update
    final currentAttributes = previousTuple.$1.userAttributes;
    final updatedAttributes = Map<String, String>.from(currentAttributes);
    
    if (givenName != null) updatedAttributes['given_name'] = givenName;
    if (familyName != null) updatedAttributes['family_name'] = familyName;
    if (gender != null) updatedAttributes['gender'] = gender;
    if (birthdate != null) updatedAttributes['birthdate'] = birthdate;

    // Optimistically update the UI, but REUSE the existing unique ID to prevent rebuild
    final updatedProfileData = previousTuple.$1.copyWith(userAttributes: updatedAttributes);
    state = AsyncValue.data((updatedProfileData, previousTuple.$2));

    try {
      final service = ref.read(cognitoProfileServiceProvider);
      print('[CognitoProfileNotifier] Service instance retrieved, calling updateUserProfileAttributes()');

      final result = await service.updateUserProfileAttributes(
        givenName: givenName,
        familyName: familyName,
        gender: gender,
        birthdate: birthdate,
      );

      if (result) {
        print('[CognitoProfileNotifier] Profile attributes update successful');
        // The optimistic update was correct. We can now assign a new ID to mark a "clean" state.
        state = AsyncValue.data((updatedProfileData, const Uuid().v4()));
        return true;
      } else {
        print('[CognitoProfileNotifier] Profile attributes update failed');
        // If update failed, revert to the previous state
        state = previousState;
        return false;
      }
    } catch (e, stackTrace) {
      print('[CognitoProfileNotifier] Error updating profile attributes: $e');
      print('[CognitoProfileNotifier] Stack trace: $stackTrace');
      
      // If update failed, revert to previous state and show error
      state = AsyncValue<(CognitoProfileData, String)>.error(e, stackTrace)
          .copyWithPrevious(previousState);
      return false;
    }
  }

  Future<void> refresh() async {
    print('[CognitoProfileNotifier] Force refreshing cognito profile...');
    await loadCognitoProfile();
  }
}

// Convenience providers for specific data access
final subscriptionStatusProvider = Provider<String?>((ref) {
  final profileState = ref.watch(cognitoProfileProvider);
  return profileState.value?.$1.subscriptionStatus;
});

final userProfileAttributesProvider = Provider<Map<String, String>>((ref) {
  final profileState = ref.watch(cognitoProfileProvider);
  return profileState.value?.$1.userAttributes ?? {};
});

// Provider to check if profile is loading/refreshing
final isProfileLoadingProvider = Provider<bool>((ref) {
  final profileState = ref.watch(cognitoProfileProvider);
  return profileState.isLoading || profileState.isRefreshing;
});

// Provider to get profile error
final profileErrorProvider = Provider<Object?>((ref) {
  final profileState = ref.watch(cognitoProfileProvider);
  return profileState.error;
});