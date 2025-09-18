import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/models/Chat/chat_messages_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessagesResponse', () {
    test('fromJson parses list of messages', () {
      final json = {
        'count': 2,
        'hasMore': true,
        'oldestTimestamp': '2024-01-01T00:00:00Z',
        'messages': [
          {
            'id': 'm1',
            'chatId': 'c1',
            'messageContent': 'Hi',
            'messageId': 'm1',
            'recipientId': 'u1',
            'senderId': 'n1',
            'senderType': 'NUTRITIONIST',
            'sentAt': DateTime.now().toUtc().toIso8601String(),
          },
          {
            'id': 'm2',
            'chatId': 'c1',
            'messageContent': 'Hello',
            'messageId': 'm2',
            'recipientId': 'u1',
            'senderId': 'n1',
            'senderType': 'NUTRITIONIST',
            'sentAt': DateTime.now().toUtc().toIso8601String(),
          }
        ]
      };

      final res = ChatMessagesResponse.fromJson(json);
      expect(res.count, 2);
      expect(res.hasMore, isTrue);
      expect(res.oldestTimestamp, '2024-01-01T00:00:00Z');
      expect(res.messages.length, 2);
      expect(res.messages.first.messageId, 'm1');
    });

    test('fromJson handles GraphQL connection format with items', () {
      final json = {
        'hasMore': false,
        'messages': {
          'items': [
            {
              'id': 'm10',
              'chatId': 'c10',
              'messageContent': 'Conn',
              'messageId': 'm10',
              'recipientId': 'u10',
              'senderId': 'n10',
              'senderType': 'USER',
              'sentAt': DateTime.now().toUtc().toIso8601String(),
            },
          ]
        }
      };

      final res = ChatMessagesResponse.fromJson(json);
      expect(res.count, 1);
      expect(res.hasMore, isFalse);
      expect(res.messages.single.senderType, SenderType.USER);
    });

    test('toJson mirrors fields', () {
      final msg = ChatMessage(
        id: 'm3',
        chatId: 'c3',
        messageContent: 'Yo',
        messageId: 'm3',
        recipientId: 'u3',
        senderId: 'n3',
        senderType: SenderType.NUTRITIONIST,
        sentAt: DateTime.now(),
      );
      final res = ChatMessagesResponse(
        count: 1,
        hasMore: false,
        messages: [msg],
        oldestTimestamp: 'ts',
      );
      final json = res.toJson();
      expect(json['count'], 1);
      expect(json['hasMore'], false);
      expect((json['messages'] as List).length, 1);
      expect(json['oldestTimestamp'], 'ts');
    });

    test('equality compares by primitive fields and messages length', () {
      final now = DateTime.now();
      final a = ChatMessagesResponse(
        count: 2,
        hasMore: true,
        messages: [
          ChatMessage(
            id: 'm1',
            chatId: 'c1',
            messageContent: 'A',
            messageId: 'm1',
            recipientId: 'u1',
            senderId: 'n1',
            senderType: SenderType.USER,
            sentAt: now,
          ),
          ChatMessage(
            id: 'm2',
            chatId: 'c1',
            messageContent: 'B',
            messageId: 'm2',
            recipientId: 'u1',
            senderId: 'n1',
            senderType: SenderType.USER,
            sentAt: now,
          ),
        ],
        oldestTimestamp: 'ts',
      );
      final b = ChatMessagesResponse(
        count: 2,
        hasMore: true,
        messages: [
          ChatMessage(
            id: 'm1',
            chatId: 'c1',
            messageContent: 'X',
            messageId: 'm1',
            recipientId: 'u1',
            senderId: 'n1',
            senderType: SenderType.USER,
            sentAt: now,
          ),
          ChatMessage(
            id: 'm2',
            chatId: 'c1',
            messageContent: 'Y',
            messageId: 'm2',
            recipientId: 'u1',
            senderId: 'n1',
            senderType: SenderType.USER,
            sentAt: now,
          ),
        ],
        oldestTimestamp: 'ts',
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
