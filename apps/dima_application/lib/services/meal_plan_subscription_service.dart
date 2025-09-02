// meal_plan_subscription_service.dart (FIXED VERSION)
import 'dart:async';
import 'dart:convert'; // Aggiunto per JSON parsing
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class MealPlanSubscriptionService {
  StreamSubscription<GraphQLResponse<String>>? _subscription;
  final StreamController<MealPlanResponse> _controller =
      StreamController<MealPlanResponse>.broadcast();

  // Stream pubblico per ascoltare le notifiche
  Stream<MealPlanResponse> get notificationStream => _controller.stream;

  // Avvia la subscription
  Future<void> startListening() async {
    try {
      // Query GraphQL per la subscription
      const String subscriptionDocument = '''
        subscription OnMealPlanStatusChanged {
          onMealPlanStatusChanged {
            success
            message
            mealPlanId
          }
        }
      ''';

      // Crea la subscription request
      final subscriptionRequest = GraphQLRequest<String>(
        document: subscriptionDocument,
      );

      // Avvia la subscription
      final operation = Amplify.API.subscribe(subscriptionRequest);

      _subscription = operation.listen(
        (GraphQLResponse<String> response) {
          _handleSubscriptionData(response);
        },
        onError: (error) {
          safePrint('Subscription error: $error');
          _controller.addError(error);
        },
        onDone: () {
          safePrint('Subscription completed');
        },
      );

      safePrint('MealPlan subscription started successfully');
    } catch (e) {
      safePrint('Error starting subscription: $e');
      rethrow;
    }
  }

  // Gestisce i dati ricevuti dalla subscription
  void _handleSubscriptionData(GraphQLResponse<String> response) {
    try {
      if (response.data != null) {
        // Parse manuale del JSON
        final data = response.data!;
        final notification = _parseNotification(data);

        safePrint(
            'Received meal plan notification: ${notification.mealPlanId}');

        // Invia la notifica attraverso lo stream
        _controller.add(notification);
      }

      if (response.errors != null && response.errors!.isNotEmpty) {
        safePrint('Subscription response errors: ${response.errors}');
        _controller.addError(response.errors!);
      }
    } catch (e) {
      safePrint('Error handling subscription data: $e');
      _controller.addError(e);
    }
  }

  // Parse della notifica - VERSIONE CORRETTA
  MealPlanResponse _parseNotification(String jsonData) {
    try {
      print("🔍 Raw JSON data received:");
      print(jsonData);

      // Parse del JSON
      final Map<String, dynamic> jsonMap = json.decode(jsonData);
      print("📋 Parsed JSON map: $jsonMap");

      // I dati della subscription sono nested sotto "onMealPlanStatusChanged"
      final Map<String, dynamic>? notificationData =
          jsonMap['onMealPlanStatusChanged'] as Map<String, dynamic>?;

      if (notificationData == null) {
        print("⚠️ No 'onMealPlanStatusChanged' field found in JSON");
        // Fallback: prova a usare il JSON completo
        return _createMealPlanResponse(jsonMap);
      }

      print("✅ Notification data found: $notificationData");
      return _createMealPlanResponse(notificationData);
    } catch (e) {
      print("❌ Error parsing JSON: $e");
      print("Raw data was: $jsonData");

      // Fallback: crea una notifica di errore
      return MealPlanResponse(
        success: false,
        message: "Error parsing notification: $e",
        mealPlanId: "parse-error-${DateTime.now().millisecondsSinceEpoch}",
      );
    }
  }

  // Helper per creare MealPlanResponse da Map
  MealPlanResponse _createMealPlanResponse(Map<String, dynamic> data) {
    try {
      final bool success = data['success'] ?? false;
      final String? message = data['message'];
      final String mealPlanId = data['mealPlanId'] ?? 'unknown';

      print("🏗️ Creating MealPlanResponse:");
      print("   success: $success");
      print("   message: $message");
      print("   mealPlanId: $mealPlanId");

      return MealPlanResponse(
        success: success,
        message: message,
        mealPlanId: mealPlanId,
      );
    } catch (e) {
      print("❌ Error creating MealPlanResponse: $e");
      return MealPlanResponse(
        success: false,
        message: "Error creating response: $e",
        mealPlanId: "creation-error-${DateTime.now().millisecondsSinceEpoch}",
      );
    }
  }

  // Ferma la subscription
  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    safePrint('MealPlan subscription stopped');
  }

  // Pulisce le risorse
  void dispose() {
    stopListening();
    _controller.close();
  }
}
