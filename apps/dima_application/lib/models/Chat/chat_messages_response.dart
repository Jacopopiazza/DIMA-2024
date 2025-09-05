import 'package:dima_application/models/Chat/chat_message.dart';

class ChatMessagesResponse {
  final int count;
  final bool hasMore;
  final List<ChatMessage> messages;
  final String? oldestTimestamp;

  const ChatMessagesResponse({
    required this.count,
    required this.hasMore,
    required this.messages,
    this.oldestTimestamp,
  });

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> messagesList = [];

    // Handle messages array - be very flexible with the format
    final messagesJson = json['messages'];
    if (messagesJson != null) {
      if (messagesJson is List) {
        // Direct array of messages
        messagesList = messagesJson
            .where((e) => e != null)
            .map((e) {
              try {
                return ChatMessage.fromJson(Map<String, dynamic>.from(e));
              } catch (error) {
                print('[ChatMessagesResponse] Error parsing message: $error');
                print('[ChatMessagesResponse] Message data: $e');
                return null;
              }
            })
            .where((e) => e != null)
            .cast<ChatMessage>()
            .toList();
      } else if (messagesJson is Map && messagesJson['items'] is List) {
        // GraphQL connection format with items
        messagesList = (messagesJson['items'] as List)
            .where((e) => e != null)
            .map((e) {
              try {
                return ChatMessage.fromJson(Map<String, dynamic>.from(e));
              } catch (error) {
                print(
                    '[ChatMessagesResponse] Error parsing message item: $error');
                print('[ChatMessagesResponse] Message item data: $e');
                return null;
              }
            })
            .where((e) => e != null)
            .cast<ChatMessage>()
            .toList();
      }
    }

    return ChatMessagesResponse(
      count: json['count'] as int? ?? messagesList.length,
      hasMore: json['hasMore'] as bool? ?? false,
      messages: messagesList,
      oldestTimestamp: json['oldestTimestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'hasMore': hasMore,
        'messages': messages.map((e) => e.toJson()).toList(),
        'oldestTimestamp': oldestTimestamp,
      };

  @override
  String toString() {
    return 'ChatMessagesResponse(count: $count, hasMore: $hasMore, messages: ${messages.length}, oldestTimestamp: $oldestTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessagesResponse &&
        other.count == count &&
        other.hasMore == hasMore &&
        other.messages.length == messages.length &&
        other.oldestTimestamp == oldestTimestamp;
  }

  @override
  int get hashCode =>
      Object.hash(count, hasMore, messages.length, oldestTimestamp);
}
