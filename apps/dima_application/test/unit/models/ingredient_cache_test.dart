import 'package:dima_application/generated/flutter-models/Ingredient.dart';
import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IngredientCache', () {
    group('Constructor and initialization', () {
      test('creates IngredientCache with default constructor', () {
        final ingredient = IngredientCache();

        // Default constructor should create an object that can be initialized later
        expect(ingredient, isA<IngredientCache>());
      });

      test('creates IngredientCache with create constructor', () {
        final macros = MacrosCache(
          calories: 150.0,
          carbohydrates: 20.0,
          fats: 5.0,
          proteins: 8.0,
        );

        final ingredient = IngredientCache.create(
          name: 'Chicken Breast',
          amount: 200.0,
          unit: 'g',
          macros: macros,
        );

        expect(ingredient.name, 'Chicken Breast');
        expect(ingredient.amount, 200.0);
        expect(ingredient.unit, 'g');
        expect(ingredient.macros.calories, 150.0);
        expect(ingredient.macros.carbohydrates, 20.0);
        expect(ingredient.macros.fats, 5.0);
        expect(ingredient.macros.proteins, 8.0);
      });

      test('creates IngredientCache with different units', () {
        final macros = MacrosCache(
            calories: 80.0, carbohydrates: 12.0, fats: 2.0, proteins: 4.0);

        final cupIngredient = IngredientCache.create(
          name: 'Rice',
          amount: 1.0,
          unit: 'cup',
          macros: macros,
        );

        final tablespoonIngredient = IngredientCache.create(
          name: 'Olive Oil',
          amount: 2.0,
          unit: 'tbsp',
          macros: macros,
        );

        expect(cupIngredient.unit, 'cup');
        expect(tablespoonIngredient.unit, 'tbsp');
      });
    });

    group('Factory constructor fromJson', () {
      test('creates IngredientCache from complete JSON', () {
        final json = {
          'name': 'Salmon Fillet',
          'amount': 150.0,
          'unit': 'g',
          'macros': {
            'calories': 200.0,
            'carbohydrates': 0.0,
            'fats': 12.0,
            'proteins': 22.0,
          },
        };

        final ingredient = IngredientCache.fromJson(json);

        expect(ingredient.name, 'Salmon Fillet');
        expect(ingredient.amount, 150.0);
        expect(ingredient.unit, 'g');
        expect(ingredient.macros.calories, 200.0);
        expect(ingredient.macros.carbohydrates, 0.0);
        expect(ingredient.macros.fats, 12.0);
        expect(ingredient.macros.proteins, 22.0);
      });

      test('creates IngredientCache from minimal JSON with defaults', () {
        final json = {
          'name': 'Apple',
        };

        final ingredient = IngredientCache.fromJson(json);

        expect(ingredient.name, 'Apple');
        expect(ingredient.amount, 0.0); // Default from _toDouble
        expect(ingredient.unit, 'g'); // Default unit
        expect(ingredient.macros.calories, 0.0); // Default from empty macros
        expect(ingredient.macros.carbohydrates, 0.0);
        expect(ingredient.macros.fats, 0.0);
        expect(ingredient.macros.proteins, 0.0);
      });

      test('handles missing name with default', () {
        final json = {
          'amount': 100.0,
          'unit': 'g',
        };

        final ingredient = IngredientCache.fromJson(json);

        expect(ingredient.name, 'Unknown Ingredient');
        expect(ingredient.amount, 100.0);
        expect(ingredient.unit, 'g');
      });

      test('handles missing unit with default', () {
        final json = {
          'name': 'Banana',
          'amount': 120.0,
        };

        final ingredient = IngredientCache.fromJson(json);

        expect(ingredient.name, 'Banana');
        expect(ingredient.amount, 120.0);
        expect(ingredient.unit, 'g'); // Default unit
      });

      test('handles missing macros with empty object', () {
        final json = {
          'name': 'Water',
          'amount': 500.0,
          'unit': 'ml',
        };

        final ingredient = IngredientCache.fromJson(json);

        expect(ingredient.name, 'Water');
        expect(ingredient.amount, 500.0);
        expect(ingredient.unit, 'ml');
        expect(ingredient.macros.calories, 0.0);
        expect(ingredient.macros.carbohydrates, 0.0);
        expect(ingredient.macros.fats, 0.0);
        expect(ingredient.macros.proteins, 0.0);
      });

      test('handles various amount data types', () {
        final testCases = [
          {'amount': 100, 'expected': 100.0}, // int
          {'amount': 150.5, 'expected': 150.5}, // double
          {'amount': '200.0', 'expected': 200.0}, // string number
          {'amount': '75.25', 'expected': 75.25}, // string decimal
          {'amount': 'invalid', 'expected': 0.0}, // invalid string
          {'amount': null, 'expected': 0.0}, // null
          {'amount': [], 'expected': 0.0}, // array
          {'amount': {}, 'expected': 0.0}, // object
        ];

        for (final testCase in testCases) {
          final json = {
            'name': 'Test Ingredient',
            'amount': testCase['amount'],
            'unit': 'g',
          };

          final ingredient = IngredientCache.fromJson(json);
          expect(ingredient.amount, testCase['expected'],
              reason:
                  'Amount ${testCase['amount']} should become ${testCase['expected']}');
        }
      });
    });

    group('Factory constructor fromAmplify', () {
      test('creates IngredientCache from Amplify Ingredient model', () {
        final amplifyMacros = Macros(
          calories: 180.0,
          carbohydrates: 15.0,
          fats: 8.0,
          proteins: 12.0,
        );

        final amplifyIngredient = Ingredient(
          name: 'Avocado',
          amount: 100.0,
          unit: 'g',
          macros: amplifyMacros,
        );

        final ingredient = IngredientCache.fromAmplify(amplifyIngredient);

        expect(ingredient.name, 'Avocado');
        expect(ingredient.amount, 100.0);
        expect(ingredient.unit, 'g');
        expect(ingredient.macros.calories, 180.0);
        expect(ingredient.macros.carbohydrates, 15.0);
        expect(ingredient.macros.fats, 8.0);
        expect(ingredient.macros.proteins, 12.0);
      });

      test('handles null unit with default', () {
        final amplifyMacros = Macros(
            calories: 50.0, carbohydrates: 12.0, fats: 0.0, proteins: 1.0);

        final amplifyIngredient = Ingredient(
          name: 'Lettuce',
          amount: 50.0,
          unit: null, // Null unit
          macros: amplifyMacros,
        );

        final ingredient = IngredientCache.fromAmplify(amplifyIngredient);

        expect(ingredient.name, 'Lettuce');
        expect(ingredient.amount, 50.0);
        expect(ingredient.unit, 'g'); // Default unit applied
        expect(ingredient.macros.calories, 50.0);
      });

      test('preserves all Amplify data correctly', () {
        final amplifyMacros = Macros(
          calories: 250.75,
          carbohydrates: 35.25,
          fats: 10.5,
          proteins: 18.0,
        );

        final amplifyIngredient = Ingredient(
          name: 'Quinoa',
          amount: 85.5,
          unit: 'cup',
          macros: amplifyMacros,
        );

        final ingredient = IngredientCache.fromAmplify(amplifyIngredient);

        expect(ingredient.name, 'Quinoa');
        expect(ingredient.amount, 85.5);
        expect(ingredient.unit, 'cup');
        expect(ingredient.macros.calories, 250.75);
        expect(ingredient.macros.carbohydrates, 35.25);
        expect(ingredient.macros.fats, 10.5);
        expect(ingredient.macros.proteins, 18.0);
      });
    });

    group('toJson method', () {
      test('converts IngredientCache to JSON', () {
        final macros = MacrosCache(
          calories: 120.0,
          carbohydrates: 25.0,
          fats: 2.0,
          proteins: 6.0,
        );

        final ingredient = IngredientCache.create(
          name: 'Sweet Potato',
          amount: 200.0,
          unit: 'g',
          macros: macros,
        );

        final json = ingredient.toJson();

        expect(json['name'], 'Sweet Potato');
        expect(json['amount'], 200.0);
        expect(json['unit'], 'g');
        expect(json['macros'], isA<Map<String, dynamic>>());
        expect(json['macros']['calories'], 120.0);
        expect(json['macros']['carbohydrates'], 25.0);
        expect(json['macros']['fats'], 2.0);
        expect(json['macros']['proteins'], 6.0);
      });

      test('round-trip JSON conversion preserves data', () {
        final original = IngredientCache.create(
          name: 'Blueberries',
          amount: 75.5,
          unit: 'cup',
          macros: MacrosCache(
            calories: 42.5,
            carbohydrates: 10.8,
            fats: 0.2,
            proteins: 0.6,
          ),
        );

        final json = original.toJson();
        final reconstructed = IngredientCache.fromJson(json);

        expect(reconstructed.name, original.name);
        expect(reconstructed.amount, original.amount);
        expect(reconstructed.unit, original.unit);
        expect(reconstructed.macros.calories, original.macros.calories);
        expect(
            reconstructed.macros.carbohydrates, original.macros.carbohydrates);
        expect(reconstructed.macros.fats, original.macros.fats);
        expect(reconstructed.macros.proteins, original.macros.proteins);
      });
    });

    group('toIngredient method', () {
      test('converts IngredientCache to Amplify Ingredient model', () {
        final macros = MacrosCache(
          calories: 300.0,
          carbohydrates: 40.0,
          fats: 15.0,
          proteins: 20.0,
        );

        final ingredient = IngredientCache.create(
          name: 'Whole Wheat Bread',
          amount: 2.0,
          unit: 'slice',
          macros: macros,
        );

        final amplifyIngredient = ingredient.toIngredient();

        expect(amplifyIngredient.name, 'Whole Wheat Bread');
        expect(amplifyIngredient.amount, 2.0);
        expect(amplifyIngredient.unit, 'slice');
        expect(amplifyIngredient.macros.calories, 300.0);
        expect(amplifyIngredient.macros.carbohydrates, 40.0);
        expect(amplifyIngredient.macros.fats, 15.0);
        expect(amplifyIngredient.macros.proteins, 20.0);
      });

      test('round-trip Amplify conversion preserves data', () {
        final originalAmplify = Ingredient(
          name: 'Greek Yogurt',
          amount: 170.0,
          unit: 'g',
          macros: Macros(
            calories: 130.0,
            carbohydrates: 9.0,
            fats: 7.0,
            proteins: 15.0,
          ),
        );

        final cache = IngredientCache.fromAmplify(originalAmplify);
        final reconstructed = cache.toIngredient();

        expect(reconstructed.name, originalAmplify.name);
        expect(reconstructed.amount, originalAmplify.amount);
        expect(reconstructed.unit, originalAmplify.unit);
        expect(reconstructed.macros.calories, originalAmplify.macros.calories);
        expect(reconstructed.macros.carbohydrates,
            originalAmplify.macros.carbohydrates);
        expect(reconstructed.macros.fats, originalAmplify.macros.fats);
        expect(reconstructed.macros.proteins, originalAmplify.macros.proteins);
      });
    });

    group('_toDouble helper function', () {
      test('converts various numeric types to double', () {
        // Test through the fromJson method which uses _toDouble
        final testCases = [
          {'input': 42, 'expected': 42.0},
          {'input': 3.14, 'expected': 3.14},
          {'input': '123', 'expected': 123.0},
          {'input': '45.67', 'expected': 45.67},
          {'input': '0', 'expected': 0.0},
          {'input': '-10.5', 'expected': -10.5},
        ];

        for (final testCase in testCases) {
          final json = {
            'name': 'Test',
            'amount': testCase['input'],
            'unit': 'g',
          };

          final ingredient = IngredientCache.fromJson(json);
          expect(ingredient.amount, testCase['expected'],
              reason:
                  'Input ${testCase['input']} should convert to ${testCase['expected']}');
        }
      });

      test('handles invalid input gracefully', () {
        final invalidInputs = [
          'not a number',
          'abc123',
          '',
          '  ',
          null,
          [],
          {},
          true,
          false,
        ];

        for (final input in invalidInputs) {
          final json = {
            'name': 'Test',
            'amount': input,
            'unit': 'g',
          };

          final ingredient = IngredientCache.fromJson(json);
          expect(ingredient.amount, 0.0,
              reason: 'Invalid input $input should default to 0.0');
        }
      });
    });

    group('Realistic usage scenarios', () {
      test('represents common cooking ingredients', () {
        final ingredients = [
          IngredientCache.create(
            name: 'Chicken Breast',
            amount: 150.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 165, carbohydrates: 0, fats: 3.6, proteins: 31),
          ),
          IngredientCache.create(
            name: 'Brown Rice',
            amount: 1.0,
            unit: 'cup',
            macros: MacrosCache(
                calories: 216, carbohydrates: 45, fats: 1.8, proteins: 5),
          ),
          IngredientCache.create(
            name: 'Broccoli',
            amount: 100.0,
            unit: 'g',
            macros: MacrosCache(
                calories: 34, carbohydrates: 7, fats: 0.4, proteins: 2.8),
          ),
          IngredientCache.create(
            name: 'Olive Oil',
            amount: 1.0,
            unit: 'tbsp',
            macros: MacrosCache(
                calories: 119, carbohydrates: 0, fats: 13.5, proteins: 0),
          ),
        ];

        // Test serialization of recipe ingredients
        final jsonList = ingredients.map((ing) => ing.toJson()).toList();
        expect(jsonList.length, 4);

        // Test deserialization
        final reconstructed =
            jsonList.map((json) => IngredientCache.fromJson(json)).toList();
        expect(reconstructed.length, 4);
        expect(reconstructed[0].name, 'Chicken Breast');
        expect(reconstructed[1].unit, 'cup');
        expect(reconstructed[2].macros.calories, 34);
        expect(reconstructed[3].macros.fats, 13.5);
      });

      test('handles recipe scaling', () {
        final originalIngredient = IngredientCache.create(
          name: 'All-Purpose Flour',
          amount: 2.0,
          unit: 'cups',
          macros: MacrosCache(
              calories: 455, carbohydrates: 95, fats: 1.2, proteins: 13),
        );

        // Scale recipe from 4 servings to 6 servings (multiply by 1.5)
        final scalingFactor = 1.5;
        final scaledIngredient = IngredientCache.create(
          name: originalIngredient.name,
          amount: originalIngredient.amount * scalingFactor,
          unit: originalIngredient.unit,
          macros: MacrosCache(
            calories: originalIngredient.macros.calories * scalingFactor,
            carbohydrates:
                originalIngredient.macros.carbohydrates * scalingFactor,
            fats: originalIngredient.macros.fats * scalingFactor,
            proteins: originalIngredient.macros.proteins * scalingFactor,
          ),
        );

        expect(scaledIngredient.amount, 3.0); // 2.0 * 1.5
        expect(scaledIngredient.macros.calories, 682.5); // 455 * 1.5
        expect(scaledIngredient.macros.carbohydrates, 142.5); // 95 * 1.5
        expect(scaledIngredient.macros.fats, closeTo(1.8, 1e-9)); // 1.2 * 1.5
        expect(scaledIngredient.macros.proteins, 19.5); // 13 * 1.5
      });

      test('handles ingredient substitution scenarios', () {
        // Original ingredient
        final butter = IngredientCache.create(
          name: 'Butter',
          amount: 50.0,
          unit: 'g',
          macros: MacrosCache(
              calories: 357, carbohydrates: 0.1, fats: 40, proteins: 0.4),
        );

        // Healthier substitute with same amount
        final coconutOil = IngredientCache.create(
          name: 'Coconut Oil',
          amount: butter.amount, // Same amount
          unit: butter.unit,
          macros: MacrosCache(
              calories: 354, carbohydrates: 0, fats: 39.2, proteins: 0),
        );

        // Calculate nutritional difference
        final calorieDiff = coconutOil.macros.calories - butter.macros.calories;
        final fatDiff = coconutOil.macros.fats - butter.macros.fats;

        expect(calorieDiff, -3.0); // 3 fewer calories
        expect(fatDiff, closeTo(-0.8, 1e-9)); // 0.8g less fat
        expect(coconutOil.amount, butter.amount); // Same quantity
      });
    });

    group('Edge cases and validation', () {
      test('handles extreme amounts', () {
        final extremeIngredients = [
          IngredientCache.create(
            name: 'Tiny Amount',
            amount: 0.001,
            unit: 'g',
            macros: MacrosCache(calories: 0.001),
          ),
          IngredientCache.create(
            name: 'Large Amount',
            amount: 10000.0,
            unit: 'kg',
            macros: MacrosCache(calories: 50000),
          ),
          IngredientCache.create(
            name: 'Zero Amount',
            amount: 0.0,
            unit: 'g',
            macros: MacrosCache(),
          ),
        ];

        for (final ingredient in extremeIngredients) {
          final json = ingredient.toJson();
          final reconstructed = IngredientCache.fromJson(json);

          expect(reconstructed.amount, ingredient.amount);
          expect(reconstructed.macros.calories, ingredient.macros.calories);
        }
      });

      test('handles special characters in names', () {
        final specialNames = [
          'Café au Lait',
          'Jalapeño Peppers',
          'Crème Brûlée',
          'Açaí Berries',
          'Süßkartoffeln',
          '🥑 Avocado 🥑',
          'Ingredient with "quotes" and symbols!@#\$%',
        ];

        for (final name in specialNames) {
          final ingredient = IngredientCache.create(
            name: name,
            amount: 100.0,
            unit: 'g',
            macros: MacrosCache(calories: 50),
          );

          final json = ingredient.toJson();
          final reconstructed = IngredientCache.fromJson(json);

          expect(reconstructed.name, name);
        }
      });

      test('handles unusual units', () {
        final unusualUnits = [
          'pinch',
          'dash',
          'handful',
          'piece',
          'slice',
          'can (14 oz)',
          'package (500g)',
          'bottle',
          '',
          'μg', // Unicode
        ];

        for (final unit in unusualUnits) {
          final ingredient = IngredientCache.create(
            name: 'Test Ingredient',
            amount: 1.0,
            unit: unit,
            macros: MacrosCache(calories: 10),
          );

          final json = ingredient.toJson();
          final reconstructed = IngredientCache.fromJson(json);

          expect(reconstructed.unit, unit);
        }
      });

      test('handles negative amounts', () {
        final negativeIngredient = IngredientCache.create(
          name: 'Negative Test',
          amount: -50.0,
          unit: 'g',
          macros: MacrosCache(calories: -25),
        );

        expect(negativeIngredient.amount, -50.0);
        expect(negativeIngredient.macros.calories, -25.0);

        final json = negativeIngredient.toJson();
        final reconstructed = IngredientCache.fromJson(json);

        expect(reconstructed.amount, -50.0);
        expect(reconstructed.macros.calories, -25.0);
      });

      test('handles very long ingredient names', () {
        final longName = 'A' * 1000; // 1000 character name

        final ingredient = IngredientCache.create(
          name: longName,
          amount: 100.0,
          unit: 'g',
          macros: MacrosCache(calories: 100),
        );

        expect(ingredient.name.length, 1000);

        final json = ingredient.toJson();
        final reconstructed = IngredientCache.fromJson(json);

        expect(reconstructed.name, longName);
        expect(reconstructed.name.length, 1000);
      });

      test('handles precision edge cases', () {
        final precisionIngredient = IngredientCache.create(
          name: 'Precision Test',
          amount: 123.456789,
          unit: 'g',
          macros: MacrosCache(
            calories: 987.654321,
            carbohydrates: 12.3456789,
            fats: 0.123456789,
            proteins: 45.6789012,
          ),
        );

        final json = precisionIngredient.toJson();
        final reconstructed = IngredientCache.fromJson(json);

        expect(reconstructed.amount, 123.456789);
        expect(reconstructed.macros.calories, 987.654321);
        expect(reconstructed.macros.carbohydrates, 12.3456789);
        expect(reconstructed.macros.fats, 0.123456789);
        expect(reconstructed.macros.proteins, 45.6789012);
      });
    });
  });
}
