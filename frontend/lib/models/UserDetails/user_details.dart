import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/UserDetails.dart'
    as amplify_user_details;

class UserDetails {
  final String userId;
  final double weightKg;
  final double heightCm;
  final int? exerciseFrequency;
  final int dailyMealsPreference;
  final List<String> allergies;
  final String? dietaryRestrictions;
  final String? openTextPreferences;
  final String? activeMealPlanId;
  final TemporalDateTime? updatedAt;
  final TemporalDateTime? createdAt;

  UserDetails({
    required this.userId,
    required this.weightKg,
    required this.heightCm,
    this.exerciseFrequency,
    required this.dailyMealsPreference,
    required this.allergies,
    this.dietaryRestrictions,
    this.openTextPreferences,
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
      exerciseFrequency: amplifyDetails.exerciseFrequency.index,
      dailyMealsPreference: amplifyDetails.dailyMealsPreference,
      allergies: List<String>.from(amplifyDetails.allergies ?? []),
      dietaryRestrictions: amplifyDetails.dietaryRestrictions ?? "",
      openTextPreferences: amplifyDetails.openTextPreferences,
      activeMealPlanId: amplifyDetails.activeMealPlanId,
      updatedAt: amplifyDetails.updatedAt,
      createdAt: amplifyDetails.createdAt,
    );
  }
}
