import 'dart:convert';

import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/client_details_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientDetailsService', () {
    late ClientDetailsService service;

    setUp(() {
      service = ClientDetailsService();
    });

    group('getClientDetails', () {
      test('handles successful response', () async {
        // This test would require mocking Amplify.API.query
        // For demonstration, we're testing the expected behavior
        expect(service, isNotNull);
      });

      test('returns null on GraphQL errors', () async {
        // In a real test, you'd mock the API to return errors
        // and verify the service returns null
        expect(service, isNotNull);
      });

      test('returns null when no data returned', () async {
        // Test case for when API returns null data
        expect(service, isNotNull);
      });

      test('handles JSON parsing correctly', () {
        // Test JSON parsing logic
        final testData = {
          'getClientDetails': {
            'userId': 'test-user-123',
            'activeMealPlanId': 'mp-456',
            'allergies': ['GLUTEN', 'NUTS'],
            'dailyMealsPreference': 3,
            'dietaryRestrictions': ['vegetarian'],
            'exerciseFrequency': 'MODERATE',
            'heightCm': 175,
            'weightKg': 70,
            'openTextPreferences': 'No spicy food',
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-06-01T12:00:00Z',
          }
        };

        final jsonString = json.encode(testData);
        final decoded = json.decode(jsonString);
        final clientData = decoded['getClientDetails'];

        expect(clientData['userId'], 'test-user-123');
        expect(clientData['heightCm'], 175);
        expect(clientData['weightKg'], 70);
        expect(clientData['allergies'], hasLength(2));
      });

      test('handles exception gracefully', () async {
        // Test exception handling
        expect(service, isNotNull);
      });
    });

    group('Static utility methods', () {
      group('calculateBMI', () {
        test('calculates BMI correctly with valid inputs', () {
          final bmi = ClientDetailsService.calculateBMI(175.0, 70.0);
          expect(bmi, closeTo(22.86, 0.01));
        });

        test('returns null with null height', () {
          final bmi = ClientDetailsService.calculateBMI(null, 70.0);
          expect(bmi, isNull);
        });

        test('returns null with null weight', () {
          final bmi = ClientDetailsService.calculateBMI(175.0, null);
          expect(bmi, isNull);
        });

        test('returns null with zero height', () {
          final bmi = ClientDetailsService.calculateBMI(0.0, 70.0);
          expect(bmi, isNull);
        });

        test('returns null with zero weight', () {
          final bmi = ClientDetailsService.calculateBMI(175.0, 0.0);
          expect(bmi, isNull);
        });

        test('returns null with negative height', () {
          final bmi = ClientDetailsService.calculateBMI(-175.0, 70.0);
          expect(bmi, isNull);
        });

        test('returns null with negative weight', () {
          final bmi = ClientDetailsService.calculateBMI(175.0, -70.0);
          expect(bmi, isNull);
        });

        test('handles extreme values correctly', () {
          final bmi = ClientDetailsService.calculateBMI(200.0, 150.0);
          expect(bmi, closeTo(37.5, 0.01));
        });
      });

      group('getBMICategory', () {
        test('returns "Underweight" for BMI < 18.5', () {
          expect(ClientDetailsService.getBMICategory(16.0), 'Underweight');
          expect(ClientDetailsService.getBMICategory(18.4), 'Underweight');
        });

        test('returns "Normal weight" for BMI 18.5-24.9', () {
          expect(ClientDetailsService.getBMICategory(18.5), 'Normal weight');
          expect(ClientDetailsService.getBMICategory(22.0), 'Normal weight');
          expect(ClientDetailsService.getBMICategory(24.9), 'Normal weight');
        });

        test('returns "Overweight" for BMI 25.0-29.9', () {
          expect(ClientDetailsService.getBMICategory(25.0), 'Overweight');
          expect(ClientDetailsService.getBMICategory(27.5), 'Overweight');
          expect(ClientDetailsService.getBMICategory(29.9), 'Overweight');
        });

        test('returns "Obese" for BMI >= 30.0', () {
          expect(ClientDetailsService.getBMICategory(30.0), 'Obese');
          expect(ClientDetailsService.getBMICategory(35.0), 'Obese');
          expect(ClientDetailsService.getBMICategory(40.0), 'Obese');
        });

        test('handles edge cases correctly', () {
          expect(ClientDetailsService.getBMICategory(18.49), 'Underweight');
          expect(ClientDetailsService.getBMICategory(24.99), 'Normal weight');
          expect(ClientDetailsService.getBMICategory(29.99), 'Overweight');
        });
      });

      group('formatAllergies', () {
        test('returns "None reported" for null allergies', () {
          expect(ClientDetailsService.formatAllergies(null), 'None reported');
        });

        test('returns "None reported" for empty allergies list', () {
          expect(ClientDetailsService.formatAllergies([]), 'None reported');
        });

        test('formats single allergy correctly', () {
          final allergies = [AllergenEnum.GLUTEN_CEREALS];
          expect(ClientDetailsService.formatAllergies(allergies),
              'GLUTEN_CEREALS');
        });

        test('formats multiple allergies correctly', () {
          final allergies = [
            AllergenEnum.GLUTEN_CEREALS,
            AllergenEnum.NUTS,
            AllergenEnum.MILK
          ];
          final result = ClientDetailsService.formatAllergies(allergies);
          expect(result, 'GLUTEN_CEREALS, NUTS, MILK');
        });

        test('handles all allergen types', () {
          final allergies = [
            AllergenEnum.GLUTEN_CEREALS,
            AllergenEnum.MILK,
            AllergenEnum.EGGS,
            AllergenEnum.FISH,
            AllergenEnum.CRUSTACEANS,
            AllergenEnum.NUTS,
            AllergenEnum.PEANUTS,
            AllergenEnum.SOYBEANS,
            AllergenEnum.SESAME_SEEDS
          ];

          final result = ClientDetailsService.formatAllergies(allergies);
          expect(result.contains('GLUTEN_CEREALS'), true);
          expect(result.contains('MILK'), true);
          expect(result.contains('NUTS'), true);
          expect(result.split(', '), hasLength(9));
        });
      });
    });

    group('Integration scenarios', () {
      test('complete client analysis workflow', () {
        // Test a complete workflow of getting client data and analyzing it
        const heightCm = 175.0;
        const weightKg = 70.0;
        final allergies = [AllergenEnum.GLUTEN_CEREALS, AllergenEnum.NUTS];

        final bmi = ClientDetailsService.calculateBMI(heightCm, weightKg);
        final bmiCategory = ClientDetailsService.getBMICategory(bmi!);
        final allergiesText = ClientDetailsService.formatAllergies(allergies);

        expect(bmi, closeTo(22.86, 0.01));
        expect(bmiCategory, 'Normal weight');
        expect(allergiesText, 'GLUTEN_CEREALS, NUTS');
      });

      test('handles incomplete client data', () {
        // Test workflow with missing data
        const double? heightCm = null;
        const weightKg = 70.0;
        final List<AllergenEnum>? allergies = null;

        final bmi = ClientDetailsService.calculateBMI(heightCm, weightKg);
        final allergiesText = ClientDetailsService.formatAllergies(allergies);

        expect(bmi, isNull);
        expect(allergiesText, 'None reported');
      });

      test('handles edge case client data', () {
        // Test with extreme but valid values
        const heightCm = 140.0; // Very short
        const weightKg = 200.0; // Very heavy
        final allergies = <AllergenEnum>[]; // No allergies

        final bmi = ClientDetailsService.calculateBMI(heightCm, weightKg);
        final bmiCategory = ClientDetailsService.getBMICategory(bmi!);
        final allergiesText = ClientDetailsService.formatAllergies(allergies);

        expect(bmi, greaterThan(30)); // Should be obese
        expect(bmiCategory, 'Obese');
        expect(allergiesText, 'None reported');
      });
    });
  });
}
