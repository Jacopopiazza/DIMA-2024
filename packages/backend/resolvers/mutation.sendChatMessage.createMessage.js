import { util } from '@aws-appsync/utils';

// mutation.sendChatMessage.createMessage.js

export function request(ctx) {
  const { chatId, messageContent } = ctx.args.input;
  const { userId, isNutritionist } = ctx.stash;

  const timestamp = util.time.nowEpochMilliSeconds();
  const now = util.time.nowISO8601();
  const messageId = `MSG#${timestamp}`;

  const senderType = isNutritionist ? 'NUTRITIONIST' : 'USER';

  // Store for next step
  ctx.stash.messageId = messageId;
  ctx.stash.sentAt = now;
  ctx.stash.senderType = senderType;
  ctx.stash.messageContent = messageContent;

  const recipientId = isNutritionist
    ? ctx.stash.chatMetadata.userId
    : ctx.stash.chatMetadata.nutritionistId;

  const message = {
    PK: `CHAT#${chatId}`,
    SK: messageId,
    chatId: chatId,
    messageId: messageId,
    senderId: userId,
    senderType: senderType,
    messageContent: messageContent,
    sentAt: now,
    senderName: ctx.stash.isNutritionist
      ? ctx.stash.chatMetadata.nutritionistGivenName
      : ctx.stash.chatMetadata.userGivenName,
    recipientId: recipientId,
    entityType: 'MESSAGE',
  };

  return {
    operation: 'PutItem',
    key: util.dynamodb.toMapValues({
      PK: message.PK,
      SK: message.SK,
    }),
    attributeValues: util.dynamodb.toMapValues(message),
  };
}

export function response(ctx) {
  if (ctx.error) {
    util.error('Failed to send message', ctx.error.type);
  }

  // Store the created message for the response
  ctx.stash.createdMessage = ctx.result;
  return ctx.result;
}
