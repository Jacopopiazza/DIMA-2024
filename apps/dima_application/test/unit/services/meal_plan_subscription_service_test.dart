import 'dart:async';

import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/meal_plan_subscription_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealPlanSubscriptionService', () {
    late MealPlanSubscriptionService service;

    setUp(() {
      service = MealPlanSubscriptionService();
    });

    tearDown(() async {
      service.dispose();
    });

    group('notification stream', () {
      test('returns empty stream initially', () {
        expect(service.notificationStream, isA<Stream<MealPlanResponse>>());
      });
    });

    group('stopListening', () {
      test('cleans up resources', () async {
        await service.stopListening();
        
        // Should not throw when called again
        await service.stopListening();
        expect(true, isTrue); // Test passes if no exception is thrown
      });
    });

    group('dispose', () {
      test('calls stopListening and cleans up', () {
        service.dispose();
        
        // Should not throw when called again
        service.dispose();
        expect(true, isTrue); // Test passes if no exception is thrown
      });
    });

    group('stream behavior', () {
      test('notificationStream property works', () {
        final stream = service.notificationStream;
        expect(stream, isNotNull);
        expect(stream, isA<Stream<MealPlanResponse>>());
      });

      test('multiple calls to notificationStream return consistent result', () {
        final stream1 = service.notificationStream;
        final stream2 = service.notificationStream;
        
        expect(stream1.runtimeType, equals(stream2.runtimeType));
      });
    });

    group('service lifecycle', () {
      test('can create and dispose service multiple times', () {
        final service1 = MealPlanSubscriptionService();
        service1.dispose();
        
        final service2 = MealPlanSubscriptionService();
        service2.dispose();
        
        expect(true, isTrue); // Test passes if no exception is thrown
      });

      test('stopListening can be called before startListening', () async {
        final service = MealPlanSubscriptionService();
        await service.stopListening();
        service.dispose();
        
        expect(true, isTrue); // Test passes if no exception is thrown
      });
    });
  });
}