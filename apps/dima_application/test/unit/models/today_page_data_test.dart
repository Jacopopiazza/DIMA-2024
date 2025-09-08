import 'package:dima_application/models/TodayPage/today_page_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('TodayPageData', () {
    group('Constructor and initialization', () {
      test('creates TodayPageData with all required parameters', () {
        final calories = '2500';
        final fatPercent = 25.5;
        final proteinPercent = 30.0;
        final carbPercent = 44.5;
        final lunchImageUrl = 'https://example.com/lunch.jpg';
        final dinnerImageUrl = 'https://example.com/dinner.jpg';
        final lastUpdated = DateTime.now();
        
        final todayData = TodayPageData(
          calories: calories,
          fatPercent: fatPercent,
          proteinPercent: proteinPercent,
          carbPercent: carbPercent,
          lunchImageUrl: lunchImageUrl,
          dinnerImageUrl: dinnerImageUrl,
          lastUpdated: lastUpdated,
        );
        
        expect(todayData.calories, calories);
        expect(todayData.fatPercent, fatPercent);
        expect(todayData.proteinPercent, proteinPercent);
        expect(todayData.carbPercent, carbPercent);
        expect(todayData.lunchImageUrl, lunchImageUrl);
        expect(todayData.dinnerImageUrl, dinnerImageUrl);
        expect(todayData.lastUpdated, lastUpdated);
        expect(todayData.id, 0); // Default Isar autoIncrement
      });
      
      test('creates TodayPageData with numeric values', () {
        final todayData = TodayPageData(
          calories: '1800',
          fatPercent: 20.0,
          proteinPercent: 25.0,
          carbPercent: 55.0,
          lunchImageUrl: 'lunch.png',
          dinnerImageUrl: 'dinner.png',
          lastUpdated: DateTime(2023, 12, 25),
        );
        
        expect(todayData.fatPercent + todayData.proteinPercent + todayData.carbPercent, 100.0);
        expect(todayData.calories, '1800');
      });
    });
    
    group('Empty constructor', () {
      test('creates TodayPageData with empty constructor and default values', () {
        final todayData = TodayPageData.empty();
        
        expect(todayData.id, 0);
        expect(todayData.calories, '0');
        expect(todayData.fatPercent, 0.0);
        expect(todayData.proteinPercent, 0.0);
        expect(todayData.carbPercent, 0.0);
        expect(todayData.lunchImageUrl, '');
        expect(todayData.dinnerImageUrl, '');
        expect(todayData.lastUpdated, DateTime.fromMillisecondsSinceEpoch(0));
      });
      
      test('empty constructor creates epoch timestamp', () {
        final todayData = TodayPageData.empty();
        final epochDateTime = DateTime.fromMillisecondsSinceEpoch(0);
        
        expect(todayData.lastUpdated, epochDateTime);
        expect(todayData.lastUpdated.year, 1970);
        expect(todayData.lastUpdated.month, 1);
        expect(todayData.lastUpdated.day, 1);
      });
    });
    
    group('toString method', () {
      test('includes all relevant information in string representation', () {
        final todayData = TodayPageData(
          calories: '2200',
          fatPercent: 30.0,
          proteinPercent: 20.0,
          carbPercent: 50.0,
          lunchImageUrl: 'lunch.jpg',
          dinnerImageUrl: 'dinner.jpg',
          lastUpdated: DateTime(2023, 6, 15, 12, 30),
        );
        
        final stringRepresentation = todayData.toString();
        
        expect(stringRepresentation, contains('TodayPageData'));
        expect(stringRepresentation, contains('calories: 2200'));
        expect(stringRepresentation, contains('fat: 30.0'));
        expect(stringRepresentation, contains('pro: 20.0'));
        expect(stringRepresentation, contains('carb: 50.0'));
        expect(stringRepresentation, contains('lastUpdated:'));
      });
      
      test('toString handles empty values correctly', () {
        final todayData = TodayPageData.empty();
        final stringRepresentation = todayData.toString();
        
        expect(stringRepresentation, contains('calories: 0'));
        expect(stringRepresentation, contains('fat: 0.0'));
        expect(stringRepresentation, contains('pro: 0.0'));
        expect(stringRepresentation, contains('carb: 0.0'));
      });
    });
    
    group('Macronutrient calculations', () {
      test('validates macronutrient percentages add up to 100', () {
        final todayData = TodayPageData(
          calories: '2000',
          fatPercent: 25.0,
          proteinPercent: 30.0,
          carbPercent: 45.0,
          lunchImageUrl: 'lunch.jpg',
          dinnerImageUrl: 'dinner.jpg',
          lastUpdated: DateTime.now(),
        );
        
        final totalPercent = todayData.fatPercent + todayData.proteinPercent + todayData.carbPercent;
        expect(totalPercent, 100.0);
      });
      
      test('handles decimal precision in macronutrients', () {
        final todayData = TodayPageData(
          calories: '1950',
          fatPercent: 33.33,
          proteinPercent: 33.33,
          carbPercent: 33.34,
          lunchImageUrl: 'test.jpg',
          dinnerImageUrl: 'test2.jpg',
          lastUpdated: DateTime.now(),
        );
        
        final totalPercent = todayData.fatPercent + todayData.proteinPercent + todayData.carbPercent;
        expect(totalPercent, closeTo(100.0, 0.01));
      });
      
      test('supports various calorie ranges', () {
        final lowCalorie = TodayPageData(
          calories: '1200',
          fatPercent: 35.0,
          proteinPercent: 25.0,
          carbPercent: 40.0,
          lunchImageUrl: 'low.jpg',
          dinnerImageUrl: 'low2.jpg',
          lastUpdated: DateTime.now(),
        );
        
        final highCalorie = TodayPageData(
          calories: '3500',
          fatPercent: 20.0,
          proteinPercent: 30.0,
          carbPercent: 50.0,
          lunchImageUrl: 'high.jpg',
          dinnerImageUrl: 'high2.jpg',
          lastUpdated: DateTime.now(),
        );
        
        expect(int.parse(lowCalorie.calories), lessThan(int.parse(highCalorie.calories)));
        expect(lowCalorie.fatPercent, greaterThan(highCalorie.fatPercent));
      });
    });
    
    group('Image URL handling', () {
      test('handles various URL formats', () {
        final urlFormats = [
          'https://example.com/image.jpg',
          'http://localhost:3000/lunch.png',
          'file:///path/to/local/image.gif',
          'data:image/jpeg;base64,abc123',
          'image.jpg', // Relative path
          '', // Empty string
        ];
        
        for (int i = 0; i < urlFormats.length; i++) {
          final todayData = TodayPageData(
            calories: '2000',
            fatPercent: 25.0,
            proteinPercent: 25.0,
            carbPercent: 50.0,
            lunchImageUrl: urlFormats[i],
            dinnerImageUrl: urlFormats[(i + 1) % urlFormats.length],
            lastUpdated: DateTime.now(),
          );
          
          expect(todayData.lunchImageUrl, urlFormats[i]);
          expect(todayData.dinnerImageUrl, urlFormats[(i + 1) % urlFormats.length]);
        }
      });
      
      test('handles empty and null-like image URLs', () {
        final todayData = TodayPageData(
          calories: '1500',
          fatPercent: 30.0,
          proteinPercent: 20.0,
          carbPercent: 50.0,
          lunchImageUrl: '',
          dinnerImageUrl: '',
          lastUpdated: DateTime.now(),
        );
        
        expect(todayData.lunchImageUrl, isEmpty);
        expect(todayData.dinnerImageUrl, isEmpty);
      });
    });
    
    group('DateTime handling', () {
      test('handles different timestamp scenarios', () {
        final now = DateTime.now();
        final past = DateTime.now().subtract(Duration(days: 7));
        final future = DateTime.now().add(Duration(hours: 2));
        
        final scenarios = [now, past, future];
        
        for (final timestamp in scenarios) {
          final todayData = TodayPageData(
            calories: '2000',
            fatPercent: 25.0,
            proteinPercent: 25.0,
            carbPercent: 50.0,
            lunchImageUrl: 'lunch.jpg',
            dinnerImageUrl: 'dinner.jpg',
            lastUpdated: timestamp,
          );
          
          expect(todayData.lastUpdated, timestamp);
        }
      });
      
      test('handles extreme date values', () {
        final veryOldDate = DateTime(1900, 1, 1);
        final veryFutureDate = DateTime(2100, 12, 31);
        
        final oldData = TodayPageData(
          calories: '1000',
          fatPercent: 20.0,
          proteinPercent: 30.0,
          carbPercent: 50.0,
          lunchImageUrl: 'old.jpg',
          dinnerImageUrl: 'old2.jpg',
          lastUpdated: veryOldDate,
        );
        
        final futureData = TodayPageData(
          calories: '3000',
          fatPercent: 25.0,
          proteinPercent: 25.0,
          carbPercent: 50.0,
          lunchImageUrl: 'future.jpg',
          dinnerImageUrl: 'future2.jpg',
          lastUpdated: veryFutureDate,
        );
        
        expect(oldData.lastUpdated.year, 1900);
        expect(futureData.lastUpdated.year, 2100);
        expect(oldData.lastUpdated.isBefore(futureData.lastUpdated), true);
      });
    });
    
    group('Realistic usage scenarios', () {
      test('simulates daily data update workflow', () {
        // Start with empty data
        var todayData = TodayPageData.empty();
        expect(todayData.calories, '0');
        
        // Simulate morning update with breakfast data
        todayData = TodayPageData(
          calories: '400',
          fatPercent: 35.0,
          proteinPercent: 15.0,
          carbPercent: 50.0,
          lunchImageUrl: '',
          dinnerImageUrl: '',
          lastUpdated: DateTime(2023, 12, 25, 9, 0),
        );
        
        expect(int.parse(todayData.calories), 400);
        expect(todayData.lastUpdated.hour, 9);
        
        // Simulate lunch update
        todayData = TodayPageData(
          calories: '1200',
          fatPercent: 30.0,
          proteinPercent: 25.0,
          carbPercent: 45.0,
          lunchImageUrl: 'healthy_lunch.jpg',
          dinnerImageUrl: '',
          lastUpdated: DateTime(2023, 12, 25, 13, 30),
        );
        
        expect(int.parse(todayData.calories), 1200);
        expect(todayData.lunchImageUrl, isNotEmpty);
        expect(todayData.dinnerImageUrl, isEmpty);
        
        // Simulate dinner update - end of day
        todayData = TodayPageData(
          calories: '2100',
          fatPercent: 25.0,
          proteinPercent: 30.0,
          carbPercent: 45.0,
          lunchImageUrl: 'healthy_lunch.jpg',
          dinnerImageUrl: 'balanced_dinner.jpg',
          lastUpdated: DateTime(2023, 12, 25, 19, 45),
        );
        
        expect(int.parse(todayData.calories), 2100);
        expect(todayData.lunchImageUrl, isNotEmpty);
        expect(todayData.dinnerImageUrl, isNotEmpty);
        expect(todayData.lastUpdated.hour, 19);
      });
      
      test('represents different dietary patterns', () {
        // High protein diet
        final highProteinDay = TodayPageData(
          calories: '2200',
          fatPercent: 20.0,
          proteinPercent: 40.0,
          carbPercent: 40.0,
          lunchImageUrl: 'protein_lunch.jpg',
          dinnerImageUrl: 'protein_dinner.jpg',
          lastUpdated: DateTime.now(),
        );
        
        // Low carb diet
        final lowCarbDay = TodayPageData(
          calories: '1800',
          fatPercent: 60.0,
          proteinPercent: 30.0,
          carbPercent: 10.0,
          lunchImageUrl: 'keto_lunch.jpg',
          dinnerImageUrl: 'keto_dinner.jpg',
          lastUpdated: DateTime.now(),
        );
        
        // Balanced diet
        final balancedDay = TodayPageData(
          calories: '2000',
          fatPercent: 25.0,
          proteinPercent: 25.0,
          carbPercent: 50.0,
          lunchImageUrl: 'balanced_lunch.jpg',
          dinnerImageUrl: 'balanced_dinner.jpg',
          lastUpdated: DateTime.now(),
        );
        
        expect(highProteinDay.proteinPercent, greaterThan(balancedDay.proteinPercent));
        expect(lowCarbDay.fatPercent, greaterThan(highProteinDay.fatPercent));
        expect(lowCarbDay.carbPercent, lessThan(balancedDay.carbPercent));
      });
    });
    
    group('Edge cases and validation', () {
      test('handles extreme calorie values', () {
        final veryLowCalories = TodayPageData(
          calories: '500',
          fatPercent: 40.0,
          proteinPercent: 30.0,
          carbPercent: 30.0,
          lunchImageUrl: 'low.jpg',
          dinnerImageUrl: 'low2.jpg',
          lastUpdated: DateTime.now(),
        );
        
        final veryHighCalories = TodayPageData(
          calories: '5000',
          fatPercent: 30.0,
          proteinPercent: 20.0,
          carbPercent: 50.0,
          lunchImageUrl: 'high.jpg',
          dinnerImageUrl: 'high2.jpg',
          lastUpdated: DateTime.now(),
        );
        
        expect(int.parse(veryLowCalories.calories), lessThan(1000));
        expect(int.parse(veryHighCalories.calories), greaterThan(4000));
      });
      
      test('handles zero and negative-like values appropriately', () {
        final zeroCalories = TodayPageData(
          calories: '0',
          fatPercent: 0.0,
          proteinPercent: 0.0,
          carbPercent: 0.0,
          lunchImageUrl: '',
          dinnerImageUrl: '',
          lastUpdated: DateTime.now(),
        );
        
        expect(zeroCalories.calories, '0');
        expect(zeroCalories.fatPercent, 0.0);
        expect(zeroCalories.proteinPercent, 0.0);
        expect(zeroCalories.carbPercent, 0.0);
      });
      
      test('handles very long image URLs', () {
        final longUrl = 'https://example.com/' + 'a' * 1000 + '.jpg';
        
        final todayData = TodayPageData(
          calories: '2000',
          fatPercent: 25.0,
          proteinPercent: 25.0,
          carbPercent: 50.0,
          lunchImageUrl: longUrl,
          dinnerImageUrl: longUrl,
          lastUpdated: DateTime.now(),
        );
        
        expect(todayData.lunchImageUrl.length, greaterThan(1000));
        expect(todayData.dinnerImageUrl, longUrl);
      });
      
      test('validates fixed ID behavior', () {
        final data1 = TodayPageData.empty();
        final data2 = TodayPageData(
          calories: '1000',
          fatPercent: 25.0,
          proteinPercent: 25.0,
          carbPercent: 50.0,
          lunchImageUrl: 'test.jpg',
          dinnerImageUrl: 'test2.jpg',
          lastUpdated: DateTime.now(),
        );
        
        // Both should have the same fixed ID for single-entry cache
        expect(data1.id, 0);
        expect(data2.id, 0);
        expect(data1.id, data2.id);
      });
    });
  });
}