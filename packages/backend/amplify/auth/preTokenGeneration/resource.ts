import { defineFunction } from '@aws-amplify/backend';

export const preTokenGenerationLambda = defineFunction({
  name: "preTokenGenerationLambda",
  resourceGroupName: 'auth'
});

