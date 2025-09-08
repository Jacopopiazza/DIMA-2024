import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class NutritionistProfileService {
  final AmplifyGraphQL _amplifyGraphQL;

  NutritionistProfileService({AmplifyGraphQL? amplifyGraphQL})
      : _amplifyGraphQL = amplifyGraphQL ?? AmplifyGraphQL();

  /// Get the authenticated nutritionist's profile
  Future<NutritionistProfile?> getMyProfile() async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          query GetMyNutritionistProfile {
            getMyNutritionistProfile {
              id
              nutritionistId
              givenName
              familyName
              specialization
              bio
              profilePictureUrl
              isAvailable
            }
          }
        ''',
        decodePath: 'getMyNutritionistProfile',
      );

      final response = await _amplifyGraphQL.query(request: request).response;

      if (response.hasErrors) {
        safePrint(
            '[NutritionistProfileService] Error loading nutritionist profile: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        return null;
      }

      final responseData = json.decode(response.data!);
      final profileData = responseData['getMyNutritionistProfile'];
      
      if (profileData == null) {
        return null;
      }

      return NutritionistProfile.fromJson(
          Map<String, dynamic>.from(profileData));
    } catch (e) {
      safePrint(
          '[NutritionistProfileService] Error loading nutritionist profile: $e');
      return null;
    }
  }

  /// Update the authenticated nutritionist's profile
  Future<NutritionistProfile?> updateMyProfile({
    required String specialization,
    required String bio,
    String? profilePictureUrl,
    required bool isAvailable,
  }) async {
    safePrint(
        '[NutritionistProfileService] Updating nutritionist profile with specialization: $specialization, bio: $bio, profilePictureUrl: $profilePictureUrl, isAvailable: $isAvailable');
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation UpdateMyNutritionistProfile(\$input: UpdateNutritionistProfileInput!) {
            updateMyNutritionistProfile(input: \$input) {
              id
              familyName
              givenName
              nutritionistId
              specialization
              bio
              profilePictureUrl
              isAvailable
            }
          }
        ''',
        variables: {
          'input': {
            'specialization': specialization,
            'bio': bio,
            'profilePictureUrl': profilePictureUrl,
            'isAvailable': isAvailable,
          }
        },
        decodePath: 'updateMyNutritionistProfile',
      );

      final response = await _amplifyGraphQL.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint(
            '[NutritionistProfileService] Error updating nutritionist profile: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        return null;
      }

      final decoded = json.decode(response.data!);
      final profileData = decoded['updateMyNutritionistProfile'];
      if (profileData == null) {
        safePrint(
            '[NutritionistProfileService] Error: updateMyNutritionistProfile returned null');
        return null;
      }
      safePrint(
          '[NutritionistProfileService] Successfully updated nutritionist profile: $profileData');
      return NutritionistProfile.fromJson(
          Map<String, dynamic>.from(profileData));
    } catch (e) {
      safePrint(
          '[NutritionistProfileService] Error updating nutritionist profile: $e');
      return null;
    }
  }

  /// Check if the nutritionist has a valid profile
  Future<bool> hasValidProfile() async {
    safePrint(
        '[NutritionistProfileService] Checking if nutritionist has a valid profile');
    final profile = await getMyProfile();
    if (profile == null) {
      safePrint('[NutritionistProfileService] No profile found');
      return false;
    }
    safePrint('[NutritionistProfileService] Retrieved profile: $profile');
    bool isProfileValid = profile.givenName != null &&
        profile.givenName!.isNotEmpty &&
        profile.familyName != null &&
        profile.familyName!.isNotEmpty &&
        profile.specialization != null &&
        profile.specialization!.isNotEmpty &&
        profile.bio != null &&
        profile.bio!.isNotEmpty;
    safePrint(
        '[NutritionistProfileService] Profile validity check: $isProfileValid');
    // Check if required fields are filled
    return isProfileValid;
  }
}
