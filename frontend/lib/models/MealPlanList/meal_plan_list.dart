import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart'; // Added for firstWhereOrNull
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart'; // For MealPlanCache
import 'package:isar/isar.dart';

part 'meal_plan_list.g.dart';

class MealPlanList {
  final List<MealPlan> items;
  final String? nextToken;
  final String? activeMealPlan;

  MealPlanList({required this.items, this.nextToken, this.activeMealPlan});

  factory MealPlanList.fromJson(Map<String, dynamic> json) {
    return MealPlanList(
      items: (json['items'] as List<dynamic>?)?.map((item) {
            // Create a simplified MealPlan with only the fields from the list query
            final itemMap = Map<String, dynamic>.from(item);
            return MealPlan(
              mealPlanId: itemMap['mealPlanId'] as String,
              planName: itemMap['planName'] as String?,
              status: itemMap['status'] != null
                  ? amplify_core.enumFromString<PlanStatus>(
                      itemMap['status'] as String, PlanStatus.values)
                  : null,
              userId:
                  '', // This field is required but not returned by the list query
            );
          }).toList() ??
          [],
      nextToken: json['nextToken'] as String?,
      activeMealPlan: json['activeMealPlan'] as String?,
    );
  }

  // Optional: Add a copyWith method if you need to create modified instances
  MealPlanList copyWith({
    List<MealPlan>? items,
    String? nextToken,
    String? activeMealPlan,
  }) {
    return MealPlanList(
      items: items ?? this.items,
      nextToken: nextToken ?? this.nextToken,
      activeMealPlan: activeMealPlan ?? this.activeMealPlan,
    );
  }

  // Optional: Add factory constructor for empty state or initial state
  factory MealPlanList.initial() {
    return MealPlanList(
      items: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((mp) => mp.toJson()).toList(),
      'nextToken': nextToken,
      'activeMealPlan': activeMealPlan,
    };
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
      items: List<MealPlan>.from(mealPlans), // Create a new list
      nextToken: null,
      activeMealPlan: current?.mealPlanId,
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
      ..currentMealPlanId = domainList.activeMealPlan
      ..allMealPlanIds = domainList.items.map((mp) => mp.mealPlanId).toList();
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
      items: resolvedMealPlans,
      nextToken: null,
      activeMealPlan: resolvedCurrentMealPlan?.mealPlanId,
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

class LightMealPlan {
  final String mealPlanId;
  final DateTime? updatedAt;
  final String? planName;
  final String? errorDetails;
  final DateTime? startDate;
  final DateTime? endDate;
  final PlanStatus? status;
  final MealPlanValidationStatus? validationStatus;

  LightMealPlan({
    required this.mealPlanId,
    this.planName,
    this.updatedAt,
    this.startDate,
    this.endDate,
    this.errorDetails,
    this.status,
    this.validationStatus,
  });

  factory LightMealPlan.fromJson(Map<String, dynamic> json) {
    return LightMealPlan(
      mealPlanId: json['mealPlanId'] as String,
      planName: json['planName'] as String?,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'] != null
          ? amplify_core.enumFromString<PlanStatus>(
              json['status'] as String, PlanStatus.values)
          : null,
      validationStatus: json['validationStatus'] != null
          ? amplify_core.enumFromString<MealPlanValidationStatus>(
              json['validationStatus'] as String,
              MealPlanValidationStatus.values)
          : null,
      errorDetails: json['errorDetails'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealPlanId': mealPlanId,
      'planName': planName,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status?.name,
      'validationStatus': validationStatus?.name,
      'errorDetails': errorDetails,
    };
  }
}

class LightMealPlanList {
  final List<LightMealPlan> items;
  final String? nextToken;
  final String? activeMealPlan;

  LightMealPlanList({required this.items, this.nextToken, this.activeMealPlan});

  factory LightMealPlanList.fromJson(Map<String, dynamic> json) {
    final listMyMealPlans =
        json['listMyMealPlans'] as Map<String, dynamic>? ?? {};
    final rawItems = listMyMealPlans['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .where((item) => item != null)
        .map((item) => LightMealPlan.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return LightMealPlanList(
      items: items,
      nextToken: listMyMealPlans['nextToken'] as String?,
      activeMealPlan: listMyMealPlans['activeMealPlan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((mp) => mp.toJson()).toList(),
      'nextToken': nextToken,
      'activeMealPlan': activeMealPlan,
    };
  }

  void sortByUpdatedAtDesc() {
    items.sort((a, b) {
      final aTime = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
  }
}
