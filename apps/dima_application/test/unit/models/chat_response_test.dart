import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/models/Chat/chat_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatResponse', () {
    test('fromJson parses with nested serializedData', () {
      final json = {
        'recipientId': 'user-1',
        'message': {
          'serializedData': {
            'id': 'm1',
            'chatId': 'c1',
            'messageContent': 'Hi',
            'messageId': 'm1',
            'recipientId': 'user-1',
            'senderId': 'nutri-1',
            'senderType': 'NUTRITIONIST',
            'sentAt': DateTime.now().toUtc().toIso8601String(),
          }
        }
      };

      final resp = ChatResponse.fromJson(json);
      expect(resp.recipientId, 'user-1');
      expect(resp.message, isNotNull);
      expect(resp.message!.messageId, 'm1');
    });

    test('fromJson handles plain message map', () {
      final json = {
        'recipientId': 'user-2',
        'message': {
          'id': 'm2',
          'chatId': 'c2',
          'messageContent': 'Hello',
          'messageId': 'm2',
          'recipientId': 'user-2',
          'senderId': 'nutri-2',
          'senderType': 'NUTRITIONIST',
          'sentAt': DateTime.now().toUtc().toIso8601String(),
        },
      };

      final resp = ChatResponse.fromJson(json);
      expect(resp.recipientId, 'user-2');
      expect(resp.message!.chatId, 'c2');
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
      final resp = ChatResponse(message: msg, recipientId: 'u3');
      final json = resp.toJson();
      expect(json['recipientId'], 'u3');
      expect(json['message'], isA<Map<String, dynamic>>());
      expect((json['message'] as Map<String, dynamic>)['messageId'], 'm3');
    });

    test('equality compares by messageId and recipientId', () {
      final now = DateTime.now();
      final a = ChatResponse(
        message: ChatMessage(
          id: 'm4',
          chatId: 'c4',
          messageContent: 'A',
          messageId: 'm4',
          recipientId: 'u4',
          senderId: 'n4',
          senderType: SenderType.USER,
          sentAt: now,
        ),
        recipientId: 'u4',
      );
      final b = ChatResponse(
        message: ChatMessage(
          id: 'm4',
          chatId: 'c4',
          messageContent: 'B',
          messageId: 'm4',
          recipientId: 'u4',
          senderId: 'n4',
          senderType: SenderType.USER,
          sentAt: now,
        ),
        recipientId: 'u4',
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.toString(), contains('recipientId: u4'));
    });
  });
}
