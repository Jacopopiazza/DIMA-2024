import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatNotificationData {
  final ChatMessage message;
  final DateTime timestamp;

  const ChatNotificationData({
    required this.message,
    required this.timestamp,
  });

  factory ChatNotificationData.fromChatMessage(ChatMessage message) {
    return ChatNotificationData(
      message: message,
      timestamp: DateTime.now(),
    );
  }
}

/// In-app notification widget specifically for chat messages
class ChatNotification extends StatefulWidget {
  final ChatNotificationData notification;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const ChatNotification({
    super.key,
    required this.notification,
    required this.onDismiss,
    this.onTap,
  });

  @override
  State<ChatNotification> createState() => _ChatNotificationState();
}

class _ChatNotificationState extends State<ChatNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the slide-in animation
    _animationController.forward();

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _animationController.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.primaryContainer.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap ?? _dismiss,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Sender avatar/icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getSenderTypeColor(
                                    widget.notification.message.senderType)
                                .withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getSenderTypeIcon(
                                widget.notification.message.senderType),
                            color: _getSenderTypeColor(
                                widget.notification.message.senderType),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Message content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Sender name and chat indicator
                              Row(
                                children: [
                                  Text(
                                    widget.notification.message.senderName ??
                                        'Someone',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_rounded,
                                          size: 12,
                                          color: colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Chat',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Message preview
                              Text(
                                _getMessagePreview(
                                    widget.notification.message.messageContent),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer
                                      .withOpacity(0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Timestamp
                              Text(
                                _formatTimestamp(
                                    widget.notification.timestamp, context),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer
                                      .withOpacity(0.7),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Dismiss button
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            onPressed: _dismiss,
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: colorScheme.onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              minimumSize: const Size(24, 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getMessagePreview(String content) {
    if (content.length <= 80) return content;
    return '${content.substring(0, 77)}...';
  }

  String _formatTimestamp(DateTime dateTime, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return AppLocalizations.of(context)!.justNow;
    } else if (difference.inMinutes < 60) {
      return AppLocalizations.of(context)!.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return AppLocalizations.of(context)!.hoursAgo(difference.inHours);
    } else {
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }
  }

  Color _getSenderTypeColor(SenderType senderType) {
    switch (senderType) {
      case SenderType.NUTRITIONIST:
        return Colors.green;
      case SenderType.USER:
        return Colors.blue;
    }
  }

  IconData _getSenderTypeIcon(SenderType senderType) {
    switch (senderType) {
      case SenderType.NUTRITIONIST:
        return Icons.local_hospital_rounded;
      case SenderType.USER:
        return Icons.person_rounded;
    }
  }
}

/// Enhanced overlay manager for showing chat notifications
class ChatNotificationManager {
  static OverlayEntry? _currentOverlay;

  /// Show a chat notification
  static void showChatNotification(
    BuildContext context,
    ChatNotificationData notification, {
    VoidCallback? onTap,
  }) {
    // Remove any existing notification
    hide();

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 0,
        right: 0,
        child: ChatNotification(
          notification: notification,
          onDismiss: hide,
          onTap: onTap,
        ),
      ),
    );

    // Use the root overlay to ensure it shows above nested navigators
    final overlayState = Overlay.of(context, rootOverlay: true);
    if (overlayState != null) {
      overlayState.insert(_currentOverlay!);
    }
  }

  /// Hide the current notification
  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  /// Check if a notification is currently showing
  static bool get hasActiveNotification => _currentOverlay != null;
}
