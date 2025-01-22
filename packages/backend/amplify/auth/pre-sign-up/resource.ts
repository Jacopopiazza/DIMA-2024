import { defineFunction } from '@aws-amplify/backend';

export const preSignUpLambda = defineFunction({
  name: "pre-sign-up",
  resourceGroupName: 'auth',
});
