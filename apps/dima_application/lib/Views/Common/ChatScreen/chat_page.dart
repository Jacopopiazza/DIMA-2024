import 'package:dima_application/Utils/error_handling_utils.dart';
import 'package:dima_application/Views/Common/ChatScreen/chat_input.dart';
import 'package:dima_application/Views/Common/ChatScreen/message_bubble.dart';
import 'package:dima_application/Views/UserViews/SettingsScreen/settings_screen_riverpod.dart';
import 'package:dima_application/models/Chat/chat_message.dart';
import 'package:dima_application/models/Chat/chat_state.dart';
import 'package:dima_application/providers/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String chatId;
  final String? title;
  final String? nutritionistName;
  final String? userName;
  final bool isCurrentUserNutritionist;

  const ChatPage({
    super.key,
    required this.chatId,
    this.title,
    this.nutritionistName,
    this.userName,
    this.isCurrentUserNutritionist = false,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;
  bool _hasScrolledToBottom = false;
  int _lastMessageCount = 0;
  String? _lastMessageId;
  bool _isAppInBackground = false;

  @override
  void initState() {
    super.initState();
    // Removed scroll listener - only using pull-to-refresh for loading older messages
    WidgetsBinding.instance.addObserver(this);

    // Reset scroll state when entering the chat
    _hasScrolledToBottom = false;
    _lastMessageCount = 0;
    _lastMessageId = null;

    // Set this chat as active and mark as read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeChatProvider.notifier).setActiveChat(widget.chatId);
      // Mark this chat as read to clear any notifications
      ref.read(chatNotificationProvider.notifier).markChatAsRead(widget.chatId);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();

    // Clear active chat when leaving
    try {
      if (mounted) {
        ref.read(activeChatProvider.notifier).clearActiveChat();
        // Don't invalidate provider - let it naturally dispose to avoid flashing
      }
    } catch (e) {
      // Ignore disposal errors
    }

    super.dispose();
  }

  /// Gets the recipient's name based on the current user type
  String _getRecipientName() {
    if (widget.isCurrentUserNutritionist) {
      // Current user is nutritionist, show user/patient name
      return widget.userName ?? 'Patient';
    } else {
      // Current user is regular user, show nutritionist name  
      return widget.nutritionistName ?? 'Nutritionist';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _isAppInBackground = true;
        break;
      case AppLifecycleState.resumed:
        // Small delay before allowing scroll operations after app resume
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isAppInBackground = false;
          }
        });
        break;
      default:
        break;
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      try {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } catch (e) {
        // Ignore scroll errors
      }
    });
  }

  Future<void> _onSendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      await ref
          .read(chatMessagesProvider(widget.chatId).notifier)
          .sendMessage(message);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final errorMessage = ErrorHandlingUtils.formatErrorMessage(e);
        final isSubscriptionError = ErrorHandlingUtils.isSubscriptionError(e);
        final isRetryable = ErrorHandlingUtils.isRetryableError(e);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: isSubscriptionError
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.error,
            action: isRetryable
                ? SnackBarAction(
                    label: 'Retry',
                    textColor: Theme.of(context).colorScheme.onError,
                    onPressed: () => _onSendMessage(message),
                  )
                : isSubscriptionError
                    ? SnackBarAction(
                        label: 'Upgrade',
                        textColor: Theme.of(context).colorScheme.onTertiary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsScreenRiverpod(
                                      showBackButton: true),
                            ),
                          );
                        },
                      )
                    : null,
          ),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    if (!_scrollController.hasClients) return;

    // Get the current state to calculate relative position
    final chatAsync = ref.read(chatMessagesProvider(widget.chatId));
    final currentChatState = chatAsync.valueOrNull;
    if (currentChatState == null || currentChatState.messages.isEmpty) return;

    // Store current scroll info
    final currentScrollOffset = _scrollController.position.pixels;
    final currentMaxScrollExtent = _scrollController.position.maxScrollExtent;
    final messagesBeforeLoad = currentChatState.messages.length;

    // Find which message we're currently looking at (approximate)
    final messageHeight = 80; // Approximate message height
    final visibleMessageIndex =
        ((currentMaxScrollExtent - currentScrollOffset) / messageHeight)
            .floor();
    final targetMessageIndex =
        (visibleMessageIndex).clamp(0, messagesBeforeLoad - 1);
    final targetMessageId =
        currentChatState.messages[targetMessageIndex].messageId;

    try {
      // Load older messages
      await ref
          .read(chatMessagesProvider(widget.chatId).notifier)
          .loadMoreMessages();

      // After loading, find the target message and scroll to maintain relative position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;

        final newChatAsync = ref.read(chatMessagesProvider(widget.chatId));
        final newChatState = newChatAsync.valueOrNull;
        if (newChatState == null) return;

        // Find the target message in the new list
        final targetIndex = newChatState.messages
            .indexWhere((msg) => msg.messageId == targetMessageId);
        if (targetIndex >= 0) {
          // Calculate new scroll position to keep the target message in the same relative position
          final newMessagesAdded =
              newChatState.messages.length - messagesBeforeLoad;
          final estimatedNewOffset =
              (newMessagesAdded * messageHeight) + currentScrollOffset;

          // Jump to the calculated position
          _scrollController.jumpTo(estimatedNewOffset.clamp(
              0.0, _scrollController.position.maxScrollExtent));
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load older messages: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chatAsync = ref.watch(chatMessagesProvider(widget.chatId));

    // Get current user ID for message styling
    _currentUserId ??=
        ref.read(chatMessagesProvider(widget.chatId).notifier).currentUserId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getRecipientName(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            chatAsync.when(
              data: (chatState) => Text(
                '${chatState.messageCount} messages',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              loading: () => Text(
                'Loading...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              error: (_, __) => Text(
                'Error',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: Icon(
              Icons.refresh_rounded,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: chatAsync.when(
              data: (chatState) =>
                  _buildMessagesArea(theme, colorScheme, chatState),
              loading: () => _buildLoadingState(colorScheme),
              error: (error, stackTrace) =>
                  _buildErrorState(theme, colorScheme, error.toString()),
            ),
          ),

          // Input area
          ChatInput(
            onSendMessage: _onSendMessage,
            isLoading: false, // We handle loading in the async state now
            placeholder: 'Message...',
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(
      ThemeData theme, ColorScheme colorScheme, ChatState chatState) {
    if (chatState.isEmpty) {
      return _buildEmptyState(theme, colorScheme);
    }

    // Smart scrolling logic - but not when app is in background or just resumed
    if (!_isAppInBackground) {
      final currentMessageCount = chatState.messages.length;
      final lastMessage =
          chatState.messages.isNotEmpty ? chatState.messages.last : null;
      final currentLastMessageId = lastMessage?.messageId;

      // Initial load - scroll to bottom immediately without delay
      if (!_hasScrolledToBottom && currentMessageCount > 0) {
        _hasScrolledToBottom = true;
        // Multiple attempts to ensure we scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _ensureScrollToBottom();
        });
        // Also try after a short delay as backup
        Future.delayed(const Duration(milliseconds: 50), () {
          _ensureScrollToBottom();
        });
      }
      // New message arrived - scroll to bottom with animation, but only if we're near the bottom
      else if (currentMessageCount > _lastMessageCount &&
          currentLastMessageId != _lastMessageId &&
          currentLastMessageId != null &&
          _isNearBottom()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients && !_isAppInBackground) {
            _scrollToBottom(animated: true);
          }
        });
      }

      // Update tracking variables immediately
      _lastMessageCount = currentMessageCount;
      _lastMessageId = currentLastMessageId;
    }

    final messagesListView = CustomScrollView(
      controller: _scrollController,
      // Start from the bottom (reverse scroll)
      reverse: false,
      slivers: [
        // Top spacing and load more indicator
        if (chatState.hasMoreMessages)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Text(
                'Pull down to load older messages',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          ),

        // Messages
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final message = chatState.messages[index];
              final isCurrentUser = message.senderId == _currentUserId;
              final isFirstInGroup =
                  _isFirstMessageInGroup(chatState.messages, index);
              final isLastInGroup =
                  _isLastMessageInGroup(chatState.messages, index);
              final showTimestamp =
                  _shouldShowTimestamp(chatState.messages, index);

              return MessageBubble(
                message: message,
                isCurrentUser: isCurrentUser,
                showTimestamp: showTimestamp,
                isFirstInGroup: isFirstInGroup,
                isLastInGroup: isLastInGroup,
              );
            },
            childCount: chatState.messages.length,
          ),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );

    // Only show RefreshIndicator if there are older messages to load
    if (chatState.hasMoreMessages) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        displacement: 60.0, // Move indicator lower to avoid conflicts
        strokeWidth: 2.0,
        child: messagesListView,
      );
    } else {
      return messagesListView;
    }
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Loading messages...',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      ThemeData theme, ColorScheme colorScheme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load chat',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.chat_rounded,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Start the conversation',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Send a message to begin chatting.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool _isFirstMessageInGroup(List<ChatMessage> messages, int index) {
    if (index == 0) return true;

    final current = messages[index];
    final previous = messages[index - 1];

    return current.senderId != previous.senderId ||
        _hasTimeGap(previous.sentAt, current.sentAt);
  }

  bool _isLastMessageInGroup(List<ChatMessage> messages, int index) {
    if (index == messages.length - 1) return true;

    final current = messages[index];
    final next = messages[index + 1];

    return current.senderId != next.senderId ||
        _hasTimeGap(current.sentAt, next.sentAt);
  }

  bool _shouldShowTimestamp(List<ChatMessage> messages, int index) {
    if (index == 0) return true;
    if (index == messages.length - 1) return true;

    final current = messages[index];
    final previous = messages[index - 1];

    return _hasTimeGap(
        previous.sentAt, current.sentAt, const Duration(minutes: 5));
  }

  bool _hasTimeGap(DateTime first, DateTime second,
      [Duration gap = const Duration(minutes: 2)]) {
    return second.difference(first).abs() > gap;
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollPosition = _scrollController.position.pixels;

    // Consider "near bottom" if within 200 pixels of the bottom
    return (maxScrollExtent - currentScrollPosition) < 200;
  }

  void _ensureScrollToBottom() {
    if (mounted && _scrollController.hasClients && !_isAppInBackground) {
      try {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (maxScrollExtent > 0) {
          _scrollController.jumpTo(maxScrollExtent);
        }
      } catch (e) {
        // Ignore scroll errors
      }
    }
  }
}
