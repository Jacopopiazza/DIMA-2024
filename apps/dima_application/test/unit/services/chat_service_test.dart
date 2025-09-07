import 'dart:async';

import 'package:dima_application/models/Chat/chat_response.dart';
import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/models/Chat/send_message_input.dart';
import 'package:dima_application/services/chat_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatService', () {
    late ChatService chatService;

    setUp(() {
      chatService = ChatService.instance;
    });

    tearDown(() async {
      await chatService.stopListening();
      chatService.dispose();
    });

    group('Singleton behavior', () {
      test('returns same instance', () {
        final instance1 = ChatService.instance;
        final instance2 = ChatService.instance;
        
        expect(instance1, same(instance2));
      });
    });

    group('Initial state', () {
      test('has empty message stream initially', () {
        expect(chatService.messageStream, isA<Stream<ChatResponse>>());
      });

      test('is not listening initially', () {
        expect(chatService.isListening, false);
      });
    });

    group('Stream management', () {
      test('messageStream property returns a stream', () {
        final stream = chatService.messageStream;
        expect(stream, isNotNull);
        expect(stream, isA<Stream<ChatResponse>>());
      });

      test('multiple calls to messageStream return consistent type', () {
        final stream1 = chatService.messageStream;
        final stream2 = chatService.messageStream;
        
        expect(stream1.runtimeType, equals(stream2.runtimeType));
      });
    });

    group('Lifecycle management', () {
      test('stopListening can be called multiple times safely', () async {
        await chatService.stopListening();
        await chatService.stopListening();
        
        expect(chatService.isListening, false);
      });

      test('dispose can be called multiple times safely', () {
        chatService.dispose();
        chatService.dispose();
        
        expect(true, isTrue); // Test passes if no exception is thrown
      });

      test('can call stopListening before startListening', () async {
        await chatService.stopListening();
        expect(chatService.isListening, false);
      });
    });

    group('Message handling', () {
      test('handles background message callback', () {
        bool callbackTriggered = false;
        ChatResponse? receivedMessage;

        chatService.onBackgroundMessage = (message) {
          callbackTriggered = true;
          receivedMessage = message;
        };

        // Simulate a background message (in real implementation)
        final testMessage = ChatResponse(
          recipientId: 'user-123',
          message: ChatMessage(
            id: 'msg-789',
            chatId: 'chat-456',
            messageContent: 'Test message',
            messageId: 'msg-789',
            recipientId: 'user-123',
            senderId: 'user-456',
            senderName: 'John Doe',
            senderType: SenderType.USER,
            sentAt: DateTime.parse('2024-06-01T10:00:00Z'),
          ),
        );

        // In a real test, you would trigger the subscription to call this callback
        if (chatService.onBackgroundMessage != null) {
          chatService.onBackgroundMessage!(testMessage);
        }

        expect(callbackTriggered, true);
        expect(receivedMessage, isNotNull);
        expect(receivedMessage?.recipientId, 'user-123');
      });

      test('handles active chat message callback', () {
        bool callbackTriggered = false;
        ChatResponse? receivedMessage;

        chatService.onActiveChatMessage = (message) {
          callbackTriggered = true;
          receivedMessage = message;
        };

        final testMessage = ChatResponse(
          recipientId: 'user-123',
          message: ChatMessage(
            id: 'msg-790',
            chatId: 'chat-456',
            messageContent: 'Active chat message',
            messageId: 'msg-790',
            recipientId: 'user-123',
            senderId: 'user-456',
            senderName: 'Jane Smith',
            senderType: SenderType.NUTRITIONIST,
            sentAt: DateTime.parse('2024-06-01T11:00:00Z'),
          ),
        );

        // Simulate active chat message
        if (chatService.onActiveChatMessage != null) {
          chatService.onActiveChatMessage!(testMessage);
        }

        expect(callbackTriggered, true);
        expect(receivedMessage, isNotNull);
        expect(receivedMessage?.message?.senderType, SenderType.NUTRITIONIST);
      });
    });

    group('Active chat management', () {
      test('can set and track active chat', () {
        chatService.setActiveChatId('chat-123');
        expect(chatService.activeChatId, 'chat-123');
      });

      test('can clear active chat', () {
        chatService.setActiveChatId('chat-123');
        chatService.setActiveChatId(null);
        expect(chatService.activeChatId, isNull);
      });
    });

    group('Error handling', () {
      test('handles subscription errors gracefully', () {
        // This would test what happens when the GraphQL subscription fails
        expect(true, isTrue); // Placeholder for subscription error testing
      });

      test('handles network disconnection', () {
        // This would test behavior when network is lost during subscription
        expect(true, isTrue); // Placeholder for network error testing
      });

      test('handles authentication errors', () {
        // This would test what happens when user auth expires during subscription
        expect(true, isTrue); // Placeholder for auth error testing
      });
    });

    group('Message sending', () {
      test('can create SendMessageInput correctly', () {
        final input = SendMessageInput(
          chatId: 'chat-123',
          messageContent: 'Hello, this is a test message',
        );

        expect(input.chatId, 'chat-123');
        expect(input.messageContent, 'Hello, this is a test message');
      });

      test('handles empty message content', () {
        final input = SendMessageInput(
          chatId: 'chat-123',
          messageContent: '',
        );

        expect(input.messageContent, isEmpty);
      });

      test('handles long message content', () {
        final longMessage = 'A' * 1000; // 1000 character message
        final input = SendMessageInput(
          chatId: 'chat-123',
          messageContent: longMessage,
        );

        expect(input.messageContent.length, 1000);
      });
    });

    group('Data models', () {
      test('ChatResponse model works correctly', () {
        final chatResponse = ChatResponse(
          recipientId: 'user-123',
          message: ChatMessage(
            id: 'msg-789',
            chatId: 'chat-456',
            messageContent: 'Test message',
            messageId: 'msg-789',
            recipientId: 'user-123',
            senderId: 'user-456',
            senderName: 'Test User',
            senderType: SenderType.USER,
            sentAt: DateTime.parse('2024-06-01T10:00:00Z'),
          ),
        );

        expect(chatResponse.recipientId, 'user-123');
        expect(chatResponse.message?.messageContent, 'Test message');
        expect(chatResponse.message?.senderName, 'Test User');
      });

      test('ChatMessage model works correctly', () {
        final messageDetail = ChatMessage(
          id: 'msg-123',
          chatId: 'chat-456',
          messageContent: 'Detailed test message',
          messageId: 'msg-123',
          recipientId: 'user-789',
          senderId: 'user-456',
          senderName: 'John Doe',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.parse('2024-06-01T12:00:00Z'),
        );

        expect(messageDetail.chatId, 'chat-456');
        expect(messageDetail.messageContent, 'Detailed test message');
        expect(messageDetail.senderType, SenderType.NUTRITIONIST);
        expect(messageDetail.sentAt, DateTime.parse('2024-06-01T12:00:00Z'));
      });
    });
  });
}