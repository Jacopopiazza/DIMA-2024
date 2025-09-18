import { util } from '@aws-appsync/utils';

/**
 * Unmarks a meal as completed. Uses the provided date, or defaults to the
 * current UTC date if no date is passed.
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {import('@aws-appsync/utils').DynamoDBUpdateItemRequest} the request
 */
export function request(ctx) {
  const { mealPlanId, mealName, date: inputDate } = ctx.arguments.input;
  const userId = ctx.identity.sub;

  // Use the provided date if it exists; otherwise, default to today's UTC date.
  const targetDate = inputDate || util.time.nowISO8601().substring(0, 10);
  const nowTimestamp = util.time.nowISO8601();

  const mealNameSet = util.dynamodb.toStringSet([mealName]);

  return {
    operation: 'UpdateItem',
    key: {
      PK: util.dynamodb.toDynamoDB(`USER#${userId}`),
      SK: util.dynamodb.toDynamoDB(`PDC#${mealPlanId}#${targetDate}`),
    },
    update: {
      expression: `
        DELETE completedMealNames :mealName
        SET #updatedAt = :updatedAt
      `,
      expressionNames: {
        '#updatedAt': 'updatedAt',
      },
      expressionValues: {
        ':mealName': mealNameSet,
        ':updatedAt': util.dynamodb.toDynamoDB(nowTimestamp),
      },
    },
  };
}

/**
 * Returns the result of the UpdateItem operation.
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the result
 */
export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  // FIX: If DynamoDB deleted the attribute because it was the last item,
  // add it back as an empty list to satisfy the GraphQL schema.
  if (ctx.result && !ctx.result.completedMealNames) {
    ctx.result.completedMealNames = [];
  }

  return ctx.result;
}
