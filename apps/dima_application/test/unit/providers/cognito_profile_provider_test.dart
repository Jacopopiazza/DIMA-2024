import 'package:dima_application/providers/cognito_profile_provider.dart';
import 'package:dima_application/services/cognito_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock service for testing
class MockCognitoProfileService implements CognitoProfileService {
  bool shouldThrowError = false;
  Map<String, String> mockUserAttributes = {};

  @override
  Future<Map<String, String>> getUserProfileAttributes() async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }
    return Map.from(mockUserAttributes);
  }

  @override
  Future<bool> updateUserProfileAttributes({
    String? gender,
    String? birthdate,
  }) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (gender != null) {
      mockUserAttributes['gender'] = gender;
    }
    if (birthdate != null) {
      mockUserAttributes['birthdate'] = birthdate;
    }

    return true;
  }
}

void main() {
  group('CognitoProfileProvider', () {
    late ProviderContainer container;
    late MockCognitoProfileService mockService;

    setUp(() {
      mockService = MockCognitoProfileService();
      container = ProviderContainer(
        overrides: [
          cognitoProfileServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('CognitoProfileData model', () {
      test('initializes with empty userAttributes', () {
        final data = CognitoProfileData();
        expect(data.userAttributes, isEmpty);
      });

      test('initializes with provided userAttributes', () {
        final attributes = {'gender': 'male', 'birthdate': '1990-01-01'};
        final data = CognitoProfileData(userAttributes: attributes);
        expect(data.userAttributes, attributes);
      });

      test('copyWith works correctly', () {
        final original = CognitoProfileData(
          userAttributes: {'gender': 'male', 'birthdate': '1990-01-01'},
        );

        final updated = original.copyWith(
          userAttributes: {'gender': 'female', 'email': 'test@example.com'},
        );

        expect(updated.userAttributes['gender'], 'female');
        expect(updated.userAttributes['email'], 'test@example.com');
        // copyWith completely replaces userAttributes, so 'birthdate' is not preserved
        expect(updated.userAttributes.containsKey('birthdate'), false);
      });

      test('copyWith preserves original values when null', () {
        final original = CognitoProfileData(
          userAttributes: {'gender': 'male', 'birthdate': '1990-01-01'},
        );

        final updated = original.copyWith();

        expect(updated.userAttributes, original.userAttributes);
      });

      test('toString works correctly', () {
        final data = CognitoProfileData(
          userAttributes: {'gender': 'male', 'birthdate': '1990-01-01'},
        );

        final string = data.toString();
        expect(string, contains('CognitoProfileData'));
        expect(string, contains('gender'));
        expect(string, contains('birthdate'));
      });
    });

    group('Service provider', () {
      test('creates service instance', () {
        final service = container.read(cognitoProfileServiceProvider);
        expect(service, isNotNull);
        expect(service, isA<MockCognitoProfileService>());
      });
    });

    group('Profile loading', () {
      test('loads profile successfully', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
          'email': 'test@example.com',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();
        final state = container.read(cognitoProfileProvider);

        expect(state.value?.$1.userAttributes['gender'], 'male');
        expect(state.value?.$1.userAttributes['birthdate'], '1990-01-01');
        expect(state.value?.$1.userAttributes['email'], 'test@example.com');
        expect(state.value?.$2, isA<String>()); // UUID
      });

      test('handles empty profile attributes', () async {
        mockService.mockUserAttributes = {};

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();
        final state = container.read(cognitoProfileProvider);

        expect(state.value?.$1.userAttributes, isEmpty);
        expect(state.value?.$2, isA<String>());
      });

      test('handles service errors', () async {
        mockService.shouldThrowError = true;

        final notifier = container.read(cognitoProfileProvider.notifier);
        
        // The provider doesn't throw exceptions, it stores them in the AsyncValue
        // Wait a bit for the initialization to complete
        await Future.delayed(Duration(milliseconds: 100));
        
        final state = container.read(cognitoProfileProvider);
        expect(state.hasError, true);
      });

      test('handles null attributes gracefully', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'email': 'test@example.com',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();
        final state = container.read(cognitoProfileProvider);

        expect(state.value?.$1.userAttributes['gender'], 'male');
        expect(state.value?.$1.userAttributes['email'], 'test@example.com');
        expect(state.value?.$1.userAttributes.containsKey('birthdate'), false);
      });
    });

    group('Profile updating', () {
      test('updates profile successfully', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final result = await notifier.updateUserProfileAttributes(
          gender: 'female',
          birthdate: '1995-05-15',
        );

        expect(result, true);

        final state = container.read(cognitoProfileProvider);
        expect(state.value?.$1.userAttributes['gender'], 'female');
        expect(state.value?.$1.userAttributes['birthdate'], '1995-05-15');
      });

      test('updates only gender', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final result = await notifier.updateUserProfileAttributes(
          gender: 'female',
        );

        expect(result, true);

        final state = container.read(cognitoProfileProvider);
        expect(state.value?.$1.userAttributes['gender'], 'female');
        expect(state.value?.$1.userAttributes['birthdate'], '1990-01-01');
      });

      test('updates only birthdate', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final result = await notifier.updateUserProfileAttributes(
          birthdate: '1995-05-15',
        );

        expect(result, true);

        final state = container.read(cognitoProfileProvider);
        expect(state.value?.$1.userAttributes['gender'], 'male');
        expect(state.value?.$1.userAttributes['birthdate'], '1995-05-15');
      });

      test('handles update errors', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        mockService.shouldThrowError = true;

        final result = await notifier.updateUserProfileAttributes(
          gender: 'female',
        );

        expect(result, false);
      });

      test('handles update when no previous state', () async {
        final notifier = container.read(cognitoProfileProvider.notifier);

        final result = await notifier.updateUserProfileAttributes(
          gender: 'female',
        );

        expect(result, false);
      });
    });

    group('Refresh functionality', () {
      test('refresh reloads profile', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        // Change mock data
        mockService.mockUserAttributes = {
          'gender': 'female',
          'birthdate': '1995-05-15',
        };

        await notifier.refresh();

        final state = container.read(cognitoProfileProvider);
        expect(state.value?.$1.userAttributes['gender'], 'female');
        expect(state.value?.$1.userAttributes['birthdate'], '1995-05-15');
      });
    });

    group('Derived providers', () {
      test('userProfileAttributesProvider returns attributes', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final attributes = container.read(userProfileAttributesProvider);
        expect(attributes['gender'], 'male');
        expect(attributes['birthdate'], '1990-01-01');
      });

      test('userProfileAttributesProvider returns empty map when loading', () {
        final attributes = container.read(userProfileAttributesProvider);
        expect(attributes, isEmpty);
      });

      test('isProfileLoadingProvider returns true when loading', () {
        final isLoading = container.read(isProfileLoadingProvider);
        expect(isLoading, true);
      });

      test('isProfileLoadingProvider returns false when loaded', () async {
        mockService.mockUserAttributes = {'gender': 'male'};
        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final isLoading = container.read(isProfileLoadingProvider);
        expect(isLoading, false);
      });

      test('profileErrorProvider returns error when present', () async {
        mockService.shouldThrowError = true;

        try {
          final notifier = container.read(cognitoProfileProvider.notifier);
          await notifier.loadCognitoProfile();
        } catch (e) {
          // Expected to throw
        }

        final error = container.read(profileErrorProvider);
        expect(error, isNotNull);
      });

      test('profileErrorProvider returns null when no error', () async {
        mockService.mockUserAttributes = {'gender': 'male'};
        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final error = container.read(profileErrorProvider);
        expect(error, isNull);
      });
    });

    group('Edge cases', () {
      test('handles very long attribute values', () async {
        final longValue = 'a' * 10000;
        mockService.mockUserAttributes = {
          'longAttribute': longValue,
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();
        final state = container.read(cognitoProfileProvider);

        expect(state.value?.$1.userAttributes['longAttribute'], longValue);
      });

      test('handles special characters in attributes', () async {
        mockService.mockUserAttributes = {
          'special': '!@#\$%^&*()_+-=[]{}|;:,.<>?',
          'unicode': '🚀🎉💯',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();
        final state = container.read(cognitoProfileProvider);

        expect(state.value?.$1.userAttributes['special'],
            '!@#\$%^&*()_+-=[]{}|;:,.<>?');
        expect(state.value?.$1.userAttributes['unicode'], '🚀🎉💯');
      });

      test('handles null attribute values', () async {
        mockService.mockUserAttributes = {
          'emptyValue': '',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();
        final state = container.read(cognitoProfileProvider);

        expect(state.value?.$1.userAttributes.containsKey('emptyValue'), true);
        expect(state.value?.$1.userAttributes['emptyValue'], '');
      });

      test('handles concurrent updates', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        // Start multiple concurrent updates
        final futures = [
          notifier.updateUserProfileAttributes(gender: 'female'),
          notifier.updateUserProfileAttributes(birthdate: '1995-05-15'),
          notifier.updateUserProfileAttributes(gender: 'other'),
        ];

        final results = await Future.wait(futures);

        // At least one should succeed
        expect(results.any((result) => result == true), true);
      });
    });

    group('State management', () {
      test('maintains state consistency during updates', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
          'birthdate': '1990-01-01',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        final stateBefore = container.read(cognitoProfileProvider);
        final uuidBefore = stateBefore.value?.$2;

        await notifier.updateUserProfileAttributes(gender: 'female');

        final stateAfter = container.read(cognitoProfileProvider);
        final uuidAfter = stateAfter.value?.$2;

        expect(stateAfter.value?.$1.userAttributes['gender'], 'female');
        expect(stateAfter.value?.$1.userAttributes['birthdate'], '1990-01-01');
        expect(uuidAfter, isNot(equals(uuidBefore))); // UUID should change
      });

      test('handles optimistic updates correctly', () async {
        mockService.mockUserAttributes = {
          'gender': 'male',
        };

        final notifier = container.read(cognitoProfileProvider.notifier);
        await notifier.loadCognitoProfile();

        // Start update but don't wait
        final updateFuture = notifier.updateUserProfileAttributes(
          gender: 'female',
          birthdate: '1995-05-15',
        );

        // Check state immediately (should be optimistically updated)
        final stateDuring = container.read(cognitoProfileProvider);
        expect(stateDuring.value?.$1.userAttributes['gender'], 'female');
        expect(stateDuring.value?.$1.userAttributes['birthdate'], '1995-05-15');

        await updateFuture;

        // Check final state
        final stateAfter = container.read(cognitoProfileProvider);
        expect(stateAfter.value?.$1.userAttributes['gender'], 'female');
        expect(stateAfter.value?.$1.userAttributes['birthdate'], '1995-05-15');
      });
    });
  });
}
