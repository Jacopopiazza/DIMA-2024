import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  GetCommand,
  QueryCommand,
  TransactWriteCommand,
} from '@aws-sdk/lib-dynamodb';

// Types
interface MealPlanEvent {
  identity?: {
    sub: string;
  };
  arguments?: {
    planId?: string;
    mealPlanId?: string;
  };
}

interface MealPlan {
  PK: string;
  SK: string;
  status: 'ACTIVE' | 'GENERATED' | 'INACTIVE';
  [key: string]: any;
}

interface LambdaResponse {
  success: boolean;
  message: string;
  mealPlanId?: string;
}

// Initialize DynamoDB client
const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const TABLE_NAME = process.env.TABLE_NAME || 'MealPlanningTable';

export const handler = async (
  event: MealPlanEvent,
): Promise<LambdaResponse> => {
  console.log('Full event received:', JSON.stringify(event, null, 2));

  const userId = event.identity?.sub;
  const planId = event.arguments?.planId || event.arguments?.mealPlanId;

  console.log('Extracted userId:', userId);
  console.log('Extracted planId:', planId);

  if (!userId || !planId) {
    return {
      success: false,
      message: 'Missing required parameters: userId or planId',
      mealPlanId: planId,
    };
  }

  console.log('Setting active meal plan:', { userId, planId });

  // 0. Check if the plan is already active
  const checkCurrentPlanCommand = new GetCommand({
    TableName: TABLE_NAME,
    Key: {
      PK: `USER#${userId}`,
      SK: `PLAN#${planId}`,
    },
  });

  try {
    const currentPlan = await ddb.send(checkCurrentPlanCommand);
    console.log(
      'Current plan from DB:',
      JSON.stringify(currentPlan.Item, null, 2),
    );

    if (
      currentPlan.Item &&
      (currentPlan.Item as MealPlan).status === 'ACTIVE'
    ) {
      console.log('Plan is already active, no changes needed');
      return {
        success: true,
        message: `Plan is already active. ${(currentPlan.Item as MealPlan).status}`,
        mealPlanId: planId,
      };
    } else if (!currentPlan.Item) {
      console.log('Plan does not exist in database');
      return {
        success: false,
        message: 'Plan not found in database.',
        mealPlanId: planId,
      };
    }
  } catch (err) {
    console.error('Error checking current plan status:', err);
    return {
      success: false,
      message: 'Error checking current plan status',
      mealPlanId: planId,
    };
  }

  // 1. Find the current active plan for the user
  const queryCommand = new QueryCommand({
    TableName: TABLE_NAME,
    KeyConditionExpression: 'PK = :pk AND begins_with(SK, :skPrefix)',
    FilterExpression: '#status = :active',
    ExpressionAttributeNames: { '#status': 'status' },
    ExpressionAttributeValues: {
      ':pk': `USER#${userId}`,
      ':skPrefix': 'PLAN#',
      ':active': 'ACTIVE',
    },
  });

  let previousActivePlan: MealPlan | null = null;
  try {
    const result = await ddb.send(queryCommand);
    if (result.Items && result.Items.length > 0) {
      previousActivePlan = result.Items[0] as MealPlan;
      console.log('Found previous active plan:', previousActivePlan.SK);
    }
  } catch (err) {
    console.error('Error querying active plan:', err);
    return {
      success: false,
      message: 'Error querying active plan',
      mealPlanId: planId,
    };
  }

  // 2. Prepare transaction items
  const transactItems: any[] = [];

  // Unset previous active plan if it exists and it's different from the new plan
  if (previousActivePlan && previousActivePlan.SK !== `PLAN#${planId}`) {
    transactItems.push({
      Update: {
        TableName: TABLE_NAME,
        Key: {
          PK: previousActivePlan.PK,
          SK: previousActivePlan.SK,
        },
        UpdateExpression: 'SET #status = :inactive',
        ExpressionAttributeNames: { '#status': 'status' },
        ExpressionAttributeValues: { ':inactive': 'GENERATED' },
      },
    });
  }

  // Set new plan as active
  transactItems.push({
    Update: {
      TableName: TABLE_NAME,
      Key: {
        PK: `USER#${userId}`,
        SK: `PLAN#${planId}`,
      },
      UpdateExpression: 'SET #status = :active',
      ExpressionAttributeNames: { '#status': 'status' },
      ExpressionAttributeValues: { ':active': 'ACTIVE' },
    },
  });

  console.log('Transact items:', JSON.stringify(transactItems, null, 2));

  // 3. Execute transaction
  const transactCommand = new TransactWriteCommand({
    TransactItems: transactItems,
  });

  try {
    await ddb.send(transactCommand);
    console.log('Transaction completed successfully');
    return {
      success: true,
      message: 'Active plan updated successfully.',
      mealPlanId: planId,
    };
  } catch (err) {
    console.error('Transaction failed:', err);
    const error = err as Error;
    return {
      success: false,
      message: `Transaction failed: ${error.message}`,
      mealPlanId: planId,
    };
  }
};
