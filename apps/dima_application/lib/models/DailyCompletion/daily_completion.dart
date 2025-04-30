// lib/models/daily_completion.dart (or similar file)
import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:isar/isar.dart';

part 'daily_completion.g.dart'; // Generate this with build_runner

@collection
class DailyCompletion {
  Id id = Isar.autoIncrement; // Or manage ID differently if needed

  @Index(type: IndexType.value, caseSensitive: false, unique: true, replace: true) // Index for efficient date lookup
  late DateTime date; // Store date only (set time to 00:00:00)

  @enumerated
  late List<MealNameEnum> completedMealNames;

  // Optional: Add a user identifier if multiple users might use the app on one device
  // String userId;

  DailyCompletion({
     required this.date,
     this.completedMealNames = const [],
     this.id = Isar.autoIncrement,
  });

  // Helper to ensure date is stored without time component
   static DateTime _dateOnly(DateTime dt) {
     return DateTime(dt.year, dt.month, dt.day);
   }

   // Constructor that normalizes the date
   factory DailyCompletion.forDate(DateTime date, {List<MealNameEnum> completedMeals = const []}) {
      return DailyCompletion(
         date: _dateOnly(date),
         completedMealNames: completedMeals,
      );
   }
}