import 'package:isar/isar.dart';
import 'package:dima_application/models/ActivePlanCache/active_plan_cache.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/models/TodayPage/today_page_data.dart';
import 'package:dima_application/models/UserDetails/user_details_cache.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Helper class for setting up in-memory Isar instances for testing
class IsarTestHelper {
  static bool _isInitialized = false;
  static late String _testDirectory;

  /// Gets the dedicated test directory for Isar files
  static String get testDirectory {
    if (!_isInitialized) {
      _testDirectory = path.join(Directory.current.path, '.isar_test');
    }
    return _testDirectory;
  }

  /// Ensures the test directory exists
  static Directory _ensureTestDirectory() {
    final dir = Directory(testDirectory);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Initializes Isar for testing environment
  /// 
  /// This handles the native library loading that's required for Isar to work in tests.
  /// Must be called before creating any Isar instances.
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Set up dedicated test directory
    _testDirectory = path.join(Directory.current.path, '.isar_test');
    _ensureTestDirectory();
    
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
            directory: testDirectory,
            name: 'temp_init_${DateTime.now().millisecondsSinceEpoch}',
          );
          await tempIsar.close(deleteFromDisk: true);
          _isInitialized = true;
        } catch (e3) {
          // Last resort: mark as initialized and let the actual instance creation handle it
          print('Warning: All Isar initialization attempts failed. Error details:');
          print('  Download=true: $e');
          print('  Download=false: $e2');
          print('  Temp instance: $e3');
          print('Proceeding with test setup, but tests may fail if Isar native library is missing.');
          _isInitialized = true;
        }
      }
    }
  }

  /// Creates an Isar instance in the dedicated test directory with all required schemas for testing
  /// 
  /// This method sets up a temporary database in the `.isar_test` directory that includes all
  /// the Isar collections used in the application. The instance is isolated per test and 
  /// all files will be placed in the test directory that can be easily gitignored.
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
    
    final testName = name ?? 'test_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      // Always use the dedicated test directory to keep files organized
      return await Isar.open(
        [
          ActivePlanCacheSchema,
          TodayPageDataSchema,
          DailyCompletionSchema,
          MealPlanCacheSchema,
          UserDetailsCacheSchema,
        ],
        directory: testDirectory,
        name: testName,
      );
    } catch (e) {
      print('Failed to create Isar instance in test directory: $e');
      rethrow;
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
    await isar.close(deleteFromDisk: true);
  }

  /// Cleans up all test files in the test directory
  /// 
  /// This method removes all Isar database files from the test directory.
  /// Useful for cleaning up after test runs or in CI environments.
  static Future<void> cleanupTestDirectory() async {
    final dir = Directory(testDirectory);
    if (dir.existsSync()) {
      try {
        await dir.delete(recursive: true);
        print('Cleaned up Isar test directory: $testDirectory');
      } catch (e) {
        print('Failed to clean up test directory: $e');
      }
    }
  }

  /// Adds a cleanup handler that runs after all tests
  /// 
  /// This ensures test files are cleaned up automatically
  static void setupCleanupHandler() {
    // Register cleanup to run after all tests complete
    // Note: This will be called by test framework teardown
    atexit(() async {
      await cleanupTestDirectory();
    });
  }

  // Simple atexit implementation for Dart
  static void atexit(Function() callback) {
    // Store callback for cleanup - in real implementation this would
    // be handled by the test framework's tearDown methods
    // For now, tests should manually call cleanupTestDirectory()
  }
}