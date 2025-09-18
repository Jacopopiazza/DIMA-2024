import {
  CognitoIdentityProviderClient,
  AdminGetUserCommand,
  AdminGetUserCommandInput,
  AdminGetUserCommandOutput,
} from '@aws-sdk/client-cognito-identity-provider';

interface LambdaEvent {
  userSub: string;
}

interface UserDetails {
  statusCode: number;
  givenName: string | null;
  familyName: string | null;
  email: string | null;
  customAttribute: string | null;
}

const cognitoClient = new CognitoIdentityProviderClient({
  region: process.env.AWS_REGION,
});

export const handler = async (event: LambdaEvent): Promise<UserDetails> => {
  try {
    const { userSub } = event;

    if (!userSub) {
      throw new Error('userSub is required');
    }

    if (!process.env.USER_POOL_ID) {
      throw new Error('USER_POOL_ID environment variable is required');
    }

    const input: AdminGetUserCommandInput = {
      UserPoolId: process.env.USER_POOL_ID,
      Username: userSub,
    };

    const command = new AdminGetUserCommand(input);
    const response: AdminGetUserCommandOutput =
      await cognitoClient.send(command);

    // Transform UserAttributes array to object
    const userAttributes: Record<string, string> = {};
    if (response.UserAttributes) {
      response.UserAttributes.forEach((attr) => {
        if (attr.Name && attr.Value) {
          userAttributes[attr.Name] = attr.Value;
        }
      });
    }

    return {
      statusCode: 200,
      givenName: userAttributes['given_name'] || null,
      familyName: userAttributes['family_name'] || null,
      email: userAttributes['email'] || null,
      customAttribute: userAttributes['custom:your_custom_attribute'] || null,
    };
  } catch (error) {
    console.error('Error getting user details:', error);

    if (error instanceof Error) {
      throw new Error(`Failed to get user details: ${error.message}`);
    }

    throw new Error('Failed to get user details: Unknown error');
  }
};
