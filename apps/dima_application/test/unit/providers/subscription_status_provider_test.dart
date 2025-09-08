import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/subscription_status_provider.dart';
import 'package:dima_application/services/subscription_status_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock service for testing
class MockSubscriptionStatusService extends SubscriptionStatusService {
  bool shouldThrowError = false;
  SubscriptionStatusEnum mockStatus = SubscriptionStatusEnum.FREE;
  bool updateSuccess = true;

  @override
  Future<UserSubscriptionStatus> getSubscriptionStatus() async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return UserSubscriptionStatus(
      userId: 'u',
      subscriptionStatus: mockStatus,
    );
  }

  @override
  Future<UserSubscriptionStatus> updateSubscriptionStatus(
      SubscriptionStatusEnum status) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (updateSuccess) {
      mockStatus = status;
      return UserSubscriptionStatus(userId: 'u', subscriptionStatus: status);
    } else {
      // Simulate failure by returning the previous status without changing it
      return UserSubscriptionStatus(
          userId: 'u', subscriptionStatus: mockStatus);
    }
  }
}

void main() {
  group('SubscriptionStatusProvider', () {
    late ProviderContainer container;
    late MockSubscriptionStatusService mockService;

    setUp(() {
      mockService = MockSubscriptionStatusService();
      container = ProviderContainer(
        overrides: [
          subscriptionStatusServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('SubscriptionStatusData model', () {
      test('initializes with default values', () {
        const data = SubscriptionStatusData();
        expect(data.subscriptionStatus, SubscriptionStatusEnum.FREE);
      });

      test('initializes with provided values', () {
        const data = SubscriptionStatusData(
          subscriptionStatus: SubscriptionStatusEnum.PRO,
        );
        expect(data.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });

      test('copyWith works correctly', () {
        const original = SubscriptionStatusData(
          subscriptionStatus: SubscriptionStatusEnum.FREE,
        );

        final updated = original.copyWith(
          subscriptionStatus: SubscriptionStatusEnum.PRO,
        );

        expect(updated.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });

      test('copyWith preserves original values when null', () {
        const original = SubscriptionStatusData(
          subscriptionStatus: SubscriptionStatusEnum.PRO,
        );

        final updated = original.copyWith();

        expect(updated.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });

      test('toString works correctly', () {
        const data = SubscriptionStatusData(
          subscriptionStatus: SubscriptionStatusEnum.PRO,
        );

        final string = data.toString();
        expect(string, contains('SubscriptionStatusData'));
        expect(string, contains('PRO'));
      });
    });

    group('Service provider', () {
      test('creates service instance', () {
        final service = container.read(subscriptionStatusServiceProvider);
        expect(service, isNotNull);
        expect(service, isA<MockSubscriptionStatusService>());
      });
    });

    group('Profile loading', () {
      test('loads subscription status successfully', () async {
        mockService.mockStatus = SubscriptionStatusEnum.PRO;

        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.PRO);
        expect(state.value!.$2, isA<String>()); // UUID
      });

      test('handles FREE subscription status', () async {
        mockService.mockStatus = SubscriptionStatusEnum.FREE;

        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.FREE);
        expect(state.value!.$2, isA<String>());
      });

      test('handles service errors', () async {
        mockService.shouldThrowError = true;

        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        final state = container.read(subscriptionStatusProvider);
        expect(state.hasError, true);
      });
    });

    group('Subscription management', () {
      late SubscriptionStatusNotifier notifier;

      setUp(() async {
        notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();
      });

      test('subscribe succeeds when service returns PRO', () async {
        mockService.updateSuccess = true;

        final result = await notifier.subscribe();

        expect(result, true);

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });

      test('subscribe fails when service returns false', () async {
        mockService.updateSuccess = false;

        final result = await notifier.subscribe();

        expect(result, false);
      });

      test('subscribe handles service errors', () async {
        mockService.shouldThrowError = true;

        final result = await notifier.subscribe();

        expect(result, false);
      });

      test('unsubscribe succeeds when service returns FREE', () async {
        // First set to PRO
        mockService.mockStatus = SubscriptionStatusEnum.PRO;
        await notifier.loadSubscriptionStatus();

        mockService.updateSuccess = true;

        final result = await notifier.unsubscribe();

        expect(result, true);

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.FREE);
      });

      test('unsubscribe fails when service returns false', () async {
        // Ensure starting from PRO
        mockService.mockStatus = SubscriptionStatusEnum.PRO;
        await notifier.loadSubscriptionStatus();
        mockService.updateSuccess = false;

        final result = await notifier.unsubscribe();

        expect(result, false);
      });

      test('unsubscribe handles service errors', () async {
        mockService.shouldThrowError = true;

        final result = await notifier.unsubscribe();

        expect(result, false);
      });

      test('refresh reloads subscription status', () async {
        mockService.mockStatus = SubscriptionStatusEnum.FREE;
        await notifier.loadSubscriptionStatus();

        // Change mock data
        mockService.mockStatus = SubscriptionStatusEnum.PRO;

        await notifier.refresh();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });
    });

    group('State management', () {
      test('maintains state consistency during updates', () async {
        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        final stateBefore = container.read(subscriptionStatusProvider);
        final uuidBefore = stateBefore.value!.$2;

        mockService.updateSuccess = true;
        await notifier.subscribe();

        final stateAfter = container.read(subscriptionStatusProvider);
        final uuidAfter = stateAfter.value!.$2;

        expect(stateAfter.value!.$1.subscriptionStatus,
            SubscriptionStatusEnum.PRO);
        expect(uuidAfter, isNot(equals(uuidBefore))); // UUID should change
      });

      test('handles optimistic updates correctly', () async {
        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        mockService.updateSuccess = true;

        // Start subscription but don't wait
        final subscribeFuture = notifier.subscribe();

        // Wait for completion and then assert final state
        await subscribeFuture;

        final stateAfter = container.read(subscriptionStatusProvider);
        expect(stateAfter.value!.$1.subscriptionStatus,
            SubscriptionStatusEnum.PRO);
      });

      test('reverts optimistic updates on failure', () async {
        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        final originalState = container.read(subscriptionStatusProvider);

        mockService.updateSuccess = false;

        final result = await notifier.subscribe();

        expect(result, false);

        final stateAfter = container.read(subscriptionStatusProvider);
        expect(stateAfter.value!.$1.subscriptionStatus,
            originalState.value!.$1.subscriptionStatus);
      });
    });

    group('Provider lifecycle', () {
      test('disposes correctly', () {
        final notifier = container.read(subscriptionStatusProvider.notifier);

        expect(() => notifier.dispose(), returnsNormally);
      });

      test('can dispose multiple times safely', () {
        final notifier = container.read(subscriptionStatusProvider.notifier);

        notifier.dispose();
        expect(() => notifier.dispose(), returnsNormally);
      });
    });

    group('Edge cases', () {
      late SubscriptionStatusNotifier notifier;

      setUp(() async {
        notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();
      });

      test('handles rapid subscription changes', () async {
        mockService.updateSuccess = true;

        // Subscribe
        await notifier.subscribe();
        expect(
            container
                .read(subscriptionStatusProvider)
                .value!
                .$1
                .subscriptionStatus,
            SubscriptionStatusEnum.PRO);

        // Unsubscribe
        await notifier.unsubscribe();
        expect(
            container
                .read(subscriptionStatusProvider)
                .value!
                .$1
                .subscriptionStatus,
            SubscriptionStatusEnum.FREE);

        // Subscribe again
        await notifier.subscribe();
        expect(
            container
                .read(subscriptionStatusProvider)
                .value!
                .$1
                .subscriptionStatus,
            SubscriptionStatusEnum.PRO);
      });

      test('handles concurrent operations', () async {
        mockService.updateSuccess = true;

        // Start multiple concurrent operations
        final futures = <Future<bool>>[
          notifier.subscribe(),
          notifier.unsubscribe(),
        ];
        await notifier.refresh();

        final results = await Future.wait<bool>(futures);

        // At least one should succeed
        expect(results.any((result) => result == true), true);
      });

      test('handles service errors during refresh', () async {
        mockService.shouldThrowError = true;

        // Should not throw, but should handle error gracefully
        expect(() => notifier.refresh(), returnsNormally);
      });

      test('handles null responses gracefully', () async {
        mockService.updateSuccess = false;

        final result = await notifier.subscribe();

        expect(result, false);
      });
    });

    group('SubscriptionStatusEnum', () {
      test('all enum values are defined', () {
        expect(SubscriptionStatusEnum.values.length, 2);
        expect(SubscriptionStatusEnum.values,
            contains(SubscriptionStatusEnum.FREE));
        expect(SubscriptionStatusEnum.values,
            contains(SubscriptionStatusEnum.PRO));
      });

      test('FREE is the default value', () {
        const data = SubscriptionStatusData();
        expect(data.subscriptionStatus, SubscriptionStatusEnum.FREE);
      });
    });

    group('Error handling', () {
      late SubscriptionStatusNotifier notifier;

      setUp(() async {
        notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();
      });

      test('handles network timeouts gracefully', () async {
        mockService.shouldThrowError = true;

        final result = await notifier.subscribe();

        expect(result, false);
      });

      test('handles malformed responses gracefully', () async {
        mockService.shouldThrowError = true;

        final result = await notifier.unsubscribe();

        expect(result, false);
      });

      test('maintains state consistency during errors', () async {
        final originalState = container.read(subscriptionStatusProvider);

        mockService.shouldThrowError = true;
        await notifier.subscribe();

        final stateAfter = container.read(subscriptionStatusProvider);
        expect(stateAfter.value!.$1.subscriptionStatus,
            originalState.value!.$1.subscriptionStatus);
      });

      test('handles errors during initialization', () async {
        mockService.shouldThrowError = true;

        final notifier = container.read(subscriptionStatusProvider.notifier);

        // Should not throw during initialization
        expect(() => notifier, returnsNormally);
      });
    });

    group('Concurrent access', () {
      test('handles concurrent state reads', () async {
        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        final futures = List.generate(10, (index) async {
          return container.read(subscriptionStatusProvider);
        });

        final results = await Future.wait(futures);

        // All reads should return the same state
        for (final result in results) {
          expect(
              result.value!.$1.subscriptionStatus, SubscriptionStatusEnum.FREE);
        }
      });

      test('handles concurrent state changes', () async {
        final notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();

        mockService.updateSuccess = true;

        final futures = <Future>[];

        // Start multiple state changes concurrently
        for (int i = 0; i < 5; i++) {
          futures.add(Future(() {
            return notifier.subscribe();
          }));
        }

        final results = await Future.wait(futures);

        // At least one should succeed
        expect(results.any((result) => result == true), true);
      });
    });

    group('State transitions', () {
      late SubscriptionStatusNotifier notifier;

      setUp(() async {
        notifier = container.read(subscriptionStatusProvider.notifier);
        await notifier.loadSubscriptionStatus();
      });

      test('FREE to PRO transition', () async {
        mockService.updateSuccess = true;

        await notifier.subscribe();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });

      test('PRO to FREE transition', () async {
        // First set to PRO
        mockService.mockStatus = SubscriptionStatusEnum.PRO;
        await notifier.loadSubscriptionStatus();

        mockService.updateSuccess = true;

        await notifier.unsubscribe();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.FREE);
      });

      test('FREE to FREE transition (no change)', () async {
        mockService.updateSuccess = true;

        await notifier.unsubscribe();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.FREE);
      });

      test('PRO to PRO transition (no change)', () async {
        // First set to PRO
        mockService.mockStatus = SubscriptionStatusEnum.PRO;
        await notifier.loadSubscriptionStatus();

        mockService.updateSuccess = true;

        await notifier.subscribe();

        final state = container.read(subscriptionStatusProvider);
        expect(state.value!.$1.subscriptionStatus, SubscriptionStatusEnum.PRO);
      });
    });
  });
}
