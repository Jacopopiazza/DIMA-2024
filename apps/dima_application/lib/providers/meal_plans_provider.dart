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
    final backendPlans = await _service.listMyMealPlans();
    state = AsyncValue.data(backendPlans.items);
    return backendPlans.items;
  }

  // Optional: Expose activeMealPlanId
  Future<String?> get activeMealPlanId async =>
      (await _service.listMyMealPlans()).activeMealPlan;
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
