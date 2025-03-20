import * as cdk from 'aws-cdk-lib';
import * as appsync from 'aws-cdk-lib/aws-appsync';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import { Construct } from 'constructs';
import { DataStack } from './data-stack'; // This stack contains your DynamoDB table

interface AppSyncApiStackProps extends cdk.StackProps {
  userPool: cognito.UserPool;
  mealPlanningTable: DataStack['mealPlanningTable'];
}

export class AppSyncApiStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: AppSyncApiStackProps) {
    super(scope, id, props);

    // Create the AppSync API using your GraphQL schema (e.g., schema.graphql)
    const api = new appsync.GraphqlApi(this, 'MealPlanningApi', {
      name: 'MealPlanningApi',
      definition: appsync.Definition.fromFile('graphql/schema.graphql'),
      authorizationConfig: {
        defaultAuthorization: {
          authorizationType: appsync.AuthorizationType.USER_POOL,
          userPoolConfig: { userPool: props.userPool },
        },
      },
      xrayEnabled: true,
    });

    // Add DynamoDB table as a data source
    const tableDS = api.addDynamoDbDataSource(
      'MealPlanningTable',
      props.mealPlanningTable,
    );

    tableDS.createResolver('QueryGetUserPreferences', {
      typeName: 'Query',
      fieldName: 'getUserPreferences',
      requestMappingTemplate: appsync.MappingTemplate.fromString(`
          #set($pk = "USER#" + $ctx.identity.sub)
          {
            "version": "2018-05-29",
            "operation": "GetItem",
            "key": {
              "PK": $util.dynamodb.toDynamoDBJson($pk),
              "SK": $util.dynamodb.toDynamoDBJson("PREFERENCES")
            }
          }
        `),
      responseMappingTemplate: appsync.MappingTemplate.dynamoDbResultItem(),
    });

    tableDS.createResolver('MutationPutUserPreferences', {
      typeName: 'Mutation',
      fieldName: 'putUserPreferences',
      requestMappingTemplate: appsync.MappingTemplate.fromString(`
          #set($pk = "USER#" + $ctx.identity.sub)
          {
            "version": "2018-05-29",
            "operation": "PutItem",
            "key": {
              "PK": $util.dynamodb.toDynamoDBJson($pk),
              "SK": $util.dynamodb.toDynamoDBJson("PREFERENCES")
            },
            "attributeValues": $util.dynamodb.toMapValuesJson($ctx.args.input)
          }
        `),
      responseMappingTemplate: appsync.MappingTemplate.fromString(`
          #set($input = $ctx.args.input)
          {
            "mealsPerDay": $input.mealsPerDay,
            "weight": $input.weight,
            "frequencyExercise": "$input.frequencyExercise",
            "allergens": $util.toJson($input.allergens)
          }
        `),
    });

    new cdk.CfnOutput(this, 'GraphQLAPIURL', { value: api.graphqlUrl });
    new cdk.CfnOutput(this, 'GraphQLAPIKey', {
      value: api.apiKey || 'No API Key',
    });
  }
}
