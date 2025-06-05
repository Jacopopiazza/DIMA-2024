import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:collection/collection.dart'; // Added for firstWhereOrNull
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart'; // For MealPlanCache
import 'package:isar/isar.dart';

class MealPlanList {
  final MealPlan? currentMealPlan;
  final List<MealPlan> allMealPlans;

  MealPlanList({
    this.currentMealPlan,
    required this.allMealPlans,
  });

  // Optional: Add a copyWith method if you need to create modified instances
  MealPlanList copyWith({
    MealPlan? currentMealPlan,
    List<MealPlan>? allMealPlans,
  }) {
    return MealPlanList(
      currentMealPlan: currentMealPlan ?? this.currentMealPlan,
      allMealPlans: allMealPlans ?? this.allMealPlans,
    );
  }

  // Optional: Add factory constructor for empty state or initial state
  factory MealPlanList.initial() {
    return MealPlanList(
      allMealPlans: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentMealPlan':
          currentMealPlan?.toJson(), // Amplify MealPlan has toJson()
      'allMealPlans': allMealPlans.map((mp) => mp.toJson()).toList(),
    };
  }

  factory MealPlanList.fromJson(Map<String, dynamic> json) {
    MealPlan mealPlanFromJson(Map<String, dynamic> mpJson) {
      List<Meal> parseMeals(List<dynamic>? mealListJson) {
        if (mealListJson == null) return [];
        return mealListJson.map((mJson) {
          final m = mJson as Map<String, dynamic>;
          return Meal(
            name: MealNameEnum.values.byName(m['name'] as String),
            recipe: m['recipe'] as String?,
            recipeName: m['recipeName'] as String?,
            ingredients: (m['ingredients'] as List<dynamic>?)
                    ?.map((iJson) =>
                        Ingredient.fromJson(iJson as Map<String, dynamic>))
                    .toList() ??
                [],
            totalMacros:
                Macros.fromJson(m['totalMacros'] as Map<String, dynamic>),
          );
        }).toList();
      }

      final dailyPlanJson = mpJson['dailyPlan'] as Map<String, dynamic>?;
      DailyPlanData? dailyPlanData;
      if (dailyPlanJson != null) {
        dailyPlanData = DailyPlanData(
          monday: parseMeals(dailyPlanJson['monday'] as List<dynamic>?),
          tuesday: parseMeals(dailyPlanJson['tuesday'] as List<dynamic>?),
          wednesday: parseMeals(dailyPlanJson['wednesday'] as List<dynamic>?),
          thursday: parseMeals(dailyPlanJson['thursday'] as List<dynamic>?),
          friday: parseMeals(dailyPlanJson['friday'] as List<dynamic>?),
          saturday: parseMeals(dailyPlanJson['saturday'] as List<dynamic>?),
          sunday: parseMeals(dailyPlanJson['sunday'] as List<dynamic>?),
        );
      }

      return MealPlan(
        id: mpJson['id'] as String, // Amplify ID
        mealPlanId: mpJson['mealPlanId'] as String,
        userId: mpJson['userId'] as String,
        planName: mpJson['planName'] as String,
        status: PlanStatus.values.byName(mpJson['status'] as String),
        generatedAt:
            TemporalDateTime.fromString(mpJson['generatedAt'] as String),
        assignedNutritionistId: mpJson['assignedNutritionistId'] as String?,
        chatId: mpJson['chatId'] as String?,
        dailyPlan: dailyPlanData,
        // lastModifiedAt, createdAt, updatedAt, owner are also part of Amplify model but often handled by DataStore
      );
    }

    return MealPlanList(
      currentMealPlan: json['currentMealPlan'] != null
          ? mealPlanFromJson(json['currentMealPlan'] as Map<String, dynamic>)
          : null,
      allMealPlans: (json['allMealPlans'] as List<dynamic>)
          .map((mpJson) => mealPlanFromJson(mpJson as Map<String, dynamic>))
          .toList(),
    );
  }

  factory MealPlanList.fromAmplifyModels(
    List<MealPlan> mealPlans, {
    String? currentMealPlanId,
    bool determineCurrentByStatus =
        true, // Default to trying to find an ACTIVE plan
  }) {
    MealPlan? current;
    if (currentMealPlanId != null) {
      current = mealPlans
          .firstWhereOrNull((mp) => mp.mealPlanId == currentMealPlanId);
    }
    if (current == null && determineCurrentByStatus) {
      current =
          mealPlans.firstWhereOrNull((mp) => mp.status == PlanStatus.ACTIVE);
    }
    // If still no current plan, and there are plans, pick the first one as a fallback? Or leave null.
    // For now, leaving it null if no specific criteria met.
    // if (current == null && mealPlans.isNotEmpty) {
    //   current = mealPlans.first;
    // }

    return MealPlanList(
      currentMealPlan: current,
      allMealPlans: List<MealPlan>.from(mealPlans), // Create a new list
    );
  }
}

//-------------------------------------------------
// MealPlanListCache Collection - For Isar
//-------------------------------------------------
@collection
class MealPlanListCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.hash)
  late String userId; // To associate this list with a specific user

  String? currentMealPlanId; // Stores the mealPlanId of the Amplify MealPlan
  List<String> allMealPlanIds; // Stores mealPlanIds

  // Default constructor needed by Isar
  MealPlanListCache({
    this.currentMealPlanId,
    this.allMealPlanIds = const [],
  }) {
    // userId must be set before saving, typically via fromDomain or manually
  }

  factory MealPlanListCache.fromDomain(MealPlanList domainList, String userId) {
    return MealPlanListCache()
      ..userId = userId
      ..currentMealPlanId = domainList.currentMealPlan?.mealPlanId
      ..allMealPlanIds =
          domainList.allMealPlans.map((mp) => mp.mealPlanId).toList();
  }

  Future<MealPlanList> toDomain(Isar isar) async {
    List<MealPlan> resolvedMealPlans = [];
    for (String planId in allMealPlanIds) {
      final mealPlanCache = await isar.mealPlanCaches.getByMealPlanId(planId);
      if (mealPlanCache != null) {
        resolvedMealPlans.add(mealPlanCache.toMealPlan());
      }
      // else: log warning or handle missing meal plan cache?
    }

    MealPlan? resolvedCurrentMealPlan;
    if (currentMealPlanId != null) {
      final currentMealPlanCache =
          await isar.mealPlanCaches.getByMealPlanId(currentMealPlanId!);
      if (currentMealPlanCache != null) {
        resolvedCurrentMealPlan = currentMealPlanCache.toMealPlan();
      }
      // else: if currentMealPlanId is set but not found, what to do?
      // Maybe try to find it in the resolvedMealPlans list by ID.
      resolvedCurrentMealPlan ??= resolvedMealPlans
          .firstWhereOrNull((mp) => mp.mealPlanId == currentMealPlanId);
    }

    // If currentMealPlan is still null, try to set it based on ACTIVE status from the resolved list
    resolvedCurrentMealPlan ??= resolvedMealPlans
        .firstWhereOrNull((mp) => mp.status == PlanStatus.ACTIVE);

    return MealPlanList(
      currentMealPlan: resolvedCurrentMealPlan,
      allMealPlans: resolvedMealPlans,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentMealPlanId': currentMealPlanId,
      'allMealPlanIds': allMealPlanIds,
      // 'id': id, // Isar ID typically not needed in JSON unless for specific debugging
    };
  }

  factory MealPlanListCache.fromJson(Map<String, dynamic> json) {
    final cache = MealPlanListCache()
      ..userId = json['userId'] as String
      ..currentMealPlanId = json['currentMealPlanId'] as String?
      ..allMealPlanIds = (json['allMealPlanIds'] as List<dynamic>)
          .map((id) => id as String)
          .toList();
    // if (json.containsKey('id')) { // If Isar ID is ever included
    //   cache.id = json['id'] as int;
    // }
    return cache;
  }
}
