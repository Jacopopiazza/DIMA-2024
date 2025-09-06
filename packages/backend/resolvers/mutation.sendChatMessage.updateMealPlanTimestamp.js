// ============================================
// UPDATED: Step 3 of sendChatMessage pipeline
// mutation.sendChatMessage.updateChatMetadata.js
// Now includes recipient info for subscription filtering
// ============================================
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { chatId, messageContent, sentAt, senderType } = ctx.stash;
  const { chatMetadata } = ctx.stash;

  const mealPlanId = chatMetadata.mealPlanId;
  const userId = chatMetadata.userId;

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({
      PK: `USER#${userId}`,
      SK: `PLAN#${mealPlanId}`,
    }),
    update: {
      expression: `SET updatedAt = :timestamp`,
      expressionValues: util.dynamodb.toMapValues({
        ':timestamp': sentAt,
      }),
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    console.error('Failed to update chat metadata:', ctx.error);
  }

  // return previous created message
  return ctx.stash.createdMessage;
}
