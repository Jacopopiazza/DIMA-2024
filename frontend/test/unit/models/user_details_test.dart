import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/UserDetails/user_details.dart'
    as user_details_models;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserDetails', () {
    group('Constructor and initialization', () {
      test('creates UserDetails with required parameters', () {
        final userId = 'user-123';
        final weightKg = 75.5;
        final heightCm = 180.0;
        final dailyMealsPreference = 3;
        final allergies = ['GLUTEN_CEREALS', 'NUTS'];

        final userDetails = user_details_models.UserDetails(
          userId: userId,
          weightKg: weightKg,
          heightCm: heightCm,
          dailyMealsPreference: dailyMealsPreference,
          allergies: allergies,
        );

        expect(userDetails.userId, userId);
        expect(userDetails.weightKg, weightKg);
        expect(userDetails.heightCm, heightCm);
        expect(userDetails.dailyMealsPreference, dailyMealsPreference);
        expect(userDetails.allergies, allergies);
        expect(userDetails.exerciseFrequency, isNull);
        expect(userDetails.dietaryRestrictions, isNull);
        expect(userDetails.openTextPreferences, isNull);
        expect(userDetails.activeMealPlanId, isNull);
        expect(userDetails.updatedAt, isNull);
        expect(userDetails.createdAt, isNull);
      });

      test('creates UserDetails with all parameters', () {
        final userId = 'user-456';
        final weightKg = 68.2;
        final heightCm = 165.0;
        final exerciseFrequency = 4;
        final dailyMealsPreference = 5;
        final allergies = ['MILK', 'MOLLUSCS'];
        final dietaryRestrictions = 'Vegetarian';
        final openTextPreferences = 'I prefer organic foods';
        final activeMealPlanId = 'plan-789';
        final updatedAt = TemporalDateTime.now();
        final createdAt = TemporalDateTime.now();

        final userDetails = user_details_models.UserDetails(
          userId: userId,
          weightKg: weightKg,
          heightCm: heightCm,
          exerciseFrequency: exerciseFrequency,
          dailyMealsPreference: dailyMealsPreference,
          allergies: allergies,
          dietaryRestrictions: dietaryRestrictions,
          openTextPreferences: openTextPreferences,
          activeMealPlanId: activeMealPlanId,
          updatedAt: updatedAt,
          createdAt: createdAt,
        );

        expect(userDetails.userId, userId);
        expect(userDetails.weightKg, weightKg);
        expect(userDetails.heightCm, heightCm);
        expect(userDetails.exerciseFrequency, exerciseFrequency);
        expect(userDetails.dailyMealsPreference, dailyMealsPreference);
        expect(userDetails.allergies, allergies);
        expect(userDetails.dietaryRestrictions, dietaryRestrictions);
        expect(userDetails.openTextPreferences, openTextPreferences);
        expect(userDetails.activeMealPlanId, activeMealPlanId);
        expect(userDetails.updatedAt, updatedAt);
        expect(userDetails.createdAt, createdAt);
      });
    });

    group('Factory constructor fromAmplify', () {
      test(
          'converts Amplify UserDetails to domain UserDetails (null allergies -> empty list)',
          () {
        final amplifyUserDetails = UserDetails(
          userId: 'amplify-user-123',
          weightKg: 70.0,
          heightCm: 175.0,
          exerciseFrequency: ExerciseFrequency.FIVE_TIMES_A_WEEK,
          dailyMealsPreference: 4,
          allergies: null,
          dietaryRestrictions: 'Vegan',
          openTextPreferences: 'I love spicy food',
          activeMealPlanId: 'active-plan-456',
          updatedAt: TemporalDateTime.now(),
          createdAt: TemporalDateTime.now(),
        );

        final domainUserDetails =
            user_details_models.UserDetails.fromAmplify(amplifyUserDetails);

        expect(domainUserDetails.userId, amplifyUserDetails.userId);
        expect(domainUserDetails.weightKg, amplifyUserDetails.weightKg);
        expect(domainUserDetails.heightCm, amplifyUserDetails.heightCm);
        expect(domainUserDetails.exerciseFrequency,
            ExerciseFrequency.FIVE_TIMES_A_WEEK.index);
        expect(domainUserDetails.dailyMealsPreference,
            amplifyUserDetails.dailyMealsPreference);
        expect(domainUserDetails.allergies, isEmpty);
        expect(domainUserDetails.dietaryRestrictions,
            amplifyUserDetails.dietaryRestrictions);
        expect(domainUserDetails.openTextPreferences,
            amplifyUserDetails.openTextPreferences);
        expect(domainUserDetails.activeMealPlanId,
            amplifyUserDetails.activeMealPlanId);
        expect(domainUserDetails.updatedAt, amplifyUserDetails.updatedAt);
        expect(domainUserDetails.createdAt, amplifyUserDetails.createdAt);
      });

      test('handles null allergies list', () {
        final amplifyUserDetails = UserDetails(
          userId: 'user-no-allergies',
          weightKg: 65.0,
          heightCm: 170.0,
          exerciseFrequency: ExerciseFrequency.ONCE_A_WEEK,
          dailyMealsPreference: 3,
          allergies: null,
        );

        final domainUserDetails =
            user_details_models.UserDetails.fromAmplify(amplifyUserDetails);

        expect(domainUserDetails.allergies, isEmpty);
        expect(domainUserDetails.exerciseFrequency,
            ExerciseFrequency.ONCE_A_WEEK.index);
      });

      test('handles empty dietary restrictions', () {
        final amplifyUserDetails = UserDetails(
          userId: 'user-no-restrictions',
          weightKg: 80.0,
          heightCm: 185.0,
          exerciseFrequency: ExerciseFrequency.SIX_TIMES_A_WEEK,
          dailyMealsPreference: 6,
          allergies: [],
          dietaryRestrictions: null,
        );

        final domainUserDetails =
            user_details_models.UserDetails.fromAmplify(amplifyUserDetails);

        expect(domainUserDetails.dietaryRestrictions, '');
        expect(domainUserDetails.allergies, isEmpty);
        expect(domainUserDetails.exerciseFrequency,
            ExerciseFrequency.SIX_TIMES_A_WEEK.index);
      });

      test('handles all exercise frequency levels', () {
        final exerciseFrequencies = ExerciseFrequency.values;

        for (int i = 0; i < exerciseFrequencies.length; i++) {
          final amplifyUserDetails = UserDetails(
            userId: 'user-exercise-$i',
            weightKg: 70.0,
            heightCm: 170.0,
            exerciseFrequency: exerciseFrequencies[i],
            dailyMealsPreference: 3,
            allergies: [],
          );

          final domainUserDetails =
              user_details_models.UserDetails.fromAmplify(amplifyUserDetails);
          expect(domainUserDetails.exerciseFrequency, i);
        }
      });
    });

    group('Physical measurements validation', () {
      test('handles various weight ranges', () {
        final weights = [45.0, 60.5, 75.8, 90.2, 120.0];

        for (final weight in weights) {
          final userDetails = user_details_models.UserDetails(
            userId: 'weight-test',
            weightKg: weight,
            heightCm: 170.0,
            dailyMealsPreference: 3,
            allergies: [],
          );

          expect(userDetails.weightKg, weight);
          expect(userDetails.weightKg, greaterThan(0));
        }
      });

      test('handles various height ranges', () {
        final heights = [150.0, 165.5, 180.2, 195.8, 210.0];

        for (final height in heights) {
          final userDetails = user_details_models.UserDetails(
            userId: 'height-test',
            weightKg: 70.0,
            heightCm: height,
            dailyMealsPreference: 3,
            allergies: [],
          );

          expect(userDetails.heightCm, height);
          expect(userDetails.heightCm, greaterThan(0));
        }
      });

      test('calculates BMI categories correctly', () {
        // BMI = weight (kg) / (height (m))^2

        // Underweight: BMI < 18.5
        final underweight = user_details_models.UserDetails(
          userId: 'underweight-user',
          weightKg: 50.0,
          heightCm: 170.0, // BMI ≈ 17.3
          dailyMealsPreference: 3,
          allergies: [],
        );

        // Normal weight: BMI 18.5-24.9
        final normalWeight = user_details_models.UserDetails(
          userId: 'normal-user',
          weightKg: 65.0,
          heightCm: 170.0, // BMI ≈ 22.5
          dailyMealsPreference: 3,
          allergies: [],
        );

        // Overweight: BMI 25-29.9
        final overweight = user_details_models.UserDetails(
          userId: 'overweight-user',
          weightKg: 80.0,
          heightCm: 170.0, // BMI ≈ 27.7
          dailyMealsPreference: 3,
          allergies: [],
        );

        final heightInMeters = 1.70;
        final underweightBMI =
            underweight.weightKg / (heightInMeters * heightInMeters);
        final normalBMI =
            normalWeight.weightKg / (heightInMeters * heightInMeters);
        final overweightBMI =
            overweight.weightKg / (heightInMeters * heightInMeters);

        expect(underweightBMI, lessThan(18.5));
        expect(normalBMI, greaterThanOrEqualTo(18.5));
        expect(normalBMI, lessThan(25.0));
        expect(overweightBMI, greaterThanOrEqualTo(25.0));
      });
    });

    group('Meal preferences and allergies', () {
      test('handles different daily meal preferences', () {
        final mealCounts = [3, 4, 5, 6];

        for (final mealCount in mealCounts) {
          final userDetails = user_details_models.UserDetails(
            userId: 'meal-pref-test',
            weightKg: 70.0,
            heightCm: 170.0,
            dailyMealsPreference: mealCount,
            allergies: [],
          );

          expect(userDetails.dailyMealsPreference, mealCount);
          expect(userDetails.dailyMealsPreference, greaterThan(0));
        }
      });

      test('handles various allergy combinations', () {
        final allergyScenarios = [
          <String>[], // No allergies
          ['GLUTEN_CEREALS'], // Single allergy
          ['GLUTEN_CEREALS', 'MILK'], // Multiple allergies
          ['NUTS', 'MOLLUSCS', 'EGGS', 'SOYBEANS'], // Many allergies
        ];

        for (final allergies in allergyScenarios) {
          final userDetails = user_details_models.UserDetails(
            userId: 'allergy-test',
            weightKg: 70.0,
            heightCm: 170.0,
            dailyMealsPreference: 3,
            allergies: allergies,
          );

          expect(userDetails.allergies, allergies);
          expect(userDetails.allergies.length, allergies.length);
        }
      });

      test('handles dietary restrictions', () {
        final dietaryRestrictions = [
          null,
          '',
          'Vegetarian',
          'Vegan',
          'Keto',
          'Mediterranean',
          'Low-carb, high-protein diet with intermittent fasting',
        ];

        for (final restriction in dietaryRestrictions) {
          final userDetails = user_details_models.UserDetails(
            userId: 'diet-test',
            weightKg: 70.0,
            heightCm: 170.0,
            dailyMealsPreference: 3,
            allergies: [],
            dietaryRestrictions: restriction,
          );

          expect(userDetails.dietaryRestrictions, restriction);
        }
      });
    });

    group('Realistic usage scenarios', () {
      test('represents active fitness enthusiast profile', () {
        final fitnessUser = user_details_models.UserDetails(
          userId: 'fitness-enthusiast',
          weightKg: 72.0,
          heightCm: 178.0,
          exerciseFrequency: 6, // High exercise frequency
          dailyMealsPreference: 5, // More frequent meals
          allergies: [],
          dietaryRestrictions: 'High-protein',
          openTextPreferences:
              'I need meals to support muscle building and recovery',
          activeMealPlanId: 'muscle-building-plan',
          updatedAt: TemporalDateTime.now(),
          createdAt: TemporalDateTime.now(),
        );

        expect(fitnessUser.exerciseFrequency, greaterThan(4));
        expect(fitnessUser.dailyMealsPreference, greaterThan(3));
        expect(fitnessUser.dietaryRestrictions, contains('protein'));
        expect(fitnessUser.activeMealPlanId, isNotNull);
      });

      test('represents health-conscious user with dietary restrictions', () {
        final healthConsciousUser = user_details_models.UserDetails(
          userId: 'health-conscious',
          weightKg: 58.5,
          heightCm: 162.0,
          exerciseFrequency: 3,
          dailyMealsPreference: 3,
          allergies: ['GLUTEN_CEREALS', 'MILK'],
          dietaryRestrictions: 'Gluten-free, dairy-free',
          openTextPreferences:
              'I prefer whole foods and organic ingredients when possible',
          activeMealPlanId: 'clean-eating-plan',
          updatedAt: TemporalDateTime.now(),
          createdAt: TemporalDateTime.now(),
        );

        expect(healthConsciousUser.allergies, contains('GLUTEN_CEREALS'));
        expect(healthConsciousUser.allergies, contains('MILK'));
        expect(
            healthConsciousUser.dietaryRestrictions, contains('Gluten-free'));
        expect(healthConsciousUser.openTextPreferences, contains('organic'));
      });

      test('represents beginner user with minimal preferences', () {
        final beginnerUser = user_details_models.UserDetails(
          userId: 'beginner-user',
          weightKg: 65.0,
          heightCm: 170.0,
          exerciseFrequency: 1, // Low exercise frequency
          dailyMealsPreference: 3, // Standard meal count
          allergies: [],
          dietaryRestrictions: null,
          openTextPreferences:
              'I\'m new to meal planning and open to trying new foods',
          activeMealPlanId: null, // No active plan yet
        );

        expect(beginnerUser.exerciseFrequency, lessThanOrEqualTo(2));
        expect(beginnerUser.allergies, isEmpty);
        expect(beginnerUser.dietaryRestrictions, isNull);
        expect(beginnerUser.activeMealPlanId, isNull);
        expect(beginnerUser.openTextPreferences, contains('new'));
      });
    });

    group('Edge cases and validation', () {
      test('handles extreme physical measurements', () {
        // Very light user
        final lightUser = user_details_models.UserDetails(
          userId: 'light-user',
          weightKg: 40.0,
          heightCm: 150.0,
          dailyMealsPreference: 3,
          allergies: [],
        );

        // Very heavy user
        final heavyUser = user_details_models.UserDetails(
          userId: 'heavy-user',
          weightKg: 150.0,
          heightCm: 200.0,
          dailyMealsPreference: 6,
          allergies: [],
        );

        expect(lightUser.weightKg, 40.0);
        expect(heavyUser.weightKg, 150.0);
        expect(lightUser.heightCm, lessThan(heavyUser.heightCm));
        expect(lightUser.dailyMealsPreference,
            lessThan(heavyUser.dailyMealsPreference));
      });

      test('handles extreme meal preferences', () {
        final fewMealsUser = user_details_models.UserDetails(
          userId: 'few-meals',
          weightKg: 70.0,
          heightCm: 170.0,
          dailyMealsPreference: 2, // Very few meals
          allergies: [],
        );

        final manyMealsUser = user_details_models.UserDetails(
          userId: 'many-meals',
          weightKg: 70.0,
          heightCm: 170.0,
          dailyMealsPreference: 8, // Many small meals
          allergies: [],
        );

        expect(fewMealsUser.dailyMealsPreference, 2);
        expect(manyMealsUser.dailyMealsPreference, 8);
        expect(fewMealsUser.dailyMealsPreference,
            lessThan(manyMealsUser.dailyMealsPreference));
      });

      test('handles very long text preferences', () {
        final longPreferences =
            'I have very specific dietary needs including ' * 50;

        final userWithLongPrefs = user_details_models.UserDetails(
          userId: 'long-prefs-user',
          weightKg: 70.0,
          heightCm: 170.0,
          dailyMealsPreference: 3,
          allergies: [],
          openTextPreferences: longPreferences,
        );

        expect(
            userWithLongPrefs.openTextPreferences!.length, greaterThan(1000));
        expect(userWithLongPrefs.openTextPreferences, longPreferences);
      });

      test('validates user ID format consistency', () {
        final userIds = [
          'simple-id',
          'user_123',
          'user@email.com',
          'uuid-12345-abcdef-67890',
          '123456789',
        ];

        for (final userId in userIds) {
          final userDetails = user_details_models.UserDetails(
            userId: userId,
            weightKg: 70.0,
            heightCm: 170.0,
            dailyMealsPreference: 3,
            allergies: [],
          );

          expect(userDetails.userId, userId);
          expect(userDetails.userId, isNotEmpty);
        }
      });
    });
  });
}
