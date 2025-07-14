import * as cdk from 'aws-cdk-lib';
import * as appsync from 'aws-cdk-lib/aws-appsync';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as logs from 'aws-cdk-lib/aws-logs';
import { Construct } from 'constructs';

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
        'vtl-templates/getUserDetails-request.vtl',
      ),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/getUserDetails-response.vtl',
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
          'vtl-templates/pipeline.getTodaysPlanAndStatus.func1-getUserDetails-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'vtl-templates/pipeline.getTodaysPlanAndStatus.func1-getUserDetails-response.vtl',
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
          'vtl-templates/pipeline.getTodaysPlanAndStatus.func2-getMealPlan-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'vtl-templates/pipeline.getTodaysPlanAndStatus.func2-getMealPlan-response.vtl',
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
          'vtl-templates/pipeline.getTodaysPlanAndStatus.func3-getCompletedLog-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'vtl-templates/pipeline.getTodaysPlanAndStatus.func3-getCompletedLog-response.vtl',
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
        'vtl-templates/pipeline.getTodaysPlanAndStatus-response.vtl',
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
        'vtl-templates/pipeline.getActiveMealPlan-response.vtl',
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
        requestMappingTemplate: appsync.MappingTemplate.fromFile(
          'vtl-templates/pipeline.updateUserDetails.UpdateUserDetailsFunction-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'vtl-templates/pipeline.updateUserDetails.UpdateUserDetailsFunction-response.vtl',
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
          'vtl-templates/getUserDetails-request.vtl',
        ),
        responseMappingTemplate: appsync.MappingTemplate.fromFile(
          'vtl-templates/getUserDetails-response.vtl',
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
          'vtl-templates/pipeline.updateUserDetails-response.vtl',
        ),
      },
    );

    // ====================================================================
    //                      MUTATION RESOLVERS
    // ====================================================================

    // --- Resolver for Mutation.setActiveMealPlan ---
    // --- Lambda Data Source for setActiveMealPlan ---
    const setActiveMealPlanLambda = new lambda.Function(
      this,
      'SetActiveMealPlanLambda',
      {
        runtime: lambda.Runtime.NODEJS_22_X,
        handler: 'index.handler',
        code: lambda.Code.fromAsset('src/lambda/setActiveMealPlan'),
        environment: {
          TABLE_NAME: props.mealPlanningTable.tableName,
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
        'vtl-templates/mutation.markMealAsCompleted-request.vtl',
      ), // Ensure this file exists and has the Set logic
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/mutation.markMealAsCompleted-response.vtl',
      ),
    });

    // --- Add Resolver for Unmark Meal ---
    tableDS.createResolver('MutationUnmarkMealAsCompletedResolver', {
      // New Resolver definition
      typeName: 'Mutation',
      fieldName: 'unmarkMealAsCompleted', // New field name from updated schema
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/mutation.unmarkMealAsCompleted-request.vtl',
      ), // New VTL file
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/mutation.unmarkMealAsCompleted-response.vtl',
      ), // New VTL file
    });

    // --- Resolver for Mutation.createMealPlan ---
    tableDS.createResolver('MutationCreateMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'createMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/mutation.createMealPlan.js'),
    });

    // --- Resolver for Mutation.deleteMealPlan ---
    tableDS.createResolver('MutationDeleteMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'deleteMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/mutation.deleteMealPlan.js'),
    });

    // --- Resolver for Mutation.modifyMealPlan ---
    tableDS.createResolver('MutationModifyMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'modifyMealPlan',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/mutation.modifyMealPlan.js'),
    });

    // --- Resolver for Query.listMyMealPlans ---
    tableDS.createResolver('QueryListMyMealPlansResolver', {
      typeName: 'Query',
      fieldName: 'listMyMealPlans',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/query.listMyMealPlans.js'),
    });

    // --- Resolver for Query.getMealPlanById ---
    tableDS.createResolver('QueryGetMealPlanByIdResolver', {
      typeName: 'Query',
      fieldName: 'getMealPlanById',
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/query.getMealPlanById-request.vtl',
      ),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/query.getMealPlanById-response.vtl',
      ),
    });

    // --- Resolver for Query.listNutritionists ---
    tableDS.createResolver('QueryListNutritionistsResolverNew', {
      typeName: 'Query',
      fieldName: 'listNutritionists',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/query.listNutritionists.js'),
    });

    // --- Resolver for Mutation.requestValidation ---
    tableDS.createResolver('MutationRequestValidationResolver', {
      typeName: 'Mutation',
      fieldName: 'requestValidation',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/mutation.requestValidation.js'),
    });

    // --- Resolver for Query.listMyAssignedMealPlans ---
    tableDS.createResolver('QueryListMyAssignedMealPlansResolver', {
      typeName: 'Query',
      fieldName: 'listMyAssignedMealPlans',
      runtime: appsync.FunctionRuntime.JS_1_0_0,
      code: appsync.Code.fromAsset('vtl-templates/query.listMyAssignedMealPlans.js'),
    });

    // --------------------------------------------------------------------
    // OTHER RESOLVERS WILL BE ADDED LATER
    // --------------------------------------------------------------------

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
    new cdk.CfnOutput(this, 'AppSyncApiRegion', {
      value: this.region,
      description: 'The region where the AppSync API is deployed',
    });
  }
}
