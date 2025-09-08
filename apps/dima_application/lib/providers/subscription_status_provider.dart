import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/subscription_status_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Provider for the SubscriptionStatusService
final subscriptionStatusServiceProvider =
    Provider<SubscriptionStatusService>((ref) {
  print(
      '[SubscriptionStatusProvider] Creating SubscriptionStatusService instance');
  return SubscriptionStatusService();
});

/// Model class to hold subscription status data
class SubscriptionStatusData {
  final SubscriptionStatusEnum subscriptionStatus;

  const SubscriptionStatusData({
    this.subscriptionStatus = SubscriptionStatusEnum.FREE,
  });

  SubscriptionStatusData copyWith({
    SubscriptionStatusEnum? subscriptionStatus,
  }) {
    return SubscriptionStatusData(
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }

  @override
  String toString() {
    return 'SubscriptionStatusData(subscriptionStatus: $subscriptionStatus)';
  }
}

/// Provider for the subscription status state. The String is a unique ID to force rebuilds.
final subscriptionStatusProvider = StateNotifierProvider<
    SubscriptionStatusNotifier,
    AsyncValue<(SubscriptionStatusData, String)>>((ref) {
  return SubscriptionStatusNotifier(ref);
});

/// Notifier class to manage subscription status state
class SubscriptionStatusNotifier
    extends StateNotifier<AsyncValue<(SubscriptionStatusData, String)>> {
  final Ref ref;
  bool _mounted = true;

  SubscriptionStatusNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  @override
  void dispose() {
    if (!_mounted) {
      return;
    }
    _mounted = false;
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      await loadSubscriptionStatus();
    } catch (error, stackTrace) {
      if (_mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> loadSubscriptionStatus() async {
    print('[SubscriptionStatusNotifier] Loading subscription status...');
    final previousState = state;
    // Set state to loading, but `copyWithPrevious` will keep the old data and set isRefreshing to true.
    state = AsyncValue<(SubscriptionStatusData, String)>.loading()
        .copyWithPrevious(previousState);

    try {
      final service = ref.read(subscriptionStatusServiceProvider);

      final result = await service.getSubscriptionStatus();

      print(
          "[SubscriptionStatusNotifier] Fetched subscription status: $result");

      final subscriptionStatus = result.subscriptionStatus;

      final profileData = SubscriptionStatusData(
        subscriptionStatus: subscriptionStatus,
      );

      print('[SubscriptionStatusNotifier] Profile data loaded: $profileData');
      // On success, update the state with the new data and a unique ID.
      if (_mounted) {
        state = AsyncValue.data((profileData, const Uuid().v4()));
      }
    } catch (error, stackTrace) {
      print('[SubscriptionStatusNotifier] Error loading profile: $error');
      print('[SubscriptionStatusNotifier] Stack trace: $stackTrace');
      // On error, report the error but keep the previous data.
      if (_mounted) {
        state = AsyncValue<(SubscriptionStatusData, String)>.error(
                error, stackTrace)
            .copyWithPrevious(previousState);
      }
    }
  }

  Future<bool> subscribe() async {
    print('[SubscriptionStatusNotifier] Starting subscription process...');
    final previousState = state;
    final previousTuple = previousState.value;

    try {
      final service = ref.read(subscriptionStatusServiceProvider);
      print(
          '[SubscriptionStatusNotifier] Service instance retrieved, calling updateSubscriptionStatus()');

      final result =
          await service.updateSubscriptionStatus(SubscriptionStatusEnum.PRO);
      print(
          '[SubscriptionStatusNotifier] Subscribe service call completed with result: $result');

      if (result.subscriptionStatus == SubscriptionStatusEnum.PRO) {
        print(
            '[SubscriptionStatusNotifier] Subscription successful, user upgraded to PRO');

        // Optimistically update the subscription status
        if (previousTuple != null && _mounted) {
          final updatedProfileData = previousTuple.$1
              .copyWith(subscriptionStatus: SubscriptionStatusEnum.PRO);
          state = AsyncValue.data((updatedProfileData, const Uuid().v4()));
        }

        // Refresh the profile to get the latest data
        await loadSubscriptionStatus();
      } else {
        print(
            '[SubscriptionStatusNotifier] Subscription failed, service returned false');
        // If subscription failed, revert to the previous state
        if (_mounted) {
          state = previousState;
        }
      }

      return result.subscriptionStatus == SubscriptionStatusEnum.PRO;
    } catch (e, stackTrace) {
      print('[SubscriptionStatusNotifier] Error during subscription: $e');
      print('[SubscriptionStatusNotifier] Stack trace: $stackTrace');

      // On error, revert to the previous state (same behavior as other providers)
      if (_mounted) {
        state = previousState;
      }
      return false;
    }
  }

  Future<bool> unsubscribe() async {
    print('[SubscriptionStatusNotifier] Starting unsubscription process...');
    final previousState = state;
    final previousTuple = previousState.value;

    try {
      final service = ref.read(subscriptionStatusServiceProvider);
      print(
          '[SubscriptionStatusNotifier] Service instance retrieved, calling updateSubscriptionStatus()');

      final result =
          await service.updateSubscriptionStatus(SubscriptionStatusEnum.FREE);
      print(
          '[SubscriptionStatusNotifier] Unsubscribe service call completed with result: $result');

      if (result.subscriptionStatus == SubscriptionStatusEnum.FREE) {
        print(
            '[SubscriptionStatusNotifier] Unsubscription successful, user downgraded to FREE');

        // Optimistically update the subscription status
        if (previousTuple != null && _mounted) {
          final updatedProfileData = previousTuple.$1
              .copyWith(subscriptionStatus: SubscriptionStatusEnum.FREE);
          state = AsyncValue.data((updatedProfileData, const Uuid().v4()));
        }

        // Refresh the profile to get the latest data
        await loadSubscriptionStatus();
      } else {
        print(
            '[SubscriptionStatusNotifier] Unsubscription failed, service returned false');
        // If unsubscription failed, revert to the previous state
        if (_mounted) {
          state = previousState;
        }
      }

      return result.subscriptionStatus == SubscriptionStatusEnum.FREE;
    } catch (e, stackTrace) {
      print('[SubscriptionStatusNotifier] Error during unsubscription: $e');
      print('[SubscriptionStatusNotifier] Stack trace: $stackTrace');

      // On error, revert to the previous state (same behavior as other providers)
      if (_mounted) {
        state = previousState;
      }
      return false;
    }
  }

  Future<void> refresh() async {
    print(
        '[SubscriptionStatusNotifier] Force refreshing subscription status...');
    await loadSubscriptionStatus();
  }
}
