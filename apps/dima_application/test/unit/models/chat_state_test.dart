import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/models/Chat/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatState', () {
    test('default values and computed properties', () {
      final state = ChatState(chatId: 'c1');
      expect(state.chatId, 'c1');
      expect(state.messages, isEmpty);
      expect(state.hasMoreMessages, isTrue);
      expect(state.oldestTimestamp, isNull);
      expect(state.isConnected, isTrue);
      expect(state.isEmpty, isTrue);
      expect(state.messageCount, 0);
    });

    test('copyWith updates fields immutably', () {
      final now = DateTime.now();
      final initial = ChatState(chatId: 'c1');
      final msg = ChatMessage(
        id: 'm1',
        chatId: 'c1',
        messageContent: 'Hello',
        messageId: 'm1',
        recipientId: 'u1',
        senderId: 'n1',
        senderType: SenderType.USER,
        sentAt: now,
      );

      final updated = initial.copyWith(
        messages: [msg],
        hasMoreMessages: false,
        oldestTimestamp: 'ts',
        isConnected: false,
      );

      expect(updated.chatId, 'c1');
      expect(updated.messages.single.messageId, 'm1');
      expect(updated.hasMoreMessages, isFalse);
      expect(updated.oldestTimestamp, 'ts');
      expect(updated.isConnected, isFalse);

      // original remains unchanged
      expect(initial.messages, isEmpty);
      expect(initial.hasMoreMessages, isTrue);
      expect(initial.isConnected, isTrue);
    });

    test('equality requires same list instance for messages', () {
      final now = DateTime.now();
      final sharedMessages = [
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
      ];

      final a = ChatState(
        chatId: 'c1',
        messages: sharedMessages,
        hasMoreMessages: false,
        oldestTimestamp: 'ts',
        isConnected: false,
      );

      final b = ChatState(
        chatId: 'c1',
        messages: sharedMessages, // same list reference
        hasMoreMessages: false,
        oldestTimestamp: 'ts',
        isConnected: false,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.toString(), contains('chatId: c1'));
    });
  });

  group('ChatNotificationState', () {
    test('addUnreadMessage and counts per chat', () {
      final now = DateTime.now();
      final msg1 = ChatMessage(
        id: 'm1',
        chatId: 'c1',
        messageContent: 'A',
        messageId: 'm1',
        recipientId: 'u1',
        senderId: 'n1',
        senderType: SenderType.USER,
        sentAt: now,
      );
      final msg2 = ChatMessage(
        id: 'm2',
        chatId: 'c1',
        messageContent: 'B',
        messageId: 'm2',
        recipientId: 'u1',
        senderId: 'n1',
        senderType: SenderType.USER,
        sentAt: now,
      );
      final msg3 = ChatMessage(
        id: 'm3',
        chatId: 'c2',
        messageContent: 'C',
        messageId: 'm3',
        recipientId: 'u1',
        senderId: 'n1',
        senderType: SenderType.USER,
        sentAt: now,
      );

      var state = const ChatNotificationState();
      state = state.addUnreadMessage(msg1);
      state = state.addUnreadMessage(msg2);
      state = state.addUnreadMessage(msg3);

      expect(state.unreadMessages.length, 3);
      expect(state.getUnreadCountForChat('c1'), 2);
      expect(state.getUnreadCountForChat('c2'), 1);
      expect(state.getTotalUnreadCount(), 3);
    });

    test('markChatAsRead clears specific chat counts and messages', () {
      final now = DateTime.now();
      final msg1 = ChatMessage(
        id: 'm1',
        chatId: 'c1',
        messageContent: 'A',
        messageId: 'm1',
        recipientId: 'u1',
        senderId: 'n1',
        senderType: SenderType.USER,
        sentAt: now,
      );
      final msg2 = ChatMessage(
        id: 'm2',
        chatId: 'c2',
        messageContent: 'B',
        messageId: 'm2',
        recipientId: 'u1',
        senderId: 'n1',
        senderType: SenderType.USER,
        sentAt: now,
      );

      var state = const ChatNotificationState();
      state = state.addUnreadMessage(msg1).addUnreadMessage(msg2);

      state = state.markChatAsRead('c1');
      expect(state.getUnreadCountForChat('c1'), 0);
      expect(state.getUnreadCountForChat('c2'), 1);
      expect(state.unreadMessages.any((m) => m.chatId == 'c1'), isFalse);
    });
  });
}
