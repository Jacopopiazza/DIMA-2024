import 'package:dima_application/generated/flutter-models/DailyPlanData.dart';
import 'package:dima_application/generated/flutter-models/Ingredient.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyPlanCache', () {
    group('Constructor and initialization', () {
      test('creates DailyPlanCache with default constructor', () {
        final dailyPlan = DailyPlanCache();

        expect(dailyPlan, isA<DailyPlanCache>());
        expect(dailyPlan.monday, isEmpty);
        expect(dailyPlan.tuesday, isEmpty);
        expect(dailyPlan.wednesday, isEmpty);
        expect(dailyPlan.thursday, isEmpty);
        expect(dailyPlan.friday, isEmpty);
        expect(dailyPlan.saturday, isEmpty);
        expect(dailyPlan.sunday, isEmpty);
      });

      test('creates DailyPlanCache with create constructor', () {
        final mondayMeals = [
          MealCache.create(
            name: MealNameEnum.BREAKFAST,
            recipe: 'Morning oatmeal',
            recipeName: 'Oatmeal',
            ingredients: [],
            totalMacros: MacrosCache(calories: 300),
          ),
        ];

        final tuesdayMeals = [
          MealCache.create(
            name: MealNameEnum.LUNCH,
            recipe: 'Chicken salad',
            recipeName: 'Salad',
            ingredients: [],
            totalMacros: MacrosCache(calories: 400),
          ),
        ];

        final dailyPlan = DailyPlanCache.create(
          monday: mondayMeals,
          tuesday: tuesdayMeals,
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        expect(dailyPlan.monday.length, 1);
        expect(dailyPlan.tuesday.length, 1);
        expect(dailyPlan.wednesday, isEmpty);
        expect(dailyPlan.monday[0].name, MealNameEnum.BREAKFAST);
        expect(dailyPlan.tuesday[0].name, MealNameEnum.LUNCH);
      });

      test('creates DailyPlanCache with meals for all days', () {
        final createMeal =
            (MealNameEnum name, String recipeName) => MealCache.create(
                  name: name,
                  recipe: 'Recipe for $recipeName',
                  recipeName: recipeName,
                  ingredients: [],
                  totalMacros: MacrosCache(calories: 250),
                );

        final dailyPlan = DailyPlanCache.create(
          monday: [createMeal(MealNameEnum.BREAKFAST, 'Monday Breakfast')],
          tuesday: [createMeal(MealNameEnum.LUNCH, 'Tuesday Lunch')],
          wednesday: [createMeal(MealNameEnum.DINNER, 'Wednesday Dinner')],
          thursday: [createMeal(MealNameEnum.SNACK_MORNING, 'Thursday Snack')],
          friday: [createMeal(MealNameEnum.BREAKFAST, 'Friday Breakfast')],
          saturday: [createMeal(MealNameEnum.LUNCH, 'Saturday Lunch')],
          sunday: [createMeal(MealNameEnum.DINNER, 'Sunday Dinner')],
        );

        expect(dailyPlan.monday[0].recipeName, 'Monday Breakfast');
        expect(dailyPlan.tuesday[0].recipeName, 'Tuesday Lunch');
        expect(dailyPlan.wednesday[0].recipeName, 'Wednesday Dinner');
        expect(dailyPlan.thursday[0].recipeName, 'Thursday Snack');
        expect(dailyPlan.friday[0].recipeName, 'Friday Breakfast');
        expect(dailyPlan.saturday[0].recipeName, 'Saturday Lunch');
        expect(dailyPlan.sunday[0].recipeName, 'Sunday Dinner');
      });
    });

    group('Factory constructor fromAmplify', () {
      test('creates DailyPlanCache from Amplify DailyPlanData', () {
        final amplifyIngredient = Ingredient(
          name: 'Test Ingredient',
          amount: 100.0,
          unit: 'g',
          macros:
              Macros(calories: 150, carbohydrates: 20, fats: 5, proteins: 10),
        );

        final amplifyMeals = [
          Meal(
            name: MealNameEnum.BREAKFAST,
            recipe: 'Amplify breakfast recipe',
            recipeName: 'Amplify Breakfast',
            ingredients: [amplifyIngredient],
            totalMacros: Macros(
                calories: 300, carbohydrates: 40, fats: 10, proteins: 20),
          ),
          Meal(
            name: MealNameEnum.LUNCH,
            recipe: 'Amplify lunch recipe',
            recipeName: 'Amplify Lunch',
            ingredients: [amplifyIngredient],
            totalMacros: Macros(
                calories: 450, carbohydrates: 50, fats: 15, proteins: 30),
          ),
        ];

        final amplifyDailyPlan = DailyPlanData(
          monday: amplifyMeals,
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final dailyPlan = DailyPlanCache.fromAmplify(amplifyDailyPlan);

        expect(dailyPlan.monday.length, 2);
        expect(dailyPlan.tuesday, isEmpty);
        expect(dailyPlan.monday[0].name, MealNameEnum.BREAKFAST);
        expect(dailyPlan.monday[0].recipeName, 'Amplify Breakfast');
        expect(dailyPlan.monday[0].totalMacros.calories, 300);
        expect(dailyPlan.monday[1].name, MealNameEnum.LUNCH);
        expect(dailyPlan.monday[1].recipeName, 'Amplify Lunch');
        expect(dailyPlan.monday[1].totalMacros.calories, 450);
      });

      test('handles null DailyPlanData', () {
        final dailyPlan = DailyPlanCache.fromAmplify(null);

        expect(dailyPlan.monday, isEmpty);
        expect(dailyPlan.tuesday, isEmpty);
        expect(dailyPlan.wednesday, isEmpty);
        expect(dailyPlan.thursday, isEmpty);
        expect(dailyPlan.friday, isEmpty);
        expect(dailyPlan.saturday, isEmpty);
        expect(dailyPlan.sunday, isEmpty);
      });

      test('handles null meal lists in DailyPlanData', () {
        final amplifyDailyPlan = DailyPlanData(
          monday: null, // Null meal list
          tuesday: [],
          wednesday: null, // Null meal list
          thursday: [],
          friday: null, // Null meal list
          saturday: [],
          sunday: null, // Null meal list
        );

        final dailyPlan = DailyPlanCache.fromAmplify(amplifyDailyPlan);

        expect(dailyPlan.monday, isEmpty); // Null becomes empty
        expect(dailyPlan.tuesday, isEmpty);
        expect(dailyPlan.wednesday, isEmpty); // Null becomes empty
        expect(dailyPlan.thursday, isEmpty);
        expect(dailyPlan.friday, isEmpty); // Null becomes empty
        expect(dailyPlan.saturday, isEmpty);
        expect(dailyPlan.sunday, isEmpty); // Null becomes empty
      });

      test('creates DailyPlanCache with complex weekly plan', () {
        final createAmplifyMeal =
            (MealNameEnum name, String recipeName, double calories) => Meal(
                  name: name,
                  recipe: 'Recipe for $recipeName',
                  recipeName: recipeName,
                  ingredients: [
                    Ingredient(
                      name: 'Sample Ingredient',
                      amount: 100.0,
                      unit: 'g',
                      macros: Macros(
                          calories: calories,
                          carbohydrates: 20,
                          fats: 5,
                          proteins: 10),
                    ),
                  ],
                  totalMacros: Macros(
                      calories: calories,
                      carbohydrates: 20,
                      fats: 5,
                      proteins: 10),
                );

        final amplifyDailyPlan = DailyPlanData(
          monday: [
            createAmplifyMeal(MealNameEnum.BREAKFAST, 'Monday Breakfast', 300),
            createAmplifyMeal(MealNameEnum.LUNCH, 'Monday Lunch', 450),
            createAmplifyMeal(MealNameEnum.DINNER, 'Monday Dinner', 500),
          ],
          tuesday: [
            createAmplifyMeal(MealNameEnum.BREAKFAST, 'Tuesday Breakfast', 320),
            createAmplifyMeal(
                MealNameEnum.SNACK_AFTERNOON, 'Tuesday Snack', 150),
          ],
          wednesday: [
            createAmplifyMeal(MealNameEnum.LUNCH, 'Wednesday Lunch', 400),
          ],
          thursday: [],
          friday: [
            createAmplifyMeal(MealNameEnum.DINNER, 'Friday Dinner', 550),
          ],
          saturday: [
            createAmplifyMeal(
                MealNameEnum.BREAKFAST, 'Saturday Breakfast', 280),
            createAmplifyMeal(MealNameEnum.LUNCH, 'Saturday Lunch', 420),
          ],
          sunday: [
            createAmplifyMeal(
                MealNameEnum.SNACK_MORNING, 'Sunday Morning Snack', 100),
            createAmplifyMeal(MealNameEnum.DINNER, 'Sunday Dinner', 480),
          ],
        );

        final dailyPlan = DailyPlanCache.fromAmplify(amplifyDailyPlan);

        // Monday
        expect(dailyPlan.monday.length, 3);
        expect(dailyPlan.monday[0].name, MealNameEnum.BREAKFAST);
        expect(dailyPlan.monday[1].name, MealNameEnum.LUNCH);
        expect(dailyPlan.monday[2].name, MealNameEnum.DINNER);

        // Tuesday
        expect(dailyPlan.tuesday.length, 2);
        expect(dailyPlan.tuesday[0].name, MealNameEnum.BREAKFAST);
        expect(dailyPlan.tuesday[1].name, MealNameEnum.SNACK_AFTERNOON);

        // Wednesday
        expect(dailyPlan.wednesday.length, 1);
        expect(dailyPlan.wednesday[0].name, MealNameEnum.LUNCH);

        // Thursday
        expect(dailyPlan.thursday, isEmpty);

        // Friday
        expect(dailyPlan.friday.length, 1);
        expect(dailyPlan.friday[0].name, MealNameEnum.DINNER);

        // Saturday
        expect(dailyPlan.saturday.length, 2);
        expect(dailyPlan.saturday[0].name, MealNameEnum.BREAKFAST);
        expect(dailyPlan.saturday[1].name, MealNameEnum.LUNCH);

        // Sunday
        expect(dailyPlan.sunday.length, 2);
        expect(dailyPlan.sunday[0].name, MealNameEnum.SNACK_MORNING);
        expect(dailyPlan.sunday[1].name, MealNameEnum.DINNER);
      });
    });

    group('toJson method', () {
      test('converts DailyPlanCache to JSON', () {
        final meal1 = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Morning meal',
          recipeName: 'Breakfast',
          ingredients: [
            IngredientCache.create(
              name: 'Oats',
              amount: 50.0,
              unit: 'g',
              macros: MacrosCache(calories: 200),
            ),
          ],
          totalMacros: MacrosCache(calories: 250),
        );

        final meal2 = MealCache.create(
          name: MealNameEnum.LUNCH,
          recipe: 'Midday meal',
          recipeName: 'Lunch',
          ingredients: [],
          totalMacros: MacrosCache(calories: 400),
        );

        final dailyPlan = DailyPlanCache.create(
          monday: [meal1],
          tuesday: [meal2],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final json = dailyPlan.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['monday'], isA<List>());
        expect(json['tuesday'], isA<List>());
        expect(json['wednesday'], isA<List>());
        expect(json['thursday'], isA<List>());
        expect(json['friday'], isA<List>());
        expect(json['saturday'], isA<List>());
        expect(json['sunday'], isA<List>());

        expect(json['monday'].length, 1);
        expect(json['tuesday'].length, 1);
        expect(json['wednesday'], isEmpty);

        // Check meal content in JSON
        expect(json['monday'][0]['name'], MealNameEnum.BREAKFAST);
        expect(json['monday'][0]['recipe_name'], 'Breakfast');
        expect(json['tuesday'][0]['name'], MealNameEnum.LUNCH);
        expect(json['tuesday'][0]['recipe_name'], 'Lunch');
      });

      test('converts empty DailyPlanCache to JSON', () {
        final dailyPlan = DailyPlanCache();

        final json = dailyPlan.toJson();

        expect(json['monday'], isEmpty);
        expect(json['tuesday'], isEmpty);
        expect(json['wednesday'], isEmpty);
        expect(json['thursday'], isEmpty);
        expect(json['friday'], isEmpty);
        expect(json['saturday'], isEmpty);
        expect(json['sunday'], isEmpty);
      });
    });

    group('toDailyPlan method', () {
      test('converts DailyPlanCache to Amplify DailyPlanData', () {
        final meal1 = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Morning recipe',
          recipeName: 'Morning Meal',
          ingredients: [
            IngredientCache.create(
              name: 'Eggs',
              amount: 2.0,
              unit: 'large',
              macros: MacrosCache(
                  calories: 140, carbohydrates: 1, fats: 10, proteins: 12),
            ),
          ],
          totalMacros: MacrosCache(
              calories: 200, carbohydrates: 5, fats: 12, proteins: 15),
        );

        final meal2 = MealCache.create(
          name: MealNameEnum.DINNER,
          recipe: 'Evening recipe',
          recipeName: 'Evening Meal',
          ingredients: [],
          totalMacros: MacrosCache(
              calories: 500, carbohydrates: 50, fats: 20, proteins: 30),
        );

        final dailyPlan = DailyPlanCache.create(
          monday: [meal1],
          tuesday: [],
          wednesday: [meal2],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final amplifyDailyPlan = dailyPlan.toDailyPlan();

        expect(amplifyDailyPlan, isA<DailyPlanData>());
        expect(amplifyDailyPlan.monday?.length, 1);
        expect(amplifyDailyPlan.tuesday?.length, 0);
        expect(amplifyDailyPlan.wednesday?.length, 1);
        expect(amplifyDailyPlan.thursday?.length, 0);
        expect(amplifyDailyPlan.friday?.length, 0);
        expect(amplifyDailyPlan.saturday?.length, 0);
        expect(amplifyDailyPlan.sunday?.length, 0);

        // Check Monday meal
        expect(amplifyDailyPlan.monday![0].name, MealNameEnum.BREAKFAST);
        expect(amplifyDailyPlan.monday![0].recipeName, 'Morning Meal');
        expect(amplifyDailyPlan.monday![0].totalMacros.calories, 200);
        expect(amplifyDailyPlan.monday![0].ingredients.length, 1);
        expect(amplifyDailyPlan.monday![0].ingredients[0].name, 'Eggs');

        // Check Wednesday meal
        expect(amplifyDailyPlan.wednesday![0].name, MealNameEnum.DINNER);
        expect(amplifyDailyPlan.wednesday![0].recipeName, 'Evening Meal');
        expect(amplifyDailyPlan.wednesday![0].totalMacros.calories, 500);
        expect(amplifyDailyPlan.wednesday![0].ingredients, isEmpty);
      });

      test('converts empty DailyPlanCache to empty DailyPlanData', () {
        final dailyPlan = DailyPlanCache();

        final amplifyDailyPlan = dailyPlan.toDailyPlan();

        expect(amplifyDailyPlan.monday, isEmpty);
        expect(amplifyDailyPlan.tuesday, isEmpty);
        expect(amplifyDailyPlan.wednesday, isEmpty);
        expect(amplifyDailyPlan.thursday, isEmpty);
        expect(amplifyDailyPlan.friday, isEmpty);
        expect(amplifyDailyPlan.saturday, isEmpty);
        expect(amplifyDailyPlan.sunday, isEmpty);
      });

      test('round-trip Amplify conversion preserves data', () {
        final originalAmplify = DailyPlanData(
          monday: [
            Meal(
              name: MealNameEnum.BREAKFAST,
              recipe: 'Original breakfast recipe',
              recipeName: 'Original Breakfast',
              ingredients: [
                Ingredient(
                  name: 'Original Ingredient',
                  amount: 75.0,
                  unit: 'g',
                  macros: Macros(
                      calories: 180, carbohydrates: 25, fats: 6, proteins: 8),
                ),
              ],
              totalMacros: Macros(
                  calories: 250, carbohydrates: 30, fats: 8, proteins: 12),
            ),
          ],
          tuesday: [],
          wednesday: [
            Meal(
              name: MealNameEnum.LUNCH,
              recipe: 'Original lunch recipe',
              recipeName: 'Original Lunch',
              ingredients: [],
              totalMacros: Macros(
                  calories: 400, carbohydrates: 45, fats: 15, proteins: 25),
            ),
          ],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final cache = DailyPlanCache.fromAmplify(originalAmplify);
        final reconstructed = cache.toDailyPlan();

        // Check Monday meal
        expect(reconstructed.monday?.length, 1);
        expect(reconstructed.monday![0].name, originalAmplify.monday![0].name);
        expect(
            reconstructed.monday![0].recipe, originalAmplify.monday![0].recipe);
        expect(reconstructed.monday![0].recipeName,
            originalAmplify.monday![0].recipeName);
        expect(reconstructed.monday![0].totalMacros.calories,
            originalAmplify.monday![0].totalMacros.calories);
        expect(reconstructed.monday![0].ingredients.length,
            originalAmplify.monday![0].ingredients.length);

        // Check Wednesday meal
        expect(reconstructed.wednesday?.length, 1);
        expect(reconstructed.wednesday![0].name,
            originalAmplify.wednesday![0].name);
        expect(reconstructed.wednesday![0].recipe,
            originalAmplify.wednesday![0].recipe);
        expect(reconstructed.wednesday![0].recipeName,
            originalAmplify.wednesday![0].recipeName);
        expect(reconstructed.wednesday![0].totalMacros.calories,
            originalAmplify.wednesday![0].totalMacros.calories);

        // Check empty days
        expect(reconstructed.tuesday, isEmpty);
        expect(reconstructed.thursday, isEmpty);
        expect(reconstructed.friday, isEmpty);
        expect(reconstructed.saturday, isEmpty);
        expect(reconstructed.sunday, isEmpty);
      });
    });

    group('Realistic usage scenarios', () {
      test('represents a balanced weekly meal plan', () {
        final createBalancedMeal =
            (MealNameEnum type, String day, double calories) =>
                MealCache.create(
                  name: type,
                  recipe: 'Balanced recipe for $day ${type.name}',
                  recipeName: '$day ${type.name}',
                  ingredients: [
                    IngredientCache.create(
                      name: 'Protein Source',
                      amount: 100.0,
                      unit: 'g',
                      macros: MacrosCache(
                          calories: calories * 0.4, proteins: calories * 0.1),
                    ),
                    IngredientCache.create(
                      name: 'Carb Source',
                      amount: 80.0,
                      unit: 'g',
                      macros: MacrosCache(
                          calories: calories * 0.4,
                          carbohydrates: calories * 0.15),
                    ),
                    IngredientCache.create(
                      name: 'Vegetables',
                      amount: 150.0,
                      unit: 'g',
                      macros: MacrosCache(
                          calories: calories * 0.2,
                          carbohydrates: calories * 0.05),
                    ),
                  ],
                  totalMacros: MacrosCache(
                    calories: calories,
                    carbohydrates: calories * 0.2,
                    fats: calories * 0.25,
                    proteins: calories * 0.3,
                  ),
                );

        final weeklyPlan = DailyPlanCache.create(
          monday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Monday', 350),
            createBalancedMeal(MealNameEnum.LUNCH, 'Monday', 450),
            createBalancedMeal(MealNameEnum.DINNER, 'Monday', 500),
          ],
          tuesday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Tuesday', 320),
            createBalancedMeal(MealNameEnum.SNACK_MORNING, 'Tuesday', 150),
            createBalancedMeal(MealNameEnum.LUNCH, 'Tuesday', 420),
            createBalancedMeal(MealNameEnum.DINNER, 'Tuesday', 480),
          ],
          wednesday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Wednesday', 340),
            createBalancedMeal(MealNameEnum.LUNCH, 'Wednesday', 440),
            createBalancedMeal(MealNameEnum.SNACK_AFTERNOON, 'Wednesday', 100),
            createBalancedMeal(MealNameEnum.DINNER, 'Wednesday', 520),
          ],
          thursday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Thursday', 330),
            createBalancedMeal(MealNameEnum.LUNCH, 'Thursday', 460),
            createBalancedMeal(MealNameEnum.DINNER, 'Thursday', 490),
          ],
          friday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Friday', 360),
            createBalancedMeal(MealNameEnum.LUNCH, 'Friday', 470),
            createBalancedMeal(MealNameEnum.SNACK_EVENING, 'Friday', 120),
            createBalancedMeal(MealNameEnum.DINNER, 'Friday', 510),
          ],
          saturday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Saturday', 380),
            createBalancedMeal(MealNameEnum.LUNCH, 'Saturday', 500),
            createBalancedMeal(MealNameEnum.DINNER, 'Saturday', 550),
          ],
          sunday: [
            createBalancedMeal(MealNameEnum.BREAKFAST, 'Sunday', 370),
            createBalancedMeal(MealNameEnum.LUNCH, 'Sunday', 480),
            createBalancedMeal(MealNameEnum.DINNER, 'Sunday', 530),
          ],
        );

        // Test that each day has appropriate meals
        expect(weeklyPlan.monday.length, 3); // Breakfast, Lunch, Dinner
        expect(weeklyPlan.tuesday.length, 4); // + Morning Snack
        expect(weeklyPlan.wednesday.length, 4); // + Afternoon Snack
        expect(weeklyPlan.thursday.length, 3); // Breakfast, Lunch, Dinner
        expect(weeklyPlan.friday.length, 4); // + Evening Snack
        expect(weeklyPlan.saturday.length, 3); // Breakfast, Lunch, Dinner
        expect(weeklyPlan.sunday.length, 3); // Breakfast, Lunch, Dinner

        // Calculate weekly calories
        final allMeals = [
          ...weeklyPlan.monday,
          ...weeklyPlan.tuesday,
          ...weeklyPlan.wednesday,
          ...weeklyPlan.thursday,
          ...weeklyPlan.friday,
          ...weeklyPlan.saturday,
          ...weeklyPlan.sunday,
        ];

        final weeklyCalories = allMeals.fold<double>(
            0, (sum, meal) => sum + meal.totalMacros.calories);

        expect(allMeals.length, 24); // Total number of meals
        expect(weeklyCalories, 9620); // Expected total calories
      });

      test('handles meal plan customization by dietary preferences', () {
        final createVegetarianMeal = (MealNameEnum type, String name) =>
            MealCache.create(
              name: type,
              recipe: 'Vegetarian recipe for $name',
              recipeName: 'Vegetarian $name',
              ingredients: [
                IngredientCache.create(
                  name: 'Legumes',
                  amount: 100.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 120, carbohydrates: 20, proteins: 8),
                ),
                IngredientCache.create(
                  name: 'Whole Grains',
                  amount: 80.0,
                  unit: 'g',
                  macros: MacrosCache(
                      calories: 280, carbohydrates: 60, proteins: 8),
                ),
                IngredientCache.create(
                  name: 'Vegetables',
                  amount: 200.0,
                  unit: 'g',
                  macros:
                      MacrosCache(calories: 50, carbohydrates: 10, proteins: 2),
                ),
              ],
              totalMacros: MacrosCache(
                  calories: 450, carbohydrates: 90, fats: 5, proteins: 18),
            );

        final vegetarianPlan = DailyPlanCache.create(
          monday: [
            createVegetarianMeal(MealNameEnum.BREAKFAST, 'Quinoa Bowl'),
            createVegetarianMeal(MealNameEnum.LUNCH, 'Lentil Curry'),
            createVegetarianMeal(MealNameEnum.DINNER, 'Chickpea Stir-fry'),
          ],
          tuesday: [
            createVegetarianMeal(MealNameEnum.BREAKFAST, 'Oat Porridge'),
            createVegetarianMeal(MealNameEnum.LUNCH, 'Bean Salad'),
            createVegetarianMeal(MealNameEnum.DINNER, 'Tofu Stir-fry'),
          ],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        // Test vegetarian meal characteristics
        expect(vegetarianPlan.monday.length, 3);
        expect(vegetarianPlan.tuesday.length, 3);

        // All meals should have high carb/protein ratio typical of vegetarian meals
        for (final meal in vegetarianPlan.monday) {
          expect(meal.recipeName, contains('Vegetarian'));
          expect(meal.totalMacros.carbohydrates, 90);
          expect(meal.totalMacros.proteins, 18);
          expect(meal.ingredients.length, 3);
          expect(meal.ingredients.any((ing) => ing.name == 'Legumes'), true);
        }
      });

      test('supports meal plan analytics and reporting', () {
        final createTrackedMeal =
            (MealNameEnum type, double calories, double protein) =>
                MealCache.create(
                  name: type,
                  recipe: 'Tracked recipe',
                  recipeName: 'Tracked ${type.name}',
                  ingredients: [],
                  totalMacros: MacrosCache(
                    calories: calories,
                    carbohydrates: calories * 0.5 / 4, // 50% carbs
                    fats: calories * 0.3 / 9, // 30% fats
                    proteins: protein,
                  ),
                );

        final weekPlan = DailyPlanCache.create(
          monday: [
            createTrackedMeal(MealNameEnum.BREAKFAST, 350, 20),
            createTrackedMeal(MealNameEnum.LUNCH, 450, 30),
            createTrackedMeal(MealNameEnum.DINNER, 500, 35),
          ],
          tuesday: [
            createTrackedMeal(MealNameEnum.BREAKFAST, 320, 18),
            createTrackedMeal(MealNameEnum.LUNCH, 420, 28),
            createTrackedMeal(MealNameEnum.DINNER, 480, 32),
          ],
          wednesday: [
            createTrackedMeal(MealNameEnum.BREAKFAST, 340, 19),
            createTrackedMeal(MealNameEnum.LUNCH, 440, 29),
            createTrackedMeal(MealNameEnum.DINNER, 520, 36),
          ],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        // Calculate analytics for Monday-Wednesday
        final activeDays = [
          weekPlan.monday,
          weekPlan.tuesday,
          weekPlan.wednesday
        ];
        final dailyTotals = activeDays.map((dayMeals) {
          return dayMeals.fold(
              MacrosCache(), (total, meal) => total + meal.totalMacros);
        }).toList();

        // Monday totals
        expect(dailyTotals[0].calories, 1300); // 350 + 450 + 500
        expect(dailyTotals[0].proteins, 85); // 20 + 30 + 35

        // Tuesday totals
        expect(dailyTotals[1].calories, 1220); // 320 + 420 + 480
        expect(dailyTotals[1].proteins, 78); // 18 + 28 + 32

        // Wednesday totals
        expect(dailyTotals[2].calories, 1300); // 340 + 440 + 520
        expect(dailyTotals[2].proteins, 84); // 19 + 29 + 36

        // Weekly averages
        final avgDailyCalories =
            dailyTotals.fold<double>(0, (sum, day) => sum + day.calories) / 3;
        final avgDailyProtein =
            dailyTotals.fold<double>(0, (sum, day) => sum + day.proteins) / 3;

        expect(avgDailyCalories, closeTo(1273.33, 0.01));
        expect(avgDailyProtein, closeTo(82.33, 0.01));
      });
    });

    group('Edge cases and validation', () {
      test('handles days with many meals', () {
        final manyMeals = List.generate(
            10,
            (index) => MealCache.create(
                  name: MealNameEnum.values[index % MealNameEnum.values.length],
                  recipe: 'Recipe $index',
                  recipeName: 'Meal $index',
                  ingredients: [],
                  totalMacros: MacrosCache(calories: 100 + index * 10),
                ));

        final dailyPlan = DailyPlanCache.create(
          monday: manyMeals,
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        expect(dailyPlan.monday.length, 10);
        expect(dailyPlan.monday[0].recipeName, 'Meal 0');
        expect(dailyPlan.monday[9].recipeName, 'Meal 9');
        expect(dailyPlan.monday[0].totalMacros.calories, 100);
        expect(dailyPlan.monday[9].totalMacros.calories, 190);

        final json = dailyPlan.toJson();
        expect(json['monday'].length, 10);

        final amplifyPlan = dailyPlan.toDailyPlan();
        expect(amplifyPlan.monday?.length, 10);
      });

      test('handles meals with complex ingredients', () {
        final complexMeal = MealCache.create(
          name: MealNameEnum.DINNER,
          recipe: '''
          Multi-step complex recipe:
          1. Prepare base sauce with 15 ingredients
          2. Marinate protein for 2 hours
          3. Prepare 3 different side dishes
          4. Combine and garnish
          ''',
          recipeName: 'Gourmet Multi-Course Dinner',
          ingredients: List.generate(
              20,
              (index) => IngredientCache.create(
                    name: 'Complex Ingredient ${index + 1}',
                    amount: (index + 1) * 5.0,
                    unit: index % 2 == 0 ? 'g' : 'ml',
                    macros: MacrosCache(
                      calories: (index + 1) * 10.0,
                      carbohydrates: (index + 1) * 2.0,
                      fats: (index + 1) * 1.0,
                      proteins: (index + 1) * 1.5,
                    ),
                  )),
          totalMacros: MacrosCache(
              calories: 2100, carbohydrates: 420, fats: 210, proteins: 315),
        );

        final dailyPlan = DailyPlanCache.create(
          monday: [],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [complexMeal],
          sunday: [],
        );

        expect(dailyPlan.saturday.length, 1);
        expect(dailyPlan.saturday[0].ingredients.length, 20);
        expect(dailyPlan.saturday[0].totalMacros.calories, 2100);
        expect(dailyPlan.saturday[0].recipe.contains('Multi-step'), true);

        final json = dailyPlan.toJson();
        expect(json['saturday'][0]['ingredients'].length, 20);

        final amplifyPlan = dailyPlan.toDailyPlan();
        expect(amplifyPlan.saturday![0].ingredients.length, 20);
      });

      test('handles empty and null meal scenarios in conversion', () {
        final dailyPlan = DailyPlanCache.create(
          monday: [],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        final json = dailyPlan.toJson();

        expect(json['monday'], isEmpty);
        expect(json['tuesday'], isEmpty);
        expect(json['wednesday'], isEmpty);
        expect(json['thursday'], isEmpty);
        expect(json['friday'], isEmpty);
        expect(json['saturday'], isEmpty);
        expect(json['sunday'], isEmpty);

        final amplifyPlan = dailyPlan.toDailyPlan();

        expect(amplifyPlan.monday, isEmpty);
        expect(amplifyPlan.tuesday, isEmpty);
        expect(amplifyPlan.wednesday, isEmpty);
        expect(amplifyPlan.thursday, isEmpty);
        expect(amplifyPlan.friday, isEmpty);
        expect(amplifyPlan.saturday, isEmpty);
        expect(amplifyPlan.sunday, isEmpty);
      });

      test('handles meals with extreme macro values', () {
        final extremeMeal = MealCache.create(
          name: MealNameEnum.LUNCH,
          recipe: 'Extreme macro test meal',
          recipeName: 'Extreme Meal',
          ingredients: [],
          totalMacros: MacrosCache(
            calories: 9999.99,
            carbohydrates: 1234.56,
            fats: 789.01,
            proteins: 456.78,
          ),
        );

        final dailyPlan = DailyPlanCache.create(
          monday: [],
          tuesday: [extremeMeal],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        expect(dailyPlan.tuesday[0].totalMacros.calories, 9999.99);
        expect(dailyPlan.tuesday[0].totalMacros.carbohydrates, 1234.56);

        final json = dailyPlan.toJson();
        expect(json['tuesday'][0]['total_macros']['calories'], 9999.99);

        final amplifyPlan = dailyPlan.toDailyPlan();
        expect(amplifyPlan.tuesday![0].totalMacros.calories, 9999.99);
        expect(amplifyPlan.tuesday![0].totalMacros.carbohydrates, 1234.56);
      });

      test('handles special characters in meal data', () {
        final specialMeal = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Café recipe with açaí & crème brûlée 🍽️',
          recipeName: 'Специальный завтрак (Special Breakfast) 漢字',
          ingredients: [
            IngredientCache.create(
              name: 'Açaí berries 🫐',
              amount: 50.0,
              unit: 'g',
              macros: MacrosCache(calories: 70),
            ),
          ],
          totalMacros: MacrosCache(calories: 300),
        );

        final dailyPlan = DailyPlanCache.create(
          monday: [specialMeal],
          tuesday: [],
          wednesday: [],
          thursday: [],
          friday: [],
          saturday: [],
          sunday: [],
        );

        expect(dailyPlan.monday[0].recipe, contains('🍽️'));
        expect(dailyPlan.monday[0].recipeName, contains('漢字'));
        expect(dailyPlan.monday[0].ingredients[0].name, contains('🫐'));

        final json = dailyPlan.toJson();
        expect(json['monday'][0]['recipe'], contains('🍽️'));
        expect(json['monday'][0]['recipe_name'], contains('漢字'));

        final amplifyPlan = dailyPlan.toDailyPlan();
        expect(amplifyPlan.monday![0].recipe, contains('🍽️'));
        expect(amplifyPlan.monday![0].recipeName, contains('漢字'));
      });
    });
  });
}
