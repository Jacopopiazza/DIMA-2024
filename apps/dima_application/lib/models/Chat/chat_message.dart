enum SenderType { NUTRITIONIST, USER }

class ChatMessage {
  final String id;
  final String chatId;
  final String messageContent;
  final String messageId;
  final String recipientId;
  final String senderId;
  final String? senderName;
  final SenderType senderType;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.messageContent,
    required this.messageId,
    required this.recipientId,
    required this.senderId,
    this.senderName,
    required this.senderType,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? json['messageId'] ?? '',
      chatId: json['chatId'] as String,
      messageContent: json['messageContent'] as String,
      messageId: json['messageId'] as String,
      recipientId: json['recipientId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String?,
      senderType: _parseSenderType(json['senderType']),
      sentAt: _parseDateTime(json['sentAt']),
    );
  }

  static SenderType _parseSenderType(dynamic value) {
    if (value is String) {
      switch (value.toUpperCase()) {
        case 'NUTRITIONIST':
          return SenderType.NUTRITIONIST;
        case 'USER':
          return SenderType.USER;
        default:
          return SenderType.USER;
      }
    }
    return SenderType.USER;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value).toLocal();
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'messageContent': messageContent,
        'messageId': messageId,
        'recipientId': recipientId,
        'senderId': senderId,
        'senderName': senderName,
        'senderType': senderType.name,
        'sentAt': sentAt.toUtc().toIso8601String(),
      };

  @override
  String toString() {
    return 'ChatMessage(messageId: $messageId, chatId: $chatId, senderId: $senderId, senderType: $senderType, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.messageId == messageId;
  }

  @override
  int get hashCode => messageId.hashCode;
}
