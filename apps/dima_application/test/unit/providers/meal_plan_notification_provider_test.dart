import 'dart:async';

import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plan_notification_provider.dart';
import 'package:dima_application/services/meal_plan_subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock service for testing
class MockMealPlanSubscriptionService extends MealPlanSubscriptionService {
  final StreamController<MealPlanResponse> _controller =
      StreamController<MealPlanResponse>.broadcast();
  bool _isDisposed = false;

  @override
  Stream<MealPlanResponse> get notificationStream => _controller.stream;

  @override
  Future<void> startListening() async {}

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _controller.close();
    }
  }

  void addNotification(MealPlanResponse response) {
    if (!_isDisposed) {
      _controller.add(response);
    }
  }

  void addError(Object error) {
    if (!_isDisposed) {
      _controller.addError(error);
    }
  }
}

void main() {
  group('MealPlanNotificationProvider', () {
    late ProviderContainer container;
    late MockMealPlanSubscriptionService mockService;

    setUp(() async {
      mockService = MockMealPlanSubscriptionService();
      container = ProviderContainer(
        overrides: [
          mealPlanSubscriptionServiceProvider.overrideWithValue(mockService),
        ],
      );
      
      // Trigger the provider initialization by reading it
      container.read(mealPlanNotificationProvider);
      // Wait a bit for initialization to complete
      await Future.delayed(Duration(milliseconds: 50));
    });

    tearDown(() {
      container.dispose();
      // Don't call mockService.dispose() here since the container.dispose()
      // will already dispose the notifier which disposes the service
    });

    group('MealPlanNotification model', () {
      test('initializes with required parameters', () {
        final notification = MealPlanNotification(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
          timestamp: DateTime(2024, 1, 1),
        );

        expect(notification.mealPlanId, 'plan-123');
        expect(notification.message, 'Test notification');
        expect(notification.success, true);
        expect(notification.timestamp, DateTime(2024, 1, 1));
      });

      test('fromMealPlanResponse creates notification correctly', () {
        final response = MealPlanResponse(
          mealPlanId: 'plan-456',
          message: 'Plan updated successfully',
          success: true,
        );

        final notification =
            MealPlanNotification.fromMealPlanResponse(response);

        expect(notification.mealPlanId, 'plan-456');
        expect(notification.message, 'Plan updated successfully');
        expect(notification.success, true);
        expect(notification.timestamp, isA<DateTime>());
      });

      test('fromMealPlanResponse handles null message', () {
        final response = MealPlanResponse(
          mealPlanId: 'plan-789',
          message: null,
          success: false,
        );

        final notification =
            MealPlanNotification.fromMealPlanResponse(response);

        expect(notification.mealPlanId, 'plan-789');
        expect(notification.message, 'Meal plan status updated');
        expect(notification.success, false);
        expect(notification.timestamp, isA<DateTime>());
      });
    });

    group('NotificationState model', () {
      test('initializes with default values', () {
        const state = NotificationState();
        expect(state.notifications, isEmpty);
        expect(state.hasUnreadNotifications, false);
      });

      test('initializes with provided values', () {
        final notifications = [
          MealPlanNotification(
            mealPlanId: 'plan-1',
            message: 'Message 1',
            success: true,
            timestamp: DateTime.now(),
          ),
          MealPlanNotification(
            mealPlanId: 'plan-2',
            message: 'Message 2',
            success: false,
            timestamp: DateTime.now(),
          ),
        ];

        final state = NotificationState(
          notifications: notifications,
          hasUnreadNotifications: true,
        );

        expect(state.notifications, notifications);
        expect(state.hasUnreadNotifications, true);
      });

      test('copyWith works correctly', () {
        final original = NotificationState(
          notifications: [
            MealPlanNotification(
              mealPlanId: 'plan-1',
              message: 'Message 1',
              success: true,
              timestamp: DateTime.now(),
            ),
          ],
          hasUnreadNotifications: true,
        );

        final updated = original.copyWith(
          hasUnreadNotifications: false,
        );

        expect(updated.notifications, original.notifications);
        expect(updated.hasUnreadNotifications, false);
      });

      test('copyWith preserves original values when null', () {
        final original = NotificationState(
          notifications: [
            MealPlanNotification(
              mealPlanId: 'plan-1',
              message: 'Message 1',
              success: true,
              timestamp: DateTime.now(),
            ),
          ],
          hasUnreadNotifications: true,
        );

        final updated = original.copyWith();

        expect(updated.notifications, original.notifications);
        expect(updated.hasUnreadNotifications, original.hasUnreadNotifications);
      });
    });

    group('MealPlanNotificationNotifier', () {
      test('initializes with empty state', () {
        final notifier = container.read(mealPlanNotificationProvider.notifier);
        final state = container.read(mealPlanNotificationProvider);

        expect(state.notifications, isEmpty);
        expect(state.hasUnreadNotifications, false);
      });

      test('handles new notifications', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'New meal plan created',
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications.length, 1);
        expect(state.notifications.first.mealPlanId, 'plan-123');
        expect(state.notifications.first.message, 'New meal plan created');
        expect(state.notifications.first.success, true);
        expect(state.hasUnreadNotifications, true);
      });

      test('handles multiple notifications', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        final response1 = MealPlanResponse(
          mealPlanId: 'plan-1',
          message: 'First notification',
          success: true,
        );

        final response2 = MealPlanResponse(
          mealPlanId: 'plan-2',
          message: 'Second notification',
          success: false,
        );

        mockService.addNotification(response1);
        mockService.addNotification(response2);
        await Future.delayed(Duration(milliseconds: 100));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications.length, 2);
        expect(state.hasUnreadNotifications, true);
      });

      test('limits notifications to 50', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        // Add 55 notifications
        for (int i = 0; i < 55; i++) {
          final response = MealPlanResponse(
            mealPlanId: 'plan-$i',
            message: 'Notification $i',
            success: true,
          );
          mockService.addNotification(response);
        }

        await Future.delayed(Duration(milliseconds: 200));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications.length, 50);
        expect(state.hasUnreadNotifications, true);
      });

      test('markAllAsRead clears unread flag', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        notifier.markAllAsRead();

        final state = container.read(mealPlanNotificationProvider);
        expect(state.hasUnreadNotifications, false);
        expect(state.notifications.length, 1);
      });

      test('clearNotifications resets state', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        notifier.clearNotifications();

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications, isEmpty);
        expect(state.hasUnreadNotifications, false);
      });

      test('restart clears and reinitializes', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        await notifier.restart();

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications, isEmpty);
        expect(state.hasUnreadNotifications, false);
      });

      test('unreadCount returns correct value', () async {
        // Ensure provider is initialized
        container.read(mealPlanNotificationProvider);
        await Future.delayed(Duration(milliseconds: 50));

        final notifier = container.read(mealPlanNotificationProvider.notifier);

        expect(notifier.unreadCount, 0);

        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        expect(notifier.unreadCount, 1);

        notifier.markAllAsRead();
        expect(notifier.unreadCount, 0);
      });

      test('latestNotification returns most recent', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        expect(notifier.latestNotification, isNull);

        final response1 = MealPlanResponse(
          mealPlanId: 'plan-1',
          message: 'First notification',
          success: true,
        );

        final response2 = MealPlanResponse(
          mealPlanId: 'plan-2',
          message: 'Second notification',
          success: false,
        );

        mockService.addNotification(response1);
        await Future.delayed(Duration(milliseconds: 50));

        mockService.addNotification(response2);
        await Future.delayed(Duration(milliseconds: 50));

        final latest = notifier.latestNotification;
        expect(latest, isNotNull);
        expect(latest!.mealPlanId, 'plan-2');
        expect(latest.message, 'Second notification');
      });

      test('handles stream errors gracefully', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        mockService.addError(Exception('Stream error'));
        await Future.delayed(Duration(milliseconds: 100));

        // Should not crash and state should remain unchanged
        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications, isEmpty);
        expect(state.hasUnreadNotifications, false);
      });

      test('disposes correctly', () {
        // Create a separate container for this test to avoid double disposal
        final testService = MockMealPlanSubscriptionService();
        final testContainer = ProviderContainer(
          overrides: [
            mealPlanSubscriptionServiceProvider.overrideWithValue(testService),
          ],
        );
        
        // Just read the notifier to initialize it
        testContainer.read(mealPlanNotificationProvider.notifier);

        // Test that container disposal (which calls notifier.dispose()) works correctly
        expect(() => testContainer.dispose(), returnsNormally);
      });
    });

    group('Service provider', () {
      test('creates service instance', () {
        final service = container.read(mealPlanSubscriptionServiceProvider);
        expect(service, isNotNull);
        expect(service, isA<MockMealPlanSubscriptionService>());
      });
    });

    group('Global notification handler', () {
      test('triggers background refresh on notifications', () async {
        // This test would require mocking the mealPlansProvider
        // For now, we'll test that the provider can be read
        expect(
            () => container.read(globalNotificationHandler), returnsNormally);
      });
    });

    group('Current page provider', () {
      test('starts with null', () {
        final page = container.read(currentPageProvider);
        expect(page, isNull);
      });

      test('can be updated', () {
        final notifier = container.read(currentPageProvider.notifier);

        notifier.state = 'MyPlansPage';
        final page = container.read(currentPageProvider);
        expect(page, 'MyPlansPage');
      });
    });

    group('MyPlansPage refresh provider', () {
      test('can be read without errors', () {
        expect(
            () => container.read(myPlansPageRefreshProvider), returnsNormally);
      });
    });

    group('Edge cases', () {
      test('handles very long notification messages', () async {
        // Ensure provider is initialized
        container.read(mealPlanNotificationProvider);
        await Future.delayed(Duration(milliseconds: 50));

        final longMessage = 'a' * 10000;
        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: longMessage,
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications.length, 1);
        expect(state.notifications.first.message, longMessage);
      });

      test('handles special characters in messages', () async {
        // Ensure provider is initialized
        container.read(mealPlanNotificationProvider);
        await Future.delayed(Duration(milliseconds: 50));

        final specialMessage = '!@#\$%^&*()_+-=[]{}|;:,.<>?🚀🎉💯';
        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: specialMessage,
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 100));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications.length, 1);
        expect(state.notifications.first.message, specialMessage);
      });

      test('handles concurrent notifications', () async {
        // Ensure provider is initialized
        container.read(mealPlanNotificationProvider);
        await Future.delayed(Duration(milliseconds: 50));

        // Send multiple notifications concurrently
        final futures = List.generate(10, (index) async {
          final response = MealPlanResponse(
            mealPlanId: 'plan-$index',
            message: 'Notification $index',
            success: true,
          );
          mockService.addNotification(response);
        });

        await Future.wait(futures);
        await Future.delayed(Duration(milliseconds: 100));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications.length, 10);
        expect(state.hasUnreadNotifications, true);
      });

      test('handles rapid state changes', () async {
        final notifier = container.read(mealPlanNotificationProvider.notifier);

        // Add notification
        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
        );

        mockService.addNotification(response);
        await Future.delayed(Duration(milliseconds: 50));

        // Mark as read
        notifier.markAllAsRead();
        await Future.delayed(Duration(milliseconds: 50));

        // Clear notifications
        notifier.clearNotifications();
        await Future.delayed(Duration(milliseconds: 50));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications, isEmpty);
        expect(state.hasUnreadNotifications, false);
      });
    });

    group('Error handling', () {
      test('handles service disposal during notification', () async {
        // Ensure provider is initialized
        container.read(mealPlanNotificationProvider);
        await Future.delayed(Duration(milliseconds: 50));

        // Dispose service first to prevent further notifications
        mockService.dispose();
        
        // Try to add notification after disposal (should be ignored)
        final response = MealPlanResponse(
          mealPlanId: 'plan-123',
          message: 'Test notification',
          success: true,
        );

        mockService.addNotification(response);

        // Should not crash and no notifications should be processed
        await Future.delayed(Duration(milliseconds: 100));

        final state = container.read(mealPlanNotificationProvider);
        expect(state.notifications, isEmpty);
      });

      test('handles notifier disposal during operation', () {
        // Create a separate container for this test to avoid double disposal in tearDown
        final testService = MockMealPlanSubscriptionService();
        final testContainer = ProviderContainer(
          overrides: [
            mealPlanSubscriptionServiceProvider.overrideWithValue(testService),
          ],
        );
        
        final notifier = testContainer.read(mealPlanNotificationProvider.notifier);

        // Dispose notifier manually
        notifier.dispose();

        // Operations should not crash
        expect(() => notifier.markAllAsRead(), returnsNormally);
        expect(() => notifier.clearNotifications(), returnsNormally);
        
        // Clean up
        testService.dispose();
      });
    });
  });
}
