// providers/chat_notification_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dima_application/services/chat_service.dart';
import 'dart:async';

// ============================================
// NOTIFICATION PROVIDER
// ============================================
final chatNotificationProvider =
    StateNotifierProvider<ChatNotificationNotifier, ChatNotification?>((ref) {
  return ChatNotificationNotifier();
});

class ChatNotificationNotifier extends StateNotifier<ChatNotification?> {
  Timer? _dismissTimer;

  ChatNotificationNotifier() : super(null);

  void showNotification(ChatNotification notification) {
    state = notification;

    // Auto-dismiss after 4 seconds
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(seconds: 4), () {
      dismiss();
    });
  }

  void dismiss() {
    _dismissTimer?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }
}
