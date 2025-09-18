import 'package:amplify_flutter/amplify_flutter.dart';

/// Utility class for handling and formatting errors in a user-friendly way
class ErrorHandlingUtils {
  /// Formats an exception into a user-friendly error message
  static String formatErrorMessage(dynamic error) {
    if (error == null) {
      return 'An unknown error occurred';
    }

    // Handle Amplify exceptions
    if (error is AmplifyException) {
      return _formatAmplifyException(error);
    }

    // Handle generic exceptions
    if (error is Exception) {
      return _formatGenericException(error);
    }

    // Handle string errors
    if (error is String) {
      return _formatStringError(error);
    }

    // Fallback for any other type
    return 'An unexpected error occurred: ${error.toString()}';
  }

  /// Checks if an error is a subscription-related error
  static bool isSubscriptionError(dynamic error) {
    if (error == null) return false;

    final message = error.toString().toLowerCase();
    return message.contains('subscription_required') ||
        message.contains('pro subscription') ||
        message.contains('premium subscription') ||
        message.contains('upgrade required') ||
        message.contains('this feature requires a pro subscription');
  }

  /// Formats Amplify-specific exceptions
  static String _formatAmplifyException(AmplifyException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'No internet connection. Please check your network and try again.';
      case ApiException:
        final apiError = error as ApiException;
        return _formatApiException(apiError);
      case AuthException:
        return 'Authentication error. Please sign in again.';
      case StorageException:
        return 'Storage error. Please try again.';
      case AnalyticsException:
        return 'Analytics error. Please try again.';
      default:
        return 'Network error. Please check your connection and try again.';
    }
  }

  /// Formats API-specific exceptions
  static String _formatApiException(ApiException error) {
    // Check for specific error messages that indicate network issues
    final message = error.message.toLowerCase();

    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('no such host is known') ||
        message.contains('network is unreachable') ||
        message.contains('connection refused')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (message.contains('timeout') || message.contains('timed out')) {
      return 'Request timed out. Please check your connection and try again.';
    }

    if (message.contains('unauthorized') || message.contains('401')) {
      return 'Authentication expired. Please sign in again.';
    }

    if (message.contains('forbidden') || message.contains('403')) {
      return 'Access denied. Please contact support if this continues.';
    }

    if (message.contains('not found') || message.contains('404')) {
      return 'The requested resource was not found.';
    }

    if (message.contains('server error') || message.contains('500')) {
      return 'Server error. Please try again later.';
    }

    // Check for subscription-related errors
    if (message.contains('subscription_required') ||
        message.contains('pro subscription') ||
        message.contains('premium subscription') ||
        message.contains('upgrade required')) {
      return 'This feature requires a PRO subscription. Please upgrade your plan to continue.';
    }

    // Default API error message
    return 'Network error. Please check your connection and try again.';
  }

  /// Formats generic exceptions
  static String _formatGenericException(Exception error) {
    final message = error.toString().toLowerCase();

    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('no such host is known') ||
        message.contains('network is unreachable') ||
        message.contains('connection refused')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (message.contains('timeout') || message.contains('timed out')) {
      return 'Request timed out. Please check your connection and try again.';
    }

    // Check for subscription-related errors
    if (message.contains('subscription_required') ||
        message.contains('pro subscription') ||
        message.contains('premium subscription') ||
        message.contains('upgrade required') ||
        message.contains('this feature requires a pro subscription')) {
      return 'This feature requires a PRO subscription. Please upgrade your plan to continue.';
    }

    // Generic exception fallback
    return 'An error occurred. Please try again.';
  }

  /// Formats string errors
  static String _formatStringError(String error) {
    final message = error.toLowerCase();

    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('no such host is known') ||
        message.contains('network is unreachable') ||
        message.contains('connection refused')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (message.contains('timeout') || message.contains('timed out')) {
      return 'Request timed out. Please check your connection and try again.';
    }

    // Check for subscription-related errors
    if (message.contains('subscription_required') ||
        message.contains('pro subscription') ||
        message.contains('premium subscription') ||
        message.contains('upgrade required') ||
        message.contains('this feature requires a pro subscription')) {
      return 'This feature requires a PRO subscription. Please upgrade your plan to continue.';
    }

    // Check if it's a JSON error (like the one in the user's issue)
    if (message.contains('unable to send graphqlrequest to client') ||
        message.contains('unknownException')) {
      return 'No internet connection. Please check your network and try again.';
    }

    // Return the original string if it looks user-friendly
    if (message.length < 100 &&
        !message.contains('{') &&
        !message.contains('}')) {
      return error;
    }

    // Generic fallback for complex error strings
    return 'An error occurred. Please try again.';
  }

  /// Checks if an error is a network connectivity issue
  static bool isNetworkError(dynamic error) {
    if (error == null) return false;

    final message = error.toString().toLowerCase();
    return message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('no such host is known') ||
        message.contains('network is unreachable') ||
        message.contains('connection refused') ||
        message.contains('timeout') ||
        message.contains('timed out') ||
        message.contains('unable to send graphqlrequest to client');
  }

  /// Checks if an error is a temporary issue that might resolve with retry
  static bool isRetryableError(dynamic error) {
    if (error == null) return false;

    // Subscription errors are not retryable
    if (isSubscriptionError(error)) return false;

    final message = error.toString().toLowerCase();
    return isNetworkError(error) ||
        message.contains('timeout') ||
        message.contains('timed out') ||
        message.contains('server error') ||
        message.contains('500') ||
        message.contains('502') ||
        message.contains('503') ||
        message.contains('504');
  }
}
