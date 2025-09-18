import 'package:dima_application/Utils/error_handling_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_setup.dart';

class CustomTestError {
  final String message;
  CustomTestError(this.message);

  @override
  String toString() => 'CustomTestError: $message';
}

void main() {
  configureTestEnvironment();

  group('ErrorHandlingUtils', () {
    group('formatErrorMessage', () {
      test('handles null error', () {
        final result = ErrorHandlingUtils.formatErrorMessage(null);
        expect(result, 'An unknown error occurred');
      });

      test('handles generic Exception', () {
        final exception = Exception('Test exception');
        final result = ErrorHandlingUtils.formatErrorMessage(exception);
        expect(result, 'An error occurred. Please try again.');
      });

      test('handles string errors', () {
        const error = 'Simple error message';
        final result = ErrorHandlingUtils.formatErrorMessage(error);
        expect(result, error);
      });

      test('handles complex string errors', () {
        const error = '{complex: json, error: message, with: many_characters}';
        final result = ErrorHandlingUtils.formatErrorMessage(error);
        expect(result, 'An error occurred. Please try again.');
      });

      test('handles network-related string errors', () {
        const networkErrors = [
          'SocketException: Failed host lookup',
          'Connection refused',
          'Network is unreachable',
          'Request timed out',
        ];

        for (final error in networkErrors) {
          final result = ErrorHandlingUtils.formatErrorMessage(error);
          expect(
              result,
              anyOf([
                contains('internet connection'),
                contains('timed out'),
              ]));
        }
      });

      test('handles subscription-related string errors', () {
        const subscriptionErrors = [
          'subscription_required',
          'pro subscription required',
          'premium subscription needed',
          'upgrade required',
          'this feature requires a pro subscription',
        ];

        for (final error in subscriptionErrors) {
          final result = ErrorHandlingUtils.formatErrorMessage(error);
          expect(result,
              'This feature requires a PRO subscription. Please upgrade your plan to continue.');
        }
      });

      test('handles GraphQL client errors', () {
        const graphqlErrors = [
          'unable to send graphqlrequest to client',
          'unknownException occurred',
        ];

        for (final error in graphqlErrors) {
          final result = ErrorHandlingUtils.formatErrorMessage(error);
          // The function may return the original string for some error formats
          expect(
              result,
              anyOf([
                'No internet connection. Please check your network and try again.',
                error, // Original error might be returned if it's user-friendly
              ]));
        }
      });

      test('handles unknown object types', () {
        final customObject = {'key': 'value'};
        final result = ErrorHandlingUtils.formatErrorMessage(customObject);
        expect(result, startsWith('An unexpected error occurred:'));
      });

      test('handles long user-friendly strings by returning generic fallback',
          () {
        final longMessage = List.filled(120, 'a').join();
        final result = ErrorHandlingUtils.formatErrorMessage(longMessage);
        expect(result, 'An error occurred. Please try again.');
      });

      test('handles timeout string precisely', () {
        const error = 'timed out while connecting';
        final result = ErrorHandlingUtils.formatErrorMessage(error);
        expect(result,
            'Request timed out. Please check your connection and try again.');
      });

      test('handles generic Exception with network keywords', () {
        final ex = Exception(
            'SocketException: Failed host lookup for api.example.com');
        final result = ErrorHandlingUtils.formatErrorMessage(ex);
        expect(result,
            'No internet connection. Please check your network and try again.');
      });
    });

    group('isSubscriptionError', () {
      test('returns false for null error', () {
        final result = ErrorHandlingUtils.isSubscriptionError(null);
        expect(result, isFalse);
      });

      test('detects subscription-related errors', () {
        const subscriptionErrors = [
          'subscription_required',
          'PRO SUBSCRIPTION needed',
          'premium subscription required',
          'Upgrade Required for this feature',
          'This feature requires a pro subscription',
        ];

        for (final error in subscriptionErrors) {
          final result = ErrorHandlingUtils.isSubscriptionError(error);
          expect(result, isTrue,
              reason: 'Failed to detect subscription error: $error');
        }
      });

      test('returns false for non-subscription errors', () {
        const nonSubscriptionErrors = [
          'Network error',
          'Authentication failed',
          'Generic exception',
          'Timeout occurred',
        ];

        for (final error in nonSubscriptionErrors) {
          final result = ErrorHandlingUtils.isSubscriptionError(error);
          expect(result, isFalse,
              reason: 'Incorrectly detected subscription error: $error');
        }
      });
    });

    group('isNetworkError', () {
      test('returns false for null error', () {
        final result = ErrorHandlingUtils.isNetworkError(null);
        expect(result, isFalse);
      });

      test('detects network-related errors', () {
        const networkErrors = [
          'SocketException: Failed host lookup',
          'Connection refused',
          'Network is unreachable',
          'Request timed out',
          'unable to send graphqlrequest to client',
          'TIMEOUT occurred',
          'No such host is known',
        ];

        for (final error in networkErrors) {
          final result = ErrorHandlingUtils.isNetworkError(error);
          expect(result, isTrue,
              reason: 'Failed to detect network error: $error');
        }
      });

      test('returns false for non-network errors', () {
        const nonNetworkErrors = [
          'Authentication failed',
          'Invalid input provided',
          'Server returned 500',
          'Subscription required',
        ];

        for (final error in nonNetworkErrors) {
          final result = ErrorHandlingUtils.isNetworkError(error);
          expect(result, isFalse,
              reason: 'Incorrectly detected network error: $error');
        }
      });
    });

    group('isRetryableError', () {
      test('returns false for null error', () {
        final result = ErrorHandlingUtils.isRetryableError(null);
        expect(result, isFalse);
      });

      test('detects retryable errors', () {
        const retryableErrors = [
          'SocketException: Failed host lookup',
          'Connection refused',
          'Request timed out',
          'Server error 500',
          'HTTP 502 Bad Gateway',
          'Service unavailable 503',
          'Gateway timeout 504',
        ];

        for (final error in retryableErrors) {
          final result = ErrorHandlingUtils.isRetryableError(error);
          expect(result, isTrue,
              reason: 'Failed to detect retryable error: $error');
        }
      });

      test('detects retryable errors for 503 and 504 explicitly', () {
        expect(ErrorHandlingUtils.isRetryableError('503'), isTrue);
        expect(ErrorHandlingUtils.isRetryableError('504'), isTrue);
      });

      test('returns false for subscription errors even if they look retryable',
          () {
        const subscriptionErrors = [
          'subscription_required timeout',
          'pro subscription network error',
        ];

        for (final error in subscriptionErrors) {
          final result = ErrorHandlingUtils.isRetryableError(error);
          expect(result, isFalse,
              reason: 'Subscription errors should not be retryable: $error');
        }
      });

      test('returns false for non-retryable errors', () {
        const nonRetryableErrors = [
          'Authentication failed 401',
          'Forbidden 403',
          'Not found 404',
          'Invalid input provided',
        ];

        for (final error in nonRetryableErrors) {
          final result = ErrorHandlingUtils.isRetryableError(error);
          expect(result, isFalse,
              reason: 'Incorrectly detected retryable error: $error');
        }
      });
    });

    group('Amplify exception handling behavior', () {
      test('formatErrorMessage handles objects with toString() method', () {
        // Test that the formatter can handle objects that override toString()
        final customError = CustomTestError('Test error message');
        final result = ErrorHandlingUtils.formatErrorMessage(customError);
        expect(result, startsWith('An unexpected error occurred:'));
        expect(result, contains('Test error message'));
      });

      test('formats generic Exception variants', () {
        final timeout = Exception('timeout occurred');
        final subscription =
            Exception('this feature requires a pro subscription');
        expect(ErrorHandlingUtils.formatErrorMessage(timeout),
            'Request timed out. Please check your connection and try again.');
        expect(ErrorHandlingUtils.formatErrorMessage(subscription),
            'This feature requires a PRO subscription. Please upgrade your plan to continue.');
      });
    });
  });
}
