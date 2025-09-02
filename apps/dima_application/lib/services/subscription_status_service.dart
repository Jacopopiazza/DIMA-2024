import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class SubscriptionStatusService {
  Future<UserSubscriptionStatus> getSubscriptionStatus() async {
    try {
      safePrint(
          '[SubscriptionStatusService] Starting getSubscriptionStatus request...');

      final request = GraphQLRequest(document: '''
      query MyQuery {
          getUserSubscriptionStatus {
              userId
              subscriptionStatus
          }
      }
      ''', decodePath: "getUserSubscriptionStatus");

      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        safePrint(
            '[SubscriptionStatusService] GraphQL errors: ${response.errors}');
        throw Exception(
            'GraphQL query failed with errors: \\${response.errors}');
      }

      Map<String, dynamic> jsonData;
      if (response.data is String) {
        jsonData = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        jsonData = response.data;
      } else {
        safePrint(
            '[SubscriptionStatusService] Unexpected response data type: \\${response.data.runtimeType}');
        throw Exception('Unexpected response data type');
      }
      safePrint('[SubscriptionStatusService] Parsed JSON data: $jsonData');
      return UserSubscriptionStatus.fromJson(jsonData[request.decodePath!]);
    } catch (e, stackTrace) {
      safePrint('[SubscriptionStatusService] Error: $e');
      safePrint('[SubscriptionStatusService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<UserSubscriptionStatus> updateSubscriptionStatus(
      SubscriptionStatusEnum status) async {
    try {
      final request = GraphQLRequest(
        document: '''
      mutation {
        setUserSubscriptionStatus(subscriptionStatus: ${status.name}) {
          userId
          subscriptionStatus
        }
      }
    ''',
        decodePath: 'setUserSubscriptionStatus',
      );

      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint(
            '[SubscriptionStatusService] GraphQL errors: ${response.errors}');
        throw Exception('GraphQL query failed with errors: ${response.errors}');
      }

      Map<String, dynamic> jsonData;
      if (response.data is String) {
        jsonData = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        jsonData = response.data;
      } else {
        safePrint(
            '[SubscriptionStatusService] Unexpected response data type: ${response.data.runtimeType}');
        throw Exception('Unexpected response data type');
      }
      safePrint('[SubscriptionStatusService] Parsed JSON data: $jsonData');
      return UserSubscriptionStatus.fromJson(jsonData[request.decodePath!]);
    } catch (e) {
      safePrint(
          '[SubscriptionStatusService] Error updating user subscription status: $e');
      rethrow;
    }
  }
}
