// ============================================
// SUBSCRIPTION RESOLVER for Global Notifications
// subscription.onNewChatMessageForUser.js
// ============================================
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  // No arguments needed - will filter by user ID
  return {
    payload: {},
  };
}

export function response(ctx) {
  const userId = ctx.identity.sub;

  if (!ctx.result) {
    return null;
  }

  // Check if the current user is the recipient OR sender
  // This allows users to see their own sent messages in real-time too
  const message = ctx.result;

  // User should receive the message if:
  // 1. They are the recipient (someone sent them a message)
  // 2. They are the sender (for UI consistency)
  if (message.recipientId === userId || message.senderId === userId) {
    return message;
  }

  // Filter out messages not for this user
  return null;
}
