import 'package:intl/intl.dart';

/// Utility class for validating user profile data
class ProfileValidationUtils {
  /// Valid gender values
  static const List<String> validGenders = ['male', 'female', 'other'];

  /// Minimum age requirement
  static const int minAge = 13;

  /// Validates if a gender value is valid
  static bool isValidGender(String? gender) {
    if (gender == null || gender.isEmpty) return false;
    return validGenders.contains(gender.toLowerCase());
  }

  /// Validates if a birthdate is in the correct format (YYYY-MM-DD)
  static bool isValidBirthdateFormat(String? birthdate) {
    if (birthdate == null || birthdate.isEmpty) return false;

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(birthdate)) return false;

    try {
      DateFormat('yyyy-MM-dd').parse(birthdate);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validates if a birthdate represents a person who is at least 13 years old
  static bool isValidAge(String? birthdate) {
    if (!isValidBirthdateFormat(birthdate)) return false;

    try {
      final birthDate = DateFormat('yyyy-MM-dd').parse(birthdate!);
      final today = DateTime.now();

      // Check if birthdate is not in the future
      if (birthDate.isAfter(today)) return false;

      // Calculate age
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age >= minAge;
    } catch (e) {
      return false;
    }
  }

  /// Validates if a user profile has complete and valid information
  /// Returns a ProfileValidationResult with details about what's missing or invalid
  static ProfileValidationResult validateProfile({
    required String? gender,
    required String? birthdate,
  }) {
    final issues = <String>[];

    // Check gender
    if (!isValidGender(gender)) {
      issues.add('Gender must be Male, Female, or Other');
    }

    // Check birthdate format
    if (!isValidBirthdateFormat(birthdate)) {
      issues.add('Birthdate must be in YYYY-MM-DD format');
    } else if (!isValidAge(birthdate)) {
      issues.add('You must be at least 13 years old to use this service');
    }

    return ProfileValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }

  /// Gets a user-friendly message describing what needs to be completed
  static String getProfileCompletionMessage(List<String> issues) {
    if (issues.isEmpty) return 'Profile is complete';

    if (issues.length == 1) {
      return 'Please complete your profile: ${issues.first}';
    }

    return 'Please complete your profile:\n• ${issues.join('\n• ')}';
  }
}

/// Result of profile validation
class ProfileValidationResult {
  final bool isValid;
  final List<String> issues;

  const ProfileValidationResult({
    required this.isValid,
    required this.issues,
  });

  /// Gets a user-friendly message about the validation result
  String get message =>
      ProfileValidationUtils.getProfileCompletionMessage(issues);
}
