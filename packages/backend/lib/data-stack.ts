import * as cdk from 'aws-cdk-lib';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as s3 from 'aws-cdk-lib/aws-s3';
import { Construct } from 'constructs';

interface DataStackProps extends cdk.StackProps {
  userPool: cognito.UserPool;
  authenticatedRole?: iam.Role;
}

export class DataStack extends cdk.Stack {
  public readonly mealPlanningTable: dynamodb.TableV2;
  public readonly setActiveMealPlanLambda: lambda.Function;
  public readonly assetsBucket: s3.Bucket;

  constructor(scope: Construct, id: string, props: DataStackProps) {
    super(scope, id, props);

    // Create S3 bucket for assets (images, documents, etc.)
    this.assetsBucket = new s3.Bucket(this, 'AssetsBucket', {
      bucketName: `dima-assets-${this.account}-${this.region}`,
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY, // TODO: Change to RETAIN for prod
      cors: [
        {
          allowedMethods: [
            s3.HttpMethods.GET,
            s3.HttpMethods.PUT,
            s3.HttpMethods.POST,
            s3.HttpMethods.DELETE,
          ],
          allowedOrigins: ['*'], // TODO: Restrict to your app domains in production
          allowedHeaders: ['*'],
          maxAge: 3000,
        },
      ],
    });

    // Create IAM policy for authenticated users to upload assets
    const s3Policy = new iam.PolicyStatement({
      effect: iam.Effect.ALLOW,
      actions: [
        's3:PutObject',
        's3:PutObjectAcl',
        's3:GetObject',
        's3:DeleteObject',
        's3:ListBucket',
      ],
      resources: [
        this.assetsBucket.bucketArn,
        `${this.assetsBucket.bucketArn}/*`,
      ],
    });

    // If authenticated role is provided, attach the S3 policy
    if (props.authenticatedRole) {
      props.authenticatedRole.addToPolicy(s3Policy);
    }

    // Export the bucket name for cross-stack references
    new cdk.CfnOutput(this, 'AssetsBucketName', {
      value: this.assetsBucket.bucketName,
      exportName: 'AssetsBucketName',
    });

    new cdk.CfnOutput(this, 'AssetsBucketRegion', {
      value: this.region,
      exportName: 'AssetsBucketRegion',
    });

    new cdk.CfnOutput(this, 'AssetsBucketArn', {
      value: this.assetsBucket.bucketArn,
      exportName: 'AssetsBucketArn',
    });

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

    // GSI1 - For listing nutritionists (listNutritionists query)
    // NutritionistProfile items will have:
    // GSI1PK = "NUTR_PROFILES_ALL" (constant value to gather all profiles)
    // GSI1SK = "NAME#{FamilyName}#{GivenName}" OR "NUTRID#{NutritionistID}" (for sorting)
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI1_NutritionistListings',
      partitionKey: { name: 'GSI1PK', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'GSI1SK', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.INCLUDE,
      nonKeyAttributes: [
        // Attributes from NutritionistProfile type needed for the list
        'NutritionistID', // This is the ID from the main PK (e.g., value of NUTR#<id>)
        'GivenName',
        'FamilyName',
        'Specialization',
        'ProfilePictureURL',
        'IsAvailable',
        'Bio',
      ],
    });

    // GSI2 - For retrieving a Nutritionist's chats, sorted by recency (listMyAssignedChats query)
    // ChatMetadata items will have:
    // nutritionistId = "NUTR#{NutritionistID}"
    // lastMessageTimestamp = "LMT#{LastMessageTimestampISO}" (LMT for Last Message Timestamp)
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI2_NutritionistChatsByRecency',
      partitionKey: {
        name: 'nutritionistId',
        type: dynamodb.AttributeType.STRING,
      },
      sortKey: {
        name: 'lastMessageTimestamp',
        type: dynamodb.AttributeType.STRING,
      },
      projectionType: dynamodb.ProjectionType.ALL,
    });

    // GSI3 - For retrieving a User's chats, sorted by recency (listMyChats query)
    // ChatMetadata items will have:
    // userId = "USER#{UserID}"
    // lastMessageTimestamp = "LMT#{LastMessageTimestampISO}"
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI3_UserChatsByRecency',
      partitionKey: { name: 'userId', type: dynamodb.AttributeType.STRING },
      sortKey: {
        name: 'lastMessageTimestamp',
        type: dynamodb.AttributeType.STRING,
      },
      projectionType: dynamodb.ProjectionType.ALL,
    });

    // GSI4 - For retrieving meal plans assigned to a nutritionist (listMyAssignedMealPlans query)
    // MealPlan items will have:
    // assignedNutritionistId = "NUTR#{NutritionistID}"
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI4_AssignedNutritionistId',
      partitionKey: {
        name: 'assignedNutritionistId',
        type: dynamodb.AttributeType.STRING,
      },
      sortKey: { name: 'updatedAt', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.ALL,
    });

    // GSI5_MealPlanId - For retrieving meal plans by mealPlanId
    // MealPlan items will have:
    // mealPlanId = <mealPlanId>
    // entityType = "MEAL_PLAN"
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI5_MealPlanId',
      partitionKey: { name: 'mealPlanId', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'entityType', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.ALL,
    });

    // GSI6 - For retrieving a User's PlanDayCompletion records, sorted by date across plans (listPlanCompletions query or general history)
    // PlanDayCompletion items will have:
    // GSI6PK = "USER#{UserID}"
    // GSI6SK = "DATE#{Date}_PLAN#{PlanID}" (Date as YYYY-MM-DD)
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI6_UserCompletions',
      partitionKey: { name: 'GSI6PK', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'GSI6SK', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.ALL,
    });

    // ============================================
    // GSI7 - For Chat to MealPlan lookup (optional but useful)
    // Allows finding a chat by mealPlanId
    // ============================================
    this.mealPlanningTable.addGlobalSecondaryIndex({
      indexName: 'GSI7_MealPlanChat',
      partitionKey: { name: 'mealPlanId', type: dynamodb.AttributeType.STRING },
      sortKey: { name: 'entityType', type: dynamodb.AttributeType.STRING },
      projectionType: dynamodb.ProjectionType.ALL,
    });

    // Export the table name for cross-stack references
    new cdk.CfnOutput(this, 'MealPlanningTableId', {
      value: this.mealPlanningTable.tableName,
      exportName: 'MealPlanningTable',
    });

    // Export the table name for cross-stack references
    new cdk.CfnOutput(this, 'MealPlanningTableName', {
      value: this.mealPlanningTable.tableName,
      exportName: 'MealPlanningTableName',
    });
  }
}
