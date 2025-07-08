import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart'
    show LightMealPlanList;
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';

class MealPlansService {
  final Isar? isar;
  // static const Duration _cacheValidityDuration = Duration(hours: 24);

  MealPlansService({this.isar});

  Future<List<MealPlan>> getMealPlans() async {
    throw UnimplementedError();
  }

  Future<MealPlan?> getMealPlanById(String mealPlanId) async {
    try {
      final request = GraphQLRequest<MealPlan>(
        document: '''
          query GetMealPlanById(
            \$mealPlanId: ID!
          ) {
            getMealPlanById(mealPlanId: \$mealPlanId) {
              mealPlanId
              planName
              startDate
              endDate
              generatedAt
              status
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
          }
        ''',
        variables: {'mealPlanId': mealPlanId},
        decodePath: 'getMealPlanById',
        modelType: ModelProvider.instance.getModelTypeByModelName('MealPlan'),
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: \\${response.errors}');
        return null;
      }
      return response.data;
    } catch (e) {
      safePrint(
          '[MealPlansService] Error fetching meal plan by ID: \\${e.toString()}');
      return null;
    }
  }

  Future<MealPlanResponse?> deleteMealPlan(String mealPlanId) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation DeleteMealPlan(
            \$mealPlanId: ID!
          ) {
            deleteMealPlan(mealPlanId: \$mealPlanId) {
              success
              message
              mealPlanId
            }
          }
        ''',
        variables: {'mealPlanId': mealPlanId},
        decodePath: 'deleteMealPlan',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: \\${response.errors}');
        return null;
      }
      if (response.data == null) return null;

      final Map<String, dynamic> deleteMealPlanData =
          json.decode(response.data!);

      final data = deleteMealPlanData['deleteMealPlan'];

      // Safely extract values with null checks
      final success = data['success'] as bool? ?? false;
      final message = data['message'] as String?;
      final responseMealPlanId = data['mealPlanId'] as String?;

      return MealPlanResponse(
        success: success,
        message: message,
        mealPlanId: responseMealPlanId,
      );
    } catch (e) {
      safePrint(
          '[MealPlansService] Error deleting meal plan: \\${e.toString()}');
      return null;
    }
  }

  Future<MealPlanResponse?> createMockPlan() async {
    try {
      // Load the Gemini-Meal-Output.json from assets
      final jsonString =
          await rootBundle.loadString('assets/Gemini-Meal-Output.json');
      final Map<String, dynamic> dailyPlan = json.decode(jsonString);

      // Build the input for the mutation
      final input = {
        'dailyPlan': dailyPlan,
        'planName': 'Mock Plan',
        'startDate': '2024-06-01', // Example date
        'endDate': '2024-06-07', // Example date
        'status': 'ACTIVE', // Or another PlanStatus value
      };

      return await createMealPlan(input);
    } catch (e) {
      safePrint(
          '[MealPlansService] Error creating mock plan: \\${e.toString()}');
      return null;
    }
  }

  Future<MealPlanResponse?> createMealPlan(Map<String, dynamic> input) async {
    try {
      final request = GraphQLRequest<MealPlanResponse>(
        document: '''
          mutation CreateMealPlan(\$input: CreateMealPlanInput!) {
            createMealPlan(input: \$input) {
              success
              message
              mealPlanId
            }
          }
        ''',
        variables: {'input': input},
        decodePath: 'createMealPlan',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: \\${response.errors}');
        return null;
      }
      return response.data;
    } catch (e) {
      safePrint(
          '[MealPlansService] Error creating meal plan: \\${e.toString()}');
      return null;
    }
  }

  Future<LightMealPlanList> listMyMealPlans({int limit = 10}) async {
    try {
      final request = GraphQLRequest(
        document: '''
          query ListMyMealPlans {
            listMyMealPlans(limit: $limit) {
              items {
                mealPlanId
                planName
                startDate
                endDate
                status
              }
              nextToken
              activeMealPlan
            }
          }
        ''',
        decodePath: 'listMyMealPlans',
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: \\${response.errors}');
        return LightMealPlanList(
            items: [], nextToken: null, activeMealPlan: null);
      }

      Map<String, dynamic> jsonData;
      if (response.data is String) {
        jsonData = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        jsonData = response.data;
      } else {
        safePrint(
            '[MealPlansService] Unexpected response data type: \\${response.data.runtimeType}');
        return LightMealPlanList(
            items: [], nextToken: null, activeMealPlan: null);
      }
      return LightMealPlanList.fromJson(jsonData);
    } catch (e) {
      safePrint(
          '[MealPlansService] Error fetching meal plans: \\${e.toString()}');
      return LightMealPlanList(
          items: [], nextToken: null, activeMealPlan: null);
    }
  }
}
