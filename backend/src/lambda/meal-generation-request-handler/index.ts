/**
 * ===================================================================
 * Lambda: request_handler.ts (Now starts a Step Function)
 * ===================================================================
 * This Lambda is the synchronous entry point for the 'requestNewMealPlan' mutation.
 * It creates a 'PENDING' record and starts the Step Function workflow.
 *
 * Required Environment Variables:
 * - MEALPLANS_TABLE_NAME: The name of your DynamoDB table.
 * - STATE_MACHINE_ARN: The ARN of the Step Function state machine.
 *
 * Required `package.json` dependencies:
 * "dependencies": {
 * "@aws-sdk/client-dynamodb": "^3.525.0",
 * "@aws-sdk/lib-dynamodb": "^3.525.0",
 * "@aws-sdk/client-sfn": "^3.525.0" // CHANGED
 * },
 * ...
 * ===================================================================
 */
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb';
// CHANGED: Import the SFN client instead of the Lambda client.
import { SFNClient, StartExecutionCommand } from '@aws-sdk/client-sfn';
import { AppSyncResolverEvent, AppSyncIdentityCognito } from 'aws-lambda';
import { randomUUID } from 'crypto';
import {
  PlanRequestPreferencesInput,
  PlanStatus,
  MealPlanValidationStatus,
  MealPlanResponse,
} from '../graphql-types';
import crypto from 'crypto';
import { StepFunctionInput } from '../../types/StepFunctionInput';
// Initialize AWS clients
const ddbClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(ddbClient);
// CHANGED: Initialize the SFNClient.
const sfnClient = new SFNClient({});

// Get environment variables
// CHANGED: Use STATE_MACHINE_ARN.
const { MEALPLANS_TABLE_NAME, STATE_MACHINE_ARN } = process.env;

interface RequestNewMealPlanArgs {
  prefsOverride: PlanRequestPreferencesInput;
}

function isCognitoIdentity(identity: any): identity is AppSyncIdentityCognito {
  return identity && typeof identity.sub === 'string';
}

export const handler = async (
  event: AppSyncResolverEvent<RequestNewMealPlanArgs>,
): Promise<MealPlanResponse> => {
  console.log('Received event:', JSON.stringify(event));

  // CHANGED: Check for STATE_MACHINE_ARN.
  if (!MEALPLANS_TABLE_NAME || !STATE_MACHINE_ARN) {
    throw new Error(
      'Configuration error: Environment variables MEALPLANS_TABLE_NAME and STATE_MACHINE_ARN must be set.',
    );
  }

  if (!isCognitoIdentity(event.identity)) {
    throw new Error(
      'Authorization error: Not a valid Cognito User Pool identity.',
    );
  }
  const userId = event.identity.sub;
  const prefsOverride = event.arguments.prefsOverride;

  // --- This part remains the same: Create the PENDING record ---
  const mealPlanId = randomUUID();
  const mealPlanItem = {
    PK: `USER#${userId}`,
    SK: `PLAN#${mealPlanId}`,
    entityType: 'MEAL_PLAN',
    mealPlanId,
    userId,
    status: PlanStatus.PENDING,
    validationStatus: MealPlanValidationStatus.NOT_VALIDATED,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    planName: `New Meal Plan - ${new Date().toLocaleDateString('en-CA')}`,
  };

  const putCommand = new PutCommand({
    TableName: MEALPLANS_TABLE_NAME,
    Item: mealPlanItem,
  });
  try {
    await docClient.send(putCommand);
    console.log('Successfully created PENDING item in DynamoDB.');
  } catch (error) {
    console.error('ERROR: Could not write to DynamoDB:', error);
    throw new Error(
      'Internal server error: Could not create meal plan record.',
    );
  }

  // --- REPLACED: Start a Step Function execution instead of invoking a Lambda ---
  const invocationPayload: StepFunctionInput = {
    mealPlanId,
    userId,
    preferences: prefsOverride,
  };

  const executionIdentifier = `gen-${userId}-${mealPlanId}-${Date.now()}`;

  const hash = crypto
    .createHash('md5')
    .update(executionIdentifier)
    .digest('hex');
  const executionName = `gen-${hash}`;

  console.log(
    `Starting Step Function execution with id '${executionName}' for '${STATE_MACHINE_ARN}' with payload:`,
    JSON.stringify(invocationPayload),
  );

  const command = new StartExecutionCommand({
    stateMachineArn: STATE_MACHINE_ARN,
    // The 'input' property is used for Step Functions.
    input: JSON.stringify(invocationPayload),
    // Providing a unique name helps prevent duplicate executions if the request is retried.
    name: executionName,
  });

  try {
    await sfnClient.send(command);
    console.log('Successfully started Step Function execution.');
  } catch (error) {
    console.error('ERROR: Could not start Step Function execution:', error);
    throw new Error(
      'Internal server error: Could not start meal plan generation.',
    );
  }

  // --- This part remains the same: Return an immediate response ---
  const response: MealPlanResponse = {
    success: true,
    message: 'Meal plan creation request successfully.',
    mealPlanId,
  };

  return response;
};
