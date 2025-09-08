import { util } from '@aws-appsync/utils';

/**
 * Modifies a meal plan assigned to the nutritionist with authorization check.
 * Can modify the plan name and/or the daily plan meals.
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {import('@aws-appsync/utils').DynamoDBUpdateItemRequest} the request
 */
export function request(ctx) {
  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  const nutritionistId = ctx.identity.sub;
  const { mealPlanId, userId, input } = ctx.args;

  // Validate input
  if (!mealPlanId) {
    util.error('mealPlanId is required');
  }

  if (!userId) {
    util.error('userId is required');
  }

  if (
    !input ||
    (!input.planName &&
      !input.dailyPlan &&
      !input.ingredients &&
      !input.totalMacros)
  ) {
    util.error(
      'At least one of planName, dailyPlan, ingredients, or totalMacros must be provided in input',
    );
  }

  const pk = `USER#${userId}`;
  const sk = `PLAN#${mealPlanId}`;
  const now = util.time.nowISO8601();

  // Build the update expression dynamically
  let updateExpression =
    'SET updatedAt = :updatedAt, validationStatus = :validationStatus';
  const expressionValues = {
    ':updatedAt': now,
    ':validationStatus': 'PENDING_REVIEW',
    ':assignedNutritionistId': `NUTR#${nutritionistId}`,
  };

  // Add planName if provided
  if (input.planName) {
    updateExpression += ', planName = :planName';
    expressionValues[':planName'] = input.planName;
  }

  // Add dailyPlan if provided
  if (input.dailyPlan) {
    updateExpression += ', dailyPlan = :dailyPlan';
    expressionValues[':dailyPlan'] = input.dailyPlan;
  }

  // Add ingredients if provided
  if (input.ingredients) {
    updateExpression += ', ingredients = :ingredients';
    expressionValues[':ingredients'] = input.ingredients;
  }

  // Add totalMacros if provided
  if (input.totalMacros) {
    updateExpression += ', totalMacros = :totalMacros';
    expressionValues[':totalMacros'] = input.totalMacros;
  }

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
    update: {
      expression: updateExpression,
      expressionValues: util.dynamodb.toMapValues(expressionValues),
    },
    condition: {
      expression:
        'attribute_exists(PK) AND attribute_exists(SK) AND assignedNutritionistId = :assignedNutritionistId',
    },
  };
}

/**
 * Returns the result of the update operation
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the modified meal plan response
 */
export function response(ctx) {
  if (ctx.error) {
    // Check if the error is due to condition failure
    if (ctx.error.type === 'DynamoDB:ConditionalCheckFailedException') {
      return {
        success: false,
        message:
          'You are not authorized to modify this meal plan or it does not exist',
        mealPlanId: null,
      };
    }

    return {
      success: false,
      message: ctx.error.message,
      mealPlanId: null,
    };
  }

  return {
    success: true,
    message:
      'Meal plan modified successfully and validation status reset to pending review',
    mealPlanId: ctx.args.mealPlanId,
  };
}
