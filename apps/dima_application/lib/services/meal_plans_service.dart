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

  /// Creates a meal plan with random data for testing purposes
  Future<MealPlanResponse?> createRandomMealPlan() async {
    try {
      // Generate random meal plan data
      final random = DateTime.now().millisecondsSinceEpoch;
      final planNames = [
        'Balanced Weekly Plan',
        'High Protein Diet',
        'Vegetarian Delights',
        'Mediterranean Style',
        'Quick & Healthy',
        'Athlete\'s Fuel',
        'Family Friendly',
        'Weight Loss Plan'
      ];

      final meals = [
        'Chicken',
        'Salmon',
        'Quinoa',
        'Salad',
        'Sandwich',
        'Pasta',
        'Beef',
        'Soup',
        'Tuna',
        'Caesar'
      ];

      // Helper to generate a recipe map
      Map<String, dynamic> recipeFor(int offset) => {
            'name': [
              'BREAKFAST',
              'LUNCH',
              'DINNER',
              'SNACK_MORNING',
              'SNACK_AFTERNOON',
              'SNACK_EVENING'
            ][offset % 6],
            'recipeName': meals[(random + offset) % meals.length]
                .replaceAll("'", "")
                .replaceAll('"', ''),
            'ingredients': [
              {
                'name': 'Ingredient A',
                'amount': 100 + offset * 10,
                'unit': 'g',
                'macros': {
                  'proteins': 10 + offset,
                  'carbohydrates': 20 + offset,
                  'fats': 5 + offset,
                  'calories': 150 + offset * 10
                }
              },
              {
                'name': 'Ingredient B',
                'amount': 50 + offset * 5,
                'unit': 'g',
                'macros': {
                  'proteins': 2 + offset,
                  'carbohydrates': 10 + offset,
                  'fats': 1 + offset,
                  'calories': 50 + offset * 5
                }
              }
            ],
            'totalMacros': {
              'proteins': 12 + offset,
              'carbohydrates': 30 + offset,
              'fats': 6 + offset,
              'calories': 200 + offset * 10
            },
            'recipe':
                'Sample recipe instructions for ${meals[(random + offset) % meals.length].replaceAll("'", "").replaceAll('"', '')}.'
          };

      // Generate a week of meals, each day as a list of recipes
      final dailyPlan = {
        'monday': [recipeFor(0)],
        'tuesday': [recipeFor(1)],
        'wednesday': [recipeFor(2)],
        'thursday': [recipeFor(3)],
        'friday': [recipeFor(4)],
        'saturday': [recipeFor(5)],
        'sunday': [recipeFor(6)],
      };

      // Calculate start and end dates (next week)
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day + 1);
      final endDate = DateTime(now.year, now.month, now.day + 7);

      // Build the input for the mutation
      final input = {
        'dailyPlan': dailyPlan,
        'planName': planNames[random % planNames.length],
        'startDate':
            '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
        'endDate':
            '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
        'status': 'ACTIVE',
      };

      return await createMealPlan(input);
    } catch (e) {
      safePrint(
          '[MealPlansService] Error creating random meal plan: \\${e.toString()}');
      return null;
    }
  }

  Future<MealPlanResponse?> createMealPlan(Map<String, dynamic> input) async {
    try {
      final request = GraphQLRequest<String>(
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
      if (response.data == null) return null;

      final Map<String, dynamic> createMealPlanData =
          json.decode(response.data!);
      final data = createMealPlanData['createMealPlan'];

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
          '[MealPlansService] Error creating meal plan: \\${e.toString()}');
      return null;
    }
  }

  /// Sets the given meal plan as the active plan for the user.
  Future<MealPlanResponse?> setActiveMealPlan(String mealPlanId) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation SetActiveMealPlan(
            \$mealPlanId: ID!
          ) {
            setActiveMealPlan(mealPlanId: \$mealPlanId) {
              success
              message
              mealPlanId
            }
          }
        ''',
        variables: {'mealPlanId': mealPlanId},
        decodePath: 'setActiveMealPlan',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: \\${response.errors}');
        return null;
      }
      if (response.data == null) return null;

      final Map<String, dynamic> setActiveMealPlanData =
          json.decode(response.data!);
      final data = setActiveMealPlanData['setActiveMealPlan'];

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
          '[MealPlansService] Error setting active meal plan: \\${e.toString()}');
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

  /// Modifies the name of a meal plan.
  Future<MealPlanResponse?> modifyMealPlan(
      String mealPlanId, String mealPlanName) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation ModifyMealPlan(
            \$mealPlanId: ID!
            \$mealPlanName: String!
          ) {
            modifyMealPlan(mealPlanId: \$mealPlanId, mealPlanName: \$mealPlanName) {
              success
              message
              mealPlanId
            }
          }
        ''',
        variables: {
          'mealPlanId': mealPlanId,
          'mealPlanName': mealPlanName,
        },
        decodePath: 'modifyMealPlan',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: \\${response.errors}');
        return null;
      }
      if (response.data == null) return null;

      final Map<String, dynamic> modifyMealPlanData =
          json.decode(response.data!);
      final data = modifyMealPlanData['modifyMealPlan'];

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
          '[MealPlansService] Error modifying meal plan: \\${e.toString()}');
      return null;
    }
  }

  /// Lists available nutritionists for assignment to meal plans.
  Future<List<NutritionistProfile>> listNutritionists(
      {bool? isAvailable, int? limit, String? nextToken}) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          query ListAllNutritionists(\$limit: Int, \$nextToken: String) {
            listNutritionists(limit: \$limit, nextToken: \$nextToken) {
              items {
                id
                nutritionistId
                givenName
                familyName
                specialization
                bio
                profilePictureUrl
                isAvailable
              }
              nextToken
            }
          }
        ''',
        variables: {
          'limit': limit ?? 10,
          'nextToken': nextToken,
        },
        decodePath: 'listNutritionists',
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: ${response.errors}');
        return [];
      }
      if (response.data == null) return [];

      final Map<String, dynamic> jsonData = json.decode(response.data!);
      final items = jsonData['listNutritionists']['items'] as List<dynamic>;

      return items.map((item) {
        if (item is Map<String, dynamic>) {
          return NutritionistProfile.fromJson(item);
        }
        return NutritionistProfile.fromJson(item);
      }).toList();
    } catch (e) {
      safePrint(
          '[MealPlansService] Error listing nutritionists: ${e.toString()}');
      return [];
    }
  }

  /// Assigns a nutritionist to a meal plan for validation.
  Future<MealPlanResponse?> assignNutritionistToPlan(
      String mealPlanId, String nutritionistId) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation AssignNutritionistToPlan(\$input: AssignNutritionistInput!) {
            assignNutritionistToPlan(input: \$input) {
              mealPlanId
              planName
              assignedNutritionistId
              validationStatus
            }
          }
        ''',
        variables: {
          'input': {
            'mealPlanId': mealPlanId,
            'nutritionistId': nutritionistId,
          },
        },
        decodePath: 'assignNutritionistToPlan',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: ${response.errors}');
        return null;
      }
      if (response.data == null) return null;

      final Map<String, dynamic> assignData = json.decode(response.data!);
      final data = assignData['assignNutritionistToPlan'];

      return MealPlanResponse(
        success: true,
        message: 'Nutritionist assigned successfully',
        mealPlanId: data['mealPlanId'] as String?,
      );
    } catch (e) {
      safePrint(
          '[MealPlansService] Error assigning nutritionist: ${e.toString()}');
      return null;
    }
  }

  /// Requests validation of a meal plan by a nutritionist.
  Future<MealPlanResponse?> requestValidation(
      String mealPlanId, String nutritionistId) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation RequestValidation(\$input: RequestValidationInput!) {
            requestValidation(input: \$input) {
              success
              message
              mealPlanId
            }
          }
        ''',
        variables: {
          'input': {
            'mealPlanId': mealPlanId,
            'nutritionistId': nutritionistId,
          },
        },
        decodePath: 'requestValidation',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: ${response.errors}');
        return null;
      }
      if (response.data == null) return null;

      final Map<String, dynamic> requestData = json.decode(response.data!);
      final data = requestData['requestValidation'];

      return MealPlanResponse(
        success: data['success'] as bool? ?? false,
        message: data['message'] as String?,
        mealPlanId: data['mealPlanId'] as String?,
      );
    } catch (e) {
      safePrint(
          '[MealPlansService] Error requesting validation: ${e.toString()}');
      return null;
    }
  }

  /// Validates a meal plan by a nutritionist, updating the validation status.
  Future<MealPlanResponse?> validateMealPlan(
      String mealPlanId, String nutritionistId, String validationStatus) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation ValidateMealPlan(\$input: ValidateMealPlanInput!) {
            validateMealPlan(input: \$input) {
              success
              message
              mealPlanId
            }
          }
        ''',
        variables: {
          'input': {
            'mealPlanId': mealPlanId,
            'validationStatus': validationStatus,
          },
        },
        decodePath: 'validateMealPlan',
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: ${response.errors}');
        return null;
      }
      if (response.data == null) return null;

      final Map<String, dynamic> validateData = json.decode(response.data!);
      final data = validateData['validateMealPlan'];

      return MealPlanResponse(
        success: data['success'] as bool? ?? false,
        message: data['message'] as String?,
        mealPlanId: data['mealPlanId'] as String?,
      );
    } catch (e) {
      safePrint(
          '[MealPlansService] Error validating meal plan: ${e.toString()}');
      return null;
    }
  }

  /// Lists meal plans assigned to the authenticated nutritionist for validation.
  Future<List<MealPlan>> listMyAssignedMealPlans({int limit = 10}) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          query ListMyAssignedMealPlans(\$limit: Int) {
            listMyAssignedMealPlans(limit: \$limit) {
              items {
                mealPlanId
                planName
                startDate
                endDate
                status
                validationStatus
                assignedNutritionistId
                userId
              }
              nextToken
            }
          }
        ''',
        variables: {
          'limit': limit,
        },
        decodePath: 'listMyAssignedMealPlans',
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.hasErrors) {
        safePrint('[MealPlansService] GraphQL errors: ${response.errors}');
        return [];
      }
      if (response.data == null) return [];

      final Map<String, dynamic> jsonData = json.decode(response.data!);
      final items =
          jsonData['listMyAssignedMealPlans']['items'] as List<dynamic>;

      //TODO: Remove id field from the items and put it in the schema

      return items.map((item) {
        if (item is Map<String, dynamic>) {
          item['id'] = item['mealPlanId']; // Add id field for compatibility
          return MealPlan.fromJson(item);
        }
        final mapItem = Map<String, dynamic>.from(item);
        mapItem['id'] = mapItem['mealPlanId']; // Add id field for compatibility
        return MealPlan.fromJson(mapItem);
      }).toList();
    } catch (e) {
      safePrint(
          '[MealPlansService] Error listing assigned meal plans: ${e.toString()}');
      return [];
    }
  }
}
