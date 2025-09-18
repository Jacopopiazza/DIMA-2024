import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class ClientDetailsService {
  final AmplifyGraphQL _amplifyGraphQL;

  ClientDetailsService({AmplifyGraphQL? amplifyGraphQL})
      : _amplifyGraphQL = amplifyGraphQL ?? AmplifyGraphQL();

  /// Get client details for nutritionist using the getClientDetails GraphQL query
  /// This query is restricted to nutritionists only via AWS Cognito groups
  Future<UserDetails?> getClientDetails(String userId) async {
    safePrint(
        '[ClientDetailsService] Fetching client details for userId: $userId');

    try {
      final request = GraphQLRequest<String>(
        document: '''
          query GetClientDetails(\$userId: ID!) {
            getClientDetails(userId: \$userId) {
              userId
              activeMealPlanId
              allergies
              createdAt
              dailyMealsPreference
              dietaryRestrictions
              exerciseFrequency
              heightCm
              openTextPreferences
              updatedAt
              weightKg
            }
          }
        ''',
        variables: {
          'userId': userId,
        },
        decodePath: 'getClientDetails',
      );

      final response = await _amplifyGraphQL.query(request: request).response;

      if (response.hasErrors) {
        safePrint(
            '[ClientDetailsService] Error fetching client details: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        safePrint('[ClientDetailsService] No data returned for client details');
        return null;
      }

      final Map<String, dynamic>? clientData = Map<String, dynamic>.from(
          json.decode(response.data!))['getClientDetails'];

      if (clientData == null) {
        safePrint('[ClientDetailsService] Client details data is null');
        return null;
      }

      safePrint('[ClientDetailsService] Successfully fetched client details');
      return UserDetails.fromJson(clientData);
    } catch (e) {
      safePrint('[ClientDetailsService] Error fetching client details: $e');
      return null;
    }
  }

  /// Calculate BMI from height and weight
  static double? calculateBMI(double? heightCm, double? weightKg) {
    if (heightCm == null ||
        weightKg == null ||
        heightCm <= 0 ||
        weightKg <= 0) {
      return null;
    }

    final heightM = heightCm / 100.0; // Convert cm to meters
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category as a human-readable string
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25.0) {
      return 'Normal weight';
    } else if (bmi < 30.0) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  /// Format allergies list for display
  static String formatAllergies(List<AllergenEnum>? allergies) {
    if (allergies == null || allergies.isEmpty) {
      return 'None reported';
    }

    return allergies.map((allergy) => allergy.name).join(', ');
  }

  /// Format exercise frequency for display
  static String formatExerciseFrequency(ExerciseFrequency? frequency) {
    if (frequency == null) {
      return 'Not specified';
    }

    switch (frequency) {
      case ExerciseFrequency.EVERY_DAY:
        return 'Every day';
      case ExerciseFrequency.SIX_TIMES_A_WEEK:
        return '6 times a week';
      case ExerciseFrequency.FIVE_TIMES_A_WEEK:
        return '5 times a week';
      case ExerciseFrequency.FOUR_TIMES_A_WEEK:
        return '4 times a week';
      case ExerciseFrequency.THREE_TIMES_A_WEEK:
        return '3 times a week';
      case ExerciseFrequency.TWICE_A_WEEK:
        return 'Twice a week';
      case ExerciseFrequency.ONCE_A_WEEK:
        return 'Once a week';
      case ExerciseFrequency.NONE:
        return 'No exercise';
      case ExerciseFrequency.NOT_SPECIFIED:
        return 'Not specified';
    }
  }
}
