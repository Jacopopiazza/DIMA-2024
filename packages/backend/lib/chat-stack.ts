// chat-stack.ts
import * as cdk from 'aws-cdk-lib';
import * as appsync from 'aws-cdk-lib/aws-appsync';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import { NodejsFunction, OutputFormat } from 'aws-cdk-lib/aws-lambda-nodejs';
import { Construct } from 'constructs';

interface ChatStackProps extends cdk.StackProps {
  // Existing resources passed from AppSync stack
  api: appsync.GraphqlApi;
  dynamoDataSource: appsync.DynamoDbDataSource;
  table: dynamodb.ITableV2;
  userPool: cognito.UserPool;
}

export class ChatStack extends Construct {
  public readonly getCognitoUserDetailsLambda: lambda.Function;
  public readonly lambdaDataSource: appsync.LambdaDataSource;

  constructor(scope: Construct, id: string, props: ChatStackProps) {
    super(scope, id);

    // ============================================
    // 1. CREATE LAMBDA FOR COGNITO USER DETAILS
    // ============================================
    this.getCognitoUserDetailsLambda = new NodejsFunction(this, 'GetCognitoUserDetails', {
      runtime: lambda.Runtime.NODEJS_22_X,
      handler: 'handler',
      entry: 'src/lambda/get-cognito-user-details-chat/index.ts', // TODO: SISTEMA PERCORSO
      environment: {
        USER_POOL_ID: props.userPool.userPoolId,
        TABLE_NAME: props.table.tableName,
      },
      timeout: cdk.Duration.seconds(30),
      memorySize: 128,
      bundling: {
        format: OutputFormat.ESM,
        externalModules: ['@aws-sdk/client-dynamodb', '@aws-sdk/lib-dynamodb', '@aws-sdk/client-cognito-identity-provider'],
        minify: true,
      },
    });

    // Grant Lambda permissions to read Cognito
    props.userPool.grant(this.getCognitoUserDetailsLambda, 'cognito-idp:AdminGetUser', 'cognito-idp:ListUsers', 'cognito-idp:AdminListGroupsForUser');

    // Se funziona, elimina questo tieni riga sopra
    /*this.getCognitoUserDetailsLambda.addToRolePolicy(
      new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: [
          'cognito-idp:AdminGetUser',
          'cognito-idp:ListUsers',
          'cognito-idp:AdminListGroupsForUser',
        ],
        resources: [props.userPool.userPoolArn],
      })
    );*/

    // Grant Lambda permissions to cache in DynamoDB
    props.table.grantReadWriteData(this.getCognitoUserDetailsLambda);

    // ============================================
    // 2. ADD LAMBDA DATA SOURCE TO EXISTING API
    // ============================================
    this.lambdaDataSource = props.api.addLambdaDataSource(
      'CognitoUserDataSource',
      this.getCognitoUserDetailsLambda
    );

    // ============================================
    // 3. CREATE RESOLVER FUNCTIONS
    // ============================================
    
    // requestValidation Pipeline Functions
    const updateMealPlanFn = new appsync.AppsyncFunction(this, 'UpdateMealPlanFn', {
      api: props.api,
      dataSource: props.dynamoDataSource,
      name: 'UpdateMealPlanFunction',
      code: appsync.Code.fromAsset('resolvers/mutation.requestValidation.updateMealPlan.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    const fetchUserDetailsFn = new appsync.AppsyncFunction(this, 'FetchUserDetailsFn', {
      api: props.api,
      dataSource: this.lambdaDataSource,
      name: 'FetchUserDetailsFunction',
      code: appsync.Code.fromAsset('resolvers/mutation.requestValidation.fetchUserDetails.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    const createChatFn = new appsync.AppsyncFunction(this, 'CreateChatFn', {
      api: props.api,
      dataSource: props.dynamoDataSource,
      name: 'CreateChatFunction',
      code: appsync.Code.fromAsset('resolvers/mutation.requestValidation.createChat.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    // sendChatMessage Pipeline Functions
    const verifyParticipantFn = new appsync.AppsyncFunction(this, 'VerifyParticipantFn', {
      api: props.api,
      dataSource: props.dynamoDataSource,
      name: 'VerifyParticipantFunction',
      code: appsync.Code.fromAsset('resolvers/mutation.sendChatMessage.verifyParticipant.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    const createMessageFn = new appsync.AppsyncFunction(this, 'CreateMessageFn', {
      api: props.api,
      dataSource: props.dynamoDataSource,
      name: 'CreateMessageFunction',
      code: appsync.Code.fromAsset('resolvers/mutation.sendChatMessage.createMessage.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    const updateChatMetadataFn = new appsync.AppsyncFunction(this, 'UpdateChatMetadataFn', {
      api: props.api,
      dataSource: props.dynamoDataSource,
      name: 'UpdateChatMetadataFunction',
      code: appsync.Code.fromAsset('resolvers/mutation.sendChatMessage.updateChatMetadata.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    // ============================================
    // 4. CREATE PIPELINE RESOLVERS
    // ============================================
    
    // requestValidation Pipeline (3 steps) - UPDATE EXISTING
    new appsync.Resolver(this, 'RequestValidationResolver', {
      api: props.api,
      typeName: 'Mutation',
      fieldName: 'requestValidation',
      pipelineConfig: [
        updateMealPlanFn,
        fetchUserDetailsFn,
        createChatFn,
      ],
      code: appsync.Code.fromInline(`
        export function request(ctx) {
          return {};
        }
        export function response(ctx) {
          return ctx.prev.result;
        }
      `),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    // sendChatMessage Pipeline (3 steps) - NEW
    new appsync.Resolver(this, 'SendChatMessageResolver', {
      api: props.api,
      typeName: 'Mutation',
      fieldName: 'sendChatMessage',
      pipelineConfig: [
        verifyParticipantFn,
        createMessageFn,
        updateChatMetadataFn,
      ],
      code: appsync.Code.fromInline(`
        export function request(ctx) {
          return {};
        }
        export function response(ctx) {
          return ctx.prev.result;
        }
      `),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    // ============================================
    // 5. CREATE UNIT RESOLVERS
    // ============================================
    
    // Query resolvers
    new appsync.Resolver(this, 'GetChatMessagesResolver', {
      api: props.api,
      typeName: 'Query',
      fieldName: 'getChatMessages',
      dataSource: props.dynamoDataSource,
      code: appsync.Code.fromAsset('resolvers/query.getChatMessages.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    new appsync.Resolver(this, 'ListMyChatsResolver', {
      api: props.api,
      typeName: 'Query',
      fieldName: 'listMyChats',
      dataSource: props.dynamoDataSource,
      code: appsync.Code.fromAsset('resolvers/query.listMyChats.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

    new appsync.Resolver(this, 'ListMyAssignedChatsResolver', {
      api: props.api,
      typeName: 'Query',
      fieldName: 'listMyAssignedChats',
      dataSource: props.dynamoDataSource,
      code: appsync.Code.fromAsset('resolvers/query.listMyAssignedChats.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });


    // ============================================
    // 6. SUBSCRIPTION RESOLVERS
    // ============================================
    
    // Create None data source for subscriptions
    const noneDataSource = props.api.addNoneDataSource(
      'ChatSubscriptionNoneDataSource',
      {
        name: 'ChatSubscriptionNoneDataSource',
        description: 'None data source for chat subscriptions',
      }
    );
    
    // Global subscription for all user's chats
    new appsync.Resolver(this, 'OnNewChatMessageForUserResolver', {
      api: props.api,
      typeName: 'Subscription',
      fieldName: 'onNewChatMessageForUser',
      dataSource: noneDataSource,
      code: appsync.Code.fromAsset('resolvers/subscription.onNewChatMessageForUser.js'),
      runtime: appsync.FunctionRuntime.JS_1_0_0,
    });

  }
}
