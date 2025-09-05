import 'package:dima_application/Views/Common/ChatScreen/chat_page.dart';
import 'package:dima_application/Views/Common/chat_notification.dart';
import 'package:dima_application/models/Chat/chat_response.dart';
import 'package:dima_application/models/Chat/chat_state.dart';
import 'package:dima_application/providers/chat_messages_provider.dart';
import 'package:dima_application/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that handles global chat notifications
/// Should be placed high in the widget tree (e.g., in main app)
class GlobalChatNotificationHandler extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalChatNotificationHandler({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<GlobalChatNotificationHandler> createState() =>
      _GlobalChatNotificationHandlerState();
}

class _GlobalChatNotificationHandlerState
    extends ConsumerState<GlobalChatNotificationHandler> {
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _setupChatNotifications();
  }

  void _setupChatNotifications() {
    final chatService = ChatService.instance;

    // Store the existing callback (ChatNotificationNotifier's handler)  
    final existingCallback = chatService.onBackgroundMessage;

    // Set up background message handler that calls both handlers
    chatService.onBackgroundMessage = (response) {
      debugPrint('[GlobalChatNotificationHandler] Master callback invoked for message: ${response.message?.messageContent}');
      
      // Call the existing handler first (ChatNotificationNotifier)
      if (existingCallback != null) {
        try {
          existingCallback(response);
          debugPrint('[GlobalChatNotificationHandler] Existing callback called successfully');
        } catch (e) {
          debugPrint('[GlobalChatNotificationHandler] Error calling existing callback: $e');
        }
      } else {
        debugPrint('[GlobalChatNotificationHandler] No existing callback found');
      }
      
      // Then call our handler for the popup
      try {
        _handleBackgroundChatMessage(response);
        debugPrint('[GlobalChatNotificationHandler] Popup handler called successfully');
      } catch (e) {
        debugPrint('[GlobalChatNotificationHandler] Error in popup handler: $e');
      }
    };
    
    debugPrint('[GlobalChatNotificationHandler] Master callback setup complete. ExistingCallback was: ${existingCallback != null ? 'not null' : 'null'}');
  }

  void _handleBackgroundChatMessage(ChatResponse response) {
    debugPrint('[GlobalChatNotificationHandler] _handleBackgroundChatMessage called');
    debugPrint('[GlobalChatNotificationHandler] _disposed: $_disposed, mounted: $mounted');
    
    if (_disposed || !mounted || response.message == null) {
      debugPrint('[GlobalChatNotificationHandler] Skipping - disposed/not mounted/no message');
      return;
    }

    final message = response.message!;
    debugPrint('[GlobalChatNotificationHandler] Processing message: ${message.messageContent}');

    try {
      final notification = ChatNotificationData.fromChatMessage(message);

      // This should be handled automatically by the ChatNotificationNotifier
      // which listens to the ChatService.onBackgroundMessage

      // Show in-app notification only if widget is still active
      if (mounted && !_disposed) {
        debugPrint('[GlobalChatNotificationHandler] Showing notification for: ${message.messageContent}');
        ChatNotificationManager.showChatNotification(
          context,
          notification,
          onTap: () {
            // Hide the notification first
            ChatNotificationManager.hide();
            // Then open the chat
            _openChatFromNotification(message.chatId, message.senderName);
          },
        );
      } else {
        debugPrint('[GlobalChatNotificationHandler] Not showing notification - widget not ready');
      }
    } catch (e) {
      debugPrint(
          '[GlobalChatNotificationHandler] Error handling background message: $e');
    }
  }

  void _openChatFromNotification(String chatId, String? senderName) {
    if (_disposed || !mounted) return;

    try {
      // Navigate to chat page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatId: chatId,
            title: senderName != null ? 'Chat with $senderName' : 'Chat',
          ),
        ),
      );

      // Mark chat as read
      ref.read(chatNotificationProvider.notifier).markChatAsRead(chatId);
    } catch (e) {
      debugPrint(
          '[GlobalChatNotificationHandler] Error opening chat from notification: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;

    // Clean up notification handler
    try {
      ChatService.instance.onBackgroundMessage = null;
    } catch (e) {
      // Ignore cleanup errors
      debugPrint('[GlobalChatNotificationHandler] Error during cleanup: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Provider that watches for chat notifications and manages app-level state
final globalChatNotificationHandler = Provider<void>((ref) {
  // Watch for chat notification changes globally
  ref.listen<ChatNotificationState>(chatNotificationProvider,
      (previous, current) {
    try {
      if (current.getTotalUnreadCount() > 0) {
        // Could trigger badge updates, push notification registration, etc.
        debugPrint(
            '[GlobalChatNotificationHandler] ${current.getTotalUnreadCount()} unread chat messages');
      }
    } catch (e) {
      debugPrint(
          '[GlobalChatNotificationHandler] Error in notification listener: $e');
    }
  });
});

/// Extension to check if a chat notification handler is properly set up
extension ChatServiceValidation on ChatService {
  bool get hasValidNotificationHandler => onBackgroundMessage != null;

  void validateNotificationSetup() {
    if (!hasValidNotificationHandler) {
      debugPrint(
          '[ChatService] Warning: No background message handler set up. Notifications may not work properly.');
    }
  }
}
