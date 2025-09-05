class SendMessageInput {
  final String chatId;
  final String messageContent;

  const SendMessageInput({
    required this.chatId,
    required this.messageContent,
  });

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'messageContent': messageContent,
      };

  factory SendMessageInput.fromJson(Map<String, dynamic> json) {
    return SendMessageInput(
      chatId: json['chatId'] as String,
      messageContent: json['messageContent'] as String,
    );
  }

  @override
  String toString() {
    return 'SendMessageInput(chatId: $chatId, messageContent: $messageContent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendMessageInput &&
        other.chatId == chatId &&
        other.messageContent == messageContent;
  }

  @override
  int get hashCode => Object.hash(chatId, messageContent);
}
