import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/isar_test_helper.dart';

/// Global test setup that initializes required components for all tests
///
/// This should be called at the beginning of test files that use Isar and Amplify
/// to ensure proper initialization of native libraries and plugins.
Future<void> initializeTestEnvironment() async {
  // Initialize Isar core libraries
  await IsarTestHelper.initialize();

  // Initialize Amplify for testing if not already configured
  await _configureAmplifyForTesting();
}

/// Configure Amplify plugins for testing environment
Future<void> _configureAmplifyForTesting() async {
  try {
    if (!Amplify.isConfigured) {
      // Add required plugins for testing
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.addPlugin(AmplifyAuthCognito());

      // Configure with minimal test configuration
      await Amplify.configure('''
      {
        "api": {
          "plugins": {
            "awsAPIPlugin": {
              "testAPI": {
                "endpointType": "GraphQL",
                "endpoint": "https://test-api.example.com/graphql",
                "region": "us-east-1",
                "authorizationType": "API_KEY",
                "apiKey": "test-api-key"
              }
            }
          }
        },
        "auth": {
          "plugins": {
            "awsCognitoAuthPlugin": {
              "UserAgent": "aws-amplify-cli/0.1.0",
              "Version": "0.1.0",
              "IdentityManager": {
                "Default": {}
              },
              "CredentialsProvider": {
                "CognitoIdentity": {
                  "Default": {
                    "PoolId": "test-pool-id",
                    "Region": "us-east-1"
                  }
                }
              },
              "CognitoUserPool": {
                "Default": {
                  "PoolId": "test-pool-id",
                  "AppClientId": "test-client-id",
                  "Region": "us-east-1"
                }
              }
            }
          }
        }
      }
      ''');

      safePrint('Amplify configured for testing');
    }
  } catch (e) {
    // If configuration fails, log but don't fail the test setup
    // Tests can still run but may need to handle Amplify errors
    safePrint('Warning: Failed to configure Amplify for testing: $e');
  }
}

/// Test configuration that can be used in setUpAll across test files
void configureTestEnvironment() {
  setUpAll(() async {
    await initializeTestEnvironment();
  });
}
