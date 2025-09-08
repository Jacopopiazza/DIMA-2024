import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/UserDetails/user_details_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('UserDetailsCache', () {
    group('Constructor and initialization', () {
      test('creates UserDetailsCache with default constructor', () {
        final cache = UserDetailsCache();

        expect(cache.id, Isar.autoIncrement);
        expect(cache.activeMealPlanId, isNull);
        expect(cache.allergiesJson, isNull);
        expect(cache.dailyMealsPreference, isNull);
        expect(cache.exerciseFrequencyString, isNull);
        expect(cache.heightCm, isNull);
        expect(cache.openTextPreferences, isNull);
        expect(cache.dietaryRestrictions, isNull);
        expect(cache.updatedAtString, isNull);
        expect(cache.weightKg, isNull);
      });
    });

    group('Factory constructor fromUserDetails', () {
      test('creates cache from UserDetails with all fields', () {
        final now = DateTime.now();
        final userDetails = UserDetails(
          userId: 'cache-user-123',
          activeMealPlanId: 'plan-456',
          allergies: [AllergenEnum.GLUTEN_CEREALS, AllergenEnum.MILK],
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.FIVE_TIMES_A_WEEK,
          heightCm: 175.0,
          openTextPreferences: 'I love healthy food',
          dietaryRestrictions: 'Vegetarian',
          updatedAt: TemporalDateTime.now(),
          weightKg: 70.5,
        );

        final cache = UserDetailsCache.fromUserDetails(userDetails, now);

        expect(cache.userId, 'cache-user-123');
        expect(cache.activeMealPlanId, 'plan-456');
        expect(cache.allergiesJson, ['GLUTEN_CEREALS', 'MILK']);
        expect(cache.dailyMealsPreference, 4);
        expect(cache.exerciseFrequencyString, 'FIVE_TIMES_A_WEEK');
        expect(cache.heightCm, 175.0);
        expect(cache.openTextPreferences, 'I love healthy food');
        expect(cache.dietaryRestrictions, 'Vegetarian');
        expect(cache.weightKg, 70.5);
        expect(cache.updatedAtString, isNotNull);
        expect(cache.lastFetched.isUtc, true);
      });

      test('creates cache from UserDetails with minimal fields', () {
        final fetchTime = DateTime.now();
        final userDetails = UserDetails(
          userId: 'minimal-user',
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.NOT_SPECIFIED,
          heightCm: 170.0,
          weightKg: 65.0,
        );

        final cache = UserDetailsCache.fromUserDetails(userDetails, fetchTime);

        expect(cache.userId, 'minimal-user');
        expect(cache.activeMealPlanId, isNull);
        expect(cache.allergiesJson, isNull);
        expect(cache.dailyMealsPreference, 3);
        expect(cache.exerciseFrequencyString, 'NOT_SPECIFIED');
        expect(cache.heightCm, 170.0);
        expect(cache.openTextPreferences, isNull);
        expect(cache.dietaryRestrictions, isNull);
        expect(cache.weightKg, 65.0);
        expect(cache.updatedAtString, isNull);
        expect(cache.lastFetched, fetchTime.toUtc());
      });

      test('creates cache with empty allergies list', () {
        final userDetails = UserDetails(
          userId: 'no-allergies-user',
          allergies: [],
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.ONCE_A_WEEK,
          heightCm: 160.0,
          weightKg: 55.0,
        );

        final cache =
            UserDetailsCache.fromUserDetails(userDetails, DateTime.now());

        expect(cache.allergiesJson, isEmpty);
        expect(cache.exerciseFrequencyString, 'ONCE_A_WEEK');
      });

      test('handles all exercise frequency values', () {
        final exerciseFrequencies = ExerciseFrequency.values;

        for (final frequency in exerciseFrequencies) {
          final userDetails = UserDetails(
            userId: 'exercise-test-${frequency.name}',
            dailyMealsPreference: 3,
            exerciseFrequency: frequency,
            heightCm: 170.0,
            weightKg: 70.0,
          );

          final cache =
              UserDetailsCache.fromUserDetails(userDetails, DateTime.now());
          expect(cache.exerciseFrequencyString, frequency.name);
        }
      });

      test('handles all allergen values', () {
        final allergens = AllergenEnum.values;

        for (int i = 0; i < allergens.length; i += 2) {
          final selectedAllergens =
              allergens.sublist(i, (i + 2).clamp(0, allergens.length));

          final userDetails = UserDetails(
            userId: 'allergen-test-$i',
            allergies: selectedAllergens,
            dailyMealsPreference: 3,
            exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
            heightCm: 170.0,
            weightKg: 70.0,
          );

          final cache =
              UserDetailsCache.fromUserDetails(userDetails, DateTime.now());
          expect(cache.allergiesJson,
              selectedAllergens.map((e) => e.name).toList());
        }
      });
    });

    group('toUserDetails method', () {
      test('converts cache back to UserDetails with all fields', () {
        final cache = UserDetailsCache()
          ..userId = 'convert-user-123'
          ..activeMealPlanId = 'active-plan-789'
          ..allergiesJson = ['NUTS', 'MOLLUSCS']
          ..dailyMealsPreference = 5
          ..exerciseFrequencyString = 'THREE_TIMES_A_WEEK'
          ..heightCm = 180.0
          ..openTextPreferences = 'I prefer Mediterranean cuisine'
          ..dietaryRestrictions = 'Pescatarian'
          ..updatedAtString = '2023-12-25T10:30:00.000Z'
          ..weightKg = 75.5
          ..lastFetched = DateTime.now();

        final userDetails = cache.toUserDetails();

        expect(userDetails.userId, 'convert-user-123');
        expect(userDetails.activeMealPlanId, 'active-plan-789');
        expect(userDetails.allergies?.map((e) => e.name).toList(),
            ['NUTS', 'MOLLUSCS']);
        expect(userDetails.dailyMealsPreference, 5);
        expect(userDetails.exerciseFrequency,
            ExerciseFrequency.THREE_TIMES_A_WEEK);
        expect(userDetails.heightCm, 180.0);
        expect(
            userDetails.openTextPreferences, 'I prefer Mediterranean cuisine');
        expect(userDetails.dietaryRestrictions, 'Pescatarian');
        expect(userDetails.weightKg, 75.5);
        expect(userDetails.updatedAt, isA<TemporalDateTime>());
      });

      test('converts cache with minimal fields', () {
        final cache = UserDetailsCache()
          ..userId = 'minimal-convert-user'
          ..dailyMealsPreference = 3
          ..exerciseFrequencyString = 'NOT_SPECIFIED'
          ..heightCm = 165.0
          ..weightKg = 60.0
          ..lastFetched = DateTime.now();

        final userDetails = cache.toUserDetails();

        expect(userDetails.userId, 'minimal-convert-user');
        expect(userDetails.activeMealPlanId, isNull);
        expect(userDetails.allergies, isNull);
        expect(userDetails.dailyMealsPreference, 3);
        expect(userDetails.exerciseFrequency, ExerciseFrequency.NOT_SPECIFIED);
        expect(userDetails.heightCm, 165.0);
        expect(userDetails.openTextPreferences, isNull);
        expect(userDetails.dietaryRestrictions, isNull);
        expect(userDetails.weightKg, 60.0);
        expect(userDetails.updatedAt, isNull);
      });

      test('handles unknown allergen gracefully', () {
        final cache = UserDetailsCache()
          ..userId = 'unknown-allergen-user'
          ..allergiesJson = ['GLUTEN_CEREALS', 'UNKNOWN_ALLERGEN', 'MILK']
          ..dailyMealsPreference = 3
          ..exerciseFrequencyString = 'ONCE_A_WEEK'
          ..heightCm = 170.0
          ..weightKg = 65.0
          ..lastFetched = DateTime.now();

        final userDetails = cache.toUserDetails();

        expect(userDetails.allergies?.length, 3);
        expect(userDetails.allergies?.map((e) => e.name).toList(),
            contains('GLUTEN_CEREALS'));
        expect(userDetails.allergies?.map((e) => e.name).toList(),
            contains('MILK'));
        // Unknown allergen should fallback to first enum value
        expect(
            userDetails.allergies
                ?.any((allergen) => AllergenEnum.values.first == allergen),
            true);
      });

      test('handles unknown exercise frequency gracefully', () {
        final cache = UserDetailsCache()
          ..userId = 'unknown-exercise-user'
          ..dailyMealsPreference = 4
          ..exerciseFrequencyString = 'UNKNOWN_FREQUENCY'
          ..heightCm = 175.0
          ..weightKg = 70.0
          ..lastFetched = DateTime.now();

        final userDetails = cache.toUserDetails();

        expect(userDetails.exerciseFrequency, ExerciseFrequency.NOT_SPECIFIED);
      });

      test('handles empty allergies list', () {
        final cache = UserDetailsCache()
          ..userId = 'empty-allergies-user'
          ..allergiesJson = []
          ..dailyMealsPreference = 3
          ..exerciseFrequencyString = 'ONCE_A_WEEK'
          ..heightCm = 168.0
          ..weightKg = 62.0
          ..lastFetched = DateTime.now();

        final userDetails = cache.toUserDetails();

        expect(userDetails.allergies, isEmpty);
      });
    });

    group('Round-trip conversion', () {
      test('preserves data through UserDetails -> Cache -> UserDetails', () {
        final originalUserDetails = UserDetails(
          userId: 'round-trip-user',
          activeMealPlanId: 'round-trip-plan',
          allergies: [AllergenEnum.EGGS, AllergenEnum.SOYBEANS],
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.TWICE_A_WEEK,
          heightCm: 172.0,
          openTextPreferences: 'Round trip test preferences',
          dietaryRestrictions: 'Round trip restrictions',
          updatedAt: TemporalDateTime.now(),
          weightKg: 68.5,
        );

        // Convert to cache
        final cache = UserDetailsCache.fromUserDetails(
            originalUserDetails, DateTime.now());

        // Convert back to UserDetails
        final reconstructedUserDetails = cache.toUserDetails();

        expect(reconstructedUserDetails.userId, originalUserDetails.userId);
        expect(reconstructedUserDetails.activeMealPlanId,
            originalUserDetails.activeMealPlanId);
        expect(reconstructedUserDetails.allergies?.map((e) => e.name).toList(),
            originalUserDetails.allergies?.map((e) => e.name).toList());
        expect(reconstructedUserDetails.dailyMealsPreference,
            originalUserDetails.dailyMealsPreference);
        expect(reconstructedUserDetails.exerciseFrequency,
            originalUserDetails.exerciseFrequency);
        expect(reconstructedUserDetails.heightCm, originalUserDetails.heightCm);
        expect(reconstructedUserDetails.openTextPreferences,
            originalUserDetails.openTextPreferences);
        expect(reconstructedUserDetails.dietaryRestrictions,
            originalUserDetails.dietaryRestrictions);
        expect(reconstructedUserDetails.weightKg, originalUserDetails.weightKg);
        // TemporalDateTime comparison
        expect(reconstructedUserDetails.updatedAt?.toString(),
            originalUserDetails.updatedAt?.toString());
      });

      test('preserves data with null optional fields', () {
        final originalUserDetails = UserDetails(
          userId: 'null-fields-user',
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.ONCE_A_WEEK,
          heightCm: 160.0,
          weightKg: 55.0,
        );

        final cache = UserDetailsCache.fromUserDetails(
            originalUserDetails, DateTime.now());
        final reconstructedUserDetails = cache.toUserDetails();

        expect(reconstructedUserDetails.userId, originalUserDetails.userId);
        expect(reconstructedUserDetails.activeMealPlanId, isNull);
        expect(reconstructedUserDetails.allergies, isNull);
        expect(reconstructedUserDetails.openTextPreferences, isNull);
        expect(reconstructedUserDetails.dietaryRestrictions, isNull);
        expect(reconstructedUserDetails.updatedAt, isNull);
      });
    });

    group('Cache metadata handling', () {
      test('stores fetch time in UTC', () {
        final localTime = DateTime(2023, 12, 25, 15, 30, 45);
        final userDetails = UserDetails(
          userId: 'utc-test-user',
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          heightCm: 170.0,
          weightKg: 70.0,
        );

        final cache = UserDetailsCache.fromUserDetails(userDetails, localTime);

        expect(cache.lastFetched.isUtc, true);
        expect(cache.lastFetched, localTime.toUtc());
      });

      test('handles different fetch times', () {
        final userDetails = UserDetails(
          userId: 'fetch-time-user',
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.FIVE_TIMES_A_WEEK,
          heightCm: 175.0,
          weightKg: 72.0,
        );

        final now = DateTime.now();
        final pastTime = now.subtract(Duration(hours: 2));
        final futureTime = now.add(Duration(minutes: 30));

        final cacheNow = UserDetailsCache.fromUserDetails(userDetails, now);
        final cachePast =
            UserDetailsCache.fromUserDetails(userDetails, pastTime);
        final cacheFuture =
            UserDetailsCache.fromUserDetails(userDetails, futureTime);

        expect(cacheNow.lastFetched, now.toUtc());
        expect(cachePast.lastFetched, pastTime.toUtc());
        expect(cacheFuture.lastFetched, futureTime.toUtc());
        expect(cachePast.lastFetched.isBefore(cacheNow.lastFetched), true);
        expect(cacheFuture.lastFetched.isAfter(cacheNow.lastFetched), true);
      });
    });

    group('Realistic usage scenarios', () {
      test('simulates caching workflow for fitness user', () {
        final fitnessUserDetails = UserDetails(
          userId: 'fitness-cache-user',
          activeMealPlanId: 'muscle-building-plan',
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dailyMealsPreference: 6,
          exerciseFrequency: ExerciseFrequency.SIX_TIMES_A_WEEK,
          heightCm: 180.0,
          openTextPreferences: 'High protein meals for muscle gain',
          dietaryRestrictions: 'Gluten-free, high protein',
          updatedAt: TemporalDateTime.now(),
          weightKg: 78.0,
        );

        final fetchTime = DateTime.now();
        final cache =
            UserDetailsCache.fromUserDetails(fitnessUserDetails, fetchTime);

        expect(cache.exerciseFrequencyString, 'SIX_TIMES_A_WEEK');
        expect(cache.dailyMealsPreference, 6);
        expect(cache.allergiesJson, ['GLUTEN_CEREALS']);
        expect(cache.openTextPreferences, contains('protein'));
        expect(cache.lastFetched, fetchTime.toUtc());

        final retrievedUserDetails = cache.toUserDetails();
        expect(retrievedUserDetails.exerciseFrequency,
            ExerciseFrequency.SIX_TIMES_A_WEEK);
        expect(retrievedUserDetails.dailyMealsPreference, 6);
      });

      test('simulates caching workflow for user with dietary restrictions', () {
        final restrictedUserDetails = UserDetails(
          userId: 'restricted-cache-user',
          allergies: [
            AllergenEnum.MILK,
            AllergenEnum.NUTS,
            AllergenEnum.MOLLUSCS
          ],
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.TWICE_A_WEEK,
          heightCm: 165.0,
          openTextPreferences: 'Multiple allergies, need careful meal planning',
          dietaryRestrictions:
              'Dairy-free, nut-free, shellfish-free, vegetarian',
          weightKg: 62.0,
        );

        final cache = UserDetailsCache.fromUserDetails(
            restrictedUserDetails, DateTime.now());

        expect(cache.allergiesJson, ['MILK', 'NUTS', 'MOLLUSCS']);
        expect(cache.allergiesJson?.length, 3);
        expect(cache.dietaryRestrictions, contains('vegetarian'));

        final retrievedUserDetails = cache.toUserDetails();
        expect(retrievedUserDetails.allergies?.length, 3);
        expect(retrievedUserDetails.allergies?.map((e) => e.name),
            contains('MILK'));
        expect(retrievedUserDetails.allergies?.map((e) => e.name),
            contains('NUTS'));
        expect(retrievedUserDetails.allergies?.map((e) => e.name),
            contains('MOLLUSCS'));
      });
    });

    group('Edge cases and error conditions', () {
      test('handles very large text fields', () {
        final longText = 'Very long preferences text ' * 100;
        final userDetails = UserDetails(
          userId: 'long-text-user',
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.ONCE_A_WEEK,
          heightCm: 170.0,
          openTextPreferences: longText,
          dietaryRestrictions: longText,
          weightKg: 65.0,
        );

        final cache =
            UserDetailsCache.fromUserDetails(userDetails, DateTime.now());

        expect(cache.openTextPreferences?.length, greaterThan(2500));
        expect(cache.dietaryRestrictions?.length, greaterThan(2500));

        final retrievedUserDetails = cache.toUserDetails();
        expect(retrievedUserDetails.openTextPreferences, longText);
        expect(retrievedUserDetails.dietaryRestrictions, longText);
      });

      test('handles extreme physical measurements', () {
        final extremeUserDetails = UserDetails(
          userId: 'extreme-measurements-user',
          dailyMealsPreference: 8,
          exerciseFrequency: ExerciseFrequency.FIVE_TIMES_A_WEEK,
          heightCm: 220.0, // Very tall
          weightKg: 150.0, // Very heavy
        );

        final cache = UserDetailsCache.fromUserDetails(
            extremeUserDetails, DateTime.now());

        expect(cache.heightCm, 220.0);
        expect(cache.weightKg, 150.0);

        final retrievedUserDetails = cache.toUserDetails();
        expect(retrievedUserDetails.heightCm, 220.0);
        expect(retrievedUserDetails.weightKg, 150.0);
      });

      test('validates unique userId index behavior', () {
        final userDetails1 = UserDetails(
          userId: 'duplicate-test-user',
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.ONCE_A_WEEK,
          heightCm: 160.0,
          weightKg: 55.0,
        );

        final userDetails2 = UserDetails(
          userId: 'duplicate-test-user', // Same user ID
          dailyMealsPreference: 5,
          exerciseFrequency: ExerciseFrequency.FIVE_TIMES_A_WEEK,
          heightCm: 170.0,
          weightKg: 70.0,
        );

        final cache1 =
            UserDetailsCache.fromUserDetails(userDetails1, DateTime.now());
        final cache2 =
            UserDetailsCache.fromUserDetails(userDetails2, DateTime.now());

        // Both caches should have the same userId (unique index should handle replacement)
        expect(cache1.userId, cache2.userId);
        expect(cache1.dailyMealsPreference, 3);
        expect(cache2.dailyMealsPreference, 5);
      });
    });
  });
}
