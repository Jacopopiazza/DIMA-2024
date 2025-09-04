import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { userId, nutritionistId } = ctx.stash;

  // Invoke Lambda to get user details from Cognito
  return {
    operation: 'Invoke',
    payload: {
      action: 'GET_USER_AND_NUTRITIONIST',
      userId: userId,
      nutritionistId: nutritionistId,
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    // Log error but don't fail - use defaults
    console.error('Failed to fetch user details:', ctx.error);
    util.error('Failed to fetch user details');
  }

  if (!ctx.result || !ctx.result.user || !ctx.result.nutritionist) {
    console.error('Incomplete user details received:', ctx.result);
    util.error('Incomplete user details received');
  }

  // Extract names from Lambda response
  const result = ctx.result;
  ctx.stash.userGivenName = result.user?.givenName;
  ctx.stash.userFamilyName = result.user?.familyName;
  ctx.stash.nutritionistGivenName = result.nutritionist?.givenName;
  ctx.stash.nutritionistFamilyName = result.nutritionist?.familyName;

  return ctx.prev.result;
}
