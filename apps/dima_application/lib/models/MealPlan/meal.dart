import 'package:dima_application/generated/flutter-models/Meal.dart';
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:isar/isar.dart';

part 'meal.g.dart'; // <-- Add part directive

@embedded // Embed Meal within DailyPlan
class MealCache {
  @Enumerated(EnumType.name)
  late MealNameEnum? name; // e.g., "breakfast"

  late String recipe;
  late String recipeName; // e.g., "Oatmeal with fruits"
  late List<IngredientCache> ingredients;
  late MacrosCache totalMacros;

  MealCache(); // Default constructor needed by Isar

  MealCache.create(
      {required this.name,
      required this.recipe,
      required this.ingredients,
      required this.recipeName,
      required this.totalMacros});

  factory MealCache.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ingredientsList = json['ingredients'] ?? [];
    return MealCache.create(
      name: json['name'] ?? 'Unknown Meal',
      recipe: json['recipe'] ?? '',
      recipeName: json['recipe_name'] ?? '',
      ingredients: ingredientsList
          .map((ingJson) => IngredientCache.fromJson(ingJson))
          .toList(),
      totalMacros: MacrosCache.fromJson(json['total_macros'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recipe': recipe,
      'recipe_name': recipeName,
      'ingredients': ingredients.map((ing) => ing.toJson()).toList(),
      'total_macros': totalMacros.toJson(),
    };
  }

  // Optional: Factory constructor from Amplify model
  factory MealCache.fromAmplify(Meal amplifyMeal) {
    return MealCache.create(
      ingredients: amplifyMeal.ingredients
          .map((ing) => IngredientCache.fromAmplify(ing))
          .toList(),
      // Ensure the enum values match exactly between Amplify and Isar versions
      name: MealNameEnum.values.firstWhere(
        (e) => e.name == amplifyMeal.name.name,
        orElse: () {
          // Optional: Log a warning if a mismatch occurs
          return MealNameEnum.values.first; // Provide a default value
        },
      ),
      recipe: amplifyMeal.recipe ?? 'EMPTY RECIPE',
      recipeName: amplifyMeal.recipeName ?? 'EMPTY RECIPE NAME',
      totalMacros: MacrosCache.fromAmplify(amplifyMeal.totalMacros),
    );
  }

  Meal toMeal() {
    if (name == null || !MealNameEnum.values.contains(name!)) {
      throw ArgumentError("Invalid meal name: ${name?.name}");
    }

    return Meal(
      name: MealNameEnum.values.firstWhere((e) => e.name == name!.name),
      recipe: recipe,
      recipeName: recipeName,
      ingredients: ingredients.map((ing) => ing.toIngredient()).toList(),
      totalMacros: totalMacros.toMacros(),
    );
  }
}
