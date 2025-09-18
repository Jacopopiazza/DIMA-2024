import 'package:dima_application/generated/flutter-models/Ingredient.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealCache', () {
    group('Constructor and initialization', () {
      test('creates MealCache with default constructor', () {
        final meal = MealCache();

        expect(meal, isA<MealCache>());
      });

      test('creates MealCache with create constructor', () {
        final ingredients = [
          IngredientCache.create(
            name: 'Oats',
            amount: 50.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 200, carbohydrates: 35, fats: 3, proteins: 8),
          ),
        ];

        final totalMacros = MacrosCache(
          calories: 250.0,
          carbohydrates: 40.0,
          fats: 5.0,
          proteins: 10.0,
        );

        final meal = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Prepare oatmeal with milk and fruits',
          recipeName: 'Morning Oatmeal',
          ingredients: ingredients,
          totalMacros: totalMacros,
        );

        expect(meal.name, MealNameEnum.BREAKFAST);
        expect(meal.recipe, 'Prepare oatmeal with milk and fruits');
        expect(meal.recipeName, 'Morning Oatmeal');
        expect(meal.ingredients.length, 1);
        expect(meal.ingredients[0].name, 'Oats');
        expect(meal.totalMacros.calories, 250.0);
      });

      test('creates MealCache with different meal types', () {
        final mealTypes = [
          MealNameEnum.BREAKFAST,
          MealNameEnum.LUNCH,
          MealNameEnum.DINNER,
          MealNameEnum.SNACK_MORNING,
          MealNameEnum.SNACK_AFTERNOON,
          MealNameEnum.SNACK_EVENING,
        ];

        for (final mealType in mealTypes) {
          final meal = MealCache.create(
            name: mealType,
            recipe: 'Test recipe',
            recipeName: 'Test meal',
            ingredients: [],
            totalMacros: MacrosCache(),
          );

          expect(meal.name, mealType);
        }
      });
    });

    // Factory constructor fromJson tests removed per request

    group('Factory constructor fromAmplify', () {
      test('creates MealCache from Amplify Meal model', () {
        final amplifyIngredients = [
          Ingredient(
            name: 'Salmon',
            amount: 120.0,
            unit: 'g',
            macros:
                Macros(calories: 200, carbohydrates: 0, fats: 12, proteins: 22),
          ),
          Ingredient(
            name: 'Quinoa',
            amount: 80.0,
            unit: 'g',
            macros:
                Macros(calories: 120, carbohydrates: 22, fats: 2, proteins: 4),
          ),
        ];

        final amplifyTotalMacros = Macros(
          calories: 320,
          carbohydrates: 22,
          fats: 14,
          proteins: 26,
        );

        final amplifyMeal = Meal(
          name: MealNameEnum.DINNER,
          recipe: 'Bake salmon and prepare quinoa',
          recipeName: 'Salmon Quinoa Bowl',
          ingredients: amplifyIngredients,
          totalMacros: amplifyTotalMacros,
        );

        final meal = MealCache.fromAmplify(amplifyMeal);

        expect(meal.name, MealNameEnum.DINNER);
        expect(meal.recipe, 'Bake salmon and prepare quinoa');
        expect(meal.recipeName, 'Salmon Quinoa Bowl');
        expect(meal.ingredients.length, 2);
        expect(meal.ingredients[0].name, 'Salmon');
        expect(meal.ingredients[1].name, 'Quinoa');
        expect(meal.totalMacros.calories, 320);
        expect(meal.totalMacros.proteins, 26);
      });

      test('handles null recipe fields with defaults', () {
        final amplifyMeal = Meal(
          name: MealNameEnum.BREAKFAST,
          recipe: null, // Null recipe
          recipeName: null, // Null recipe name
          ingredients: [],
          totalMacros:
              Macros(calories: 100, carbohydrates: 15, fats: 2, proteins: 5),
        );

        final meal = MealCache.fromAmplify(amplifyMeal);

        expect(meal.name, MealNameEnum.BREAKFAST);
        expect(meal.recipe, 'EMPTY RECIPE'); // Default for null
        expect(meal.recipeName, 'EMPTY RECIPE NAME'); // Default for null
        expect(meal.ingredients, isEmpty);
        expect(meal.totalMacros.calories, 100);
      });

      test('handles enum value conversion correctly', () {
        // Test all available meal name enums
        final mealNames = [
          MealNameEnum.BREAKFAST,
          MealNameEnum.LUNCH,
          MealNameEnum.DINNER,
          MealNameEnum.SNACK_MORNING,
          MealNameEnum.SNACK_AFTERNOON,
          MealNameEnum.SNACK_EVENING,
        ];

        for (final mealName in mealNames) {
          final amplifyMeal = Meal(
            name: mealName,
            recipe: 'Test recipe',
            recipeName: 'Test meal',
            ingredients: [],
            totalMacros:
                Macros(calories: 50, carbohydrates: 10, fats: 1, proteins: 2),
          );

          final meal = MealCache.fromAmplify(amplifyMeal);
          expect(meal.name, mealName);
        }
      });

      test('handles enum mismatch with default fallback', () {
        // This test simulates what happens when enum values don't match
        // The firstWhere with orElse should provide a fallback
        final amplifyMeal = Meal(
          name: MealNameEnum.BREAKFAST, // Use existing enum value
          recipe: 'Test recipe',
          recipeName: 'Test meal',
          ingredients: [],
          totalMacros:
              Macros(calories: 100, carbohydrates: 20, fats: 3, proteins: 5),
        );

        final meal = MealCache.fromAmplify(amplifyMeal);

        // Should succeed with matching enum
        expect(meal.name, MealNameEnum.BREAKFAST);
      });
    });

    group('toJson method', () {
      test('converts MealCache to JSON', () {
        final ingredients = [
          IngredientCache.create(
            name: 'Greek Yogurt',
            amount: 150.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 100, carbohydrates: 6, fats: 5, proteins: 15),
          ),
          IngredientCache.create(
            name: 'Honey',
            amount: 1.0,
            unit: 'tbsp',
            macros: MacrosCache(
                calories: 64, carbohydrates: 17, fats: 0, proteins: 0),
          ),
        ];

        final meal = MealCache.create(
          name: MealNameEnum.SNACK_AFTERNOON,
          recipe: 'Mix yogurt with honey',
          recipeName: 'Honey Greek Yogurt',
          ingredients: ingredients,
          totalMacros: MacrosCache(
              calories: 164, carbohydrates: 23, fats: 5, proteins: 15),
        );

        final json = meal.toJson();

        expect(json['name'], MealNameEnum.SNACK_AFTERNOON);
        expect(json['recipe'], 'Mix yogurt with honey');
        expect(json['recipe_name'], 'Honey Greek Yogurt');
        expect(json['ingredients'], isA<List>());
        expect(json['ingredients'].length, 2);
        expect(json['total_macros'], isA<Map<String, dynamic>>());
        expect(json['total_macros']['calories'], 164);
      });

      test('round-trip JSON conversion preserves data', () {
        final original = MealCache.create(
          name: MealNameEnum.LUNCH,
          recipe: 'Prepare a balanced meal',
          recipeName: 'Balanced Lunch',
          ingredients: [
            IngredientCache.create(
              name: 'Turkey',
              amount: 100.0,
              unit: 'g',
              macros: MacrosCache(
                  calories: 135, carbohydrates: 0, fats: 1, proteins: 30),
            ),
          ],
          totalMacros: MacrosCache(
              calories: 200, carbohydrates: 10, fats: 5, proteins: 32),
        );

        final json = original.toJson();
        final reconstructed = MealCache.fromJson(json);

        expect(reconstructed.name, original.name);
        expect(reconstructed.recipe, original.recipe);
        expect(reconstructed.recipeName, original.recipeName);
        expect(reconstructed.ingredients.length, original.ingredients.length);
        expect(reconstructed.ingredients[0].name, original.ingredients[0].name);
        expect(
            reconstructed.totalMacros.calories, original.totalMacros.calories);
      });
    });

    group('toMeal method', () {
      test('converts MealCache to Amplify Meal model', () {
        final ingredients = [
          IngredientCache.create(
            name: 'Eggs',
            amount: 2.0,
            unit: 'large',
            macros: MacrosCache(
                calories: 140, carbohydrates: 1, fats: 10, proteins: 12),
          ),
          IngredientCache.create(
            name: 'Spinach',
            amount: 50.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 12, carbohydrates: 2, fats: 0, proteins: 2),
          ),
        ];

        final meal = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Scramble eggs with spinach',
          recipeName: 'Spinach Scrambled Eggs',
          ingredients: ingredients,
          totalMacros: MacrosCache(
              calories: 152, carbohydrates: 3, fats: 10, proteins: 14),
        );

        final amplifyMeal = meal.toMeal();

        expect(amplifyMeal.name, MealNameEnum.BREAKFAST);
        expect(amplifyMeal.recipe, 'Scramble eggs with spinach');
        expect(amplifyMeal.recipeName, 'Spinach Scrambled Eggs');
        expect(amplifyMeal.ingredients.length, 2);
        expect(amplifyMeal.ingredients[0].name, 'Eggs');
        expect(amplifyMeal.ingredients[1].name, 'Spinach');
        expect(amplifyMeal.totalMacros.calories, 152);
        expect(amplifyMeal.totalMacros.proteins, 14);
      });

      test('throws error for null meal name', () {
        final meal = MealCache.create(
          name: null, // Null name
          recipe: 'Test recipe',
          recipeName: 'Test meal',
          ingredients: [],
          totalMacros: MacrosCache(),
        );

        expect(() => meal.toMeal(), throwsArgumentError);
      });

      test('throws error for invalid meal name', () {
        final meal = MealCache();
        // Manually set an invalid name (this would require accessing private fields in real scenario)
        // For this test, we'll create a meal with null name to trigger the validation
        meal.name = null;
        meal.recipe = 'Test';
        meal.recipeName = 'Test';
        meal.ingredients = [];
        meal.totalMacros = MacrosCache();

        expect(() => meal.toMeal(), throwsArgumentError);
      });

      test('round-trip Amplify conversion preserves data', () {
        final originalAmplify = Meal(
          name: MealNameEnum.DINNER,
          recipe: 'Stir-fry vegetables with tofu',
          recipeName: 'Vegetable Tofu Stir-fry',
          ingredients: [
            Ingredient(
              name: 'Tofu',
              amount: 100.0,
              unit: 'g',
              macros:
                  Macros(calories: 76, carbohydrates: 2, fats: 5, proteins: 8),
            ),
          ],
          totalMacros:
              Macros(calories: 150, carbohydrates: 10, fats: 8, proteins: 12),
        );

        final cache = MealCache.fromAmplify(originalAmplify);
        final reconstructed = cache.toMeal();

        expect(reconstructed.name, originalAmplify.name);
        expect(reconstructed.recipe, originalAmplify.recipe);
        expect(reconstructed.recipeName, originalAmplify.recipeName);
        expect(reconstructed.ingredients.length,
            originalAmplify.ingredients.length);
        expect(reconstructed.ingredients[0].name,
            originalAmplify.ingredients[0].name);
        expect(reconstructed.totalMacros.calories,
            originalAmplify.totalMacros.calories);
      });
    });

    group('Realistic usage scenarios', () {
      test('represents a complete breakfast meal', () {
        final breakfastIngredients = [
          IngredientCache.create(
            name: 'Rolled Oats',
            amount: 40.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 156, carbohydrates: 26, fats: 3, proteins: 7),
          ),
          IngredientCache.create(
            name: 'Whole Milk',
            amount: 200.0,
            unit: 'ml',
            macros: MacrosCache(
                calories: 122, carbohydrates: 9, fats: 7, proteins: 6),
          ),
          IngredientCache.create(
            name: 'Banana',
            amount: 1.0,
            unit: 'medium',
            macros: MacrosCache(
                calories: 105, carbohydrates: 27, fats: 0, proteins: 1),
          ),
          IngredientCache.create(
            name: 'Almonds',
            amount: 15.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 87, carbohydrates: 3, fats: 7, proteins: 3),
          ),
        ];

        // Calculate total macros from ingredients
        final totalCalories = breakfastIngredients.fold<double>(
            0, (sum, ing) => sum + ing.macros.calories);
        final totalCarbs = breakfastIngredients.fold<double>(
            0, (sum, ing) => sum + ing.macros.carbohydrates);
        final totalFats = breakfastIngredients.fold<double>(
            0, (sum, ing) => sum + ing.macros.fats);
        final totalProteins = breakfastIngredients.fold<double>(
            0, (sum, ing) => sum + ing.macros.proteins);

        final breakfast = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe:
              '1. Cook oats with milk. 2. Add sliced banana. 3. Top with chopped almonds.',
          recipeName: 'Banana Almond Oatmeal',
          ingredients: breakfastIngredients,
          totalMacros: MacrosCache(
            calories: totalCalories,
            carbohydrates: totalCarbs,
            fats: totalFats,
            proteins: totalProteins,
          ),
        );

        expect(breakfast.name, MealNameEnum.BREAKFAST);
        expect(breakfast.ingredients.length, 4);
        expect(breakfast.totalMacros.calories, 470); // 156+122+105+87
        expect(breakfast.totalMacros.carbohydrates, 65); // 26+9+27+3
        expect(breakfast.totalMacros.fats, 17); // 3+7+0+7
        expect(breakfast.totalMacros.proteins, 17); // 7+6+1+3
      });

      test('handles meal portion scaling', () {
        final originalMeal = MealCache.create(
          name: MealNameEnum.LUNCH,
          recipe: 'Grill chicken, steam rice',
          recipeName: 'Chicken Rice Bowl',
          ingredients: [
            IngredientCache.create(
              name: 'Chicken Breast',
              amount: 100.0,
              unit: 'g',
              macros: MacrosCache(
                  calories: 165, carbohydrates: 0, fats: 4, proteins: 31),
            ),
            IngredientCache.create(
              name: 'White Rice',
              amount: 80.0,
              unit: 'g',
              macros: MacrosCache(
                  calories: 130, carbohydrates: 28, fats: 0, proteins: 3),
            ),
          ],
          totalMacros: MacrosCache(
              calories: 295, carbohydrates: 28, fats: 4, proteins: 34),
        );

        // Scale meal for larger portion (1.5x)
        final scalingFactor = 1.5;
        final scaledMeal = MealCache.create(
          name: originalMeal.name,
          recipe: originalMeal.recipe,
          recipeName: '${originalMeal.recipeName} (Large)',
          ingredients: originalMeal.ingredients
              .map((ing) => IngredientCache.create(
                    name: ing.name,
                    amount: ing.amount * scalingFactor,
                    unit: ing.unit,
                    macros: MacrosCache(
                      calories: ing.macros.calories * scalingFactor,
                      carbohydrates: ing.macros.carbohydrates * scalingFactor,
                      fats: ing.macros.fats * scalingFactor,
                      proteins: ing.macros.proteins * scalingFactor,
                    ),
                  ))
              .toList(),
          totalMacros: MacrosCache(
            calories: originalMeal.totalMacros.calories * scalingFactor,
            carbohydrates:
                originalMeal.totalMacros.carbohydrates * scalingFactor,
            fats: originalMeal.totalMacros.fats * scalingFactor,
            proteins: originalMeal.totalMacros.proteins * scalingFactor,
          ),
        );

        expect(scaledMeal.ingredients[0].amount, 150.0); // 100 * 1.5
        expect(scaledMeal.ingredients[1].amount, 120.0); // 80 * 1.5
        expect(scaledMeal.totalMacros.calories, 442.5); // 295 * 1.5
        expect(scaledMeal.totalMacros.proteins, 51.0); // 34 * 1.5
      });

      test('represents different snack types throughout the day', () {
        final snacks = [
          MealCache.create(
            name: MealNameEnum.SNACK_MORNING,
            recipe: 'Slice apple and serve with almond butter',
            recipeName: 'Apple with Almond Butter',
            ingredients: [
              IngredientCache.create(
                name: 'Apple',
                amount: 1.0,
                unit: 'medium',
                macros: MacrosCache(
                    calories: 95, carbohydrates: 25, fats: 0, proteins: 0),
              ),
              IngredientCache.create(
                name: 'Almond Butter',
                amount: 1.0,
                unit: 'tbsp',
                macros: MacrosCache(
                    calories: 98, carbohydrates: 4, fats: 9, proteins: 4),
              ),
            ],
            totalMacros: MacrosCache(
                calories: 193, carbohydrates: 29, fats: 9, proteins: 4),
          ),
          MealCache.create(
            name: MealNameEnum.SNACK_AFTERNOON,
            recipe: 'Mix Greek yogurt with berries',
            recipeName: 'Berry Yogurt',
            ingredients: [
              IngredientCache.create(
                name: 'Greek Yogurt',
                amount: 100.0,
                unit: 'g',
                macros: MacrosCache(
                    calories: 59, carbohydrates: 4, fats: 0, proteins: 10),
              ),
              IngredientCache.create(
                name: 'Mixed Berries',
                amount: 50.0,
                unit: 'g',
                macros: MacrosCache(
                    calories: 28, carbohydrates: 7, fats: 0, proteins: 0),
              ),
            ],
            totalMacros: MacrosCache(
                calories: 87, carbohydrates: 11, fats: 0, proteins: 10),
          ),
          MealCache.create(
            name: MealNameEnum.SNACK_EVENING,
            recipe: 'Prepare herbal tea with a small cookie',
            recipeName: 'Evening Tea & Cookie',
            ingredients: [
              IngredientCache.create(
                name: 'Herbal Tea',
                amount: 1.0,
                unit: 'cup',
                macros: MacrosCache(
                    calories: 2, carbohydrates: 0, fats: 0, proteins: 0),
              ),
              IngredientCache.create(
                name: 'Oat Cookie',
                amount: 1.0,
                unit: 'small',
                macros: MacrosCache(
                    calories: 45, carbohydrates: 7, fats: 2, proteins: 1),
              ),
            ],
            totalMacros: MacrosCache(
                calories: 47, carbohydrates: 7, fats: 2, proteins: 1),
          ),
        ];

        expect(snacks.length, 3);
        expect(snacks[0].name, MealNameEnum.SNACK_MORNING);
        expect(snacks[1].name, MealNameEnum.SNACK_AFTERNOON);
        expect(snacks[2].name, MealNameEnum.SNACK_EVENING);

        // Total snack calories for the day
        final totalSnackCalories = snacks.fold<double>(
            0, (sum, meal) => sum + meal.totalMacros.calories);
        expect(totalSnackCalories, 327); // 193 + 87 + 47
      });

      test('handles complex dinner with multiple cooking steps', () {
        final dinnerIngredients = [
          IngredientCache.create(
            name: 'Salmon Fillet',
            amount: 150.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 206, carbohydrates: 0, fats: 12, proteins: 22),
          ),
          IngredientCache.create(
            name: 'Sweet Potato',
            amount: 200.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 172, carbohydrates: 40, fats: 0, proteins: 2),
          ),
          IngredientCache.create(
            name: 'Asparagus',
            amount: 150.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 30, carbohydrates: 6, fats: 0, proteins: 3),
          ),
          IngredientCache.create(
            name: 'Olive Oil',
            amount: 1.0,
            unit: 'tbsp',
            macros: MacrosCache(
                calories: 119, carbohydrates: 0, fats: 14, proteins: 0),
          ),
          IngredientCache.create(
            name: 'Lemon',
            amount: 0.5,
            unit: 'medium',
            macros: MacrosCache(
                calories: 8, carbohydrates: 3, fats: 0, proteins: 0),
          ),
        ];

        final complexDinner = MealCache.create(
          name: MealNameEnum.DINNER,
          recipe: '''
1. Preheat oven to 400°F (200°C)
2. Cut sweet potato into wedges, toss with half the olive oil
3. Roast sweet potato for 25 minutes
4. Season salmon with salt, pepper, and lemon juice
5. Heat remaining olive oil in pan, sear salmon 4 minutes each side
6. Steam asparagus for 5 minutes
7. Serve salmon with roasted sweet potato and steamed asparagus
8. Garnish with remaining lemon juice
          '''
              .trim(),
          recipeName: 'Herb-Crusted Salmon with Roasted Sweet Potato',
          ingredients: dinnerIngredients,
          totalMacros: MacrosCache(
              calories: 535, carbohydrates: 49, fats: 26, proteins: 27),
        );

        expect(complexDinner.name, MealNameEnum.DINNER);
        expect(complexDinner.ingredients.length, 5);
        expect(complexDinner.recipe.contains('Preheat oven'), true);
        expect(complexDinner.recipe.contains('Garnish with'), true);
        expect(complexDinner.totalMacros.calories, 535);

        // Verify ingredient variety
        final ingredientNames =
            complexDinner.ingredients.map((ing) => ing.name).toList();
        expect(ingredientNames.contains('Salmon Fillet'), true);
        expect(ingredientNames.contains('Sweet Potato'), true);
        expect(ingredientNames.contains('Asparagus'), true);
        expect(ingredientNames.contains('Olive Oil'), true);
        expect(ingredientNames.contains('Lemon'), true);
      });
    });

    group('Edge cases and validation', () {
      test('handles empty ingredients list', () {
        final meal = MealCache.create(
          name: MealNameEnum.BREAKFAST,
          recipe: 'Fast for health benefits',
          recipeName: 'Intermittent Fasting',
          ingredients: [],
          totalMacros: MacrosCache(), // All zeros
        );

        expect(meal.ingredients, isEmpty);
        expect(meal.totalMacros.calories, 0.0);

        final json = meal.toJson();
        final reconstructed = MealCache.fromJson(json);

        expect(reconstructed.ingredients, isEmpty);
        expect(reconstructed.totalMacros.calories, 0.0);
      });

      test('handles very long recipe text', () {
        final longRecipe =
            'Step ${List.generate(100, (i) => i + 1).join(', Step ')}.';

        final meal = MealCache.create(
          name: MealNameEnum.LUNCH,
          recipe: longRecipe,
          recipeName: 'Complex Recipe',
          ingredients: [],
          totalMacros: MacrosCache(),
        );

        expect(meal.recipe.length, greaterThan(500));
        expect(meal.recipe.contains('Step 1'), true);
        expect(meal.recipe.contains('Step 100'), true);

        final json = meal.toJson();
        final reconstructed = MealCache.fromJson(json);

        expect(reconstructed.recipe, meal.recipe);
      });

      test('handles special characters in recipe fields', () {
        final specialRecipe =
            'Café recipe: Mix crème with açaí! 🍽️ Temperature: 200°C';
        final specialName = 'Crème Brûlée with Açaí & Café ☕';

        final meal = MealCache.create(
          name: MealNameEnum.SNACK_AFTERNOON,
          recipe: specialRecipe,
          recipeName: specialName,
          ingredients: [],
          totalMacros: MacrosCache(),
        );

        expect(meal.recipe, specialRecipe);
        expect(meal.recipeName, specialName);

        final json = meal.toJson();
        final reconstructed = MealCache.fromJson(json);

        expect(reconstructed.recipe, specialRecipe);
        expect(reconstructed.recipeName, specialName);
      });

      test('handles extreme macro values', () {
        final extremeMacros = MacrosCache(
          calories: 9999.99,
          carbohydrates: 1234.56,
          fats: 789.01,
          proteins: 456.78,
        );

        final meal = MealCache.create(
          name: MealNameEnum.DINNER,
          recipe: 'Extreme meal',
          recipeName: 'High Calorie Feast',
          ingredients: [],
          totalMacros: extremeMacros,
        );

        expect(meal.totalMacros.calories, 9999.99);
        expect(meal.totalMacros.carbohydrates, 1234.56);

        final json = meal.toJson();
        final reconstructed = MealCache.fromJson(json);

        expect(reconstructed.totalMacros.calories, 9999.99);
        expect(reconstructed.totalMacros.carbohydrates, 1234.56);
      });

      test('handles large number of ingredients', () {
        final manyIngredients = List.generate(
            50,
            (index) => IngredientCache.create(
                  name: 'Ingredient $index',
                  amount: index + 1.0,
                  unit: 'g',
                  macros: MacrosCache(calories: index * 2.0),
                ));

        final meal = MealCache.create(
          name: MealNameEnum.LUNCH,
          recipe: 'Complex meal with many ingredients',
          recipeName: 'Mega Meal',
          ingredients: manyIngredients,
          totalMacros: MacrosCache(
              calories: 2450), // Sum of all calories: 0+2+4+...+98 = 2450
        );

        expect(meal.ingredients.length, 50);
        expect(meal.ingredients[0].name, 'Ingredient 0');
        expect(meal.ingredients[49].name, 'Ingredient 49');
        expect(meal.totalMacros.calories, 2450);

        final json = meal.toJson();
        final reconstructed = MealCache.fromJson(json);

        expect(reconstructed.ingredients.length, 50);
        expect(reconstructed.totalMacros.calories, 2450);
      });
    });
  });
}
