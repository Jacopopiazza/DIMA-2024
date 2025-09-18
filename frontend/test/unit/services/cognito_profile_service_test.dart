import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';
import 'package:dima_application/services/cognito_profile_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_setup.dart';
import 'cognito_profile_service_test.mocks.dart';

@GenerateMocks([AmplifyAuth])
void main() {
  configureTestEnvironment();

  group('CognitoProfileService', () {
    late CognitoProfileService cognitoProfileService;
    late MockAmplifyAuth mockAmplifyAuth;

    setUp(() {
      mockAmplifyAuth = MockAmplifyAuth();
      cognitoProfileService =
          CognitoProfileService(amplifyAuth: mockAmplifyAuth);
    });

    group('Constructor', () {
      test('creates instance with provided AmplifyAuth', () {
        final service = CognitoProfileService(amplifyAuth: mockAmplifyAuth);
        expect(service, isNotNull);
        expect(service, isA<CognitoProfileService>());
      });

      test('creates instance with default AmplifyAuth when none provided', () {
        final service = CognitoProfileService();
        expect(service, isNotNull);
        expect(service, isA<CognitoProfileService>());
      });
    });

    group('getUserProfileAttributes', () {
      test('successfully fetches and filters profile attributes', () async {
        final mockAttributes = [
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.givenName,
            value: 'John',
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.familyName,
            value: 'Doe',
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.gender,
            value: 'male',
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.birthdate,
            value: '1990-01-01',
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.email,
            value: 'john.doe@example.com',
          ),
        ];

        when(mockAmplifyAuth.fetchUserAttributes())
            .thenAnswer((_) async => mockAttributes);

        final result = await cognitoProfileService.getUserProfileAttributes();

        expect(result, {
          'given_name': 'John',
          'family_name': 'Doe',
          'gender': 'male',
          'birthdate': '1990-01-01',
        });
        verify(mockAmplifyAuth.fetchUserAttributes()).called(1);
      });

      test('returns empty map when no profile attributes exist', () async {
        final mockAttributes = [
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.email,
            value: 'john.doe@example.com',
          ),
        ];

        when(mockAmplifyAuth.fetchUserAttributes())
            .thenAnswer((_) async => mockAttributes);

        final result = await cognitoProfileService.getUserProfileAttributes();

        expect(result, isEmpty);
        verify(mockAmplifyAuth.fetchUserAttributes()).called(1);
      });

      test('handles AuthException and rethrows', () async {
        when(mockAmplifyAuth.fetchUserAttributes())
            .thenThrow(const SignedOutException('Auth error'));

        expect(
          () async => await cognitoProfileService.getUserProfileAttributes(),
          throwsA(isA<SignedOutException>()),
        );

        verify(mockAmplifyAuth.fetchUserAttributes()).called(1);
      });

      test('handles generic exception and rethrows', () async {
        when(mockAmplifyAuth.fetchUserAttributes())
            .thenThrow(Exception('Generic error'));

        expect(
          () async => await cognitoProfileService.getUserProfileAttributes(),
          throwsA(isA<Exception>()),
        );

        verify(mockAmplifyAuth.fetchUserAttributes()).called(1);
      });
    });

    group('updateUserProfileAttributes', () {
      test('successfully updates gender and birthdate', () async {
        when(mockAmplifyAuth.updateUserAttributes(any))
            .thenAnswer((_) async => {});

        final result = await cognitoProfileService.updateUserProfileAttributes(
          gender: 'female',
          birthdate: '1995-05-15',
        );

        expect(result, isTrue);
        verify(mockAmplifyAuth.updateUserAttributes(any)).called(1);
      });

      test('successfully updates only gender', () async {
        when(mockAmplifyAuth.updateUserAttributes(any))
            .thenAnswer((_) async => {});

        final result = await cognitoProfileService.updateUserProfileAttributes(
          gender: 'male',
        );

        expect(result, isTrue);
        verify(mockAmplifyAuth.updateUserAttributes(any)).called(1);
      });

      test('successfully updates only birthdate', () async {
        when(mockAmplifyAuth.updateUserAttributes(any))
            .thenAnswer((_) async => {});

        final result = await cognitoProfileService.updateUserProfileAttributes(
          birthdate: '2000-12-31',
        );

        expect(result, isTrue);
        verify(mockAmplifyAuth.updateUserAttributes(any)).called(1);
      });

      test('returns true when no attributes to update', () async {
        final result =
            await cognitoProfileService.updateUserProfileAttributes();

        expect(result, isTrue);
        verifyNever(mockAmplifyAuth.updateUserAttributes(any));
      });

      test('returns true when empty string attributes provided', () async {
        final result = await cognitoProfileService.updateUserProfileAttributes(
          gender: '',
          birthdate: '',
        );

        expect(result, isTrue);
        verifyNever(mockAmplifyAuth.updateUserAttributes(any));
      });

      test('returns false for invalid birthdate format', () async {
        final result = await cognitoProfileService.updateUserProfileAttributes(
          gender: 'male',
          birthdate: 'invalid-date',
        );

        expect(result, isFalse);
        verifyNever(mockAmplifyAuth.updateUserAttributes(any));
      });

      test('validates birthdate format correctly', () async {
        when(mockAmplifyAuth.updateUserAttributes(any))
            .thenAnswer((_) async => {});

        final validFormats = ['1990-01-01', '2000-12-31', '1985-06-15'];
        for (final date in validFormats) {
          final result =
              await cognitoProfileService.updateUserProfileAttributes(
            birthdate: date,
          );
          expect(result, isTrue);
        }

        final invalidFormats = [
          '90-01-01',
          '1990-1-1',
          '1990/01/01',
          '01-01-1990'
        ];
        for (final date in invalidFormats) {
          final result =
              await cognitoProfileService.updateUserProfileAttributes(
            birthdate: date,
          );
          expect(result, isFalse);
        }
      });

      test('handles AuthException and returns false', () async {
        when(mockAmplifyAuth.updateUserAttributes(any))
            .thenThrow(const SignedOutException('Auth error'));

        final result = await cognitoProfileService.updateUserProfileAttributes(
          gender: 'male',
        );

        expect(result, isFalse);
        verify(mockAmplifyAuth.updateUserAttributes(any)).called(1);
      });

      test('handles generic exception and returns false', () async {
        when(mockAmplifyAuth.updateUserAttributes(any))
            .thenThrow(Exception('Generic error'));

        final result = await cognitoProfileService.updateUserProfileAttributes(
          gender: 'female',
        );

        expect(result, isFalse);
        verify(mockAmplifyAuth.updateUserAttributes(any)).called(1);
      });
    });
  });
}
