// lib/models/daily_completion.dart (or similar file)
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:isar/isar.dart';

part 'daily_completion.g.dart'; // Generate this with build_runner

@collection
class DailyCompletion {
  Id id = Isar.autoIncrement; // Or manage ID differently if needed

  // Composite index using planId and date for unique tracking per plan per day
  // The 'unique: true, replace: true' ensures that for a given planId and date,
  // there is only one entry, and inserting a new one with the same keys replaces the old one.
  // The Index annotation is on the first field of the composite key (planId),
  // and the type applies to this field.
  @Index(
      composite: [CompositeIndex('date')],
      unique: true,
      replace: true,
      type: IndexType.hash)
  late String planId; // Add planId to the model

  late DateTime date; // Store date only (set time to 00:00:00)

  @enumerated
  late List<MealNameEnum> completedMealNames;

  // Add a field to track the latest update time for this completion record
  late DateTime latestUpdate;

  // Optional: Add a user identifier if multiple users might use the app on one device
  // String userId;

  DailyCompletion({
    required this.planId, // planId is now required
    required DateTime date,
    this.completedMealNames = const [],
    // Initialize latestUpdate with the current time upon creation
    required this.latestUpdate,
    this.id = Isar.autoIncrement,
  }) : this.date = dateOnly(date); // Normalize date

  // Helper to ensure date is stored without time component
  static DateTime dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  // Factory constructor that normalizes the date and includes planId and latestUpdate
  factory DailyCompletion.forDate({
    required String planId,
    required DateTime date,
    List<MealNameEnum> completedMeals = const [],
    DateTime? latestUpdate, // Allow passing latestUpdate or use current time
  }) {
    return DailyCompletion(
      planId: planId,
      date: dateOnly(date),
      completedMealNames: completedMeals,
      // Use provided latestUpdate or current time if not provided
      latestUpdate: latestUpdate ?? DateTime.now(),
    );
  }
}
