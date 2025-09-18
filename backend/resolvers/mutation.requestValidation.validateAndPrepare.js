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

  // Check if meal plan exists and user owns it
  const pk = `USER#${userId}`;
  const sk = `PLAN#${mealPlanId}`;

  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
  };
}

export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  if (!ctx.result) {
    util.error(
      'Meal plan not found or you do not have permission to access it',
      'NotFoundError',
    );
  }

  // Check if a nutritionist is already assigned
  if (ctx.result.assignedNutritionistId) {
    util.error(
      'A nutritionist is already assigned to this meal plan',
      'ValidationError',
    );
  }

  // Store the meal plan for later use and continue to next step
  // ctx.stash.mealPlan = ctx.result;
  ctx.stash.planName = ctx.result.planName || `Meal Plan`;

  return ctx.result;
}
