import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessage', () {
    group('Constructor and initialization', () {
      test('creates ChatMessage with all required parameters', () {
        final sentAt = DateTime.now();
        final chatMessage = ChatMessage(
          id: 'msg-123',
          chatId: 'chat-456',
          messageContent: 'Hello, how can I help you?',
          messageId: 'msg-123',
          recipientId: 'user-789',
          senderId: 'nutritionist-101',
          senderName: 'Dr. Smith',
          senderType: SenderType.NUTRITIONIST,
          sentAt: sentAt,
        );

        expect(chatMessage.id, 'msg-123');
        expect(chatMessage.chatId, 'chat-456');
        expect(chatMessage.messageContent, 'Hello, how can I help you?');
        expect(chatMessage.messageId, 'msg-123');
        expect(chatMessage.recipientId, 'user-789');
        expect(chatMessage.senderId, 'nutritionist-101');
        expect(chatMessage.senderName, 'Dr. Smith');
        expect(chatMessage.senderType, SenderType.NUTRITIONIST);
        expect(chatMessage.sentAt, sentAt);
      });

      test('creates ChatMessage with optional senderName as null', () {
        final chatMessage = ChatMessage(
          id: 'msg-124',
          chatId: 'chat-457',
          messageContent: 'Thank you for the advice!',
          messageId: 'msg-124',
          recipientId: 'nutritionist-101',
          senderId: 'user-789',
          senderName: null,
          senderType: SenderType.USER,
          sentAt: DateTime.now(),
        );

        expect(chatMessage.senderName, isNull);
        expect(chatMessage.senderType, SenderType.USER);
      });

      test('creates ChatMessage without senderName parameter', () {
        final chatMessage = ChatMessage(
          id: 'msg-125',
          chatId: 'chat-458',
          messageContent: 'Great progress!',
          messageId: 'msg-125',
          recipientId: 'user-789',
          senderId: 'nutritionist-102',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        expect(chatMessage.senderName, isNull);
        expect(chatMessage.senderType, SenderType.NUTRITIONIST);
      });
    });

    group('SenderType enum', () {
      test('has correct enum values', () {
        expect(SenderType.values, hasLength(2));
        expect(SenderType.values, contains(SenderType.NUTRITIONIST));
        expect(SenderType.values, contains(SenderType.USER));
      });

      test('enum name property works correctly', () {
        expect(SenderType.NUTRITIONIST.name, 'NUTRITIONIST');
        expect(SenderType.USER.name, 'USER');
      });
    });

    group('fromJson factory method', () {
      test('creates ChatMessage from valid JSON with all fields', () {
        final json = {
          'id': 'msg-200',
          'chatId': 'chat-300',
          'messageContent': 'Your meal plan is ready!',
          'messageId': 'msg-200',
          'recipientId': 'user-400',
          'senderId': 'nutritionist-500',
          'senderName': 'Dr. Johnson',
          'senderType': 'NUTRITIONIST',
          'sentAt': '2023-12-25T10:30:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);

        expect(chatMessage.id, 'msg-200');
        expect(chatMessage.chatId, 'chat-300');
        expect(chatMessage.messageContent, 'Your meal plan is ready!');
        expect(chatMessage.messageId, 'msg-200');
        expect(chatMessage.recipientId, 'user-400');
        expect(chatMessage.senderId, 'nutritionist-500');
        expect(chatMessage.senderName, 'Dr. Johnson');
        expect(chatMessage.senderType, SenderType.NUTRITIONIST);
        expect(chatMessage.sentAt.year, 2023);
        expect(chatMessage.sentAt.month, 12);
        expect(chatMessage.sentAt.day, 25);
      });

      test('creates ChatMessage from JSON with messageId fallback for id', () {
        final json = {
          'messageId': 'msg-201',
          'chatId': 'chat-301',
          'messageContent': 'Thanks for the update',
          'recipientId': 'nutritionist-501',
          'senderId': 'user-401',
          'senderType': 'USER',
          'sentAt': '2023-12-25T14:15:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);

        expect(chatMessage.id, 'msg-201');
        expect(chatMessage.messageId, 'msg-201');
        expect(chatMessage.senderType, SenderType.USER);
      });

      test(
          'handles missing id with empty string fallback (empty messageId allowed)',
          () {
        final json = {
          'chatId': 'chat-302',
          'messageContent': 'No ID message',
          'recipientId': 'user-402',
          'senderId': 'nutritionist-502',
          'senderType': 'NUTRITIONIST',
          'sentAt': '2023-12-25T16:00:00.000Z',
          // Provide empty messageId since model expects a String cast
          'messageId': '',
        };

        final chatMessage = ChatMessage.fromJson(json);

        expect(chatMessage.id, '');
        expect(chatMessage.messageId, '');
        expect(chatMessage.messageContent, 'No ID message');
      });

      test('handles null senderName correctly', () {
        final json = {
          'id': 'msg-202',
          'chatId': 'chat-303',
          'messageContent': 'Anonymous message',
          'messageId': 'msg-202',
          'recipientId': 'user-403',
          'senderId': 'nutritionist-503',
          'senderName': null,
          'senderType': 'NUTRITIONIST',
          'sentAt': '2023-12-25T17:30:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);

        expect(chatMessage.senderName, isNull);
        expect(chatMessage.senderType, SenderType.NUTRITIONIST);
      });

      test('handles missing senderName field', () {
        final json = {
          'id': 'msg-203',
          'chatId': 'chat-304',
          'messageContent': 'No sender name',
          'messageId': 'msg-203',
          'recipientId': 'user-404',
          'senderId': 'nutritionist-504',
          'senderType': 'USER',
          'sentAt': '2023-12-25T18:45:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);

        expect(chatMessage.senderName, isNull);
        expect(chatMessage.senderType, SenderType.USER);
      });
    });

    group('SenderType parsing', () {
      test('parses NUTRITIONIST string correctly', () {
        final json = {
          'id': 'msg-300',
          'chatId': 'chat-400',
          'messageContent': 'Test message',
          'messageId': 'msg-300',
          'recipientId': 'user-500',
          'senderId': 'nutritionist-600',
          'senderType': 'NUTRITIONIST',
          'sentAt': '2023-12-25T10:00:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);
        expect(chatMessage.senderType, SenderType.NUTRITIONIST);
      });

      test('parses USER string correctly', () {
        final json = {
          'id': 'msg-301',
          'chatId': 'chat-401',
          'messageContent': 'Test message',
          'messageId': 'msg-301',
          'recipientId': 'nutritionist-601',
          'senderId': 'user-501',
          'senderType': 'USER',
          'sentAt': '2023-12-25T11:00:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);
        expect(chatMessage.senderType, SenderType.USER);
      });

      test('parses case insensitive sender types', () {
        final testCases = [
          'nutritionist',
          'Nutritionist',
          'NUTRITIONIST',
          'user',
          'User',
          'USER'
        ];

        for (int i = 0; i < testCases.length; i++) {
          final json = {
            'id': 'msg-30$i',
            'chatId': 'chat-40$i',
            'messageContent': 'Test message $i',
            'messageId': 'msg-30$i',
            'recipientId': 'recipient-$i',
            'senderId': 'sender-$i',
            'senderType': testCases[i],
            'sentAt': '2023-12-25T10:00:00.000Z',
          };

          final chatMessage = ChatMessage.fromJson(json);

          if (testCases[i].toUpperCase() == 'NUTRITIONIST') {
            expect(chatMessage.senderType, SenderType.NUTRITIONIST);
          } else {
            expect(chatMessage.senderType, SenderType.USER);
          }
        }
      });

      test('defaults to USER for unknown sender type strings', () {
        final json = {
          'id': 'msg-310',
          'chatId': 'chat-410',
          'messageContent': 'Unknown sender type',
          'messageId': 'msg-310',
          'recipientId': 'user-510',
          'senderId': 'unknown-610',
          'senderType': 'ADMIN',
          'sentAt': '2023-12-25T12:00:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);
        expect(chatMessage.senderType, SenderType.USER);
      });

      test('defaults to USER for non-string sender type values', () {
        final json = {
          'id': 'msg-311',
          'chatId': 'chat-411',
          'messageContent': 'Non-string sender type',
          'messageId': 'msg-311',
          'recipientId': 'user-511',
          'senderId': 'sender-611',
          'senderType': 123,
          'sentAt': '2023-12-25T13:00:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);
        expect(chatMessage.senderType, SenderType.USER);
      });

      test('defaults to USER for null sender type', () {
        final json = {
          'id': 'msg-312',
          'chatId': 'chat-412',
          'messageContent': 'Null sender type',
          'messageId': 'msg-312',
          'recipientId': 'user-512',
          'senderId': 'sender-612',
          'senderType': null,
          'sentAt': '2023-12-25T14:00:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);
        expect(chatMessage.senderType, SenderType.USER);
      });
    });

    group('DateTime parsing', () {
      test('parses valid ISO date strings correctly', () {
        final json = {
          'id': 'msg-400',
          'chatId': 'chat-500',
          'messageContent': 'DateTime test',
          'messageId': 'msg-400',
          'recipientId': 'user-600',
          'senderId': 'nutritionist-700',
          'senderType': 'NUTRITIONIST',
          'sentAt': '2023-06-15T14:30:45.123Z',
        };

        final chatMessage = ChatMessage.fromJson(json);

        expect(chatMessage.sentAt.year, 2023);
        expect(chatMessage.sentAt.month, 6);
        expect(chatMessage.sentAt.day, 15);
        // Preserve hour in UTC; local hour may differ by timezone
        expect(chatMessage.sentAt.toUtc().hour, 14);
      });

      test('handles invalid date strings by defaulting to now', () {
        final json = {
          'id': 'msg-401',
          'chatId': 'chat-501',
          'messageContent': 'Invalid date test',
          'messageId': 'msg-401',
          'recipientId': 'user-601',
          'senderId': 'nutritionist-701',
          'senderType': 'NUTRITIONIST',
          'sentAt': 'not-a-date',
        };

        final beforeParsing = DateTime.now();
        final chatMessage = ChatMessage.fromJson(json);
        final afterParsing = DateTime.now();

        expect(
            chatMessage.sentAt
                .isAfter(beforeParsing.subtract(Duration(seconds: 1))),
            true);
        expect(
            chatMessage.sentAt.isBefore(afterParsing.add(Duration(seconds: 1))),
            true);
      });

      test('handles non-string date values by defaulting to now', () {
        final json = {
          'id': 'msg-402',
          'chatId': 'chat-502',
          'messageContent': 'Non-string date test',
          'messageId': 'msg-402',
          'recipientId': 'user-602',
          'senderId': 'nutritionist-702',
          'senderType': 'USER',
          'sentAt': 12345,
        };

        final beforeParsing = DateTime.now();
        final chatMessage = ChatMessage.fromJson(json);
        final afterParsing = DateTime.now();

        expect(
            chatMessage.sentAt
                .isAfter(beforeParsing.subtract(Duration(seconds: 1))),
            true);
        expect(
            chatMessage.sentAt.isBefore(afterParsing.add(Duration(seconds: 1))),
            true);
      });

      test('converts parsed date to local time', () {
        final json = {
          'id': 'msg-403',
          'chatId': 'chat-503',
          'messageContent': 'UTC to local test',
          'messageId': 'msg-403',
          'recipientId': 'user-603',
          'senderId': 'nutritionist-703',
          'senderType': 'NUTRITIONIST',
          'sentAt': '2023-12-25T12:00:00.000Z',
        };

        final chatMessage = ChatMessage.fromJson(json);

        // The parsed date should be in local timezone
        expect(chatMessage.sentAt.isUtc, false);
        expect(chatMessage.sentAt.year, 2023);
        expect(chatMessage.sentAt.month, 12);
        expect(chatMessage.sentAt.day, 25);
      });
    });

    group('toJson method', () {
      test('converts ChatMessage to JSON correctly', () {
        final sentAt = DateTime(2023, 12, 25, 15, 30, 45);
        final chatMessage = ChatMessage(
          id: 'msg-500',
          chatId: 'chat-600',
          messageContent: 'JSON conversion test',
          messageId: 'msg-500',
          recipientId: 'user-700',
          senderId: 'nutritionist-800',
          senderName: 'Dr. Brown',
          senderType: SenderType.NUTRITIONIST,
          sentAt: sentAt,
        );

        final json = chatMessage.toJson();

        expect(json['id'], 'msg-500');
        expect(json['chatId'], 'chat-600');
        expect(json['messageContent'], 'JSON conversion test');
        expect(json['messageId'], 'msg-500');
        expect(json['recipientId'], 'user-700');
        expect(json['senderId'], 'nutritionist-800');
        expect(json['senderName'], 'Dr. Brown');
        expect(json['senderType'], 'NUTRITIONIST');
        expect(json['sentAt'], sentAt.toUtc().toIso8601String());
      });

      test('converts ChatMessage with null senderName to JSON', () {
        final chatMessage = ChatMessage(
          id: 'msg-501',
          chatId: 'chat-601',
          messageContent: 'Null senderName JSON test',
          messageId: 'msg-501',
          recipientId: 'user-701',
          senderId: 'nutritionist-801',
          senderName: null,
          senderType: SenderType.USER,
          sentAt: DateTime.now(),
        );

        final json = chatMessage.toJson();

        expect(json['senderName'], isNull);
        expect(json['senderType'], 'USER');
      });

      test('converts sentAt to UTC ISO string', () {
        final localTime = DateTime(2023, 6, 15, 14, 30, 0);
        final chatMessage = ChatMessage(
          id: 'msg-502',
          chatId: 'chat-602',
          messageContent: 'UTC conversion test',
          messageId: 'msg-502',
          recipientId: 'user-702',
          senderId: 'nutritionist-802',
          senderType: SenderType.NUTRITIONIST,
          sentAt: localTime,
        );

        final json = chatMessage.toJson();
        final expectedUtcString = localTime.toUtc().toIso8601String();

        expect(json['sentAt'], expectedUtcString);
        expect(json['sentAt'], contains('T'));
        expect(json['sentAt'], endsWith('Z'));
      });
    });

    group('toString method', () {
      test('includes key identifying information', () {
        final chatMessage = ChatMessage(
          id: 'msg-600',
          chatId: 'chat-700',
          messageContent: 'toString test message',
          messageId: 'msg-600',
          recipientId: 'user-800',
          senderId: 'nutritionist-900',
          senderName: 'Dr. Wilson',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime(2023, 8, 20, 10, 15),
        );

        final stringRepresentation = chatMessage.toString();

        expect(stringRepresentation, contains('ChatMessage'));
        expect(stringRepresentation, contains('messageId: msg-600'));
        expect(stringRepresentation, contains('chatId: chat-700'));
        expect(stringRepresentation, contains('senderId: nutritionist-900'));
        expect(stringRepresentation,
            contains('senderType: SenderType.NUTRITIONIST'));
        expect(stringRepresentation, contains('sentAt:'));
      });

      test('shows USER sender type correctly', () {
        final chatMessage = ChatMessage(
          id: 'msg-601',
          chatId: 'chat-701',
          messageContent: 'User toString test',
          messageId: 'msg-601',
          recipientId: 'nutritionist-901',
          senderId: 'user-801',
          senderType: SenderType.USER,
          sentAt: DateTime.now(),
        );

        final stringRepresentation = chatMessage.toString();
        expect(stringRepresentation, contains('senderType: SenderType.USER'));
      });
    });

    group('Equality and hashCode', () {
      test('two ChatMessages with same messageId are equal', () {
        final message1 = ChatMessage(
          id: 'msg-700',
          chatId: 'chat-800',
          messageContent: 'Test message 1',
          messageId: 'same-message-id',
          recipientId: 'user-900',
          senderId: 'nutritionist-1000',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime(2023, 1, 1),
        );

        final message2 = ChatMessage(
          id: 'msg-701',
          chatId: 'chat-801',
          messageContent: 'Test message 2',
          messageId: 'same-message-id',
          recipientId: 'user-901',
          senderId: 'nutritionist-1001',
          senderType: SenderType.USER,
          sentAt: DateTime(2023, 12, 31),
        );

        expect(message1 == message2, true);
        expect(message1.hashCode, message2.hashCode);
      });

      test('two ChatMessages with different messageIds are not equal', () {
        final message1 = ChatMessage(
          id: 'msg-702',
          chatId: 'chat-802',
          messageContent: 'Same content',
          messageId: 'different-id-1',
          recipientId: 'user-902',
          senderId: 'nutritionist-1002',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        final message2 = ChatMessage(
          id: 'msg-703',
          chatId: 'chat-802',
          messageContent: 'Same content',
          messageId: 'different-id-2',
          recipientId: 'user-902',
          senderId: 'nutritionist-1002',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        expect(message1 == message2, false);
        expect(message1.hashCode == message2.hashCode, false);
      });

      test('ChatMessage is equal to itself', () {
        final message = ChatMessage(
          id: 'msg-704',
          chatId: 'chat-803',
          messageContent: 'Self equality test',
          messageId: 'self-test-id',
          recipientId: 'user-903',
          senderId: 'nutritionist-1003',
          senderType: SenderType.USER,
          sentAt: DateTime.now(),
        );

        expect(message == message, true);
        expect(identical(message, message), true);
      });

      test('ChatMessage is not equal to different object type', () {
        final message = ChatMessage(
          id: 'msg-705',
          chatId: 'chat-804',
          messageContent: 'Type test',
          messageId: 'type-test-id',
          recipientId: 'user-904',
          senderId: 'nutritionist-1004',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        expect(message == 'not a chat message', false);
        expect(message == 123, false);
        expect(message == null, false);
      });
    });

    group('Round-trip JSON conversion', () {
      test('converts to JSON and back correctly', () {
        final original = ChatMessage(
          id: 'msg-800',
          chatId: 'chat-900',
          messageContent: 'Round trip test message',
          messageId: 'msg-800',
          recipientId: 'user-1000',
          senderId: 'nutritionist-1100',
          senderName: 'Dr. Anderson',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime(2023, 9, 10, 16, 45, 30),
        );

        final json = original.toJson();
        final roundTrip = ChatMessage.fromJson(json);

        expect(roundTrip.id, original.id);
        expect(roundTrip.chatId, original.chatId);
        expect(roundTrip.messageContent, original.messageContent);
        expect(roundTrip.messageId, original.messageId);
        expect(roundTrip.recipientId, original.recipientId);
        expect(roundTrip.senderId, original.senderId);
        expect(roundTrip.senderName, original.senderName);
        expect(roundTrip.senderType, original.senderType);
        // Note: Time comparison might have slight differences due to precision
        expect(roundTrip.sentAt.year, original.sentAt.year);
        expect(roundTrip.sentAt.month, original.sentAt.month);
        expect(roundTrip.sentAt.day, original.sentAt.day);
        expect(roundTrip.sentAt.hour, original.sentAt.hour);
        expect(roundTrip.sentAt.minute, original.sentAt.minute);
      });

      test('maintains equality after round-trip conversion', () {
        final original = ChatMessage(
          id: 'msg-801',
          chatId: 'chat-901',
          messageContent: 'Equality round trip test',
          messageId: 'msg-801',
          recipientId: 'user-1001',
          senderId: 'nutritionist-1101',
          senderType: SenderType.USER,
          sentAt: DateTime.now(),
        );

        final json = original.toJson();
        final roundTrip = ChatMessage.fromJson(json);

        expect(roundTrip == original, true);
        expect(roundTrip.hashCode, original.hashCode);
      });

      test('handles null senderName in round-trip conversion', () {
        final original = ChatMessage(
          id: 'msg-802',
          chatId: 'chat-902',
          messageContent: 'Null senderName round trip',
          messageId: 'msg-802',
          recipientId: 'user-1002',
          senderId: 'nutritionist-1102',
          senderName: null,
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        final json = original.toJson();
        final roundTrip = ChatMessage.fromJson(json);

        expect(roundTrip.senderName, isNull);
        expect(roundTrip == original, true);
      });
    });

    group('Realistic messaging scenarios', () {
      test('represents nutritionist initial consultation message', () {
        final consultationMessage = ChatMessage(
          id: 'msg-consultation-001',
          chatId: 'chat-new-client-123',
          messageContent:
              'Hello! I\'m Dr. Smith, your assigned nutritionist. I\'ve reviewed your profile and I\'m excited to help you achieve your health goals. Let\'s start by discussing your current eating habits and any specific concerns you have.',
          messageId: 'msg-consultation-001',
          recipientId: 'user-new-client-456',
          senderId: 'nutritionist-dr-smith-789',
          senderName: 'Dr. Sarah Smith',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime(2023, 12, 1, 9, 0),
        );

        expect(consultationMessage.senderType, SenderType.NUTRITIONIST);
        expect(consultationMessage.messageContent, contains('nutritionist'));
        expect(consultationMessage.messageContent, contains('health goals'));
        expect(consultationMessage.senderName, 'Dr. Sarah Smith');
      });

      test('represents user question about meal plan', () {
        final userQuestion = ChatMessage(
          id: 'msg-user-question-002',
          chatId: 'chat-ongoing-456',
          messageContent:
              'Hi Dr. Smith! I have a question about tomorrow\'s lunch. The recipe calls for quinoa, but I don\'t have any. Can I substitute it with brown rice? Will that affect the nutritional balance?',
          messageId: 'msg-user-question-002',
          recipientId: 'nutritionist-dr-smith-789',
          senderId: 'user-active-client-789',
          senderName: 'Mike Johnson',
          senderType: SenderType.USER,
          sentAt: DateTime(2023, 12, 15, 18, 30),
        );

        expect(userQuestion.senderType, SenderType.USER);
        expect(userQuestion.messageContent, contains('question'));
        expect(userQuestion.messageContent, contains('substitute'));
        expect(userQuestion.senderName, 'Mike Johnson');
      });

      test('represents nutritionist meal plan update notification', () {
        final planUpdate = ChatMessage(
          id: 'msg-plan-update-003',
          chatId: 'chat-ongoing-456',
          messageContent:
              'Great news! I\'ve updated your meal plan for next week based on your progress. You\'ll find more variety in your breakfast options and I\'ve added some new snack ideas that align with your fitness goals.',
          messageId: 'msg-plan-update-003',
          recipientId: 'user-active-client-789',
          senderId: 'nutritionist-dr-smith-789',
          senderName: 'Dr. Sarah Smith',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime(2023, 12, 20, 14, 15),
        );

        expect(planUpdate.senderType, SenderType.NUTRITIONIST);
        expect(planUpdate.messageContent, contains('updated your meal plan'));
        expect(planUpdate.messageContent, contains('progress'));
        expect(planUpdate.sentAt.hour, 14);
      });

      test('handles long message content appropriately', () {
        final longMessage =
            'This is a very detailed nutritional explanation that covers multiple aspects of dietary planning, including macronutrient distribution, meal timing, hydration requirements, supplementation guidelines, and long-term sustainability strategies. ' *
                5;

        final detailedAdvice = ChatMessage(
          id: 'msg-detailed-004',
          chatId: 'chat-educational-789',
          messageContent: longMessage,
          messageId: 'msg-detailed-004',
          recipientId: 'user-learning-client-101',
          senderId: 'nutritionist-expert-202',
          senderName: 'Dr. Expert Rodriguez',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime(2023, 12, 25, 10, 45),
        );

        expect(detailedAdvice.messageContent.length, greaterThan(1000));
        expect(
            detailedAdvice.messageContent, contains('nutritional explanation'));
        expect(detailedAdvice.senderType, SenderType.NUTRITIONIST);
      });

      test('represents anonymous user message (no senderName)', () {
        final anonymousMessage = ChatMessage(
          id: 'msg-anonymous-005',
          chatId: 'chat-support-999',
          messageContent:
              'I prefer to remain anonymous, but I have questions about starting a plant-based diet.',
          messageId: 'msg-anonymous-005',
          recipientId: 'nutritionist-support-team-555',
          senderId: 'user-anonymous-777',
          senderName: null,
          senderType: SenderType.USER,
          sentAt: DateTime(2023, 12, 28, 16, 20),
        );

        expect(anonymousMessage.senderName, isNull);
        expect(anonymousMessage.senderType, SenderType.USER);
        expect(anonymousMessage.messageContent, contains('anonymous'));
        expect(anonymousMessage.messageContent, contains('plant-based'));
      });
    });

    group('Edge cases and validation', () {
      test('handles empty message content', () {
        final emptyMessage = ChatMessage(
          id: 'msg-empty-001',
          chatId: 'chat-test-001',
          messageContent: '',
          messageId: 'msg-empty-001',
          recipientId: 'user-test-001',
          senderId: 'nutritionist-test-001',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        expect(emptyMessage.messageContent, '');
        expect(emptyMessage.messageContent.isEmpty, true);
      });

      test('handles very long ID fields', () {
        final longId = 'msg-' + 'x' * 1000;
        final longChatId = 'chat-' + 'y' * 1000;

        final longIdMessage = ChatMessage(
          id: longId,
          chatId: longChatId,
          messageContent: 'Message with very long IDs',
          messageId: longId,
          recipientId: 'user-normal',
          senderId: 'nutritionist-normal',
          senderType: SenderType.USER,
          sentAt: DateTime.now(),
        );

        expect(longIdMessage.id.length, greaterThan(1000));
        expect(longIdMessage.chatId.length, greaterThan(1000));
        expect(longIdMessage.id, longId);
        expect(longIdMessage.chatId, longChatId);
      });

      test('handles special characters in message content', () {
        final specialMessage = ChatMessage(
          id: 'msg-special-001',
          chatId: 'chat-special-001',
          messageContent:
              'Special chars: áéíóú ñ 中文 русский 🥗🍎💪 <script>alert("test")</script>',
          messageId: 'msg-special-001',
          recipientId: 'user-international',
          senderId: 'nutritionist-multilingual',
          senderType: SenderType.NUTRITIONIST,
          sentAt: DateTime.now(),
        );

        expect(specialMessage.messageContent, contains('áéíóú'));
        expect(specialMessage.messageContent, contains('中文'));
        expect(specialMessage.messageContent, contains('русский'));
        expect(specialMessage.messageContent, contains('🥗'));
        expect(specialMessage.messageContent, contains('<script>'));
      });

      test('handles extreme DateTime values', () {
        final veryOldDate = DateTime(1900, 1, 1);
        final veryFutureDate = DateTime(2100, 12, 31);

        final oldMessage = ChatMessage(
          id: 'msg-old',
          chatId: 'chat-old',
          messageContent: 'Very old message',
          messageId: 'msg-old',
          recipientId: 'user-old',
          senderId: 'nutritionist-old',
          senderType: SenderType.NUTRITIONIST,
          sentAt: veryOldDate,
        );

        final futureMessage = ChatMessage(
          id: 'msg-future',
          chatId: 'chat-future',
          messageContent: 'Future message',
          messageId: 'msg-future',
          recipientId: 'user-future',
          senderId: 'nutritionist-future',
          senderType: SenderType.USER,
          sentAt: veryFutureDate,
        );

        expect(oldMessage.sentAt.year, 1900);
        expect(futureMessage.sentAt.year, 2100);
        expect(oldMessage.sentAt.isBefore(futureMessage.sentAt), true);
      });
    });
  });
}
