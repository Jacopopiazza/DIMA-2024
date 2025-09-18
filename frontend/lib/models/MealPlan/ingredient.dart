import 'package:dima_application/generated/flutter-models/Ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:isar/isar.dart';

part 'ingredient.g.dart'; // <-- Add part directive

@embedded // Embed Ingredient within Meal
class IngredientCache {
  late String name;
  late double amount; // Use num for flexibility (int/double)
  late String unit; // unit of measurement (e.g., grams, cups)
  late MacrosCache macros;

  IngredientCache(); // Default constructor needed by Isar

  IngredientCache.create(
      {required this.name,
      required this.amount,
      required this.macros,
      required this.unit});

  factory IngredientCache.fromJson(Map<String, dynamic> json) {
    return IngredientCache.create(
      name: json['name'] ?? 'Unknown Ingredient',
      amount: _toDouble(json['amount']),
      macros: MacrosCache.fromJson(json['macros'] ?? {}),
      unit: json['unit'] ?? 'g', // Default to grams if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'macros': macros.toJson(),
      'unit': unit,
    };
  }

  // Optional: Factory constructor from Amplify model
  factory IngredientCache.fromAmplify(Ingredient amplifyIngredient) {
    return IngredientCache.create(
      amount: amplifyIngredient.amount,
      name: amplifyIngredient.name,
      unit: amplifyIngredient.unit ?? 'g',
      macros: MacrosCache.fromAmplify(amplifyIngredient.macros),
    );
  }

  Ingredient toIngredient() {
    return Ingredient(
      name: name,
      amount: amount,
      unit: unit,
      macros: macros.toMacros(),
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
