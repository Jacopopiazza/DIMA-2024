// lib/models/today_page_data.dart
import 'package:isar/isar.dart';

part 'today_page_data.g.dart'; // Instructs Dart to link this file to the generated one

@collection // Tells Isar this class is a database collection
class TodayPageData {
  Id id = 0; // Use a fixed ID for single-entry cache

  late String calories;
  late double fatPercent;
  late double proteinPercent;
  late double carbPercent;
  late String lunchImageUrl;
  late String dinnerImageUrl;

  @Index() // Tells Isar to create an index for faster queries on this field
  late DateTime lastUpdated;

  // Your constructors (make sure they align with the fields)
  TodayPageData({
    required this.calories,
    required this.fatPercent,
    required this.proteinPercent,
    required this.carbPercent,
    required this.lunchImageUrl,
    required this.dinnerImageUrl,
    required this.lastUpdated,
  });

  // Optional: Add an empty constructor if needed elsewhere, Isar doesn't strictly require it
  TodayPageData.empty() {
    id = 0; // Assign fixed ID
    calories = "0";
    fatPercent = 0.0;
    proteinPercent = 0.0;
    carbPercent = 0.0;
    lunchImageUrl = "";
    dinnerImageUrl = "";
    lastUpdated = DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  String toString() {
    // Useful for debugging
    return 'TodayPageData(id: $id, calories: $calories, fat: $fatPercent, pro: $proteinPercent, carb: $carbPercent, lastUpdated: $lastUpdated)';
  }
}
