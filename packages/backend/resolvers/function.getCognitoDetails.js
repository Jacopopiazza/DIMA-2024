import { util } from '@aws-appsync/utils';

export function request(ctx) {
  if (!ctx.identity || !ctx.identity.sub) {
    util.unauthorized();
  }

  return {
    operation: 'Invoke',
    payload: {
      userSub: ctx.identity.sub,
    },
  };
}

export function response(ctx) {
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  // Store user details in stash for next function
  ctx.stash.givenName = ctx.result.givenName;
  ctx.stash.familyName = ctx.result.familyName;

  return ctx.result;
}
