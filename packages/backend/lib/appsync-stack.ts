import * as cdk from 'aws-cdk-lib';
import * as appsync from 'aws-cdk-lib/aws-appsync';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { NodejsFunction, OutputFormat } from 'aws-cdk-lib/aws-lambda-nodejs';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';
import * as sns from 'aws-cdk-lib/aws-sns';
import * as snsSubscriptions from 'aws-cdk-lib/aws-sns-subscriptions';
import * as sqs from 'aws-cdk-lib/aws-sqs';
import * as sfn from 'aws-cdk-lib/aws-stepfunctions';
import * as sfn_tasks from 'aws-cdk-lib/aws-stepfunctions-tasks';
import { MessageAttributeDataType } from 'aws-cdk-lib/aws-stepfunctions-tasks';
import { Construct } from 'constructs';
import { ChatStack } from './chat-stack';

interface AppSyncApiStackProps extends cdk.StackProps {
  userPool: cognito.UserPool;
  mealPlanningTable: dynamodb.ITableV2;
}

export class AppSyncApiStack extends cdk.Stack {
  public readonly graphqlUrl: string;
  public readonly apiId: string;

  constructor(scope: Construct, id: string, props: AppSyncApiStackProps) {
    super(scope, id, props);

    // Create the AppSync API using your comprehensive GraphQL schema
    const api = new appsync.GraphqlApi(this, 'MealPlanningApi', {
      name: 'MealPlanningApi',
      definition: appsync.Definition.fromFile('graphql/schema.graphql'),
      authorizationConfig: {
        defaultAuthorization: {
          authorizationType: appsync.AuthorizationType.USER_POOL,
          userPoolConfig: {
            userPool: props.userPool,
          },
        },
        // IMPORTANT: Add IAM as an additional authorization mode
        additionalAuthorizationModes: [
          {
            authorizationType: appsync.AuthorizationType.IAM,
          },
        ],
      },
      logConfig: {
        fieldLogLevel: appsync.FieldLogLevel.ALL,
        retention: logs.RetentionDays.ONE_WEEK,
        excludeVerboseContent: false,
      },
      xrayEnabled: true,
    });

    // Add DynamoDB table as a data source
    const tableDS = api.addDynamoDbDataSource(
      'MealPlanningDynamoDataSource',
      props.mealPlanningTable,
    );

    // --------------------------------------------------------------------
    // RESOLVERS FOR USER DETAILS (FORMERLY PREFERENCES)
    // --------------------------------------------------------------------

    // Resolver for Query.getUserDetails
    tableDS.createResolver('QueryGetUserDetailsResolver', {
      typeName: 'Query',
      fieldName: 'getUserDetails',
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/getUserDetails-request.vtl',
      ),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/getUserDetails-response.vtl',
      ),
    });

    // ====================================================================
    //         PIPELINE RESOLVER for Query.getTodaysPlanAndStatus
    // ====================================================================

    // --- Pipeline Function 1: Get UserDetails (to find active plan ID) ---
    const getUserDetailsFunc = new appsync.AppsyncFunction(
      this,
      'GetUserDetailsFunc',
      {
        name: 'getUserDetailsFunc',
        api: api,
        dataSource: tableDS,
        requestMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.getTodaysPlanAndStatus.func1-getUserDetails-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.getTodaysPlanAndStatus.func1-getUserDetails-response.vtl',
        ),
      },
    );

    // --- Pipeline Function 2: Get Active MealPlan ---
    const getActiveMealPlanFunc = new appsync.AppsyncFunction(
      this,
      'GetActiveMealPlanFunc',
      {
        name: 'getActiveMealPlanFunc',
        api: api,
        dataSource: tableDS,
        requestMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.getTodaysPlanAndStatus.func2-getMealPlan-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.getTodaysPlanAndStatus.func2-getMealPlan-response.vtl',
        ),
      },
    );

    // --- Pipeline Function 3: Get Today's Completed Meal Log ---
    const getCompletedLogFunc = new appsync.AppsyncFunction(
      this,
      'GetCompletedLogFunc',
      {
        name: 'getCompletedLogFunc',
        api: api,
        dataSource: tableDS,
        requestMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.getTodaysPlanAndStatus.func3-getCompletedLog-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.getTodaysPlanAndStatus.func3-getCompletedLog-response.vtl',
        ),
      },
    );

    // --- Pipeline Resolver Definition ---
    new appsync.Resolver(this, 'PipelineGetTodaysPlanAndStatusResolver', {
      api: api,
      typeName: 'Query',
      fieldName: 'getTodaysPlanAndStatus',
      // Define the sequence of functions
      pipelineConfig: [
        getUserDetailsFunc,
        getActiveMealPlanFunc,
        getCompletedLogFunc,
      ],
      // Request mapping template for the pipeline resolver itself (usually simple)
      requestMappingTemplate: appsync.MappingTemplate.fromString('{}'),
      // Response mapping template - combines results from the functions
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/pipeline.getTodaysPlanAndStatus-response.vtl',
      ),
    });

    // ====================================================================
    //         PIPELINE RESOLVER for Query.getActiveMealPlan
    // ====================================================================
    new appsync.Resolver(this, 'PipelineGetActiveMealPlanResolver', {
      api: api,
      typeName: 'Query',
      fieldName: 'getActiveMealPlan',
      pipelineConfig: [getUserDetailsFunc, getActiveMealPlanFunc],
      requestMappingTemplate: appsync.MappingTemplate.fromString('{}'),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/pipeline.getActiveMealPlan-response.vtl',
      ),
    });

    // ====================================================================
    //                      PIPELINE RESOLVER UpdateMyUserDetails
    // ====================================================================
    const updateUserDetailsFunction = new appsync.AppsyncFunction(
      this,
      'UpdateUserDetailsFunctionForUserDetails',
      {
        api,
        name: 'UpdateUserDetailsFunctionForUserDetails',
        dataSource: tableDS,
        runtime: appsync.FunctionRuntime.JS_1_0_0,
        code: appsync.Code.fromAsset(
          'resolvers/pipeline.updateUserDetails.UpdateUserDetails.js',
        ),
      },
    );

    const getUserDetailsFunction = new appsync.AppsyncFunction(
      this,
      'GetUserDetailsFunctionForUserDetails',
      {
        api,
        name: 'GetUserDetailsFunction',
        dataSource: tableDS,
        requestMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/getUserDetails-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/getUserDetails-response.vtl',
        ),
      },
    );

    const pipelineResolver = new appsync.Resolver(
      this,
      'MutationUpdateUserDetailsResolver',
      {
        api,
        typeName: 'Mutation',
        fieldName: 'updateUserDetails',
        pipelineConfig: [updateUserDetailsFunction, getUserDetailsFunction],
        requestMappingTemplate:
          appsync.MappingTemplate.fromString('$util.toJson({})'), // <-- ADD THIS
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'templates/pipeline.updateUserDetails-response.vtl',
        ),
      },
    );

    // ====================================================================
    //                      MUTATION RESOLVERS
    // ====================================================================

    // --- Resolver for Mutation.setActiveMealPlan ---
    // --- Lambda Data Source for setActiveMealPlan ---
    const setActiveMealPlanLambda = new NodejsFunction(
      this,
      'SetActiveMealPlanLambda',
      {
        functionName: 'SetActiveMealPlanLambdaHandler',
        runtime: lambda.Runtime.NODEJS_22_X,
        handler: 'handler',
        entry: 'src/lambda/setActiveMealPlan/index.ts', // Adjust path as needed
        timeout: cdk.Duration.seconds(30),
        environment: {
          TABLE_NAME: props.mealPlanningTable.tableName,
        },
        bundling: {
          format: OutputFormat.ESM,
          bundleAwsSDK: false,
          minify: false, // Minify the code
          sourceMap: true, // Generate source maps
          externalModules: [
            '@aws-sdk/client-dynamodb',
            '@aws-sdk/lib-dynamodb',
          ],
        },
      },
    );

    props.mealPlanningTable.grantReadWriteData(setActiveMealPlanLambda);

    const setActiveMealPlanLambdaDS = api.addLambdaDataSource(
      'SetActiveMealPlanLambdaDS',
      setActiveMealPlanLambda,
    );

    setActiveMealPlanLambdaDS.createResolver(
      'MutationSetActiveMealPlanResolver',
      {
        typeName: 'Mutation',
        fieldName: 'setActiveMealPlan',
      },
    );

    tableDS.createResolver('MutationMarkMealAsCompletedResolver', {
      typeName: 'Mutation',
      fieldName: 'markMealAsCompleted',
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/mutation.markMealAsCompleted-request.vtl',
      ), // Ensure this file exists and has the Set logic
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/mutation.markMealAsCompleted-response.vtl',
      ),
    });

    // --- Add Resolver for Unmark Meal ---
    tableDS.createResolver('MutationUnmarkMealAsCompletedResolver', {
      // New Resolver definition
      typeName: 'Mutation',
      fieldName: 'unmarkMealAsCompleted', // New field name from updated schema
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/mutation.unmarkMealAsCompleted-request.vtl',
      ), // New VTL file
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'templates/mutation.unmarkMealAsCompleted-response.vtl',
      ), // New VTL file
    });

    // --- Resolver for Mutation.createMealPlan ---
    tableDS.createResolver('MutationCreateMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'createMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/mutation.createMealPlan.js'),
    });

    // --- Resolver for Mutation.deleteMealPlan ---
    tableDS.createResolver('MutationDeleteMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'deleteMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/mutation.deleteMealPlan.js'),
    });

    // --- Resolver for Mutation.modifyMealPlan ---
    tableDS.createResolver('MutationModifyMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'modifyMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/mutation.modifyMealPlan.js'),
    });

    // --- Resolver for Mutation.modifyAssignedMealPlan ---
    tableDS.createResolver('MutationModifyAssignedMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'modifyAssignedMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/mutation.modifyAssignedMealPlan.js',
      ),
    });

    // --- Pipeline Functions for validateMealPlan ---
    const getMealPlanKeysByMealPlanIdFunc = new appsync.AppsyncFunction(
      this,
      'GetMealPlanKeysByMealPlanIdFunc',
      {
        name: 'getMealPlanKeysByMealPlanIdFunc',
        api: api,
        dataSource: tableDS,
        runtime: appsync.FunctionRuntime.JS_1_0_0,
        code: appsync.Code.fromAsset(
          'resolvers/getMealPlanKeysByMealPlanId.js',
        ),
      },
    );

    const updateMealPlanValidationStatusFunc = new appsync.AppsyncFunction(
      this,
      'UpdateMealPlanValidationStatusFunc',
      {
        name: 'updateMealPlanValidationStatusFunc',
        api: api,
        dataSource: tableDS,
        runtime: appsync.FunctionRuntime.JS_1_0_0,
        code: appsync.Code.fromAsset(
          'resolvers/updateMealPlanValidationStatus.js',
        ),
      },
    );

    // --- Pipeline Resolver for Mutation.validateMealPlan ---
    new appsync.Resolver(this, 'PipelineValidateMealPlanResolver', {
      api: api,
      typeName: 'Mutation',
      fieldName: 'validateMealPlan',
      pipelineConfig: [
        getMealPlanKeysByMealPlanIdFunc,
        updateMealPlanValidationStatusFunc,
      ],
      requestMappingTemplate: appsync.MappingTemplate.fromString('{}'),
      responseMappingTemplate: appsync.MappingTemplate.fromString(
        '$util.toJson($ctx.prev.result)',
      ),
    });

    // --- Resolver for Query.listMyMealPlans ---
    tableDS.createResolver('QueryListMyMealPlansResolver', {
      typeName: 'Query',
      fieldName: 'listMyMealPlans',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/query.listMyMealPlans.js'),
    });

    // --- Resolver for Query.getMealPlanById (JavaScript Runtime) ---
    tableDS.createResolver('QueryGetMealPlanByIdResolver', {
      typeName: 'Query',
      fieldName: 'getMealPlanById',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/getMealPlanById.js'),
    });

    // --- Resolver for Query.listNutritionists ---
    tableDS.createResolver('QueryListNutritionistsResolverNew', {
      typeName: 'Query',
      fieldName: 'listNutritionists',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/query.listNutritionists.js'),
    });

    // --- Resolver for Mutation.requestValidation ---
    // Si trova in chat-stack
    /*tableDS.createResolver('MutationRequestValidationResolver', {
      typeName: 'Mutation',
      fieldName: 'requestValidation',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('resolvers/mutation.requestValidation.js'),
    });*/

    // --- Resolver for Mutation.setUserSubscriptionStatus ---
    tableDS.createResolver('MutationSetUserSubscriptionStatusResolver', {
      typeName: 'Mutation',
      fieldName: 'setUserSubscriptionStatus',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/mutation.setUserSubscriptionStatus.js',
      ),
    });

    // --- Resolver for Query.listMyAssignedMealPlans ---
    tableDS.createResolver('QueryListMyAssignedMealPlansResolver', {
      typeName: 'Query',
      fieldName: 'listMyAssignedMealPlans',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/query.listMyAssignedMealPlans.js',
      ),
    });

    // --- Resolver for Query.getUserSubscriptionStatus ---
    tableDS.createResolver('QueryGetUserSubscriptionStatusResolver', {
      typeName: 'Query',
      fieldName: 'getUserSubscriptionStatus',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/query.getUserSubscriptionStatus.js',
      ),
    });

    // --- Resolver for Query.getMyNutritionistProfile ---
    tableDS.createResolver('QueryGetMyNutritionistProfileResolver', {
      typeName: 'Query',
      fieldName: 'getMyNutritionistProfile',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/query.getMyNutritionistProfile.js',
      ),
    });

    const getCognitoUserDetails = new NodejsFunction(
      this,
      'GetCognitoUserDetails',
      {
        functionName: 'get-cognito-user-details',
        runtime: lambda.Runtime.NODEJS_22_X,
        handler: 'handler',
        entry: 'src/lambda/get-cognito-user-details/index.ts',
        timeout: cdk.Duration.seconds(30),
        memorySize: 256,
        bundling: {
          format: OutputFormat.CJS,
          bundleAwsSDK: false,
          minify: false, // Minify the code
          sourceMap: true, // Generate source maps
          externalModules: ['@aws-sdk/client-cognito-identity-provider'],
        },
        environment: {
          USER_POOL_ID: props.userPool.userPoolId,
        },
        tracing: lambda.Tracing.ACTIVE,
        logRetention: logs.RetentionDays.ONE_WEEK,
      },
    );

    // Add Cognito permissions
    props.userPool.grant(getCognitoUserDetails, 'cognito-idp:AdminGetUser');

    const lambdaDS = api.addLambdaDataSource(
      'GetCognitoUserDetailsDataSource',
      getCognitoUserDetails,
    );

    // Create the pipeline functions
    const getCognitoDetailsFunction = new appsync.AppsyncFunction(
      this,
      'GetCognitoDetailsFunction',
      {
        name: 'getCognitoDetails',
        api,
        dataSource: lambdaDS, // Use Lambda data source
        runtime: appsync.FunctionRuntime.JS_1_0_0,
        code: appsync.Code.fromAsset('resolvers/function.getCognitoDetails.js'),
      },
    );

    const updateMyNutritionistProfileFunction = new appsync.AppsyncFunction(
      this,
      'UpdateMyNutritionistProfileFunction',
      {
        name: 'updateMyNutritionistProfile',
        api,
        dataSource: tableDS, // Use DynamoDB data source
        runtime: appsync.FunctionRuntime.JS_1_0_0,
        code: appsync.Code.fromAsset(
          'resolvers/function.updateMyNutritionistProfile.js',
        ),
      },
    );

    // Replace your existing resolver with pipeline resolver
    new appsync.Resolver(this, 'MutationUpdateMyNutritionistProfileResolver', {
      api,
      typeName: 'Mutation',
      fieldName: 'updateMyNutritionistProfile',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      pipelineConfig: [
        getCognitoDetailsFunction,
        updateMyNutritionistProfileFunction,
      ],
      code: appsync.Code.fromInline(`
        export function request(ctx) {
          return {};
        }
        
        export function response(ctx) {
          return ctx.prev.result;
        }
      `),
    });

    // ====================================================================
    // ====================================================================
    //                  MEAL PLAN GENERATION (NEW SECTION)
    // ====================================================================
    // ====================================================================

    // ====================================================================
    //                MEAL PLAN GENERATION WORKFLOW
    // ====================================================================

    // --- 1. Notification System (SNS + Lambda) ---
    // This system is triggered by the Step Function to notify AppSync.
    // It can be extended later to handle push notifications.

    const mealPlanNotificationTopic = new sns.Topic(
      this,
      'MealPlanNotificationTopic',
      {
        topicName: 'meal-plan-notifications',
      },
    );

    // Crea un data source "None" per le notification mutations (se non esiste già)
    const noneDS = api.addNoneDataSource('NotificationDataSource');

    noneDS.createResolver('OnMealPlanStatusChangedSubscriptionResolver', {
      typeName: 'Subscription',
      fieldName: 'onMealPlanStatusChanged',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/subscription.onMealPlanStatusChanged.js',
      ),
    });

    // Resolver per la notification mutation unificata
    noneDS.createResolver('NotifyMealPlanStatusChangedResolver', {
      typeName: 'Mutation',
      fieldName: 'notifyMealPlanStatusChanged',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset(
        'resolvers/mutation.notifyMealPlanStatusChanged.js',
      ),
    });

    // --- End of Meal Plan Generation Section ---

    const notificationLambda = new NodejsFunction(this, 'NotificationHandler', {
      functionName: 'meal-plan-notification-handler',
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'handler',
      entry: 'src/lambda/meal-generation-notification-handler/index.ts',
      environment: {
        APPSYNC_API_URL: api.graphqlUrl,
      },
      bundling: {
        format: OutputFormat.CJS,
        externalModules: [
          '@aws-sdk/credential-providers',
          '@aws-sdk/signature-v4',
          '@aws-sdk/protocol-http',
        ],
      },
    });

    // Grant the notification Lambda permission to call the AppSync API
    notificationLambda.addToRolePolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: ['appsync:GraphQL'],
        resources: [`${api.arn}/*`],
      }),
    );

    // Subscribe the notification Lambda to the SNS topic
    mealPlanNotificationTopic.addSubscription(
      new snsSubscriptions.LambdaSubscription(notificationLambda, {
        deadLetterQueue: new sqs.Queue(this, 'NotificationDLQ'),
      }),
    );

    // --- 2. Workflow Lambdas ---
    // These are the individual functions orchestrated by the Step Function.

    const requestLambda = new NodejsFunction(this, 'RequestHandler', {
      functionName: 'meal-plan-request-handler',
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'handler',
      entry: 'src/lambda/meal-generation-request-handler/index.ts',
      timeout: cdk.Duration.seconds(30),
      environment: {
        MEALPLANS_TABLE_NAME: props.mealPlanningTable.tableName,
        // The STATE_MACHINE_ARN is added further down after the machine is created
      },
      bundling: {
        format: OutputFormat.ESM,
        externalModules: [
          '@aws-sdk/client-dynamodb',
          '@aws-sdk/lib-dynamodb',
          '@aws-sdk/client-sfn',
        ],
      },
    });

    const validatorLambda = new NodejsFunction(this, 'ValidatorHandler', {
      functionName: 'meal-plan-validator-handler',
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'handler',
      entry: 'src/lambda/validate-preferences-handler/index.ts',
      timeout: cdk.Duration.seconds(10),
      environment: {
        TABLE_NAME: props.mealPlanningTable.tableName,
        // The STATE_MACHINE_ARN is added further down after the machine is created
      },
      bundling: {
        format: OutputFormat.ESM,
        externalModules: ['@aws-sdk/client-dynamodb', '@aws-sdk/lib-dynamodb'],
      },
    });

    const geminiApiSecret = secretsmanager.Secret.fromSecretCompleteArn(
      this,
      'GeminiApiSecret',
      'arn:aws:secretsmanager:us-west-2:537124974525:secret:GeminiApiSecret-FoYZ9f',
    );

    const generatorLambda = new NodejsFunction(this, 'GeneratorHandler', {
      functionName: 'meal-plan-generator-handler',
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'handler',
      entry: 'src/lambda/meal-generator-generation-handler/index.ts',
      timeout: cdk.Duration.minutes(5),
      memorySize: 512,
      environment: {
        GEMINI_SECRET_ARN: geminiApiSecret.secretArn,
      },
      bundling: {
        format: OutputFormat.CJS,
        // CORRECTED: Lists the actual SDK clients used by the generator's code
        externalModules: ['@aws-sdk/client-secrets-manager'],
      },
    });

    const updateStatusLambda = new NodejsFunction(this, 'UpdateStatusHandler', {
      functionName: 'meal-plan-update-status-handler',
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'handler',
      entry: 'src/lambda/meal-generation-update-status-handler/index.ts',
      environment: { TABLE_NAME: props.mealPlanningTable.tableName },
      timeout: cdk.Duration.seconds(30),
      bundling: {
        format: OutputFormat.ESM,
        externalModules: ['@aws-sdk/client-dynamodb', '@aws-sdk/lib-dynamodb'],
      },
    });

    const getCognitoDetailsLambda = new NodejsFunction(
      this,
      'GetCognitoDetailsHandler',
      {
        functionName: 'meal-plan-get-cognito-details-handler',
        runtime: lambda.Runtime.NODEJS_22_X,
        handler: 'handler',
        entry: 'src/lambda/get-cognito-details-handler/index.ts',
        environment: {
          USER_POOL_ID: props.userPool.userPoolId,
        },
        timeout: cdk.Duration.seconds(10),
        bundling: {
          format: OutputFormat.ESM,
          externalModules: ['@aws-sdk/client-cognito-identity-provider'],
        },
      },
    );

    props.userPool.grant(getCognitoDetailsLambda, 'cognito-idp:AdminGetUser');

    // --- 3. AppSync Integration to Start the Workflow ---
    const requestLambdaDS = api.addLambdaDataSource(
      'RequestLambdaDataSource',
      requestLambda,
    );

    requestLambdaDS.createResolver('RequestNewMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'requestNewMealPlan',
    });

    // --- 4. Step Function State Machine ---

    const getCognitoDetailsTask = new sfn_tasks.LambdaInvoke(
      this,
      'Get Cognito User Details',
      {
        lambdaFunction: getCognitoDetailsLambda,
        payload: sfn.TaskInput.fromJsonPathAt('$'),
        outputPath: '$.Payload',
      },
    );

    const validatePreferencesTask = new sfn_tasks.LambdaInvoke(
      this,
      'Validate Preferences',
      {
        lambdaFunction: validatorLambda,
        payload: sfn.TaskInput.fromJsonPathAt('$'),
        resultPath: '$.validatedPrefs',
        resultSelector: { 'Payload.$': '$.Payload' },
      },
    );

    const generatePlanTask = new sfn_tasks.LambdaInvoke(
      this,
      'Generate Meal Plan',
      {
        lambdaFunction: generatorLambda,
        payload: sfn.TaskInput.fromJsonPathAt('$'),
        resultPath: '$.planResult',
        resultSelector: { 'Payload.$': '$.Payload' },
      },
    );

    // Success path: Update to GENERATED and notify
    const updateSuccessTask = new sfn_tasks.LambdaInvoke(
      this,
      'Update Status to GENERATED',
      {
        lambdaFunction: updateStatusLambda,
        payload: sfn.TaskInput.fromObject({
          mealPlanId: sfn.JsonPath.stringAt('$.mealPlanId'),
          userId: sfn.JsonPath.stringAt('$.userId'),
          status: 'GENERATED',
          dailyPlan: sfn.JsonPath.objectAt('$.planResult.Payload'),
        }),
        resultPath: '$.updateResult',
      },
    );

    const notifySuccessTask = new sfn_tasks.SnsPublish(this, 'Notify Success', {
      topic: mealPlanNotificationTopic,
      message: sfn.TaskInput.fromObject({
        type: 'MEAL_PLAN_GENERATED',
        userId: sfn.JsonPath.stringAt('$.userId'),
        mealPlanId: sfn.JsonPath.stringAt('$.mealPlanId'),
        timestamp: sfn.JsonPath.stringAt('$$.State.EnteredTime'),
      }),
    });

    // Failure path: Update to FAILED and notify
    const updateFailureTask = new sfn_tasks.LambdaInvoke(
      this,
      'Update Status to FAILED',
      {
        lambdaFunction: updateStatusLambda,
        payload: sfn.TaskInput.fromObject({
          mealPlanId: sfn.JsonPath.stringAt('$.mealPlanId'),
          userId: sfn.JsonPath.stringAt('$.userId'),
          status: 'FAILED',
          error: sfn.JsonPath.stringAt('$.error.Cause'),
        }),
        resultPath: '$.updateResult',
      },
    );

    const notifyFailureTask = new sfn_tasks.SnsPublish(this, 'Notify Failure', {
      topic: mealPlanNotificationTopic,
      message: sfn.TaskInput.fromObject({
        type: 'MEAL_PLAN_FAILED',
        userId: sfn.JsonPath.stringAt('$.userId'),
        mealPlanId: sfn.JsonPath.stringAt('$.mealPlanId'),
        timestamp: sfn.JsonPath.stringAt('$$.State.EnteredTime'),
        details: {
          error: sfn.JsonPath.stringAt('$.error.Cause'),
        },
      }),
      messageAttributes: {
        userId: {
          dataType: MessageAttributeDataType.STRING,
          value: sfn.JsonPath.stringAt('$.userId'),
        },
        type: {
          dataType: MessageAttributeDataType.STRING,
          value: 'MEAL_PLAN_FAILED',
        },
      },
    });

    // Create the failure flow (update + notify)
    const failureFlow = updateFailureTask.next(notifyFailureTask);

    // Create the success flow (update + notify)
    const successFlow = updateSuccessTask.next(notifySuccessTask);

    // Build the main workflow with catch-all error handling
    const definition = getCognitoDetailsTask
      .addCatch(failureFlow, {
        errors: ['States.ALL'],
        resultPath: '$.error', // KEY FIX: Preserve original input, add error to $.error
      })
      .next(
        validatePreferencesTask
          .addCatch(failureFlow, {
            errors: ['States.ALL'],
            resultPath: '$.error', // KEY FIX: Preserve original input, add error to $.error
          })
          .next(
            generatePlanTask
              .addCatch(failureFlow, {
                errors: ['States.ALL'],
                resultPath: '$.error', // KEY FIX: Preserve original input, add error to $.error
              })
              .next(successFlow),
          ),
      );

    // Create the state machine
    const stateMachine = new sfn.StateMachine(
      this,
      'MealPlanGenerationMachine',
      {
        stateMachineName: 'MealPlanGenerationWorkflow',
        definitionBody: sfn.DefinitionBody.fromChainable(definition),
        timeout: cdk.Duration.minutes(10),
        tracingEnabled: true,
        logs: {
          destination: new logs.LogGroup(this, 'MealPlanGenerationMachineLogs'),
          level: sfn.LogLevel.ALL,
          includeExecutionData: true,
        },
      },
    );

    // --- 5. IAM Permissions & Final Wiring ---
    // Connect the Request Handler to the State Machine
    requestLambda.addEnvironment(
      'STATE_MACHINE_ARN',
      stateMachine.stateMachineArn,
    );
    stateMachine.grantStartExecution(requestLambda);

    // Grant permissions to the workflow Lambdas
    props.mealPlanningTable.grantWriteData(requestLambda); // For the initial PENDING status
    props.mealPlanningTable.grantReadData(validatorLambda); // For reading user details
    geminiApiSecret.grantRead(generatorLambda);
    props.mealPlanningTable.grantWriteData(updateStatusLambda); // For the final status update

    // --------------------------------------------------------------------
    // OTHER RESOLVERS WILL BE ADDED LATER
    // --------------------------------------------------------------------

    new ChatStack(this, 'ChatResolvers', {
      api: api,
      dynamoDataSource: tableDS,
      table: props.mealPlanningTable,
      userPool: props.userPool,
    });

    // Store API details for outputs or cross-stack references
    this.graphqlUrl = api.graphqlUrl;
    this.apiId = api.apiId;

    // Outputs
    new cdk.CfnOutput(this, 'GraphQLAPIURL', {
      value: api.graphqlUrl,
      description: 'The URL of the GraphQL API',
    });
    new cdk.CfnOutput(this, 'GraphQLAPIId', {
      value: api.apiId,
      description: 'The ID of the GraphQL API',
    });
    // Region output removed to avoid TypeScript compilation issues
  }
}
