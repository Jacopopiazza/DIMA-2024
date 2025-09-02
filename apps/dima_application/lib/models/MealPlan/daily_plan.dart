// lib/models/meal_plan_models.dart (adjust filename as needed)
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlan/meal.dart';

import 'package:isar/isar.dart';

part 'daily_plan.g.dart';

//-------------------------------------------------
// DailyPlanCache Embedded Object
//-------------------------------------------------
@embedded
class DailyPlanCache {
  // Use IsarMeal list. Initialize to empty lists.
  // Isar doesn't distinguish between null list and empty list well
  // when embedded, so using non-nullable empty lists is often easier.
  late List<MealCache> monday = [];
  late List<MealCache> tuesday = [];
  late List<MealCache> wednesday = [];
  late List<MealCache> thursday = [];
  late List<MealCache> friday = [];
  late List<MealCache> saturday = [];
  late List<MealCache> sunday = [];

  DailyPlanCache(); // Default constructor needed by Isar
  DailyPlanCache.create({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  // Optional: Factory constructor from Amplify model
  factory DailyPlanCache.fromAmplify(DailyPlanData? amplifyData) {
    // Ensure each day's meals are non-null and default to empty lists if null
    final monday = amplifyData?.monday ?? [];
    final tuesday = amplifyData?.tuesday ?? [];
    final wednesday = amplifyData?.wednesday ?? [];
    final thursday = amplifyData?.thursday ?? [];
    final friday = amplifyData?.friday ?? [];
    final saturday = amplifyData?.saturday ?? [];
    final sunday = amplifyData?.sunday ?? [];

    return DailyPlanCache.create(
      monday: monday.map((meal) => MealCache.fromAmplify(meal)).toList(),
      tuesday: tuesday.map((meal) => MealCache.fromAmplify(meal)).toList(),
      wednesday: wednesday.map((meal) => MealCache.fromAmplify(meal)).toList(),
      thursday: thursday.map((meal) => MealCache.fromAmplify(meal)).toList(),
      friday: friday.map((meal) => MealCache.fromAmplify(meal)).toList(),
      saturday: saturday.map((meal) => MealCache.fromAmplify(meal)).toList(),
      sunday: sunday.map((meal) => MealCache.fromAmplify(meal)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday.map((meal) => meal.toJson()).toList(),
      'tuesday': tuesday.map((meal) => meal.toJson()).toList(),
      'wednesday': wednesday.map((meal) => meal.toJson()).toList(),
      'thursday': thursday.map((meal) => meal.toJson()).toList(),
      'friday': friday.map((meal) => meal.toJson()).toList(),
      'saturday': saturday.map((meal) => meal.toJson()).toList(),
      'sunday': sunday.map((meal) => meal.toJson()).toList(),
    };
  }

  /// Creates a DailyPlan from DailyPlanCache
  DailyPlanData toDailyPlan() {
    return DailyPlanData(
      monday: monday.map((meal) => meal.toMeal()).toList(),
      tuesday: tuesday.map((meal) => meal.toMeal()).toList(),
      wednesday: wednesday.map((meal) => meal.toMeal()).toList(),
      thursday: thursday.map((meal) => meal.toMeal()).toList(),
      friday: friday.map((meal) => meal.toMeal()).toList(),
      saturday: saturday.map((meal) => meal.toMeal()).toList(),
      sunday: sunday.map((meal) => meal.toMeal()).toList(),
    );
  }
}
