// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/providers/isar_provider.dart';

/// Provider that creates and exposes the ApiService instance
/// Uses the Isar database for local caching
final apiServiceProvider = Provider<ApiService>((ref) {
  final isar = ref.watch(isarProvider);
  return ApiService(isar);
});

/// Service responsible for API operations and local caching
/// 
/// Handles fetching meal plans from network and managing local cache
/// using Isar database for offline support
class ApiService {
  final Isar _isar;
  
  /// Duration to consider cached data valid before refreshing
  static const Duration _planCacheDuration = Duration(hours: 24);
  
  /// Creates a new ApiService with the provided Isar instance
  ApiService(this._isar);

  /// Gets the ID of the user's chosen meal plan
  /// 
  /// Returns null if no plan has been chosen
  /// Note: Currently uses mock implementation
  Future<String?> getChosenPlanId() async {
    print("[ApiService] MOCK: Checking for chosen plan ID...");
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Mock implementation - toggle return values to test different scenarios
     return 'mock_plan_from_gemini_output'; // Uncomment to simulate plan chosen
    //return null; // Simulate no plan chosen
  }

  /// Fetches a meal plan with the specified ID
  /// 
  /// Implements a cache-first strategy using Isar for offline support
  /// 
  /// [planId] - The ID of the plan to fetch
  /// [forceRefresh] - If true, bypasses valid cache and fetches fresh data
  /// 
  /// Returns the meal plan from either cache or network
  /// Throws an exception if the fetch fails and no cache is available
  Future<MealPlan> fetchMealPlan(String planId,
      {bool forceRefresh = false}) async {
    print("[ApiService] Fetching meal plan (ID: $planId) - Checking Isar cache first...");
    
    final now = DateTime.now();
    MealPlan? cachedPlan;

    // 1. Check cache unless force refresh is requested
    if (!forceRefresh) {
      cachedPlan = await _isar.mealPlans.where().planIdEqualTo(planId).findFirst();
      
      if (cachedPlan != null) {
        if (now.difference(cachedPlan.lastFetched) < _planCacheDuration) {
          print("[ApiService] ISAR CACHE HIT: Returning valid cached plan for $planId");
          return cachedPlan;
        } else {
          print("[ApiService] ISAR CACHE STALE: Cached plan for $planId is expired.");
        }
      } else {
        print("[ApiService] ISAR CACHE MISS: No cached plan found for $planId.");
      }
    } else {
      print("[ApiService] FORCE REFRESH: Skipping cache check.");
      
      // Still load cache as fallback in case network fails
      cachedPlan = await _isar.mealPlans.where().planIdEqualTo(planId).findFirst();
      
      if (cachedPlan != null) {
        print("[ApiService] FORCE REFRESH: Found potential stale cache for fallback.");
      }
    }

    // 2. Fetch from network (mock implementation)
    try {
      print("[ApiService] MOCK NETWORK: Fetching plan for $planId...");
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load mock data from assets
      final String jsonString = await rootBundle.loadString('assets/Gemini-Meal-Output.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      // Create meal plan from JSON and store current timestamp
      final fetchedPlan = MealPlan.fromJson(jsonMap, planId, now);
      
      print("[ApiService] MOCK NETWORK: Success. Saving plan to Isar for $planId.");
      
      // 3. Save fetched plan to cache
      await _isar.writeTxn(() async {
        await _isar.mealPlans.put(fetchedPlan);
      });
      
      return fetchedPlan;
    } catch (e, stackTrace) {
      print("[ApiService] NETWORK ERROR: Failed to fetch plan for $planId. Error: $e\n$stackTrace");
      
      // 4. Fallback to cache on network failure
      if (cachedPlan != null) {
        print("[ApiService] NETWORK ERROR FALLBACK: Returning stale Isar cached plan for $planId.");
        return cachedPlan;
      } else {
        print("[ApiService] NETWORK ERROR FALLBACK: No cache available in Isar for $planId.");
        throw Exception("Failed to fetch plan and no cache available: $e");
      }
    }
  }
}