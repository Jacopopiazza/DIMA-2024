import { util } from '@aws-appsync/utils';

/**
 * Modifies a meal plan name assigned to the nutritionist with authorization check.
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {import('@aws-appsync/utils').DynamoDBUpdateItemRequest} the request
 */
export function request(ctx) {
  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  const nutritionistId = ctx.identity.sub;
  const { mealPlanId, userId, mealPlanName } = ctx.args;

  // Validate input
  if (!mealPlanId) {
    util.error('mealPlanId is required');
  }

  if (!userId) {
    util.error('userId is required');
  }

  if (!mealPlanName) {
    util.error('mealPlanName is required');
  }

  const pk = `USER#${userId}`;
  const sk = `PLAN#${mealPlanId}`;
  const now = util.time.nowISO8601();

  return {
    operation: 'UpdateItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
    update: {
      expression: 'SET planName = :planName, updatedAt = :updatedAt, validationStatus = :validationStatus',
      expressionValues: util.dynamodb.toMapValues({
        ':planName': mealPlanName,
        ':updatedAt': now,
        ':validationStatus': 'PENDING_REVIEW',
        ':nutritionistId': nutritionistId,
      }),
    },
    condition: {
      expression: 'attribute_exists(PK) AND attribute_exists(SK) AND assignedNutritionistId = :nutritionistId',
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
        message: 'You are not authorized to modify this meal plan or it does not exist',
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
    message: 'Meal plan modified successfully and validation status reset to pending review',
    mealPlanId: ctx.args.mealPlanId,
  };
}
