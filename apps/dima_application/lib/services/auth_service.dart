import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService {
  static Future<String?> getCurrentUserId() async {
    try {
      final authSession = await Amplify.Auth.fetchAuthSession();
      if (authSession.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        return user.userId;
      }
      return null;
    } catch (e) {
      safePrint('Error getting current user: $e');
      return null;
    }
  }
} 