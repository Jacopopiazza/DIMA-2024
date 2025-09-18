import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const {
    userId,
    mealPlanId,
    nutritionistId,
    chatId,
    now,
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

  const pk = `USER#${userId}`;
  const sk = `PLAN#${mealPlanId}`;

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
    update: {
      expression:
        'SET validationStatus = :validationStatus, ' +
        'updatedAt = :updatedAt, ' +
        'assignedNutritionistId = :assignedNutritionistId, ' +
        'chatId = :chatId, ' +
        'userFullName = :userFullName, ' +
        'nutritionistFullName = :nutritionistFullName, ' +
        '#mealPlanId = :mealPlanId',

      expressionValues: util.dynamodb.toMapValues({
        ':validationStatus': 'PENDING_REVIEW',
        ':updatedAt': now,
        ':assignedNutritionistId': `NUTR#${nutritionistId}`,
        ':chatId': chatId,
        ':mealPlanId': mealPlanId,
        ':userFullName': userFullName,
        ':nutritionistFullName': nutritionistFullName,
      }),
      expressionNames: {
        '#mealPlanId': 'mealPlanId',
      },
    },
    // Condition removed since we already validated in the first step
    condition: {
      expression: 'attribute_exists(PK) AND attribute_exists(SK)',
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  return {
    success: true,
    message: 'Validation request sent successfully and chat created',
    mealPlanId: ctx.stash.mealPlanId,
  };
}
