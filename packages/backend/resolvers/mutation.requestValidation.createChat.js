import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const {
    userId,
    mealPlanId,
    nutritionistId,
    chatId,
    now,
    planName,
    userGivenName,
    userFamilyName,
    nutritionistGivenName,
    nutritionistFamilyName,
  } = ctx.stash;

  // Build full names
  const userFullName = userFamilyName
    ? `${userGivenName} ${userFamilyName}`
    : userGivenName;

  const nutritionistFullName = nutritionistFamilyName
    ? `${nutritionistGivenName} ${nutritionistFamilyName}`
    : nutritionistGivenName;

  // Create chat metadata item
  const chatMetadata = {
    PK: `CHAT#${chatId}`,
    SK: 'METADATA',
    chatId: chatId,
    userId: userId,
    nutritionistId: nutritionistId,
    mealPlanId: mealPlanId,
    planName: planName,
    userGivenName: userFullName,
    nutritionistGivenName: nutritionistFullName,
    lastMessageSnippet: null,
    userUnreadCount: 0,
    nutritionistUnreadCount: 0,
    createdAt: now,
    entityType: 'CHAT_METADATA',
    // For GSIs - use createdAt as initial value for lastMessageTimestamp
    lastMessageTimestamp: now,
  };

  return {
    operation: 'PutItem',
    key: util.dynamodb.toMapValues({
      PK: chatMetadata.PK,
      SK: chatMetadata.SK,
    }),
    attributeValues: util.dynamodb.toMapValues(chatMetadata),
    condition: {
      expression: 'attribute_not_exists(PK) AND attribute_not_exists(SK)',
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    console.error('Failed to create chat metadata:', ctx.error);
    // Continue anyway - chat can be created later if needed
  }

  return {
    success: true,
    message: 'Validation request sent successfully and chat created',
    mealPlanId: ctx.stash.mealPlanId,
  };
}
