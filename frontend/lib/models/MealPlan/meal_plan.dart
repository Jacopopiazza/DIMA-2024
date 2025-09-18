// lib/models/meal_plan_models.dart (adjust filename as needed)
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlan/daily_plan.dart';
import 'package:dima_application/models/MealPlan/ingredient.dart';
import 'package:dima_application/models/MealPlan/macros.dart';
import 'package:dima_application/models/MealPlan/meal.dart';
import 'package:isar/isar.dart';

part 'meal_plan.g.dart';

//-------------------------------------------------
// MealPlanCache Collection - Top Level Object
//-------------------------------------------------
@collection
class MealPlanCache {
  Id id = Isar.autoIncrement; // Isar's internal auto-incrementing ID

  late String? assignedNutritionistId;
  late String? chatId;
  late DailyPlanCache dailyPlan;
  late String generatedAtTimestamp;

  // Use @Index to ensure mealPlanId is unique in the database
  @Index(unique: true, replace: true)
  late String mealPlanId;

  // Use @Index to ensure planName is unique in the database
  @Index(unique: true, replace: true)
  late String planName;

  @enumerated
  late PlanStatus status;
  late String userId;
  late String lastFetchedTimestamp;

  @ignore
  TemporalDateTime get generatedAt =>
      TemporalDateTime.fromString(generatedAtTimestamp);
  @ignore
  TemporalDateTime get lastFetched =>
      TemporalDateTime.fromString(lastFetchedTimestamp);

  // Default constructor needed by Isar
  MealPlanCache(); // Default constructor needed by Isar

  // Factory constructor from Amplify model
  factory MealPlanCache.create({
    required String? assignedNutritionistId,
    required String? chatId,
    required DailyPlanCache dailyPlan,
    required TemporalDateTime generatedAt,
    required String mealPlanId,
    required String planName,
    required PlanStatus status,
    required String userId,
    TemporalDateTime? lastFetched,
  }) {
    return MealPlanCache()
      ..assignedNutritionistId = assignedNutritionistId
      ..chatId = chatId
      ..dailyPlan = dailyPlan
      ..generatedAtTimestamp = generatedAt.format()
      ..mealPlanId = mealPlanId
      ..planName = planName
      ..status = status
      ..userId = userId
      ..lastFetchedTimestamp =
          lastFetched?.format() ?? TemporalDateTime.now().format();
  }

  // Optional: Factory constructor from Amplify model
  factory MealPlanCache.fromAmplify(MealPlan amplifyData) {
    // Check if amplifyData is null
    if (amplifyData == null) {
      throw ArgumentError("amplifyData cannot be null");
    }
    // Check if status is null
    if (amplifyData.status == null) {
      throw ArgumentError("status cannot be null");
    }
    if (amplifyData.dailyPlan == null) {
      throw ArgumentError("dailyPlan cannot be null");
    }
    if (amplifyData.planName == null) {
      throw ArgumentError("monday meals cannot be null");
    }

    return MealPlanCache.create(
      assignedNutritionistId: amplifyData.assignedNutritionistId,
      chatId: amplifyData.chatId,
      dailyPlan: DailyPlanCache.fromAmplify(amplifyData.dailyPlan),
      generatedAt: amplifyData.generatedAt!,
      mealPlanId: amplifyData.mealPlanId,
      planName: amplifyData.planName!,
      status: amplifyData.status!,
      userId: amplifyData.userId,
      lastFetched: TemporalDateTime.now(),
    );
  }

  MealPlan toMealPlan() {
    return MealPlan(
      assignedNutritionistId: assignedNutritionistId,
      chatId: chatId,
      dailyPlan: dailyPlan.toDailyPlan(),
      generatedAt: TemporalDateTime.fromString(generatedAtTimestamp),
      mealPlanId: mealPlanId,
      planName: planName,
      status: status,
      userId: userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignedNutritionistId': assignedNutritionistId,
      'chatId': chatId,
      'dailyPlan': dailyPlan.toJson(),
      'generatedAt': generatedAtTimestamp,
      'mealPlanId': mealPlanId,
      'planName': planName,
      'status': status.name,
      'userId': userId,
      'lastFetched': lastFetchedTimestamp,
    };
  }
}
