import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { preSignUpLambda } from './auth/pre-sign-up/resource';
import * as iam from 'aws-cdk-lib/aws-iam';
import { Stack } from 'aws-cdk-lib';

const stack = new Stack();

/**
 * @see https://docs.amplify.aws/react/build-a-backend/ to add storage, functions, and more
 */
const backend = defineBackend({
  auth,
  data,
  preSignUpLambda,
});

backend.preSignUpLambda.resources.lambda.addToRolePolicy(new iam.PolicyStatement({  
  actions: ['cognito-idp:AdminLinkProviderForUser', 'cognito-idp:ListUsers', 'cognito-idp:AdminCreateUser', 'cognito-idp:AdminSetUserPassword'],
  resources: [stack.formatArn({ service: 'cognito-idp', resource: 'userpool', resourceName: '*' })],
}));