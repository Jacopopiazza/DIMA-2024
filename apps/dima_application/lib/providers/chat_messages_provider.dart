import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Utils/error_handling_utils.dart';
import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/models/Chat/chat_messages_response.dart';
import 'package:dima_application/models/Chat/chat_response.dart';
import 'package:dima_application/models/Chat/chat_state.dart';
import 'package:dima_application/services/auth_service.dart';
import 'package:dima_application/services/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_provider.g.dart';

@riverpod
class ChatMessages extends _$ChatMessages {
  StreamSubscription<ChatResponse>? _messageSubscription;
  String? _currentUserId;
  bool _isLoadingMore = false;

  @override
  FutureOr<ChatState> build(String chatId) async {
    // Set up cleanup on dispose
    ref.onDispose(() {
      try {
        _messageSubscription?.cancel();
        ChatService.instance.setActiveChatId(null);
        safePrint('[ChatMessages] Provider disposed for chat: $chatId');
      } catch (e) {
        safePrint('[ChatMessages] Error during provider disposal: $e');
      }
    });

    // Get current user ID
    try {
      final user = await Amplify.Auth.getCurrentUser();
      _currentUserId = user.userId;
    } catch (e) {
      _currentUserId = await AuthService.getCurrentUserId();
    }

    // Set this chat as active
    ChatService.instance.setActiveChatId(chatId);
    safePrint('[ChatMessages] Set active chat ID to: $chatId');

    // ChatService should already be started globally by AuthStateProvider
    safePrint('[ChatMessages] Checking ChatService status...');
    safePrint(
        '[ChatMessages] ChatService.isListening: ${ChatService.instance.isListening}');
    if (!ChatService.instance.isListening) {
      safePrint(
          '[ChatMessages] *** WARNING: ChatService not listening - should be started by AuthStateProvider ***');
    } else {
      safePrint(
          '[ChatMessages] ChatService already listening - subscription should be active');
    }

    // Set up real-time message subscription
    _setupMessageSubscription(chatId);

    // Load initial messages
    final initialMessages = await _loadMessages(chatId);

    return ChatState(
      chatId: chatId,
      messages: initialMessages.messages,
      hasMoreMessages: initialMessages.hasMore,
      oldestTimestamp: initialMessages.oldestTimestamp,
      isConnected: true,
    );
  }

  void _setupMessageSubscription(String chatId) {
    safePrint(
        '[ChatMessages] *** SETTING UP MESSAGE SUBSCRIPTION for chat: $chatId ***');
    safePrint(
        '[ChatMessages] ChatService messageStream available: ${ChatService.instance.messageStream != const Stream.empty()}');

    // Listen to the general message stream for this specific chat
    _messageSubscription = ChatService.instance.messageStream.where((response) {
      safePrint(
          '[ChatMessages] Filtering message: chatId=${response.message?.chatId}, targetChat=$chatId');
      return response.message?.chatId == chatId;
    }).listen(
      (response) {
        safePrint(
            '[ChatMessages] *** RECEIVED MESSAGE VIA STREAM for chat: $chatId ***');
        safePrint(
            '[ChatMessages] Message content: ${response.message?.messageContent}');
        safePrint(
            '[ChatMessages] Message sender: ${response.message?.senderName}');
        _handleNewMessage(response);
      },
      onError: (error) {
        safePrint('[ChatMessages] *** STREAM ERROR: $error ***');
        // Update state to show connection error but keep existing messages
        final currentState = state.valueOrNull;
        if (currentState != null) {
          try {
            state = AsyncValue.data(currentState.copyWith(isConnected: false));
          } catch (e) {
            safePrint(
                '[ChatMessages] Error updating state after stream error: $e');
          }
        }
      },
      cancelOnError: false, // Don't cancel on error to prevent race conditions
    );

    safePrint(
        '[ChatMessages] *** MESSAGE SUBSCRIPTION SET UP for chat: $chatId ***');
  }

  void _handleNewMessage(ChatResponse response) {
    final currentState = state.valueOrNull;
    if (currentState == null || response.message == null) {
      safePrint(
          '[ChatMessages] Skipping message - currentState is null or no message in response');
      return;
    }

    final newMessage = response.message!;
    safePrint(
        '[ChatMessages] Processing new message: ${newMessage.messageId} for chat: ${newMessage.chatId}');

    // Check if message already exists to avoid duplicates
    final messageExists = currentState.messages.any(
      (msg) => msg.messageId == newMessage.messageId,
    );

    if (!messageExists) {
      final updatedMessages = [...currentState.messages, newMessage]
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

      state = AsyncValue.data(currentState.copyWith(
        messages: updatedMessages,
        isConnected: true,
      ));

      safePrint(
          '[ChatMessages] Added new real-time message: ${newMessage.messageId}. Total messages: ${updatedMessages.length}');
    } else {
      safePrint(
          '[ChatMessages] Message ${newMessage.messageId} already exists, skipping');
    }
  }

  Future<ChatMessagesResponse> _loadMessages(String chatId,
      {String? beforeTimestamp}) async {
    try {
      final response = await ChatService.instance.getChatMessages(
        chatId: chatId,
        beforeTimestamp: beforeTimestamp,
        limit: beforeTimestamp == null
            ? null
            : 20, // Initial load: server decides, pagination: 20
      );

      // Sort messages by timestamp
      final sortedMessages = response.messages
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

      return ChatMessagesResponse(
        messages: sortedMessages,
        hasMore: response.hasMore,
        oldestTimestamp: response.oldestTimestamp,
        count: response.count,
      );
    } catch (e) {
      safePrint('[ChatMessages] Error loading messages: $e');
      rethrow;
    }
  }

  Future<void> sendMessage(String messageContent) async {
    final currentState = state.valueOrNull;
    if (currentState == null || messageContent.trim().isEmpty) return;

    // Create optimistic message
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimisticMessage = ChatMessage(
      id: messageId,
      messageId: messageId,
      chatId: currentState.chatId,
      messageContent: messageContent.trim(),
      senderId: _currentUserId ?? 'unknown',
      senderName: 'You',
      senderType: SenderType.USER,
      sentAt: DateTime.now(),
      recipientId: '', // Will be set by server
    );

    // Add message optimistically
    final updatedMessages = [...currentState.messages, optimisticMessage]
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

    state = AsyncValue.data(currentState.copyWith(messages: updatedMessages));

    try {
      // Send to server
      await ChatService.instance.sendMessage(
        chatId: currentState.chatId,
        messageContent: messageContent.trim(),
      );

      safePrint('[ChatMessages] Message sent successfully: $messageId');
    } catch (e) {
      safePrint('[ChatMessages] Error sending message: $e');

      // Remove optimistic message on failure
      final messagesWithoutFailed = currentState.messages
          .where((msg) => msg.messageId != messageId)
          .toList();

      state = AsyncValue.data(
          currentState.copyWith(messages: messagesWithoutFailed));

      // Re-throw with better error context
      if (ErrorHandlingUtils.isNetworkError(e)) {
        throw Exception(ErrorHandlingUtils.formatErrorMessage(e));
      }
      rethrow;
    }
  }

  Future<void> loadMoreMessages() async {
    // Prevent concurrent loading requests
    if (_isLoadingMore) return;

    final currentState = state.valueOrNull;
    if (currentState == null ||
        !currentState.hasMoreMessages ||
        currentState.oldestTimestamp == null) {
      return;
    }

    _isLoadingMore = true;

    try {
      safePrint('[ChatMessages] Loading more messages...');

      final moreMessages = await _loadMessages(
        currentState.chatId,
        beforeTimestamp: currentState.oldestTimestamp,
      );

      final allMessages = [...moreMessages.messages, ...currentState.messages];

      state = AsyncValue.data(currentState.copyWith(
        messages: allMessages,
        hasMoreMessages: moreMessages.hasMore,
        oldestTimestamp: moreMessages.oldestTimestamp,
      ));

      safePrint(
          '[ChatMessages] Loaded ${moreMessages.messages.length} more messages');
    } catch (e) {
      safePrint('[ChatMessages] Error loading more messages: $e');
      // Don't update state on pagination error, just log it
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    // Force refresh by invalidating and rebuilding
    ref.invalidateSelf();
  }

  String? get currentUserId => _currentUserId;
}

// Provider to track currently active chat
@Riverpod(keepAlive: true)
class ActiveChat extends _$ActiveChat {
  @override
  String? build() => null;

  void setActiveChat(String? chatId) {
    state = chatId;
  }

  void clearActiveChat() {
    state = null;
  }
}

// Global chat notification notifier
class ChatNotificationNotifier extends StateNotifier<ChatNotificationState> {
  final ChatService _chatService = ChatService.instance;
  StreamSubscription<ChatResponse>? _notificationSubscription;
  bool _isDisposed = false;

  ChatNotificationNotifier() : super(const ChatNotificationState()) {
    _initialize();
  }

  void _initialize() {
    if (_isDisposed) return;

    // Store any existing callback (GlobalChatNotificationHandler's)
    final existingCallback = _chatService.onBackgroundMessage;

    // Set up background message handler that calls both handlers
    _chatService.onBackgroundMessage = (response) {
      // Call our handler first (for notification state)
      _handleBackgroundMessage(response);

      // Call existing handler if it exists (for popup notifications)
      if (existingCallback != null) {
        try {
          existingCallback(response);
        } catch (e) {
          safePrint(
              '[ChatNotificationNotifier] Error calling existing callback: $e');
        }
      }
    };

    safePrint(
        '[ChatNotificationNotifier] Callback setup complete. ExistingCallback was: ${existingCallback != null ? 'not null' : 'null'}');
  }

  void _handleBackgroundMessage(ChatResponse response) {
    if (_isDisposed || !mounted) return;

    if (response.message != null) {
      try {
        state = state.addUnreadMessage(response.message!);
        safePrint(
            '[ChatNotificationNotifier] Added unread message for chat: ${response.message!.chatId}');
      } catch (e) {
        safePrint(
            '[ChatNotificationNotifier] Error handling background message: $e');
      }
    }
  }

  void markChatAsRead(String chatId) {
    if (_isDisposed || !mounted) return;

    try {
      state = state.markChatAsRead(chatId);
      safePrint('[ChatNotificationNotifier] Marked chat as read: $chatId');
    } catch (e) {
      safePrint('[ChatNotificationNotifier] Error marking chat as read: $e');
    }
  }

  void clearAllNotifications() {
    if (_isDisposed || !mounted) return;

    try {
      state = const ChatNotificationState();
      safePrint('[ChatNotificationNotifier] Cleared all notifications');
    } catch (e) {
      safePrint('[ChatNotificationNotifier] Error clearing notifications: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _notificationSubscription?.cancel();
    _chatService.onBackgroundMessage = null;
    safePrint('[ChatNotificationNotifier] Disposed');
    super.dispose();
  }
}

// Global chat notifications provider
final chatNotificationProvider =
    StateNotifierProvider<ChatNotificationNotifier, ChatNotificationState>(
  (ref) => ChatNotificationNotifier(),
);
