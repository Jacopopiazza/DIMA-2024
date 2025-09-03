// Simplified meal-generation-update-status-handler/index.ts

import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, UpdateCommand } from '@aws-sdk/lib-dynamodb';
import { DailyPlanData, PlanStatus } from '../graphql-types';

const ddbClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(ddbClient);
const { TABLE_NAME } = process.env;

interface UpdateStatusEvent {
  userId: string;
  mealPlanId: string;
  status: 'GENERATED' | 'FAILED';
  dailyPlan?: DailyPlanData;
  error?: string;
}

export const handler = async (event: UpdateStatusEvent) => {
  if (!TABLE_NAME) {
    throw new Error('TABLE_NAME environment variable is not set.');
  }

  const { userId, mealPlanId, status, dailyPlan, error } = event;
  console.log(`Updating status for mealPlanId ${mealPlanId} to ${status}`);

  // Build update expression dynamically
  const updateExpressionParts = [
    '#status = :status',
    '#updatedAt = :updatedAt',
  ];
  const expressionAttributeNames: Record<string, string> = {
    '#status': 'status',
    '#updatedAt': 'updatedAt',
  };
  const expressionAttributeValues: Record<string, unknown> = {
    ':status': status,
    ':updatedAt': new Date().toISOString(),
  };

  // Add daily plan for successful generation
  if (status === 'GENERATED' && dailyPlan) {
    updateExpressionParts.push('#dailyPlan = :dailyPlan');
    expressionAttributeNames['#dailyPlan'] = 'dailyPlan';
    expressionAttributeValues[':dailyPlan'] = dailyPlan;

    updateExpressionParts.push('#generatedAt = :generatedAt');
    expressionAttributeNames['#generatedAt'] = 'generatedAt';
    expressionAttributeValues[':generatedAt'] = new Date().toISOString();
  }

  // Add error details for failures
  if (status === 'FAILED' && error) {
    updateExpressionParts.push('#errorDetails = :errorDetails');
    expressionAttributeNames['#errorDetails'] = 'errorDetails';
    expressionAttributeValues[':errorDetails'] = error;
  }

  const command = new UpdateCommand({
    TableName: TABLE_NAME,
    Key: {
      PK: `USER#${userId}`,
      SK: `PLAN#${mealPlanId}`,
    },
    UpdateExpression: `SET ${updateExpressionParts.join(', ')}`,
    ExpressionAttributeNames: expressionAttributeNames,
    ExpressionAttributeValues: expressionAttributeValues,
  });

  try {
    await docClient.send(command);
    console.log(
      `Successfully updated meal plan ${mealPlanId} status to ${status}`,
    );

    // Return simple response - the Step Function doesn't need complex data here
    return {
      success: true,
      mealPlanId,
      userId,
      status,
      updatedAt: new Date().toISOString(),
    };
  } catch (dbError) {
    console.error('Failed to update DynamoDB:', dbError);
    throw new Error(`Failed to update meal plan status: ${dbError}`);
  }
};
