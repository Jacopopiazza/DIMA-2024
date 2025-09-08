import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../test_setup.dart';

// Mock service for testing
class MockMealPlansService implements MealPlansService {
  @override
  final Isar? isar = null;

  bool shouldThrowError = false;
  List<LightMealPlan> mockPlans = [];
  String? mockActiveMealPlanId;
  bool deleteSuccess = true;
  bool setActiveSuccess = true;
  bool createRandomSuccess = true;
  bool createSuccess = true;
  bool modifySuccess = true;
  bool assignSuccess = true;
  bool requestValidationSuccess = true;
  bool validateSuccess = true;
  List<NutritionistProfile> mockNutritionists = [];
  List<MealPlan> mockAssignedPlans = [];

  @override
  Future<LightMealPlanList> listMyMealPlans({int limit = 10}) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return LightMealPlanList(
        items: mockPlans, activeMealPlan: mockActiveMealPlanId);
  }

  @override
  Future<MealPlanResponse?> deleteMealPlan(String mealPlanId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (deleteSuccess) {
      // Actually remove from mock list
      mockPlans.removeWhere((plan) => plan.mealPlanId == mealPlanId);

      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Meal plan deleted successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Failed to delete meal plan',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> setActiveMealPlan(String mealPlanId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (setActiveSuccess) {
      mockActiveMealPlanId = mealPlanId;
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Active meal plan set successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Failed to set active meal plan',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> createRandomMealPlan() async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (createRandomSuccess) {
      final newPlan = LightMealPlan(
        mealPlanId: 'random-plan-${DateTime.now().millisecondsSinceEpoch}',
        planName: 'Random Meal Plan',
        updatedAt: DateTime.now(),
      );
      mockPlans.add(newPlan);

      return MealPlanResponse(
        mealPlanId: newPlan.mealPlanId,
        message: 'Random meal plan created successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: 'unknown',
        message: 'Failed to create random meal plan',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> createMealPlan(Map<String, dynamic> input) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (createSuccess) {
      final newPlan = LightMealPlan(
        mealPlanId: 'created-plan-${DateTime.now().millisecondsSinceEpoch}',
        planName: 'Created Meal Plan',
        updatedAt: DateTime.now(),
      );
      mockPlans.add(newPlan);

      return MealPlanResponse(
        mealPlanId: newPlan.mealPlanId,
        message: 'Meal plan creation requested successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: 'unknown',
        message: 'Failed to create meal plan',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> modifyMealPlan(
      String mealPlanId, String mealPlanName) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (modifySuccess) {
      final planIndex =
          mockPlans.indexWhere((plan) => plan.mealPlanId == mealPlanId);
      if (planIndex != -1) {
        mockPlans[planIndex] = LightMealPlan(
          mealPlanId: mealPlanId,
          planName: mealPlanName,
          updatedAt: DateTime.now(),
        );
      }

      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Meal plan modified successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Failed to modify meal plan',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> modifyAssignedMealPlan(
      String mealPlanId, String userId, Map<String, dynamic> input) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return MealPlanResponse(
      mealPlanId: mealPlanId,
      message: 'Assigned meal plan modified successfully',
      success: true,
    );
  }

  @override
  Future<List<NutritionistProfile>> listNutritionists(
      {bool? isAvailable, int? limit, String? nextToken}) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return mockNutritionists.where((nutritionist) {
      if (isAvailable == null) return true;
      return nutritionist.isAvailable == isAvailable;
    }).toList();
  }

  @override
  Future<MealPlanResponse?> assignNutritionistToPlan(
      String mealPlanId, String nutritionistId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (assignSuccess) {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Nutritionist assigned successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Failed to assign nutritionist',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> requestValidation(
      String mealPlanId, String nutritionistId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (requestValidationSuccess) {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Validation requested successfully',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Failed to request validation',
        success: false,
      );
    }
  }

  @override
  Future<MealPlanResponse?> validateMealPlan(String mealPlanId,
      String nutritionistId, MealPlanValidationStatus validationStatus) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    if (validateSuccess) {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Meal plan validation successful',
        success: true,
      );
    } else {
      return MealPlanResponse(
        mealPlanId: mealPlanId,
        message: 'Failed to validate meal plan',
        success: false,
      );
    }
  }

  @override
  Future<List<MealPlan>> listMyAssignedMealPlans({int limit = 10}) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return mockAssignedPlans.take(limit).toList();
  }

  @override
  Future<MealPlan?> getMealPlanById(String mealPlanId) async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    return mockAssignedPlans.cast<MealPlan?>().firstWhere(
        (plan) => plan?.mealPlanId == mealPlanId,
        orElse: () => null);
  }

  @override
  Future<MealPlanResponse?> createMockPlan() async {
    if (shouldThrowError) {
      throw Exception('Mock service error');
    }

    final newPlan = LightMealPlan(
      mealPlanId: 'mock-plan-${DateTime.now().millisecondsSinceEpoch}',
      planName: 'Mock Meal Plan',
      updatedAt: DateTime.now(),
    );
    mockPlans.add(newPlan);

    return MealPlanResponse(
      mealPlanId: newPlan.mealPlanId,
      message: 'Mock meal plan created successfully',
      success: true,
    );
  }
}

void main() {
  configureTestEnvironment();

  group('MealPlansProvider', () {
    late ProviderContainer container;
    late MockMealPlansService mockService;

    setUp(() {
      mockService = MockMealPlansService();
      container = ProviderContainer(
        overrides: [
          mealPlansServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial state', () {
      test('builds successfully', () async {
        final provider = mealPlansProvider;
        final state = await container.read(provider.future);

        expect(state, isA<List<LightMealPlan>>());
        expect(state, isEmpty);
      });

      test('handles service errors during build', () async {
        mockService.shouldThrowError = true;

        final provider = mealPlansProvider;

        expect(
          () => container.read(provider.future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('MealPlansNotifier', () {
      late MealPlansNotifier notifier;

      setUp(() {
        notifier = container.read(mealPlansProvider.notifier);
      });

      test('cachedActiveMealPlanId returns null initially', () {
        expect(notifier.cachedActiveMealPlanId, isNull);
      });

      test('isCacheStale returns false initially', () {
        expect(notifier.isCacheStale, false);
      });

      test('invalidateCache marks cache as stale', () {
        notifier.invalidateCache();
        expect(notifier.isCacheStale, true);
      });

      test('listMyMealPlans loads plans successfully', () async {
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Test Plan 1',
            updatedAt: DateTime.now(),
          ),
          LightMealPlan(
            mealPlanId: 'plan-2',
            planName: 'Test Plan 2',
            updatedAt: DateTime.now(),
          ),
        ];
        mockService.mockActiveMealPlanId = 'plan-1';

        final plans = await notifier.listMyMealPlans();

        expect(plans.length, 2);
        expect(notifier.cachedActiveMealPlanId, 'plan-1');
        expect(notifier.isCacheStale, false);
      });

      test('listMyMealPlans handles service errors', () async {
        mockService.shouldThrowError = true;

        final plans = await notifier.listMyMealPlans();

        expect(plans, isEmpty);
      });

      test('activeMealPlanId returns active plan ID', () async {
        mockService.mockActiveMealPlanId = 'plan-123';

        final activeId = await notifier.activeMealPlanId;

        expect(activeId, 'plan-123');
      });

      test('deleteMealPlan succeeds', () async {
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Test Plan',
            updatedAt: DateTime.now(),
          ),
        ];

        final result = await notifier.deleteMealPlan('plan-1');

        expect(result, true);
      });

      test('deleteMealPlan fails when service returns false', () async {
        mockService.deleteSuccess = false;

        final result = await notifier.deleteMealPlan('plan-1');

        expect(result, false);
      });

      test('deleteMealPlan fails when service returns null', () async {
        mockService.deleteSuccess = false;
        mockService.shouldThrowError = true;

        final result = await notifier.deleteMealPlan('plan-1');

        expect(result, false);
      });

      test('setActiveMealPlan succeeds', () async {
        final result = await notifier.setActiveMealPlan('plan-123');

        expect(result, true);
        expect(mockService.mockActiveMealPlanId, 'plan-123');
      });

      test('setActiveMealPlan fails when service returns false', () async {
        mockService.setActiveSuccess = false;

        final result = await notifier.setActiveMealPlan('plan-123');

        expect(result, false);
      });

      test('createRandomMealPlan succeeds', () async {
        final result = await notifier.createRandomMealPlan();

        expect(result, true);
        expect(mockService.mockPlans.length, 1);
      });

      test('createRandomMealPlan fails when service returns false', () async {
        mockService.createRandomSuccess = false;

        final result = await notifier.createRandomMealPlan();

        expect(result, false);
      });

      test('createMealPlan succeeds', () async {
        final result = await notifier
            .createMealPlan(prefsOverride: {'preference': 'vegetarian'});

        expect(result, true);
        expect(mockService.mockPlans.length, 1);
      });

      test('createMealPlan fails when service returns false', () async {
        mockService.createSuccess = false;

        final result = await notifier.createMealPlan(prefsOverride: {});

        expect(result, false);
      });

      test('modifyMealPlan succeeds', () async {
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Old Name',
            updatedAt: DateTime.now(),
          ),
        ];

        final result = await notifier.modifyMealPlan('plan-1', 'New Name');

        expect(result, true);
        expect(mockService.mockPlans.first.planName, 'New Name');
      });

      test('modifyMealPlan fails when service returns false', () async {
        mockService.modifySuccess = false;

        final result = await notifier.modifyMealPlan('plan-1', 'New Name');

        expect(result, false);
      });

      test('modifyAssignedMealPlan succeeds', () async {
        final result = await notifier
            .modifyAssignedMealPlan('plan-1', 'user-1', {'name': 'New Name'});

        expect(result, true);
      });

      test('modifyAssignedMealPlan fails when service returns false', () async {
        mockService.shouldThrowError = true;

        final result =
            await notifier.modifyAssignedMealPlan('plan-1', 'user-1', {});

        expect(result, false);
      });

      test('listNutritionists returns nutritionists', () async {
        mockService.mockNutritionists = [
          NutritionistProfile(
            id: 'nut-1',
            nutritionistId: 'nut-1',
            givenName: 'John',
            familyName: 'Doe',
            specialization: 'Sports Nutrition',
            bio: 'Expert in sports nutrition',
            profilePictureUrl: null,
            isAvailable: true,
          ),
          NutritionistProfile(
            id: 'nut-2',
            nutritionistId: 'nut-2',
            givenName: 'Jane',
            familyName: 'Smith',
            specialization: 'Clinical Nutrition',
            bio: 'Expert in clinical nutrition',
            profilePictureUrl: null,
            isAvailable: false,
          ),
        ];

        final nutritionists = await notifier.listNutritionists();

        expect(nutritionists.length, 2);
      });

      test('listNutritionists filters by availability', () async {
        mockService.mockNutritionists = [
          NutritionistProfile(
            id: 'nut-1',
            nutritionistId: 'nut-1',
            givenName: 'John',
            familyName: 'Doe',
            specialization: 'Sports Nutrition',
            bio: 'Expert in sports nutrition',
            profilePictureUrl: null,
            isAvailable: true,
          ),
          NutritionistProfile(
            id: 'nut-2',
            nutritionistId: 'nut-2',
            givenName: 'Jane',
            familyName: 'Smith',
            specialization: 'Clinical Nutrition',
            bio: 'Expert in clinical nutrition',
            profilePictureUrl: null,
            isAvailable: false,
          ),
        ];

        final availableNutritionists =
            await notifier.listNutritionists(isAvailable: true);
        expect(availableNutritionists.length, 1);
        expect(availableNutritionists.first.isAvailable, true);

        final unavailableNutritionists =
            await notifier.listNutritionists(isAvailable: false);
        expect(unavailableNutritionists.length, 1);
        expect(unavailableNutritionists.first.isAvailable, false);
      });

      test('listNutritionists handles service errors', () async {
        mockService.shouldThrowError = true;

        final nutritionists = await notifier.listNutritionists();

        expect(nutritionists, isEmpty);
      });

      test('assignNutritionistToPlan succeeds', () async {
        final result =
            await notifier.assignNutritionistToPlan('plan-1', 'nut-1');

        expect(result, true);
      });

      test('assignNutritionistToPlan fails when service returns false',
          () async {
        mockService.assignSuccess = false;

        final result =
            await notifier.assignNutritionistToPlan('plan-1', 'nut-1');

        expect(result, false);
      });

      test('requestValidation succeeds', () async {
        final result = await notifier.requestValidation('plan-1', 'nut-1');

        expect(result, true);
      });

      test('requestValidation fails when service returns false', () async {
        mockService.requestValidationSuccess = false;

        final result = await notifier.requestValidation('plan-1', 'nut-1');

        expect(result, false);
      });

      test('validateMealPlan succeeds', () async {
        final result = await notifier.validateMealPlan(
            'plan-1', 'nut-1', MealPlanValidationStatus.NOT_VALIDATED);

        expect(result, true);
      });

      test('validateMealPlan fails when service returns false', () async {
        mockService.validateSuccess = false;

        final result = await notifier.validateMealPlan(
            'plan-1', 'nut-1', MealPlanValidationStatus.REJECTED);

        expect(result, false);
      });

      test('listMyAssignedMealPlans returns assigned plans', () async {
        mockService.mockAssignedPlans = [
          MealPlan(
            id: 'plan-1',
            mealPlanId: 'plan-1',
            userId: 'user-1',
            planName: 'Assigned Plan 1',
            dailyPlan: DailyPlanData(
              monday: [],
              tuesday: [],
              wednesday: [],
              thursday: [],
              friday: [],
              saturday: [],
              sunday: [],
            ),
            generatedAt: TemporalDateTime.now(),
            status: PlanStatus.ACTIVE,
            assignedNutritionistId: 'nut-1',
            chatId: null,
          ),
        ];

        final plans = await notifier.listMyAssignedMealPlans();

        expect(plans.length, 1);
        expect(plans.first.planName, 'Assigned Plan 1');
      });

      test('listMyAssignedMealPlans handles service errors', () async {
        mockService.shouldThrowError = true;

        final plans = await notifier.listMyAssignedMealPlans();

        expect(plans, isEmpty);
      });

      test('backgroundRefresh updates data silently', () async {
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Background Plan',
            updatedAt: DateTime.now(),
          ),
        ];
        mockService.mockActiveMealPlanId = 'plan-1';

        await notifier.backgroundRefresh();

        expect(notifier.cachedActiveMealPlanId, 'plan-1');
        expect(notifier.isCacheStale, false);
      });

      test('backgroundRefresh handles errors gracefully', () async {
        mockService.shouldThrowError = true;

        await notifier.backgroundRefresh();

        expect(notifier.isCacheStale, true);
      });
    });

    group('Active meal plan ID provider', () {
      test('returns null when no plans loaded', () {
        final activeId = container.read(activeMealPlanIdProvider);
        expect(activeId, isNull);
      });

      test('returns active plan ID when plans are loaded', () async {
        final notifier = container.read(mealPlansProvider.notifier);
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Test Plan',
            updatedAt: DateTime.now(),
          ),
        ];
        mockService.mockActiveMealPlanId = 'plan-1';

        await notifier.listMyMealPlans();

        final activeId = container.read(activeMealPlanIdProvider);
        expect(activeId, 'plan-1');
      });
    });

    group('Active meal plan cache provider', () {
      test('returns null (not implemented)', () async {
        final cache = await container.read(activeMealPlanCacheProvider.future);
        expect(cache, isNull);
      });
    });

    group('Edge cases', () {
      late MealPlansNotifier notifier;

      setUp(() {
        notifier = container.read(mealPlansProvider.notifier);
      });

      test('handles empty meal plans list', () async {
        mockService.mockPlans = [];
        mockService.mockActiveMealPlanId = null;

        final plans = await notifier.listMyMealPlans();

        expect(plans, isEmpty);
        expect(notifier.cachedActiveMealPlanId, isNull);
      });

      test('handles very large meal plans list', () async {
        mockService.mockPlans = List.generate(
            1000,
            (index) => LightMealPlan(
                  mealPlanId: 'plan-$index',
                  planName: 'Plan $index',
                  updatedAt: DateTime.now(),
                ));

        final plans = await notifier.listMyMealPlans();

        expect(plans.length, 1000);
      });

      test('handles concurrent operations', () async {
        final futures = [
          notifier.listMyMealPlans(),
          notifier.createRandomMealPlan(),
          notifier.createMealPlan(prefsOverride: {}),
        ];

        await Future.wait(futures);

        expect(mockService.mockPlans.length,
            2); // 1 from createRandom, 1 from create
      });

      test('handles rapid state changes', () async {
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Original Plan',
            updatedAt: DateTime.now(),
          ),
        ];

        await notifier.listMyMealPlans();
        await notifier.modifyMealPlan('plan-1', 'Modified Plan');
        await notifier.deleteMealPlan('plan-1');

        expect(mockService.mockPlans, isEmpty);
      });

      test('handles special characters in plan names', () async {
        const specialName =
            'Plan with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?🚀🎉💯';

        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: specialName,
            updatedAt: DateTime.now(),
          ),
        ];

        final plans = await notifier.listMyMealPlans();

        expect(plans.first.planName, specialName);
      });

      test('handles very long plan names', () async {
        final longName = 'a' * 10000;

        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: longName,
            updatedAt: DateTime.now(),
          ),
        ];

        final plans = await notifier.listMyMealPlans();

        expect(plans.first.planName, longName);
      });
    });

    group('Error handling', () {
      late MealPlansNotifier notifier;

      setUp(() {
        notifier = container.read(mealPlansProvider.notifier);
      });

      test('handles network timeouts gracefully', () async {
        mockService.shouldThrowError = true;

        final plans = await notifier.listMyMealPlans();

        expect(plans, isEmpty);
      });

      test('handles malformed responses gracefully', () async {
        mockService.shouldThrowError = true;

        await expectLater(
          notifier.deleteMealPlan('plan-1'),
          throwsA(isA<Exception>()),
        );
      });

      test('handles null responses gracefully', () async {
        mockService.deleteSuccess = false;

        final result = await notifier.deleteMealPlan('plan-1');

        expect(result, false);
      });

      test('maintains state consistency during errors', () async {
        mockService.mockPlans = [
          LightMealPlan(
            mealPlanId: 'plan-1',
            planName: 'Test Plan',
            updatedAt: DateTime.now(),
          ),
        ];

        await notifier.listMyMealPlans();
        final stateBefore = container.read(mealPlansProvider);

        mockService.shouldThrowError = true;
        await expectLater(
          notifier.createRandomMealPlan(),
          throwsA(isA<Exception>()),
        );

        final stateAfter = container.read(mealPlansProvider);
        expect(stateAfter, stateBefore); // State should remain unchanged
      });
    });
  });
}
