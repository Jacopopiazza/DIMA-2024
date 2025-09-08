import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';

/// Service for updating Cognito user attributes
/// This service handles direct updates to Cognito user pool attributes
class CognitoProfileService {
  final AmplifyAuth _amplifyAuth;

  CognitoProfileService({AmplifyAuth? amplifyAuth})
      : _amplifyAuth = amplifyAuth ?? AmplifyAuth();

  /// Get current user profile attributes
  Future<Map<String, String>> getUserProfileAttributes() async {
    try {
      final attributes = await _amplifyAuth.fetchUserAttributes();
      final profileAttributes = <String, String>{};

      for (final attr in attributes) {
        final key = attr.userAttributeKey.key;
        if (key == 'given_name' ||
            key == 'family_name' ||
            key == 'gender' ||
            key == 'birthdate') {
          profileAttributes[key] = attr.value;
        }
      }

      safePrint(
          '[CognitoProfileService] Fetched profile attributes: $profileAttributes');
      return profileAttributes;
    } on AuthException catch (e) {
      safePrint(
          '[CognitoProfileService] Auth error getting profile attributes: ${e.message}');
      throw e;
    } catch (e) {
      safePrint(
          '[CognitoProfileService] Unexpected error getting profile attributes: $e');
      throw e;
    }
  }

  /// Update user profile attributes
  Future<bool> updateUserProfileAttributes({
    String? gender,
    String? birthdate,
  }) async {
    try {
      safePrint(
          '[CognitoProfileService] Starting profile attributes update...');

      final attributes = <String, String>{};
      if (gender != null && gender.isNotEmpty) attributes['gender'] = gender;
      if (birthdate != null && birthdate.isNotEmpty) {
        // Basic date format validation (YYYY-MM-DD)
        final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (dateRegex.hasMatch(birthdate)) {
          attributes['birthdate'] = birthdate;
        } else {
          safePrint(
              '[CognitoProfileService] Invalid birthdate format: $birthdate');
          return false;
        }
      }

      if (attributes.isEmpty) {
        safePrint('[CognitoProfileService] No valid attributes to update');
        return true;
      }

      // For standard attributes, use predefined CognitoUserAttributeKey constants
      final cognitoAttributes = <AuthUserAttribute>[];

      if (attributes.containsKey('gender')) {
        cognitoAttributes.add(AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.gender,
          value: attributes['gender']!,
        ));
      }

      if (attributes.containsKey('birthdate')) {
        cognitoAttributes.add(AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.birthdate,
          value: attributes['birthdate']!,
        ));
      }

      safePrint(
          '[CognitoProfileService] Updating attributes: ${attributes.keys.join(', ')}');

      await _amplifyAuth.updateUserAttributes(cognitoAttributes);

      safePrint(
          '[CognitoProfileService] Successfully updated profile attributes');
      return true;
    } on AuthException catch (e) {
      safePrint(
          '[CognitoProfileService] Auth error updating profile attributes: ${e.message}');
      safePrint('[CognitoProfileService] Auth error details: ${e.toString()}');
      return false;
    } catch (e) {
      safePrint(
          '[CognitoProfileService] Unexpected error updating profile attributes: $e');
      return false;
    }
  }
}
