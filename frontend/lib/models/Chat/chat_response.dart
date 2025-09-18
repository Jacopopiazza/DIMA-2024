import 'package:dima_application/models/Chat/chat_message.dart';

class ChatResponse {
  final ChatMessage? message;
  final String recipientId;

  const ChatResponse({
    this.message,
    required this.recipientId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    ChatMessage? message;

    if (json['message'] != null) {
      final messageData = json['message'];
      if (messageData is Map<String, dynamic>) {
        // Handle nested serializedData if present
        if (messageData['serializedData'] != null) {
          message = ChatMessage.fromJson(
              Map<String, dynamic>.from(messageData['serializedData']));
        } else {
          message = ChatMessage.fromJson(messageData);
        }
      }
    }

    return ChatResponse(
      message: message,
      recipientId: json['recipientId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message?.toJson(),
        'recipientId': recipientId,
      };

  @override
  String toString() {
    return 'ChatResponse(recipientId: $recipientId, message: ${message?.messageId})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatResponse &&
        other.message?.messageId == message?.messageId &&
        other.recipientId == recipientId;
  }

  @override
  int get hashCode => Object.hash(message?.messageId, recipientId);
}
