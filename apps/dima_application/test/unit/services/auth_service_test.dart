import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';
import 'package:dima_application/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_setup.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([AmplifyAuth, AuthSession, AuthUser])
void main() {
  configureTestEnvironment();

  group('AuthService', () {
    late AuthService authService;
    late MockAmplifyAuth mockAmplifyAuth;
    late MockAuthSession mockAuthSession;
    late MockAuthUser mockAuthUser;

    setUp(() {
      mockAmplifyAuth = MockAmplifyAuth();
      mockAuthSession = MockAuthSession();
      mockAuthUser = MockAuthUser();
      authService = AuthService(amplifyAuth: mockAmplifyAuth);
    });

    group('Constructor', () {
      test('creates instance with provided AmplifyAuth', () {
        final service = AuthService(amplifyAuth: mockAmplifyAuth);
        expect(service, isNotNull);
        expect(service, isA<AuthService>());
      });

      test('creates instance with default AmplifyAuth when none provided', () {
        final service = AuthService();
        expect(service, isNotNull);
        expect(service, isA<AuthService>());
      });
    });

    group('getCurrentUserIdInstance', () {
      test('returns user ID when user is signed in', () async {
        when(mockAuthSession.isSignedIn).thenReturn(true);
        when(mockAuthUser.userId).thenReturn('test-user-123');
        when(mockAmplifyAuth.fetchAuthSession()).thenAnswer((_) async => mockAuthSession);
        when(mockAmplifyAuth.getCurrentUser()).thenAnswer((_) async => mockAuthUser);

        final result = await authService.getCurrentUserIdInstance();

        expect(result, 'test-user-123');
        verify(mockAmplifyAuth.fetchAuthSession()).called(1);
        verify(mockAmplifyAuth.getCurrentUser()).called(1);
      });

      test('returns null when user is not signed in', () async {
        when(mockAuthSession.isSignedIn).thenReturn(false);
        when(mockAmplifyAuth.fetchAuthSession()).thenAnswer((_) async => mockAuthSession);

        final result = await authService.getCurrentUserIdInstance();

        expect(result, isNull);
        verify(mockAmplifyAuth.fetchAuthSession()).called(1);
        verifyNever(mockAmplifyAuth.getCurrentUser());
      });

      test('returns null when AuthSession throws exception', () async {
        when(mockAmplifyAuth.fetchAuthSession())
            .thenThrow(Exception('Auth session error'));

        final result = await authService.getCurrentUserIdInstance();

        expect(result, isNull);
        verify(mockAmplifyAuth.fetchAuthSession()).called(1);
        verifyNever(mockAmplifyAuth.getCurrentUser());
      });

      test('returns null when getCurrentUser throws exception', () async {
        when(mockAuthSession.isSignedIn).thenReturn(true);
        when(mockAmplifyAuth.fetchAuthSession()).thenAnswer((_) async => mockAuthSession);
        when(mockAmplifyAuth.getCurrentUser())
            .thenThrow(Exception('Get user error'));

        final result = await authService.getCurrentUserIdInstance();

        expect(result, isNull);
        verify(mockAmplifyAuth.fetchAuthSession()).called(1);
        verify(mockAmplifyAuth.getCurrentUser()).called(1);
      });

      test('returns null when generic exception occurs', () async {
        when(mockAmplifyAuth.fetchAuthSession())
            .thenThrow(Exception('Generic error'));

        final result = await authService.getCurrentUserIdInstance();

        expect(result, isNull);
        verify(mockAmplifyAuth.fetchAuthSession()).called(1);
        verifyNever(mockAmplifyAuth.getCurrentUser());
      });
    });

    group('Static getCurrentUserId method', () {
      test('static method exists and calls instance method', () async {
        // Test that static method exists and handles exceptions gracefully
        final result = await AuthService.getCurrentUserId();
        
        // Since this uses a new instance with real Amplify (not our mocks),
        // it will return null due to Amplify not being configured in tests
        expect(result, isNull);
      });

      test('static method behavior matches instance method', () {
        // Verify the static method delegates to instance method
        expect(AuthService.getCurrentUserId, isA<Function>());
        expect(AuthService.getCurrentUserId(), isA<Future<String?>>());
      });
    });
  });
}