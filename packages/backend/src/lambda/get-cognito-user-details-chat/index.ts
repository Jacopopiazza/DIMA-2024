// lambda/getCognitoUserDetails.ts
import {
  CognitoIdentityProviderClient,
  AdminGetUserCommand,
  ListUsersCommand,
} from '@aws-sdk/client-cognito-identity-provider';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
} from '@aws-sdk/lib-dynamodb';

const cognito = new CognitoIdentityProviderClient({});
const dynamoClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(dynamoClient);

const USER_POOL_ID = process.env.USER_POOL_ID!;
const TABLE_NAME = process.env.TABLE_NAME!;
const CACHE_TTL = 86400; // 24 hours in seconds

interface UserDetails {
  userId: string;
  givenName: string;
  familyName: string;
  email: string;
  userType: 'USER' | 'NUTRITIONIST';
}

interface LambdaEvent {
  action: 'GET_USER' | 'GET_MULTIPLE_USERS' | 'GET_USER_AND_NUTRITIONIST';
  userId?: string;
  nutritionistId?: string;
  userIds?: string[];
}

export const handler = async (event: LambdaEvent): Promise<any> => {
  console.log('Event:', JSON.stringify(event));

  try {
    switch (event.action) {
      case 'GET_USER':
        return await getUserDetails(event.userId!);

      case 'GET_USER_AND_NUTRITIONIST':
        const [userDetails, nutritionistDetails] = await Promise.all([
          getUserDetails(event.userId!),
          getUserDetails(event.nutritionistId!),
        ]);
        console.log('User details:', userDetails);
        console.log('Nutritionist details:', nutritionistDetails);
        return {
          user: userDetails,
          nutritionist: nutritionistDetails,
        };

      case 'GET_MULTIPLE_USERS':
        const users = await Promise.all(
          event.userIds!.map((id) => getUserDetails(id)),
        );
        return { users };

      default:
        throw new Error(`Unknown action: ${event.action}`);
    }
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
};

async function getUserDetails(userId: string): Promise<UserDetails> {
  // First, try to get from DynamoDB cache
  const cached = await getCachedUserDetails(userId);
  if (cached) {
    console.log(`Found cached details for user ${userId}`);
    return cached;
  }

  // If not cached, fetch from Cognito
  console.log(`Fetching from Cognito for user ${userId}`);
  const cognitoUser = await getCognitoUser(userId);

  if (!cognitoUser) {
    throw new Error(`User ${userId} not found in Cognito`);
  }

  if (!cognitoUser.UserAttributes) {
    throw new Error(`User ${userId} has no attributes in Cognito`);
  }

  if (!getAttributeValue(cognitoUser.UserAttributes, 'given_name')) {
    throw new Error(`User ${userId} has no given_name in Cognito`);
  }

  if (!getAttributeValue(cognitoUser.UserAttributes, 'family_name')) {
    throw new Error(`User ${userId} has no family_name in Cognito`);
  }

  if (!getAttributeValue(cognitoUser.UserAttributes, 'email')) {
    throw new Error(`User ${userId} has no email in Cognito`);
  }

  // Extract user details from Cognito attributes
  const userDetails: UserDetails = {
    userId,
    givenName: getAttributeValue(cognitoUser.UserAttributes, 'given_name')!,
    familyName: getAttributeValue(cognitoUser.UserAttributes, 'family_name')!,
    email: getAttributeValue(cognitoUser.UserAttributes, 'email')!,
    userType: cognitoUser.Groups?.includes('NUTRITIONISTS')
      ? 'NUTRITIONIST'
      : 'USER',
  };

  // Cache the result in DynamoDB
  await cacheUserDetails(userDetails);

  return userDetails;
}

async function getCognitoUser(userId: string): Promise<any> {
  try {
    // First try to get user by sub (userId)
    const listResponse = await cognito.send(
      new ListUsersCommand({
        UserPoolId: USER_POOL_ID,
        Filter: `sub = "${userId}"`,
        Limit: 1,
      }),
    );

    if (listResponse.Users && listResponse.Users.length > 0) {
      const username = listResponse.Users[0].Username!;

      // Get full user details including groups
      const response = await cognito.send(
        new AdminGetUserCommand({
          UserPoolId: USER_POOL_ID,
          Username: username,
        }),
      );

      // Get user groups
      const groups = await getUserGroups(username);

      return {
        ...response,
        Groups: groups,
      };
    }

    return null;
  } catch (error) {
    console.error(`Error fetching Cognito user ${userId}:`, error);
    return null;
  }
}

async function getUserGroups(username: string): Promise<string[]> {
  try {
    const { AdminListGroupsForUserCommand } = await import(
      '@aws-sdk/client-cognito-identity-provider'
    );
    const response = await cognito.send(
      new AdminListGroupsForUserCommand({
        UserPoolId: USER_POOL_ID,
        Username: username,
      }),
    );

    return response.Groups?.map((g) => g.GroupName!) || [];
  } catch (error) {
    console.error(`Error fetching groups for ${username}:`, error);
    return [];
  }
}

async function getCachedUserDetails(
  userId: string,
): Promise<UserDetails | null> {
  try {
    const response = await docClient.send(
      new GetCommand({
        TableName: TABLE_NAME,
        Key: {
          PK: `USERCACHE#${userId}`,
          SK: 'DETAILS',
        },
      }),
    );

    if (response.Item) {
      // Check if cache is still valid
      const now = Math.floor(Date.now() / 1000);
      if (response.Item.ttl > now) {
        return response.Item as UserDetails;
      }
    }

    return null;
  } catch (error) {
    console.error('Cache read error:', error);
    return null;
  }
}

async function cacheUserDetails(userDetails: UserDetails): Promise<void> {
  try {
    const now = Math.floor(Date.now() / 1000);
    await docClient.send(
      new PutCommand({
        TableName: TABLE_NAME,
        Item: {
          PK: `USERCACHE#${userDetails.userId}`,
          SK: 'DETAILS',
          ...userDetails,
          ttl: now + CACHE_TTL,
          cachedAt: new Date().toISOString(),
        },
      }),
    );
  } catch (error) {
    console.error('Cache write error:', error);
    // Don't throw - caching is not critical
  }
}

function getAttributeValue(
  attributes: any[] | undefined,
  name: string,
): string | undefined {
  if (!attributes) return undefined;
  const attr = attributes.find((a) => a.Name === name);
  return attr?.Value;
}
