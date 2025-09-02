import 'package:isar/isar.dart';

part 'active_plan_cache.g.dart';

/// Cache for storing the last known active meal plan state
/// This helps distinguish between "no active plan" vs "network error"
@Collection()
class ActivePlanCache {
  Id id = Isar.autoIncrement;
  
  /// The user ID this cache belongs to
  @Index()
  String? userId;
  
  /// The last known active meal plan ID (null if confirmed no active plan)
  String? activeMealPlanId;
  
  /// When this active plan state was last confirmed from the server
  DateTime lastConfirmedAt;
  
  /// Whether the server confirmed there is no active plan (true) 
  /// or if we just couldn't reach the server (false)
  bool confirmedNoActivePlan;
  
  /// When this cache entry was created/updated
  DateTime updatedAt;

  ActivePlanCache({
    this.userId,
    this.activeMealPlanId,
    required this.lastConfirmedAt,
    required this.confirmedNoActivePlan,
    required this.updatedAt,
  });

  /// Creates a cache entry for when server confirms no active plan
  factory ActivePlanCache.confirmedNoPlan({
    required String? userId,
  }) {
    final now = DateTime.now();
    return ActivePlanCache(
      userId: userId,
      activeMealPlanId: null,
      lastConfirmedAt: now,
      confirmedNoActivePlan: true,
      updatedAt: now,
    );
  }

  /// Creates a cache entry for when server confirms an active plan
  factory ActivePlanCache.confirmedActivePlan({
    required String? userId,
    required String activeMealPlanId,
  }) {
    final now = DateTime.now();
    return ActivePlanCache(
      userId: userId,
      activeMealPlanId: activeMealPlanId,
      lastConfirmedAt: now,
      confirmedNoActivePlan: false,
      updatedAt: now,
    );
  }

  /// Checks if this cache entry is still fresh (less than 5 minutes old)
  bool get isFresh {
    final now = DateTime.now();
    final difference = now.difference(lastConfirmedAt);
    return difference.inMinutes < 5;
  }

  /// Checks if this cache entry is stale but still usable (less than 24 hours old)
  bool get isUsable {
    final now = DateTime.now();
    final difference = now.difference(lastConfirmedAt);
    return difference.inHours < 24;
  }

  @override
  String toString() {
    return 'ActivePlanCache(userId: $userId, activePlanId: $activeMealPlanId, '
           'confirmedNoActivePlan: $confirmedNoActivePlan, lastConfirmed: $lastConfirmedAt, '
           'isFresh: $isFresh, isUsable: $isUsable)';
  }
}