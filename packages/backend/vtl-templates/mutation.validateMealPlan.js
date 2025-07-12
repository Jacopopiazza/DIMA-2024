import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { mealPlanId, nutritionistId, validationStatus } = ctx.args.input;
  
  // Verify the authenticated user is the nutritionist being assigned
  if (ctx.identity.sub !== nutritionistId) {
    util.error('Unauthorized: You can only validate meal plans assigned to you');
  }

  // For this implementation, we'll use a scan with a filter
  // This is not efficient for production, but works for this implementation
  return {
    operation: 'Scan',
    filter: {
      expression: 'SK = :mealPlanId AND assignedNutritionistId = :nutritionistId',
      expressionAttributeValues: util.dynamodb.toMapValues({
        ':mealPlanId': 'PLAN#' + mealPlanId,
        ':nutritionistId': nutritionistId
      })
    },
    limit: 1
  };
}

export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }
  
  // If no meal plan found, return error
  if (!ctx.result.items || ctx.result.items.length === 0) {
    util.error('Meal plan not found or not assigned to you');
  }
  
  const mealPlan = ctx.result.items[0];
  
  // For now, we'll just verify the meal plan exists and is assigned to the nutritionist
  // In a production environment, you would need a pipeline resolver or Lambda to perform the actual update
  return {
    success: true,
    message: 'Meal plan found and assigned to you. Update functionality requires pipeline resolver.',
    mealPlanId: ctx.args.input.mealPlanId
  };
} 