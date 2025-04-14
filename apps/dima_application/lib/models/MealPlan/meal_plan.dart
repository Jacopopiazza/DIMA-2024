// lib/models/meal_plan_models.dart (adjust filename)
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:isar/isar.dart';
import 'package:dima_application/models/MealPlan/macros.dart'; // Assuming you have a Macros model
import 'package:dima_application/models/MealPlan/meal.dart'; // Assuming you have a Meal model
import 'package:dima_application/models/MealPlan/ingredient.dart'; // Assuming you have an Ingredient model

part 'meal_plan.g.dart'; // Remember to generate this!

@collection
class MealPlan {
  Id id = Isar.autoIncrement; // Isar's auto ID

  @Index(unique: true, replace: true) // Index on planId for easy lookup/update
  late String planId; // The original ID from your backend/mock

  late List<DailyPlan> dailyPlans;

  late DateTime lastFetched; // Timestamp for cache validity

  // Default constructor needed by Isar
  MealPlan();

   // Constructor for creating/updating
  MealPlan.create({required this.planId, required this.dailyPlans, required this.lastFetched});

  // fromJson remains useful for parsing the initial API/asset response
   factory MealPlan.fromJson(Map<String, dynamic> json, String originalPlanId, DateTime fetchedTime) {
     final List<dynamic> planList = json['meal_plan'] ?? [];
     return MealPlan.create(
         planId: originalPlanId, // Store the ID
         dailyPlans: planList.map((dayJson) => DailyPlan.fromJson(dayJson)).toList(),
         lastFetched: fetchedTime // Store when it was fetched
     );
   }
}
