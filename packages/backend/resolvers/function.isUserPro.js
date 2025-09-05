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

  const groups = ctx.identity.groups || [];

  const isNutritionist = groups.includes('NUTRITIONISTS');
  ctx.stash.isNutritionist = isNutritionist;

  // ✅ If NOT a NUTRITIONIST, skip DynamoDB query entirely
  if (isNutritionist) {
    console.log('Nutritionist user detected, skipping subscription check');
    ctx.stash.isPro = true; // Nutritionists bypass restrictions
    ctx.stash.subscriptionStatus = 'N/A';
    return {
      operation: 'GetItem',
      key: util.dynamodb.toMapValues({ PK: 'DUMMY#0', SK: 'DUMMY#0' }),
    }; // No request = skip resolver step
  }

  console.log('User detected starting subscription check...');

  const pk = `USER#${sub}`;
  const sk = `SUBSCRIPTION_STATUS`;

  const retValue = {
    operation: 'GetItem',
    key: util.dynamodb.toMapValues({ PK: pk, SK: sk }),
  };

  console.log('-------------------------');
  console.log(retValue);
  console.log('-------------------------');

  return retValue;
}

export function response(ctx) {
  // If we skipped the request step (nutritionists), just return
  if (ctx.stash.isNutritionist) {
    console.log('Nutritionist leaving the function...');
    return {};
  }

  const error = ctx.error;
  const dynamoResult = ctx.result;

  if (error) {
    util.error('Failed to retrieve subscription status', 'SUBSCRIPTION_ERROR');
  }

  let status = 'FREE'; // Default to FREE

  // Case 1: No DynamoDB record found at all
  if (!dynamoResult) {
    console.log(`No subscription record found for user. Defaulting to FREE.`);
    util.error('No Result');
  }
  // Case 2: Record exists but no status field
  else if (!dynamoResult.status) {
    console.log(
      `Subscription record exists but no status field found. Defaulting to FREE.`,
    );
    util.error('Empty result');
  }
  // Case 3: Record and status field exist
  else {
    status = dynamoResult.status;
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

  if (!isPro) {
    console.log(`User is on FREE plan. Applying restrictions.`);
    util.error(
      'This feature requires a PRO subscription',
      'SUBSCRIPTION_REQUIRED',
    );
  }

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
