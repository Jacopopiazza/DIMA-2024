// lib/models/daily_completion.dart (or similar file)
import 'package:isar/isar.dart';

part 'daily_completion.g.dart'; // Generate this with build_runner

@collection
class DailyCompletion {
  Id id = Isar.autoIncrement; // Or manage ID differently if needed

  @Index(type: IndexType.value, caseSensitive: false) // Index for efficient date lookup
  late DateTime date; // Store date only (set time to 00:00:00)

  late List<String> completedMealNames;

  // Optional: Add a user identifier if multiple users might use the app on one device
  // String userId;

  DailyCompletion({
     required this.date,
     this.completedMealNames = const [],
     // required this.userId,
  });

  // Helper to ensure date is stored without time component
   static DateTime _dateOnly(DateTime dt) {
     return DateTime(dt.year, dt.month, dt.day);
   }

   // Constructor that normalizes the date
   factory DailyCompletion.forDate(DateTime date, {List<String> completedMeals = const []}) {
      return DailyCompletion(
         date: _dateOnly(date),
         completedMealNames: completedMeals,
      );
   }
}