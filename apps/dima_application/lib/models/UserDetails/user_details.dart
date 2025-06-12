import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/UserDetails.dart'
    as amplify_user_details;

class UserDetails {
  final String userId;
  final double? weightKg;
  final double? heightCm;
  final int? exerciseFrequency;
  final int? dailyMealsPreference;
  final List<String> allergies;
  final List<String> dietaryRestrictions;
  final String? openTextPreferences;
  final int? targetCalories;
  final String? activeMealPlanId;
  final TemporalDateTime? updatedAt;
  final TemporalDateTime? createdAt;

  UserDetails({
    required this.userId,
    this.weightKg,
    this.heightCm,
    this.exerciseFrequency,
    this.dailyMealsPreference,
    required this.allergies,
    required this.dietaryRestrictions,
    this.openTextPreferences,
    this.targetCalories,
    this.activeMealPlanId,
    this.updatedAt,
    this.createdAt,
  });

  factory UserDetails.fromAmplify(
      amplify_user_details.UserDetails amplifyDetails) {
    return UserDetails(
      userId: amplifyDetails.userId,
      weightKg: amplifyDetails.weightKg,
      heightCm: amplifyDetails.heightCm,
      exerciseFrequency: amplifyDetails.exerciseFrequency?.index,
      dailyMealsPreference: amplifyDetails.dailyMealsPreference,
      allergies: List<String>.from(amplifyDetails.allergies ?? []),
      dietaryRestrictions:
          List<String>.from(amplifyDetails.dietaryRestrictions ?? []),
      openTextPreferences: amplifyDetails.openTextPreferences,
      targetCalories: amplifyDetails.targetCalories?.round(),
      activeMealPlanId: amplifyDetails.activeMealPlanId,
      updatedAt: amplifyDetails.updatedAt,
      createdAt: amplifyDetails.createdAt,
    );
  }
}
