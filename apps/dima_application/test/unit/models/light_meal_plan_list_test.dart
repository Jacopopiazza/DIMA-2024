import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LightMealPlanList', () {
    group('Constructor and initialization', () {
      test('creates LightMealPlanList with required parameters', () {
        final lightPlans = [
          LightMealPlan(mealPlanId: 'light-plan-1'),
          LightMealPlan(mealPlanId: 'light-plan-2'),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);

        expect(lightPlanList.items, lightPlans);
        expect(lightPlanList.nextToken, isNull);
        expect(lightPlanList.activeMealPlan, isNull);
      });

      test('creates LightMealPlanList with all parameters', () {
        final lightPlans = [
          LightMealPlan(
            mealPlanId: 'complete-plan-1',
            planName: 'Complete Plan 1',
            status: PlanStatus.ACTIVE,
          ),
          LightMealPlan(
            mealPlanId: 'complete-plan-2',
            planName: 'Complete Plan 2',
            status: PlanStatus.ARCHIVED,
          ),
        ];
        final nextToken = 'next-page-token-123';
        final activePlan = 'complete-plan-1';

        final lightPlanList = LightMealPlanList(
          items: lightPlans,
          nextToken: nextToken,
          activeMealPlan: activePlan,
        );

        expect(lightPlanList.items, lightPlans);
        expect(lightPlanList.nextToken, nextToken);
        expect(lightPlanList.activeMealPlan, activePlan);
      });

      test('creates LightMealPlanList with empty items list', () {
        final lightPlanList = LightMealPlanList(items: []);

        expect(lightPlanList.items, isEmpty);
        expect(lightPlanList.nextToken, isNull);
        expect(lightPlanList.activeMealPlan, isNull);
      });
    });

    group('Factory constructor fromJson', () {
      test('creates LightMealPlanList from complete GraphQL response', () {
        final json = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'graphql-plan-1',
                'planName': 'GraphQL Plan 1',
                'updatedAt': '2023-12-25T10:30:00.000Z',
                'startDate': '2023-12-20T00:00:00.000Z',
                'endDate': '2023-12-27T23:59:59.999Z',
                'status': 'ACTIVE',
                'validationStatus': 'VALIDATED',
                'errorDetails': null,
              },
              {
                'mealPlanId': 'graphql-plan-2',
                'planName': 'GraphQL Plan 2',
                'updatedAt': '2023-12-24T15:45:00.000Z',
                'status': 'ARCHIVED',
                'validationStatus': 'PENDING_REVIEW',
                'errorDetails': 'Needs nutritionist review',
              },
            ],
            'nextToken': 'graphql-next-token',
            'activeMealPlan': 'graphql-plan-1',
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items.length, 2);

        // Check first item
        final firstItem = lightPlanList.items[0];
        expect(firstItem.mealPlanId, 'graphql-plan-1');
        expect(firstItem.planName, 'GraphQL Plan 1');
        expect(firstItem.updatedAt, DateTime.parse('2023-12-25T10:30:00.000Z'));
        expect(firstItem.startDate, DateTime.parse('2023-12-20T00:00:00.000Z'));
        expect(firstItem.endDate, DateTime.parse('2023-12-27T23:59:59.999Z'));
        expect(firstItem.status, PlanStatus.ACTIVE);
        expect(firstItem.validationStatus, MealPlanValidationStatus.VALIDATED);
        expect(firstItem.errorDetails, isNull);

        // Check second item
        final secondItem = lightPlanList.items[1];
        expect(secondItem.mealPlanId, 'graphql-plan-2');
        expect(secondItem.planName, 'GraphQL Plan 2');
        expect(
            secondItem.updatedAt, DateTime.parse('2023-12-24T15:45:00.000Z'));
        expect(secondItem.status, PlanStatus.ARCHIVED);
        expect(secondItem.validationStatus,
            MealPlanValidationStatus.PENDING_REVIEW);
        expect(secondItem.errorDetails, 'Needs nutritionist review');

        // Check list metadata
        expect(lightPlanList.nextToken, 'graphql-next-token');
        expect(lightPlanList.activeMealPlan, 'graphql-plan-1');
      });

      test('handles empty GraphQL response', () {
        final json = {
          'listMyMealPlans': {
            'items': <Map<String, dynamic>>[],
            'nextToken': null,
            'activeMealPlan': null,
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items, isEmpty);
        expect(lightPlanList.nextToken, isNull);
        expect(lightPlanList.activeMealPlan, isNull);
      });

      test('handles minimal GraphQL response with required fields only', () {
        final json = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'minimal-plan-1',
              },
              {
                'mealPlanId': 'minimal-plan-2',
              },
            ],
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items.length, 2);
        expect(lightPlanList.items[0].mealPlanId, 'minimal-plan-1');
        expect(lightPlanList.items[0].planName, isNull);
        expect(lightPlanList.items[1].mealPlanId, 'minimal-plan-2');
        expect(lightPlanList.nextToken, isNull);
        expect(lightPlanList.activeMealPlan, isNull);
      });

      test('handles missing listMyMealPlans wrapper', () {
        final json = <String, dynamic>{};

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items, isEmpty);
        expect(lightPlanList.nextToken, isNull);
        expect(lightPlanList.activeMealPlan, isNull);
      });

      test('handles null listMyMealPlans', () {
        final json = {
          'listMyMealPlans': null,
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items, isEmpty);
        expect(lightPlanList.nextToken, isNull);
        expect(lightPlanList.activeMealPlan, isNull);
      });

      test('handles items with null values in the list', () {
        final json = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'valid-plan-1',
                'planName': 'Valid Plan',
              },
              null, // This should be filtered out
              {
                'mealPlanId': 'valid-plan-2',
                'planName': 'Another Valid Plan',
              },
            ],
            'nextToken': 'filtered-token',
            'activeMealPlan': 'valid-plan-1',
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items.length, 2); // Null item filtered out
        expect(lightPlanList.items[0].mealPlanId, 'valid-plan-1');
        expect(lightPlanList.items[1].mealPlanId, 'valid-plan-2');
        expect(lightPlanList.nextToken, 'filtered-token');
        expect(lightPlanList.activeMealPlan, 'valid-plan-1');
      });

      test('handles unknown enum values in nested items', () {
        final json = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'unknown-enum-plan',
                'status': 'UNKNOWN_STATUS',
                'validationStatus': 'UNKNOWN_VALIDATION',
              },
            ],
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items.length, 1);
        expect(
            lightPlanList.items[0].status, isNull); // Unknown enum becomes null
        expect(lightPlanList.items[0].validationStatus, isNull);
      });

      test('handles complex nested structure with all possible fields', () {
        final json = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'complex-plan-1',
                'planName': 'Complex Plan with All Fields',
                'updatedAt': '2023-12-25T10:30:00.000Z',
                'startDate': '2023-12-20T00:00:00.000Z',
                'endDate': '2023-12-27T23:59:59.999Z',
                'status': 'PENDING',
                'validationStatus': 'REJECTED',
                'errorDetails':
                    'Detailed error message with special chars: 🚫💯',
              },
            ],
            'nextToken': 'complex-token-123',
            'activeMealPlan': 'complex-plan-1',
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(json);

        expect(lightPlanList.items.length, 1);
        final plan = lightPlanList.items[0];
        expect(plan.mealPlanId, 'complex-plan-1');
        expect(plan.planName, 'Complex Plan with All Fields');
        expect(plan.updatedAt, DateTime.parse('2023-12-25T10:30:00.000Z'));
        expect(plan.startDate, DateTime.parse('2023-12-20T00:00:00.000Z'));
        expect(plan.endDate, DateTime.parse('2023-12-27T23:59:59.999Z'));
        expect(plan.status, PlanStatus.PENDING);
        expect(plan.validationStatus, MealPlanValidationStatus.REJECTED);
        expect(plan.errorDetails,
            'Detailed error message with special chars: 🚫💯');
        expect(lightPlanList.nextToken, 'complex-token-123');
        expect(lightPlanList.activeMealPlan, 'complex-plan-1');
      });
    });

    group('toJson method', () {
      test('converts complete LightMealPlanList to JSON', () {
        final lightPlans = [
          LightMealPlan(
            mealPlanId: 'to-json-plan-1',
            planName: 'JSON Plan 1',
            updatedAt: DateTime(2023, 12, 25, 10, 30, 0),
            status: PlanStatus.ACTIVE,
            validationStatus: MealPlanValidationStatus.VALIDATED,
          ),
          LightMealPlan(
            mealPlanId: 'to-json-plan-2',
            planName: 'JSON Plan 2',
            updatedAt: DateTime(2023, 12, 24, 15, 45, 0),
            status: PlanStatus.ARCHIVED,
            validationStatus: MealPlanValidationStatus.PENDING_REVIEW,
            errorDetails: 'Review needed',
          ),
        ];

        final lightPlanList = LightMealPlanList(
          items: lightPlans,
          nextToken: 'to-json-token',
          activeMealPlan: 'to-json-plan-1',
        );

        final json = lightPlanList.toJson();

        expect(json['items'], isA<List>());
        expect(json['items'].length, 2);

        // Check first item JSON
        final firstItemJson = json['items'][0];
        expect(firstItemJson['mealPlanId'], 'to-json-plan-1');
        expect(firstItemJson['planName'], 'JSON Plan 1');
        expect(firstItemJson['updatedAt'], '2023-12-25T10:30:00.000');
        expect(firstItemJson['status'], 'ACTIVE');
        expect(firstItemJson['validationStatus'], 'VALIDATED');

        // Check second item JSON
        final secondItemJson = json['items'][1];
        expect(secondItemJson['mealPlanId'], 'to-json-plan-2');
        expect(secondItemJson['planName'], 'JSON Plan 2');
        expect(secondItemJson['updatedAt'], '2023-12-24T15:45:00.000');
        expect(secondItemJson['status'], 'ARCHIVED');
        expect(secondItemJson['validationStatus'], 'PENDING_REVIEW');
        expect(secondItemJson['errorDetails'], 'Review needed');

        // Check list metadata
        expect(json['nextToken'], 'to-json-token');
        expect(json['activeMealPlan'], 'to-json-plan-1');
      });

      test('converts minimal LightMealPlanList to JSON', () {
        final lightPlanList = LightMealPlanList(items: []);

        final json = lightPlanList.toJson();

        expect(json['items'], isEmpty);
        expect(json['nextToken'], isNull);
        expect(json['activeMealPlan'], isNull);
      });

      test('converts LightMealPlanList with null values to JSON', () {
        final lightPlans = [
          LightMealPlan(mealPlanId: 'null-values-plan'),
        ];

        final lightPlanList = LightMealPlanList(
          items: lightPlans,
          nextToken: null,
          activeMealPlan: null,
        );

        final json = lightPlanList.toJson();

        expect(json['items'].length, 1);
        expect(json['items'][0]['mealPlanId'], 'null-values-plan');
        expect(json['nextToken'], isNull);
        expect(json['activeMealPlan'], isNull);
      });

      test('round-trip conversion preserves data', () {
        final originalList = LightMealPlanList(
          items: [
            LightMealPlan(
              mealPlanId: 'round-trip-plan-1',
              planName: 'Round Trip Plan 1',
              updatedAt: DateTime(2023, 6, 15, 14, 30, 0),
              status: PlanStatus.PENDING,
              validationStatus: MealPlanValidationStatus.PENDING_REVIEW,
            ),
            LightMealPlan(
              mealPlanId: 'round-trip-plan-2',
              planName: 'Round Trip Plan 2',
              startDate: DateTime(2023, 6, 10),
              endDate: DateTime(2023, 6, 20),
              status: PlanStatus.ACTIVE,
              validationStatus: MealPlanValidationStatus.VALIDATED,
            ),
          ],
          nextToken: 'round-trip-token',
          activeMealPlan: 'round-trip-plan-2',
        );

        final json = originalList.toJson();

        // Note: Round-trip through GraphQL format
        final graphqlJson = {
          'listMyMealPlans': json,
        };

        final reconstructed = LightMealPlanList.fromJson(graphqlJson);

        expect(reconstructed.items.length, originalList.items.length);
        expect(reconstructed.nextToken, originalList.nextToken);
        expect(reconstructed.activeMealPlan, originalList.activeMealPlan);

        // Check first item
        expect(reconstructed.items[0].mealPlanId,
            originalList.items[0].mealPlanId);
        expect(reconstructed.items[0].planName, originalList.items[0].planName);
        expect(
            reconstructed.items[0].updatedAt, originalList.items[0].updatedAt);
        expect(reconstructed.items[0].status, originalList.items[0].status);
        expect(reconstructed.items[0].validationStatus,
            originalList.items[0].validationStatus);

        // Check second item
        expect(reconstructed.items[1].mealPlanId,
            originalList.items[1].mealPlanId);
        expect(reconstructed.items[1].planName, originalList.items[1].planName);
        expect(
            reconstructed.items[1].startDate, originalList.items[1].startDate);
        expect(reconstructed.items[1].endDate, originalList.items[1].endDate);
        expect(reconstructed.items[1].status, originalList.items[1].status);
        expect(reconstructed.items[1].validationStatus,
            originalList.items[1].validationStatus);
      });
    });

    group('sortByUpdatedAtDesc method', () {
      test('sorts plans by updatedAt in descending order', () {
        final oldDate = DateTime(2023, 1, 1);
        final middleDate = DateTime(2023, 6, 15);
        final newDate = DateTime(2023, 12, 25);

        final lightPlans = [
          LightMealPlan(mealPlanId: 'old-plan', updatedAt: oldDate),
          LightMealPlan(mealPlanId: 'new-plan', updatedAt: newDate),
          LightMealPlan(mealPlanId: 'middle-plan', updatedAt: middleDate),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);

        // Before sorting - check original order
        expect(lightPlanList.items[0].mealPlanId, 'old-plan');
        expect(lightPlanList.items[1].mealPlanId, 'new-plan');
        expect(lightPlanList.items[2].mealPlanId, 'middle-plan');

        // Sort by updated date descending
        lightPlanList.sortByUpdatedAtDesc();

        // After sorting - newest first
        expect(lightPlanList.items[0].mealPlanId, 'new-plan');
        expect(lightPlanList.items[1].mealPlanId, 'middle-plan');
        expect(lightPlanList.items[2].mealPlanId, 'old-plan');
      });

      test('handles plans with null updatedAt values', () {
        final realDate = DateTime(2023, 6, 15);

        final lightPlans = [
          LightMealPlan(mealPlanId: 'no-date-1', updatedAt: null),
          LightMealPlan(mealPlanId: 'with-date', updatedAt: realDate),
          LightMealPlan(mealPlanId: 'no-date-2', updatedAt: null),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);
        lightPlanList.sortByUpdatedAtDesc();

        // Plan with real date should be first
        expect(lightPlanList.items[0].mealPlanId, 'with-date');
        // Null dates treated as epoch (very old), so they go to the end
        expect(lightPlanList.items[1].mealPlanId, 'no-date-1');
        expect(lightPlanList.items[2].mealPlanId, 'no-date-2');
      });

      test('handles empty list', () {
        final lightPlanList = LightMealPlanList(items: []);

        // Should not throw an error
        expect(() => lightPlanList.sortByUpdatedAtDesc(), returnsNormally);
        expect(lightPlanList.items, isEmpty);
      });

      test('handles single item list', () {
        final lightPlans = [
          LightMealPlan(mealPlanId: 'single-plan', updatedAt: DateTime.now()),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);
        lightPlanList.sortByUpdatedAtDesc();

        expect(lightPlanList.items.length, 1);
        expect(lightPlanList.items[0].mealPlanId, 'single-plan');
      });

      test('handles plans with identical updatedAt values', () {
        final sameDate = DateTime(2023, 6, 15);

        final lightPlans = [
          LightMealPlan(mealPlanId: 'plan-a', updatedAt: sameDate),
          LightMealPlan(mealPlanId: 'plan-b', updatedAt: sameDate),
          LightMealPlan(mealPlanId: 'plan-c', updatedAt: sameDate),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);
        lightPlanList.sortByUpdatedAtDesc();

        // Should maintain stable sort (original order preserved for equal elements)
        expect(lightPlanList.items.length, 3);
        // All plans should still be present
        expect(lightPlanList.items.map((p) => p.mealPlanId).toSet(),
            {'plan-a', 'plan-b', 'plan-c'});
      });

      test('modifies original list in place', () {
        final lightPlans = [
          LightMealPlan(mealPlanId: 'first', updatedAt: DateTime(2023, 1, 1)),
          LightMealPlan(mealPlanId: 'second', updatedAt: DateTime(2023, 12, 1)),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);
        final originalItems = lightPlanList.items;

        lightPlanList.sortByUpdatedAtDesc();

        // Should be the same object reference (in-place modification)
        expect(identical(lightPlanList.items, originalItems), true);
        expect(lightPlanList.items[0].mealPlanId,
            'second'); // Newest first after sort
      });
    });

    group('Realistic usage scenarios', () {
      test('handles typical GraphQL API response structure', () {
        final typicalApiResponse = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'plan-001',
                'planName': 'Weekly Meal Plan',
                'updatedAt': '2023-12-25T10:30:00.000Z',
                'startDate': '2023-12-25T00:00:00.000Z',
                'endDate': '2023-12-31T23:59:59.999Z',
                'status': 'ACTIVE',
                'validationStatus': 'VALIDATED',
                'errorDetails': null,
              },
              {
                'mealPlanId': 'plan-002',
                'planName': 'Previous Week',
                'updatedAt': '2023-12-18T14:20:00.000Z',
                'startDate': '2023-12-18T00:00:00.000Z',
                'endDate': '2023-12-24T23:59:59.999Z',
                'status': 'ARCHIVED',
                'validationStatus': 'VALIDATED',
                'errorDetails': null,
              },
            ],
            'nextToken': 'eyJsaW1pdCI6MjB9',
            'activeMealPlan': 'plan-001',
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(typicalApiResponse);

        expect(lightPlanList.items.length, 2);
        expect(lightPlanList.activeMealPlan, 'plan-001');
        expect(lightPlanList.nextToken, 'eyJsaW1pdCI6MjB9');

        // Active plan should be properly identified
        final activePlan = lightPlanList.items.firstWhere(
            (plan) => plan.mealPlanId == lightPlanList.activeMealPlan);
        expect(activePlan.status, PlanStatus.ACTIVE);

        // Test sorting functionality
        lightPlanList.sortByUpdatedAtDesc();
        expect(
            lightPlanList.items[0].mealPlanId, 'plan-001'); // Most recent first
      });

      test('supports pagination workflow', () {
        // First page
        final firstPageResponse = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'plan-page1-1',
                'updatedAt': '2023-12-25T10:00:00.000Z'
              },
              {
                'mealPlanId': 'plan-page1-2',
                'updatedAt': '2023-12-24T10:00:00.000Z'
              },
            ],
            'nextToken': 'page2-token',
            'activeMealPlan': 'plan-page1-1',
          },
        };

        // Second page
        final secondPageResponse = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'plan-page2-1',
                'updatedAt': '2023-12-23T10:00:00.000Z'
              },
              {
                'mealPlanId': 'plan-page2-2',
                'updatedAt': '2023-12-22T10:00:00.000Z'
              },
            ],
            'nextToken': null,
            'activeMealPlan':
                'plan-page1-1', // Active plan ID persists across pages
          },
        };

        final firstPage = LightMealPlanList.fromJson(firstPageResponse);
        final secondPage = LightMealPlanList.fromJson(secondPageResponse);

        expect(firstPage.nextToken, 'page2-token');
        expect(secondPage.nextToken, isNull);
        expect(firstPage.activeMealPlan, secondPage.activeMealPlan);

        // Combine pages
        final allItems = [...firstPage.items, ...secondPage.items];
        final combinedList = LightMealPlanList(
          items: allItems,
          activeMealPlan: firstPage.activeMealPlan,
        );

        expect(combinedList.items.length, 4);
        expect(combinedList.activeMealPlan, 'plan-page1-1');
      });

      test('handles error scenarios and validation states', () {
        final errorResponse = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'failed-plan-1',
                'planName': 'Failed Validation Plan',
                'updatedAt': '2023-12-25T10:00:00.000Z',
                'status': 'ARCHIVED',
                'validationStatus': 'REJECTED',
                'errorDetails':
                    'Insufficient protein content for user requirements',
              },
              {
                'mealPlanId': 'pending-plan-1',
                'planName': 'Awaiting Review',
                'updatedAt': '2023-12-25T09:00:00.000Z',
                'status': 'PENDING',
                'validationStatus': 'PENDING_REVIEW',
                'errorDetails': null,
              },
            ],
            'nextToken': null,
            'activeMealPlan': null, // No active plan when all failed/pending
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(errorResponse);

        expect(lightPlanList.items.length, 2);
        expect(lightPlanList.activeMealPlan, isNull);

        // Check error handling
        final failedPlan = lightPlanList.items[0];
        expect(failedPlan.validationStatus, MealPlanValidationStatus.REJECTED);
        expect(failedPlan.errorDetails, contains('protein content'));

        final pendingPlan = lightPlanList.items[1];
        expect(pendingPlan.validationStatus,
            MealPlanValidationStatus.PENDING_REVIEW);
        expect(pendingPlan.errorDetails, isNull);
      });

      test('supports filtering and searching operations', () {
        final searchableResponse = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'keto-plan-001',
                'planName': 'Keto Diet Plan',
                'status': 'ACTIVE',
                'validationStatus': 'VALIDATED',
              },
              {
                'mealPlanId': 'vegan-plan-001',
                'planName': 'Vegan Meal Plan',
                'status': 'ARCHIVED',
                'validationStatus': 'VALIDATED',
              },
              {
                'mealPlanId': 'mediterranean-plan-001',
                'planName': 'Mediterranean Diet',
                'status': 'PENDING',
                'validationStatus': 'PENDING_REVIEW',
              },
            ],
            'activeMealPlan': 'keto-plan-001',
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(searchableResponse);

        // Filter by status
        final activePlans = lightPlanList.items
            .where((plan) => plan.status == PlanStatus.ACTIVE)
            .toList();
        expect(activePlans.length, 1);
        expect(activePlans[0].planName, 'Keto Diet Plan');

        // Filter by validation status
        final validatedPlans = lightPlanList.items
            .where((plan) =>
                plan.validationStatus == MealPlanValidationStatus.VALIDATED)
            .toList();
        expect(validatedPlans.length, 2);

        // Search by name content
        final dietPlans = lightPlanList.items
            .where((plan) =>
                plan.planName?.toLowerCase().contains('diet') ?? false)
            .toList();
        expect(dietPlans.length, 2); // Keto Diet and Mediterranean Diet
      });
    });

    group('Edge cases and robustness', () {
      test('handles malformed JSON gracefully', () {
        final malformedJson = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'valid-plan',
                'planName': 'Valid Plan',
              },
              {
                // Missing required mealPlanId - this should cause an error in LightMealPlan.fromJson
                'planName': 'Invalid Plan - No ID',
              },
            ],
          },
        };

        // The fromJson should throw an error due to missing required field
        expect(() => LightMealPlanList.fromJson(malformedJson),
            throwsA(isA<TypeError>()));
      });

      test('handles very large response lists', () {
        final largeItemsList = List.generate(
            1000,
            (index) => {
                  'mealPlanId': 'large-plan-$index',
                  'planName': 'Large Plan $index',
                  'updatedAt': DateTime(2023, 1, 1)
                      .add(Duration(hours: index))
                      .toIso8601String(),
                  'status': index % 3 == 0
                      ? 'ACTIVE'
                      : index % 3 == 1
                          ? 'ARCHIVED'
                          : 'PENDING',
                });

        final largeResponse = {
          'listMyMealPlans': {
            'items': largeItemsList,
            'nextToken': 'large-list-token',
            'activeMealPlan': 'large-plan-0',
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(largeResponse);

        expect(lightPlanList.items.length, 1000);
        expect(lightPlanList.nextToken, 'large-list-token');
        expect(lightPlanList.activeMealPlan, 'large-plan-0');

        // Test sorting performance with large list
        final stopwatch = Stopwatch()..start();
        lightPlanList.sortByUpdatedAtDesc();
        stopwatch.stop();

        // Sorting should complete in reasonable time (less than 1 second for 1000 items)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify sort worked correctly
        expect(lightPlanList.items[0].mealPlanId,
            'large-plan-999'); // Most recent first
        expect(
            lightPlanList.items[999].mealPlanId, 'large-plan-0'); // Oldest last
      });

      test('handles plans with special characters and unicode', () {
        final unicodeResponse = {
          'listMyMealPlans': {
            'items': [
              {
                'mealPlanId': 'unicode-plan-🍎',
                'planName': 'Plan with emojis 🥗🍽️ and unicode: àáâãäåæçèéêë',
                'errorDetails': 'Error with special chars: ñáéíóú 漢字 العربية',
              },
            ],
          },
        };

        final lightPlanList = LightMealPlanList.fromJson(unicodeResponse);

        expect(lightPlanList.items.length, 1);
        expect(lightPlanList.items[0].mealPlanId, 'unicode-plan-🍎');
        expect(lightPlanList.items[0].planName, contains('🥗🍽️'));
        expect(lightPlanList.items[0].planName, contains('àáâãäåæçèéêë'));
        expect(lightPlanList.items[0].errorDetails, contains('漢字'));
        expect(lightPlanList.items[0].errorDetails, contains('العربية'));

        // Test round-trip with unicode
        final json = lightPlanList.toJson();
        final reconstructed =
            LightMealPlanList.fromJson({'listMyMealPlans': json});

        expect(reconstructed.items[0].mealPlanId,
            lightPlanList.items[0].mealPlanId);
        expect(
            reconstructed.items[0].planName, lightPlanList.items[0].planName);
        expect(reconstructed.items[0].errorDetails,
            lightPlanList.items[0].errorDetails);
      });

      test('handles concurrent modifications during sorting', () {
        final lightPlans = [
          LightMealPlan(
              mealPlanId: 'concurrent-plan-1', updatedAt: DateTime(2023, 1, 1)),
          LightMealPlan(
              mealPlanId: 'concurrent-plan-2', updatedAt: DateTime(2023, 6, 1)),
          LightMealPlan(
              mealPlanId: 'concurrent-plan-3',
              updatedAt: DateTime(2023, 12, 1)),
        ];

        final lightPlanList = LightMealPlanList(items: lightPlans);

        // Modify list during sorting (this is just a test to ensure it doesn't crash)
        lightPlanList.sortByUpdatedAtDesc();

        expect(lightPlanList.items.length, 3);
        expect(lightPlanList.items[0].mealPlanId,
            'concurrent-plan-3'); // Most recent
      });
    });
  });
}
