import * as cdk from 'aws-cdk-lib';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import { Construct } from 'constructs';

interface DataStackProps extends cdk.StackProps {
  userPool: cognito.UserPool;
}

export class DataStack extends cdk.Stack {
  public readonly mealPlanningTable: dynamodb.TableV2;

  constructor(scope: Construct, id: string, props: DataStackProps) {
    super(scope, id, props);

    const mealPlanningTableProps: dynamodb.TablePropsV2 = {
      billing: dynamodb.Billing.onDemand(),
      partitionKey: { name: 'PK', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'SK', type: dynamodb.AttributeType.STRING },
      removalPolicy: cdk.RemovalPolicy.DESTROY, // TODO: Change to RETAIN for prod
      pointInTimeRecoverySpecification: {
        pointInTimeRecoveryEnabled: false,
      },
      encryption: dynamodb.TableEncryptionV2.awsManagedKey(),
      tableName: 'MealPlanningTable',
    };

    this.mealPlanningTable = new dynamodb.TableV2(
      this,
      'MealPlanningTable',
      mealPlanningTableProps,
    );

    // GSI1 - For listing nutritionists
    // NutritionistProfile items will use: GSI1PK = "NUTR" and GSI1SK = "NAME#{NutritionistName}"
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI1',
      partitionKey: { name: 'GSI1PK', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'GSI1SK', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.INCLUDE, // Include only necessary attributes
      nonKeyAttributes: [
        'NutritionistID', // Crucial to identify the nutritionist
        'GivenName',
        'FamilyName',
        'Specialization',
        'ProfilePictureURL',
        'IsAvailable',
        'Bio', // Optional: include if you show a short bio in the list
      ],
    });

    // GSI2 - For retrieving chats by nutritionist
    // Chat items will use: GSI2PK = `NUTR#{NutritionistID}` and GSI2SK = `CHAT#{UserID}#{MealPlanID}`
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI2',
      partitionKey: { name: 'GSI2PK', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'GSI2SK', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.KEYS_ONLY, // Optimized for listing chat IDs
    });

    // Export the table name for cross-stack references
    new cdk.CfnOutput(this, 'MealPlanningTableId', {
      value: this.mealPlanningTable.tableName,
      exportName: 'MealPlanningTable',
    });
  }
}
