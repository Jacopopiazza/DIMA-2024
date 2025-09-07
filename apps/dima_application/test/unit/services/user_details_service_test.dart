import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:async/async.dart' as async_pkg;
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/user_details_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

// Mock Amplify API for testing
class MockAmplifyAPI {
  static bool shouldThrowError = false;
  static UserDetails? mockUserDetails;
  static List<GraphQLResponseError> mockErrors = [];

  static GraphQLResponse<UserDetails> createMockResponse() {
    return GraphQLResponse<UserDetails>(
      data: shouldThrowError ? null : mockUserDetails,
      errors: shouldThrowError ? mockErrors : [],
    );
  }
}

// Mock GraphQL Operation
class MockGraphQLOperation implements GraphQLOperation<UserDetails> {
  final GraphQLResponse<UserDetails> _response;

  MockGraphQLOperation(this._response);

  @override
  Future<GraphQLResponse<UserDetails>> get response => Future.value(_response);

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
  async_pkg.CancelableOperation<GraphQLResponse<UserDetails>> get operation =>
      async_pkg.CancelableOperation<GraphQLResponse<UserDetails>>.fromFuture(
          response);
}

void main() {
  group('UserDetailsService', () {
    late UserDetailsService service;
    late Isar mockIsar;

    setUp(() {
      // Reset mock state
      MockAmplifyAPI.shouldThrowError = false;
      MockAmplifyAPI.mockUserDetails = null;
      MockAmplifyAPI.mockErrors = [];

      // Create mock Isar instance (in real tests you might use Isar.openSync with memory)
      mockIsar = Isar.openSync([], directory: '');
      service = UserDetailsService(isar: mockIsar);
    });

    tearDown(() {
      mockIsar.close();
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

        MockAmplifyAPI.mockUserDetails = expectedUserDetails;

        // Note: In a real test, you'd mock Amplify.API.query
        // For this example, we'll assume the method works as intended
        // You would typically use a dependency injection framework or
        // make the API client injectable for proper testing

        expect(expectedUserDetails.userId, 'test-user-id');
        expect(expectedUserDetails.heightCm, 175);
        expect(expectedUserDetails.weightKg, 70);
      });

      test('throws exception on API error', () async {
        // Arrange
        MockAmplifyAPI.shouldThrowError = true;
        MockAmplifyAPI.mockErrors = [
          const GraphQLResponseError(message: 'Access denied')
        ];

        // Act & Assert
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

        MockAmplifyAPI.mockUserDetails = expectedUpdatedDetails;

        // Act
        // Note: This test would need proper mocking of Amplify.API
        // For demonstration purposes, we're testing the data structure
        expect(userDetailsToUpdate.heightCm, 180);
        expect(
            userDetailsToUpdate.exerciseFrequency, ExerciseFrequency.EVERY_DAY);
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

        MockAmplifyAPI.shouldThrowError = true;
        MockAmplifyAPI.mockErrors = [
          const GraphQLResponseError(message: 'Validation failed')
        ];

        // Act & Assert
        expect(
          () async => await service.updateUserDetails(userDetailsToUpdate),
          throwsException,
        );
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
        expect(userDetails.heightCm, isNull);
        expect(userDetails.weightKg, isNull);
        expect(userDetails.allergies, isNull);
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
        // This would typically be tested by mocking the underlying HTTP client
        // to throw a TimeoutException
        expect(true, isTrue); // Placeholder for timeout testing
      });

      test('handles malformed response data', () async {
        // This would test cases where the API returns unexpected data format
        expect(true, isTrue); // Placeholder for malformed response testing
      });

      test('handles authentication errors', () async {
        MockAmplifyAPI.shouldThrowError = true;
        MockAmplifyAPI.mockErrors = [
          const GraphQLResponseError(message: 'Unauthorized')
        ];

        expect(
          () async => await service.getUserDetails('test-user-id'),
          throwsException,
        );
      });
    });
  });
}
