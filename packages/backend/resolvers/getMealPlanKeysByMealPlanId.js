import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { mealPlanId } = ctx.args.input;
  if (!mealPlanId) {
    util.error('mealPlanId is required');
  }
  return {
    operation: 'Query',
    index: 'GSI5_MealPlanId',
    query: {
      expression: 'mealPlanId = :mpid AND entityType = :et',
      expressionValues: {
        ':mpid': { S: mealPlanId },
        ':et': { S: 'MEAL_PLAN' },
      },
    },
    limit: 1,
  };
}

export function response(ctx) {
  if (!ctx.result || !ctx.result.items || ctx.result.items.length === 0) {
    util.error('Meal plan not found');
  }

  // Stash PK and SK for the next function
  const item = ctx.result.items[0];
  ctx.stash.pk = item.PK;
  ctx.stash.sk = item.SK;
  return ctx.prev.result;
}
