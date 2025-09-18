import {
  PlanRequestPreferencesInput,
  ExerciseFrequency,
  PlanRequestPreferences,
  UserDetails,
} from '../graphql-types';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  QueryCommand,
  QueryCommandOutput,
  UpdateCommand,
} from '@aws-sdk/lib-dynamodb';

const { TABLE_NAME } = process.env;

// Initialize the DynamoDB client
const dynamoDbClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(dynamoDbClient);

interface CognitoDetails {
  cognitoBirthdate?: string;
  cognitoGender?: string;
}

interface ValidatorEvent {
  preferences: PlanRequestPreferencesInput;
  cognitoBirthdate?: string;
  cognitoGender?: string;
  // Other potential fields from the SFN execution
  userId: string;
  mealPlanId: string;
}

function buildUserPreferencesForGenerator(
  userDetails: UserDetails,
  preferences: PlanRequestPreferencesInput,
  cognitoDetails: CognitoDetails,
): PlanRequestPreferences {
  // Prepare the preferences object for the generator

  const dateOfBirth = cognitoDetails.cognitoBirthdate!;
  const gender = cognitoDetails.cognitoGender!;

  const userPreferences: PlanRequestPreferences = {
    allergies: preferences.allergies || userDetails.allergies || [],
    dailyMealsPreference:
      preferences.dailyMealsPreference || userDetails.dailyMealsPreference || 3,
    dietaryRestrictions:
      preferences.dietaryRestrictions || userDetails.dietaryRestrictions,
    exerciseFrequency:
      preferences.exerciseFrequency ||
      userDetails.exerciseFrequency ||
      ExerciseFrequency.NOT_SPECIFIED,
    heightCm: preferences.heightCm || userDetails.heightCm,
    weightKg: preferences.weightKg || userDetails.weightKg,
    openTextPreferences:
      preferences.openTextPreferences || userDetails.openTextPreferences || '',
    dateOfBirth: dateOfBirth,
    gender: gender,
    language: preferences.language || 'en',
  };

  return userPreferences;
}

/**
 * Validates the user preferences object. Throws an error if invalid.
 */
function validateUserPreferences(prefs: PlanRequestPreferences): void {
  if (!prefs) {
    throw new Error('User preferences are required.');
  }
  if (!prefs.heightCm || prefs.heightCm < 50 || prefs.heightCm > 250) {
    throw new Error('Height must be provided and be between 50 and 250 cm.');
  }
  if (!prefs.weightKg || prefs.weightKg < 30 || prefs.weightKg > 300) {
    throw new Error('Weight must be provided and be between 30 and 300 kg.');
  }
  if (
    prefs.dailyMealsPreference &&
    (prefs.dailyMealsPreference < 1 || prefs.dailyMealsPreference > 6)
  ) {
    throw new Error('Daily meals preference must be between 1 and 6.');
  }
  if (
    !prefs.exerciseFrequency ||
    !Object.values(ExerciseFrequency).includes(prefs.exerciseFrequency)
  ) {
    throw new Error(
      `Exercise frequency must be one of: ${Object.values(ExerciseFrequency).join(', ')}`,
    );
  }
}

/**
 * Validates that Cognito details are present and valid.
 */
function validateCognitoDetails(cognitoDetails?: CognitoDetails): void {
  if (!cognitoDetails) {
    throw new Error('Cognito user details are required but not provided.');
  }

  if (!cognitoDetails.cognitoBirthdate) {
    throw new Error(
      'User birthdate is required but not found in Cognito profile.',
    );
  }

  if (!cognitoDetails.cognitoGender) {
    throw new Error(
      'User gender is required but not found in Cognito profile.',
    );
  }

  // Validate birthdate format (should be YYYY-MM-DD)
  const birthdateRegex = /^\d{4}-\d{2}-\d{2}$/;
  if (!birthdateRegex.test(cognitoDetails.cognitoBirthdate)) {
    throw new Error(
      'Invalid birthdate format in Cognito profile. Expected YYYY-MM-DD.',
    );
  }

  // Validate that birthdate is not in the future and user is at least 13 years old
  const birthDate = new Date(cognitoDetails.cognitoBirthdate);
  const today = new Date();
  const minAge = 13;
  const minBirthDate = new Date(
    today.getFullYear() - minAge,
    today.getMonth(),
    today.getDate(),
  );

  if (birthDate > today) {
    throw new Error('Birthdate cannot be in the future.');
  }

  if (birthDate > minBirthDate) {
    throw new Error('User must be at least 13 years old to use this service.');
  }

  // Validate gender (basic validation - could be extended)
  const validGenders = ['male', 'female', 'other', 'prefer_not_to_say'];
  if (!validGenders.includes(cognitoDetails.cognitoGender.toLowerCase())) {
    throw new Error(
      `Invalid gender value: ${cognitoDetails.cognitoGender}. Must be one of: ${validGenders.join(', ')}`,
    );
  }
}

async function getUserDetails(userId: string): Promise<UserDetails> {
  const keyConditionExpression = `#pk = :pk AND #sk = :sk`;
  const expressionAttributeNames = {
    '#pk': 'PK',
    '#sk': 'SK',
  };
  const expressionAttributeValues = {
    ':pk': `USER#${userId}`,
    ':sk': 'USER_DETAILS',
  };

  try {
    const command = new QueryCommand({
      TableName: TABLE_NAME,
      KeyConditionExpression: keyConditionExpression,
      ExpressionAttributeNames: expressionAttributeNames,
      ExpressionAttributeValues: expressionAttributeValues,
    });

    console.log('Querying DynamoDB for user details:', {
      TableName: TABLE_NAME,
      KeyConditionExpression: keyConditionExpression,
      ExpressionAttributeNames: expressionAttributeNames,
      ExpressionAttributeValues: expressionAttributeValues,
    });

    const response: QueryCommandOutput = await docClient.send(command);

    if (!response.Items) {
      throw new Error(`User details not found for userId: ${userId}`);
    }

    console.log(
      'User details fetched successfully:',
      JSON.stringify(response.Items),
    );

    if (response.Items.length === 0) {
      // return an empty object if no user details are found
      console.warn(`No user details found for userId: ${userId}`);
      return {} as UserDetails; // Return an empty object if no user details are found, those will be provided by the frontend
    }

    return response.Items[0] as UserDetails;
  } catch (error) {
    console.error('Error fetching user details:', error);
    throw new Error('Failed to fetch user details.');
  }
}

export const handler = async (event: ValidatorEvent) => {
  if (!TABLE_NAME) {
    throw new Error('TABLE_NAME environment variable not set.');
  }

  console.log(
    'Validating preferences and Cognito details:',
    JSON.stringify(event),
  );

  try {
    // Validate Cognito details
    const cognitoDetails = {
      cognitoBirthdate: event.cognitoBirthdate,
      cognitoGender: event.cognitoGender,
    } as CognitoDetails;
    validateCognitoDetails(cognitoDetails);
    console.log('Cognito details validation successful.');

    console.log(
      'Fetching user details from DynamoDB for userId:',
      event.userId,
    );
    const userDetails = await getUserDetails(event.userId);
    console.log(
      'User details fetched successfully:',
      JSON.stringify(userDetails),
    );

    console.log('Building user preferences for generator...');
    const userPreferences = buildUserPreferencesForGenerator(
      userDetails,
      event.preferences,
      cognitoDetails,
    );
    console.log(
      'User preferences built successfully:',
      JSON.stringify(userPreferences),
    );

    // Validate user preferences
    console.log('Validating user preferences...');
    validateUserPreferences(userPreferences);
    console.log('User preferences validation successful.');

    // Return the complete event data for the next step
    // This ensures cognitoDetails gets passed to the generator
    return {
      userId: event.userId,
      mealPlanId: event.mealPlanId,
      preferences: userPreferences,
    };
  } catch (error) {
    console.error('Validation failed:', error);
    // Throw the error to be caught by the Step Function's "Catch" block
    throw error;
  }
};
