import { util } from '@aws-appsync/utils';

export function request(ctx) {
  const { userId, nutritionistId } = ctx.stash;

  // Invoke Lambda to get user details from Cognito
  return {
    operation: 'Invoke',
    payload: {
      action: 'GET_USER_AND_NUTRITIONIST',
      userId: userId,
      nutritionistId: nutritionistId
    }
  };
}

export function response(ctx) {
  if (ctx.error) {
    // Log error but don't fail - use defaults
    console.error('Failed to fetch user details:', ctx.error);
    ctx.stash.userGivenName = 'User';
    ctx.stash.nutritionistGivenName = 'Nutritionist';
  } else if (ctx.result) {
    // Extract names from Lambda response
    const result = JSON.parse(ctx.result);
    ctx.stash.userGivenName = result.user?.givenName || 'User';
    ctx.stash.userFamilyName = result.user?.familyName || '';
    ctx.stash.nutritionistGivenName = result.nutritionist?.givenName || 'Nutritionist';
    ctx.stash.nutritionistFamilyName = result.nutritionist?.familyName || '';
  }

  return ctx.prev.result;
}