import 'package:isar/isar.dart';
import 'package:dima_application/models/ActivePlanCache/active_plan_cache.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/models/TodayPage/today_page_data.dart';
import 'package:dima_application/models/UserDetails/user_details_cache.dart';
import 'dart:io';

/// Helper class for setting up in-memory Isar instances for testing
class IsarTestHelper {
  static bool _isInitialized = false;

  /// Initializes Isar for testing environment
  ///
  /// This handles the native library loading that's required for Isar to work in tests.
  /// Must be called before creating any Isar instances.
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // First try to initialize with download enabled
      await Isar.initializeIsarCore(download: true);
      _isInitialized = true;
    } catch (e) {
      try {
        // If that fails, try without auto-download
        await Isar.initializeIsarCore(download: false);
        _isInitialized = true;
      } catch (e2) {
        // If both fail, try manual initialization
        try {
          // Try to create a temporary instance to force initialization
          final tempIsar = await Isar.open(
            [],
            directory: Platform.isWindows ? Directory.systemTemp.path : '',
            name: 'temp_init_${DateTime.now().millisecondsSinceEpoch}',
          );
          await tempIsar.close(deleteFromDisk: true);
          _isInitialized = true;
        } catch (e3) {
          // Last resort: mark as initialized and let the actual instance creation handle it
          print(
              'Warning: All Isar initialization attempts failed. Error details:');
          print('  Download=true: $e');
          print('  Download=false: $e2');
          print('  Temp instance: $e3');
          print(
              'Proceeding with test setup, but tests may fail if Isar native library is missing.');
          _isInitialized = true;
        }
      }
    }
  }

  /// Creates an in-memory Isar instance with all required schemas for testing
  ///
  /// This method sets up a temporary in-memory database that includes all
  /// the Isar collections used in the application. The instance is isolated
  /// per test and will be automatically cleaned up when the test completes.
  ///
  /// Usage:
  /// ```dart
  /// setUp(() async {
  ///   isar = await IsarTestHelper.createTestIsar();
  /// });
  ///
  /// tearDown(() async {
  ///   await IsarTestHelper.closeTestIsar(isar);
  /// });
  /// ```
  static Future<Isar> createTestIsar({String? name}) async {
    await initialize();

    try {
      // First try with empty directory for in-memory database
      return await Isar.open(
        [
          ActivePlanCacheSchema,
          TodayPageDataSchema,
          DailyCompletionSchema,
          MealPlanCacheSchema,
          UserDetailsCacheSchema,
        ],
        directory: '', // Empty string creates in-memory database
        name: name ?? 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      // If in-memory fails, try with temp directory
      final tempDir = Directory.systemTemp.createTempSync('isar_test_');
      try {
        return await Isar.open(
          [
            ActivePlanCacheSchema,
            TodayPageDataSchema,
            DailyCompletionSchema,
            MealPlanCacheSchema,
            UserDetailsCacheSchema,
          ],
          directory: tempDir.path,
          name: name ?? 'test_${DateTime.now().millisecondsSinceEpoch}',
        );
      } catch (e2) {
        // Clean up temp directory if creation failed
        try {
          tempDir.deleteSync(recursive: true);
        } catch (_) {}
        rethrow;
      }
    }
  }

  /// Creates a test Isar instance and clears all data
  ///
  /// This is useful when you want to ensure a completely clean state
  /// for your tests.
  static Future<Isar> createCleanTestIsar({String? name}) async {
    final isar = await createTestIsar(name: name);
    await clearAllCollections(isar);
    return isar;
  }

  /// Clears all data from all collections in the given Isar instance
  static Future<void> clearAllCollections(Isar isar) async {
    await isar.writeTxn(() async {
      await isar.activePlanCaches.clear();
      await isar.todayPageDatas.clear();
      await isar.dailyCompletions.clear();
      await isar.mealPlanCaches.clear();
      await isar.userDetailsCaches.clear();
    });
  }

  /// Closes the Isar instance and cleans up resources
  ///
  /// Should be called in tearDown() of tests
  static Future<void> closeTestIsar(Isar isar) async {
    if (!isar.isOpen) return;
    await isar.close();
  }
}
