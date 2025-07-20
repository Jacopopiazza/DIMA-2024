import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NutritionistProfile Model Tests', () {
    test('should create NutritionistProfile with id field', () {
      final profile = NutritionistProfile(
        id: 'test-id',
        nutritionistId: 'NUTR123',
        givenName: 'John',
        familyName: 'Doe',
        specialization: 'Sports Nutrition',
        bio: 'Certified nutritionist',
        isAvailable: true,
      );

      expect(profile.id, equals('test-id'));
      expect(profile.nutritionistId, equals('NUTR123'));
      expect(profile.givenName, equals('John'));
      expect(profile.familyName, equals('Doe'));
      expect(profile.specialization, equals('Sports Nutrition'));
      expect(profile.bio, equals('Certified nutritionist'));
      expect(profile.isAvailable, equals(true));
    });

    test('should create NutritionistProfile without explicit id', () {
      final profile = NutritionistProfile(
        nutritionistId: 'NUTR123',
        givenName: 'John',
        familyName: 'Doe',
        specialization: 'Sports Nutrition',
        bio: 'Certified nutritionist',
        isAvailable: true,
      );

      expect(profile.id, isNotEmpty);
      expect(profile.nutritionistId, equals('NUTR123'));
    });

    test('should serialize and deserialize correctly', () {
      final originalProfile = NutritionistProfile(
        id: 'test-id',
        nutritionistId: 'NUTR123',
        givenName: 'John',
        familyName: 'Doe',
        specialization: 'Sports Nutrition',
        bio: 'Certified nutritionist',
        isAvailable: true,
      );

      final json = originalProfile.toJson();
      final deserializedProfile = NutritionistProfile.fromJson(json);

      expect(deserializedProfile.id, equals(originalProfile.id));
      expect(deserializedProfile.nutritionistId,
          equals(originalProfile.nutritionistId));
      expect(deserializedProfile.givenName, equals(originalProfile.givenName));
      expect(
          deserializedProfile.familyName, equals(originalProfile.familyName));
      expect(deserializedProfile.specialization,
          equals(originalProfile.specialization));
      expect(deserializedProfile.bio, equals(originalProfile.bio));
      expect(
          deserializedProfile.isAvailable, equals(originalProfile.isAvailable));
    });

    test('should handle null optional fields', () {
      final profile = NutritionistProfile(
        nutritionistId: 'NUTR123',
        givenName: null,
        familyName: null,
        specialization: null,
        bio: null,
        isAvailable: null,
      );

      expect(profile.id, isNotEmpty);
      expect(profile.nutritionistId, equals('NUTR123'));
      expect(profile.givenName, isNull);
      expect(profile.familyName, isNull);
      expect(profile.specialization, isNull);
      expect(profile.bio, isNull);
      expect(profile.isAvailable, isNull);
    });
  });
}
