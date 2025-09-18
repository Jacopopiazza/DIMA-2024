import { util } from '@aws-appsync/utils';

/**
 * Fetches the PlanDayCompletion item for a given user, plan, and date.
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {import('@aws-appsync/utils').DynamoDBGetItemRequest} the request
 */
export function request(ctx) {
  const { planId, date } = ctx.arguments;
  const userId = ctx.identity.sub;

  return {
    operation: 'GetItem',
    key: {
      PK: util.dynamodb.toDynamoDB(`USER#${userId}`),
      SK: util.dynamodb.toDynamoDB(`PDC#${planId}#${date}`),
    },
  };
}

/**
 * Returns the fetched item.
 * @param {import('@aws-appsync/utils').Context} ctx the context
 * @returns {*} the result
 */
export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  // FIX: If the fetched item exists but is missing the completedMealNames
  // attribute (because the last meal was unmarked), add it back as an
  // empty list to satisfy the GraphQL schema.
  if (ctx.result && !ctx.result.completedMealNames) {
    ctx.result.completedMealNames = [];
  }

  // The result of GetItem is the item itself. If no item is found, it will be null,
  // which is the correct GraphQL response for a non-existent record.
  return ctx.result;
}
