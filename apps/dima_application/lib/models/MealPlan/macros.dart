import 'package:dima_application/generated/flutter-models/Macros.dart';
import 'package:isar/isar.dart';

part 'macros.g.dart'; // <-- Add part directive

@embedded // Embed Macros
class MacrosCache {
  late double calories;
  late double carbohydrates;
  late double fats;
  late double proteins;

  MacrosCache({
    this.calories = 0.0,
    this.carbohydrates = 0.0,
    this.fats = 0.0,
    this.proteins = 0.0,
  });

  factory MacrosCache.fromJson(Map<String, dynamic> json) {
    return MacrosCache(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      proteins: (json['proteins'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Operator overloading for easy summation
  MacrosCache operator +(MacrosCache other) {
    return MacrosCache(
      calories: calories + other.calories,
      carbohydrates: carbohydrates + other.carbohydrates,
      fats: fats + other.fats,
      proteins: proteins + other.proteins,
    );
  }

  // Method for percentage calculation (useful for progress)
  MacrosCache percentageOf(MacrosCache total) {
    return MacrosCache(
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

  // Optional: Factory constructor to convert from your Amplify model
  factory MacrosCache.fromAmplify(Macros amplifyMacros) {
    return MacrosCache(
      calories: amplifyMacros.calories,
      carbohydrates: amplifyMacros.carbohydrates,
      fats: amplifyMacros.fats,
      proteins: amplifyMacros.proteins,
    );
  }

  Macros toMacros() {
    return Macros(
      calories: calories,
      carbohydrates: carbohydrates,
      fats: fats,
      proteins: proteins,
    );
  }
}
