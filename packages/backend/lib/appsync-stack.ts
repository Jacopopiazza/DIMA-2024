import * as cdk from 'aws-cdk-lib';
import * as appsync from 'aws-cdk-lib/aws-appsync';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
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
      requestMappingTemplate: appsync.MappingTemplate.fromString(`
            ## Store identity for use in functions
            $ctx.stash.identity = $ctx.identity
            ## Store today's date parts for cxonsistency
            #set($utils = $util.time)
            $ctx.stash.todayDate = $utils.nowISO8601().substring(0, 10)
            $ctx.stash.todayDayOfWeek = $utils.getDayOfWeekISO() ## 1=Monday, 7=Sunday
            $ctx.stash.weekDayMap = {1: "monday", 2: "tuesday", 3: "wednesday", 4: "thursday", 5: "friday", 6: "saturday", 7: "sunday"}
            $ctx.stash.todayWeekdayKey = $ctx.stash.weekDayMap[$ctx.stash.todayDayOfWeek]
            {}
        `),
      // Response mapping template - combines results from the functions
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/pipeline.getTodaysPlanAndStatus-response.vtl',
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
    tableDS.createResolver('MutationSetActiveMealPlanResolver', {
      typeName: 'Mutation',
      fieldName: 'setActiveMealPlan',
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/mutation.setActiveMealPlan-request.vtl',
      ),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/mutation.setActiveMealPlan-response.vtl',
      ),
    });

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
