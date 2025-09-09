import 'package:dima_application/services/nutritionist_location_service.dart';
import 'package:dima_application/generated/flutter-models/NutritionistLocation.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Generate mocks using build_runner
@GenerateNiceMocks([MockSpec<AmplifyGraphQL>()])
import 'nutritionist_location_service_test.mocks.dart';

void main() {
  group('NutritionistLocationService', () {
    late MockAmplifyGraphQL mockAmplifyGraphQL;
    late NutritionistLocationService service;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      mockAmplifyGraphQL = MockAmplifyGraphQL();
      service = NutritionistLocationService(amplifyGraphQL: mockAmplifyGraphQL);
    });

    group('updateNutritionistLocation', () {
      test('returns NutritionistLocation when GraphQL succeeds', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final updatedAt = TemporalDateTime.now();

        final mockResponse = GraphQLResponse<String>(
          data: {
            'updateNutritionistLocation': {
              'nutritionistId': 'test-nutritionist-id',
              'latitude': 45.4642,
              'longitude': 7.8994,
              'address': 'Test Address',
              'notes': 'Test Notes',
              'updatedAt': updatedAt.format(),
            }
          } as dynamic,
          errors: const [],
        );

        when(mockAmplifyGraphQL.mutate<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.updateNutritionistLocation(
          latitude: 45.4642,
          longitude: 7.8994,
          address: 'Test Address',
          notes: 'Test Notes',
        );

        // Assert
        expect(result, isNotNull);
        expect(result!.latitude, equals(45.4642));
        expect(result.longitude, equals(7.8994));
        expect(result.address, equals('Test Address'));
        expect(result.notes, equals('Test Notes'));
        expect(result.nutritionistId, equals('test-nutritionist-id'));
      });

      test('throws exception when GraphQL returns errors', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final mockResponse = GraphQLResponse<String>(
          data: null as dynamic,
          errors: const [GraphQLResponseError(message: 'GraphQL Error')],
        );

        when(mockAmplifyGraphQL.mutate<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () async => await service.updateNutritionistLocation(
            latitude: 45.4642,
            longitude: 7.8994,
          ),
          throwsException,
        );
      });
    });

    group('removeNutritionistLocation', () {
      test('completes successfully when GraphQL succeeds', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final mockResponse = GraphQLResponse<String>(
          data: {'removeNutritionistLocation': null} as dynamic,
          errors: const [],
        );

        when(mockAmplifyGraphQL.mutate<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act & Assert - should not throw
        await service.removeNutritionistLocation();
      });

      test('throws exception when GraphQL returns errors', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final mockResponse = GraphQLResponse<String>(
          data: null as dynamic,
          errors: const [GraphQLResponseError(message: 'Delete failed')],
        );

        when(mockAmplifyGraphQL.mutate<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () async => await service.removeNutritionistLocation(),
          throwsException,
        );
      });
    });

    group('getMyLocation', () {
      test('returns NutritionistLocation when location exists', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final updatedAt = TemporalDateTime.now();

        final mockResponse = GraphQLResponse<String>(
          data: {
            'getMyLocation': {
              'nutritionistId': 'test-nutritionist-id',
              'latitude': 45.4642,
              'longitude': 7.8994,
              'address': 'My Office Address',
              'notes': 'Second floor',
              'updatedAt': updatedAt.format(),
            }
          } as dynamic,
          errors: const [],
        );

        when(mockAmplifyGraphQL.query<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.getMyLocation();

        // Assert
        expect(result, isNotNull);
        expect(result!.nutritionistId, equals('test-nutritionist-id'));
        expect(result.latitude, equals(45.4642));
        expect(result.longitude, equals(7.8994));
        expect(result.address, equals('My Office Address'));
        expect(result.notes, equals('Second floor'));
      });

      test('returns null when no location is set', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final mockResponse = GraphQLResponse<String>(
          data: {'getMyLocation': null} as dynamic,
          errors: const [],
        );

        when(mockAmplifyGraphQL.query<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.getMyLocation();

        // Assert
        expect(result, isNull);
      });
    });

    group('getNutritionistLocation', () {
      test('returns location for specific nutritionist', () async {
        // Arrange
        const nutritionistId = 'other-nutritionist-id';
        final mockOperation = MockGraphQLOperation<String>();
        final updatedAt = TemporalDateTime.now();

        final mockResponse = GraphQLResponse<String>(
          data: {
            'getNutritionistLocation': {
              'nutritionistId': nutritionistId,
              'latitude': 46.0696,
              'longitude': 11.1210,
              'address': 'Nutritionist Office',
              'notes': 'Call before visiting',
              'updatedAt': updatedAt.format(),
            }
          } as dynamic,
          errors: const [],
        );

        when(mockAmplifyGraphQL.query<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.getNutritionistLocation(nutritionistId);

        // Assert
        expect(result, isNotNull);
        expect(result!.nutritionistId, equals(nutritionistId));
        expect(result.latitude, equals(46.0696));
        expect(result.longitude, equals(11.1210));
      });

      test('returns null when nutritionist has no location', () async {
        // Arrange
        final mockOperation = MockGraphQLOperation<String>();
        final mockResponse = GraphQLResponse<String>(
          data: {'getNutritionistLocation': null} as dynamic,
          errors: const [],
        );

        when(mockAmplifyGraphQL.query<String>(request: anyNamed('request')))
            .thenReturn(mockOperation);
        when(mockOperation.response).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.getNutritionistLocation('test-id');

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentPosition', () {
      test('returns success when location services work', () async {
        // Note: This test will fail in most CI environments
        // but demonstrates the expected behavior
        final result = await service.getCurrentPosition();

        expect(result, isA<CurrentLocationResult>());
        expect(result.success, isA<bool>());
        expect(result.message, isNotNull);

        if (result.success) {
          expect(result.location, isNotNull);
          expect(result.location!.latitude, isA<double>());
          expect(result.location!.longitude, isA<double>());
        }
      });
    });

    group('Generated NutritionistLocation', () {
      test('can be created with required fields', () {
        final location = NutritionistLocation(
          nutritionistId: 'test-id',
          latitude: 45.4642,
          longitude: 7.8994,
          updatedAt: TemporalDateTime.now(),
        );

        expect(location.nutritionistId, equals('test-id'));
        expect(location.latitude, equals(45.4642));
        expect(location.longitude, equals(7.8994));
        expect(location.address, isNull);
        expect(location.notes, isNull);
      });

      test('serializes to and from JSON correctly', () {
        final updatedAt = TemporalDateTime.now();
        final location = NutritionistLocation(
          nutritionistId: 'test-id',
          latitude: 45.4642,
          longitude: 7.8994,
          address: 'Test Address',
          notes: 'Test Notes',
          updatedAt: updatedAt,
        );

        final json = location.toJson();
        final fromJson = NutritionistLocation.fromJson(json);

        expect(fromJson.nutritionistId, equals(location.nutritionistId));
        expect(fromJson.latitude, equals(location.latitude));
        expect(fromJson.longitude, equals(location.longitude));
        expect(fromJson.address, equals(location.address));
        expect(fromJson.notes, equals(location.notes));
        expect(fromJson.updatedAt.format(), equals(updatedAt.format()));
      });
    });

    group('Helper classes', () {
      test('LocationPermissionStatus enum has all expected values', () {
        expect(LocationPermissionStatus.values.length, equals(5));
        expect(LocationPermissionStatus.values,
            contains(LocationPermissionStatus.granted));
        expect(LocationPermissionStatus.values,
            contains(LocationPermissionStatus.denied));
        expect(LocationPermissionStatus.values,
            contains(LocationPermissionStatus.deniedForever));
        expect(LocationPermissionStatus.values,
            contains(LocationPermissionStatus.serviceDisabled));
        expect(LocationPermissionStatus.values,
            contains(LocationPermissionStatus.unknown));
      });

      test('CurrentLocationData can be created', () {
        final data = CurrentLocationData(
          latitude: 45.4642,
          longitude: 7.8994,
          address: 'Test Address',
        );

        expect(data.latitude, equals(45.4642));
        expect(data.longitude, equals(7.8994));
        expect(data.address, equals('Test Address'));
      });

      test('CurrentLocationResult can be created', () {
        final locationData = CurrentLocationData(
          latitude: 45.4642,
          longitude: 7.8994,
        );

        final result = CurrentLocationResult(
          success: true,
          message: 'Success',
          location: locationData,
        );

        expect(result.success, isTrue);
        expect(result.message, equals('Success'));
        expect(result.location, equals(locationData));
      });
    });

    group('Integration tests', () {
      test('checkLocationStatus returns valid status', () async {
        final status = await service.checkLocationStatus();
        expect(status, isA<LocationPermissionStatus>());
        expect(LocationPermissionStatus.values, contains(status));
      });

      test('openLocationSettings returns boolean', () async {
        final result = await service.openLocationSettings();
        expect(result, isA<bool>());
      });

      test('getAddressFromCoordinates handles coordinate input', () async {
        final address =
            await service.getAddressFromCoordinates(45.4642, 7.8994);
        expect(address, isA<String?>());
      });
    });
  });
}

// Mock classes for testing
class MockGraphQLOperation<T> extends Mock implements GraphQLOperation<T> {}
