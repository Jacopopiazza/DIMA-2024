import 'package:isar/isar.dart';

part 'macros.g.dart'; // <-- Add part directive

@embedded // Embed Macros
class Macros {
  late double calories;
  late double carbohydrates;
  late double fats;
  late double proteins;

  Macros({
    this.calories = 0.0,
    this.carbohydrates = 0.0,
    this.fats = 0.0,
    this.proteins = 0.0,
  });

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      proteins: (json['proteins'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Operator overloading for easy summation
  Macros operator +(Macros other) {
    return Macros(
      calories: calories + other.calories,
      carbohydrates: carbohydrates + other.carbohydrates,
      fats: fats + other.fats,
      proteins: proteins + other.proteins,
    );
  }

  // Method for percentage calculation (useful for progress)
  Macros percentageOf(Macros total) {
    return Macros(
      calories: total.calories == 0 ? 0 : calories / total.calories,
      carbohydrates:
          total.carbohydrates == 0 ? 0 : carbohydrates / total.carbohydrates,
      fats: total.fats == 0 ? 0 : fats / total.fats,
      proteins: total.proteins == 0 ? 0 : proteins / total.proteins,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proteins': proteins,
      'carbohydrates': carbohydrates,
      'fats': fats,
      'calories': calories,
    };
  }
}
