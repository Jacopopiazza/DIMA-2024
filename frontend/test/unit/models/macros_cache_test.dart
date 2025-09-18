import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MacrosCache', () {
    group('Constructor and initialization', () {
      test('creates MacrosCache with default values', () {
        final macros = MacrosCache();

        expect(macros.calories, 0.0);
        expect(macros.carbohydrates, 0.0);
        expect(macros.fats, 0.0);
        expect(macros.proteins, 0.0);
      });

      test('creates MacrosCache with specified values', () {
        final macros = MacrosCache(
          calories: 250.0,
          carbohydrates: 30.0,
          fats: 10.0,
          proteins: 15.0,
        );

        expect(macros.calories, 250.0);
        expect(macros.carbohydrates, 30.0);
        expect(macros.fats, 10.0);
        expect(macros.proteins, 15.0);
      });

      test('creates MacrosCache with partial values', () {
        final macros = MacrosCache(
          calories: 100.0,
          proteins: 20.0,
        );

        expect(macros.calories, 100.0);
        expect(macros.carbohydrates, 0.0); // Default
        expect(macros.fats, 0.0); // Default
        expect(macros.proteins, 20.0);
      });
    });

    group('Factory constructor fromJson', () {
      test('creates MacrosCache from complete JSON', () {
        final json = {
          'calories': 300.5,
          'carbohydrates': 45.2,
          'fats': 12.8,
          'proteins': 25.1,
        };

        final macros = MacrosCache.fromJson(json);

        expect(macros.calories, 300.5);
        expect(macros.carbohydrates, 45.2);
        expect(macros.fats, 12.8);
        expect(macros.proteins, 25.1);
      });

      test('creates MacrosCache from partial JSON with defaults', () {
        final json = {
          'calories': 150.0,
          'proteins': 10.0,
        };

        final macros = MacrosCache.fromJson(json);

        expect(macros.calories, 150.0);
        expect(macros.carbohydrates, 0.0); // Default
        expect(macros.fats, 0.0); // Default
        expect(macros.proteins, 10.0);
      });

      test('creates MacrosCache from empty JSON with all defaults', () {
        final json = <String, dynamic>{};

        final macros = MacrosCache.fromJson(json);

        expect(macros.calories, 0.0);
        expect(macros.carbohydrates, 0.0);
        expect(macros.fats, 0.0);
        expect(macros.proteins, 0.0);
      });

      test('handles integer values in JSON', () {
        final json = {
          'calories': 200,
          'carbohydrates': 25,
          'fats': 8,
          'proteins': 15,
        };

        final macros = MacrosCache.fromJson(json);

        expect(macros.calories, 200.0);
        expect(macros.carbohydrates, 25.0);
        expect(macros.fats, 8.0);
        expect(macros.proteins, 15.0);
      });

      test('handles null values in JSON', () {
        final json = {
          'calories': null,
          'carbohydrates': 30.0,
          'fats': null,
          'proteins': 20.0,
        };

        final macros = MacrosCache.fromJson(json);

        expect(macros.calories, 0.0); // Null becomes default
        expect(macros.carbohydrates, 30.0);
        expect(macros.fats, 0.0); // Null becomes default
        expect(macros.proteins, 20.0);
      });

      test('throws on invalid value types', () {
        final json = {
          'calories': 'invalid',
          'carbohydrates': 25.0,
          'fats': [],
          'proteins': {'nested': 'object'},
        };

        expect(() => MacrosCache.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('Factory constructor fromAmplify', () {
      test('creates MacrosCache from Amplify Macros model', () {
        final amplifyMacros = Macros(
          calories: 350.0,
          carbohydrates: 40.0,
          fats: 15.0,
          proteins: 30.0,
        );

        final macros = MacrosCache.fromAmplify(amplifyMacros);

        expect(macros.calories, 350.0);
        expect(macros.carbohydrates, 40.0);
        expect(macros.fats, 15.0);
        expect(macros.proteins, 30.0);
      });

      test('creates MacrosCache from Amplify Macros with zero values', () {
        final amplifyMacros = Macros(
          calories: 0.0,
          carbohydrates: 0.0,
          fats: 0.0,
          proteins: 0.0,
        );

        final macros = MacrosCache.fromAmplify(amplifyMacros);

        expect(macros.calories, 0.0);
        expect(macros.carbohydrates, 0.0);
        expect(macros.fats, 0.0);
        expect(macros.proteins, 0.0);
      });
    });

    group('toJson method', () {
      test('converts MacrosCache to JSON', () {
        final macros = MacrosCache(
          calories: 280.5,
          carbohydrates: 35.2,
          fats: 11.8,
          proteins: 22.1,
        );

        final json = macros.toJson();

        expect(json['calories'], 280.5);
        expect(json['carbohydrates'], 35.2);
        expect(json['fats'], 11.8);
        expect(json['proteins'], 22.1);
      });

      test('converts MacrosCache with zero values to JSON', () {
        final macros = MacrosCache();

        final json = macros.toJson();

        expect(json['calories'], 0.0);
        expect(json['carbohydrates'], 0.0);
        expect(json['fats'], 0.0);
        expect(json['proteins'], 0.0);
      });

      test('round-trip JSON conversion preserves data', () {
        final original = MacrosCache(
          calories: 125.75,
          carbohydrates: 18.25,
          fats: 6.5,
          proteins: 12.0,
        );

        final json = original.toJson();
        final reconstructed = MacrosCache.fromJson(json);

        expect(reconstructed.calories, original.calories);
        expect(reconstructed.carbohydrates, original.carbohydrates);
        expect(reconstructed.fats, original.fats);
        expect(reconstructed.proteins, original.proteins);
      });
    });

    group('toMacros method', () {
      test('converts MacrosCache to Amplify Macros model', () {
        final macros = MacrosCache(
          calories: 400.0,
          carbohydrates: 50.0,
          fats: 18.0,
          proteins: 35.0,
        );

        final amplifyMacros = macros.toMacros();

        expect(amplifyMacros.calories, 400.0);
        expect(amplifyMacros.carbohydrates, 50.0);
        expect(amplifyMacros.fats, 18.0);
        expect(amplifyMacros.proteins, 35.0);
      });

      test('round-trip Amplify conversion preserves data', () {
        final original = Macros(
          calories: 175.5,
          carbohydrates: 22.0,
          fats: 7.5,
          proteins: 14.0,
        );

        final cache = MacrosCache.fromAmplify(original);
        final reconstructed = cache.toMacros();

        expect(reconstructed.calories, original.calories);
        expect(reconstructed.carbohydrates, original.carbohydrates);
        expect(reconstructed.fats, original.fats);
        expect(reconstructed.proteins, original.proteins);
      });
    });

    group('Addition operator (+)', () {
      test('adds two MacrosCache objects correctly', () {
        final macros1 = MacrosCache(
          calories: 100.0,
          carbohydrates: 15.0,
          fats: 5.0,
          proteins: 8.0,
        );

        final macros2 = MacrosCache(
          calories: 200.0,
          carbohydrates: 25.0,
          fats: 10.0,
          proteins: 12.0,
        );

        final result = macros1 + macros2;

        expect(result.calories, 300.0);
        expect(result.carbohydrates, 40.0);
        expect(result.fats, 15.0);
        expect(result.proteins, 20.0);
      });

      test('adds MacrosCache with zero values', () {
        final macros1 = MacrosCache(
          calories: 150.0,
          carbohydrates: 20.0,
          fats: 6.0,
          proteins: 10.0,
        );

        final macros2 = MacrosCache(); // All zeros

        final result = macros1 + macros2;

        expect(result.calories, 150.0);
        expect(result.carbohydrates, 20.0);
        expect(result.fats, 6.0);
        expect(result.proteins, 10.0);
      });

      test('addition is commutative', () {
        final macros1 = MacrosCache(
          calories: 75.5,
          carbohydrates: 10.2,
          fats: 3.8,
          proteins: 6.5,
        );

        final macros2 = MacrosCache(
          calories: 124.5,
          carbohydrates: 15.8,
          fats: 7.2,
          proteins: 9.5,
        );

        final result1 = macros1 + macros2;
        final result2 = macros2 + macros1;

        expect(result1.calories, result2.calories);
        expect(result1.carbohydrates, result2.carbohydrates);
        expect(result1.fats, result2.fats);
        expect(result1.proteins, result2.proteins);
      });

      test('addition is associative', () {
        final macros1 = MacrosCache(
            calories: 50.0, carbohydrates: 5.0, fats: 2.0, proteins: 3.0);
        final macros2 = MacrosCache(
            calories: 100.0, carbohydrates: 10.0, fats: 4.0, proteins: 6.0);
        final macros3 = MacrosCache(
            calories: 75.0, carbohydrates: 8.0, fats: 3.0, proteins: 5.0);

        final result1 = (macros1 + macros2) + macros3;
        final result2 = macros1 + (macros2 + macros3);

        expect(result1.calories, result2.calories);
        expect(result1.carbohydrates, result2.carbohydrates);
        expect(result1.fats, result2.fats);
        expect(result1.proteins, result2.proteins);
      });

      test('handles decimal addition correctly', () {
        final macros1 = MacrosCache(
          calories: 123.45,
          carbohydrates: 16.78,
          fats: 5.23,
          proteins: 9.87,
        );

        final macros2 = MacrosCache(
          calories: 87.65,
          carbohydrates: 12.34,
          fats: 3.77,
          proteins: 7.13,
        );

        final result = macros1 + macros2;

        expect(result.calories, closeTo(211.1, 0.001));
        expect(result.carbohydrates, closeTo(29.12, 0.001));
        expect(result.fats, closeTo(9.0, 0.001));
        expect(result.proteins, closeTo(17.0, 0.001));
      });
    });

    group('percentageOf method', () {
      test('calculates correct percentages for all fields', () {
        final current = MacrosCache(
          calories: 150.0,
          carbohydrates: 20.0,
          fats: 8.0,
          proteins: 12.0,
        );

        final total = MacrosCache(
          calories: 300.0,
          carbohydrates: 40.0,
          fats: 16.0,
          proteins: 24.0,
        );

        final percentage = current.percentageOf(total);

        expect(percentage.calories, 0.5); // 150/300
        expect(percentage.carbohydrates, 0.5); // 20/40
        expect(percentage.fats, 0.5); // 8/16
        expect(percentage.proteins, 0.5); // 12/24
      });

      test('handles zero total values without division by zero', () {
        final current = MacrosCache(
          calories: 100.0,
          carbohydrates: 15.0,
          fats: 5.0,
          proteins: 10.0,
        );

        final total = MacrosCache(); // All zeros

        final percentage = current.percentageOf(total);

        expect(percentage.calories, 0.0);
        expect(percentage.carbohydrates, 0.0);
        expect(percentage.fats, 0.0);
        expect(percentage.proteins, 0.0);
      });

      test('handles partial zero total values', () {
        final current = MacrosCache(
          calories: 200.0,
          carbohydrates: 25.0,
          fats: 10.0,
          proteins: 15.0,
        );

        final total = MacrosCache(
          calories: 400.0,
          carbohydrates: 0.0, // Zero
          fats: 20.0,
          proteins: 0.0, // Zero
        );

        final percentage = current.percentageOf(total);

        expect(percentage.calories, 0.5); // 200/400
        expect(percentage.carbohydrates, 0.0); // Division by zero handled
        expect(percentage.fats, 0.5); // 10/20
        expect(percentage.proteins, 0.0); // Division by zero handled
      });

      test('calculates percentage greater than 1.0', () {
        final current = MacrosCache(
          calories: 300.0,
          carbohydrates: 40.0,
          fats: 15.0,
          proteins: 25.0,
        );

        final total = MacrosCache(
          calories: 200.0,
          carbohydrates: 30.0,
          fats: 10.0,
          proteins: 20.0,
        );

        final percentage = current.percentageOf(total);

        expect(percentage.calories, 1.5); // 300/200
        expect(percentage.carbohydrates, closeTo(1.333, 0.001)); // 40/30
        expect(percentage.fats, 1.5); // 15/10
        expect(percentage.proteins, 1.25); // 25/20
      });

      test('handles decimal calculations accurately', () {
        final current = MacrosCache(
          calories: 123.45,
          carbohydrates: 16.78,
          fats: 5.23,
          proteins: 9.87,
        );

        final total = MacrosCache(
          calories: 246.9,
          carbohydrates: 33.56,
          fats: 10.46,
          proteins: 19.74,
        );

        final percentage = current.percentageOf(total);

        expect(percentage.calories, closeTo(0.5, 0.001));
        expect(percentage.carbohydrates, closeTo(0.5, 0.001));
        expect(percentage.fats, closeTo(0.5, 0.001));
        expect(percentage.proteins, closeTo(0.5, 0.001));
      });

      test('handles zero current values', () {
        final current = MacrosCache(); // All zeros

        final total = MacrosCache(
          calories: 300.0,
          carbohydrates: 40.0,
          fats: 15.0,
          proteins: 25.0,
        );

        final percentage = current.percentageOf(total);

        expect(percentage.calories, 0.0);
        expect(percentage.carbohydrates, 0.0);
        expect(percentage.fats, 0.0);
        expect(percentage.proteins, 0.0);
      });
    });

    group('Realistic usage scenarios', () {
      test('calculates daily nutritional progress', () {
        // Daily targets
        final dailyTargets = MacrosCache(
          calories: 2000.0,
          carbohydrates: 250.0,
          fats: 67.0,
          proteins: 150.0,
        );

        // Breakfast
        final breakfast = MacrosCache(
          calories: 350.0,
          carbohydrates: 45.0,
          fats: 12.0,
          proteins: 25.0,
        );

        // Lunch
        final lunch = MacrosCache(
          calories: 500.0,
          carbohydrates: 60.0,
          fats: 20.0,
          proteins: 35.0,
        );

        // Current progress
        final currentProgress = breakfast + lunch;
        expect(currentProgress.calories, 850.0);
        expect(currentProgress.carbohydrates, 105.0);
        expect(currentProgress.fats, 32.0);
        expect(currentProgress.proteins, 60.0);

        // Percentage of daily targets achieved
        final progressPercentage = currentProgress.percentageOf(dailyTargets);
        expect(progressPercentage.calories, 0.425); // 42.5%
        expect(progressPercentage.carbohydrates, 0.42); // 42%
        expect(progressPercentage.fats, closeTo(0.478, 0.001)); // ~47.8%
        expect(progressPercentage.proteins, 0.4); // 40%
      });

      test('sums weekly meal plan macros', () {
        final dailyMacros = List.generate(
            7,
            (index) => MacrosCache(
                  calories: 1800.0 + (index * 50), // Varying daily calories
                  carbohydrates: 200.0 + (index * 10),
                  fats: 60.0 + (index * 2),
                  proteins: 120.0 + (index * 5),
                ));

        // Sum all days
        final weeklyTotal = dailyMacros.reduce((sum, daily) => sum + daily);

        expect(weeklyTotal.calories, 13650.0); // 1800*7 + 50*(0+1+2+3+4+5+6)
        expect(weeklyTotal.carbohydrates, 1610.0); // 200*7 + 10*(0+1+2+3+4+5+6)
        expect(weeklyTotal.fats, 462.0); // 60*7 + 2*(0+1+2+3+4+5+6)
        expect(weeklyTotal.proteins, 945.0); // 120*7 + 5*(0+1+2+3+4+5+6)

        // Average daily macros
        final averageDaily = MacrosCache(
          calories: weeklyTotal.calories / 7,
          carbohydrates: weeklyTotal.carbohydrates / 7,
          fats: weeklyTotal.fats / 7,
          proteins: weeklyTotal.proteins / 7,
        );

        expect(averageDaily.calories, 1950.0);
        expect(averageDaily.carbohydrates, 230.0);
        expect(averageDaily.fats, 66.0);
        expect(averageDaily.proteins, 135.0);
      });

      test('handles recipe scaling calculations', () {
        // Original recipe for 2 servings
        final originalRecipe = MacrosCache(
          calories: 400.0,
          carbohydrates: 50.0,
          fats: 16.0,
          proteins: 24.0,
        );

        // Scale to 6 servings (multiply by 3)
        final scaledRecipe = MacrosCache(
          calories: originalRecipe.calories * 3,
          carbohydrates: originalRecipe.carbohydrates * 3,
          fats: originalRecipe.fats * 3,
          proteins: originalRecipe.proteins * 3,
        );

        expect(scaledRecipe.calories, 1200.0);
        expect(scaledRecipe.carbohydrates, 150.0);
        expect(scaledRecipe.fats, 48.0);
        expect(scaledRecipe.proteins, 72.0);

        // Per serving calculation (divide by 6)
        final perServing = MacrosCache(
          calories: scaledRecipe.calories / 6,
          carbohydrates: scaledRecipe.carbohydrates / 6,
          fats: scaledRecipe.fats / 6,
          proteins: scaledRecipe.proteins / 6,
        );

        expect(perServing.calories, 200.0);
        expect(perServing.carbohydrates, 25.0);
        expect(perServing.fats, 8.0);
        expect(perServing.proteins, 12.0);
      });
    });

    group('Edge cases and validation', () {
      test('handles very large numbers', () {
        final largeMacros = MacrosCache(
          calories: 999999.99,
          carbohydrates: 123456.78,
          fats: 87654.32,
          proteins: 56789.01,
        );

        final json = largeMacros.toJson();
        final reconstructed = MacrosCache.fromJson(json);

        expect(reconstructed.calories, largeMacros.calories);
        expect(reconstructed.carbohydrates, largeMacros.carbohydrates);
        expect(reconstructed.fats, largeMacros.fats);
        expect(reconstructed.proteins, largeMacros.proteins);
      });

      test('handles very small decimal numbers', () {
        final smallMacros = MacrosCache(
          calories: 0.001,
          carbohydrates: 0.0001,
          fats: 0.00001,
          proteins: 0.000001,
        );

        final json = smallMacros.toJson();
        final reconstructed = MacrosCache.fromJson(json);

        expect(reconstructed.calories, smallMacros.calories);
        expect(reconstructed.carbohydrates, smallMacros.carbohydrates);
        expect(reconstructed.fats, smallMacros.fats);
        expect(reconstructed.proteins, smallMacros.proteins);
      });

      test('handles negative values', () {
        final negativeMacros = MacrosCache(
          calories: -100.0,
          carbohydrates: -25.0,
          fats: -10.0,
          proteins: -15.0,
        );

        expect(negativeMacros.calories, -100.0);
        expect(negativeMacros.carbohydrates, -25.0);
        expect(negativeMacros.fats, -10.0);
        expect(negativeMacros.proteins, -15.0);

        // Addition with negative values
        final positiveMacros = MacrosCache(
          calories: 150.0,
          carbohydrates: 30.0,
          fats: 12.0,
          proteins: 18.0,
        );

        final result = positiveMacros + negativeMacros;
        expect(result.calories, 50.0);
        expect(result.carbohydrates, 5.0);
        expect(result.fats, 2.0);
        expect(result.proteins, 3.0);
      });

      test('handles double precision edge cases', () {
        final precisionMacros = MacrosCache(
          calories: double.maxFinite,
          carbohydrates: double.minPositive,
          fats: double.infinity,
          proteins: double.negativeInfinity,
        );

        expect(precisionMacros.calories, double.maxFinite);
        expect(precisionMacros.carbohydrates, double.minPositive);
        expect(precisionMacros.fats, double.infinity);
        expect(precisionMacros.proteins, double.negativeInfinity);
      });

      test('handles NaN values', () {
        final nanMacros = MacrosCache(
          calories: double.nan,
          carbohydrates: 25.0,
          fats: double.nan,
          proteins: 15.0,
        );

        expect(nanMacros.calories.isNaN, true);
        expect(nanMacros.carbohydrates, 25.0);
        expect(nanMacros.fats.isNaN, true);
        expect(nanMacros.proteins, 15.0);

        // Addition with NaN
        final normalMacros = MacrosCache(
            calories: 100.0, carbohydrates: 20.0, fats: 8.0, proteins: 12.0);
        final result = normalMacros + nanMacros;

        expect(result.calories.isNaN, true);
        expect(result.carbohydrates, 45.0);
        expect(result.fats.isNaN, true);
        expect(result.proteins, 27.0);
      });
    });
  });
}
