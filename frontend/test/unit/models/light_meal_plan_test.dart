import 'package:amplify_core/amplify_core.dart' show TemporalDateTime;
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/MealPlanList/meal_plan_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LightMealPlan', () {
    group('Constructor and initialization', () {
      test('creates LightMealPlan with required parameters', () {
        final mealPlanId = 'light-plan-123';

        final lightPlan = LightMealPlan(mealPlanId: mealPlanId);

        expect(lightPlan.mealPlanId, mealPlanId);
        expect(lightPlan.planName, isNull);
        expect(lightPlan.updatedAt, isNull);
        expect(lightPlan.startDate, isNull);
        expect(lightPlan.endDate, isNull);
        expect(lightPlan.errorDetails, isNull);
        expect(lightPlan.status, isNull);
        expect(lightPlan.validationStatus, isNull);
      });

      test('creates LightMealPlan with all parameters', () {
        final mealPlanId = 'light-plan-full';
        final planName = 'Complete Light Plan';
        final updatedAt = DateTime.now();
        final startDate = DateTime.now();
        final endDate = DateTime.now().add(Duration(days: 7));
        final errorDetails = 'Test error details';
        final status = PlanStatus.ACTIVE;
        final validationStatus = MealPlanValidationStatus.VALIDATED;

        final lightPlan = LightMealPlan(
          mealPlanId: mealPlanId,
          planName: planName,
          updatedAt: updatedAt,
          startDate: startDate,
          endDate: endDate,
          errorDetails: errorDetails,
          status: status,
          validationStatus: validationStatus,
        );

        expect(lightPlan.mealPlanId, mealPlanId);
        expect(lightPlan.planName, planName);
        expect(lightPlan.updatedAt, updatedAt);
        expect(lightPlan.startDate, startDate);
        expect(lightPlan.endDate, endDate);
        expect(lightPlan.errorDetails, errorDetails);
        expect(lightPlan.status, status);
        expect(lightPlan.validationStatus, validationStatus);
      });
    });

    group('Factory constructor fromJson', () {
      test('creates LightMealPlan from complete JSON', () {
        final json = {
          'mealPlanId': 'json-plan-123',
          'planName': 'JSON Plan',
          'updatedAt': '2023-12-25T10:30:00.000Z',
          'startDate': '2023-12-20T00:00:00.000Z',
          'endDate': '2023-12-27T23:59:59.999Z',
          'status': 'ACTIVE',
          'validationStatus': 'VALIDATED',
          'errorDetails': 'No errors',
        };

        final lightPlan = LightMealPlan.fromJson(json);

        expect(lightPlan.mealPlanId, 'json-plan-123');
        expect(lightPlan.planName, 'JSON Plan');
        expect(lightPlan.updatedAt, DateTime.parse('2023-12-25T10:30:00.000Z'));
        expect(lightPlan.startDate, DateTime.parse('2023-12-20T00:00:00.000Z'));
        expect(lightPlan.endDate, DateTime.parse('2023-12-27T23:59:59.999Z'));
        expect(lightPlan.status, PlanStatus.ACTIVE);
        expect(lightPlan.validationStatus, MealPlanValidationStatus.VALIDATED);
        expect(lightPlan.errorDetails, 'No errors');
      });

      test('creates LightMealPlan from minimal JSON', () {
        final json = {
          'mealPlanId': 'minimal-plan',
        };

        final lightPlan = LightMealPlan.fromJson(json);

        expect(lightPlan.mealPlanId, 'minimal-plan');
        expect(lightPlan.planName, isNull);
        expect(lightPlan.updatedAt, isNull);
        expect(lightPlan.startDate, isNull);
        expect(lightPlan.endDate, isNull);
        expect(lightPlan.status, isNull);
        expect(lightPlan.validationStatus, isNull);
        expect(lightPlan.errorDetails, isNull);
      });

      test('handles null date fields gracefully', () {
        final json = {
          'mealPlanId': 'null-dates-plan',
          'planName': 'Plan with null dates',
          'updatedAt': null,
          'startDate': null,
          'endDate': null,
        };

        final lightPlan = LightMealPlan.fromJson(json);

        expect(lightPlan.mealPlanId, 'null-dates-plan');
        expect(lightPlan.planName, 'Plan with null dates');
        expect(lightPlan.updatedAt, isNull);
        expect(lightPlan.startDate, isNull);
        expect(lightPlan.endDate, isNull);
      });

      test('handles all status enum values', () {
        final statusValues = {
          'ACTIVE': PlanStatus.ACTIVE,
          'ARCHIVED': PlanStatus.ARCHIVED,
          'PENDING': PlanStatus.PENDING,
        };

        for (final entry in statusValues.entries) {
          final json = {
            'mealPlanId': 'status-test-${entry.key.toLowerCase()}',
            'status': entry.key,
          };

          final lightPlan = LightMealPlan.fromJson(json);

          expect(lightPlan.status, entry.value);
        }
      });

      test('handles all validation status enum values', () {
        final validationStatusValues = {
          'VALIDATED': MealPlanValidationStatus.VALIDATED,
          'REJECTED': MealPlanValidationStatus.REJECTED,
          'PENDING_REVIEW': MealPlanValidationStatus.PENDING_REVIEW,
        };

        for (final entry in validationStatusValues.entries) {
          final json = {
            'mealPlanId': 'validation-test-${entry.key.toLowerCase()}',
            'validationStatus': entry.key,
          };

          final lightPlan = LightMealPlan.fromJson(json);

          expect(lightPlan.validationStatus, entry.value);
        }
      });

      test('handles unknown enum values gracefully', () {
        final json = {
          'mealPlanId': 'unknown-enums-plan',
          'status': 'UNKNOWN_STATUS',
          'validationStatus': 'UNKNOWN_VALIDATION',
        };

        final lightPlan = LightMealPlan.fromJson(json);

        expect(lightPlan.mealPlanId, 'unknown-enums-plan');
        expect(lightPlan.status, isNull); // Unknown enum becomes null
        expect(lightPlan.validationStatus, isNull); // Unknown enum becomes null
      });

      test('handles invalid date formats', () {
        final json = {
          'mealPlanId': 'invalid-date-plan',
          'updatedAt': 'not-a-date',
          'startDate': '2023-13-45', // Invalid date
          'endDate': '', // Empty string
        };

        expect(() => LightMealPlan.fromJson(json), throwsFormatException);
      });
    });

    group('toJson method', () {
      test('converts complete LightMealPlan to JSON', () {
        final updatedAt = DateTime(2023, 12, 25, 10, 30, 0);
        final startDate = DateTime(2023, 12, 20);
        final endDate = DateTime(2023, 12, 27, 23, 59, 59);

        final lightPlan = LightMealPlan(
          mealPlanId: 'to-json-plan',
          planName: 'JSON Output Plan',
          updatedAt: updatedAt,
          startDate: startDate,
          endDate: endDate,
          status: PlanStatus.ACTIVE,
          validationStatus: MealPlanValidationStatus.VALIDATED,
          errorDetails: 'All good',
        );

        final json = lightPlan.toJson();

        expect(json['mealPlanId'], 'to-json-plan');
        expect(json['planName'], 'JSON Output Plan');
        expect(json['updatedAt'], updatedAt.toIso8601String());
        expect(json['startDate'], startDate.toIso8601String());
        expect(json['endDate'], endDate.toIso8601String());
        expect(json['status'], 'ACTIVE');
        expect(json['validationStatus'], 'VALIDATED');
        expect(json['errorDetails'], 'All good');
      });

      test('converts minimal LightMealPlan to JSON', () {
        final lightPlan = LightMealPlan(mealPlanId: 'minimal-to-json');

        final json = lightPlan.toJson();

        expect(json['mealPlanId'], 'minimal-to-json');
        expect(json['planName'], isNull);
        expect(json['updatedAt'], isNull);
        expect(json['startDate'], isNull);
        expect(json['endDate'], isNull);
        expect(json['status'], isNull);
        expect(json['validationStatus'], isNull);
        expect(json['errorDetails'], isNull);
      });

      test('converts LightMealPlan with null dates to JSON', () {
        final lightPlan = LightMealPlan(
          mealPlanId: 'null-dates-to-json',
          planName: 'Plan with nulls',
          updatedAt: null,
          startDate: null,
          endDate: null,
        );

        final json = lightPlan.toJson();

        expect(json['mealPlanId'], 'null-dates-to-json');
        expect(json['planName'], 'Plan with nulls');
        expect(json['updatedAt'], isNull);
        expect(json['startDate'], isNull);
        expect(json['endDate'], isNull);
      });

      test('round-trip conversion preserves data', () {
        final originalPlan = LightMealPlan(
          mealPlanId: 'round-trip-plan',
          planName: 'Round Trip Test',
          updatedAt: DateTime(2023, 6, 15, 14, 30, 0),
          startDate: DateTime(2023, 6, 10),
          endDate: DateTime(2023, 6, 20),
          status: PlanStatus.PENDING,
          validationStatus: MealPlanValidationStatus.PENDING_REVIEW,
          errorDetails: 'Pending review',
        );

        final json = originalPlan.toJson();
        final reconstructed = LightMealPlan.fromJson(json);

        expect(reconstructed.mealPlanId, originalPlan.mealPlanId);
        expect(reconstructed.planName, originalPlan.planName);
        expect(reconstructed.updatedAt, originalPlan.updatedAt);
        expect(reconstructed.startDate, originalPlan.startDate);
        expect(reconstructed.endDate, originalPlan.endDate);
        expect(reconstructed.status, originalPlan.status);
        expect(reconstructed.validationStatus, originalPlan.validationStatus);
        expect(reconstructed.errorDetails, originalPlan.errorDetails);
      });
    });

    group('Date handling', () {
      test('handles different date formats correctly', () {
        final dateFormats = [
          '2023-12-25T10:30:00.000Z', // ISO with milliseconds and Z
          '2023-12-25T10:30:00Z', // ISO without milliseconds
          '2023-12-25T10:30:00.123456Z', // ISO with microseconds
          '2023-12-25T10:30:00+00:00', // ISO with timezone offset
        ];

        for (final dateFormat in dateFormats) {
          final json = {
            'mealPlanId': 'date-format-test',
            'updatedAt': dateFormat,
          };

          final lightPlan = LightMealPlan.fromJson(json);
          expect(lightPlan.updatedAt, isA<DateTime>());
        }
      });

      test('handles timezone conversion properly', () {
        final utcDateString = '2023-12-25T10:30:00.000Z';

        final json = {
          'mealPlanId': 'timezone-test',
          'updatedAt': utcDateString,
          'startDate': utcDateString,
          'endDate': utcDateString,
        };

        final lightPlan = LightMealPlan.fromJson(json);
        final expectedDate = DateTime.parse(utcDateString);

        expect(lightPlan.updatedAt, expectedDate);
        expect(lightPlan.startDate, expectedDate);
        expect(lightPlan.endDate, expectedDate);
      });
    });

    group('Realistic usage scenarios', () {
      test('represents a plan in different lifecycle stages', () {
        // Draft plan
        final draftPlan = LightMealPlan(
          mealPlanId: 'draft-plan-001',
          planName: 'My Weekly Plan Draft',
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
          status: PlanStatus.ARCHIVED,
          validationStatus: MealPlanValidationStatus.PENDING_REVIEW,
          errorDetails: null,
        );

        expect(draftPlan.status, PlanStatus.ARCHIVED);
        expect(draftPlan.validationStatus,
            MealPlanValidationStatus.PENDING_REVIEW);

        // Approved and active plan
        final activePlan = LightMealPlan(
          mealPlanId: 'active-plan-001',
          planName: 'My Active Weekly Plan',
          updatedAt: DateTime.now(),
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 7)),
          status: PlanStatus.ACTIVE,
          validationStatus: MealPlanValidationStatus.VALIDATED,
          errorDetails: null,
        );

        expect(activePlan.status, PlanStatus.ACTIVE);
        expect(activePlan.validationStatus, MealPlanValidationStatus.VALIDATED);
        expect(activePlan.startDate?.isBefore(activePlan.endDate!), true);

        // Failed plan with errors
        final failedPlan = LightMealPlan(
          mealPlanId: 'failed-plan-001',
          planName: 'Failed Plan',
          updatedAt: DateTime.now().subtract(Duration(hours: 1)),
          status: PlanStatus.ARCHIVED,
          validationStatus: MealPlanValidationStatus.REJECTED,
          errorDetails: 'Insufficient nutritional balance',
        );

        expect(failedPlan.status, PlanStatus.ARCHIVED);
        expect(failedPlan.validationStatus, MealPlanValidationStatus.REJECTED);
        expect(failedPlan.errorDetails, isNotEmpty);
      });

      test('supports plan filtering and sorting operations', () {
        final plans = [
          LightMealPlan(
            mealPlanId: 'old-plan',
            updatedAt: DateTime.now().subtract(Duration(days: 10)),
            status: PlanStatus.ARCHIVED,
          ),
          LightMealPlan(
            mealPlanId: 'recent-plan',
            updatedAt: DateTime.now().subtract(Duration(hours: 1)),
            status: PlanStatus.ACTIVE,
          ),
          LightMealPlan(
            mealPlanId: 'newest-plan',
            updatedAt: DateTime.now(),
            status: PlanStatus.PENDING,
          ),
        ];

        // Filter active plans
        final activePlans =
            plans.where((plan) => plan.status == PlanStatus.ACTIVE).toList();

        expect(activePlans.length, 1);
        expect(activePlans[0].mealPlanId, 'recent-plan');

        // Sort by update time (newest first)
        final sortedPlans = List<LightMealPlan>.from(plans);
        sortedPlans.sort((a, b) {
          if (a.updatedAt == null && b.updatedAt == null) return 0;
          if (a.updatedAt == null) return 1;
          if (b.updatedAt == null) return -1;
          return b.updatedAt!.compareTo(a.updatedAt!);
        });

        expect(sortedPlans[0].mealPlanId, 'newest-plan');
        expect(sortedPlans[1].mealPlanId, 'recent-plan');
        expect(sortedPlans[2].mealPlanId, 'old-plan');
      });
    });

    group('Edge cases and validation', () {
      test('handles extremely long strings', () {
        final longString = 'A' * 10000;

        final lightPlan = LightMealPlan(
          mealPlanId: 'long-strings-test',
          planName: longString,
          errorDetails: longString,
        );

        expect(lightPlan.planName?.length, 10000);
        expect(lightPlan.errorDetails?.length, 10000);
      });

      test('handles special characters in strings', () {
        final specialChars =
            'Plan with special chars: 🍎🥗💯 !@#\$%^&*()_+-=[]{}|;:,.<>?';

        final lightPlan = LightMealPlan(
          mealPlanId: 'special-chars-test',
          planName: specialChars,
          errorDetails: specialChars,
        );

        expect(lightPlan.planName, specialChars);
        expect(lightPlan.errorDetails, specialChars);

        // Verify round-trip with JSON
        final json = lightPlan.toJson();
        final reconstructed = LightMealPlan.fromJson(json);

        expect(reconstructed.planName, specialChars);
        expect(reconstructed.errorDetails, specialChars);
      });

      test('handles extreme date values', () {
        final veryOldDate = DateTime(1900, 1, 1);
        final veryFutureDate = DateTime(2100, 12, 31);

        final lightPlan = LightMealPlan(
          mealPlanId: 'extreme-dates-test',
          updatedAt: veryOldDate,
          startDate: veryOldDate,
          endDate: veryFutureDate,
        );

        expect(lightPlan.updatedAt, veryOldDate);
        expect(lightPlan.startDate, veryOldDate);
        expect(lightPlan.endDate, veryFutureDate);

        // Verify JSON round-trip
        final json = lightPlan.toJson();
        final reconstructed = LightMealPlan.fromJson(json);

        expect(reconstructed.updatedAt, veryOldDate);
        expect(reconstructed.startDate, veryOldDate);
        expect(reconstructed.endDate, veryFutureDate);
      });

      test('handles empty strings vs null values', () {
        final jsonWithEmptyStrings = {
          'mealPlanId': 'empty-strings-test',
          'planName': '',
          'errorDetails': '',
        };

        final lightPlan = LightMealPlan.fromJson(jsonWithEmptyStrings);

        expect(lightPlan.planName, ''); // Empty string preserved
        expect(lightPlan.errorDetails, ''); // Empty string preserved

        // Compare with null values
        final jsonWithNulls = {
          'mealPlanId': 'null-values-test',
          'planName': null,
          'errorDetails': null,
        };

        final nullPlan = LightMealPlan.fromJson(jsonWithNulls);

        expect(nullPlan.planName, isNull);
        expect(nullPlan.errorDetails, isNull);
      });
    });
  });
}
