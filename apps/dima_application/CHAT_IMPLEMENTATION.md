# Flutter Chat Implementation with AWS AppSync

This document describes the comprehensive chat feature implementation for the DIMA Flutter application using AWS AppSync.

## Overview

The chat implementation provides:
- Real-time messaging using GraphQL subscriptions
- In-app notifications for background messages
- Material 3 design integration
- Proper state management with Riverpod
- Auth lifecycle integration
- Message pagination and error handling

## Architecture

### Core Components

1. **ChatService** (`lib/services/chat_service.dart`)
   - Singleton service managing GraphQL subscriptions
   - Handles message routing (active chat vs background notifications)
   - Provides methods for sending messages and fetching chat history

2. **State Management** (`lib/providers/chat_provider.dart`)
   - `ChatNotifier`: Manages individual chat states
   - `ChatNotificationNotifier`: Handles global chat notifications
   - Integration with auth state changes

3. **UI Components**
   - `ChatPage`: Main chat interface with Material 3 design
   - `MessageBubble`: Message display with proper styling
   - `ChatInput`: Message composition with send functionality
   - `ChatNotification`: In-app notification widget

4. **Models** (`lib/models/Chat/chat_state.dart`)
   - `ChatState`: Manages chat message lists and loading states
   - `ChatNotificationState`: Global notification state management

### GraphQL Operations

The implementation supports the following GraphQL operations:

```graphql
# Send a message
mutation SendChatMessage($input: SendMessageInput!) {
  sendChatMessage(input: $input) {
    recipientId
    message { ... }
  }
}

# Get chat messages with pagination
query GetChatMessages($chatId: ID!, $beforeTimestamp: String, $limit: Int) {
  getChatMessages(chatId: $chatId, beforeTimestamp: $beforeTimestamp, limit: $limit) {
    count
    hasMore
    oldestTimestamp
    messages { ... }
  }
}

# Subscribe to real-time messages
subscription OnNewChatMessageForUser($recipientId: ID!) {
  onNewChatMessageForUser(recipientId: $recipientId) {
    recipientId
    message { ... }
  }
}
```

## Integration Points

### 1. Meal Plan Integration

The chat feature integrates with meal plans through the existing `MealPlan.chatId` field:

```dart
// In ReadMealPlanPage
Widget? _buildChatButton(ColorScheme colorScheme) {
  if (_mealPlan?.chatId == null || _mealPlan!.chatId!.isEmpty) {
    return null; // No chat button if no chatId
  }
  
  return FloatingActionButton.extended(
    onPressed: () => _openChat(),
    icon: Icon(Icons.chat_bubble_rounded),
    label: Text('Chat with Nutritionist'),
  );
}
```

### 2. Authentication Lifecycle

The chat service automatically starts/stops with user authentication:

```dart
// In AuthStateProvider
void _onUserSignedIn() {
  // Start chat service for new user session
  await ChatService.instance.startListening();
}

void _onUserSignedOut() {
  // Stop chat service when user signs out
  await ChatService.instance.stopListening();
}
```

### 3. Global Notification Handling

Background messages trigger in-app notifications:

```dart
// Global handler setup in main app
GlobalChatNotificationHandler(
  child: UserTypeRouter(),
)
```

## Usage Examples

### Opening a Chat

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => ChatPage(
      chatId: 'your-chat-id',
      title: 'Chat with Nutritionist',
    ),
  ),
);
```

### Sending a Message

The chat page handles message sending automatically through the input widget:

```dart
ChatInput(
  onSendMessage: (message) {
    ref.read(chatProvider(chatId).notifier).sendMessage(message);
  },
  isLoading: chatState.isSending,
)
```

### Real-time Message Handling

Messages are automatically delivered based on user context:
- **Active chat**: Messages appear directly in the chat interface
- **Background**: Messages trigger in-app notifications

## Error Handling

The implementation includes comprehensive error handling:

- Network connection errors
- GraphQL mutation/query failures
- Subscription connection issues
- Message sending failures
- Proper error states in UI

## Performance Considerations

1. **Message Pagination**: Uses `beforeTimestamp` for efficient loading
2. **Memory Management**: Limits message history in memory
3. **Connection Management**: Proper subscription cleanup
4. **State Optimization**: Riverpod providers with proper disposal

## Testing

To test the chat implementation:

1. **Authentication**: Ensure chat service starts/stops with login/logout
2. **Message Flow**: Test sending and receiving messages
3. **Notifications**: Verify background notification behavior
4. **Error States**: Test network failures and error recovery
5. **UI Responsiveness**: Verify proper loading states and animations

## File Structure

```
lib/
├── services/
│   └── chat_service.dart                    # Core chat service
├── providers/
│   └── chat_provider.dart                   # Riverpod state management
├── models/
│   └── Chat/
│       └── chat_state.dart                  # State models
├── Views/Common/
│   ├── ChatScreen/
│   │   ├── chat_page.dart                   # Main chat interface
│   │   ├── message_bubble.dart              # Message components
│   │   └── chat_input.dart                  # Message input
│   ├── chat_notification.dart               # Notification widget
│   └── global_chat_notification_handler.dart # Global handler
└── generated/flutter-models/
    └── SendMessageInput.dart                # GraphQL input model
```

## Dependencies

The chat feature uses the following dependencies:

- `amplify_flutter`: AWS AppSync integration
- `flutter_riverpod`: State management
- `intl`: Date/time formatting
- Existing project dependencies for UI and navigation

## Security Considerations

- All chat operations require proper Cognito authentication
- GraphQL operations are protected by AWS AppSync auth rules
- Message content is validated before sending
- User permissions are enforced at the GraphQL layer

## Future Enhancements

Potential improvements for future releases:

1. **File Attachments**: Support for image and document sharing
2. **Message Reactions**: Like/emoji reactions to messages
3. **Typing Indicators**: Real-time typing status
4. **Message Search**: Search within chat history
5. **Push Notifications**: Background push notifications
6. **Message Threading**: Reply-to-message functionality
7. **Chat Moderation**: Admin controls and content filtering

This implementation provides a robust foundation for chat functionality that can be extended as needed.