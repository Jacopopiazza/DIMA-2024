// chat_notification_banner.dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'chat_screen.dart';
import 'dart:convert';

// ============================================
// NOTIFICATION MODEL
// ============================================
class ChatNotification {
  final String chatId;
  final String mealPlanId;
  final String senderName;
  final String message;
  final DateTime timestamp;

  ChatNotification({
    required this.chatId,
    required this.mealPlanId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });
}

// ============================================
// NOTIFICATION PROVIDER
// ============================================
final chatNotificationProvider =
    StateNotifierProvider<ChatNotificationNotifier, ChatNotification?>((ref) {
  return ChatNotificationNotifier();
});

class ChatNotificationNotifier extends StateNotifier<ChatNotification?> {
  Timer? _dismissTimer;

  ChatNotificationNotifier() : super(null);

  void showNotification(ChatNotification notification) {
    state = notification;

    // Auto-dismiss after 4 seconds
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(seconds: 4), () {
      dismiss();
    });
  }

  void dismiss() {
    _dismissTimer?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }
}

// ============================================
// NOTIFICATION BANNER WIDGET
// ============================================
class ChatNotificationBanner extends ConsumerWidget {
  const ChatNotificationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(chatNotificationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: notification != null
          ? Container(
              key: ValueKey(notification.timestamp),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.primaryContainer,
                child: InkWell(
                  onTap: () {
                    // Navigate to chat
                    ref.read(chatNotificationProvider.notifier).dismiss();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: notification.chatId,
                          mealPlanId: notification.mealPlanId,
                          planName: 'Meal Plan',
                          otherPartyName: notification.senderName,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.chat_bubble_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.senderName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                notification.message,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer
                                      .withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color:
                                colorScheme.onPrimaryContainer.withOpacity(0.6),
                          ),
                          onPressed: () {
                            ref
                                .read(chatNotificationProvider.notifier)
                                .dismiss();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

// ============================================
// GLOBAL CHAT SUBSCRIPTION SERVICE
// ============================================
class GlobalChatSubscriptionService {
  static final GlobalChatSubscriptionService _instance =
      GlobalChatSubscriptionService._internal();

  factory GlobalChatSubscriptionService() => _instance;
  GlobalChatSubscriptionService._internal();

  StreamSubscription? _globalSubscription;
  String? _currentUserId;
  Function(ChatNotification)? onNewMessage;

  Future<void> initialize() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      _currentUserId = user.userId;
      _startGlobalSubscription();
    } catch (e) {
      print('Failed to initialize global chat subscription: $e');
    }
  }

  void _startGlobalSubscription() {
    const String subscription = '''
      subscription OnNewChatMessageForUser {
        onNewChatMessageForUser {
          chatId
          messageId
          senderId
          senderType
          messageContent
          sentAt
          senderName
          recipientId
        }
      }
    ''';

    final request = GraphQLRequest<String>(
      document: subscription,
    );

    _globalSubscription = Amplify.API
        .subscribe(
      request,
      onEstablished: () => print('Global chat subscription established'),
    )
        .listen(
      (event) {
        if (event.data != null) {
          try {
            final json = jsonDecode(event.data!);
            final message = json['onNewChatMessageForUser'];

            // Only show notification if it's not from the current user
            if (message['senderId'] != _currentUserId && onNewMessage != null) {
              onNewMessage!(ChatNotification(
                chatId: message['chatId'],
                mealPlanId: '', // You might need to fetch this
                senderName: message['senderName'] ?? 'Nutritionist',
                message: message['messageContent'],
                timestamp: DateTime.now(),
              ));
            }
          } catch (e) {
            print('Error processing global message: $e');
          }
        }
      },
      onError: (error) {
        print('Global subscription error: $error');
        // Retry after delay
        Future.delayed(const Duration(seconds: 5), () {
          _startGlobalSubscription();
        });
      },
    );
  }

  void dispose() {
    _globalSubscription?.cancel();
  }
}
