import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class NutritionistProfileService {
  /// Get the authenticated nutritionist's profile
  Future<NutritionistProfile?> getMyProfile() async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          query GetMyNutritionistProfile {
            getMyNutritionistProfile {
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

      final response = await Amplify.API.query(request: request).response;
      
      if (response.hasErrors) {
        safePrint('Error loading nutritionist profile: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        return null;
      }

      final Map<String, dynamic> profileData = 
          Map<String, dynamic>.from(json.decode(response.data!));
      
      // Map nutritionistId to id for the generated model
      final processedData = Map<String, dynamic>.from(profileData);
      processedData['id'] = processedData['nutritionistId'];
      
      return NutritionistProfile.fromJson(processedData);
    } catch (e) {
      safePrint('Error loading nutritionist profile: $e');
      return null;
    }
  }

  /// Update the authenticated nutritionist's profile
  Future<NutritionistProfile?> updateMyProfile({
    required String givenName,
    required String familyName,
    required String specialization,
    required String bio,
    String? profilePictureUrl,
    required bool isAvailable,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation UpdateMyNutritionistProfile(\$input: UpdateNutritionistProfileInput!) {
            updateMyNutritionistProfile(input: \$input) {
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
        variables: {
          'input': {
            'givenName': givenName,
            'familyName': familyName,
            'specialization': specialization,
            'bio': bio,
            'profilePictureUrl': profilePictureUrl,
            'isAvailable': isAvailable,
          }
        },
        decodePath: 'updateMyNutritionistProfile',
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint('Error updating nutritionist profile: ${response.errors}');
        return null;
      }

      if (response.data == null) {
        return null;
      }

      final Map<String, dynamic> profileData = 
          Map<String, dynamic>.from(json.decode(response.data!));
      
      // Map nutritionistId to id for the generated model
      final processedData = Map<String, dynamic>.from(profileData);
      processedData['id'] = processedData['nutritionistId'];
      
      return NutritionistProfile.fromJson(processedData);
    } catch (e) {
      safePrint('Error updating nutritionist profile: $e');
      return null;
    }
  }

  /// Check if the nutritionist has a valid profile
  Future<bool> hasValidProfile() async {
    final profile = await getMyProfile();
    if (profile == null) {
      return false;
    }
    
    // Check if required fields are filled
    return profile.givenName != null && 
           profile.givenName!.isNotEmpty &&
           profile.familyName != null && 
           profile.familyName!.isNotEmpty &&
           profile.specialization != null && 
           profile.specialization!.isNotEmpty &&
           profile.bio != null && 
           profile.bio!.isNotEmpty;
  }
} 