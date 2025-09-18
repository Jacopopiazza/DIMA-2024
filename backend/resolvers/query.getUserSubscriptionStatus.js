import { util } from '@aws-appsync/utils';

/**
 * Request function for getUserSubscriptionStatus
 */
export function request(ctx) {
  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  const userId = ctx.identity.sub;
  const pk = `USER#${userId}`;
  const sk = `SUBSCRIPTION_STATUS`;

  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
  };
}

/**
 * Response function for getUserSubscriptionStatus
 */
export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message);
  }

  if (!ctx.result || Object.keys(ctx.result).length === 0) {
    // User has no subscription yet, return FREE by default or null
    return {
      userId: ctx.identity.sub,
      subscriptionStatus: 'FREE', // or null if you prefer
    };
  }

  return {
    userId: ctx.identity.sub,
    subscriptionStatus: ctx.result.status, // DynamoDB stores status in "status" field
  };
}
