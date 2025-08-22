import 'dart:async';

import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart'
    show LightMealPlan;
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealPlansNotifier extends AsyncNotifier<List<LightMealPlan>> {
  late final MealPlansService _service;
  String? _cachedActiveMealPlanId;

  @override
  FutureOr<List<LightMealPlan>> build() async {
    _service = MealPlansService();
    // Automatically load plans on initialization
    return await listMyMealPlans();
  }

  /// Get the cached active meal plan ID (from last listMyMealPlans call)
  String? get cachedActiveMealPlanId => _cachedActiveMealPlanId;

  // No local cache, so this is not implemented
  // Stream<List<LightMealPlan>> watchAllPlans() => throw UnimplementedError();

  // No local cache, so this is not implemented
  // Future<LightMealPlan?> fetchAndCachePlan(String mealPlanId) => throw UnimplementedError();

  Future<List<LightMealPlan>> listMyMealPlans() async {
    print('[MealPlansProvider] Starting listMyMealPlans...');
    try {
      final backendPlans = await _service.listMyMealPlans();
      print(
          '[MealPlansProvider] Backend returned ${backendPlans.items.length} plans');

      // Cache the active meal plan ID from the response
      _cachedActiveMealPlanId = backendPlans.activeMealPlan;
      print(
          '[MealPlansProvider] Cached active meal plan ID: $_cachedActiveMealPlanId');

      state = AsyncValue.data(backendPlans.items);
      print(
          '[MealPlansProvider] State updated with ${state.value?.length} items');
      return backendPlans.items;
    } catch (e) {
      print('[MealPlansProvider] Error in listMyMealPlans: $e');
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  // Optional: Expose activeMealPlanId
  Future<String?> get activeMealPlanId async =>
      (await _service.listMyMealPlans()).activeMealPlan;

  Future<bool> deleteMealPlan(String mealPlanId) async {
    print('[MealPlansProvider] Starting deletion of meal plan: $mealPlanId');

    final response = await _service.deleteMealPlan(mealPlanId);
    print('[MealPlansProvider] Service response: $response');

    if (response == null) {
      print('[MealPlansProvider] Response is null, returning false');
      return false;
    }

    // Check if the deletion was successful based on the response
    if (response.success == true) {
      print('[MealPlansProvider] Deletion successful, refreshing list...');
      // Refresh the list after successful deletion
      await listMyMealPlans();
      print(
          '[MealPlansProvider] List refreshed, current state: ${state.value?.length} items');
      return true;
    } else {
      print(
          '[MealPlansProvider] Deletion failed, success: ${response.success}, message: ${response.message}');
      return false;
    }
  }

  Future<bool> setActiveMealPlan(String mealPlanId) async {
    print('[MealPlansProvider] Setting active meal plan: $mealPlanId');
    final response = await _service.setActiveMealPlan(mealPlanId);
    print('[MealPlansProvider] setActiveMealPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] setActiveMealPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Active plan set successfully, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to set active plan, message: ${response.message}');
      return false;
    }
  }

  Future<bool> createRandomMealPlan() async {
    print('[MealPlansProvider] Creating random meal plan...');
    final response = await _service.createRandomMealPlan();
    print('[MealPlansProvider] createRandomMealPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] createRandomMealPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Random meal plan created successfully, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to create random meal plan, message: ${response.message}');
      return false;
    }
  }

  Future<bool> createMealPlan({Map<String, dynamic>? prefsOverride}) async {
    print('[MealPlansProvider] Creating meal plan with gemini...');
    final response = await _service.createMealPlan(prefsOverride ?? {});
    print('[MealPlansProvider] createMealPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] createMealPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Successfully requested the creation of a meal plan, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to requested the creation of a meal plan, message: ${response.message}');
      return false;
    }
  }

  Future<bool> modifyMealPlan(String mealPlanId, String mealPlanName) async {
    print(
        '[MealPlansProvider] Modifying meal plan: $mealPlanId with name: $mealPlanName');
    final response = await _service.modifyMealPlan(mealPlanId, mealPlanName);
    print('[MealPlansProvider] modifyMealPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] modifyMealPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Meal plan modified successfully, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to modify meal plan, message: ${response.message}');
      return false;
    }
  }

  /// Modifies a meal plan assigned to the nutritionist (nutritionist-specific operation).
  /// Requires the userId since nutritionists modify plans belonging to other users.
  /// Can modify the plan name and/or the daily plan meals via the input parameter.
  Future<bool> modifyAssignedMealPlan(
      String mealPlanId, String userId, Map<String, dynamic> input) async {
    print(
        '[MealPlansProvider] Modifying assigned meal plan: $mealPlanId for user: $userId with input: $input');
    final response =
        await _service.modifyAssignedMealPlan(mealPlanId, userId, input);
    print('[MealPlansProvider] modifyAssignedMealPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] modifyAssignedMealPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Assigned meal plan modified successfully, refreshing list...');
      await listMyAssignedMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to modify assigned meal plan, message: ${response.message}');
      return false;
    }
  }

  /// Lists available nutritionists for assignment to meal plans.
  Future<List<NutritionistProfile>> listNutritionists(
      {bool? isAvailable}) async {
    print('[MealPlansProvider] Listing nutritionists...');
    try {
      final nutritionists =
          await _service.listNutritionists(isAvailable: isAvailable);
      print('[MealPlansProvider] Found ${nutritionists.length} nutritionists');
      return nutritionists;
    } catch (e) {
      print('[MealPlansProvider] Error listing nutritionists: $e');
      return [];
    }
  }

  /// Assigns a nutritionist to a meal plan for validation.
  Future<bool> assignNutritionistToPlan(
      String mealPlanId, String nutritionistId) async {
    print(
        '[MealPlansProvider] Assigning nutritionist $nutritionistId to meal plan $mealPlanId');
    final response =
        await _service.assignNutritionistToPlan(mealPlanId, nutritionistId);
    print('[MealPlansProvider] assignNutritionistToPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] assignNutritionistToPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Nutritionist assigned successfully, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to assign nutritionist, message: ${response.message}');
      return false;
    }
  }

  /// Requests validation of a meal plan by a nutritionist.
  Future<bool> requestValidation(
      String mealPlanId, String nutritionistId) async {
    print(
        '[MealPlansProvider] Requesting validation for meal plan $mealPlanId by nutritionist $nutritionistId');
    final response =
        await _service.requestValidation(mealPlanId, nutritionistId);
    print('[MealPlansProvider] requestValidation response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] requestValidation response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Validation request successful, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to request validation, message: ${response.message}');
      return false;
    }
  }

  /// Validates a meal plan by a nutritionist, updating the validation status.
  Future<bool> validateMealPlan(
      String mealPlanId, String nutritionistId, String validationStatus) async {
    print(
        '[MealPlansProvider] Validating meal plan $mealPlanId by nutritionist $nutritionistId with status: $validationStatus');
    final response = await _service.validateMealPlan(
        mealPlanId, nutritionistId, validationStatus);
    print('[MealPlansProvider] validateMealPlan response: $response');
    if (response == null) {
      print(
          '[MealPlansProvider] validateMealPlan response is null, returning false');
      return false;
    }
    if (response.success == true) {
      print(
          '[MealPlansProvider] Meal plan validation successful, refreshing list...');
      await listMyMealPlans();
      return true;
    } else {
      print(
          '[MealPlansProvider] Failed to validate meal plan, message: ${response.message}');
      return false;
    }
  }

  /// Lists meal plans assigned to the authenticated nutritionist for validation.
  Future<List<MealPlan>> listMyAssignedMealPlans({int limit = 10}) async {
    print('[MealPlansProvider] Listing assigned meal plans...');
    try {
      final plans = await _service.listMyAssignedMealPlans(limit: limit);
      print('[MealPlansProvider] Found ${plans.length} assigned meal plans');
      return plans;
    } catch (e) {
      print('[MealPlansProvider] Error listing assigned meal plans: $e');
      return [];
    }
  }
}

final mealPlansProvider =
    AsyncNotifierProvider<MealPlansNotifier, List<LightMealPlan>>(
        () => MealPlansNotifier());

// Provider for the active meal plan ID (simplified)
final activeMealPlanIdProvider = Provider<String?>((ref) {
  final plansAsync = ref.watch(mealPlansProvider);

  return plansAsync.when(
    data: (plans) {
      // Get the active meal plan ID from the cached service data
      final notifier = ref.read(mealPlansProvider.notifier);
      return notifier.cachedActiveMealPlanId;
    },
    loading: () => null,
    error: (error, stack) => null,
  );
});

// Provider for the active LightMealPlan (async) - not implemented
final activeMealPlanCacheProvider = FutureProvider<LightMealPlan?>((ref) async {
  // Not implemented for LightMealPlan
  return null;
});
