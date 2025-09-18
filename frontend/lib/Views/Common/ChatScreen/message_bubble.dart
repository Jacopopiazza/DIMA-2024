import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final bool showTimestamp;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.showTimestamp = false,
    this.isFirstInGroup = false,
    this.isLastInGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(
        left: isCurrentUser ? 48 : 8,
        right: isCurrentUser ? 8 : 48,
        top: isFirstInGroup ? 12 : 2,
        bottom: isLastInGroup ? 8 : 2,
      ),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender name for non-current users and first message in group
          if (!isCurrentUser && isFirstInGroup && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color:
                          _getSenderTypeColor(message.senderType, colorScheme)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      _getSenderTypeIcon(message.senderType),
                      size: 12,
                      color:
                          _getSenderTypeColor(message.senderType, colorScheme),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    message.senderName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Message bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(isCurrentUser || !isFirstInGroup ? 16 : 4),
                topRight:
                    Radius.circular(!isCurrentUser || !isFirstInGroup ? 16 : 4),
                bottomLeft:
                    Radius.circular(isCurrentUser || !isLastInGroup ? 16 : 4),
                bottomRight:
                    Radius.circular(!isCurrentUser || !isLastInGroup ? 16 : 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  Text(
                    message.messageContent,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isCurrentUser
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),

                  // Timestamp and status
                  if (showTimestamp || isLastInGroup)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTimestamp(context, message.sentAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isCurrentUser
                                  ? colorScheme.onPrimary.withOpacity(0.7)
                                  : colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.check_circle_outline,
                              size: 12,
                              color: colorScheme.onPrimary.withOpacity(0.7),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Today - show time
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return '${AppLocalizations.of(context)!.yesterday} ${DateFormat('HH:mm').format(dateTime)}';
    } else if (dateTime.isAfter(today.subtract(const Duration(days: 7)))) {
      // This week - show day and time
      return DateFormat('EEE HH:mm').format(dateTime);
    } else {
      // Older - show date and time
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }
  }

  Color _getSenderTypeColor(SenderType senderType, ColorScheme colorScheme) {
    // Workaround: Check if sender name suggests they are a nutritionist
    final senderName = message.senderName?.toLowerCase() ?? '';
    final isNutritionist = senderType == SenderType.NUTRITIONIST ||
        senderName.contains('nutrizionist') ||
        senderName.contains('nutritionist') ||
        senderName.contains('dietista') ||
        senderName.contains('dietitian');

    if (isNutritionist) {
      return Colors.green;
    } else {
      return colorScheme.primary;
    }
  }

  IconData _getSenderTypeIcon(SenderType senderType) {
    // Workaround: Check if sender name suggests they are a nutritionist
    final senderName = message.senderName?.toLowerCase() ?? '';
    final isNutritionist = senderType == SenderType.NUTRITIONIST ||
        senderName.contains('nutrizionist') ||
        senderName.contains('nutritionist') ||
        senderName.contains('dietista') ||
        senderName.contains('dietitian');

    if (isNutritionist) {
      return Icons.local_hospital_rounded;
    } else {
      return Icons.person_rounded;
    }
  }
}

// Widget to show a typing indicator
class TypingIndicator extends StatefulWidget {
  final String senderName;

  const TypingIndicator({
    super.key,
    required this.senderName,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(left: 8, right: 48, top: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              AppLocalizations.of(context)!.isTyping(widget.senderName),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.only(
                          right: index < 2 ? 4 : 0,
                        ),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurfaceVariant.withOpacity(
                            _opacityAnimation.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
