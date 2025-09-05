import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/models/Chat/send_message_input.dart';
import 'package:dima_application/models/Chat/chat_response.dart';
import 'package:dima_application/models/Chat/chat_messages_response.dart';

class ChatService {
  static ChatService? _instance;
  static ChatService get instance => _instance ??= ChatService._internal();

  ChatService._internal();

  StreamSubscription<GraphQLResponse<String>>? _subscription;
  StreamController<ChatResponse>? _messageController;
  String? _currentUserId;
  String? _activeChatId;

  // Callback for handling messages when user is not in the active chat
  Function(ChatResponse)? onBackgroundMessage;

  // Callback for handling messages when user is in the active chat
  Function(ChatResponse)? onActiveChatMessage;

  Stream<ChatResponse> get messageStream =>
      _messageController?.stream ?? const Stream.empty();

  bool get isListening => _subscription != null && _messageController != null;

  Future<void> startListening() async {
    try {
      safePrint('[ChatService] Starting chat subscription...');

      await _cleanupResources();

      final user = await Amplify.Auth.getCurrentUser();
      _currentUserId = user.userId;

      _messageController = StreamController<ChatResponse>.broadcast();

      safePrint('[ChatService] User ID: $_currentUserId');

      const String subscriptionDocument = '''
        subscription OnNewChatMessageForUser(\$recipientId: ID!) {
          onNewChatMessageForUser(recipientId: \$recipientId) {
            recipientId
            message {
              chatId
              messageContent
              messageId
              recipientId
              senderId
              senderName
              senderType
              sentAt
            }
          }
        }
      ''';

      final subscriptionRequest = GraphQLRequest<String>(
        document: subscriptionDocument,
        variables: {
          'recipientId': _currentUserId,
        },
      );

      safePrint('[ChatService] Subscription request created');

      final operation = Amplify.API.subscribe(subscriptionRequest);

      _subscription = operation.listen(
        (GraphQLResponse<String> response) {
          safePrint('[ChatService] *** RAW SUBSCRIPTION RESPONSE RECEIVED ***');
          safePrint('[ChatService] Response data: ${response.data}');
          safePrint('[ChatService] Response errors: ${response.errors}');
          _handleSubscriptionData(response);
        },
        onError: (error) {
          safePrint('[ChatService] *** SUBSCRIPTION ERROR *** $error');
          _messageController?.addError(error);
        },
        onDone: () {
          safePrint('[ChatService] *** SUBSCRIPTION COMPLETED ***');
        },
      );

      safePrint('[ChatService] *** CHAT SUBSCRIPTION STARTED SUCCESSFULLY ***');
      safePrint('[ChatService] isListening: ${isListening}');
      safePrint('[ChatService] Current user ID: $_currentUserId');
      safePrint('[ChatService] Active chat ID: $_activeChatId');
    } catch (e) {
      safePrint('[ChatService] Error starting subscription: $e');
      rethrow;
    }
  }

  Future<void> stopListening() async {
    await _cleanupResources();
    _currentUserId = null;
    _activeChatId = null;
    onBackgroundMessage = null;
    onActiveChatMessage = null;
    safePrint('[ChatService] Chat subscription stopped');
  }

  Future<void> _cleanupResources() async {
    safePrint('[ChatService] Cleaning up existing resources...');

    await _subscription?.cancel();
    _subscription = null;

    if (_messageController != null && !_messageController!.isClosed) {
      await _messageController!.close();
    }
    _messageController = null;

    safePrint('[ChatService] Cleanup completed');
  }

  void _handleSubscriptionData(GraphQLResponse<String> response) {
    try {
      if (_messageController == null || _messageController!.isClosed) {
        safePrint(
            '[ChatService] No active controller, ignoring subscription data');
        return;
      }

      final data = response.data;
      if (data != null && data.isNotEmpty) {
        final chatResponse = _parseChatResponse(data);

        safePrint(
            '[ChatService] Received chat message for chat: ${chatResponse.message?.chatId}');

        // Route message based on whether user is in the active chat
        if (_activeChatId != null &&
            chatResponse.message?.chatId == _activeChatId) {
          // User is in the chat, deliver directly to chat page
          onActiveChatMessage?.call(chatResponse);
          safePrint('[ChatService] Message delivered to active chat');
        } else {
          // User is not in this chat, show as background notification
          onBackgroundMessage?.call(chatResponse);
          safePrint(
              '[ChatService] Message delivered as background notification');
        }

        _messageController!.add(chatResponse);
      }

      final errors = response.errors;
      if (errors?.isNotEmpty == true) {
        safePrint('[ChatService] Subscription response errors: $errors');
        _messageController!.addError(errors!);
      }
    } catch (e) {
      safePrint('[ChatService] Error handling subscription data: $e');
      _messageController?.addError(e);
    }
  }

  ChatResponse _parseChatResponse(String jsonData) {
    try {
      safePrint('[ChatService] Raw JSON data received: $jsonData');

      final Map<String, dynamic> jsonMap = json.decode(jsonData);
      safePrint('[ChatService] Parsed JSON map: $jsonMap');

      final Map<String, dynamic>? responseData =
          jsonMap['onNewChatMessageForUser'] as Map<String, dynamic>?;

      if (responseData == null) {
        safePrint('[ChatService] No onNewChatMessageForUser field found');
        throw Exception('Invalid chat response format');
      }

      return ChatResponse.fromJson(responseData);
    } catch (e) {
      safePrint('[ChatService] Error parsing chat response: $e');
      throw Exception('Failed to parse chat response: $e');
    }
  }

  void setActiveChatId(String? chatId) {
    _activeChatId = chatId;
    safePrint('[ChatService] Active chat set to: $chatId');
  }

  Future<ChatMessagesResponse> getChatMessages({
    required String chatId,
    String? beforeTimestamp,
    int? limit,
  }) async {
    try {
      safePrint('[ChatService] Fetching messages for chat: $chatId');

      const String queryDocument = '''
        query GetChatMessages(\$chatId: ID!, \$beforeTimestamp: String, \$limit: Int) {
          getChatMessages(chatId: \$chatId, beforeTimestamp: \$beforeTimestamp, limit: \$limit) {
            oldestTimestamp
            messages {
              chatId
              messageContent
              messageId
              recipientId
              senderId
              senderName
              senderType
              sentAt
            }
            count
            hasMore
          }
        }
      ''';

      print(
          "[ChatService] Requesting chat messages with variables: chatId=$chatId, beforeTimestamp=$beforeTimestamp, limit=$limit");

      final operation = Amplify.API.query(
        request: GraphQLRequest<String>(
          document: queryDocument,
          variables: {
            'chatId': chatId,
            if (beforeTimestamp != null) 'beforeTimestamp': beforeTimestamp,
            if (limit != null) 'limit': limit,
          },
        ),
      );

      final response = await operation.response;

      if (response.hasErrors || response.data == null) {
        throw Exception('Failed to fetch chat messages: ${response.errors}');
      }

      // Parse using generated model
      final jsonData = json.decode(response.data!);
      final chatMessagesData = jsonData['getChatMessages'];
      print("[ChatService] Raw chat messages data: $chatMessagesData");
      final chatMessagesResponse =
          ChatMessagesResponse.fromJson(chatMessagesData);

      safePrint(
          '[ChatService] Successfully fetched ${chatMessagesResponse.messages.length} messages');
      return chatMessagesResponse;
    } catch (e) {
      safePrint('[ChatService] Error fetching chat messages: $e');
      rethrow;
    }
  }

  Future<ChatResponse> sendMessage({
    required String chatId,
    required String messageContent,
  }) async {
    try {
      safePrint('[ChatService] Sending message to chat: $chatId');

      const String mutationDocument = '''
        mutation SendChatMessage(\$input: SendMessageInput!) {
          sendChatMessage(input: \$input) {
            message {
              chatId
              messageContent
              messageId
              sentAt
              senderType
              senderName
              senderId
              recipientId
            }
            recipientId
          }
        }
      ''';

      final input = SendMessageInput(
        chatId: chatId,
        messageContent: messageContent,
      );

      print("[ChatService] Mutation input: ${input.toJson()}");

      final operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: mutationDocument,
          variables: {
            'input': input.toJson(),
          },
        ),
      );

      final response = await operation.response;

      if (response.hasErrors || response.data == null) {
        throw Exception('Failed to send message: ${response.errors}');
      }

      // Parse using generated model
      final jsonData = json.decode(response.data!);
      final chatResponseData = jsonData['sendChatMessage'];
      final chatResponse = ChatResponse.fromJson(chatResponseData);

      safePrint('[ChatService] Message sent successfully');
      return chatResponse;
    } catch (e) {
      safePrint('[ChatService] Error sending message: $e');
      rethrow;
    }
  }

  void dispose() {
    stopListening();
    safePrint('[ChatService] Service disposed');
  }

  String? get activeChatId => _activeChatId;
}
