import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyCompletion', () {
    group('Constructor and initialization', () {
      test('creates DailyCompletion with required parameters', () {
        final planId = 'plan-123';
        final date = DateTime.now();
        final latestUpdate = DateTime.now();
        
        final completion = DailyCompletion(
          planId: planId,
          date: date,
          latestUpdate: latestUpdate,
        );
        
        expect(completion.planId, planId);
        expect(completion.date, DailyCompletion.dateOnly(date));
        expect(completion.completedMealNames, isEmpty);
        expect(completion.latestUpdate, latestUpdate);
      });
      
      test('creates DailyCompletion with all parameters', () {
        final planId = 'plan-123';
        final date = DateTime.now();
        final latestUpdate = DateTime.now();
        final completedMeals = [MealNameEnum.BREAKFAST, MealNameEnum.LUNCH];
        
        final completion = DailyCompletion(
          planId: planId,
          date: date,
          latestUpdate: latestUpdate,
          completedMealNames: completedMeals,
        );
        
        expect(completion.planId, planId);
        expect(completion.date, DailyCompletion.dateOnly(date));
        expect(completion.completedMealNames, completedMeals);
        expect(completion.latestUpdate, latestUpdate);
      });
      
      test('normalizes date to remove time component', () {
        final date = DateTime(2023, 12, 25, 14, 30, 45, 123); // With time
        final expectedDate = DateTime(2023, 12, 25); // Without time
        
        final completion = DailyCompletion(
          planId: 'plan-123',
          date: date,
          latestUpdate: DateTime.now(),
        );
        
        expect(completion.date, expectedDate);
        expect(completion.date.hour, 0);
        expect(completion.date.minute, 0);
        expect(completion.date.second, 0);
        expect(completion.date.millisecond, 0);
      });
    });
    
    group('Factory constructor forDate', () {
      test('creates DailyCompletion with factory method', () {
        final planId = 'plan-456';
        final date = DateTime.now();
        final completedMeals = [MealNameEnum.DINNER];
        
        final completion = DailyCompletion.forDate(
          planId: planId,
          date: date,
          completedMeals: completedMeals,
        );
        
        expect(completion.planId, planId);
        expect(completion.date, DailyCompletion.dateOnly(date));
        expect(completion.completedMealNames, completedMeals);
        expect(completion.latestUpdate, isA<DateTime>());
      });
      
      test('uses provided latestUpdate when specified', () {
        final planId = 'plan-789';
        final date = DateTime.now();
        final specificUpdate = DateTime(2023, 1, 1, 12, 0, 0);
        
        final completion = DailyCompletion.forDate(
          planId: planId,
          date: date,
          latestUpdate: specificUpdate,
        );
        
        expect(completion.latestUpdate, specificUpdate);
      });
      
      test('uses current time as default latestUpdate', () {
        final planId = 'plan-default';
        final date = DateTime.now();
        final beforeCreation = DateTime.now();
        
        final completion = DailyCompletion.forDate(
          planId: planId,
          date: date,
        );
        
        final afterCreation = DateTime.now();
        
        expect(completion.latestUpdate.isAfter(beforeCreation) || 
               completion.latestUpdate.isAtSameMomentAs(beforeCreation), isTrue);
        expect(completion.latestUpdate.isBefore(afterCreation) || 
               completion.latestUpdate.isAtSameMomentAs(afterCreation), isTrue);
      });
      
      test('defaults to empty completed meals list', () {
        final completion = DailyCompletion.forDate(
          planId: 'plan-empty',
          date: DateTime.now(),
        );
        
        expect(completion.completedMealNames, isEmpty);
      });
    });
    
    group('dateOnly helper method', () {
      test('removes time component from DateTime', () {
        final originalDate = DateTime(2023, 6, 15, 9, 30, 45, 678);
        final dateOnly = DailyCompletion.dateOnly(originalDate);
        
        expect(dateOnly.year, 2023);
        expect(dateOnly.month, 6);
        expect(dateOnly.day, 15);
        expect(dateOnly.hour, 0);
        expect(dateOnly.minute, 0);
        expect(dateOnly.second, 0);
        expect(dateOnly.millisecond, 0);
        expect(dateOnly.microsecond, 0);
      });
      
      test('handles edge cases correctly', () {
        // Test leap year date
        final leapYearDate = DateTime(2024, 2, 29, 23, 59, 59);
        final leapDateOnly = DailyCompletion.dateOnly(leapYearDate);
        expect(leapDateOnly, DateTime(2024, 2, 29));
        
        // Test end of year
        final endOfYear = DateTime(2023, 12, 31, 23, 59, 59);
        final endDateOnly = DailyCompletion.dateOnly(endOfYear);
        expect(endDateOnly, DateTime(2023, 12, 31));
        
        // Test beginning of year
        final beginYear = DateTime(2024, 1, 1, 0, 0, 1);
        final beginDateOnly = DailyCompletion.dateOnly(beginYear);
        expect(beginDateOnly, DateTime(2024, 1, 1));
      });
    });
    
    group('Completed meals management', () {
      test('handles empty completed meals list', () {
        final completion = DailyCompletion.forDate(
          planId: 'plan-empty',
          date: DateTime.now(),
        );
        
        expect(completion.completedMealNames, isEmpty);
        expect(completion.completedMealNames.length, 0);
      });
      
      test('handles single completed meal', () {
        final completion = DailyCompletion.forDate(
          planId: 'plan-single',
          date: DateTime.now(),
          completedMeals: [MealNameEnum.BREAKFAST],
        );
        
        expect(completion.completedMealNames, [MealNameEnum.BREAKFAST]);
        expect(completion.completedMealNames.length, 1);
      });
      
      test('handles multiple completed meals', () {
        final meals = [
          MealNameEnum.BREAKFAST,
          MealNameEnum.LUNCH,
          MealNameEnum.DINNER,
          MealNameEnum.SNACK_AFTERNOON,
        ];
        
        final completion = DailyCompletion.forDate(
          planId: 'plan-multiple',
          date: DateTime.now(),
          completedMeals: meals,
        );
        
        expect(completion.completedMealNames, meals);
        expect(completion.completedMealNames.length, 4);
      });
      
      test('handles duplicate meals in list', () {
        final mealsWithDuplicates = [
          MealNameEnum.BREAKFAST,
          MealNameEnum.LUNCH,
          MealNameEnum.BREAKFAST, // Duplicate
        ];
        
        final completion = DailyCompletion.forDate(
          planId: 'plan-duplicates',
          date: DateTime.now(),
          completedMeals: mealsWithDuplicates,
        );
        
        // Note: The model doesn't prevent duplicates, it stores what's given
        expect(completion.completedMealNames, mealsWithDuplicates);
        expect(completion.completedMealNames.length, 3);
        expect(completion.completedMealNames.where((meal) => meal == MealNameEnum.BREAKFAST).length, 2);
      });
    });
    
    group('Date handling edge cases', () {
      test('handles different time zones consistently', () {
        // Create dates that are the same day but different times
        final morningDate = DateTime(2023, 7, 20, 8, 0);
        final eveningDate = DateTime(2023, 7, 20, 20, 0);
        
        final morningCompletion = DailyCompletion.forDate(
          planId: 'plan-morning',
          date: morningDate,
        );
        
        final eveningCompletion = DailyCompletion.forDate(
          planId: 'plan-evening',
          date: eveningDate,
        );
        
        expect(morningCompletion.date, eveningCompletion.date);
        expect(morningCompletion.date, DateTime(2023, 7, 20));
      });
      
      test('handles midnight boundary correctly', () {
        final beforeMidnight = DateTime(2023, 7, 20, 23, 59, 59);
        final atMidnight = DateTime(2023, 7, 21, 0, 0, 0);
        final afterMidnight = DateTime(2023, 7, 21, 0, 0, 1);
        
        expect(DailyCompletion.dateOnly(beforeMidnight), DateTime(2023, 7, 20));
        expect(DailyCompletion.dateOnly(atMidnight), DateTime(2023, 7, 21));
        expect(DailyCompletion.dateOnly(afterMidnight), DateTime(2023, 7, 21));
      });
    });
    
    group('Realistic usage scenarios', () {
      test('can simulate daily meal completion tracking', () {
        final planId = 'weekly-plan-001';
        final today = DateTime.now();
        
        // Start with empty completion
        var completion = DailyCompletion.forDate(
          planId: planId,
          date: today,
        );
        
        expect(completion.completedMealNames, isEmpty);
        
        // Simulate adding breakfast
        final breakfastTime = DateTime.now();
        completion = DailyCompletion.forDate(
          planId: planId,
          date: today,
          completedMeals: [MealNameEnum.BREAKFAST],
          latestUpdate: breakfastTime,
        );
        
        expect(completion.completedMealNames, [MealNameEnum.BREAKFAST]);
        expect(completion.latestUpdate, breakfastTime);
        
        // Simulate adding lunch
        final lunchTime = DateTime.now().add(Duration(hours: 4));
        completion = DailyCompletion.forDate(
          planId: planId,
          date: today,
          completedMeals: [MealNameEnum.BREAKFAST, MealNameEnum.LUNCH],
          latestUpdate: lunchTime,
        );
        
        expect(completion.completedMealNames.length, 2);
        expect(completion.completedMealNames, contains(MealNameEnum.BREAKFAST));
        expect(completion.completedMealNames, contains(MealNameEnum.LUNCH));
        expect(completion.latestUpdate, lunchTime);
      });
      
      test('maintains plan isolation', () {
        final date = DateTime.now();
        
        final plan1Completion = DailyCompletion.forDate(
          planId: 'plan-1',
          date: date,
          completedMeals: [MealNameEnum.BREAKFAST],
        );
        
        final plan2Completion = DailyCompletion.forDate(
          planId: 'plan-2',
          date: date,
          completedMeals: [MealNameEnum.LUNCH, MealNameEnum.DINNER],
        );
        
        // Different plans should have different completion states
        expect(plan1Completion.planId, 'plan-1');
        expect(plan2Completion.planId, 'plan-2');
        expect(plan1Completion.completedMealNames.length, 1);
        expect(plan2Completion.completedMealNames.length, 2);
        expect(plan1Completion.date, plan2Completion.date); // Same day
      });
    });
    
    group('Data validation', () {
      test('handles extreme dates', () {
        // Test very old date
        final oldDate = DateTime(1900, 1, 1);
        final oldCompletion = DailyCompletion.forDate(
          planId: 'old-plan',
          date: oldDate,
        );
        expect(oldCompletion.date, DateTime(1900, 1, 1));
        
        // Test future date
        final futureDate = DateTime(2100, 12, 31);
        final futureCompletion = DailyCompletion.forDate(
          planId: 'future-plan',
          date: futureDate,
        );
        expect(futureCompletion.date, DateTime(2100, 12, 31));
      });
      
      test('handles all MealNameEnum values', () {
        final allMeals = MealNameEnum.values;
        
        final completion = DailyCompletion.forDate(
          planId: 'all-meals-plan',
          date: DateTime.now(),
          completedMeals: allMeals,
        );
        
        expect(completion.completedMealNames.length, allMeals.length);
        for (final meal in allMeals) {
          expect(completion.completedMealNames, contains(meal));
        }
      });
    });
  });
}