import 'package:amplify_flutter/amplify_flutter.dart';

/// Service for updating Cognito user attributes
/// This service handles direct updates to Cognito user pool attributes
class CognitoProfileService {
  /// Updates subscription status to the specified value
  Future<bool> _updateSubscriptionStatus(String status) async {
    try {
      safePrint('[CognitoProfileService] Starting subscription update to $status...');

      final attributes = {
        'custom:subscriptionStatus': status,
      };

      final cognitoAttributes = attributes.entries.map((entry) {
        return AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.custom(
              entry.key.replaceFirst('custom:', '')),
          value: entry.value,
        );
      }).toList();

      safePrint(
          '[CognitoProfileService] Attempting to update attribute: ${cognitoAttributes.first.userAttributeKey.key} = ${cognitoAttributes.first.value}');

      await Amplify.Auth.updateUserAttributes(
        attributes: cognitoAttributes,
      );

      safePrint('[CognitoProfileService] Successfully updated subscription to $status');
      return true;
    } on AuthException catch (e) {
      safePrint('[CognitoProfileService] Auth error updating subscription: ${e.message}');
      safePrint('[CognitoProfileService] Auth error details: ${e.toString()}');
      return false;
    } catch (e) {
      safePrint('[CognitoProfileService] Unexpected error updating subscription: $e');
      return false;
    }
  }

  /// Subscribe user - changes subscription status from FREE to PRO
  Future<bool> subscribe() async => _updateSubscriptionStatus('PRO');

  /// Unsubscribe user - changes subscription status from PRO to FREE
  Future<bool> unsubscribe() async => _updateSubscriptionStatus('FREE');

  /// Get current subscription status
  /// Note: AWS Cognito normalizes custom attribute names to lowercase when retrieving them,
  /// even if they were set with mixed case (e.g., 'custom:subscriptionStatus' becomes 'custom:subscriptionstatus')
  Future<String> getSubscriptionStatus() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      safePrint(attributes
          .map((a) => '${a.userAttributeKey.key}=${a.value}')
          .join(', ')); // Debug info
      // Note: Looking for lowercase 'subscriptionstatus' because Cognito normalizes attribute names to lowercase
      final subscriptionAttribute = attributes
          .where(
            (attr) => attr.userAttributeKey.key == 'custom:subscriptionstatus',
          )
          .firstOrNull;

      if (subscriptionAttribute == null) {
        safePrint(
            '[CognitoProfileService] No subscription status found, defaulting to FREE');
        return 'FREE';
      }

      safePrint(
          '[CognitoProfileService] Current subscription status: ${subscriptionAttribute.value}');
      return subscriptionAttribute.value;
    } on AuthException catch (e) {
      safePrint(
          '[CognitoProfileService] Auth error getting subscription status: ${e.message}');
      throw e;
    } catch (e) {
      safePrint(
          '[CognitoProfileService] Unexpected error getting subscription status: $e');
      throw e;
    }
  }

  /// Get current user profile attributes
  Future<Map<String, String>> getUserProfileAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
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
    String? givenName,
    String? familyName,
    String? gender,
    String? birthdate,
  }) async {
    try {
      safePrint(
          '[CognitoProfileService] Starting profile attributes update...');

      final attributes = <String, String>{};
      // Basic validation: non-null and non-empty
      if (givenName != null && givenName.isNotEmpty) attributes['given_name'] = givenName;
      if (familyName != null && familyName.isNotEmpty) attributes['family_name'] = familyName;
      if (gender != null && gender.isNotEmpty) attributes['gender'] = gender;
      if (birthdate != null && birthdate.isNotEmpty) {
        // Basic date format validation (YYYY-MM-DD)
        final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (dateRegex.hasMatch(birthdate)) {
          attributes['birthdate'] = birthdate;
        } else {
          safePrint('[CognitoProfileService] Invalid birthdate format: $birthdate');
          return false;
        }
      }

      if (attributes.isEmpty) {
        safePrint('[CognitoProfileService] No valid attributes to update');
        return true;
      }

      // For standard attributes, use predefined CognitoUserAttributeKey constants
      final cognitoAttributes = <AuthUserAttribute>[];

      if (attributes.containsKey('given_name')) {
        cognitoAttributes.add(AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.givenName,
          value: attributes['given_name']!,
        ));
      }

      if (attributes.containsKey('family_name')) {
        cognitoAttributes.add(AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.familyName,
          value: attributes['family_name']!,
        ));
      }

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

      await Amplify.Auth.updateUserAttributes(
        attributes: cognitoAttributes,
      );

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