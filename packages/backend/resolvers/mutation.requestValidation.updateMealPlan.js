import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { mealPlanId, nutritionistId } = ctx.args.input;

  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  // Validate input
  if (!mealPlanId) {
    util.error('mealPlanId is required');
  }

  if (!nutritionistId) {
    util.error('nutritionistId is required');
  }

  const userId = ctx.identity.sub;
  const chatId = util.autoId();
  const now = util.time.nowISO8601();

  // Store in stash for next steps
  ctx.stash.userId = userId;
  ctx.stash.mealPlanId = mealPlanId;
  ctx.stash.nutritionistId = nutritionistId;
  ctx.stash.chatId = chatId;
  ctx.stash.now = now;

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
        'nutritionistId = :nutritionistId, ' +
        '#mealPlanId = :mealPlanId',
      expressionValues: util.dynamodb.toMapValues({
        ':validationStatus': 'PENDING_REVIEW',
        ':updatedAt': now,
        ':assignedNutritionistId': nutritionistId,
        ':chatId': chatId,
        ':nutritionistId': nutritionistId,
        ':mealPlanId': mealPlanId, // Ensure mealPlanId is stored
      }),
      expressionNames: {
        '#mealPlanId': 'mealPlanId'
      }
    },
    condition: {
      expression: 'attribute_exists(PK) AND attribute_exists(SK) AND attribute_not_exists(assignedNutritionistId)'
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    if (ctx.error.type === 'DynamoDB:ConditionalCheckFailedException') {
      util.error('A nutritionist is already assigned to this meal plan', 'ValidationError');
    }
    util.error(ctx.error.message, ctx.error.type);
  }

  // Store the meal plan for the next step
  ctx.stash.mealPlan = ctx.result;
  ctx.stash.planName = ctx.result.planName || `Meal Plan`;
  return ctx.result;
}