import 'package:amplify_flutter/amplify_flutter.dart';

/// Service for updating Cognito user attributes
/// This service handles direct updates to Cognito user pool attributes
class CognitoProfileService {
  /// Subscribe user - changes subscription status from FREE to PRO
  Future<bool> subscribe() async {
    try {
      safePrint('[CognitoProfileService] Starting subscription process...');

      final attributes = {
        'custom:subscriptionStatus': 'PRO',
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

      safePrint('[CognitoProfileService] Successfully subscribed user to PRO');
      return true;
    } on AuthException catch (e) {
      safePrint('[CognitoProfileService] Auth error subscribing: ${e.message}');
      safePrint('[CognitoProfileService] Auth error details: ${e.toString()}');
      return false;
    } catch (e) {
      safePrint('[CognitoProfileService] Unexpected error subscribing: $e');
      return false;
    }
  }

  /// Unsubscribe user - changes subscription status from PRO to FREE
  Future<bool> unsubscribe() async {
    try {
      safePrint('[CognitoProfileService] Starting unsubscription process...');

      final attributes = {
        'custom:subscriptionStatus': 'FREE',
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

      safePrint(
          '[CognitoProfileService] Successfully unsubscribed user to FREE');
      return true;
    } on AuthException catch (e) {
      safePrint(
          '[CognitoProfileService] Auth error unsubscribing: ${e.message}');
      safePrint('[CognitoProfileService] Auth error details: ${e.toString()}');
      return false;
    } catch (e) {
      safePrint('[CognitoProfileService] Unexpected error unsubscribing: $e');
      return false;
    }
  }

  /// Get current subscription status
  /// Note: AWS Cognito normalizes custom attribute names to lowercase when retrieving them,
  /// even if they were set with mixed case (e.g., 'custom:subscriptionStatus' becomes 'custom:subscriptionstatus')
  Future<String?> getSubscriptionStatus() async {
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
      return null;
    } catch (e) {
      safePrint(
          '[CognitoProfileService] Unexpected error getting subscription status: $e');
      return null;
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
      return {};
    } catch (e) {
      safePrint(
          '[CognitoProfileService] Unexpected error getting profile attributes: $e');
      return {};
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

      // For now, only update given_name and family_name (standard attributes)
      final attributes = <String, String>{};
      if (givenName != null) attributes['given_name'] = givenName;
      if (familyName != null) attributes['family_name'] = familyName;
      // Note: gender and birthdate are commented out for now as they need different handling

      if (attributes.isEmpty) {
        safePrint('[CognitoProfileService] No attributes to update');
        return true;
      }

      // For standard attributes, we need to use the predefined CognitoUserAttributeKey constants
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
