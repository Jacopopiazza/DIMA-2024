import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:isar/isar.dart';

part 'daily_plan.g.dart'; // <-- Add part directive

//-------------------------------------------------
// DailyPlan Embedded Object - MODIFIED
//-------------------------------------------------
@embedded // DailyPlan is part of MealPlan, not a separate collection
class DailyPlan {
  late String weekday; // Name of the day (e.g., "monday")
  late List<Meal> meals; // List of meals for this specific day
  late Macros totalMacros; // *** ADDED: Pre-calculated totals for the day ***

  // Default constructor needed by Isar.
  DailyPlan();

  // Constructor for creating DailyPlan instances programmatically.
  // *** UPDATED: Added totalMacros ***
  DailyPlan.create({
    required this.weekday, 
    required this.meals,
    required this.totalMacros 
  });

  /// Factory constructor to create a DailyPlan from the JSON object 
  /// representing a single day's data.
  /// 'dayName' is the key from the parent JSON map (e.g., "monday").
  /// 'json' is the value associated with that key (e.g., { "meals": [...] }).
  /// *** UPDATED: Calculates totalMacros ***
  factory DailyPlan.fromJson(String dayName, Map<String, dynamic> json) {
    // Safely access the 'meals' list within the day's JSON data.
    final List<dynamic> mealsList = json['meals'] ?? [];
    
    // Parse meals first
    final List<Meal> parsedMeals = mealsList
        .map((mealJson) {
          // Ensure mealJson is a Map before passing to Meal.fromJson
          if (mealJson is Map<String, dynamic>) {
            return Meal.fromJson(mealJson);
          } else {
            // Handle error or return a default/empty Meal if needed
            print('Warning: Invalid meal data found for day "$dayName".');
            // Returning a placeholder - adjust as needed
            return Meal.create(name: 'Error Meal', recipe: '', ingredients: [], totalMacros: Macros()); 
          }
        })
        .toList();

    // Calculate total macros for the day by summing macros from each meal
    // Initialize dailyTotal with zero values
    Macros dailyTotal = Macros(); 
    for (var meal in parsedMeals) {
      // Add macros from each meal to the daily total
      dailyTotal.proteins += meal.totalMacros.proteins;
      dailyTotal.carbohydrates += meal.totalMacros.carbohydrates;
      dailyTotal.fats += meal.totalMacros.fats;
      dailyTotal.calories += meal.totalMacros.calories;
    }
    
    return DailyPlan.create(
      weekday: dayName, // Assign the weekday name passed from the parent parser.
      meals: parsedMeals, // Assign the parsed list of meals.
      totalMacros: dailyTotal, // Assign the calculated daily totals.
    );
  }

  // Example toJson for DailyPlan
  // *** UPDATED: Added totalMacros ***
  Map<String, dynamic> toJson() {
    return {
      // 'weekday' is often the key in the parent map, so might not be needed here
      'meals': meals.map((m) => m.toJson()).toList(), // Assuming Meal has toJson
      'total_macros': totalMacros.toJson(), // Include total macros
    };
  }
}