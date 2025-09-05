// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:async';
import 'dart:convert';

// ============================================
// MODELS
// ============================================
class ChatMessage {
  final String chatId;
  final String messageId;
  final String senderId;
  final String senderType;
  final String messageContent;
  final DateTime sentAt;

  ChatMessage({
    required this.chatId,
    required this.messageId,
    required this.senderId,
    required this.senderType,
    required this.messageContent,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatId: json['chatId'],
      messageId: json['messageId'],
      senderId: json['senderId'],
      senderType: json['senderType'],
      messageContent: json['messageContent'],
      sentAt: DateTime.parse(json['sentAt']),
    );
  }
}

class ChatMetadata {
  final String chatId;
  final String userId;
  final String nutritionistId;
  final String mealPlanId;
  final String planName;
  final String userGivenName;
  final String nutritionistGivenName;
  final int userUnreadCount;
  final int nutritionistUnreadCount;

  ChatMetadata({
    required this.chatId,
    required this.userId,
    required this.nutritionistId,
    required this.mealPlanId,
    required this.planName,
    required this.userGivenName,
    required this.nutritionistGivenName,
    required this.userUnreadCount,
    required this.nutritionistUnreadCount,
  });

  factory ChatMetadata.fromJson(Map<String, dynamic> json) {
    return ChatMetadata(
      chatId: json['chatId'],
      userId: json['userId'],
      nutritionistId: json['nutritionistId'],
      mealPlanId: json['mealPlanId'],
      planName: json['planName'] ?? 'Meal Plan',
      userGivenName: json['userGivenName'] ?? 'User',
      nutritionistGivenName: json['nutritionistGivenName'] ?? 'Nutritionist',
      userUnreadCount: json['userUnreadCount'] ?? 0,
      nutritionistUnreadCount: json['nutritionistUnreadCount'] ?? 0,
    );
  }
}

// ============================================
// PROVIDERS
// ============================================
final chatServiceProvider = Provider((ref) => ChatService());

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier,
    AsyncValue<List<ChatMessage>>, String>((ref, chatId) {
  return ChatMessagesNotifier(ref, chatId);
});

class ChatMessagesNotifier
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final Ref ref;
  final String chatId;
  StreamSubscription? _subscription;

  ChatMessagesNotifier(this.ref, this.chatId)
      : super(const AsyncValue.loading()) {
    loadMessages();
    subscribeToMessages();
  }

  Future<void> loadMessages() async {
    try {
      final messages =
          await ref.read(chatServiceProvider).getChatMessages(chatId);
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void subscribeToMessages() {
    _subscription =
        ref.read(chatServiceProvider).subscribeToChat(chatId).listen(
      (message) {
        state.whenData((messages) {
          state = AsyncValue.data([...messages, message]);
        });
      },
      onError: (error) {
        print('Subscription error: $error');
      },
    );
  }

  Future<void> sendMessage(String content) async {
    try {
      await ref.read(chatServiceProvider).sendMessage(chatId, content);
      // Message will appear via subscription
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// ============================================
// CHAT SERVICE
// ============================================
class ChatService {
  // Get chat messages
  Future<List<ChatMessage>> getChatMessages(String chatId,
      {int limit = 50}) async {
    const String query = '''
      query GetChatMessages(\$chatId: ID!, \$limit: Int) {
        getChatMessages(chatId: \$chatId, limit: \$limit) {
          items {
            chatId
            messageId
            senderId
            senderType
            messageContent
            sentAt
          }
          nextToken
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'chatId': chatId,
          'limit': limit,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final json = jsonDecode(response.data!);
        final items = json['getChatMessages']['items'] as List;
        return items.map((item) => ChatMessage.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading messages: $e');
      throw e;
    }
  }

  // Send a message
  Future<void> sendMessage(String chatId, String messageContent) async {
    const String mutation = '''
      mutation SendMessage(\$input: SendMessageInput!) {
        sendChatMessage(input: \$input) {
          chatId
          messageId
          senderId
          senderType
          messageContent
          sentAt
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'chatId': chatId,
            'messageContent': messageContent,
          }
        },
      );

      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  // Subscribe to chat messages
  Stream<ChatMessage> subscribeToChat(String chatId) {
    const String subscription = '''
      subscription OnNewMessage(\$chatId: ID!) {
        onNewChatMessage(chatId: \$chatId) {
          chatId
          messageId
          senderId
          senderType
          messageContent
          sentAt
        }
      }
    ''';

    final request = GraphQLRequest<String>(
      document: subscription,
      variables: {'chatId': chatId},
    );

    return Amplify.API
        .subscribe(
      request,
      onEstablished: () => print('Chat subscription established'),
    )
        .map((event) {
      if (event.data != null) {
        final json = jsonDecode(event.data!);
        return ChatMessage.fromJson(json['onNewChatMessage']);
      }
      throw Exception('No data in subscription event');
    });
  }

  // Get chat metadata
  Future<ChatMetadata?> getChatMetadata(String mealPlanId) async {
    // Query to get chat metadata for a meal plan
    // This would be implemented based on your backend structure
    // For now, returning null as placeholder
    return null;
  }
}

// ============================================
// CHAT SCREEN
// ============================================
class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String mealPlanId;
  final String planName;
  final String? otherPartyName;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.mealPlanId,
    required this.planName,
    this.otherPartyName,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _currentUserId = user.userId;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    try {
      await ref
          .read(chatMessagesProvider(widget.chatId).notifier)
          .sendMessage(text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      _messageController.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));

    if (_isLoadingUser) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.planName),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherPartyName ?? 'Chat',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.planName,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: colorScheme.outline.withOpacity(0.2),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start a conversation about your meal plan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _currentUserId;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                      colorScheme: colorScheme,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load messages',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(chatMessagesProvider(widget.chatId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildMessageInput(colorScheme),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: colorScheme.onPrimary,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// MESSAGE BUBBLE WIDGET
// ============================================
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final ColorScheme colorScheme;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8,
        left: isMe ? 64 : 0,
        right: isMe ? 0 : 64,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isMe
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
                  isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight:
                  isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.messageContent,
                style: TextStyle(
                  color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(message.sentAt),
                style: TextStyle(
                  color: isMe
                      ? colorScheme.onPrimary.withOpacity(0.7)
                      : colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
