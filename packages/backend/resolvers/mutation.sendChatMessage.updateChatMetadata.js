// ============================================
// UPDATED: Step 3 of sendChatMessage pipeline
// mutation.sendChatMessage.updateChatMetadata.js
// Now includes recipient info for subscription filtering
// ============================================
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { chatId, messageContent, sentAt, senderType } = ctx.stash;
  const { chatMetadata } = ctx.stash;

  // Determine recipient based on sender type
  const recipientId =
    senderType === 'USER' ? chatMetadata.nutritionistId : chatMetadata.userId;

  // Store recipient for response
  ctx.stash.recipientId = recipientId;

  // Update unread count for recipient
  const unreadField =
    senderType === 'USER' ? 'nutritionistUnreadCount' : 'userUnreadCount';

  const snippet =
    messageContent.length > 100
      ? messageContent.substring(0, 97) + '...'
      : messageContent;

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({
      PK: `CHAT#${chatId}`,
      SK: 'METADATA',
    }),
    update: {
      expression: `SET lastMessageTimestamp = :timestamp, 
                       lastMessageSnippet = :snippet, 
                       ${unreadField} = ${unreadField} + :inc`,
      expressionValues: util.dynamodb.toMapValues({
        ':timestamp': sentAt,
        ':snippet': snippet,
        ':inc': 1,
      }),
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    console.error('Failed to update chat metadata:', ctx.error);
  }

  // Get sender name from stash (could be fetched from Cognito if needed)
  const senderName =
    ctx.stash.senderType === 'USER'
      ? ctx.stash.chatMetadata.userGivenName
      : ctx.stash.chatMetadata.nutritionistGivenName;

  // Return enhanced message with recipient info for subscription
  return {
    chatId: ctx.stash.chatId,
    messageId: ctx.stash.messageId,
    senderId: ctx.stash.userId,
    senderType: ctx.stash.senderType,
    messageContent: ctx.stash.messageContent,
    sentAt: ctx.stash.sentAt,
    // Additional fields for subscription
    senderName: senderName,
    recipientId: ctx.stash.recipientId,
  };
}
