import 'package:dima_application/generated/flutter-models/MealNameEnum.dart';
import 'package:flutter/material.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart'; // Generated localizations
import 'package:dima_application/generated/flutter-models/AllergenEnum.dart'; // Generated Amplify enum
import 'package:dima_application/generated/flutter-models/ExerciseFrequency.dart'; // Generated Amplify enum

/// Provides localized strings for AllergenEnum values.
///
/// Uses the keys defined in the .arb files (e.g., "allergenCELERY").
/// Returns the enum's name as a fallback if a localization key is missing.
String localizeAllergen(BuildContext context, AllergenEnum allergen) {
  // Get the generated localizations class instance
  final localizations = AppLocalizations.of(context)!;

  // Map enum values to their corresponding localization keys
  switch (allergen) {
    case AllergenEnum.CELERY:
      return localizations.allergenCELERY;
    case AllergenEnum.CRUSTACEANS:
      return localizations.allergenCRUSTACEANS;
    case AllergenEnum.EGGS:
      return localizations.allergenEGGS;
    case AllergenEnum.FISH:
      return localizations.allergenFISH;
    case AllergenEnum.GLUTEN_CEREALS:
      return localizations.allergenGLUTEN_CEREALS;
    case AllergenEnum.LUPIN:
      return localizations.allergenLUPIN;
    case AllergenEnum.MILK:
      return localizations.allergenMILK;
    case AllergenEnum.MOLLUSCS:
      return localizations.allergenMOLLUSCS;
    case AllergenEnum.MUSTARD:
      return localizations.allergenMUSTARD;
    case AllergenEnum.NUTS:
      return localizations.allergenNUTS;
    case AllergenEnum.PEANUTS:
      return localizations.allergenPEANUTS;
    case AllergenEnum.SESAME_SEEDS:
      return localizations.allergenSESAME_SEEDS;
    case AllergenEnum.SOYBEANS:
      return localizations.allergenSOYBEANS;
    case AllergenEnum.SULPHITES:
      return localizations.allergenSULPHITES;
    default:
      // Fallback: Log a warning and return the raw enum name
      // Consider using a logging package in a real app
      debugPrint(
          'Warning: Missing localization for AllergenEnum.${allergen.name}');
      return allergen.name;
  }
}

/// Provides localized strings for ExerciseFrequency enum values.
///
/// Uses the keys defined in the .arb files (e.g., "exerciseFrequencyEVERY_DAY").
/// Returns the enum's name as a fallback if a localization key is missing.
String localizeExerciseFrequency(
    BuildContext context, ExerciseFrequency frequency) {
  // Get the generated localizations class instance
  final localizations = AppLocalizations.of(context)!;

  // Map enum values to their corresponding localization keys
  switch (frequency) {
    case ExerciseFrequency.EVERY_DAY:
      return localizations.exerciseFrequencyEVERY_DAY;
    case ExerciseFrequency.FIVE_TIMES_A_WEEK:
      return localizations.exerciseFrequencyFIVE_TIMES_A_WEEK;
    case ExerciseFrequency.FOUR_TIMES_A_WEEK:
      return localizations.exerciseFrequencyFOUR_TIMES_A_WEEK;
    case ExerciseFrequency.NONE:
      return localizations.exerciseFrequencyNONE;
    case ExerciseFrequency.NOT_SPECIFIED:
      // Use the specific key for "Not specified"
      return localizations.exerciseFrequencyNOT_SPECIFIED;
    case ExerciseFrequency.ONCE_A_WEEK:
      return localizations.exerciseFrequencyONCE_A_WEEK;
    case ExerciseFrequency.SIX_TIMES_A_WEEK:
      return localizations.exerciseFrequencySIX_TIMES_A_WEEK;
    case ExerciseFrequency.THREE_TIMES_A_WEEK:
      return localizations.exerciseFrequencyTHREE_TIMES_A_WEEK;
    case ExerciseFrequency.TWICE_A_WEEK:
      return localizations.exerciseFrequencyTWICE_A_WEEK;

    default:
      // Fallback: Log a warning and return the raw enum name
      debugPrint(
          'Warning: Missing localization for ExerciseFrequency.${frequency.name}');
      return frequency.name;
  }
}

/// Provides localized strings for MealNameEnum enum values.
///
/// Uses the keys defined in the .arb files (e.g., "exerciseFrequencyEVERY_DAY").
/// Returns the enum's name as a fallback if a localization key is missing.
String localizeMealName(BuildContext context, MealNameEnum meal) {
  final localizations = AppLocalizations.of(context)!;

  switch (meal) {
    case MealNameEnum.BREAKFAST:
      return localizations.mealNameBREAKFAST;
    case MealNameEnum.DINNER:
      return localizations.mealNameDINNER;
    case MealNameEnum.LUNCH:
      return localizations.mealNameLUNCH;
    case MealNameEnum.SNACK_MORNING:
      return localizations.mealNameSNACK_MORNING;
    case MealNameEnum.SNACK_AFTERNOON:
      return localizations.mealNameSNACK_AFTERNOON;
    case MealNameEnum.SNACK_EVENING:
      return localizations.mealNameSNACK_EVENING;
    default:
      debugPrint('Warning: Missing localization for MealNameEnum.${meal.name}');
      return meal.name;
  }
}

// You can add other enum localization helpers here if needed in the future.
