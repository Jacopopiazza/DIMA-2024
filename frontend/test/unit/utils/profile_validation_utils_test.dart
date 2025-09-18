import 'package:dima_application/Utils/profile_validation_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_setup.dart';

void main() {
  configureTestEnvironment();

  group('ProfileValidationUtils', () {
    group('isValidGender', () {
      test('returns true for valid genders', () {
        expect(ProfileValidationUtils.isValidGender('male'), isTrue);
        expect(ProfileValidationUtils.isValidGender('female'), isTrue);
        expect(ProfileValidationUtils.isValidGender('other'), isTrue);
        expect(ProfileValidationUtils.isValidGender('MALE'), isTrue);
        expect(ProfileValidationUtils.isValidGender('Female'), isTrue);
        expect(ProfileValidationUtils.isValidGender('OTHER'), isTrue);
      });

      test('returns false for invalid genders', () {
        expect(ProfileValidationUtils.isValidGender('invalid'), isFalse);
        expect(ProfileValidationUtils.isValidGender('man'), isFalse);
        expect(ProfileValidationUtils.isValidGender('woman'), isFalse);
        expect(ProfileValidationUtils.isValidGender(''), isFalse);
        expect(ProfileValidationUtils.isValidGender(null), isFalse);
      });
    });

    group('isValidBirthdateFormat', () {
      test('returns true for valid date formats', () {
        expect(ProfileValidationUtils.isValidBirthdateFormat('1990-01-01'),
            isTrue);
        expect(ProfileValidationUtils.isValidBirthdateFormat('2000-12-31'),
            isTrue);
        expect(ProfileValidationUtils.isValidBirthdateFormat('1985-06-15'),
            isTrue);
        expect(ProfileValidationUtils.isValidBirthdateFormat('2010-02-29'),
            isTrue); // Leap year
      });

      test('returns false for clearly invalid date formats', () {
        expect(
            ProfileValidationUtils.isValidBirthdateFormat('90-01-01'), isFalse);
        expect(
            ProfileValidationUtils.isValidBirthdateFormat('1990-1-1'), isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat('1990/01/01'),
            isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat('01-01-1990'),
            isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat(''), isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat(null), isFalse);
        expect(ProfileValidationUtils.isValidBirthdateFormat('invalid-date'),
            isFalse);
      });
    });

    group('isValidAge', () {
      late String currentYear;
      late String validBirthYear;
      late String invalidBirthYear;
      late String futureBirthYear;

      setUp(() {
        final now = DateTime.now();
        currentYear = now.year.toString();
        validBirthYear = (now.year - 20).toString(); // 20 years old
        invalidBirthYear = (now.year - 5).toString(); // 5 years old (too young)
        futureBirthYear = (now.year + 1).toString(); // Future date
      });

      test('returns true for valid ages (13 or older)', () {
        expect(
            ProfileValidationUtils.isValidAge('$validBirthYear-01-01'), isTrue);
        expect(
            ProfileValidationUtils.isValidAge(
                '${DateTime.now().year - 13}-01-01'),
            isTrue);
        expect(ProfileValidationUtils.isValidAge('1980-06-15'), isTrue);
      });

      test('returns false for ages under 13', () {
        expect(ProfileValidationUtils.isValidAge('$invalidBirthYear-01-01'),
            isFalse);
        expect(
            ProfileValidationUtils.isValidAge(
                '${DateTime.now().year - 12}-01-01'),
            isFalse);
      });

      test('returns false for future dates', () {
        expect(ProfileValidationUtils.isValidAge('$futureBirthYear-01-01'),
            isFalse);
        expect(
            ProfileValidationUtils.isValidAge(
                '${DateTime.now().year + 5}-01-01'),
            isFalse);
      });

      test('returns false for invalid date formats', () {
        expect(ProfileValidationUtils.isValidAge('invalid-date'), isFalse);
        // Note: These may pass format validation but fail age validation
        expect(ProfileValidationUtils.isValidAge(''), isFalse);
        expect(ProfileValidationUtils.isValidAge(null), isFalse);
      });

      test('handles edge cases for birthday calculations', () {
        final now = DateTime.now();
        final exactAge13 = DateTime(now.year - 13, now.month, now.day);
        final almostAge13 = DateTime(now.year - 13, now.month, now.day + 1);

        expect(
            ProfileValidationUtils.isValidAge(
                '${exactAge13.year}-${exactAge13.month.toString().padLeft(2, '0')}-${exactAge13.day.toString().padLeft(2, '0')}'),
            isTrue);

        if (almostAge13.day <= 31) {
          // Avoid invalid dates
          expect(
              ProfileValidationUtils.isValidAge(
                  '${almostAge13.year}-${almostAge13.month.toString().padLeft(2, '0')}-${almostAge13.day.toString().padLeft(2, '0')}'),
              isFalse);
        }
      });
    });

    group('validateProfile', () {
      test('returns valid result for complete valid profile', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'male',
          birthdate: '1990-01-01',
        );

        expect(result.isValid, isTrue);
        expect(result.issues, isEmpty);
        expect(result.message, 'Profile is complete');
      });

      test('returns invalid result with gender issue', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'invalid',
          birthdate: '1990-01-01',
        );

        expect(result.isValid, isFalse);
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
        expect(
            result.message, contains('Gender must be Male, Female, or Other'));
      });

      test('returns invalid result with birthdate format issue', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'male',
          birthdate: 'invalid-date',
        );

        expect(result.isValid, isFalse);
        expect(
            result.issues, contains('Birthdate must be in YYYY-MM-DD format'));
        expect(
            result.message, contains('Birthdate must be in YYYY-MM-DD format'));
      });

      test('returns invalid result with age issue', () {
        final currentYear = DateTime.now().year;
        final youngAge = '$currentYear-01-01'; // 0 years old

        final result = ProfileValidationUtils.validateProfile(
          gender: 'female',
          birthdate: youngAge,
        );

        expect(result.isValid, isFalse);
        expect(result.issues,
            contains('You must be at least 13 years old to use this service'));
        expect(result.message,
            contains('You must be at least 13 years old to use this service'));
      });

      test('returns invalid result with multiple issues', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: 'invalid',
          birthdate: 'invalid-date',
        );

        expect(result.isValid, isFalse);
        expect(result.issues.length, 2);
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
        expect(
            result.issues, contains('Birthdate must be in YYYY-MM-DD format'));
        expect(result.message, contains('Please complete your profile:'));
        expect(result.message, contains('•'));
      });

      test('handles null values', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: null,
          birthdate: null,
        );

        expect(result.isValid, isFalse);
        expect(result.issues.length, 2);
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
        expect(
            result.issues, contains('Birthdate must be in YYYY-MM-DD format'));
      });

      test('handles empty strings', () {
        final result = ProfileValidationUtils.validateProfile(
          gender: '',
          birthdate: '',
        );

        expect(result.isValid, isFalse);
        expect(result.issues.length, 2);
        expect(
            result.issues, contains('Gender must be Male, Female, or Other'));
        expect(
            result.issues, contains('Birthdate must be in YYYY-MM-DD format'));
      });
    });

    group('getProfileCompletionMessage', () {
      test('returns completion message for empty issues', () {
        final message = ProfileValidationUtils.getProfileCompletionMessage([]);
        expect(message, 'Profile is complete');
      });

      test('returns single issue message', () {
        final message = ProfileValidationUtils.getProfileCompletionMessage(
            ['Gender is required']);
        expect(message, 'Please complete your profile: Gender is required');
      });

      test('returns multiple issues message with bullet points', () {
        final message = ProfileValidationUtils.getProfileCompletionMessage([
          'Gender is required',
          'Birthdate is invalid',
        ]);
        expect(message,
            'Please complete your profile:\n• Gender is required\n• Birthdate is invalid');
      });
    });

    group('ProfileValidationResult', () {
      test('creates valid result correctly', () {
        const result = ProfileValidationResult(
          isValid: true,
          issues: [],
        );

        expect(result.isValid, isTrue);
        expect(result.issues, isEmpty);
        expect(result.message, 'Profile is complete');
      });

      test('creates invalid result correctly', () {
        const result = ProfileValidationResult(
          isValid: false,
          issues: ['Test issue'],
        );

        expect(result.isValid, isFalse);
        expect(result.issues, ['Test issue']);
        expect(result.message, 'Please complete your profile: Test issue');
      });

      test('message property delegates to ProfileValidationUtils', () {
        const result = ProfileValidationResult(
          isValid: false,
          issues: ['Issue 1', 'Issue 2'],
        );

        final expectedMessage =
            ProfileValidationUtils.getProfileCompletionMessage(
                ['Issue 1', 'Issue 2']);
        expect(result.message, expectedMessage);
      });
    });

    group('Constants', () {
      test('valid genders list is correct', () {
        expect(
            ProfileValidationUtils.validGenders, ['male', 'female', 'other']);
      });

      test('minimum age is correct', () {
        expect(ProfileValidationUtils.minAge, 13);
      });
    });
  });
}
