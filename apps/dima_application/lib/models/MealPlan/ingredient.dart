import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:isar/isar.dart';

part 'ingredient.g.dart'; // <-- Add part directive

@embedded // Embed Ingredient within Meal
class Ingredient {
  late String name;
  late double amount; // Use num for flexibility (int/double)
  late Macros macros;

  Ingredient(); // Default constructor needed by Isar

  Ingredient.create({required this.name, required this.amount, required this.macros});

   factory Ingredient.fromJson(Map<String, dynamic> json) {
     return Ingredient.create(
       name: json['name'] ?? 'Unknown Ingredient',
       amount: json['amount'] ?? 0,
       macros: Macros.fromJson(json['macros'] ?? {}),
     );
   }
}