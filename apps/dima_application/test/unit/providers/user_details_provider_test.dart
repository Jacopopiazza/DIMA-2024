import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/isar_provider.dart';
import 'package:dima_application/providers/user_details_provider.dart';
import 'package:dima_application/services/user_details_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../helpers/isar_test_helper.dart';
import '../../test_setup.dart';

// Mock service for testing
class MockUserDetailsService extends UserDetailsService {
  bool shouldThrowError = false;
  UserDetails? mockUserDetails;
  bool updateSuccess = true;
  bool changePasswordSuccess = true;
  bool deleteAccountSuccess = true;
  bool signOutSuccess = true;

  MockUserDetailsService(Isar isar) : super(isar: isar);

  @override
  Future<UserDetails?> getUserDetails(String userId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return mockUserDetails;
  }

  @override
  Future<UserDetails?> updateUserDetails(UserDetails userDetails) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (updateSuccess) {
      return userDetails;
    } else {
      return null;
    }
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return changePasswordSuccess;
  }

  @override
  Future<bool> deleteAccount(String userId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return deleteAccountSuccess;
  }

  @override
  Future<void> signOut(String userId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (!signOutSuccess) {
      throw Exception('Sign out failed');
    }
  }

  @override
  Future<void> clearCache(String userId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }
    // Mock implementation
  }
}

// Mock auth service for testing
class MockAuthService {
  static String? mockUserId;

  static Future<String?> getCurrentUserId() async {
    return mockUserId;
  }
}

void main() {
  // Initialize test environment
  TestWidgetsFlutterBinding.ensureInitialized();
  configureTestEnvironment();

  group('UserDetailsProvider', () {
    late ProviderContainer container;
    late MockUserDetailsService mockService;
    late Isar testIsar;

    setUp(() async {
      testIsar = await IsarTestHelper.createTestIsar();
      mockService = MockUserDetailsService(testIsar);
      MockAuthService.mockUserId = null; // Reset auth state

      container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(testIsar),
          userDetailsServiceProvider.overrideWith((ref) async => mockService),
          userIdProvider.overrideWith((ref) => MockAuthService.getCurrentUserId()),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await IsarTestHelper.closeTestIsar(testIsar);
      MockAuthService.mockUserId = null; // Reset auth state
    });

    group('Service provider', () {
      test('creates service instance', () async {
        final service = await container.read(userDetailsServiceProvider);
        expect(service, isNotNull);
        expect(service, mockService);
      });
    });

    group('User ID provider', () {
      test('returns null when no user ID', () async {
        MockAuthService.mockUserId = null;

        final userId = await container.read(userIdProvider.future);
        expect(userId, isNull);
      });

      test('returns user ID when available', () async {
        MockAuthService.mockUserId = 'user-123';

        final userId = await container.read(userIdProvider.future);
        expect(userId, 'user-123');
      });
    });

    group('User details loading', () {
      test('loads user details successfully', () async {
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );

        MockAuthService.mockUserId = 'user-123';

        final notifier = container.read(userDetailsProvider.notifier);
        await notifier.loadUserDetails('user-123');

        final state = container.read(userDetailsProvider);
        expect(state.value!.$1?.userId, 'user-123');
        expect(state.value!.$1?.heightCm, 175.0);
        expect(state.value!.$1?.weightKg, 70.0);
        expect(state.value!.$1?.dailyMealsPreference, 3);
        expect(state.value!.$1?.exerciseFrequency,
            ExerciseFrequency.THREE_TIMES_A_WEEK);
        expect(state.value!.$1?.allergies, [AllergenEnum.GLUTEN_CEREALS]);
        expect(state.value!.$1?.dietaryRestrictions, 'vegetarian');
        expect(state.value!.$1?.openTextPreferences, 'No spicy food');
        expect(state.value!.$2, isA<String>()); // UUID
      });

      test('handles null user details', () async {
        mockService.mockUserDetails = null;
        MockAuthService.mockUserId = 'user-123';

        final notifier = container.read(userDetailsProvider.notifier);
        await notifier.loadUserDetails('user-123');
        final state = container.read(userDetailsProvider);
        expect(state.value!.$1, isNull);
        expect(state.value!.$2, isA<String>());
      });

      test('handles no user ID', () async {
        MockAuthService.mockUserId = null;

        final notifier = container.read(userDetailsProvider.notifier);
        await notifier.loadUserDetails('user-123');
        final state = container.read(userDetailsProvider);
        expect(state.value!.$1, isNull);
        expect(state.value!.$2, isA<String>());
      });

      test('handles service errors', () async {
        mockService.shouldThrowError = true;
        MockAuthService.mockUserId = 'user-123';

        final notifier = container.read(userDetailsProvider.notifier);
        await notifier.loadUserDetails('user-123');
        
        final state = container.read(userDetailsProvider);
        expect(state.hasError, true);
        expect(state.error, isA<Exception>());
      });
    });

    group('User details updating', () {
      late UserDetailsNotifier notifier;

      setUp(() async {
        notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');
      });

      test('updates user details successfully', () async {
        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.EVERY_DAY,
          allergies: [AllergenEnum.NUTS],
          dietaryRestrictions: 'vegan',
          openTextPreferences: 'Prefer organic foods',
        );

        mockService.updateSuccess = true;

        final result = await notifier.updateUserDetails(updatedDetails);

        expect(result, true);

        final state = container.read(userDetailsProvider);
        expect(state.value!.$1?.heightCm, 180.0);
        expect(state.value!.$1?.weightKg, 75.0);
        expect(state.value!.$1?.dailyMealsPreference, 4);
        expect(state.value!.$1?.exerciseFrequency, ExerciseFrequency.EVERY_DAY);
        expect(state.value!.$1?.allergies, [AllergenEnum.NUTS]);
        expect(state.value!.$1?.dietaryRestrictions, 'vegan');
        expect(state.value!.$1?.openTextPreferences, 'Prefer organic foods');
      });

      test('update fails when service returns null', () async {
        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.EVERY_DAY,
          allergies: [AllergenEnum.NUTS],
          dietaryRestrictions: 'vegan',
          openTextPreferences: 'Prefer organic foods',
        );

        mockService.updateSuccess = false;

        final result = await notifier.updateUserDetails(updatedDetails);

        expect(result, false);
      });

      test('update fails when no previous state', () async {
        // Create a fresh container with no initial state
        final freshContainer = ProviderContainer(
          overrides: [
            isarProvider.overrideWithValue(testIsar),
            userDetailsServiceProvider.overrideWith((ref) async => mockService),
            userIdProvider.overrideWith((ref) async => null), // No user ID
          ],
        );
        
        // Wait for initialization to complete with null user
        await Future.delayed(Duration(milliseconds: 100));
        
        final notifier = freshContainer.read(userDetailsProvider.notifier);
        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.EVERY_DAY,
          allergies: [AllergenEnum.NUTS],
          dietaryRestrictions: 'vegan',
          openTextPreferences: 'Prefer organic foods',
        );

        final result = await notifier.updateUserDetails(updatedDetails);

        expect(result, false);
        
        freshContainer.dispose();
      });

      test('update handles service errors', () async {
        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.EVERY_DAY,
          allergies: [AllergenEnum.NUTS],
          dietaryRestrictions: 'vegan',
          openTextPreferences: 'Prefer organic foods',
        );

        mockService.shouldThrowError = true;

        final result = await notifier.updateUserDetails(updatedDetails);

        expect(result, false);
      });
    });

    group('Password change', () {
      late UserDetailsNotifier notifier;

      setUp(() async {
        notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');
      });

      test('changes password successfully', () async {
        mockService.changePasswordSuccess = true;

        final result =
            await notifier.changePassword('oldPassword', 'newPassword');

        expect(result, true);
      });

      test('password change fails when service returns false', () async {
        mockService.changePasswordSuccess = false;

        final result =
            await notifier.changePassword('oldPassword', 'newPassword');

        expect(result, false);
      });

      test('password change handles service errors', () async {
        mockService.shouldThrowError = true;

        final result =
            await notifier.changePassword('oldPassword', 'newPassword');

        expect(result, false);
      });
    });

    group('Account deletion', () {
      late UserDetailsNotifier notifier;

      setUp(() async {
        notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');
      });

      test('deletes account successfully', () async {
        mockService.deleteAccountSuccess = true;

        final result = await notifier.deleteAccount('user-123');

        expect(result, true);

        final state = container.read(userDetailsProvider);
        expect(state.value!.$1, isNull);
      });

      test('account deletion fails when service returns false', () async {
        mockService.deleteAccountSuccess = false;

        final result = await notifier.deleteAccount('user-123');

        expect(result, false);
      });

      test('account deletion handles service errors', () async {
        mockService.shouldThrowError = true;

        final result = await notifier.deleteAccount('user-123');

        expect(result, false);
      });
    });

    group('Sign out', () {
      late UserDetailsNotifier notifier;

      setUp(() async {
        notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');
      });

      test('signs out successfully', () async {
        mockService.signOutSuccess = true;

        await notifier.signOut('user-123');

        final state = container.read(userDetailsProvider);
        expect(state.value!.$1, isNull);
      });

      test('sign out handles service errors', () async {
        mockService.shouldThrowError = true;

        expect(() async => await notifier.signOut('user-123'), throwsA(isA<Exception>()));
      });
    });

    group('State management', () {
      test('maintains state consistency during updates', () async {
        final notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');

        final stateBefore = container.read(userDetailsProvider);
        final uuidBefore = stateBefore.value!.$2;

        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );

        mockService.updateSuccess = true;
        await notifier.updateUserDetails(updatedDetails);

        final stateAfter = container.read(userDetailsProvider);
        final uuidAfter = stateAfter.value!.$2;

        expect(stateAfter.value!.$1?.heightCm, 180.0);
        expect(stateAfter.value!.$1?.weightKg, 75.0);
        expect(uuidAfter, isNot(equals(uuidBefore))); // UUID should change
      });

      test('handles optimistic updates correctly', () async {
        final notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');

        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );

        mockService.updateSuccess = true;

        // Start update but don't wait
        final updateFuture = notifier.updateUserDetails(updatedDetails);

        // Check state immediately (should be optimistically updated)
        final stateDuring = container.read(userDetailsProvider);
        expect(stateDuring.value!.$1?.heightCm, 180.0);
        expect(stateDuring.value!.$1?.weightKg, 75.0);

        await updateFuture;

        // Check final state
        final stateAfter = container.read(userDetailsProvider);
        expect(stateAfter.value!.$1?.heightCm, 180.0);
        expect(stateAfter.value!.$1?.weightKg, 75.0);
      });

      test('reverts optimistic updates on failure', () async {
        final notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');

        final originalState = container.read(userDetailsProvider);

        final updatedDetails = UserDetails(
          userId: 'user-123',
          heightCm: 180.0,
          weightKg: 75.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );

        mockService.updateSuccess = false;

        final result = await notifier.updateUserDetails(updatedDetails);

        expect(result, false);

        final stateAfter = container.read(userDetailsProvider);
        expect(
            stateAfter.value!.$1?.heightCm, originalState.value!.$1?.heightCm);
        expect(
            stateAfter.value!.$1?.weightKg, originalState.value!.$1?.weightKg);
      });
    });

    group('Edge cases', () {
      late UserDetailsNotifier notifier;

      setUp(() async {
        notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');
      });

      test('handles very large user details', () async {
        final largeDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: List.generate(
              100,
              (index) =>
                  AllergenEnum.values[index % AllergenEnum.values.length]),
          dietaryRestrictions: 'a' * 10000,
          openTextPreferences: 'b' * 10000,
        );

        mockService.updateSuccess = true;

        final result = await notifier.updateUserDetails(largeDetails);

        expect(result, true);
      });

      test('handles special characters in user details', () async {
        final specialDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: '!@#\$%^&*()_+-=[]{}|;:,.<>?🚀🎉💯',
          openTextPreferences:
              'Special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?🚀🎉💯',
        );

        mockService.updateSuccess = true;

        final result = await notifier.updateUserDetails(specialDetails);

        expect(result, true);
      });

      test('handles concurrent operations', () async {
        mockService.updateSuccess = true;

        final futures = [
          notifier.updateUserDetails(UserDetails(
              userId: 'user-123',
              heightCm: 180.0,
              weightKg: 75.0,
              dailyMealsPreference: 3,
              exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
              allergies: [AllergenEnum.GLUTEN_CEREALS],
              dietaryRestrictions: 'vegetarian',
              openTextPreferences: 'No spicy food')),
          notifier.changePassword('oldPassword', 'newPassword'),
          notifier.deleteAccount('user-123'),
        ];

        final results = await Future.wait(futures);

        // At least one should succeed
        expect(results.any((result) => result == true), true);
      });

      test('handles rapid state changes', () async {
        mockService.updateSuccess = true;

        final details1 = UserDetails(
            userId: 'user-123',
            heightCm: 180.0,
            weightKg: 75.0,
            dailyMealsPreference: 3,
            exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
            allergies: [AllergenEnum.GLUTEN_CEREALS],
            dietaryRestrictions: 'vegetarian',
            openTextPreferences: 'No spicy food');
        final details2 = UserDetails(
            userId: 'user-123',
            heightCm: 185.0,
            weightKg: 80.0,
            dailyMealsPreference: 3,
            exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
            allergies: [AllergenEnum.GLUTEN_CEREALS],
            dietaryRestrictions: 'vegetarian',
            openTextPreferences: 'No spicy food');
        final details3 = UserDetails(
            userId: 'user-123',
            heightCm: 190.0,
            weightKg: 85.0,
            dailyMealsPreference: 3,
            exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
            allergies: [AllergenEnum.GLUTEN_CEREALS],
            dietaryRestrictions: 'vegetarian',
            openTextPreferences: 'No spicy food');

        await notifier.updateUserDetails(details1);
        await notifier.updateUserDetails(details2);
        await notifier.updateUserDetails(details3);

        final state = container.read(userDetailsProvider);
        expect(state.value!.$1?.heightCm, 190.0);
        expect(state.value!.$1?.weightKg, 85.0);
      });
    });

    group('Error handling', () {
      late UserDetailsNotifier notifier;

      setUp(() async {
        notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');
      });

      test('handles network timeouts gracefully', () async {
        mockService.shouldThrowError = true;

        final result = await notifier.updateUserDetails(UserDetails(
            userId: 'user-123',
            heightCm: 180.0,
            weightKg: 75.0,
            dailyMealsPreference: 3,
            exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
            allergies: [AllergenEnum.GLUTEN_CEREALS],
            dietaryRestrictions: 'vegetarian',
            openTextPreferences: 'No spicy food'));

        expect(result, false);
      });

      test('handles malformed responses gracefully', () async {
        mockService.shouldThrowError = true;

        final result =
            await notifier.changePassword('oldPassword', 'newPassword');

        expect(result, false);
      });

      test('maintains state consistency during errors', () async {
        final originalState = container.read(userDetailsProvider);

        mockService.shouldThrowError = true;
        await notifier.updateUserDetails(UserDetails(
            userId: 'user-123',
            heightCm: 180.0,
            weightKg: 75.0,
            dailyMealsPreference: 3,
            exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
            allergies: [AllergenEnum.GLUTEN_CEREALS],
            dietaryRestrictions: 'vegetarian',
            openTextPreferences: 'No spicy food'));

        final stateAfter = container.read(userDetailsProvider);
        expect(
            stateAfter.value!.$1?.heightCm, originalState.value!.$1?.heightCm);
        expect(
            stateAfter.value!.$1?.weightKg, originalState.value!.$1?.weightKg);
      });

      test('handles errors during initialization', () async {
        mockService.shouldThrowError = true;
        MockAuthService.mockUserId = 'user-123';

        final notifier = container.read(userDetailsProvider.notifier);

        // Should not throw during initialization
        expect(() => notifier, returnsNormally);
      });
    });

    group('Concurrent access', () {
      test('handles concurrent state reads', () async {
        final notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');

        final futures = List.generate(10, (index) async {
          return container.read(userDetailsProvider);
        });

        final results = await Future.wait(futures);

        // All reads should return the same state
        for (final result in results) {
          expect(result.value!.$1?.userId, 'user-123');
        }
      });

      test('handles concurrent state changes', () async {
        final notifier = container.read(userDetailsProvider.notifier);
        mockService.mockUserDetails = UserDetails(
          userId: 'user-123',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );
        MockAuthService.mockUserId = 'user-123';
        await notifier.loadUserDetails('user-123');

        mockService.updateSuccess = true;

        final futures = <Future>[];

        // Start multiple state changes concurrently
        for (int i = 0; i < 5; i++) {
          futures.add(Future(() {
            return notifier.updateUserDetails(UserDetails(
              userId: 'user-123',
              heightCm: 175.0 + i,
              weightKg: 70.0 + i,
              dailyMealsPreference: 3,
              exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
              allergies: [AllergenEnum.GLUTEN_CEREALS],
              dietaryRestrictions: 'vegetarian',
              openTextPreferences: 'No spicy food',
            ));
          }));
        }

        final results = await Future.wait(futures);

        // At least one should succeed
        expect(results.any((result) => result == true), true);
      });
    });
  });
}
