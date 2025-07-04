import 'dart:async';

import 'package:dima_application/generated/flutter-models/MealPlanResponse.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'isar_provider.dart';

class MealPlansNotifier extends AsyncNotifier<List<MealPlanCache>> {
  late final Isar _isar;
  late final MealPlansService _service;

  @override
  FutureOr<List<MealPlanCache>> build() async {
    _isar = ref.read(isarProvider);
    _service = MealPlansService(isar: _isar);
    // Initial load from Isar
    return _isar.mealPlanCaches.where().findAll();
  }

  // Stream for UI to listen to changes
  Stream<List<MealPlanCache>> watchAllPlans() {
    return _isar.mealPlanCaches.where().watch(fireImmediately: true);
  }

  // Create a mock plan and refresh
  Future<MealPlanResponse?> createMockPlan() async {
    final response = await _service.createMockPlan();
    if (response != null && response.success && response.mealPlanId != null) {
      // Fetch and cache the new plan
      await fetchAndCachePlan(response.mealPlanId!);
      // Refresh state
      state = AsyncValue.data(await _isar.mealPlanCaches.where().findAll());
    }
    return response;
  }

  // Delete a plan and refresh
  Future<bool> deletePlan(String mealPlanId) async {
    final response = await _service.deleteMealPlan(mealPlanId);
    if (response != null && response.success) {
      await _isar.writeTxn(() async {
        final plan = await _isar.mealPlanCaches
            .filter()
            .mealPlanIdEqualTo(mealPlanId)
            .findFirst();
        if (plan != null) {
          await _isar.mealPlanCaches.delete(plan.id);
        }
      });
      state = AsyncValue.data(await _isar.mealPlanCaches.where().findAll());
      return true;
    }
    return false;
  }

  // Fetch a plan by ID (from Isar, or backend and cache)
  Future<MealPlanCache?> fetchAndCachePlan(String mealPlanId) async {
    // Try local first
    var plan = await _isar.mealPlanCaches
        .filter()
        .mealPlanIdEqualTo(mealPlanId)
        .findFirst();
    if (plan != null) return plan;
    // Fetch from backend
    final backendPlan = await _service.getMealPlanById(mealPlanId);
    if (backendPlan != null) {
      final cache = MealPlanCache.fromAmplify(backendPlan);
      await _isar.writeTxn(() async {
        await _isar.mealPlanCaches.put(cache);
      });
      // Refresh state
      state = AsyncValue.data(await _isar.mealPlanCaches.where().findAll());
      return cache;
    }
    return null;
  }

  Future<List<MealPlanCache>> listMyMealPlans() async {
    // Try local first
    var plans = await _isar.mealPlanCaches.where().findAll();
    if (plans.isNotEmpty) return plans;
    // Fetch from backend
    final backendPlans = await _service.listMyMealPlans();
    if (backendPlans.isNotEmpty) {
      // Cache the plans
      await _isar.writeTxn(() async {
        for (var plan in backendPlans) {
          final cache = MealPlanCache.fromAmplify(plan);
          await _isar.mealPlanCaches.put(cache);
        }
      });
      // Refresh state
      state = AsyncValue.data(await _isar.mealPlanCaches.where().findAll());
      return plans;
    }
    return [];
  }
}

final mealPlansProvider =
    AsyncNotifierProvider<MealPlansNotifier, List<MealPlanCache>>(
        () => MealPlansNotifier());
