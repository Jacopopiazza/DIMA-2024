import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/UserDetails/user_details_cache.dart';
import 'package:isar/isar.dart';

class UserDetailsService {
  final Isar isar;
  static const Duration _cacheValidityDuration = Duration(hours: 24);

  UserDetailsService({required this.isar});

  // Get user details from API
  Future<UserDetails?> getUserDetails(String userId) async {
    safePrint('[UserDetailsService] Fetching user details for userId: $userId');
    try {
      final request = GraphQLRequest<UserDetails>(
        document: '''
        query MyQuery {
            getUserDetails {
                activeMealPlanId
                dailyMealsPreference
                allergies
                exerciseFrequency
                heightCm
                openTextPreferences
                targetCalories
                updatedAt
                userId
                weightKg
            }
        }
        ''',
        decodePath: 'getUserDetails',
        modelType:
            ModelProvider.instance.getModelTypeByModelName('UserDetails'),
      );

      final response = await Amplify.API.query(request: request).response;
      final userDetails = response.data;
      safePrint(
          '[UserDetailsService] Successfully fetched user details: $userDetails');

      if (userDetails != null) {
        safePrint(
            '[UserDetailsService] Caching user details for userId: ${userDetails.userId}');
        await _cacheUserDetails(userDetails);
      }

      return userDetails;
    } catch (e) {
      safePrint('[UserDetailsService] Error fetching user details: $e');
      return await getCachedUserDetails(userId);
    }
  }

  Future<UserDetails?> updateUserDetails(UserDetails userDetails) async {
    safePrint(
        '[UserDetailsService] Updating user details for userId: ${userDetails.userId}');

    // Construct the input map based on your GraphQL schema's UpdateUserDetailsInput.
    // Only include fields that you want to update.
    // For null values, you might either omit them or explicitly send null depending on your backend's handling.
    // Note: For enums like AllergenEnum and ExerciseFrequency, you might need to convert them
    // to their string representation, e.g., userDetails.exerciseFrequency?.name
    final Map<String, dynamic> input = {
      // userId is not part of the UpdateUserDetailsInput itself,
      // but typically the backend uses the authenticated user's ID.
      // If your mutation requires userId in the input for some reason, add it here.
      // Based on your schema, it seems userId is handled by @primaryKey and @aws_auth,
      // so it's likely inferred from the authenticated user.
      // If you need to send it explicitly, ensure your GraphQL schema's Input type includes it.
      // For this example, we assume userId is *not* part of the 'input' object.
      // For update operations, you generally don't send the primary key in the input.

      if (userDetails.allergies != null)
        'allergies': userDetails.allergies!
            .map((e) => e.name)
            .toList(), // Convert enum list to string list
      if (userDetails.dailyMealsPreference != null)
        'dailyMealsPreference': userDetails.dailyMealsPreference,
      // If dietaryRestrictions is part of the UserDetails model and updateable:
      // if (userDetails.dietaryRestrictions != null)
      //   'dietaryRestrictions': userDetails.dietaryRestrictions,
      if (userDetails.exerciseFrequency != null)
        'exerciseFrequency':
            userDetails.exerciseFrequency!.name, // Convert enum to string
      if (userDetails.heightCm != null) 'heightCm': userDetails.heightCm,
      if (userDetails.openTextPreferences != null)
        'openTextPreferences': userDetails.openTextPreferences,
      if (userDetails.targetCalories != null)
        'targetCalories': userDetails.targetCalories,
      if (userDetails.weightKg != null) 'weightKg': userDetails.weightKg,
    };

    try {
      final request = GraphQLRequest<UserDetails>(
        document: '''
        mutation UpdateUserDetails(\$input: UpdateUserDetailsInput!) {
          updateUserDetails(input: \$input) {
            activeMealPlanId
            allergies
            dailyMealsPreference
            exerciseFrequency
            heightCm
            openTextPreferences
            targetCalories
            updatedAt
            userId
            weightKg
          }
        }
      ''',
        variables: {'input': input}, // Pass the input map as a variable
        decodePath:
            'updateUserDetails', // Path to the data in the GraphQL response
        modelType:
            ModelProvider.instance.getModelTypeByModelName('UserDetails'),
      );

      final response = await Amplify.API.mutate(request: request).response;
      final updatedUserDetails = response.data;

      if (response.hasErrors) {
        safePrint(
            '[UserDetailsService] Errors during update: ${response.errors}');
        // Handle GraphQL errors, e.g., show a user-friendly message
        return null;
      }

      safePrint(
          '[UserDetailsService] Successfully updated user details: $updatedUserDetails');

      // Optionally, you might want to update your cache after a successful mutation
      if (updatedUserDetails != null) {
        await _cacheUserDetails(updatedUserDetails);
      }

      return updatedUserDetails;
    } on ApiException catch (e) {
      safePrint('[UserDetailsService] Failed to update user details: $e');
      // Handle API exceptions (network issues, unauthorized, etc.)
      return null;
    } catch (e) {
      safePrint('[UserDetailsService] An unexpected error occurred: $e');
      return null;
    }
  }

  // Delete account
  Future<bool> deleteAccount(String userId) async {
    safePrint('[UserDetailsService] Deleting account for userId: $userId');
    try {
      final userDetails = await getUserDetails(userId);
      if (userDetails != null) {
        final request = ModelMutations.delete(userDetails);
        await Amplify.API.mutate(request: request).response;
        await clearCache(userId);
        return true;
      }
      return false;
    } catch (e) {
      safePrint('[UserDetailsService] Error deleting account: $e');
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    safePrint('[UserDetailsService] Changing password for user');
    try {
      await Amplify.Auth.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      safePrint('[UserDetailsService] Error changing password: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut(String userId) async {
    safePrint('[UserDetailsService] Signing out for userId: $userId');
    try {
      await Amplify.Auth.signOut();
      await clearCache(userId);
    } catch (e) {
      safePrint('[UserDetailsService] Error signing out: $e');
    }
  }

  // Cache operations
  Future<void> _cacheUserDetails(UserDetails userDetails) async {
    safePrint(
        '[UserDetailsService] Caching user details for userId: ${userDetails.userId}');
    final cache = UserDetailsCache.fromUserDetails(userDetails, DateTime.now());

    await isar.writeTxn(() async {
      await isar.userDetailsCaches.put(cache);
    });
  }

  Future<UserDetails?> getCachedUserDetails(String userId) async {
    safePrint(
        '[UserDetailsService] Getting cached user details for userId: $userId');
    try {
      final cache = await isar.userDetailsCaches
          .where()
          .userIdEqualTo(userId)
          .findFirst();

      return cache?.toUserDetails();
    } catch (e) {
      safePrint('[UserDetailsService] Error reading cached user details: $e');
      return null;
    }
  }

  Future<void> clearCache(String userId) async {
    safePrint('[UserDetailsService] Clearing cache for userId: $userId');
    await isar.writeTxn(() async {
      await isar.userDetailsCaches.where().userIdEqualTo(userId).deleteAll();
    });
  }
}
