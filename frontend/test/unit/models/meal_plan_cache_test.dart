import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('MealPlanCache', () {
    group('Constructor and initialization', () {
      test('creates MealPlanCache with default constructor', () {
        final mealPlan = MealPlanCache();

        expect(mealPlan, isA<MealPlanCache>());
        expect(mealPlan.id, Isar.autoIncrement);
      });

      test('creates MealPlanCache with create factory constructor', () {
        final generatedAt = TemporalDateTime.now();
        final lastFetched = TemporalDateTime.now();

        final dailyPlan = DailyPlanCache.create(
          monday: [],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: 'nutritionist-123',
          chatId: 'chat-456',
          dailyPlan: dailyPlan,
          generatedAt: generatedAt,
          mealPlanId: 'plan-789',
          planName: 'Test Meal Plan',
          status: PlanStatus.ACTIVE,
          userId: 'user-abc',
          lastFetched: lastFetched,
        );

        expect(mealPlan.assignedNutritionistId, 'nutritionist-123');
        expect(mealPlan.chatId, 'chat-456');
        expect(mealPlan.dailyPlan, dailyPlan);
        expect(mealPlan.generatedAtTimestamp, generatedAt.format());
        expect(mealPlan.mealPlanId, 'plan-789');
        expect(mealPlan.planName, 'Test Meal Plan');
        expect(mealPlan.status, PlanStatus.ACTIVE);
        expect(mealPlan.userId, 'user-abc');
        expect(mealPlan.lastFetchedTimestamp, lastFetched.format());
      });

      test('creates MealPlanCache with minimal required fields', () {
        final generatedAt = TemporalDateTime.now();

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: DailyPlanCache(),
          generatedAt: generatedAt,
          mealPlanId: 'minimal-plan',
          planName: 'Minimal Plan',
          status: PlanStatus.PENDING,
          userId: 'user-minimal',
        );

        expect(mealPlan.assignedNutritionistId, isNull);
        expect(mealPlan.chatId, isNull);
        expect(mealPlan.mealPlanId, 'minimal-plan');
        expect(mealPlan.planName, 'Minimal Plan');
        expect(mealPlan.status, PlanStatus.PENDING);
        expect(mealPlan.userId, 'user-minimal');
        expect(mealPlan.lastFetchedTimestamp,
            isNotEmpty); // Should have default value
      });

      test('handles different plan statuses', () {
        final statuses = [
          PlanStatus.ACTIVE,
          PlanStatus.ARCHIVED,
          PlanStatus.PENDING,
        ];

        for (final status in statuses) {
          final mealPlan = MealPlanCache.create(
            assignedNutritionistId: null,
            chatId: null,
            dailyPlan: DailyPlanCache(),
            generatedAt: TemporalDateTime.now(),
            mealPlanId: 'plan-${status.name}',
            planName: 'Plan with ${status.name} status',
            status: status,
            userId: 'user-status-test',
          );

          expect(mealPlan.status, status);
        }
      });
    });

    group('Factory constructor fromAmplify', () {
      test('creates MealPlanCache from complete Amplify MealPlan', () {
        final amplifyIngredient = Ingredient(
          name: 'Sample Ingredient',
          amount: 100.0,
          unit: 'g',
          macros:
              Macros(calories: 150, carbohydrates: 20, fats: 5, proteins: 10),
        );

        final amplifyMeal = Meal(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Sample recipe',
          recipeName: 'Sample Breakfast',
          ingredients: [amplifyIngredient],
          totalMacros:
              Macros(calories: 200, carbohydrates: 25, fats: 7, proteins: 12),
        );

        final amplifyDailyPlan = DailyPlanData(
          monday: [amplifyMeal],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final amplifyMealPlan = MealPlan(
          assignedNutritionistId: 'nutritionist-amplify',
          chatId: 'chat-amplify',
          dailyPlan: amplifyDailyPlan,
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'amplify-plan-id',
          planName: 'Amplify Meal Plan',
          status: PlanStatus.ACTIVE,
          userId: 'amplify-user-id',
        );

        final mealPlanCache = MealPlanCache.fromAmplify(amplifyMealPlan);

        expect(mealPlanCache.assignedNutritionistId, 'nutritionist-amplify');
        expect(mealPlanCache.chatId, 'chat-amplify');
        expect(mealPlanCache.mealPlanId, 'amplify-plan-id');
        expect(mealPlanCache.planName, 'Amplify Meal Plan');
        expect(mealPlanCache.status, PlanStatus.ACTIVE);
        expect(mealPlanCache.userId, 'amplify-user-id');
        expect(mealPlanCache.dailyPlan.monday.length, 1);
        expect(mealPlanCache.dailyPlan.monday[0].name, MealNameEnum.BREAKFAST);
      });

      test('throws error for null amplifyData', () {
        // Non-nullable parameter: passing null at runtime triggers a TypeError
        expect(() => MealPlanCache.fromAmplify(null as dynamic),
            throwsA(isA<TypeError>()));
      });

      test('throws error for null status', () {
        final amplifyMealPlan = MealPlan(
          assignedNutritionistId: null,
          chatId: null,
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
          mealPlanId: 'test-plan',
          planName: 'Test Plan',
          status: null, // Null status should throw error
          userId: 'test-user',
        );

        expect(() => MealPlanCache.fromAmplify(amplifyMealPlan),
            throwsArgumentError);
      });

      test('throws error for null dailyPlan', () {
        final amplifyMealPlan = MealPlan(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: null, // Null daily plan should throw error
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'test-plan',
          planName: 'Test Plan',
          status: PlanStatus.ACTIVE,
          userId: 'test-user',
        );

        expect(() => MealPlanCache.fromAmplify(amplifyMealPlan),
            throwsArgumentError);
      });

      test('throws error for null planName', () {
        final amplifyMealPlan = MealPlan(
          assignedNutritionistId: null,
          chatId: null,
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
          mealPlanId: 'test-plan',
          planName: null, // Null plan name should throw error
          status: PlanStatus.ACTIVE,
          userId: 'test-user',
        );

        expect(() => MealPlanCache.fromAmplify(amplifyMealPlan),
            throwsArgumentError);
      });

      test('handles nullable fields correctly', () {
        final amplifyMealPlan = MealPlan(
          assignedNutritionistId: null, // Nullable field
          chatId: null, // Nullable field
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
          mealPlanId: 'nullable-test-plan',
          planName: 'Nullable Test Plan',
          status: PlanStatus.ARCHIVED,
          userId: 'nullable-test-user',
        );

        final mealPlanCache = MealPlanCache.fromAmplify(amplifyMealPlan);

        expect(mealPlanCache.assignedNutritionistId, isNull);
        expect(mealPlanCache.chatId, isNull);
        expect(mealPlanCache.mealPlanId, 'nullable-test-plan');
        expect(mealPlanCache.planName, 'Nullable Test Plan');
        expect(mealPlanCache.status, PlanStatus.ARCHIVED);
        expect(mealPlanCache.userId, 'nullable-test-user');
      });
    });

    group('TemporalDateTime getters', () {
      test('generatedAt getter converts timestamp correctly', () {
        final originalTime = TemporalDateTime.now();

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: DailyPlanCache(),
          generatedAt: originalTime,
          mealPlanId: 'time-test-plan',
          planName: 'Time Test Plan',
          status: PlanStatus.ACTIVE,
          userId: 'time-test-user',
        );

        final retrievedTime = mealPlan.generatedAt;

        expect(retrievedTime.format(), originalTime.format());
      });

      test('lastFetched getter converts timestamp correctly', () {
        final originalTime = TemporalDateTime.now();

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: DailyPlanCache(),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'fetch-test-plan',
          planName: 'Fetch Test Plan',
          status: PlanStatus.ACTIVE,
          userId: 'fetch-test-user',
          lastFetched: originalTime,
        );

        final retrievedTime = mealPlan.lastFetched;

        expect(retrievedTime.format(), originalTime.format());
      });

      test('lastFetched defaults to now when not provided', () {
        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: DailyPlanCache(),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'default-fetch-plan',
          planName: 'Default Fetch Plan',
          status: PlanStatus.ACTIVE,
          userId: 'default-fetch-user',
          // lastFetched not provided
        );

        final retrievedTime = mealPlan.lastFetched;

        // Should have a valid timestamp
        expect(retrievedTime.format(), isNotEmpty);
        expect(retrievedTime.format().length,
            greaterThan(10)); // Should be a valid timestamp string
      });
    });

    group('toMealPlan method', () {
      test('converts MealPlanCache to Amplify MealPlan', () {
        final dailyPlan = DailyPlanCache.create(
          monday: [
            MealCache.create(
              name: MealNameEnum.BREAKFAST,
              recipe: 'Cache breakfast recipe',
              recipeName: 'Cache Breakfast',
              ingredients: [
                IngredientCache.create(
                  name: 'Cache Ingredient',
                  amount: 75.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 120, carbohydrates: 15, fats: 4, proteins: 8),
                ),
              ],
              totalMacros: MacrosCache(
                  calories: 180, carbohydrates: 20, fats: 6, proteins: 12),
            ),
          ],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final generatedAt = TemporalDateTime.now();

        final mealPlanCache = MealPlanCache.create(
          assignedNutritionistId: 'cache-nutritionist',
          chatId: 'cache-chat',
          dailyPlan: dailyPlan,
          generatedAt: generatedAt,
          mealPlanId: 'cache-to-amplify-plan',
          planName: 'Cache to Amplify Plan',
          status: PlanStatus.ACTIVE,
          userId: 'cache-to-amplify-user',
        );

        final amplifyMealPlan = mealPlanCache.toMealPlan();

        expect(amplifyMealPlan.assignedNutritionistId, 'cache-nutritionist');
        expect(amplifyMealPlan.chatId, 'cache-chat');
        expect(amplifyMealPlan.mealPlanId, 'cache-to-amplify-plan');
        expect(amplifyMealPlan.planName, 'Cache to Amplify Plan');
        expect(amplifyMealPlan.status, PlanStatus.ACTIVE);
        expect(amplifyMealPlan.userId, 'cache-to-amplify-user');
        expect(amplifyMealPlan.generatedAt?.format(), generatedAt.format());
        expect(amplifyMealPlan.dailyPlan?.monday?.length, 1);
        expect(
            amplifyMealPlan.dailyPlan?.monday?[0].name, MealNameEnum.BREAKFAST);
        expect(amplifyMealPlan.dailyPlan?.monday?[0].recipeName,
            'Cache Breakfast');
      });

      test('handles null nullable fields in conversion', () {
        final mealPlanCache = MealPlanCache.create(
          assignedNutritionistId: null, // Null nutritionist
          chatId: null, // Null chat
          dailyPlan: DailyPlanCache(),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'null-fields-plan',
          planName: 'Null Fields Plan',
          status: PlanStatus.PENDING,
          userId: 'null-fields-user',
        );

        final amplifyMealPlan = mealPlanCache.toMealPlan();

        expect(amplifyMealPlan.assignedNutritionistId, isNull);
        expect(amplifyMealPlan.chatId, isNull);
        expect(amplifyMealPlan.mealPlanId, 'null-fields-plan');
        expect(amplifyMealPlan.planName, 'Null Fields Plan');
        expect(amplifyMealPlan.status, PlanStatus.PENDING);
        expect(amplifyMealPlan.userId, 'null-fields-user');
      });

      test('round-trip Amplify conversion preserves data', () {
        final originalAmplify = MealPlan(
          assignedNutritionistId: 'round-trip-nutritionist',
          chatId: 'round-trip-chat',
          dailyPlan: DailyPlanData(
            monday: [
              Meal(
                name: MealNameEnum.LUNCH,
                recipe: 'Round trip lunch recipe',
                recipeName: 'Round Trip Lunch',
                ingredients: [
                  Ingredient(
                    name: 'Round Trip Ingredient',
                    amount: 150.0,
                    unit: 'g',
                    macros: Macros(
                        calories: 200,
                        carbohydrates: 30,
                        fats: 8,
                        proteins: 15),
                  ),
                ],
                totalMacros: Macros(
                    calories: 250, carbohydrates: 35, fats: 10, proteins: 18),
              ),
            ],
            tuesday: [],
            wednesday: [],
            thursday: [],
            friday: [],
            saturday: [],
            sunday: [],
          ),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'round-trip-plan',
          planName: 'Round Trip Plan',
          status: PlanStatus.ACTIVE,
          userId: 'round-trip-user',
        );

        final cache = MealPlanCache.fromAmplify(originalAmplify);
        final reconstructed = cache.toMealPlan();

        expect(reconstructed.assignedNutritionistId,
            originalAmplify.assignedNutritionistId);
        expect(reconstructed.chatId, originalAmplify.chatId);
        expect(reconstructed.mealPlanId, originalAmplify.mealPlanId);
        expect(reconstructed.planName, originalAmplify.planName);
        expect(reconstructed.status, originalAmplify.status);
        expect(reconstructed.userId, originalAmplify.userId);
        expect(reconstructed.generatedAt?.format(),
            originalAmplify.generatedAt?.format());
        expect(reconstructed.dailyPlan?.monday?.length,
            originalAmplify.dailyPlan?.monday?.length);
        expect(reconstructed.dailyPlan?.monday?[0].name,
            originalAmplify.dailyPlan?.monday?[0].name);
        expect(reconstructed.dailyPlan?.monday?[0].recipeName,
            originalAmplify.dailyPlan?.monday?[0].recipeName);
      });
    });

    group('toJson method', () {
      test('converts MealPlanCache to JSON', () {
        final dailyPlan = DailyPlanCache.create(
          monday: [
            MealCache.create(
              name: MealNameEnum.DINNER,
              recipe: 'JSON dinner recipe',
              recipeName: 'JSON Dinner',
              ingredients: [],
              totalMacros: MacrosCache(calories: 400),
            ),
          ],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final generatedTime = TemporalDateTime.now();
        final fetchedTime = TemporalDateTime.now();

        final mealPlanCache = MealPlanCache.create(
          assignedNutritionistId: 'json-nutritionist',
          chatId: 'json-chat',
          dailyPlan: dailyPlan,
          generatedAt: generatedTime,
          mealPlanId: 'json-plan',
          planName: 'JSON Plan',
          status: PlanStatus.ARCHIVED,
          userId: 'json-user',
          lastFetched: fetchedTime,
        );

        final json = mealPlanCache.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['assignedNutritionistId'], 'json-nutritionist');
        expect(json['chatId'], 'json-chat');
        expect(json['mealPlanId'], 'json-plan');
        expect(json['planName'], 'JSON Plan');
        expect(json['status'], 'ARCHIVED');
        expect(json['userId'], 'json-user');
        expect(json['generatedAt'], generatedTime.format());
        expect(json['lastFetched'], fetchedTime.format());
        expect(json['dailyPlan'], isA<Map<String, dynamic>>());
        expect(json['dailyPlan']['monday'], isA<List>());
        expect(json['dailyPlan']['monday'].length, 1);
      });

      test('converts MealPlanCache with null fields to JSON', () {
        final mealPlanCache = MealPlanCache.create(
          assignedNutritionistId: null, // Null nutritionist
          chatId: null, // Null chat
          dailyPlan: DailyPlanCache(),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'null-json-plan',
          planName: 'Null JSON Plan',
          status: PlanStatus.PENDING,
          userId: 'null-json-user',
        );

        final json = mealPlanCache.toJson();

        expect(json['assignedNutritionistId'], isNull);
        expect(json['chatId'], isNull);
        expect(json['mealPlanId'], 'null-json-plan');
        expect(json['planName'], 'Null JSON Plan');
        expect(json['status'], 'PENDING');
        expect(json['userId'], 'null-json-user');
      });
    });

    group('Realistic usage scenarios', () {
      test('represents a complete nutritionist-assigned meal plan', () {
        final weeklyPlan = DailyPlanCache.create(
          monday: [
            MealCache.create(
              name: MealNameEnum.BREAKFAST,
              recipe:
                  'Nutritionist breakfast: High protein oatmeal with berries',
              recipeName: 'High Protein Oatmeal',
              ingredients: [
                IngredientCache.create(
                  name: 'Rolled Oats',
                  amount: 40.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 156, carbohydrates: 26, fats: 3, proteins: 7),
                ),
                IngredientCache.create(
                  name: 'Greek Yogurt',
                  amount: 100.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 59, carbohydrates: 4, fats: 0, proteins: 10),
                ),
                IngredientCache.create(
                  name: 'Mixed Berries',
                  amount: 80.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 45, carbohydrates: 11, fats: 0, proteins: 1),
                ),
              ],
              totalMacros: MacrosCache(
                  calories: 260, carbohydrates: 41, fats: 3, proteins: 18),
            ),
            MealCache.create(
              name: MealNameEnum.LUNCH,
              recipe: 'Nutritionist lunch: Grilled chicken with quinoa salad',
              recipeName: 'Chicken Quinoa Salad',
              ingredients: [
                IngredientCache.create(
                  name: 'Chicken Breast',
                  amount: 120.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 165, carbohydrates: 0, fats: 4, proteins: 31),
                ),
                IngredientCache.create(
                  name: 'Quinoa',
                  amount: 60.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 222, carbohydrates: 39, fats: 4, proteins: 8),
                ),
              ],
              totalMacros: MacrosCache(
                  calories: 387, carbohydrates: 39, fats: 8, proteins: 39),
            ),
            MealCache.create(
              name: MealNameEnum.DINNER,
              recipe:
                  'Nutritionist dinner: Baked salmon with roasted vegetables',
              recipeName: 'Salmon with Roasted Vegetables',
              ingredients: [
                IngredientCache.create(
                  name: 'Salmon Fillet',
                  amount: 150.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 206, carbohydrates: 0, fats: 12, proteins: 22),
                ),
                IngredientCache.create(
                  name: 'Mixed Vegetables',
                  amount: 200.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 80, carbohydrates: 18, fats: 1, proteins: 3),
                ),
              ],
              totalMacros: MacrosCache(
                  calories: 286, carbohydrates: 18, fats: 13, proteins: 25),
            ),
          ],
          tuesday: [
            MealCache.create(
              name: MealNameEnum.BREAKFAST,
              recipe: 'Nutritionist breakfast: Protein smoothie with spinach',
              recipeName: 'Green Protein Smoothie',
              ingredients: [],
              totalMacros: MacrosCache(
                  calories: 280, carbohydrates: 35, fats: 5, proteins: 20),
            ),
          ],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final nutritionistPlan = MealPlanCache.create(
          assignedNutritionistId: 'nutritionist-maria-santos',
          chatId: 'chat-nutritionist-client-789',
          dailyPlan: weeklyPlan,
          generatedAt: TemporalDateTime.fromString('2024-01-15T09:00:00.000Z'),
          mealPlanId: 'nutritionist-plan-2024-001',
          planName: 'Maria\'s Weight Loss Plan - Week 1',
          status: PlanStatus.ACTIVE,
          userId: 'client-john-doe-456',
          lastFetched: TemporalDateTime.now(),
        );

        expect(nutritionistPlan.assignedNutritionistId,
            'nutritionist-maria-santos');
        expect(nutritionistPlan.chatId, 'chat-nutritionist-client-789');
        expect(
            nutritionistPlan.planName, contains('Maria\'s Weight Loss Plan'));
        expect(nutritionistPlan.status, PlanStatus.ACTIVE);

        // Check Monday's complete meal plan
        expect(nutritionistPlan.dailyPlan.monday.length, 3);
        expect(
            nutritionistPlan.dailyPlan.monday[0].name, MealNameEnum.BREAKFAST);
        expect(nutritionistPlan.dailyPlan.monday[1].name, MealNameEnum.LUNCH);
        expect(nutritionistPlan.dailyPlan.monday[2].name, MealNameEnum.DINNER);

        // Calculate total daily calories for Monday
        final mondayCalories = nutritionistPlan.dailyPlan.monday
            .fold<double>(0, (sum, meal) => sum + meal.totalMacros.calories);
        expect(mondayCalories, 933); // 260 + 387 + 286

        // Verify Tuesday has different meal
        expect(nutritionistPlan.dailyPlan.tuesday.length, 1);
        expect(nutritionistPlan.dailyPlan.tuesday[0].recipeName,
            'Green Protein Smoothie');

        // Test conversion to Amplify model
        final amplifyPlan = nutritionistPlan.toMealPlan();
        expect(amplifyPlan.assignedNutritionistId, 'nutritionist-maria-santos');
        expect(amplifyPlan.dailyPlan?.monday?.length, 3);
      });

      test('handles meal plan progression through different statuses', () {
        final baseDailyPlan = DailyPlanCache.create(
          monday: [
            MealCache.create(
              name: MealNameEnum.BREAKFAST,
              recipe: 'Draft breakfast recipe',
              recipeName: 'Draft Breakfast',
              ingredients: [],
              totalMacros: MacrosCache(calories: 300),
            ),
          ],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        // 1. Pending plan (just created)
        final pendingPlan = MealPlanCache.create(
          assignedNutritionistId: null, // No nutritionist assigned yet
          chatId: null, // No chat started yet
          dailyPlan: baseDailyPlan,
          generatedAt: TemporalDateTime.fromString('2024-01-10T10:00:00.000Z'),
          mealPlanId: 'progression-plan-001',
          planName: 'Client\'s Self-Generated Plan',
          status: PlanStatus.PENDING,
          userId: 'client-progression-test',
        );

        expect(pendingPlan.status, PlanStatus.PENDING);
        expect(pendingPlan.assignedNutritionistId, isNull);
        expect(pendingPlan.chatId, isNull);

        // 2. Active plan (nutritionist assigned, chat started)
        final activePlan = MealPlanCache.create(
          assignedNutritionistId: 'nutritionist-assigned-123',
          chatId: 'chat-started-456',
          dailyPlan: baseDailyPlan,
          generatedAt: pendingPlan.generatedAt,
          mealPlanId: pendingPlan.mealPlanId,
          planName: pendingPlan.planName,
          status: PlanStatus.ACTIVE, // Status changed to active
          userId: pendingPlan.userId,
          lastFetched: TemporalDateTime.now(),
        );

        expect(activePlan.status, PlanStatus.ACTIVE);
        expect(activePlan.assignedNutritionistId, 'nutritionist-assigned-123');
        expect(activePlan.chatId, 'chat-started-456');

        // 3. Archived plan (completed or replaced)
        final archivedPlan = MealPlanCache.create(
          assignedNutritionistId: activePlan.assignedNutritionistId,
          chatId: activePlan.chatId,
          dailyPlan: activePlan.dailyPlan,
          generatedAt: activePlan.generatedAt,
          mealPlanId: activePlan.mealPlanId,
          planName: activePlan.planName,
          status: PlanStatus.ARCHIVED, // Status changed to archived
          userId: activePlan.userId,
          lastFetched: TemporalDateTime.now(),
        );

        expect(archivedPlan.status, PlanStatus.ARCHIVED);
        expect(
            archivedPlan.assignedNutritionistId, 'nutritionist-assigned-123');
        expect(archivedPlan.chatId, 'chat-started-456');

        // Verify all plans maintain the same core data
        expect(pendingPlan.mealPlanId, activePlan.mealPlanId);
        expect(activePlan.mealPlanId, archivedPlan.mealPlanId);
        expect(pendingPlan.userId, activePlan.userId);
        expect(activePlan.userId, archivedPlan.userId);
      });

      test('supports meal plan analytics and tracking', () {
        final createAnalyticsMeal = (MealNameEnum type, double calories,
                double protein, double carbs, double fats) =>
            MealCache.create(
              name: type,
              recipe: 'Analytics tracked meal',
              recipeName: 'Tracked ${type.name}',
              ingredients: [],
              totalMacros: MacrosCache(
                calories: calories,
                carbohydrates: carbs,
                fats: fats,
                proteins: protein,
              ),
            );

        final weekPlan = DailyPlanCache.create(
          monday: [
            createAnalyticsMeal(MealNameEnum.BREAKFAST, 350, 20, 45, 12),
            createAnalyticsMeal(MealNameEnum.LUNCH, 450, 35, 50, 15),
            createAnalyticsMeal(MealNameEnum.DINNER, 500, 40, 55, 18),
          ],
          tuesday: [
            createAnalyticsMeal(MealNameEnum.BREAKFAST, 320, 18, 42, 11),
            createAnalyticsMeal(MealNameEnum.LUNCH, 420, 32, 48, 14),
            createAnalyticsMeal(MealNameEnum.DINNER, 480, 38, 52, 16),
          ],
          wednesday: [
            createAnalyticsMeal(MealNameEnum.BREAKFAST, 340, 19, 44, 12),
            createAnalyticsMeal(MealNameEnum.LUNCH, 440, 34, 49, 15),
            createAnalyticsMeal(MealNameEnum.DINNER, 520, 42, 57, 19),
          ],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final analyticsPlan = MealPlanCache.create(
          assignedNutritionistId: 'analytics-nutritionist',
          chatId: 'analytics-chat',
          dailyPlan: weekPlan,
          generatedAt: TemporalDateTime.fromString('2024-01-20T08:00:00.000Z'),
          mealPlanId: 'analytics-plan-2024',
          planName: 'Performance Tracking Plan',
          status: PlanStatus.ACTIVE,
          userId: 'analytics-user',
        );

        // Calculate analytics for the tracked days
        final trackedDays = [
          analyticsPlan.dailyPlan.monday,
          analyticsPlan.dailyPlan.tuesday,
          analyticsPlan.dailyPlan.wednesday,
        ];

        final dailyTotals = trackedDays.map((dayMeals) {
          return dayMeals.fold(
              MacrosCache(), (total, meal) => total + meal.totalMacros);
        }).toList();

        // Monday totals
        expect(dailyTotals[0].calories, 1300); // 350 + 450 + 500
        expect(dailyTotals[0].proteins, 95); // 20 + 35 + 40
        expect(dailyTotals[0].carbohydrates, 150); // 45 + 50 + 55
        expect(dailyTotals[0].fats, 45); // 12 + 15 + 18

        // Tuesday totals
        expect(dailyTotals[1].calories, 1220); // 320 + 420 + 480
        expect(dailyTotals[1].proteins, 88); // 18 + 32 + 38

        // Wednesday totals
        expect(dailyTotals[2].calories, 1300); // 340 + 440 + 520
        expect(dailyTotals[2].proteins, 95); // 19 + 34 + 42

        // Weekly averages (3 days)
        final avgDailyCalories =
            dailyTotals.fold<double>(0, (sum, day) => sum + day.calories) / 3;
        final avgDailyProtein =
            dailyTotals.fold<double>(0, (sum, day) => sum + day.proteins) / 3;

        expect(avgDailyCalories, closeTo(1273.33, 0.01));
        expect(avgDailyProtein, closeTo(92.67, 0.01));

        // Test JSON export for analytics
        final json = analyticsPlan.toJson();
        expect(json['planName'], 'Performance Tracking Plan');
        expect(json['dailyPlan']['monday'].length, 3);
        expect(json['dailyPlan']['tuesday'].length, 3);
        expect(json['dailyPlan']['wednesday'].length, 3);
      });
    });

    group('Edge cases and validation', () {
      test('handles very long plan names and IDs', () {
        final longPlanName = 'A' * 500; // 500 character plan name
        final longMealPlanId = 'plan-${'x' * 200}'; // 205 character ID
        final longUserId = 'user-${'y' * 100}'; // 105 character user ID

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: DailyPlanCache(),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: longMealPlanId,
          planName: longPlanName,
          status: PlanStatus.ACTIVE,
          userId: longUserId,
        );

        expect(mealPlan.planName.length, 500);
        expect(mealPlan.mealPlanId.length, 205);
        expect(mealPlan.userId.length, 105);

        final json = mealPlan.toJson();
        expect(json['planName'], longPlanName);
        expect(json['mealPlanId'], longMealPlanId);
        expect(json['userId'], longUserId);

        final amplifyPlan = mealPlan.toMealPlan();
        expect(amplifyPlan.planName, longPlanName);
        expect(amplifyPlan.mealPlanId, longMealPlanId);
        expect(amplifyPlan.userId, longUserId);
      });

      test('handles special characters and unicode in text fields', () {
        final unicodePlanName =
            'Plan avec caractères spéciaux: àáâãäåæçèéêë 漢字 العربية 🍽️';
        final unicodeMealPlanId = 'plan-日本語-test-123';
        final unicodeUserId = 'user-français-测试';

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: 'nutritionist-ñáéíóú',
          chatId: 'chat-中文-test',
          dailyPlan: DailyPlanCache(),
          generatedAt: TemporalDateTime.now(),
          mealPlanId: unicodeMealPlanId,
          planName: unicodePlanName,
          status: PlanStatus.ACTIVE,
          userId: unicodeUserId,
        );

        expect(mealPlan.planName, unicodePlanName);
        expect(mealPlan.mealPlanId, unicodeMealPlanId);
        expect(mealPlan.userId, unicodeUserId);
        expect(mealPlan.assignedNutritionistId, 'nutritionist-ñáéíóú');
        expect(mealPlan.chatId, 'chat-中文-test');

        final json = mealPlan.toJson();
        expect(json['planName'], unicodePlanName);
        expect(json['mealPlanId'], unicodeMealPlanId);
        expect(json['assignedNutritionistId'], 'nutritionist-ñáéíóú');

        final amplifyPlan = mealPlan.toMealPlan();
        expect(amplifyPlan.planName, unicodePlanName);
        expect(amplifyPlan.mealPlanId, unicodeMealPlanId);
        expect(amplifyPlan.assignedNutritionistId, 'nutritionist-ñáéíóú');
      });

      test('handles extreme timestamp values', () {
        final veryOldTime =
            TemporalDateTime.fromString('1900-01-01T00:00:00.000Z');
        final veryFutureTime =
            TemporalDateTime.fromString('2100-12-31T23:59:59.999Z');

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: DailyPlanCache(),
          generatedAt: veryOldTime,
          mealPlanId: 'extreme-time-plan',
          planName: 'Extreme Time Plan',
          status: PlanStatus.ACTIVE,
          userId: 'extreme-time-user',
          lastFetched: veryFutureTime,
        );

        expect(mealPlan.generatedAt.format(), veryOldTime.format());
        expect(mealPlan.lastFetched.format(), veryFutureTime.format());

        final json = mealPlan.toJson();
        expect(json['generatedAt'], veryOldTime.format());
        expect(json['lastFetched'], veryFutureTime.format());

        final amplifyPlan = mealPlan.toMealPlan();
        expect(amplifyPlan.generatedAt?.format(), veryOldTime.format());
      });

      test('handles empty daily plan with no meals', () {
        final emptyDailyPlan = DailyPlanCache.create(
          monday: [],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: emptyDailyPlan,
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'empty-plan',
          planName: 'Empty Meal Plan',
          status: PlanStatus.PENDING,
          userId: 'empty-plan-user',
        );

        expect(mealPlan.dailyPlan.monday, isEmpty);
        expect(mealPlan.dailyPlan.tuesday, isEmpty);
        expect(mealPlan.dailyPlan.wednesday, isEmpty);
        expect(mealPlan.dailyPlan.thursday, isEmpty);
        expect(mealPlan.dailyPlan.friday, isEmpty);
        expect(mealPlan.dailyPlan.saturday, isEmpty);
        expect(mealPlan.dailyPlan.sunday, isEmpty);

        final json = mealPlan.toJson();
        expect(json['dailyPlan']['monday'], isEmpty);
        expect(json['dailyPlan']['tuesday'], isEmpty);

        final amplifyPlan = mealPlan.toMealPlan();
        expect(amplifyPlan.dailyPlan?.monday, isEmpty);
        expect(amplifyPlan.dailyPlan?.tuesday, isEmpty);
      });

      test('handles plan with meals containing many ingredients', () {
        final manyIngredients = List.generate(
            50,
            (index) => IngredientCache.create(
                  name: 'Ingredient ${index + 1}',
                  amount: (index + 1) * 2.0,
                  unit: index % 3 == 0
                      ? 'g'
                      : index % 3 == 1
                          ? 'ml'
                          : 'piece',
                  macros: MacrosCache(
                    calories: (index + 1) * 5.0,
                    carbohydrates: (index + 1) * 1.0,
                    fats: (index + 1) * 0.5,
                    proteins: (index + 1) * 0.8,
                  ),
                ));

        final complexMeal = MealCache.create(
          name: MealNameEnum.DINNER,
          recipe: 'Complex recipe with 50 ingredients',
          recipeName: 'Mega Complex Dinner',
          ingredients: manyIngredients,
          totalMacros: MacrosCache(
              calories: 6375,
              carbohydrates: 1275,
              fats: 637.5,
              proteins: 1020), // Calculated totals
        );

        final dailyPlan = DailyPlanCache.create(
          monday: [complexMeal],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final mealPlan = MealPlanCache.create(
          assignedNutritionistId: null,
          chatId: null,
          dailyPlan: dailyPlan,
          generatedAt: TemporalDateTime.now(),
          mealPlanId: 'complex-meal-plan',
          planName: 'Complex Meal Plan',
          status: PlanStatus.ACTIVE,
          userId: 'complex-meal-user',
        );

        expect(mealPlan.dailyPlan.monday.length, 1);
        expect(mealPlan.dailyPlan.monday[0].ingredients.length, 50);
        expect(mealPlan.dailyPlan.monday[0].totalMacros.calories, 6375);

        final json = mealPlan.toJson();
        expect(json['dailyPlan']['monday'][0]['ingredients'].length, 50);

        final amplifyPlan = mealPlan.toMealPlan();
        expect(amplifyPlan.dailyPlan?.monday?[0].ingredients.length, 50);
        expect(amplifyPlan.dailyPlan?.monday?[0].totalMacros.calories, 6375);
      });
    });
  });
}
