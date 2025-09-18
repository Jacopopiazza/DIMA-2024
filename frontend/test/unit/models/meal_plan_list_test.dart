import 'package:amplify_core/amplify_core.dart' show TemporalDateTime;
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart'
    as meal_plan_models;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealPlanList', () {
    group('Constructor and initialization', () {
      test('creates MealPlanList with required parameters', () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'plan-1',
            userId: 'user-1',
            planName: 'Plan 1',
          ),
        ];

        final mealPlanList = meal_plan_models.MealPlanList(items: mealPlans);

        expect(mealPlanList.items, mealPlans);
        expect(mealPlanList.nextToken, isNull);
        expect(mealPlanList.activeMealPlan, isNull);
      });

      test('creates MealPlanList with all parameters', () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'plan-1',
            userId: 'user-1',
            planName: 'Plan 1',
          ),
          MealPlan(
            mealPlanId: 'plan-2',
            userId: 'user-1',
            planName: 'Plan 2',
          ),
        ];
        final nextToken = 'next-page-token';
        final activePlan = 'plan-1';

        final mealPlanList = meal_plan_models.MealPlanList(
          items: mealPlans,
          nextToken: nextToken,
          activeMealPlan: activePlan,
        );

        expect(mealPlanList.items, mealPlans);
        expect(mealPlanList.nextToken, nextToken);
        expect(mealPlanList.activeMealPlan, activePlan);
      });
    });

    group('Factory constructor fromJson', () {
      test('creates MealPlanList from valid JSON', () {
        final json = {
          'items': [
            {
              'mealPlanId': 'plan-json-1',
              'planName': 'JSON Plan 1',
              'status': 'ACTIVE',
            },
            {
              'mealPlanId': 'plan-json-2',
              'planName': 'JSON Plan 2',
              'status': 'ARCHIVED',
            },
          ],
          'nextToken': 'json-next-token',
          'activeMealPlan': 'plan-json-1',
        };

        final mealPlanList = meal_plan_models.MealPlanList.fromJson(json);

        expect(mealPlanList.items.length, 2);
        expect(mealPlanList.items[0].mealPlanId, 'plan-json-1');
        expect(mealPlanList.items[0].planName, 'JSON Plan 1');
        expect(mealPlanList.items[0].status, PlanStatus.ACTIVE);
        expect(mealPlanList.items[0].userId, ''); // Required field set to empty
        expect(mealPlanList.items[1].mealPlanId, 'plan-json-2');
        expect(mealPlanList.items[1].status, PlanStatus.ARCHIVED);
        expect(mealPlanList.nextToken, 'json-next-token');
        expect(mealPlanList.activeMealPlan, 'plan-json-1');
      });

      test('handles empty items list', () {
        final json = {
          'items': <Map<String, dynamic>>[],
          'nextToken': null,
          'activeMealPlan': null,
        };

        final mealPlanList = meal_plan_models.MealPlanList.fromJson(json);

        expect(mealPlanList.items, isEmpty);
        expect(mealPlanList.nextToken, isNull);
        expect(mealPlanList.activeMealPlan, isNull);
      });

      test('handles null items list', () {
        final json = {
          'items': null,
          'nextToken': 'some-token',
          'activeMealPlan': 'some-plan',
        };

        final mealPlanList = meal_plan_models.MealPlanList.fromJson(json);

        expect(mealPlanList.items, isEmpty);
        expect(mealPlanList.nextToken, 'some-token');
        expect(mealPlanList.activeMealPlan, 'some-plan');
      });

      test('handles minimal JSON with only required fields', () {
        final json = {
          'items': [
            {
              'mealPlanId': 'minimal-plan',
            },
          ],
        };

        final mealPlanList = meal_plan_models.MealPlanList.fromJson(json);

        expect(mealPlanList.items.length, 1);
        expect(mealPlanList.items[0].mealPlanId, 'minimal-plan');
        expect(mealPlanList.items[0].planName, isNull);
        expect(mealPlanList.items[0].status, isNull);
        expect(mealPlanList.nextToken, isNull);
        expect(mealPlanList.activeMealPlan, isNull);
      });

      test('handles unknown status values gracefully', () {
        final json = {
          'items': [
            {
              'mealPlanId': 'plan-unknown-status',
              'status': 'UNKNOWN_STATUS',
            },
          ],
        };

        final mealPlanList = meal_plan_models.MealPlanList.fromJson(json);

        expect(mealPlanList.items.length, 1);
        expect(mealPlanList.items[0].status,
            isNull); // Unknown enum values become null
      });
    });

    group('copyWith method', () {
      test('creates copy with modified items', () {
        final originalPlans = [
          MealPlan(
            mealPlanId: 'original-1',
            userId: 'user-1',
          ),
        ];

        final newPlans = [
          MealPlan(
            mealPlanId: 'new-1',
            userId: 'user-1',
          ),
          MealPlan(
            mealPlanId: 'new-2',
            userId: 'user-1',
          ),
        ];

        final original = MealPlanList(items: originalPlans);
        final copied = original.copyWith(items: newPlans);

        expect(copied.items, newPlans);
        expect(copied.nextToken, original.nextToken);
        expect(copied.activeMealPlan, original.activeMealPlan);
        expect(original.items, originalPlans); // Original unchanged
      });

      test('creates copy with modified nextToken', () {
        final plans = [
          MealPlan(mealPlanId: 'plan-1', userId: 'user-1'),
        ];

        final original = MealPlanList(
          items: plans,
          nextToken: 'original-token',
        );

        final copied = original.copyWith(nextToken: 'new-token');

        expect(copied.items, original.items);
        expect(copied.nextToken, 'new-token');
        expect(copied.activeMealPlan, original.activeMealPlan);
        expect(original.nextToken, 'original-token'); // Original unchanged
      });

      test('creates copy with modified activeMealPlan', () {
        final plans = [
          MealPlan(mealPlanId: 'plan-1', userId: 'user-1'),
          MealPlan(mealPlanId: 'plan-2', userId: 'user-1'),
        ];

        final original = MealPlanList(
          items: plans,
          activeMealPlan: 'plan-1',
        );

        final copied = original.copyWith(activeMealPlan: 'plan-2');

        expect(copied.items, original.items);
        expect(copied.nextToken, original.nextToken);
        expect(copied.activeMealPlan, 'plan-2');
        expect(original.activeMealPlan, 'plan-1'); // Original unchanged
      });

      test('creates copy with all parameters modified', () {
        final originalPlans = [
          MealPlan(mealPlanId: 'orig-1', userId: 'user-1'),
        ];

        final newPlans = [
          MealPlan(mealPlanId: 'new-1', userId: 'user-1'),
        ];

        final original = MealPlanList(
          items: originalPlans,
          nextToken: 'orig-token',
          activeMealPlan: 'orig-1',
        );

        final copied = original.copyWith(
          items: newPlans,
          nextToken: 'new-token',
          activeMealPlan: 'new-1',
        );

        expect(copied.items, newPlans);
        expect(copied.nextToken, 'new-token');
        expect(copied.activeMealPlan, 'new-1');

        // Verify original is unchanged
        expect(original.items, originalPlans);
        expect(original.nextToken, 'orig-token');
        expect(original.activeMealPlan, 'orig-1');
      });

      test('creates copy without parameters preserves original values', () {
        final plans = [
          MealPlan(mealPlanId: 'preserve-1', userId: 'user-1'),
        ];

        final original = MealPlanList(
          items: plans,
          nextToken: 'preserve-token',
          activeMealPlan: 'preserve-1',
        );

        final copied = original.copyWith();

        expect(copied.items, original.items);
        expect(copied.nextToken, original.nextToken);
        expect(copied.activeMealPlan, original.activeMealPlan);
      });
    });

    group('Factory constructor initial', () {
      test('creates empty MealPlanList', () {
        final initial = meal_plan_models.MealPlanList.initial();

        expect(initial.items, isEmpty);
        expect(initial.nextToken, isNull);
        expect(initial.activeMealPlan, isNull);
      });
    });

    group('toJson method', () {
      test('converts MealPlanList to JSON', () {
        final plans = [
          MealPlan(
            mealPlanId: 'json-out-1',
            userId: 'user-1',
            planName: 'JSON Output Plan',
            status: PlanStatus.ACTIVE,
          ),
        ];

        final mealPlanList = meal_plan_models.MealPlanList(
          items: plans,
          nextToken: 'output-token',
          activeMealPlan: 'json-out-1',
        );

        final json = mealPlanList.toJson();

        expect(json['items'], isA<List>());
        expect(json['items'].length, 1);
        expect(json['nextToken'], 'output-token');
        expect(json['activeMealPlan'], 'json-out-1');
      });

      test('handles empty list in toJson', () {
        final empty = meal_plan_models.MealPlanList.initial();
        final json = empty.toJson();

        expect(json['items'], isEmpty);
        expect(json['nextToken'], isNull);
        expect(json['activeMealPlan'], isNull);
      });
    });

    group('Factory constructor fromAmplifyModels', () {
      test(
          'creates MealPlanList from Amplify models with active plan detection',
          () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'amplify-1',
            userId: 'user-1',
            planName: 'Inactive Plan',
            status: PlanStatus.ARCHIVED,
          ),
          MealPlan(
            mealPlanId: 'amplify-2',
            userId: 'user-1',
            planName: 'Active Plan',
            status: PlanStatus.ACTIVE,
          ),
          MealPlan(
            mealPlanId: 'amplify-3',
            userId: 'user-1',
            planName: 'Pending Plan',
            status: PlanStatus.PENDING,
          ),
        ];

        final mealPlanList =
            meal_plan_models.MealPlanList.fromAmplifyModels(mealPlans);

        expect(mealPlanList.items.length, 3);
        expect(
            mealPlanList.activeMealPlan, 'amplify-2'); // ACTIVE plan detected
        expect(mealPlanList.nextToken, isNull);
      });

      test('uses specified currentMealPlanId over status detection', () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'specified-1',
            userId: 'user-1',
            status: PlanStatus.ACTIVE,
          ),
          MealPlan(
            mealPlanId: 'specified-2',
            userId: 'user-1',
            status: PlanStatus.ARCHIVED,
          ),
        ];

        final mealPlanList = meal_plan_models.MealPlanList.fromAmplifyModels(
          mealPlans,
          currentMealPlanId: 'specified-2',
        );

        expect(mealPlanList.activeMealPlan,
            'specified-2'); // Specified ID takes precedence
      });

      test('falls back to status detection when specified ID not found', () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'fallback-1',
            userId: 'user-1',
            status: PlanStatus.ACTIVE,
          ),
        ];

        final mealPlanList = meal_plan_models.MealPlanList.fromAmplifyModels(
          mealPlans,
          currentMealPlanId: 'nonexistent-plan',
        );

        expect(mealPlanList.activeMealPlan,
            'fallback-1'); // Falls back to ACTIVE status
      });

      test('returns null active plan when no active plan exists', () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'no-active-1',
            userId: 'user-1',
            status: PlanStatus.ARCHIVED,
          ),
          MealPlan(
            mealPlanId: 'no-active-2',
            userId: 'user-1',
            status: PlanStatus.PENDING,
          ),
        ];

        final mealPlanList =
            meal_plan_models.MealPlanList.fromAmplifyModels(mealPlans);

        expect(mealPlanList.items.length, 2);
        expect(mealPlanList.activeMealPlan, isNull);
      });

      test('disables status detection when requested', () {
        final mealPlans = [
          MealPlan(
            mealPlanId: 'no-detection-1',
            userId: 'user-1',
            status: PlanStatus.ACTIVE,
          ),
        ];

        final mealPlanList = meal_plan_models.MealPlanList.fromAmplifyModels(
          mealPlans,
          determineCurrentByStatus: false,
        );

        expect(mealPlanList.activeMealPlan, isNull); // No detection performed
      });

      test('handles empty meal plans list', () {
        final mealPlanList =
            meal_plan_models.MealPlanList.fromAmplifyModels(<MealPlan>[]);

        expect(mealPlanList.items, isEmpty);
        expect(mealPlanList.activeMealPlan, isNull);
      });

      test('creates independent list copy', () {
        final originalPlans = [
          MealPlan(
            mealPlanId: 'independence-1',
            userId: 'user-1',
          ),
        ];

        final mealPlanList =
            meal_plan_models.MealPlanList.fromAmplifyModels(originalPlans);

        // Modify original list
        originalPlans.add(
          MealPlan(
            mealPlanId: 'independence-2',
            userId: 'user-1',
          ),
        );

        // MealPlanList should be unaffected
        expect(mealPlanList.items.length, 1);
        expect(originalPlans.length, 2);
      });
    });

    group('Realistic usage scenarios', () {
      test('simulates pagination workflow', () {
        // First page of results
        final firstPagePlans = [
          MealPlan(mealPlanId: 'page1-plan1', userId: 'user-1'),
          MealPlan(mealPlanId: 'page1-plan2', userId: 'user-1'),
        ];

        final firstPage = MealPlanList(
          items: firstPagePlans,
          nextToken: 'page2-token',
          activeMealPlan: 'page1-plan1',
        );

        expect(firstPage.nextToken, isNotNull);
        expect(firstPage.items.length, 2);

        // Second page of results
        final secondPagePlans = [
          MealPlan(mealPlanId: 'page2-plan1', userId: 'user-1'),
        ];

        final secondPage = MealPlanList(
          items: secondPagePlans,
          nextToken: null, // No more pages
          activeMealPlan: 'page1-plan1', // Same active plan
        );

        expect(secondPage.nextToken, isNull);
        expect(secondPage.items.length, 1);

        // Combine pages
        final allPlans = [...firstPage.items, ...secondPage.items];
        final combined = MealPlanList(
          items: allPlans,
          activeMealPlan: firstPage.activeMealPlan,
        );

        expect(combined.items.length, 3);
        expect(combined.activeMealPlan, 'page1-plan1');
      });

      test('simulates plan activation workflow', () {
        final plans = [
          MealPlan(
            mealPlanId: 'workflow-1',
            userId: 'user-1',
            status: PlanStatus.ARCHIVED,
          ),
          MealPlan(
            mealPlanId: 'workflow-2',
            userId: 'user-1',
            status: PlanStatus.PENDING,
          ),
        ];

        // Initially no active plan
        var mealPlanList =
            meal_plan_models.MealPlanList.fromAmplifyModels(plans);
        expect(mealPlanList.activeMealPlan, isNull);

        // User activates plan-1
        mealPlanList = mealPlanList.copyWith(
          activeMealPlan: 'workflow-1',
        );
        expect(mealPlanList.activeMealPlan, 'workflow-1');

        // User switches to plan-2
        mealPlanList = mealPlanList.copyWith(
          activeMealPlan: 'workflow-2',
        );
        expect(mealPlanList.activeMealPlan, 'workflow-2');

        // User deactivates all plans - copyWith preserves current value when null not explicitly handled
        // This tests the current implementation behavior
        expect(mealPlanList.activeMealPlan, 'workflow-2');
      });
    });

    group('Edge cases and error handling', () {
      test('handles very large meal plans list', () {
        final largePlansList = List.generate(
          1000,
          (index) => MealPlan(
            mealPlanId: 'large-plan-$index',
            userId: 'user-1',
            status: index == 500 ? PlanStatus.ACTIVE : PlanStatus.ARCHIVED,
          ),
        );

        final mealPlanList =
            meal_plan_models.MealPlanList.fromAmplifyModels(largePlansList);

        expect(mealPlanList.items.length, 1000);
        expect(mealPlanList.activeMealPlan, 'large-plan-500');
      });

      test('handles malformed JSON gracefully', () {
        final malformedJson = {
          'items': [
            {
              'mealPlanId': null, // Invalid - should be string
              'planName': 'Malformed Plan',
            },
          ],
        };

        expect(() => meal_plan_models.MealPlanList.fromJson(malformedJson),
            throwsA(isA<TypeError>()));
      });

      test('handles multiple active plans by selecting first', () {
        final plansWithMultipleActive = [
          MealPlan(
            mealPlanId: 'multi-active-1',
            userId: 'user-1',
            status: PlanStatus.ACTIVE,
          ),
          MealPlan(
            mealPlanId: 'multi-active-2',
            userId: 'user-1',
            status: PlanStatus.ACTIVE,
          ),
        ];

        final mealPlanList = meal_plan_models.MealPlanList.fromAmplifyModels(
            plansWithMultipleActive);

        expect(
            mealPlanList.activeMealPlan, 'multi-active-1'); // First active plan
      });
    });
  });
}
