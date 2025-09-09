import 'package:dima_application/models/Chat/send_message_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SendMessageInput', () {
    test('toJson and fromJson roundtrip', () {
      const input = SendMessageInput(chatId: 'c1', messageContent: 'Hello');
      final json = input.toJson();
      expect(json['chatId'], 'c1');
      expect(json['messageContent'], 'Hello');

      final parsed = SendMessageInput.fromJson(json);
      expect(parsed, equals(input));
      expect(parsed.hashCode, equals(input.hashCode));
      expect(parsed.toString(), contains('chatId: c1'));
    });

    test('equality compares both fields', () {
      const a = SendMessageInput(chatId: 'c', messageContent: 'A');
      const b = SendMessageInput(chatId: 'c', messageContent: 'A');
      const c = SendMessageInput(chatId: 'c', messageContent: 'B');

      expect(a, equals(b));
      expect(a == c, isFalse);
    });
  });
}
