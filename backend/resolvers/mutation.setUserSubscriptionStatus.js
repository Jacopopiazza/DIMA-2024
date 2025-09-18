import { util } from '@aws-appsync/utils';

/**
 * Sets or updates a user's subscription status in DynamoDB
 */
export function request(ctx) {
  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  const userId = ctx.identity.sub;
  const pk = `USER#${userId}`;
  const sk = `SUBSCRIPTION_STATUS`;
  const now = util.time.nowISO8601();
  const status = ctx.args.subscriptionStatus;

  if (!['FREE', 'PRO'].includes(status)) {
    util.error('Invalid SubscriptionStatus chosen');
  }

  const itemData = {
    PK: pk,
    SK: sk,
    entityType: 'SUBSCRIPTION_STATUS',
    status: status,
    updatedAt: now,
  };

  return {
    operation: 'PutItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
    attributeValues: util.dynamodb.toMapValues(itemData),
  };
}

/**
 * Returns the subscription status in the shape expected by GraphQL
 */
export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message);
  }

  return {
    userId: ctx.identity.sub,
    subscriptionStatus: ctx.args.subscriptionStatus,
  };
}
