// services/chat_service.dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'dart:async';
import 'dart:convert';

// ============================================
// MODELS
// ============================================
class ChatMessage {
  final String chatId;
  final String messageId;
  final String senderId;
  final String senderType;
  final String messageContent;
  final DateTime sentAt;

  ChatMessage({
    required this.chatId,
    required this.messageId,
    required this.senderId,
    required this.senderType,
    required this.messageContent,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatId: json['chatId'] ?? '',
      messageId: json['messageId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderType: json['senderType'] ?? 'USER',
      messageContent: json['messageContent'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class ChatMetadata {
  final String chatId;
  final String userId;
  final String nutritionistId;
  final String mealPlanId;
  final String planName;
  final String userGivenName;
  final String nutritionistGivenName;
  final int userUnreadCount;
  final int nutritionistUnreadCount;

  ChatMetadata({
    required this.chatId,
    required this.userId,
    required this.nutritionistId,
    required this.mealPlanId,
    required this.planName,
    required this.userGivenName,
    required this.nutritionistGivenName,
    required this.userUnreadCount,
    required this.nutritionistUnreadCount,
  });

  factory ChatMetadata.fromJson(Map<String, dynamic> json) {
    return ChatMetadata(
      chatId: json['chatId'] ?? '',
      userId: json['userId'] ?? '',
      nutritionistId: json['nutritionistId'] ?? '',
      mealPlanId: json['mealPlanId'] ?? '',
      planName: json['planName'] ?? 'Meal Plan',
      userGivenName: json['userGivenName'] ?? 'User',
      nutritionistGivenName: json['nutritionistGivenName'] ?? 'Nutritionist',
      userUnreadCount: json['userUnreadCount'] ?? 0,
      nutritionistUnreadCount: json['nutritionistUnreadCount'] ?? 0,
    );
  }
}

// ============================================
// CHAT SERVICE
// ============================================
class ChatService {
  // Get chat messages
  Future<List<ChatMessage>> getChatMessages(String chatId,
      {int limit = 50, String? nextToken}) async {
    const String query = '''
      query GetChatMessages(\$chatId: ID!, \$limit: Int, \$nextToken: String) {
        getChatMessages(chatId: \$chatId, limit: \$limit, nextToken: \$nextToken) {
          items {
            chatId
            messageId
            senderId
            senderType
            messageContent
            sentAt
          }
          nextToken
        }
      }
    ''';

    try {
      final variables = {
        'chatId': chatId,
        'limit': limit,
        if (nextToken != null) 'nextToken': nextToken,
      };

      final request = GraphQLRequest<String>(
        document: query,
        variables: variables,
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final json = jsonDecode(response.data!);
        final items = json['getChatMessages']['items'] as List;
        return items.map((item) => ChatMessage.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      safePrint('Error loading messages: $e');
      throw e;
    }
  }

  // Send a message
  Future<ChatMessage> sendMessage(String chatId, String messageContent) async {
    const String mutation = '''
      mutation SendMessage(\$input: SendMessageInput!) {
        sendChatMessage(input: \$input) {
          chatId
          messageId
          senderId
          senderType
          messageContent
          sentAt
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'chatId': chatId,
            'messageContent': messageContent,
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final json = jsonDecode(response.data!);
        return ChatMessage.fromJson(json['sendChatMessage']);
      }
      throw Exception('Failed to send message');
    } catch (e) {
      safePrint('Error sending message: $e');
      throw e;
    }
  }

  // Subscribe to chat messages for a specific chat
  Stream<ChatMessage> subscribeToChat(String chatId) {
    const String subscription = '''
      subscription OnNewMessage(\$chatId: ID!) {
        onNewChatMessage(chatId: \$chatId) {
          chatId
          messageId
          senderId
          senderType
          messageContent
          sentAt
        }
      }
    ''';

    final request = GraphQLRequest<String>(
      document: subscription,
      variables: {'chatId': chatId},
    );

    return Amplify.API
        .subscribe(
      request,
      onEstablished: () =>
          safePrint('Chat subscription established for chat: $chatId'),
    )
        .map((event) {
      if (event.data != null) {
        try {
          final json = jsonDecode(event.data!);
          return ChatMessage.fromJson(json['onNewChatMessage']);
        } catch (e) {
          safePrint('Error parsing chat message: $e');
          throw e;
        }
      }
      throw Exception('No data in subscription event');
    });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(
      String chatId, String lastReadMessageId) async {
    const String mutation = '''
      mutation MarkMessagesAsRead(\$chatId: ID!, \$lastReadMessageId: ID!) {
        markMessagesAsRead(chatId: \$chatId, lastReadMessageId: \$lastReadMessageId) {
          chatId
          userId
          lastReadMessageId
          readAt
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'chatId': chatId,
          'lastReadMessageId': lastReadMessageId,
        },
      );

      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      safePrint('Error marking messages as read: $e');
      // Non-critical error, don't throw
    }
  }
}

// ============================================
// GLOBAL CHAT SUBSCRIPTION SERVICE
// ============================================
class ChatNotification {
  final String chatId;
  final String mealPlanId;
  final String senderName;
  final String message;
  final DateTime timestamp;

  ChatNotification({
    required this.chatId,
    required this.mealPlanId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });
}

class GlobalChatSubscriptionService {
  static final GlobalChatSubscriptionService _instance =
      GlobalChatSubscriptionService._internal();

  factory GlobalChatSubscriptionService() => _instance;
  GlobalChatSubscriptionService._internal();

  StreamSubscription<GraphQLResponse<String>>? _globalSubscription;
  String? _currentUserId;
  Function(ChatNotification)? onNewMessage;

  Future<void> initialize() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      _currentUserId = user.userId;
      _startGlobalSubscription();
    } catch (e) {
      safePrint('Failed to initialize global chat subscription: $e');
    }
  }

  void _startGlobalSubscription() {
    if (_currentUserId == null) return;

    // Use the global subscription that receives all messages for the user
    const String subscription = '''
      subscription OnNewChatMessageForUser(\$recipientId: ID!) {
        onNewChatMessageForUser(recipientId: \$recipientId) {
          recipientId
          message {
            chatId
            messageId
            senderId
            senderType
            messageContent
            sentAt
            senderName
            recipientId
          }
        }
      }
    ''';

    final request = GraphQLRequest<String>(
      document: subscription,
      variables: {'recipientId': _currentUserId!},
    );

    _globalSubscription = Amplify.API
        .subscribe(
      request,
      onEstablished: () => safePrint('Global chat subscription established'),
    )
        .listen(
      (event) {
        if (event.data != null) {
          try {
            final json = jsonDecode(event.data!);
            final response = json['onNewChatMessageForUser'];

            if (response != null && response['message'] != null) {
              final message = response['message'];

              // Only show notification if it's not from the current user
              if (message['senderId'] != _currentUserId &&
                  onNewMessage != null) {
                onNewMessage!(ChatNotification(
                  chatId: message['chatId'] ?? '',
                  mealPlanId: '', // You might need to fetch or pass this
                  senderName: message['senderName'] ?? 'Nutritionist',
                  message: message['messageContent'] ?? '',
                  timestamp: DateTime.tryParse(message['sentAt'] ?? '') ??
                      DateTime.now(),
                ));
              }
            }
          } catch (e) {
            safePrint('Error processing global message: $e');
          }
        }
      },
      onError: (error) {
        safePrint('Global subscription error: $error');
        // Retry after delay
        Future.delayed(const Duration(seconds: 5), () {
          _startGlobalSubscription();
        });
      },
    );
  }

  void dispose() {
    _globalSubscription?.cancel();
    _globalSubscription = null;
    _currentUserId = null;
  }
}
