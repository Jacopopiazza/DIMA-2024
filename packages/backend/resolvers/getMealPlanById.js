/**
 * Query: getMealPlanById(mealPlanId: ID!)
 * Action: Fetch a specific meal plan by ID and verify ownership
 * Runtime: APPSYNC_JS
 */

import { util } from '@aws-appsync/utils';

/**
 * Request handler - validates input and constructs DynamoDB GetItem operation
 */
export function request(ctx) {
  // Get user ID from context identity
  const userId = ctx.identity?.sub;

  if (!userId) {
    util.unauthorized();
  }

  // Get meal plan ID from arguments
  const mealPlanId = ctx.args.mealPlanId;

  if (!mealPlanId) {
    util.error('mealPlanId is required.', 'ValidationException');
  }

  // Construct the primary key for the meal plan
  // Meal plans are stored with PK = "USER#userId" and SK = "PLAN#mealPlanId"
  const pk = `USER#${userId}`;
  const sk = `PLAN#${mealPlanId}`;

  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({
      PK: pk,
      SK: sk
    }),
  };
}

/**
 * Response handler - processes DynamoDB response and transforms data
 */
export function response(ctx) {
  // Handle DynamoDB errors
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  // Check if meal plan was found
  if (!ctx.result) {
    util.error('Meal plan not found or you don\'t have access to it.', 'NotFound');
  }

  const mealPlan = ctx.result;

  // Transform the dailyPlan from DynamoDB Map format to GraphQL structure
  if (mealPlan.dailyPlan) {
    // The dailyPlan in DynamoDB is stored as a Map, but GraphQL expects DailyPlanData structure
    // where each day field contains a list of meals
    const transformedDailyPlan = {
      monday: mealPlan.dailyPlan.monday || [],
      tuesday: mealPlan.dailyPlan.tuesday || [],
      wednesday: mealPlan.dailyPlan.wednesday || [],
      thursday: mealPlan.dailyPlan.thursday || [],
      friday: mealPlan.dailyPlan.friday || [],
      saturday: mealPlan.dailyPlan.saturday || [],
      sunday: mealPlan.dailyPlan.sunday || []
    };

    // Update the meal plan with transformed daily plan
    mealPlan.dailyPlan = transformedDailyPlan;
  }

  return mealPlan;
}
