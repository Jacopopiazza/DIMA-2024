// lib/models/meal_plan_models.dart (adjust filename as needed)
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';

import 'package:isar/isar.dart';

part 'meal_plan.g.dart';

/// Generated file for all Isar models in this file
/// Helper function to determine the sort order of weekdays.
/// Returns an integer representing the day's position (Monday=0, Sunday=6).
int _weekdayOrder(String weekday) {
  switch (weekday.toLowerCase()) {
    case 'monday':
      return 0;
    case 'tuesday':
      return 1;
    case 'wednesday':
      return 2;
    case 'thursday':
      return 3;
    case 'friday':
      return 4;
    case 'saturday':
      return 5;
    case 'sunday':
      return 6;
    default:
      return 7; // Place unknown weekdays last
  }
}

//-------------------------------------------------
// MealPlan Collection - Top Level Object
//-------------------------------------------------
@collection
class MealPlan {
  Id id = Isar.autoIncrement; // Isar's internal auto-incrementing ID

  @Index(
      unique: true,
      replace:
          true) // Index for efficient lookup and updates based on your backend ID
  late String planId; // The original ID from your backend/source

  // Stores DailyPlan objects, each representing a day. Will be sorted by weekday.
  late List<DailyPlan> dailyPlans;

  late DateTime lastFetched; // Timestamp for cache validity checks

  // Default constructor needed by Isar.
  MealPlan();

  // Constructor for creating/updating MealPlan instances programmatically.
  MealPlan.create(
      {required this.planId,
      required this.dailyPlans,
      required this.lastFetched});

  /// Factory constructor to parse the entire meal plan JSON response.
  /// The input 'json' is expected to be the object with day names as keys:
  /// { "monday": { "meals": [...] }, "tuesday": { "meals": [...] }, ... }
  /// 'originalPlanId' is the ID associated with this plan (e.g., from backend).
  /// 'fetchedTime' is when the data was retrieved.
  factory MealPlan.fromJson(
      Map<String, dynamic> json, String originalPlanId, DateTime fetchedTime) {
    final List<DailyPlan> parsedDailyPlans = [];

    // Iterate over the keys (day names like "monday", "tuesday") and
    // values (the corresponding day data objects) of the input JSON map.
    json.forEach((dayName, dayData) {
      // Ensure the data for the day is actually a map before processing
      if (dayData is Map<String, dynamic>) {
        // Create a DailyPlan object from the day's data, passing the day name.
        parsedDailyPlans.add(DailyPlan.fromJson(dayName, dayData));
      } else {
        // Optional: Log a warning or handle cases where dayData isn't a map
        print(
            'Warning: Unexpected data type for day "$dayName" in MealPlan JSON.');
      }
    });

    // *** ADDED: Sort the daily plans by weekday ***
    // Uses the helper function _weekdayOrder to ensure consistent ordering.
    parsedDailyPlans.sort(
        (a, b) => _weekdayOrder(a.weekday).compareTo(_weekdayOrder(b.weekday)));

    return MealPlan.create(
      planId: originalPlanId,
      dailyPlans: parsedDailyPlans, // Use the sorted list
      lastFetched: fetchedTime,
    );
  }

  /// Converts the MealPlan object back into a JSON map.
  /// Useful for sending data back to an API or storing as JSON.
  Map<String, dynamic> toJson() {
    // Convert list of daily plans back to a map keyed by weekday
    final Map<String, dynamic> dailyPlansMap = {};
    for (var plan in dailyPlans) {
      // Use the weekday name as the key in the map
      dailyPlansMap[plan.weekday] =
          plan.toJson(); // Assuming DailyPlan has toJson
    }
    return {
      // Isar ID is usually not included in JSON serialization.
      // 'planId': planId, // Include planId if required by the receiving system.

      // Structure the output map with weekdays as keys, matching the input structure.
      ...dailyPlansMap,

      // Include lastFetched timestamp in ISO 8601 format if needed.
      // 'lastFetched': lastFetched.toIso8601String(),
    };
  }
}
