import 'dart:async';

import 'package:dima_application/models/MealPlanList/meal_plan_list.dart'
    show LightMealPlan;
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealPlansNotifier extends AsyncNotifier<List<LightMealPlan>> {
  late final MealPlansService _service;

  @override
  FutureOr<List<LightMealPlan>> build() async {
    _service = MealPlansService();
    // No local cache, just return empty or fetch from backend if needed
    return [];
  }

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
}

final mealPlansProvider =
    AsyncNotifierProvider<MealPlansNotifier, List<LightMealPlan>>(
        () => MealPlansNotifier());

// Provider for the active meal plan ID (async)
final activeMealPlanIdProvider = FutureProvider<String?>((ref) async {
  final notifier = ref.read(mealPlansProvider.notifier);
  return await notifier.activeMealPlanId;
});

// Provider for the active LightMealPlan (async) - not implemented
final activeMealPlanCacheProvider = FutureProvider<LightMealPlan?>((ref) async {
  // Not implemented for LightMealPlan
  return null;
});
