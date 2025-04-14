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

    // Resolver for Query.getMyUserDetails
    tableDS.createResolver('QueryGetMyUserDetailsResolver', {
      typeName: 'Query',
      fieldName: 'getMyUserDetails',
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/getMyUserDetails-request.vtl',
      ),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/getMyUserDetails-response.vtl',
      ),
    });

    // Resolver for Mutation.updateMyUserDetails
    tableDS.createResolver('MutationUpdateMyUserDetailsResolver', {
      typeName: 'Mutation',
      fieldName: 'updateMyUserDetails',
      requestMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/updateMyUserDetails-request.vtl',
      ),
      responseMappingTemplate: appsync.MappingTemplate.fromFile(
        'vtl-templates/updateMyUserDetails-response.vtl',
      ),
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
