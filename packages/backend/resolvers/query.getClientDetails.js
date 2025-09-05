// Get Client Details

// This resolver fetches the details of a client (user) based on the provided userId.
// It is intended to be used by nutritionists to view their clients' information.
import { util } from '@aws-appsync/utils';

export function request(ctx) {
  // Validate identity
  if (!ctx.identity?.sub) {
    util.unauthorized();
  }

  // Validate and sanitize userId
  const { userId } = ctx.args;
  if (!userId || typeof userId !== 'string' || userId.trim().length === 0) {
    util.error('Valid userId argument is required');
  }

  // Add authorization logic here

  return {
    operation: 'GetItem',
    key: {
      PK: { S: `USER#${userId}` },
      SK: { S: `USER_DETAILS` },
    },
  };
}
/*

type UserDetails @model {
  # Attributes stored in DynamoDB UserDetails item
  userId: ID! @primaryKey
  # Typically the Cognito Sub
  weightKg: Float!
  heightCm: Float!
  exerciseFrequency: ExerciseFrequency!
  dailyMealsPreference: Int!
  allergies: [AllergenEnum!]
  dietaryRestrictions: String
  openTextPreferences: String
  activeMealPlanId: ID
  # ID of the currently active MealPlan
  updatedAt: AWSDateTime
  # Timestamp of the last update for this record
  createdAt: AWSDateTime
}

*/

export function response(ctx) {
  // Handle DynamoDB errors first
  if (ctx.error) {
    util.error(ctx.error.message, ctx.error.type);
  }

  // Check if result exists and has data
  if (!ctx.result) {
    return null; // Return null for not found (GraphQL standard)
  }

  const item = ctx.result;

  // Extract and validate userId from PK
  const userId = item.PK?.startsWith('USER#') ? item.PK.substring(5) : null;
  if (!userId) {
    util.error('Invalid user data structure', 'DATA_ERROR');
  }

  // Validate required fields based on schema
  if (typeof item.weightKg !== 'number' || item.weightKg <= 0) {
    util.error('Invalid weight data', 'DATA_ERROR');
  }

  if (typeof item.heightCm !== 'number' || item.heightCm <= 0) {
    util.error('Invalid height data', 'DATA_ERROR');
  }

  if (!item.exerciseFrequency) {
    util.error('Missing exercise frequency data', 'DATA_ERROR');
  }

  if (
    typeof item.dailyMealsPreference !== 'number' ||
    item.dailyMealsPreference <= 0
  ) {
    util.error('Invalid daily meals preference', 'DATA_ERROR');
  }

  // Return mapped response with proper null handling
  return {
    userId,
    weightKg: item.weightKg,
    heightCm: item.heightCm,
    exerciseFrequency: item.exerciseFrequency,
    dailyMealsPreference: item.dailyMealsPreference,
    allergies: item.allergies || [],
    dietaryRestrictions: item.dietaryRestrictions || null,
    openTextPreferences: item.openTextPreferences || null,
    activeMealPlanId: item.activeMealPlanId || null,
    updatedAt: item.updatedAt || null,
    createdAt: item.createdAt || null,
  };
}
