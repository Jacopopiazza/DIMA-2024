import 'dart:async'; // Import for TimeoutException
import 'dart:convert';
import 'dart:io'; // Import for SocketException

import 'package:amplify_flutter/amplify_flutter.dart';
// Make sure ModelProvider is correctly generated and imported
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
// Import domain/Amplify models
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
// Import Isar cache models
import 'package:dima_application/models/UserDetails/user_details_cache.dart'; // Isar model
// Import input models
import 'package:dima_application/models/input/update_user_details_input.dart';
// Import Isar provider
import 'package:dima_application/providers/isar_provider.dart'; // Adjust path if needed
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// --- Custom Exception Classes ---

/// Base class for API Service related exceptions.
class ApiServiceException implements Exception {
  final String message;
  final dynamic underlyingException;
  ApiServiceException(this.message, {this.underlyingException});

  @override
  String toString() =>
      'ApiServiceException: $message ${underlyingException != null ? "\nUnderlying: $underlyingException" : ""}';
}

/// Exception for network-related errors (connection, timeout, etc.).
class NetworkException extends ApiServiceException {
  NetworkException(String message, {dynamic underlyingException})
      : super(message, underlyingException: underlyingException);
}

/// Exception when the backend indicates a requested Plan ID was not found.
class PlanNotFoundException extends ApiServiceException {
  final String planId;
  PlanNotFoundException(this.planId, {dynamic underlyingException})
      : super("Meal plan with ID '$planId' not found.",
            underlyingException: underlyingException);
}

/// Exception for errors reported by the API (GraphQL errors, etc.).
class ApiExceptionWrapper extends ApiServiceException {
  final List<GraphQLResponseError>? errors;
  ApiExceptionWrapper(String message,
      {this.errors, dynamic underlyingException})
      : super(message, underlyingException: underlyingException);

  @override
  String toString() {
    final errorDetails = errors?.map((e) => e.message).join('; ') ?? 'N/A';
    return 'ApiExceptionWrapper: $message\nGraphQL Errors: $errorDetails ${underlyingException != null ? "\nUnderlying: $underlyingException" : ""}';
  }
}

/// Exception when network fails and no cache is available.
class CacheMissException extends ApiServiceException {
  CacheMissException(String message, {dynamic underlyingException})
      : super(message, underlyingException: underlyingException);
}

/// Exception when network fails and cache is expired or invalid.
/// Includes the stale data (as a domain model) if found.
class CacheExpiredException extends ApiServiceException {
  /// The stale data found in the cache, converted to the domain model.
  /// This might be null if conversion fails or cache was unexpectedly empty.
  final MealPlan? staleData;

  CacheExpiredException(String message,
      {this.staleData, dynamic underlyingException})
      : super(message, underlyingException: underlyingException);
}

/// Exception for failed operations like updates.
class OperationFailedException extends ApiServiceException {
  OperationFailedException(String message, {dynamic underlyingException})
      : super(message, underlyingException: underlyingException);
}

// --- API Service Provider ---

/// Provider that creates and exposes the ApiService instance
final apiServiceProvider = Provider<ApiService>((ref) {
  final isar = ref.read(isarProvider);
  return ApiService(isar);
});

// --- API Service Implementation ---

/// Service responsible for API operations and local caching.
class ApiService {
  final Isar _isar;
  static const Duration _cacheValidityDuration = Duration(hours: 24);

  ApiService(this._isar);

  // --- UserDetails Methods ---

  Future<UserDetails> updateMyUserDetails(
      UpdateUserDetailsInput updateUserDetailsInput) async {
    safePrint("[APIService] Updating UserDetails via API...");
    try {
      // --- TODO: Replace with actual Amplify GraphQL Mutation ---
      await Future.delayed(
          const Duration(milliseconds: 300)); // Simulate network
      final mockUserId = 'mockUserId'; // Replace with actual user ID logic
      final updatedDetails = UserDetails(
        userId: mockUserId,
        weightKg: updateUserDetailsInput.weightKg,
        heightCm: updateUserDetailsInput.heightCm,
        exerciseFrequency: updateUserDetailsInput.exerciseFrequency,
        dailyMealsPreference: updateUserDetailsInput.dailyMealsPreference,
        allergies: updateUserDetailsInput.allergies,
        openTextPreferences: updateUserDetailsInput.openTextPreferences,
        targetCalories: updateUserDetailsInput.targetCalories,
        updatedAt: TemporalDateTime.now(),
        // createdAt should be set on creation or fetched
      );
      // --- End Mock ---

      safePrint("[APIService] NETWORK: Update successful. Updating cache.");
      final cacheEntry =
          UserDetailsCache.fromUserDetails(updatedDetails, DateTime.now());
      await _saveUserDetailsToCache(cacheEntry);
      return updatedDetails;
    } on ApiException catch (e) {
      safePrint("[APIService] API Error updating user details: ${e.message}");
      throw ApiExceptionWrapper("API error during UserDetails update",
          underlyingException: e);
    } on SocketException catch (e) {
      safePrint("[APIService] Network error updating user details: $e");
      throw NetworkException("Network error during UserDetails update",
          underlyingException: e);
    } catch (e, stackTrace) {
      safePrint("[APIService] Failed to update user details: $e\n$stackTrace");
      throw OperationFailedException("Failed to update UserDetails",
          underlyingException: e);
    }
  }

  Future<UserDetails> getMyUserDetails({bool forceRefresh = false}) async {
    // (Keep the implementation from the previous version - it doesn't need changes for stale MealPlan data)
    safePrint(
        "[APIService] Fetching user details (forceRefresh: $forceRefresh) - Network First...");
    final now = DateTime.now();

    try {
      safePrint(
          "[APIService] NETWORK: Attempting to fetch user details from AppSync...");
      // --- TODO: Replace with actual Amplify GraphQL Query ---
      final operation = Amplify.API.query(
        request: GraphQLRequest<UserDetails>(
          document: '''
            query GetMyUserDetails {
              getMyUserDetails {
                id
                userId
                weightKg
                heightCm
                exerciseFrequency
                dailyMealsPreference
                allergies
                dietaryRestrictions
                openTextPreferences
                targetCalories
                activeMealPlanId
                updatedAt
                createdAt
              }
            }
          ''',
          modelType:
              ModelProvider.instance.getModelTypeByModelName('UserDetails'),
          decodePath: 'getMyUserDetails',
        ),
      );
      final response = await operation.response;
      final fetchedDetails = response.data;
      // --- End API Call ---

      if (response.hasErrors || fetchedDetails == null) {
        throw ApiExceptionWrapper("GraphQL query for UserDetails failed",
            errors: response.errors);
      }

      safePrint(
          "[APIService] NETWORK: Success. Saving user details to Isar cache.");
      final cacheEntry = UserDetailsCache.fromUserDetails(fetchedDetails, now);
      await _saveUserDetailsToCache(cacheEntry);
      return fetchedDetails;
    } catch (e) {
      safePrint(
          "[APIService] Network/API Error encountered fetching UserDetails: $e");
      if (forceRefresh) {
        safePrint(
            "[APIService] FORCE REFRESH: Network failed, rethrowing error (UserDetails).");
        // Rethrow appropriate wrapped exception
        _handleForceRefreshError(e); // Helper to avoid repetition
      }

      // Attempt Fallback
      safePrint("[APIService] CACHE FALLBACK: Trying UserDetails from Isar...");
      final UserDetailsCache? cachedDetails = await _isar.userDetailsCaches
          .where()
          .sortByLastFetchedDesc()
          .findFirst();

      if (cachedDetails != null) {
        if (_isUserDetailsCacheValid(cachedDetails, now)) {
          safePrint(
              "[APIService] CACHE HIT (Fallback): Returning valid cached UserDetails.");
          return cachedDetails.toUserDetails();
        } else {
          safePrint(
              "[APIService] CACHE STALE (Fallback): UserDetails cache expired.");
          // Here we throw CacheExpiredException, but without stale data, as requested for UserDetails.
          // Modify if stale UserDetails data should also be included in its exception.
          throw CacheExpiredException(
              "Network failed and local UserDetails cache is expired.",
              underlyingException: e);
        }
      } else {
        safePrint(
            "[APIService] CACHE MISS (Fallback): No cached UserDetails found.");
        throw CacheMissException(
            "Failed to fetch UserDetails and no cache available.",
            underlyingException: e);
      }
    }
  }

  // --- Meal Plan Methods ---

  Future<String?> getChosenPlanId() async {
    // (Keep the implementation from the previous version)
    safePrint("[APIService] Getting chosen plan ID (via getMyUserDetails)...");
    try {
      // MOCKED IMPLEMENTATION
      return 'mock_plan_from_gemini_output';

      final userDetails = await getMyUserDetails();
      return userDetails.activeMealPlanId;
    } catch (e, stackTrace) {
      safePrint("[APIService] Failed to get chosen plan ID: $e\n$stackTrace");
      return null;
    }
  }

  Future<MealPlan> fetchMealPlan(String planId,
      {bool forceRefresh = false}) async {
    safePrint(
        "[APIService] Fetching meal plan (ID: $planId, forceRefresh: $forceRefresh) - Network First...");
    final now = TemporalDateTime.now();

    // 1. Try fetching from network
    try {
      safePrint(
          "[APIService] NETWORK: Attempting to fetch plan $planId from source...");
      // --- TODO: Replace MOCK fetch with actual Amplify GraphQL query ---
      final MealPlan fetchedAmplifyPlan =
          await _fetchAmplifyPlanFromNetworkMock(planId, now);
      // --- End Mock / API Call ---

      safePrint(
          "[APIService] NETWORK: Success. Saving plan $planId to Isar cache.");

      // Convert & Save to Cache
      final MealPlanCache isarPlan =
          MealPlanCache.fromAmplify(fetchedAmplifyPlan);
      await _savePlanToCache(isarPlan);

      // Return the fresh domain model
      // Note: If using the mock, toMealPlan might need createdAt/updatedAt from fetchTime
      return isarPlan
          .toMealPlan(); // Assuming toMealPlan correctly creates the domain model
    } on PlanNotFoundException catch (e) {
      safePrint("[APIService] Plan with id $planId not found.\n$e");
      rethrow; // Rethrow the specific exception
    } catch (e) {
      safePrint(
          "[APIService] Network/API Error encountered for plan $planId: $e");

      // Handle forceRefresh first
      if (forceRefresh) {
        safePrint(
            "[APIService] FORCE REFRESH: Network failed for plan $planId, rethrowing error.");
        _handleForceRefreshError(e); // Use helper
      }

      // Determine error type for logging
      _logNetworkOrApiError(e, planId);

      // 3. Fallback to cache (only if forceRefresh is false)
      safePrint(
          "[APIService] CACHE FALLBACK: Trying to load plan $planId from Isar...");
      final MealPlanCache? cachedPlan = await _getCachedPlan(planId);

      if (cachedPlan != null) {
        if (_isMealPlanCacheValid(cachedPlan, now)) {
          // This path should ideally not be hit often if network succeeds,
          // but handles cases where network fails but cache is still valid.
          safePrint(
              "[APIService] CACHE HIT (Fallback - Valid): Returning valid cached plan $planId.");
          return cachedPlan.toMealPlan();
        } else {
          // *** Cache is STALE ***
          safePrint(
              "[APIService] CACHE STALE (Fallback): Cached plan $planId is expired. Last fetched: ${cachedPlan.lastFetched}");
          // *** MODIFICATION: Throw exception WITH the stale data ***
          throw CacheExpiredException(
              "Network failed and local cache for plan $planId is expired.",
              staleData:
                  cachedPlan.toMealPlan(), // Include stale data (domain model)
              underlyingException: e // Include original error context
              );
        }
      } else {
        // *** Cache MISS ***
        safePrint(
            "[APIService] CACHE MISS (Fallback): No cached plan found for $planId.");
        throw CacheMissException(
            "Failed to fetch plan $planId and no cache available.",
            underlyingException: e); // Include original error context
      }
    }
  }

  Future<MealPlanList> fetchAllMealPlansForUser(String userId) async {
    // TODO: Implement actual Amplify GraphQL query
    safePrint("[APIService] Fetching all meal plans for user...");
    try {
      // MOCKED IMPLEMENTATION
      return MealPlanList(currentMealPlan: null, allMealPlans: []);
    } catch (e) {
      safePrint("[APIService] Error fetching all meal plans for user: $e");
      throw OperationFailedException("Failed to fetch all meal plans for user",
          underlyingException: e);
    }
  }

  Future<void> setChosenPlanId(String mealPlanId) async {
    // TODO: Implement actual Amplify GraphQL mutation
    safePrint("[APIService] Setting chosen plan ID: $mealPlanId");
  }

  Future<void> deleteMealPlan(String mealPlanId) async {
    // TODO: Implement actual Amplify GraphQL mutation
    safePrint("[APIService] Deleting meal plan: $mealPlanId");
  }

  // --- Private Helper Methods ---

  void _handleForceRefreshError(dynamic e) {
    if (e is ApiException) {
      throw ApiExceptionWrapper("API error during forced refresh",
          underlyingException: e);
    } else if (e is SocketException || e is TimeoutException) {
      throw NetworkException("Network error during forced refresh",
          underlyingException: e);
    } else if (e is ApiServiceException) {
      // Catch already wrapped ones
      throw e; // Rethrow as is
    } else {
      throw NetworkException("Operation failed during forced refresh",
          underlyingException: e);
    }
  }

  void _logNetworkOrApiError(dynamic e, String contextId) {
    bool isNetworkOrApiError = e is ApiException ||
        e is ApiExceptionWrapper ||
        e is SocketException ||
        e is TimeoutException;
    if (isNetworkOrApiError) {
      safePrint(
          "[APIService] NETWORK/API ERROR: Confirmed issue for ID $contextId ($e). Attempting cache fallback...");
    } else {
      safePrint(
          "[APIService] UNEXPECTED ERROR for ID $contextId: $e. Attempting cache fallback...");
      // Consider logging stackTrace here in debug/dev environments: safePrint(stackTrace);
    }
  }

  // --- User Details Cache Helpers ---
  bool _isUserDetailsCacheValid(UserDetailsCache cachedDetails, DateTime now) {
    return now.difference(cachedDetails.lastFetched) < _cacheValidityDuration;
  }

  Future<void> _saveUserDetailsToCache(UserDetailsCache detailsCache) async {
    await _isar.writeTxn(() async {
      await _isar.userDetailsCaches.clear(); // Assumes single user cache
      await _isar.userDetailsCaches.put(detailsCache);
    });
    safePrint(
        "[Isar] Saved/Updated UserDetailsCache for user ${detailsCache.userId}.");
  }

  // --- Meal Plan Cache Helpers ---
  bool _isMealPlanCacheValid(MealPlanCache cachedPlan, TemporalDateTime now) {
    final lastFetched = cachedPlan.lastFetched;
    if (lastFetched == null) return false;
    // Use DateTime comparison for duration. Ensure timezone consistency.
    // Use the helper extension if defined elsewhere, or direct conversion.
    try {
      // TemporalDateTime's compareTo might be suitable, or convert both to UTC DateTime
      return now.getDateTimeInUtc().difference(lastFetched.getDateTimeInUtc()) <
          _cacheValidityDuration;
    } catch (e) {
      safePrint("[APIService] Error comparing TemporalDateTime: $e");
      return false; // Treat comparison error as invalid
    }
  }

  Future<MealPlanCache?> _getCachedPlan(String planId) async {
    // Requires MealPlanCache to have @Index on mealPlanId
    return await _isar.mealPlanCaches
        .filter()
        .mealPlanIdEqualTo(planId)
        .findFirst();
  }

  /// Clears the locally cached UserDetails entry from Isar.
  Future<void> clearLocalUserDetailsCache() async {
    safePrint("[APIService] Clearing local UserDetailsCache from Isar...");
    try {
      await _isar.writeTxn(() async {
        // Assuming you only ever store one UserDetailsCache entry
        // If you might store multiple, you'd need a filter here.
        await _isar.userDetailsCaches.clear();
        // Alternative if you might have multiple but want to delete all:
        // final allIds = await _isar.userDetailsCaches.where().isarIdProperty().findAll();
        // await _isar.userDetailsCaches.deleteAll(allIds);
      });
      safePrint("[Isar] Cleared UserDetailsCache collection.");
    } catch (e, stackTrace) {
      safePrint(
          "[APIService] Error clearing UserDetailsCache: $e\n$stackTrace");
      // Decide if you need to rethrow or handle this error
      throw OperationFailedException("Failed to clear local UserDetails cache",
          underlyingException: e);
    }
  }

  Future<void> _savePlanToCache(MealPlanCache isarPlan) async {
    // Requires MealPlanCache to have @Index(unique: true, replace: true) on mealPlanId
    await _isar.writeTxn(() async {
      await _isar.mealPlanCaches
          .put(isarPlan); // put handles upsert based on Isar ID (@Id())
      // If using a specific business key like mealPlanId for upsert:
      // await _isar.mealPlanCaches.putByMealPlanId(isarPlan); // Requires generated method based on index name
    });
    safePrint(
        "[Isar] Saved/Updated MealPlanCache for ID ${isarPlan.mealPlanId}.");
  }

  // --- MOCK Network Fetch for Meal Plan ---
  Future<MealPlan> _fetchAmplifyPlanFromNetworkMock(
      String planId, TemporalDateTime fetchTime) async {
    // (Keep the mock implementation from the previous version)
    safePrint("!! MOCK NETWORK !! Simulating fetch for plan ID $planId...");
    await Future.delayed(const Duration(milliseconds: 500));

    // Uncomment to test exceptions:
    // throw SocketException("Simulated network connection error for $planId");
    // throw CacheExpiredException("Simulating cache expiry even on mock fetch", staleData: MealPlan(id: 'stale-mock-id', mealPlanId: planId, userId: 'mock-user', planName: 'Stale Mock Plan')); // Example

    try {
      final String jsonString =
          await rootBundle.loadString('assets/Gemini-Meal-Output.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      //final dailyPlanData = jsonMap['daily_plan'] as Map<String, dynamic>?;

      return MealPlan(
        id: UUID.getUUID(),
        mealPlanId: planId,
        userId: jsonMap['user_id'] ?? 'mock_user_id_from_mock',
        planName: jsonMap['plan_name'] ?? 'Mock Plan from JSON',
        status: PlanStatus.ACTIVE,
        dailyPlan: _convertJsonToDailyPlanData(jsonMap),
        generatedAt: fetchTime,
        // Ensure other required fields have defaults or are mapped
        // createdAt: fetchTime, // Example
      );
    } catch (e, stackTrace) {
      safePrint(
          "!! MOCK NETWORK !! Error processing mock JSON for plan $planId: $e\n$stackTrace");
      throw OperationFailedException(
          "Failed to process mock network data for plan $planId",
          underlyingException: e);
    }
  }

  // --- MOCK Data Conversion Helpers ---
  DailyPlanData _convertJsonToDailyPlanData(Map<String, dynamic>? jsonData) {
    // (Keep the mock implementation from the previous version)
    if (jsonData == null) {
      return DailyPlanData(
          monday: [],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: []); /*  */
    }
    List<Meal> parseDay(String day) {
      final meals = jsonData[day] as List<dynamic>?;
      if (meals == null) return [];
      return meals
          .map((mealJson) => Meal.fromJson(mealJson as Map<String, dynamic>))
          .toList();
    } // Placeholder

    return DailyPlanData(
        monday: parseDay('monday'),
        tuesday: parseDay('tuesday'),
        wednesday: parseDay('wednesday'),
        thursday: parseDay('thursday'),
        friday: parseDay('friday'),
        saturday: parseDay('saturday'),
        sunday: parseDay('sunday'));
  }

  Macros _convertJsonToMacros(Map<String, dynamic>? jsonMacros) {
    // (Keep the mock implementation from the previous version)
    if (jsonMacros == null)
      return Macros(calories: 0, proteins: 0, carbohydrates: 0, fats: 0);
    return Macros(
        calories: (jsonMacros['calories'] as num?)?.toDouble() ?? 0.0,
        proteins: (jsonMacros['proteins'] as num?)?.toDouble() ?? 0.0,
        carbohydrates: (jsonMacros['carbohydrates'] as num?)?.toDouble() ?? 0.0,
        fats: (jsonMacros['fats'] as num?)?.toDouble() ?? 0.0);
  }
}

// --- Helper Extension for TemporalDateTime ---
// (Keep implementation from previous version or ensure it's defined elsewhere)
extension TemporalDateTimeComparisonHelper on TemporalDateTime {
  DateTime getDateTimeInUtc() {
    // Ensure this conversion handles timezones correctly based on Amplify's TemporalDateTime implementation
    // The specific method might vary slightly depending on Amplify versions.
    // Using the built-in method is preferred.
    try {
      return this.getDateTimeInUtc(); // Use Amplify's built-in converter
    } catch (e) {
      // Fallback or rethrow if conversion fails
      safePrint("Error converting TemporalDateTime to DateTime UTC: $e");
      // Return a default or throw an error depending on requirements
      return DateTime.now().toUtc(); // Example fallback
    }
  }
}
