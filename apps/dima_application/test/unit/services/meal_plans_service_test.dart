import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:async/async.dart' as async_pkg;
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter_test/flutter_test.dart';

// A minimal fake GraphQLOperation that returns a prebuilt response
class _FakeGraphQLOperation<T> implements GraphQLOperation<T> {
  _FakeGraphQLOperation(this._response);

  final Future<GraphQLResponse<T>> _response;

  @override
  Future<GraphQLResponse<T>> get response => _response;

  // GraphQLOperation exposes cancel on some platforms; provide a no-op.
  @override
  Future<void> cancel() async {}

  // Below are required members of AWSOperation; provide inert implementations
  @override
  Future<void> close() async {}

  @override
  String get id => 'fake-operation-id';

  @override
  amplify_core.AWSLogger get logger =>
      amplify_core.AWSLogger().createChild('fake');

  @override
  String get runtimeTypeName => 'GraphQLOperation';

  @override
  async_pkg.CancelableOperation<GraphQLResponse<T>> get operation =>
      async_pkg.CancelableOperation<GraphQLResponse<T>>.fromFuture(_response);
}

// Fake AmplifyGraphQL proxy returning a canned JSON payload
class _FakeAmplifyGraphQL extends AmplifyGraphQL {
  _FakeAmplifyGraphQL({
    this.queryPayload, 
    this.mutationPayload,
    this.hasErrors = false
  });

  final Map<String, dynamic>? queryPayload;
  final Map<String, dynamic>? mutationPayload;
  final bool hasErrors;

  @override
  GraphQLOperation<String> query<String>(
      {required GraphQLRequest<String> request}) {
    final payload = queryPayload ?? {};
    final response = GraphQLResponse<String>(
      data: jsonEncode(payload) as String,
      errors: hasErrors
          ? [const GraphQLResponseError(message: 'fake query error')]
          : const [],
    );
    return _FakeGraphQLOperation<String>(Future.value(response));
  }

  @override
  GraphQLOperation<String> mutate<String>(
      {required GraphQLRequest<String> request}) {
    final payload = mutationPayload ?? {};
    final response = GraphQLResponse<String>(
      data: jsonEncode(payload) as String,
      errors: hasErrors
          ? [const GraphQLResponseError(message: 'fake mutation error')]
          : const [],
    );
    return _FakeGraphQLOperation<String>(Future.value(response));
  }
}

void main() {
  group('MealPlansService.listMyMealPlans', () {
    test('returns parsed LightMealPlanList from mocked AmplifyGraphQL',
        () async {
      final fakeJson = {
        'listMyMealPlans': {
          'activeMealPlan': 'mp-2',
          'nextToken': null,
          'items': [
            {
              'mealPlanId': 'mp-1',
              'planName': 'Plan A',
              'status': 'ACTIVE',
              'updatedAt': '2024-06-02T12:00:00.000Z',
            },
            {
              'mealPlanId': 'mp-2',
              'planName': 'Plan B',
              'status': 'DRAFT',
              'updatedAt': '2024-06-03T12:00:00.000Z',
            },
          ],
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(queryPayload: fakeJson),
      );

      final result = await service.listMyMealPlans(limit: 5);

      expect(result, isA<LightMealPlanList>());
      expect(result.items.length, 2);
      expect(result.activeMealPlan, 'mp-2');
      // Sorted desc by updatedAt -> first item should be mp-2
      expect(result.items.first.mealPlanId, 'mp-2');
      expect(result.items.first.planName, 'Plan B');
    });

    test('returns empty list on GraphQL error', () async {
      final fakeJson = {
        'listMyMealPlans': {
          'activeMealPlan': null,
          'nextToken': null,
          'items': [],
        }
      };

      final service = MealPlansService(
        amplifyGraphQL:
            _FakeAmplifyGraphQL(queryPayload: fakeJson, hasErrors: true),
      );

      final result = await service.listMyMealPlans(limit: 5);

      expect(result.items, isEmpty);
      expect(result.activeMealPlan, isNull);
    });
  });

  group('MealPlansService.getMealPlanById', () {
    test('returns parsed MealPlan from mocked response', () async {
      final fakeJson = {
        'getMealPlanById': {
          'mealPlanId': 'mp-123',
          'planName': 'Test Plan',
          'status': 'ACTIVE',
          'validationStatus': 'APPROVED',
          'generatedAt': '2024-06-01T10:00:00.000Z',
          'dailyPlan': {
            'monday': [
              {
                'name': 'BREAKFAST',
                'recipeName': 'Test Recipe',
                'ingredients': [],
                'totalMacros': {
                  'proteins': 20,
                  'carbohydrates': 30,
                  'fats': 10,
                  'calories': 280
                },
                'recipe': 'Test recipe instructions'
              }
            ]
          }
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(queryPayload: fakeJson),
      );

      final result = await service.getMealPlanById('mp-123');

      expect(result, isNotNull);
      expect(result!.mealPlanId, 'mp-123');
      expect(result.planName, 'Test Plan');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      expect(() => service.getMealPlanById('mp-123'), throwsException);
    });

    test('returns null when meal plan not found', () async {
      final fakeJson = {
        'getMealPlanById': null
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(queryPayload: fakeJson),
      );

      final result = await service.getMealPlanById('mp-nonexistent');
      expect(result, isNull);
    });
  });

  group('MealPlansService.deleteMealPlan', () {
    test('returns success response on successful deletion', () async {
      final fakeJson = {
        'deleteMealPlan': {
          'success': true,
          'message': 'Meal plan deleted successfully',
          'mealPlanId': 'mp-123'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final result = await service.deleteMealPlan('mp-123');

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.message, 'Meal plan deleted successfully');
      expect(result.mealPlanId, 'mp-123');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.deleteMealPlan('mp-123');
      expect(result, isNull);
    });
  });

  group('MealPlansService.setActiveMealPlan', () {
    test('returns success response when setting active meal plan', () async {
      final fakeJson = {
        'setActiveMealPlan': {
          'success': true,
          'message': 'Meal plan set as active',
          'mealPlanId': 'mp-123'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final result = await service.setActiveMealPlan('mp-123');

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.message, 'Meal plan set as active');
      expect(result.mealPlanId, 'mp-123');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.setActiveMealPlan('mp-123');
      expect(result, isNull);
    });
  });

  group('MealPlansService.createMealPlan', () {
    test('returns success response when creating meal plan', () async {
      final fakeJson = {
        'requestNewMealPlan': {
          'success': true,
          'message': 'Meal plan created successfully',
          'mealPlanId': 'mp-new'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final input = {
        'planName': 'New Plan',
        'status': 'ACTIVE',
      };

      final result = await service.createMealPlan(input);

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.message, 'Meal plan created successfully');
      expect(result.mealPlanId, 'mp-new');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.createMealPlan({});
      expect(result, isNull);
    });
  });

  group('MealPlansService.createRandomMealPlan', () {
    test('creates a random meal plan successfully', () async {
      final fakeJson = {
        'requestNewMealPlan': {
          'success': true,
          'message': 'Random meal plan created',
          'mealPlanId': 'mp-random'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final result = await service.createRandomMealPlan();

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.mealPlanId, 'mp-random');
    });

    test('returns null on error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.createRandomMealPlan();
      expect(result, isNull);
    });
  });

  group('MealPlansService.modifyMealPlan', () {
    test('returns success response when modifying meal plan', () async {
      final fakeJson = {
        'modifyMealPlan': {
          'success': true,
          'message': 'Meal plan modified successfully',
          'mealPlanId': 'mp-123'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final result = await service.modifyMealPlan('mp-123', 'Updated Plan Name');

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.message, 'Meal plan modified successfully');
      expect(result.mealPlanId, 'mp-123');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.modifyMealPlan('mp-123', 'New Name');
      expect(result, isNull);
    });
  });

  group('MealPlansService.listNutritionists', () {
    test('returns list of nutritionists', () async {
      final fakeJson = {
        'listNutritionists': {
          'items': [
            {
              'id': 'nut-1',
              'nutritionistId': 'nut-1',
              'givenName': 'John',
              'familyName': 'Doe',
              'specialization': 'Sports Nutrition',
              'bio': 'Expert in sports nutrition',
              'isAvailable': true
            },
            {
              'id': 'nut-2',
              'nutritionistId': 'nut-2',
              'givenName': 'Jane',
              'familyName': 'Smith',
              'specialization': 'Weight Management',
              'bio': 'Expert in weight management',
              'isAvailable': false
            }
          ],
          'nextToken': null
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(queryPayload: fakeJson),
      );

      final result = await service.listNutritionists();

      expect(result, hasLength(2));
      expect(result.first.givenName, 'John');
      expect(result.first.isAvailable, true);
      expect(result[1].givenName, 'Jane');
      expect(result[1].isAvailable, false);
    });

    test('returns empty list on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.listNutritionists();
      expect(result, isEmpty);
    });
  });

  group('MealPlansService.assignNutritionistToPlan', () {
    test('returns success response when assigning nutritionist', () async {
      final fakeJson = {
        'assignNutritionistToPlan': {
          'mealPlanId': 'mp-123',
          'planName': 'Test Plan',
          'assignedNutritionistId': 'nut-1',
          'validationStatus': 'PENDING'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final result = await service.assignNutritionistToPlan('mp-123', 'nut-1');

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.message, 'Nutritionist assigned successfully');
      expect(result.mealPlanId, 'mp-123');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.assignNutritionistToPlan('mp-123', 'nut-1');
      expect(result, isNull);
    });
  });

  group('MealPlansService.requestValidation', () {
    test('returns success response when requesting validation', () async {
      final fakeJson = {
        'requestValidation': {
          'success': true,
          'message': 'Validation requested successfully',
          'mealPlanId': 'mp-123'
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(mutationPayload: fakeJson),
      );

      final result = await service.requestValidation('mp-123', 'nut-1');

      expect(result, isNotNull);
      expect(result!.success, true);
      expect(result.message, 'Validation requested successfully');
      expect(result.mealPlanId, 'mp-123');
    });

    test('returns null on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.requestValidation('mp-123', 'nut-1');
      expect(result, isNull);
    });
  });

  group('MealPlansService.listMyAssignedMealPlans', () {
    test('returns list of assigned meal plans', () async {
      final fakeJson = {
        'listMyAssignedMealPlans': {
          'items': [
            {
              'mealPlanId': 'mp-assigned-1',
              'planName': 'Assigned Plan 1',
              'status': 'ACTIVE',
              'validationStatus': 'PENDING',
              'userId': 'user-1',
              'assignedNutritionistId': 'nut-1',
              'generatedAt': '2024-06-01T10:00:00.000Z',
              'dailyPlan': {}
            }
          ],
          'nextToken': null
        }
      };

      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(queryPayload: fakeJson),
      );

      final result = await service.listMyAssignedMealPlans();

      expect(result, hasLength(1));
      expect(result.first.mealPlanId, 'mp-assigned-1');
      expect(result.first.planName, 'Assigned Plan 1');
    });

    test('returns empty list on GraphQL error', () async {
      final service = MealPlansService(
        amplifyGraphQL: _FakeAmplifyGraphQL(hasErrors: true),
      );

      final result = await service.listMyAssignedMealPlans();
      expect(result, isEmpty);
    });
  });
}
