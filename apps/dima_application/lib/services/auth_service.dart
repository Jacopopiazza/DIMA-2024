import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';

class AuthService {
  final AmplifyAuth _amplifyAuth;

  AuthService({AmplifyAuth? amplifyAuth})
      : _amplifyAuth = amplifyAuth ?? AmplifyAuth();

  Future<String?> getCurrentUserIdInstance() async {
    try {
      final authSession = await _amplifyAuth.fetchAuthSession();
      if (authSession.isSignedIn) {
        final user = await _amplifyAuth.getCurrentUser();
        return user.userId;
      }
      return null;
    } catch (e) {
      safePrint('Error getting current user: $e');
      return null;
    }
  }

  static Future<String?> getCurrentUserId() {
    return AuthService().getCurrentUserIdInstance();
  }
}
