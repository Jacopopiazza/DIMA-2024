import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:isar/isar.dart';

part 'daily_plan.g.dart'; // <-- Add part directive

@embedded // Embed DailyPlan within FullMealPlan
class DailyPlan {
  late String weekday;
  late List<Meal> meals;
  late Macros totalMacros; // Keep pre-calculated totals if useful

   // Default constructor needed by Isar
   DailyPlan();

   // Constructor for creation
   DailyPlan.create({required this.weekday, required this.meals, required this.totalMacros});

   factory DailyPlan.fromJson(Map<String, dynamic> json) {
      // ... (parsing logic as before, using .create constructors) ...
       final List<dynamic> mealsList = json['meals'] ?? [];
       Macros dailyTotal = Macros();
       List<Meal> parsedMeals = mealsList.map((mealJson) {
           final meal = Meal.fromJson(mealJson);
           dailyTotal += meal.totalMacros;
           return meal;
       }).toList();

       return DailyPlan.create(
           weekday: json['weekday'] ?? 'Unknown',
           meals: parsedMeals,
           totalMacros: dailyTotal,
       );
   }
}