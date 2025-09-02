import { util } from '@aws-appsync/utils';

/**
 * AppSync Pipeline Function: Verify User Subscription Status
 * Use this as the first step in your pipeline to check if user is PRO or FREE
 */

export function request(ctx) {
  const sub = ctx.identity.sub;

  if (!sub) {
    util.unauthorized();
  }

  const pk = `USER#${sub}`;
  const sk = `SUBSCRIPTION_STATUS`;

  // Query DynamoDB for user subscription status
  return {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({
      PK: pk,
      SK: sk,
    }),
  };
}

export function response(ctx) {
  const error = ctx.error;
  const result = ctx.result;

  if (error) {
    util.error('Failed to retrieve subscription status', 'SUBSCRIPTION_ERROR');
  }

  let status = 'FREE'; // Default to FREE

  // Case 1: No DynamoDB record found at all
  if (!result) {
    console.log(`No subscription record found for user. Defaulting to FREE.`);
  }
  // Case 2: Record exists but no status field
  else if (!result.status || !result.status.S) {
    console.log(
      `Subscription record exists but no status field found. Defaulting to FREE.`,
    );
  }
  // Case 3: Record and status field exist
  else {
    status = result.status.S;
    console.log(`Found subscription status: ${status}`);
  }

  // Normalize status and ensure it's a valid value
  const normalizedStatus = status.toUpperCase();
  const validStatuses = ['PRO', 'FREE'];
  const finalStatus = validStatuses.includes(normalizedStatus)
    ? normalizedStatus
    : 'FREE';

  if (finalStatus !== normalizedStatus) {
    console.log(
      `Invalid status '${normalizedStatus}' found. Defaulting to FREE.`,
    );
  }

  const isPro = finalStatus === 'PRO';

  // Store in stash for use in subsequent pipeline functions
  ctx.stash.subscriptionStatus = finalStatus;
  ctx.stash.isPro = isPro;

  return {};
}

/**
 * Usage in subsequent pipeline functions:
 *
 * // Access subscription status
 * const isPro = ctx.stash.isPro;
 * const status = ctx.stash.subscriptionStatus;
 *
 * // Example: Restrict PRO-only features
 * if (!isPro) {
 *   util.error("This feature requires a PRO subscription", "SUBSCRIPTION_REQUIRED");
 * }
 *
 * // Example: Apply different limits based on subscription
 * const limit = isPro ? 100 : 10;
 */
