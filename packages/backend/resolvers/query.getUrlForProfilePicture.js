// AppSync JavaScript Resolver for getUrlForProfilePicture
// This resolver invokes the presign-profile-picture-lambda

import { util } from '@aws-appsync/utils';

/**
 * Request handler - prepares the Lambda invocation
 * @param {import('@aws-appsync/utils').Context} ctx - The context object
 */
export function request(ctx) {
  console.log(
    'Resolver request - User context:',
    JSON.stringify(ctx.identity, null, 2),
  );

  // Get user ID from Cognito identity
  const userId = ctx.identity.sub;
  const username = ctx.identity.username;
  const groups = ctx.identity.groups || [];

  // Validate user is authenticated
  if (!userId) {
    util.error('User must be authenticated to access profile pictures');
  }

  // Check if user has required groups (optional additional check)
  const allowedGroups = ['USERS', 'NUTRITIONISTS'];
  const hasRequiredGroup = groups.some((group) =>
    allowedGroups.includes(group),
  );

  if (!hasRequiredGroup) {
    util.error(
      'User does not have required permissions to access profile pictures',
    );
  }

  const s3Key = ctx.arguments.s3Key;
  if (!s3Key) {
    util.error('s3Key argument is required to fetch profile picture');
  }

  console.log('Requesting link for object key:', s3Key);

  // Prepare the Lambda invocation payload
  const payload = {
    arguments: {
      objectKey: s3Key,
    },
  };

  return {
    version: '2018-05-29',
    operation: 'Invoke',
    payload: payload,
  };
}

/**
 * Response handler - processes the Lambda response
 * @param {import('@aws-appsync/utils').Context} ctx - The context object
 */
export function response(ctx) {
  console.log('Lambda response:', JSON.stringify(ctx.result, null, 2));

  // Check for Lambda errors
  if (ctx.error) {
    console.error('Lambda invocation error:', ctx.error);
    util.error(`Lambda error: ${ctx.error.message}`, ctx.error.type);
  }

  // Check if Lambda returned an error
  if (ctx.result.errorType) {
    console.error('Lambda function error:', ctx.result);
    util.error(`Profile picture access failed: ${ctx.result.errorMessage}`);
  }

  // Return the presigned URL from Lambda response
  const lambdaResult = ctx.result;

  // Validate Lambda response structure
  if (!lambdaResult.url) {
    console.error('Invalid Lambda response - missing URL:', lambdaResult);
    util.error('Failed to generate profile picture URL');
  }

  console.log(
    'Successfully generated presigned URL for user:',
    ctx.identity.sub,
  );

  // Return just the URL since the field type is AWSURL
  return lambdaResult.url;
}
