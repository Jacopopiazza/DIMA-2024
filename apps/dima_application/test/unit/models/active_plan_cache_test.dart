import 'package:dima_application/models/ActivePlanCache/active_plan_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivePlanCache', () {
    group('Constructor and initialization', () {
      test('creates ActivePlanCache with all parameters', () {
        final userId = 'user-123';
        final activeMealPlanId = 'plan-456';
        final lastConfirmedAt = DateTime.now();
        final updatedAt = DateTime.now();
        
        final cache = ActivePlanCache(
          userId: userId,
          activeMealPlanId: activeMealPlanId,
          lastConfirmedAt: lastConfirmedAt,
          confirmedNoActivePlan: false,
          updatedAt: updatedAt,
        );
        
        expect(cache.userId, userId);
        expect(cache.activeMealPlanId, activeMealPlanId);
        expect(cache.lastConfirmedAt, lastConfirmedAt);
        expect(cache.confirmedNoActivePlan, false);
        expect(cache.updatedAt, updatedAt);
      });
      
      test('creates ActivePlanCache with minimal parameters', () {
        final lastConfirmedAt = DateTime.now();
        final updatedAt = DateTime.now();
        
        final cache = ActivePlanCache(
          lastConfirmedAt: lastConfirmedAt,
          confirmedNoActivePlan: true,
          updatedAt: updatedAt,
        );
        
        expect(cache.userId, isNull);
        expect(cache.activeMealPlanId, isNull);
        expect(cache.lastConfirmedAt, lastConfirmedAt);
        expect(cache.confirmedNoActivePlan, true);
        expect(cache.updatedAt, updatedAt);
      });
    });
    
    group('Factory constructor confirmedNoPlan', () {
      test('creates cache entry for confirmed no active plan', () {
        final userId = 'user-789';
        final beforeCreation = DateTime.now();
        
        final cache = ActivePlanCache.confirmedNoPlan(userId: userId);
        
        final afterCreation = DateTime.now();
        
        expect(cache.userId, userId);
        expect(cache.activeMealPlanId, isNull);
        expect(cache.confirmedNoActivePlan, true);
        
        // Check that timestamps are recent
        expect(cache.lastConfirmedAt.isAfter(beforeCreation) || 
               cache.lastConfirmedAt.isAtSameMomentAs(beforeCreation), isTrue);
        expect(cache.lastConfirmedAt.isBefore(afterCreation) || 
               cache.lastConfirmedAt.isAtSameMomentAs(afterCreation), isTrue);
        expect(cache.updatedAt.isAfter(beforeCreation) || 
               cache.updatedAt.isAtSameMomentAs(beforeCreation), isTrue);
        expect(cache.updatedAt.isBefore(afterCreation) || 
               cache.updatedAt.isAtSameMomentAs(afterCreation), isTrue);
      });
      
      test('creates cache entry with null userId', () {
        final cache = ActivePlanCache.confirmedNoPlan(userId: null);
        
        expect(cache.userId, isNull);
        expect(cache.activeMealPlanId, isNull);
        expect(cache.confirmedNoActivePlan, true);
        expect(cache.lastConfirmedAt, isA<DateTime>());
        expect(cache.updatedAt, isA<DateTime>());
      });
    });
    
    group('Factory constructor confirmedActivePlan', () {
      test('creates cache entry for confirmed active plan', () {
        final userId = 'user-456';
        final activePlanId = 'plan-789';
        final beforeCreation = DateTime.now();
        
        final cache = ActivePlanCache.confirmedActivePlan(
          userId: userId,
          activeMealPlanId: activePlanId,
        );
        
        final afterCreation = DateTime.now();
        
        expect(cache.userId, userId);
        expect(cache.activeMealPlanId, activePlanId);
        expect(cache.confirmedNoActivePlan, false);
        
        // Check that timestamps are recent
        expect(cache.lastConfirmedAt.isAfter(beforeCreation) || 
               cache.lastConfirmedAt.isAtSameMomentAs(beforeCreation), isTrue);
        expect(cache.lastConfirmedAt.isBefore(afterCreation) || 
               cache.lastConfirmedAt.isAtSameMomentAs(afterCreation), isTrue);
        expect(cache.updatedAt.isAfter(beforeCreation) || 
               cache.updatedAt.isAtSameMomentAs(beforeCreation), isTrue);
        expect(cache.updatedAt.isBefore(afterCreation) || 
               cache.updatedAt.isAtSameMomentAs(afterCreation), isTrue);
      });
      
      test('creates cache entry with null userId but valid plan', () {
        final activePlanId = 'plan-without-user';
        
        final cache = ActivePlanCache.confirmedActivePlan(
          userId: null,
          activeMealPlanId: activePlanId,
        );
        
        expect(cache.userId, isNull);
        expect(cache.activeMealPlanId, activePlanId);
        expect(cache.confirmedNoActivePlan, false);
      });
    });
    
    group('isFresh getter', () {
      test('returns true for recently created cache (within 5 minutes)', () {
        final recentTime = DateTime.now().subtract(Duration(minutes: 2));
        
        final cache = ActivePlanCache(
          userId: 'user-fresh',
          lastConfirmedAt: recentTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache.isFresh, true);
      });
      
      test('returns false for cache created exactly at boundary (5 minutes)', () {
        final boundaryTime = DateTime.now().subtract(Duration(minutes: 5));
        
        final cache = ActivePlanCache(
          userId: 'user-boundary',
          lastConfirmedAt: boundaryTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        // At exactly 5 minutes, it should be stale (>= 5 minutes)
        expect(cache.isFresh, false);
      });
      
      test('returns false for stale cache (older than 5 minutes)', () {
        final oldTime = DateTime.now().subtract(Duration(minutes: 6));
        
        final cache = ActivePlanCache(
          userId: 'user-stale',
          lastConfirmedAt: oldTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache.isFresh, false);
      });
      
      test('handles edge cases around minute boundaries', () {
        // Test 4 minutes 59 seconds (should be fresh)
        final almostStale = DateTime.now().subtract(
          Duration(minutes: 4, seconds: 59)
        );
        
        final cache1 = ActivePlanCache(
          userId: 'user-almost',
          lastConfirmedAt: almostStale,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache1.isFresh, true);
        
        // Test 5 minutes 1 second (should be stale)
        final definitelyStale = DateTime.now().subtract(
          Duration(minutes: 5, seconds: 1)
        );
        
        final cache2 = ActivePlanCache(
          userId: 'user-definitely',
          lastConfirmedAt: definitelyStale,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache2.isFresh, false);
      });
    });
    
    group('isUsable getter', () {
      test('returns true for recent cache (within 24 hours)', () {
        final recentTime = DateTime.now().subtract(Duration(hours: 12));
        
        final cache = ActivePlanCache(
          userId: 'user-usable',
          lastConfirmedAt: recentTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache.isUsable, true);
      });
      
      test('returns false for cache at boundary (exactly 24 hours)', () {
        final boundaryTime = DateTime.now().subtract(Duration(hours: 24));
        
        final cache = ActivePlanCache(
          userId: 'user-boundary-usable',
          lastConfirmedAt: boundaryTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache.isUsable, false);
      });
      
      test('returns false for very old cache (older than 24 hours)', () {
        final veryOldTime = DateTime.now().subtract(Duration(hours: 25));
        
        final cache = ActivePlanCache(
          userId: 'user-too-old',
          lastConfirmedAt: veryOldTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache.isUsable, false);
      });
      
      test('fresh cache is always usable', () {
        final cache = ActivePlanCache.confirmedActivePlan(
          userId: 'user-fresh-usable',
          activeMealPlanId: 'plan-fresh',
        );
        
        expect(cache.isFresh, true);
        expect(cache.isUsable, true);
      });
      
      test('stale but usable cache', () {
        final oldButUsableTime = DateTime.now().subtract(Duration(hours: 12));
        
        final cache = ActivePlanCache(
          userId: 'user-stale-usable',
          lastConfirmedAt: oldButUsableTime,
          confirmedNoActivePlan: false,
          updatedAt: DateTime.now(),
        );
        
        expect(cache.isFresh, false);
        expect(cache.isUsable, true);
      });
    });
    
    group('toString method', () {
      test('includes all relevant information', () {
        final cache = ActivePlanCache.confirmedActivePlan(
          userId: 'user-string',
          activeMealPlanId: 'plan-string',
        );
        
        final stringRepresentation = cache.toString();
        
        expect(stringRepresentation, contains('ActivePlanCache'));
        expect(stringRepresentation, contains('user-string'));
        expect(stringRepresentation, contains('plan-string'));
        expect(stringRepresentation, contains('false')); // confirmedNoActivePlan
        expect(stringRepresentation, contains('isFresh'));
        expect(stringRepresentation, contains('isUsable'));
      });
      
      test('handles null values correctly in string', () {
        final cache = ActivePlanCache.confirmedNoPlan(userId: null);
        
        final stringRepresentation = cache.toString();
        
        expect(stringRepresentation, contains('ActivePlanCache'));
        expect(stringRepresentation, contains('userId: null'));
        expect(stringRepresentation, contains('activePlanId: null'));
        expect(stringRepresentation, contains('true')); // confirmedNoActivePlan
      });
    });
    
    group('Realistic usage scenarios', () {
      test('simulates cache lifecycle for user with active plan', () {
        final userId = 'real-user-123';
        final planId = 'weekly-plan-001';
        
        // User initially has an active plan
        var cache = ActivePlanCache.confirmedActivePlan(
          userId: userId,
          activeMealPlanId: planId,
        );
        
        expect(cache.userId, userId);
        expect(cache.activeMealPlanId, planId);
        expect(cache.confirmedNoActivePlan, false);
        expect(cache.isFresh, true);
        expect(cache.isUsable, true);
        
        // Simulate time passing - cache becomes stale but usable
        final staleTime = DateTime.now().subtract(Duration(hours: 6));
        cache = ActivePlanCache(
          userId: userId,
          activeMealPlanId: planId,
          lastConfirmedAt: staleTime,
          confirmedNoActivePlan: false,
          updatedAt: staleTime,
        );
        
        expect(cache.isFresh, false);
        expect(cache.isUsable, true);
        
        // User's plan expires, server confirms no active plan
        cache = ActivePlanCache.confirmedNoPlan(userId: userId);
        
        expect(cache.userId, userId);
        expect(cache.activeMealPlanId, isNull);
        expect(cache.confirmedNoActivePlan, true);
        expect(cache.isFresh, true);
        expect(cache.isUsable, true);
      });
      
      test('simulates cache cleanup scenarios', () {
        final userId = 'cleanup-user';
        
        // Very old cache entry that should not be used
        final ancientTime = DateTime.now().subtract(Duration(days: 7));
        final ancientCache = ActivePlanCache(
          userId: userId,
          activeMealPlanId: 'old-plan',
          lastConfirmedAt: ancientTime,
          confirmedNoActivePlan: false,
          updatedAt: ancientTime,
        );
        
        expect(ancientCache.isFresh, false);
        expect(ancientCache.isUsable, false);
        
        // Fresh cache to replace the old one
        final freshCache = ActivePlanCache.confirmedActivePlan(
          userId: userId,
          activeMealPlanId: 'new-plan',
        );
        
        expect(freshCache.isFresh, true);
        expect(freshCache.isUsable, true);
        expect(freshCache.activeMealPlanId, 'new-plan');
      });
      
      test('handles offline/online scenarios', () {
        final userId = 'offline-user';
        
        // User goes offline, cache becomes stale but usable
        final offlineTime = DateTime.now().subtract(Duration(hours: 2));
        var cache = ActivePlanCache(
          userId: userId,
          activeMealPlanId: 'cached-plan',
          lastConfirmedAt: offlineTime,
          confirmedNoActivePlan: false,
          updatedAt: offlineTime,
        );
        
        expect(cache.isFresh, false);
        expect(cache.isUsable, true);
        
        // User comes back online, cache is refreshed
        cache = ActivePlanCache.confirmedActivePlan(
          userId: userId,
          activeMealPlanId: 'refreshed-plan',
        );
        
        expect(cache.isFresh, true);
        expect(cache.isUsable, true);
        expect(cache.activeMealPlanId, 'refreshed-plan');
      });
    });
    
    group('Edge cases and error conditions', () {
      test('handles future timestamps gracefully', () {
        final futureTime = DateTime.now().add(Duration(hours: 1));
        
        final cache = ActivePlanCache(
          userId: 'future-user',
          lastConfirmedAt: futureTime,
          confirmedNoActivePlan: false,
          updatedAt: futureTime,
        );
        
        // Future timestamps should be considered fresh and usable
        expect(cache.isFresh, true);
        expect(cache.isUsable, true);
      });
      
      test('handles extreme timestamp differences', () {
        // Very old timestamp
        final ancientTime = DateTime(1900, 1, 1);
        final ancientCache = ActivePlanCache(
          userId: 'ancient-user',
          lastConfirmedAt: ancientTime,
          confirmedNoActivePlan: false,
          updatedAt: ancientTime,
        );
        
        expect(ancientCache.isFresh, false);
        expect(ancientCache.isUsable, false);
        
        // Far future timestamp
        final futuristic = DateTime(2100, 12, 31);
        final futureCache = ActivePlanCache(
          userId: 'future-user',
          lastConfirmedAt: futuristic,
          confirmedNoActivePlan: false,
          updatedAt: futuristic,
        );
        
        expect(futureCache.isFresh, true);
        expect(futureCache.isUsable, true);
      });
      
      test('validates different combinations of plan states', () {
        // Active plan with confirmedNoActivePlan=true (inconsistent but handled)
        final inconsistentCache = ActivePlanCache(
          userId: 'inconsistent-user',
          activeMealPlanId: 'some-plan',
          lastConfirmedAt: DateTime.now(),
          confirmedNoActivePlan: true, // Contradicts having an active plan
          updatedAt: DateTime.now(),
        );
        
        expect(inconsistentCache.activeMealPlanId, 'some-plan');
        expect(inconsistentCache.confirmedNoActivePlan, true);
        // The model stores the values as provided without validation
      });
    });
  });
}