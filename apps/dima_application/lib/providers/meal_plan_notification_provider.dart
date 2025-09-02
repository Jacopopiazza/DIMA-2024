import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/services/meal_plan_subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification data for meal plan events
class MealPlanNotification {
  final String mealPlanId;
  final String message;
  final bool success;
  final DateTime timestamp;

  const MealPlanNotification({
    required this.mealPlanId,
    required this.message,
    required this.success,
    required this.timestamp,
  });

  factory MealPlanNotification.fromMealPlanResponse(MealPlanResponse response) {
    return MealPlanNotification(
      mealPlanId: response.mealPlanId,
      message: response.message ?? 'Meal plan status updated',
      success: response.success,
      timestamp: DateTime.now(),
    );
  }
}

/// Global state for managing in-app notifications
class NotificationState {
  final List<MealPlanNotification> notifications;
  final bool hasUnreadNotifications;

  const NotificationState({
    this.notifications = const [],
    this.hasUnreadNotifications = false,
  });

  NotificationState copyWith({
    List<MealPlanNotification>? notifications,
    bool? hasUnreadNotifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      hasUnreadNotifications:
          hasUnreadNotifications ?? this.hasUnreadNotifications,
    );
  }
}

/// Notifier for handling meal plan notifications
class MealPlanNotificationNotifier extends StateNotifier<NotificationState> {
  final MealPlanSubscriptionService _subscriptionService;
  final StateNotifierProviderRef<MealPlanNotificationNotifier, NotificationState> _ref;
  StreamSubscription<MealPlanResponse>? _notificationSubscription;

  MealPlanNotificationNotifier(this._subscriptionService, this._ref)
      : super(const NotificationState()) {
    _initializeNotifications();
  }

  /// Initialize the notification system
  Future<void> _initializeNotifications() async {
    try {
      // Start listening to meal plan notifications
      await _subscriptionService.startListening();

      // Subscribe to the notification stream
      _notificationSubscription =
          _subscriptionService.notificationStream.listen(
        _handleMealPlanResponse,
        onError: (error) {
          safePrint('[MealPlanNotificationNotifier] Error in notification stream: $error');
        },
      );

      safePrint('[MealPlanNotificationNotifier] Meal plan notification system initialized');
    } catch (e) {
      safePrint('[MealPlanNotificationNotifier] Error initializing notifications: $e');
    }
  }

  /// Handle incoming meal plan responses
  void _handleMealPlanResponse(MealPlanResponse response) {
    final notification = MealPlanNotification.fromMealPlanResponse(response);

    // Add notification to the list
    final updatedNotifications = [...state.notifications, notification];

    // Keep only the last 50 notifications to prevent memory issues
    final trimmedNotifications = updatedNotifications.length > 50
        ? updatedNotifications.skip(updatedNotifications.length - 50).toList()
        : updatedNotifications;

    state = state.copyWith(
      notifications: trimmedNotifications,
      hasUnreadNotifications: true,
    );

    safePrint('[MealPlanNotificationNotifier] New meal plan notification: ${notification.message}');
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    state = state.copyWith(hasUnreadNotifications: false);
  }

  /// Clear all notifications
  void clearNotifications() {
    state = const NotificationState();
  }

  /// Get unread notification count
  int get unreadCount =>
      state.hasUnreadNotifications ? state.notifications.length : 0;

  /// Get the latest notification
  MealPlanNotification? get latestNotification =>
      state.notifications.isNotEmpty ? state.notifications.last : null;

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _subscriptionService.dispose();
    super.dispose();
  }
}

/// Provider for the meal plan subscription service
final mealPlanSubscriptionServiceProvider =
    Provider<MealPlanSubscriptionService>((ref) {
  return MealPlanSubscriptionService();
});

/// Provider for meal plan notifications  
final mealPlanNotificationProvider =
    StateNotifierProvider<MealPlanNotificationNotifier, NotificationState>(
        (ref) {
  final subscriptionService = ref.watch(mealPlanSubscriptionServiceProvider);
  return MealPlanNotificationNotifier(subscriptionService, ref);
});

/// Global notification handler that performs background refresh
/// This is a separate provider to avoid circular dependencies
final globalNotificationHandler = Provider<void>((ref) {
  // Watch for notification changes globally
  ref.listen(mealPlanNotificationProvider, (previous, current) {
    if (current.hasUnreadNotifications && current.notifications.isNotEmpty) {
      // Perform background refresh when notifications arrive
      final mealPlansNotifier = ref.read(mealPlansProvider.notifier);
      mealPlansNotifier.backgroundRefresh();
      
      safePrint('[GlobalNotificationHandler] Background refresh triggered due to notification');
    }
  });
});

/// Provider for checking if user is currently on MyPlansPage
final currentPageProvider = StateProvider<String?>((ref) => null);

/// Special provider for triggering meal plan list refresh when on MyPlansPage
final myPlansPageRefreshProvider = Provider<void>((ref) {
  final currentPage = ref.watch(currentPageProvider);
  final notificationState = ref.watch(mealPlanNotificationProvider);

  // If user is on MyPlansPage and there are new notifications, trigger refresh
  if (currentPage == 'MyPlansPage' &&
      notificationState.hasUnreadNotifications) {
    // This will cause any widgets watching this provider to rebuild
    // The actual refresh logic will be handled in MyPlansPage
  }
});
