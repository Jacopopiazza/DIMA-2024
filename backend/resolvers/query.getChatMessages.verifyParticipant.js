import { util } from '@aws-appsync/utils';

// query.getChatMessages.verifyParticipant.js

export function request(ctx) {
  const { chatId } = ctx.args; // Note: different from mutation (no .input)
  const userId = ctx.identity.sub;

  if (!userId) {
    util.unauthorized();
  }

  ctx.stash.chatId = chatId;
  ctx.stash.userId = userId;
  ctx.stash.isNutritionist = ctx.identity.groups?.includes('NUTRITIONISTS');

  // Get chat metadata to verify participant
  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({
      PK: `CHAT#${chatId}`,
      SK: 'METADATA',
    }),
    consistentRead: true,
  };
}

export function response(ctx) {
  if (ctx.error) {
    util.error('Failed to retrieve chat', ctx.error.type);
  }

  if (!ctx.result) {
    util.error('Chat not found', 'NotFound');
  }

  const chat = ctx.result;
  const userId = ctx.stash.userId;
  const isNutritionist = ctx.stash.isNutritionist;

  // Verify the user is a participant
  const isParticipant = isNutritionist
    ? chat.nutritionistId === userId
    : chat.userId === userId;

  if (!isParticipant) {
    util.unauthorized();
  }

  // Store chat metadata for next steps
  ctx.stash.chatMetadata = chat;
  return ctx.result;
}
