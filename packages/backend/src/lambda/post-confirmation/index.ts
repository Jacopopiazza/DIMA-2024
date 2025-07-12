import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb';
import {
  PostConfirmationTriggerEvent,
  PostConfirmationTriggerHandler,
} from 'aws-lambda';

import { UserTypeEnum } from '../../types/UserTypeEnum';
import { addUserToGroup, getGroupsForUser } from '../utils';

const dynamoClient = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(dynamoClient);
const TABLE_NAME = process.env.TABLE_NAME || 'MealPlanningTable';

export const handler: PostConfirmationTriggerHandler = async (
  event: PostConfirmationTriggerEvent,
) => {
  console.log(
    'PostConfirmationTriggerHandler event: ',
    JSON.stringify(event, null, 2),
  );

  const { userPoolId, userName, request } = event;
  const userAttributes = request.userAttributes;

  // Check user role and add to appropriate group
  const userRole = userAttributes['custom:role'];

  if (!userRole) {
    console.error('User role not defined');
    throw new Error('User role is required');
  }

  if (!Object.values(UserTypeEnum).includes(userRole as any)) {
    console.error(`Invalid role: ${userRole}`);
    throw new Error(
      `Invalid role: ${userRole}. Allowed roles are: USER, NUTRITIONIST`,
    );
  }

  try {
    const groups = await getGroupsForUser(userPoolId, userName);
    console.log(`Groups for user ${userName}: ${groups}`);

    if (groups.includes('USERS') || groups.includes('NUTRITIONISTS')) {
      console.log(`User ${userName} already in group`);
      return event;
    }
  } catch (error) {
    console.error('Error getting groups for user:', error);
    throw error;
  }

  try {
    // Set group name based on role
    const groupName =
      userRole === UserTypeEnum.USER.toString() ? 'USERS' : 'NUTRITIONISTS';

    await addUserToGroup(userPoolId, userName, groupName);

    console.log(`Added user ${userName} to group ${groupName}`);

    // If this is a nutritionist, create their profile in DynamoDB
    if (userRole === UserTypeEnum.NUTRITIONIST.toString()) {
      try {
        const givenName = userAttributes.given_name || '';
        const familyName = userAttributes.family_name || '';
        const nutritionistId = userName; // Use the Cognito username as the nutritionist ID

        // Create nutritionist profile in DynamoDB (consistent with user pattern)
        const nutritionistProfile = {
          PK: `NUTR#${nutritionistId}`,
          SK: 'NUTR_DETAILS',
          NutritionistID: nutritionistId,
          GivenName: givenName,
          FamilyName: familyName,
          Specialization: 'General Nutrition', // Default specialization
          Bio: 'Certified nutritionist helping clients achieve their health goals.',
          ProfilePictureURL: userAttributes.profilePicture || null,
          IsAvailable: true, // Default to available
          // GSI1 keys for listing
          GSI1PK: 'NUTR_PROFILES_ALL',
          GSI1SK: `NUTRID#${nutritionistId}`,
        };

        const putCommand = new PutCommand({
          TableName: TABLE_NAME,
          Item: nutritionistProfile,
        });

        await docClient.send(putCommand);
        console.log(
          `Created nutritionist profile for ${givenName} ${familyName}`,
        );
      } catch (profileError) {
        console.error('Error creating nutritionist profile:', profileError);
        // Don't throw error here to avoid breaking the signup process
      }
    }
  } catch (error) {
    console.error('Error adding user to group:', error);
    throw error;
  }

  // Return the event to continue the signup process
  return event;
};
