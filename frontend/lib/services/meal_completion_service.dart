import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:isar/isar.dart';

class MealCompletionService {
  final Isar? isar;
  final AmplifyGraphQL _amplifyGraphQL;

  MealCompletionService({this.isar, AmplifyGraphQL? amplifyGraphQL})
      : _amplifyGraphQL = amplifyGraphQL ?? AmplifyGraphQL();

  /// Marks a meal as completed on the server
  Future<PlanDayCompletion?> markMealAsCompleted({
    required MealNameEnum mealName,
    required String mealPlanId,
    DateTime? date,
  }) async {
    try {
      final targetDate = date ?? DateTime.now();
      final dateString = _formatDate(targetDate);

      safePrint(
          '[MealCompletionService] Marking meal as completed: $mealName for plan $mealPlanId on $dateString');

      final request = GraphQLRequest<String>(
        document: '''
          mutation MarkMealAsCompleted(\$input: MarkMealCompletedInput!) {
            markMealAsCompleted(input: \$input) {
              planId
              date
              completedMealNames
              updatedAt
              userId
            }
          }
        ''',
        variables: {
          'input': {
            'mealName': mealName.name,
            'mealPlanId': mealPlanId,
            'date': dateString,
          }
        },
        decodePath: 'markMealAsCompleted',
      );

      final response = await _amplifyGraphQL.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint('[MealCompletionService] GraphQL errors: ${response.errors}');
        throw Exception(
            'Failed to mark meal as completed: ${response.errors.first.message}');
      }

      if (response.data == null) {
        throw Exception('No data returned from server');
      }

      final Map<String, dynamic> jsonData = json.decode(response.data!);
      final data = jsonData['markMealAsCompleted'];

      if (data == null) {
        throw Exception('Invalid response structure');
      }

      // Create PlanDayCompletion from response
      final completion = PlanDayCompletion.fromJson({
        'id': '${data['planId']}_${data['date']}', // Create a composite ID
        'planId': data['planId'],
        'date': data['date'],
        'completedMealNames': data['completedMealNames'],
        'updatedAt': data['updatedAt'],
        'userId': data['userId'],
      });

      safePrint(
          '[MealCompletionService] Successfully marked meal as completed');
      return completion;
    } catch (e) {
      safePrint('[MealCompletionService] Error marking meal as completed: $e');
      rethrow;
    }
  }

  /// Unmarks a meal as completed on the server
  Future<PlanDayCompletion?> unmarkMealAsCompleted({
    required MealNameEnum mealName,
    required String mealPlanId,
    DateTime? date,
  }) async {
    try {
      final targetDate = date ?? DateTime.now();
      final dateString = _formatDate(targetDate);

      safePrint(
          '[MealCompletionService] Unmarking meal as completed: $mealName for plan $mealPlanId on $dateString');

      final request = GraphQLRequest<String>(
        document: '''
          mutation UnmarkMealAsCompleted(\$input: UnmarkMealCompletedInput!) {
            unmarkMealAsCompleted(input: \$input) {
              planId
              date
              completedMealNames
              updatedAt
              userId
            }
          }
        ''',
        variables: {
          'input': {
            'mealName': mealName.name,
            'mealPlanId': mealPlanId,
            'date': dateString,
          }
        },
        decodePath: 'unmarkMealAsCompleted',
      );

      final response = await _amplifyGraphQL.mutate(request: request).response;

      if (response.hasErrors) {
        safePrint('[MealCompletionService] GraphQL errors: ${response.errors}');
        throw Exception(
            'Failed to unmark meal as completed: ${response.errors.first.message}');
      }

      if (response.data == null) {
        throw Exception('No data returned from server');
      }

      final Map<String, dynamic> jsonData = json.decode(response.data!);
      final data = jsonData['unmarkMealAsCompleted'];

      if (data == null) {
        throw Exception('Invalid response structure');
      }

      // Create PlanDayCompletion from response
      final completion = PlanDayCompletion.fromJson({
        'id': '${data['planId']}_${data['date']}', // Create a composite ID
        'planId': data['planId'],
        'date': data['date'],
        'completedMealNames': data['completedMealNames'],
        'updatedAt': data['updatedAt'],
        'userId': data['userId'],
      });

      safePrint(
          '[MealCompletionService] Successfully unmarked meal as completed');
      return completion;
    } catch (e) {
      safePrint(
          '[MealCompletionService] Error unmarking meal as completed: $e');
      rethrow;
    }
  }

  /// Gets today's plan and completion status from the server
  /// DEPRECATED: Currently failing due to server-side GraphQL mapping template issues
  /// Use individual mutations (markMealAsCompleted/unmarkMealAsCompleted) instead
  @Deprecated(
      'Use individual mutations instead due to server-side resolver issues')
  Future<TodaysPlan?> getTodaysPlanAndStatus() async {
    try {
      safePrint(
          '[MealCompletionService] Fetching today\'s plan and status from server');

      final request = GraphQLRequest<String>(
        document: '''
          query GetTodaysPlanAndStatus {
            getTodaysPlanAndStatus {
              activePlanDetails {
                mealPlanId
                planName
                generatedAt
                status
                validationStatus
                nutritionistFullName
                userFullName
                assignedNutritionistId
                chatId
                dailyPlan {
                  monday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                  tuesday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                  wednesday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                  thursday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                  friday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                  saturday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                  sunday {
                    name
                    recipeName
                    ingredients {
                      name
                      amount
                      unit
                      macros {
                        proteins
                        carbohydrates
                        fats
                        calories
                      }
                    }
                    totalMacros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                    recipe
                  }
                }
              }
              mealsForToday {
                meal {
                  name
                  recipeName
                  ingredients {
                    name
                    amount
                    unit
                    macros {
                      proteins
                      carbohydrates
                      fats
                      calories
                    }
                  }
                  totalMacros {
                    proteins
                    carbohydrates
                    fats
                    calories
                  }
                  recipe
                }
                isCompleted
              }
              todaysCompletion {
                planId
                date
                completedMealNames
                updatedAt
                userId
              }
            }
          }
        ''',
        decodePath: 'getTodaysPlanAndStatus',
      );

      final response = await _amplifyGraphQL.query(request: request).response;

      if (response.hasErrors) {
        safePrint('[MealCompletionService] GraphQL errors: ${response.errors}');
        // Extract just the first line of the error for cleaner logging
        final firstError = response.errors.first.message.split('\n').first;
        throw Exception(
            'Failed to get today\'s plan: $firstError (server-side resolver issue)');
      }

      if (response.data == null) {
        throw Exception('No data returned from server');
      }

      final Map<String, dynamic> jsonData = json.decode(response.data!);
      final data = jsonData['getTodaysPlanAndStatus'];

      if (data == null) {
        throw Exception('Invalid response structure');
      }

      // Create TodaysPlan from response
      final todaysPlan = TodaysPlan.fromJson(data);

      safePrint(
          '[MealCompletionService] Successfully fetched today\'s plan and status');
      return todaysPlan;
    } catch (e) {
      safePrint('[MealCompletionService] Error fetching today\'s plan: $e');
      rethrow;
    }
  }

  /// Gets plan day completion for a specific date and plan
  /// DEPRECATED: Not currently used, individual mutations handle completion tracking
  @Deprecated('Individual mutations handle completion tracking automatically')
  Future<PlanDayCompletion?> getPlanDayCompletion({
    required String planId,
    required DateTime date,
  }) async {
    try {
      final dateString = _formatDate(date);
      safePrint(
          '[MealCompletionService] Fetching plan day completion for plan $planId on $dateString');

      final request = GraphQLRequest<String>(
        document: '''
          query GetPlanDayCompletion(\$date: AWSDate!, \$planId: ID!) {
            getPlanDayCompletion(date: \$date, planId: \$planId) {
              planId
              date
              completedMealNames
              updatedAt
              userId
            }
          }
        ''',
        variables: {
          'date': dateString,
          'planId': planId,
        },
        decodePath: 'getPlanDayCompletion',
      );

      final response = await _amplifyGraphQL.query(request: request).response;

      if (response.hasErrors) {
        safePrint('[MealCompletionService] GraphQL errors: ${response.errors}');
        throw Exception(
            'Failed to get plan day completion: ${response.errors.first.message}');
      }

      if (response.data == null) {
        return null; // No completion record found
      }

      final Map<String, dynamic> jsonData = json.decode(response.data!);
      final data = jsonData['getPlanDayCompletion'];

      if (data == null) {
        return null; // No completion record found
      }

      // Create PlanDayCompletion from response
      final completion = PlanDayCompletion.fromJson({
        'id': '${data['planId']}_${data['date']}', // Create a composite ID
        'planId': data['planId'],
        'date': data['date'],
        'completedMealNames': data['completedMealNames'],
        'updatedAt': data['updatedAt'],
        'userId': data['userId'],
      });

      safePrint(
          '[MealCompletionService] Successfully fetched plan day completion');
      return completion;
    } catch (e) {
      safePrint(
          '[MealCompletionService] Error fetching plan day completion: $e');
      rethrow;
    }
  }

  /// Helper method to format date for GraphQL
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
