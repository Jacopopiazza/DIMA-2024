import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:async/async.dart' as async_pkg;
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/user_details_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../helpers/isar_test_helper.dart';
import '../../test_setup.dart';

// Mock that extends your existing AmplifyGraphQL wrapper
class MockAmplifyGraphQL extends AmplifyGraphQL {
  static bool shouldThrowError = false;
  static UserDetails? mockUserDetails;
  static List<GraphQLResponseError> mockErrors = [];

  @override
  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) {
    if (shouldThrowError) {
      throw Exception(
          'Mock API error: ${mockErrors.isNotEmpty ? mockErrors.first.message : 'Unknown error'}');
    }

    final response = GraphQLResponse<T>(
      data: mockUserDetails as T?,
      errors: mockErrors,
    );

    return MockGraphQLOperation<T>(response);
  }

  @override
  GraphQLOperation<T> mutate<T>({required GraphQLRequest<T> request}) {
    return query<T>(request: request);
  }
}

// Mock that extends your existing AmplifyAuth wrapper
class MockAmplifyAuth extends AmplifyAuth {
  static bool shouldThrowError = false;

  @override
  Future<void> deleteUser() async {
    if (shouldThrowError) {
      throw Exception('Mock auth error');
    }
    // Don't call super.deleteUser() to avoid real Amplify call
  }

  @override
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    if (shouldThrowError) {
      throw Exception('Mock password update error');
    }
    // Don't call super.updatePassword() to avoid real Amplify call
  }

  @override
  Future<void> signOut() async {
    if (shouldThrowError) {
      throw Exception('Mock sign out error');
    }
    // Don't call super.signOut() to avoid real Amplify call
  }
}

// Mock GraphQL Operation
class MockGraphQLOperation<T> implements GraphQLOperation<T> {
  final GraphQLResponse<T> _response;

  MockGraphQLOperation(this._response);

  @override
  Future<GraphQLResponse<T>> get response => Future.value(_response);

  @override
  Future<void> cancel() async {}

  @override
  Future<void> close() async {}

  @override
  String get id => 'mock-operation';

  @override
  String get runtimeTypeName => 'MockGraphQLOperation';

  @override
  amplify_core.AWSLogger get logger =>
      amplify_core.AWSLogger().createChild('mock');

  @override
  async_pkg.CancelableOperation<GraphQLResponse<T>> get operation =>
      async_pkg.CancelableOperation<GraphQLResponse<T>>.fromFuture(response);
}

void main() {
  // Initialize test environment
  configureTestEnvironment();

  group('UserDetailsService', () {
    late UserDetailsService service;
    late Isar mockIsar;
    late MockAmplifyGraphQL mockAmplifyGraphQL;
    late MockAmplifyAuth mockAmplifyAuth;

    setUp(() async {
      // Reset mock state
      MockAmplifyGraphQL.shouldThrowError = false;
      MockAmplifyGraphQL.mockUserDetails = null;
      MockAmplifyGraphQL.mockErrors = [];
      MockAmplifyAuth.shouldThrowError = false;

      // Create in-memory Isar instance for testing
      mockIsar = await IsarTestHelper.createTestIsar();

      // Create mock instances
      mockAmplifyGraphQL = MockAmplifyGraphQL();
      mockAmplifyAuth = MockAmplifyAuth();

      // Create service with mocked Amplify dependencies
      service = UserDetailsService(
        isar: mockIsar,
        amplifyGraphQL: mockAmplifyGraphQL,
        amplifyAuth: mockAmplifyAuth,
      );
    });

    tearDown(() async {
      await IsarTestHelper.closeTestIsar(mockIsar);
    });

    group('getUserDetails', () {
      test('returns user details on successful API call', () async {
        // Arrange
        final expectedUserDetails = UserDetails(
          userId: 'test-user-id',
          heightCm: 175,
          weightKg: 70,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
          allergies: [AllergenEnum.GLUTEN_CEREALS],
          dietaryRestrictions: 'vegetarian',
          openTextPreferences: 'No spicy food',
        );

        MockAmplifyGraphQL.mockUserDetails = expectedUserDetails;

        // Act
        final result = await service.getUserDetails('test-user-id');

        // Assert
        expect(result, isNotNull);
        expect(result!.userId, 'test-user-id');
        expect(result.heightCm, 175);
        expect(result.weightKg, 70);
        expect(result.exerciseFrequency, ExerciseFrequency.THREE_TIMES_A_WEEK);
        expect(result.allergies, contains(AllergenEnum.GLUTEN_CEREALS));
        expect(result.dietaryRestrictions, 'vegetarian');
        expect(result.openTextPreferences, 'No spicy food');
      });

      test('throws exception on API error', () async {
        // Arrange - Mock GraphQL should throw an error
        MockAmplifyGraphQL.shouldThrowError = true;
        MockAmplifyGraphQL.mockErrors = [
          const GraphQLResponseError(message: 'Access denied')
        ];

        // Act & Assert - The service should rethrow the exception from the mock
        expect(
          () async => await service.getUserDetails('test-user-id'),
          throwsException,
        );
      });
    });

    group('updateUserDetails', () {
      test('updates user details successfully', () async {
        // Arrange
        final userDetailsToUpdate = UserDetails(
          userId: 'test-user-id',
          heightCm: 180,
          weightKg: 75,
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.EVERY_DAY,
          allergies: [AllergenEnum.NUTS],
          dietaryRestrictions: 'vegan',
          openTextPreferences: 'Prefer organic foods',
        );

        final expectedUpdatedDetails = UserDetails(
          userId: 'test-user-id',
          heightCm: 180,
          weightKg: 75,
          dailyMealsPreference: 4,
          exerciseFrequency: ExerciseFrequency.EVERY_DAY,
          allergies: [AllergenEnum.NUTS],
          dietaryRestrictions: 'vegan',
          openTextPreferences: 'Prefer organic foods',
        );

        MockAmplifyGraphQL.mockUserDetails = expectedUpdatedDetails;

        // Act
        final result = await service.updateUserDetails(userDetailsToUpdate);

        // Assert
        expect(result, isNotNull);
        expect(result!.userId, 'test-user-id');
        expect(result.heightCm, 180);
        expect(result.weightKg, 75);
        expect(result.exerciseFrequency, ExerciseFrequency.EVERY_DAY);
        expect(result.allergies, contains(AllergenEnum.NUTS));
        expect(result.dietaryRestrictions, 'vegan');
        expect(result.openTextPreferences, 'Prefer organic foods');
      });

      test('handles update failure gracefully', () async {
        // Arrange
        final userDetailsToUpdate = UserDetails(
          userId: 'test-user-id',
          heightCm: 180,
          weightKg: 75,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.THREE_TIMES_A_WEEK,
        );

        MockAmplifyGraphQL.shouldThrowError = false;
        MockAmplifyGraphQL.mockUserDetails =
            null; // Service should return null on failure

        // Act
        final result = await service.updateUserDetails(userDetailsToUpdate);

        // Assert
        expect(result, isNull);
      });
    });

    group('data validation', () {
      test('handles null values correctly', () {
        final userDetails = UserDetails(
          userId: 'test-user-id',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.NOT_SPECIFIED,
          allergies: null,
          dietaryRestrictions: null,
          openTextPreferences: null,
        );

        expect(userDetails.userId, 'test-user-id');
        expect(userDetails.heightCm, 175.0);
        expect(userDetails.weightKg, 70.0);
        expect(userDetails.allergies, isNull);
        expect(userDetails.dietaryRestrictions, isNull);
        expect(userDetails.openTextPreferences, isNull);
      });

      test('handles empty collections correctly', () {
        final userDetails = UserDetails(
          userId: 'test-user-id',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.NOT_SPECIFIED,
          allergies: [],
          dietaryRestrictions: null,
        );

        expect(userDetails.allergies, isEmpty);
        expect(userDetails.dietaryRestrictions, isNull);
      });

      test('validates enum values correctly', () {
        final userDetails = UserDetails(
          userId: 'test-user-id',
          heightCm: 175.0,
          weightKg: 70.0,
          dailyMealsPreference: 3,
          exerciseFrequency: ExerciseFrequency.ONCE_A_WEEK,
          allergies: [AllergenEnum.MILK, AllergenEnum.EGGS],
        );

        expect(userDetails.exerciseFrequency, ExerciseFrequency.ONCE_A_WEEK);
        expect(userDetails.allergies, hasLength(2));
        expect(userDetails.allergies, contains(AllergenEnum.MILK));
        expect(userDetails.allergies, contains(AllergenEnum.EGGS));
      });
    });

    group('error scenarios', () {
      test('handles network timeout', () async {
        // Arrange - Mock GraphQL should throw a timeout-like error
        MockAmplifyGraphQL.shouldThrowError = true;
        MockAmplifyGraphQL.mockErrors = [
          const GraphQLResponseError(message: 'Network timeout')
        ];

        // Act & Assert
        expect(
          () async => await service.getUserDetails('test-user-id'),
          throwsException,
        );
      });

      test('handles malformed response data', () async {
        // Arrange - Set up a response with null data but no errors (malformed case)
        MockAmplifyGraphQL.shouldThrowError = false;
        MockAmplifyGraphQL.mockUserDetails = null;
        MockAmplifyGraphQL.mockErrors = []; // No errors but also no data

        // Act
        final result = await service.getUserDetails('test-user-id');

        // Assert - Service should handle this gracefully by returning null
        expect(result, isNull);
      });

      test('handles authentication errors', () async {
        MockAmplifyGraphQL.shouldThrowError = true;
        MockAmplifyGraphQL.mockErrors = [
          const GraphQLResponseError(message: 'Unauthorized')
        ];

        expect(
          () async => await service.getUserDetails('test-user-id'),
          throwsException,
        );
      });
    });

    group('deleteAccount', () {
      test('deletes account successfully', () async {
        // Arrange
        MockAmplifyAuth.shouldThrowError = false;

        // Act
        final result = await service.deleteAccount('test-user-id');

        // Assert
        expect(result, isTrue);
      });

      test('handles deletion failure', () async {
        // Arrange
        MockAmplifyAuth.shouldThrowError = true;

        // Act
        final result = await service.deleteAccount('test-user-id');

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
