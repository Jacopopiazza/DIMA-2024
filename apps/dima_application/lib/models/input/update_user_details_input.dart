// lib/models/inputs/update_user_details_input.dart
import 'package:dima_application/generated/flutter-models/AllergenEnum.dart';
import 'package:dima_application/generated/flutter-models/ExerciseFrequency.dart';
import 'package:flutter/foundation.dart' show immutable; // For @immutable

@immutable // Mark class as immutable for good practice
class UpdateUserDetailsInput {
  final double? weightKg;
  final double? heightCm;
  final double? targetCalories;
  final List<AllergenEnum>? allergies;
  final int? dailyMealsPreference;
  final List<String>? dietaryRestrictions;
  final ExerciseFrequency? exerciseFrequency;
  final String? openTextPreferences;

  const UpdateUserDetailsInput({
    this.weightKg,
    this.heightCm,
    this.targetCalories,
    this.allergies,
    this.dailyMealsPreference,
    this.dietaryRestrictions,
    this.exerciseFrequency,
    this.openTextPreferences,
  });

  /// Converts this input object into a Map suitable for GraphQL variables.
  /// Removes null values to support partial updates if the backend handles it.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    // Conditionally add keys only if they have a non-null value
    if (weightKg != null) data['weightKg'] = weightKg;
    if (heightCm != null) data['heightCm'] = heightCm;
    if (targetCalories != null) data['targetCalories'] = targetCalories;
    // Convert enums to their string names for JSON/GraphQL
    if (allergies != null)
      data['allergies'] = allergies!.map((e) => e.name).toList();
    if (dailyMealsPreference != null)
      data['dailyMealsPreference'] = dailyMealsPreference;
    if (dietaryRestrictions != null && dietaryRestrictions!.isNotEmpty)
      data['dietaryRestrictions'] = dietaryRestrictions;
    if (exerciseFrequency != null)
      data['exerciseFrequency'] = exerciseFrequency!.name;
    if (openTextPreferences != null)
      data['openTextPreferences'] = openTextPreferences;
    return data;
  }
}
