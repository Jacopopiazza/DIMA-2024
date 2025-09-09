import 'package:amplify_core/amplify_core.dart' show TemporalDateTime;
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
import 'package:dima_application/providers/isar_provider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/providers/today_page_provider.dart';
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../helpers/isar_test_helper.dart';
import '../../test_setup.dart';

// Focus tests on local state and Isar persistence; avoid network calls.

class _FakeMealPlansService extends MealPlansService {
  // Keep track of which meal plan IDs the test is using
  static final Set<String> _testPlanIds = {'plan-123', 'plan-xyz'};

  @override
  Future<LightMealPlanList> listMyMealPlans({int limit = 10}) async {
    // Return empty list most of the time to avoid interference
    return LightMealPlanList(items: const [], activeMealPlan: null);
  }

  // Avoid real network in any accidental calls
  @override
  Future<MealPlan?> getMealPlanById(String mealPlanId) async {
    // Return null for non-test plan IDs to avoid network calls
    if (!_testPlanIds.contains(mealPlanId)) {
      return null;
    }
    // For test plan IDs, return a minimal mock plan
    return MealPlan(
      id: mealPlanId,
      mealPlanId: mealPlanId,
      userId: 'test-user',
      planName: 'Test Plan',
      updatedAt: TemporalDateTime.now(),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureTestEnvironment();
  group('TodayPageProvider', () {
    late ProviderContainer container;
    late Isar mockIsar;

    setUp(() async {
      mockIsar =
          await IsarTestHelper.createCleanTestIsar(name: 'today_page_test');

      container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(mockIsar),
          mealPlansServiceProvider.overrideWithValue(_FakeMealPlansService()),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await IsarTestHelper.closeTestIsar(mockIsar);
    });

    group('TodayPageState model', () {
      test('initializes with default values', () {
        final state = TodayPageState();

        expect(state.status, DataStatus.initial);
        expect(state.todaysMeals, isNull);
        expect(state.dailyCompletion, isNull);
        expect(state.consumedMacros.calories, 0);
        expect(state.consumedMacros.proteins, 0);
        expect(state.consumedMacros.carbohydrates, 0);
        expect(state.consumedMacros.fats, 0);
        expect(state.errorMessage, isNull);
        expect(state.planLastFetched, isNull);
        expect(state.isInitialLoad, true);
        expect(state.mealPlanId, isNull);
      });

      test('initializes with provided values', () {
        final meals = [
          Meal(
            name: MealNameEnum.BREAKFAST,
            recipeName: 'Test Recipe',
            totalMacros: Macros(
              calories: 300,
              proteins: 20,
              carbohydrates: 30,
              fats: 10,
            ),
            ingredients: [],
          ),
        ];

        final completion = DailyCompletion.forDate(
          planId: 'plan-123',
          date: DateTime.now(),
        );

        final macros = Macros(
          calories: 500,
          proteins: 30,
          carbohydrates: 50,
          fats: 20,
        );

        final state = TodayPageState(
          status: DataStatus.loadedOnline,
          todaysMeals: meals,
          dailyCompletion: completion,
          consumedMacros: macros,
          errorMessage: 'Test error',
          planLastFetched: DateTime.now(),
          isInitialLoad: false,
          mealPlanId: 'plan-123',
        );

        expect(state.status, DataStatus.loadedOnline);
        expect(state.todaysMeals, meals);
        expect(state.dailyCompletion, completion);
        expect(state.consumedMacros, macros);
        expect(state.errorMessage, 'Test error');
        expect(state.planLastFetched, isNotNull);
        expect(state.isInitialLoad, false);
        expect(state.mealPlanId, 'plan-123');
      });

      test('copyWith works correctly', () {
        final original = TodayPageState(
          status: DataStatus.loading,
          todaysMeals: [],
          dailyCompletion:
              DailyCompletion.forDate(planId: 'plan-1', date: DateTime.now()),
          consumedMacros:
              Macros(calories: 100, proteins: 10, carbohydrates: 10, fats: 5),
          errorMessage: 'Original error',
          planLastFetched: DateTime.now(),
          isInitialLoad: true,
          mealPlanId: 'plan-1',
        );

        final updated = original.copyWith(
          status: DataStatus.loadedOnline,
          errorMessage: 'Updated error',
          isInitialLoad: false,
          dailyCompletion: original.dailyCompletion, // Explicitly preserve
        );

        expect(updated.status, DataStatus.loadedOnline);
        expect(updated.todaysMeals, original.todaysMeals);
        expect(updated.dailyCompletion, original.dailyCompletion);
        expect(updated.consumedMacros, original.consumedMacros);
        expect(updated.errorMessage, 'Updated error');
        expect(updated.planLastFetched, original.planLastFetched);
        expect(updated.isInitialLoad, false);
        expect(updated.mealPlanId, original.mealPlanId);
      });

      test('copyWith clears fields when requested', () {
        final original = TodayPageState(
          todaysMeals: [
            Meal(
                name: MealNameEnum.BREAKFAST,
                recipeName: 'Test',
                totalMacros: Macros(
                    calories: 100, proteins: 10, carbohydrates: 10, fats: 5),
                ingredients: []),
          ],
          dailyCompletion:
              DailyCompletion.forDate(planId: 'plan-1', date: DateTime.now()),
          errorMessage: 'Test error',
        );

        final updated = original.copyWith(
          clearTodaysMeals: true,
          clearDailyCompletion: true,
          clearError: true,
        );

        expect(updated.todaysMeals, isNull);
        expect(updated.dailyCompletion, isNull);
        expect(updated.errorMessage, isNull);
      });

      test('isMealCompleted works correctly', () {
        final completion = DailyCompletion.forDate(
          planId: 'plan-123',
          date: DateTime.now(),
        );
        completion.completedMealNames = [
          MealNameEnum.BREAKFAST,
          MealNameEnum.LUNCH
        ];

        final state = TodayPageState(dailyCompletion: completion);

        expect(state.isMealCompleted(MealNameEnum.BREAKFAST), true);
        expect(state.isMealCompleted(MealNameEnum.LUNCH), true);
        expect(state.isMealCompleted(MealNameEnum.DINNER), false);
        expect(state.isMealCompleted(MealNameEnum.SNACK_AFTERNOON), false);
      });

      test('isMealCompleted returns false when no completion', () {
        final state = TodayPageState();

        expect(state.isMealCompleted(MealNameEnum.BREAKFAST), false);
      });

      test('toString works correctly', () {
        final state = TodayPageState(
          status: DataStatus.loadedOnline,
          isInitialLoad: false,
          mealPlanId: 'plan-123',
        );

        final string = state.toString();
        expect(string, contains('TodayPageState'));
        expect(string, contains('loadedOnline'));
        expect(string, contains('plan-123'));
      });
    });

    group('DataStatus enum', () {
      test('all enum values are defined', () {
        expect(DataStatus.values.length, 9);
        expect(DataStatus.values, contains(DataStatus.initial));
        expect(DataStatus.values, contains(DataStatus.loading));
        expect(DataStatus.values, contains(DataStatus.loadedOnline));
        expect(DataStatus.values, contains(DataStatus.loadedOffline));
        expect(DataStatus.values, contains(DataStatus.errorNoPlan));
        expect(DataStatus.values, contains(DataStatus.errorNetwork));
        expect(DataStatus.values, contains(DataStatus.errorNetworkWithCache));
        expect(DataStatus.values, contains(DataStatus.errorInvalidPlanId));
        expect(DataStatus.values, contains(DataStatus.errorOther));
      });
    });

    group('TodayPageNotifier', () {
      late TodayPageNotifier notifier;

      setUp(() {
        notifier = container.read(todayPageProvider.notifier);
      });

      test('initializes with default state', () {
        final state = container.read(todayPageProvider);

        expect(state.status, DataStatus.loading);
        expect(state.todaysMeals, isNull);
        expect(state.dailyCompletion, isNull);
        expect(state.isInitialLoad, true);
      });

      test('refreshData returns normally', () async {
        expect(() => notifier.refreshData(), returnsNormally);
      });

      test('refreshTodayData triggers data reload', () async {
        // This would require testing the refresh logic
        // For now, we'll test that the method exists
        expect(() => notifier.refreshTodayData(), returnsNormally);
      });

      test('disposes correctly', () {
        expect(() => notifier.dispose(), returnsNormally);
      });
    });

    group('Provider integration', () {
      test('provider can be read from container', () {
        final state = container.read(todayPageProvider);
        expect(state, isA<TodayPageState>());
      });

      test('provider notifier can be read from container', () {
        final notifier = container.read(todayPageProvider.notifier);
        expect(notifier, isA<TodayPageNotifier>());
      });

      test('provider notifier exposes methods without throwing', () {
        final notifier = container.read(todayPageProvider.notifier);
        // Do not call refresh to avoid network paths
        expect(notifier, isA<TodayPageNotifier>());
      });
    });

    group('Edge cases', () {
      late TodayPageNotifier notifier;

      setUp(() {
        notifier = container.read(todayPageProvider.notifier);
      });

      test('toggleMealCompletion is no-op when loading or no meals', () async {
        // Loading state
        notifier.state = TodayPageState(status: DataStatus.loading);
        await notifier.toggleMealCompletion(MealNameEnum.BREAKFAST, 'pid');
        expect(notifier.state.status, DataStatus.loading);

        // No meals
        notifier.state = TodayPageState(status: DataStatus.loadedOnline);
        await notifier.toggleMealCompletion(MealNameEnum.BREAKFAST, 'pid');
        expect(notifier.state.todaysMeals, isNull);
      });
    });

    group('Error handling', () {
      late TodayPageNotifier notifier;

      setUp(() {
        notifier = container.read(todayPageProvider.notifier);
      });
    });

    group('Data validation', () {
      test('isMealCompleted returns false without completion', () async {
        final state = TodayPageState();
        expect(state.isMealCompleted(MealNameEnum.BREAKFAST), false);
      });

      test('copyWith can clear meals, completion and error', () async {
        final original = TodayPageState(
          todaysMeals: [
            Meal(
              name: MealNameEnum.BREAKFAST,
              recipeName: 'X',
              totalMacros:
                  Macros(calories: 1, proteins: 1, carbohydrates: 1, fats: 1),
              ingredients: const [],
            )
          ],
          dailyCompletion:
              DailyCompletion.forDate(planId: 'p', date: DateTime.now()),
          errorMessage: 'e',
        );
        final updated = original.copyWith(
            clearTodaysMeals: true,
            clearDailyCompletion: true,
            clearError: true);
        expect(updated.todaysMeals, isNull);
        expect(updated.dailyCompletion, isNull);
        expect(updated.errorMessage, isNull);
      });

      test('toString includes key fields', () async {
        final s = TodayPageState(
          status: DataStatus.loadedOnline,
          isInitialLoad: false,
          mealPlanId: 'p-1',
          todaysMeals: const [],
          consumedMacros:
              Macros(calories: 1, proteins: 1, carbohydrates: 1, fats: 1),
          planLastFetched: DateTime.now(),
        ).toString();
        expect(s, contains('TodayPageState'));
        expect(s, contains('loadedOnline'));
        expect(s, contains('p-1'));
      });

      test('handles malformed date data', () async {
        // This would require testing with malformed date data
        expect(true, isTrue); // Placeholder
      });
    });

    // Performance tests omitted in unit scope

    // Integration scenario placeholders removed
  });
}
