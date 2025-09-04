// lambda/getCognitoUserDetails.ts
import { CognitoIdentityProviderClient, AdminGetUserCommand, ListUsersCommand } from '@aws-sdk/client-cognito-identity-provider';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, PutCommand } from '@aws-sdk/lib-dynamodb';

const cognito = new CognitoIdentityProviderClient({});
const dynamoClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(dynamoClient);

const USER_POOL_ID = process.env.USER_POOL_ID!;
const TABLE_NAME = process.env.TABLE_NAME!;

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
          getUserDetails(event.nutritionistId!)
        ]);
        return {
          user: userDetails,
          nutritionist: nutritionistDetails
        };
      
      case 'GET_MULTIPLE_USERS':
        const users = await Promise.all(
          event.userIds!.map(id => getUserDetails(id))
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

  console.log(`Fetching from Cognito for user ${userId}`);
  const cognitoUser = await getCognitoUser(userId);
  
  if (!cognitoUser) {
    // Return default values if user not found
    return {
      userId,
      givenName: 'Unknown',
      familyName: 'User',
      email: '',
      userType: 'USER'
    };
  }

  // Extract user details from Cognito attributes
  const userDetails: UserDetails = {
    userId,
    givenName: getAttributeValue(cognitoUser.UserAttributes, 'given_name') || 'Unknown',
    familyName: getAttributeValue(cognitoUser.UserAttributes, 'family_name') || 'User',
    email: getAttributeValue(cognitoUser.UserAttributes, 'email') || '',
    userType: cognitoUser.Groups?.includes('NUTRITIONISTS') ? 'NUTRITIONIST' : 'USER'
  };

  return userDetails;
}

async function getCognitoUser(userId: string): Promise<any> {
  try {
    // First try to get user by sub (userId)
    const listResponse = await cognito.send(new ListUsersCommand({
      UserPoolId: USER_POOL_ID,
      Filter: `sub = "${userId}"`,
      Limit: 1
    }));

    if (listResponse.Users && listResponse.Users.length > 0) {
      const username = listResponse.Users[0].Username!;
      
      // Get full user details including groups
      const response = await cognito.send(new AdminGetUserCommand({
        UserPoolId: USER_POOL_ID,
        Username: username
      }));

      // Get user groups
      const groups = await getUserGroups(username);
      
      return {
        ...response,
        Groups: groups
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
    const { AdminListGroupsForUserCommand } = await import('@aws-sdk/client-cognito-identity-provider');
    const response = await cognito.send(new AdminListGroupsForUserCommand({
      UserPoolId: USER_POOL_ID,
      Username: username
    }));
    
    return response.Groups?.map(g => g.GroupName!) || [];
  } catch (error) {
    console.error(`Error fetching groups for ${username}:`, error);
    return [];
  }
}

function getAttributeValue(attributes: any[] | undefined, name: string): string | undefined {
  if (!attributes) return undefined;
  const attr = attributes.find(a => a.Name === name);
  return attr?.Value;
}
