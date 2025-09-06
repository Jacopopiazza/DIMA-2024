import 'package:dima_application/Utils/profile_validation_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileValidationUtils', () {
    group('isValidGender', () {
      test('should return true for valid genders', () {
        expect(ProfileValidationUtils.isValidGender('male'), isTrue);
        expect(ProfileValidationUtils.isValidGender('female'), isTrue);
        expect(ProfileValidationUtils.isValidGender('other'), isTrue);
        expect(ProfileValidationUtils.isValidGender('Male'), isTrue);
        expect(ProfileValidationUtils.isValidGender('FEMALE'), isTrue);
        expect(ProfileValidationUtils.isValidGender('Other'), isTrue);
      });

      test('should return false for invalid genders', () {
        expect(ProfileValidationUtils.isValidGender(null), isFalse);
        expect(ProfileValidationUtils.isValidGender(''), isFalse);
        expect(ProfileValidationUtils.isValidGender('invalid'), isFalse);
        expect(
            ProfileValidationUtils.isValidGender('prefer_not_to_say'), isFalse);
      });
    });

    group('isValidBirthdateFormat', () {
      test('should return true for valid date formats', () {
        expect(ProfileValidationUtils.isValidBirthdateFormat('1990-01-01'),
            isTrue);
        expect(ProfileValidationUtils.isValidBirthdateFormat('2000-12-31'),
            isTrue);
        expect(ProfileValidationUtils.isValidBirthdateFormat('1985-06-15'),
            isTrue);
      });

      test('should return false for invalid date formats', () {
        expect(ProfileValidationUtils.isValidBirthdateFormat(null), isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat(''), isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat('1990/01/01'),
            isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat('01-01-1990'),
            isFalse);
        expect(
            ProfileValidationUtils.isValidBirthdateFormat('1990-1-1'), isFalse);
        expect(
            ProfileValidationUtils.isValidBirthdateFormat('invalid'), isFalse);
      });
    });

    group('isValidAge', () {
      test('should return true for valid ages (13 and older)', () {
        // Test with current date minus 13 years
        final thirteenYearsAgo =
            DateTime.now().subtract(const Duration(days: 366 * 13));
        final validDate =
            '${thirteenYearsAgo.year}-${thirteenYearsAgo.month.toString().padLeft(2, '0')}-${thirteenYearsAgo.day.toString().padLeft(2, '0')}';
        expect(ProfileValidationUtils.isValidAge(validDate), isTrue);

        // Test with current date minus 20 years
        final twentyYearsAgo =
            DateTime.now().subtract(const Duration(days: 365 * 20));
        final validDate20 =
            '${twentyYearsAgo.year}-${twentyYearsAgo.month.toString().padLeft(2, '0')}-${twentyYearsAgo.day.toString().padLeft(2, '0')}';
        expect(ProfileValidationUtils.isValidAge(validDate20), isTrue);
      });

      test('should return false for invalid ages (under 13)', () {
        // Test with current date minus 10 years
        final tenYearsAgo =
            DateTime.now().subtract(const Duration(days: 365 * 10));
        final invalidDate =
            '${tenYearsAgo.year}-${tenYearsAgo.month.toString().padLeft(2, '0')}-${tenYearsAgo.day.toString().padLeft(2, '0')}';
        expect(ProfileValidationUtils.isValidAge(invalidDate), isFalse);

        // Test with future date
        final futureDate = DateTime.now().add(const Duration(days: 365));
        final futureDateStr =
            '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
        expect(ProfileValidationUtils.isValidAge(futureDateStr), isFalse);
      });

      test('should return false for invalid date formats', () {
        expect(ProfileValidationUtils.isValidAge(null), isFalse);
        expect(ProfileValidationUtils.isValidAge(''), isFalse);
        expect(ProfileValidationUtils.isValidAge('invalid'), isFalse);
      });
    });

    group('validateProfile', () {
      test('should return valid result for complete valid profile', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'male',
          birthdate: '1990-01-01',
        );
        expect(result.isValid, isTrue);
        expect(result.issues, isEmpty);
      });

      test('should return invalid result for missing gender', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: null,
          birthdate: '1990-01-01',
        );
        expect(result.isValid, isFalse);
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
      });

      test('should return invalid result for invalid gender', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'invalid',
          birthdate: '1990-01-01',
        );
        expect(result.isValid, isFalse);
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
      });

      test('should return invalid result for missing birthdate', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'male',
          birthdate: null,
        );
        expect(result.isValid, isFalse);
        expect(
            result.issues, contains('Birthdate must be in YYYY-MM-DD format'));
      });

      test('should return invalid result for invalid birthdate format', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'male',
          birthdate: '1990/01/01',
        );
        expect(result.isValid, isFalse);
        expect(
            result.issues, contains('Birthdate must be in YYYY-MM-DD format'));
      });

      test('should return invalid result for underage user', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'male',
          birthdate: '2020-01-01', // 4 years old
        );
        expect(result.isValid, isFalse);
        expect(result.issues,
            contains('You must be at least 13 years old to use this service'));
      });

      test('should return multiple issues for multiple problems', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'invalid',
          birthdate: '2020-01-01',
        );
        expect(result.isValid, isFalse);
        expect(result.issues, hasLength(2));
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
        expect(result.issues,
            contains('You must be at least 13 years old to use this service'));
      });
    });

    group('getProfileCompletionMessage', () {
      test('should return completion message for valid profile', () {
        final message = ProfileValidationUtils.getProfileCompletionMessage([]);
        expect(message, equals('Profile is complete'));
      });

      test('should return single issue message', () {
        final message = ProfileValidationUtils.getProfileCompletionMessage(
            ['Gender must be Male, Female, or Other']);
        expect(
            message,
            equals(
                'Please complete your profile: Gender must be Male, Female, or Other'));
      });

      test('should return multiple issues message', () {
        final issues = [
          'Gender must be Male, Female, or Other',
          'Birthdate must be in YYYY-MM-DD format'
        ];
        final message =
            ProfileValidationUtils.getProfileCompletionMessage(issues);
        expect(
            message,
            equals(
                'Please complete your profile:\n• Gender must be Male, Female, or Other\n• Birthdate must be in YYYY-MM-DD format'));
      });
    });
  });
}
