import {
  AdminGetUserCommand,
  CognitoIdentityProviderClient,
} from '@aws-sdk/client-cognito-identity-provider';
import { Handler } from 'aws-lambda';
import { StepFunctionInput } from '../../types/StepFunctionInput';

// Initialize the Cognito client
const cognitoClient = new CognitoIdentityProviderClient({});
const { USER_POOL_ID } = process.env;

interface CognitoDetailsResponse extends StepFunctionInput {
  cognitoBirthdate?: string;
  cognitoGender?: string;
}

export const handler: Handler<
  StepFunctionInput,
  CognitoDetailsResponse
> = async (event) => {
  if (!USER_POOL_ID) {
    throw new Error('USER_POOL_ID environment variable is not set.');
  }

  if (!event.userId) {
    throw new Error('Event is missing userId.');
  }

  console.log(`Fetching Cognito details for user: ${event.userId}`);

  const command = new AdminGetUserCommand({
    UserPoolId: USER_POOL_ID,
    Username: event.userId,
  });

  try {
    const response = await cognitoClient.send(command);
    const attributes = response.UserAttributes;

    if (!attributes) {
      console.warn(`No attributes found for user ${event.userId}`);
      return {
        ...event,
        cognitoBirthdate: undefined,
        cognitoGender: undefined,
      };
    }

    // Transform UserAttributes array to object
    const mappedUserAttributes: Record<string, string> = {};
    attributes.forEach((attr) => {
      if (attr.Name && attr.Value) {
        mappedUserAttributes[attr.Name] = attr.Value;
      }
    });

    console.log(
      `Fetched Cognito attributes for user ${event.userId}: ${JSON.stringify(mappedUserAttributes)}`,
    );

    // Extract the specific attributes you need
    const birthdate = mappedUserAttributes['birthdate'];
    const gender = mappedUserAttributes['gender'];

    console.log(`Fetched Cognito details for user ${event.userId}:`, {
      cognitoBirthdate: birthdate,
      cognitoGender: gender,
    });

    const result: CognitoDetailsResponse = {
      ...event,
      cognitoBirthdate: birthdate,
      cognitoGender: gender,
    };

    console.log('Successfully fetched Cognito details:', result);

    return result;
  } catch (error) {
    console.error(
      `Failed to fetch Cognito details for user ${event.userId}:`,
      error,
    );
    throw new Error('Could not fetch user details from Cognito.');
  }
};
