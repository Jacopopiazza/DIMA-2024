// providers/chat_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dima_application/services/chat_service.dart';
import 'dart:async';

// ============================================
// SERVICE PROVIDER
// ============================================
final chatServiceProvider = Provider((ref) => ChatService());

// ============================================
// CHAT MESSAGES PROVIDER (Per Chat)
// ============================================
final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier,
    AsyncValue<List<ChatMessage>>, String>((ref, chatId) {
  return ChatMessagesNotifier(ref, chatId);
});

class ChatMessagesNotifier
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final Ref ref;
  final String chatId;
  StreamSubscription? _subscription;
  final List<ChatMessage> _messages = [];

  ChatMessagesNotifier(this.ref, this.chatId)
      : super(const AsyncValue.loading()) {
    loadMessages();
    subscribeToMessages();
  }

  Future<void> loadMessages() async {
    try {
      final messages =
          await ref.read(chatServiceProvider).getChatMessages(chatId);
      _messages.clear();
      _messages.addAll(messages);
      state = AsyncValue.data(List.from(_messages));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void subscribeToMessages() {
    _subscription =
        ref.read(chatServiceProvider).subscribeToChat(chatId).listen(
      (message) {
        // Add new message to the list
        _messages.add(message);
        state = AsyncValue.data(List.from(_messages));

        // Mark as read if the chat is currently active
        if (_messages.isNotEmpty) {
          ref.read(chatServiceProvider).markMessagesAsRead(
                chatId,
                message.messageId,
              );
        }
      },
      onError: (error) {
        print('Subscription error: $error');
      },
    );
  }

  Future<void> sendMessage(String content) async {
    try {
      final message =
          await ref.read(chatServiceProvider).sendMessage(chatId, content);
      // Message will be added via subscription, but we can optimistically add it
      _messages.add(message);
      state = AsyncValue.data(List.from(_messages));
    } catch (e) {
      // Re-throw to handle in UI
      throw e;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await loadMessages();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// ============================================
// USER CHATS LIST PROVIDER
// ============================================
final userChatsProvider = FutureProvider<List<ChatMetadata>>((ref) async {
  // This would fetch the list of chats for the current user
  // You might need to implement this based on your backend
  return [];
});

// ============================================
// UNREAD MESSAGES PROVIDER
// ============================================
final unreadMessagesProvider = StateProvider<Map<String, int>>((ref) {
  // Track unread message counts per chat
  // Key: chatId, Value: unread count
  return {};
});

// Helper to check if a specific chat has unread messages
final hasUnreadMessagesProvider = Provider.family<bool, String>((ref, chatId) {
  final unreadMap = ref.watch(unreadMessagesProvider);
  return (unreadMap[chatId] ?? 0) > 0;
});
