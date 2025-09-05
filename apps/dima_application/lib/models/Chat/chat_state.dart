import 'package:dima_application/models/Chat/chat_message.dart';

class ChatState {
  final String chatId;
  final List<ChatMessage> messages;
  final bool hasMoreMessages;
  final String? oldestTimestamp;
  final bool isConnected;

  const ChatState({
    required this.chatId,
    this.messages = const [],
    this.hasMoreMessages = true,
    this.oldestTimestamp,
    this.isConnected = true,
  });

  ChatState copyWith({
    String? chatId,
    List<ChatMessage>? messages,
    bool? hasMoreMessages,
    String? oldestTimestamp,
    bool? isConnected,
  }) {
    return ChatState(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      oldestTimestamp: oldestTimestamp ?? this.oldestTimestamp,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  // Computed properties
  bool get isEmpty => messages.isEmpty;
  int get messageCount => messages.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatState &&
        other.chatId == chatId &&
        other.messages == messages &&
        other.hasMoreMessages == hasMoreMessages &&
        other.oldestTimestamp == oldestTimestamp &&
        other.isConnected == isConnected;
  }

  @override
  int get hashCode => Object.hash(
        chatId,
        messages,
        hasMoreMessages,
        oldestTimestamp,
        isConnected,
      );

  @override
  String toString() {
    return 'ChatState(chatId: $chatId, messageCount: $messageCount, hasMoreMessages: $hasMoreMessages, isConnected: $isConnected)';
  }
}

// Global chat notification state for cross-chat notifications
class ChatNotificationState {
  final List<ChatMessage> unreadMessages;
  final Map<String, int> unreadCounts; // chatId -> count

  const ChatNotificationState({
    this.unreadMessages = const [],
    this.unreadCounts = const {},
  });

  ChatNotificationState copyWith({
    List<ChatMessage>? unreadMessages,
    Map<String, int>? unreadCounts,
  }) {
    return ChatNotificationState(
      unreadMessages: unreadMessages ?? this.unreadMessages,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  ChatNotificationState addUnreadMessage(ChatMessage message) {
    final updatedMessages = [...unreadMessages, message];
    final updatedCounts = Map<String, int>.from(unreadCounts);
    updatedCounts[message.chatId] = (updatedCounts[message.chatId] ?? 0) + 1;

    return copyWith(
      unreadMessages: updatedMessages,
      unreadCounts: updatedCounts,
    );
  }

  ChatNotificationState markChatAsRead(String chatId) {
    final updatedMessages =
        unreadMessages.where((message) => message.chatId != chatId).toList();
    final updatedCounts = Map<String, int>.from(unreadCounts);
    updatedCounts.remove(chatId);

    return copyWith(
      unreadMessages: updatedMessages,
      unreadCounts: updatedCounts,
    );
  }

  int getTotalUnreadCount() {
    return unreadCounts.values.fold(0, (sum, count) => sum + count);
  }

  int getUnreadCountForChat(String chatId) {
    return unreadCounts[chatId] ?? 0;
  }
}
