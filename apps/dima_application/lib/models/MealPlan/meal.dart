import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:isar/isar.dart';

part 'meal.g.dart'; // <-- Add part directive

@embedded // Embed Meal within DailyPlan
class Meal {
  late String name; // e.g., "breakfast"
  late String recipe;
  late List<Ingredient> ingredients;
  late Macros totalMacros;

  Meal(); // Default constructor needed by Isar

  Meal.create(
      {required this.name,
      required this.recipe,
      required this.ingredients,
      required this.totalMacros});

  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ingredientsList = json['ingredients'] ?? [];
    return Meal.create(
      name: json['name'] ?? 'Unknown Meal',
      recipe: json['recipe'] ?? '',
      ingredients: ingredientsList
          .map((ingJson) => Ingredient.fromJson(ingJson))
          .toList(),
      totalMacros: Macros.fromJson(json['total_macros'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recipe': recipe,
      'ingredients': ingredients.map((ing) => ing.toJson()).toList(),
      'total_macros': totalMacros.toJson(),
    };
  }
}
