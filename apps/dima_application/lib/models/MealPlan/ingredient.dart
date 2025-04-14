import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:isar/isar.dart';

part 'ingredient.g.dart'; // <-- Add part directive

@embedded // Embed Ingredient within Meal
class Ingredient {
  late String name;
  late double amount; // Use num for flexibility (int/double)
  late Macros macros;

  Ingredient(); // Default constructor needed by Isar

  Ingredient.create(
      {required this.name, required this.amount, required this.macros});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient.create(
      name: json['name'] ?? 'Unknown Ingredient',
      amount: _toDouble(json['amount']),
      macros: Macros.fromJson(json['macros'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'macros': macros.toJson(),
    };
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}