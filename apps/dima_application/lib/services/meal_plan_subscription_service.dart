// meal_plan_subscription_service.dart (FIXED VERSION)
import 'dart:async';
import 'dart:convert'; // Aggiunto per JSON parsing

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyGraphQL.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class MealPlanSubscriptionService {
  StreamSubscription<GraphQLResponse<String>>? _subscription;
  StreamController<MealPlanResponse>? _controller;
  String? _currentUserId;

  final AmplifyAuth _amplifyAuth;
  final AmplifyGraphQL _amplifyGraphQL;

  MealPlanSubscriptionService(
      {AmplifyAuth? amplifyAuth, AmplifyGraphQL? amplifyGraphQL})
      : _amplifyAuth = amplifyAuth ?? AmplifyAuth(),
        _amplifyGraphQL = amplifyGraphQL ?? AmplifyGraphQL();

  // Stream pubblico per ascoltare le notifiche
  Stream<MealPlanResponse> get notificationStream =>
      _controller?.stream ?? const Stream.empty();

  // Avvia la subscription
  Future<void> startListening() async {
    try {
      print(
          "[MealPlanSubscriptionService] 🔍 Starting meal plan subscription...");

      // ALWAYS clean up existing resources first
      await _cleanupResources();

      // Wait for auth state to stabilize after sign-in transitions
      await Future.delayed(const Duration(milliseconds: 1000));

      // Retry logic for auth state stabilization
      AuthUser? user;
      int retries = 3;
      while (retries > 0) {
        try {
          user = await _amplifyAuth.getCurrentUser();
          break;
        } catch (e) {
          if (retries == 1) {
            print(
                "[MealPlanSubscriptionService] ❌ Failed to get user after retries: $e");
            rethrow;
          }
          print(
              "[MealPlanSubscriptionService] ⚠️ Auth not ready, retrying... ($retries attempts left)");
          retries--;
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      final String userId = user!.userId;
      _currentUserId = userId;

      print("[MealPlanSubscriptionService] 🔍 User ID: $userId");

      // Create fresh stream controller
      _controller = StreamController<MealPlanResponse>.broadcast();
      print("[MealPlanSubscriptionService] ✨ Created fresh StreamController");

      // Query GraphQL per la subscription - simplified to match working console version
      const String subscriptionDocument = '''
        subscription OnMealPlanStatusChanged(\$userId: ID!) {
          onMealPlanStatusChanged(userId: \$userId) {
            success
            message
            mealPlanId
            userId
          }
        }
      ''';

      // Crea la subscription request
      final subscriptionRequest = GraphQLRequest<String>(
        document: subscriptionDocument,
        variables: {
          'userId': userId,
        },
      );

      print(
          "[MealPlanSubscriptionService] 📡 Subscription request created with userId: $userId");

      // Avvia la subscription
      final operation = _amplifyGraphQL.subscribe(subscriptionRequest);

      _subscription = operation.listen(
        (GraphQLResponse<String> response) {
          print(
              "[MealPlanSubscriptionService] 📥 Raw subscription response received");
          _handleSubscriptionData(response);
        },
        onError: (error) {
          safePrint('[MealPlanSubscriptionService] Subscription error: $error');
          _controller?.addError(error);
        },
        onDone: () {
          safePrint('[MealPlanSubscriptionService] Subscription completed');
        },
      );

      print(
          '[MealPlanSubscriptionService] ✅ MealPlan subscription started successfully for user: $userId');
    } catch (e) {
      print('[MealPlanSubscriptionService] ❌ Error starting subscription: $e');
      rethrow;
    }
  }

  // Clean up all existing resources
  Future<void> _cleanupResources() async {
    print("[MealPlanSubscriptionService] 🧹 Cleaning up existing resources...");

    // Cancel existing subscription
    await _subscription?.cancel();
    _subscription = null;

    // Close existing controller if it exists
    if (_controller != null && !_controller!.isClosed) {
      await _controller!.close();
    }
    _controller = null;

    print("[MealPlanSubscriptionService] ✅ Cleanup completed");
  }

  // Gestisce i dati ricevuti dalla subscription
  void _handleSubscriptionData(GraphQLResponse<String> response) {
    try {
      // Simple check - if no controller, ignore
      if (_controller == null || _controller!.isClosed) {
        safePrint(
            '[MealPlanSubscriptionService] No active controller, ignoring subscription data');
        return;
      }

      if (response.data != null) {
        // Parse manuale del JSON
        final data = response.data!;
        final notification = _parseNotification(data);

        safePrint(
            '[MealPlanSubscriptionService] Received meal plan notification: ${notification.mealPlanId}');

        // Invia la notifica attraverso lo stream
        _controller!.add(notification);
      }

      if (response.errors.isNotEmpty) {
        safePrint(
            '[MealPlanSubscriptionService] Subscription response errors: ${response.errors}');
        _controller!.addError(response.errors);
      }
    } catch (e) {
      safePrint(
          '[MealPlanSubscriptionService] Error handling subscription data: $e');
      _controller?.addError(e);
    }
  }

  // Parse della notifica - VERSIONE CORRETTA
  MealPlanResponse _parseNotification(String jsonData) {
    try {
      print("[MealPlanSubscriptionService] 🔍 Raw JSON data received:");
      print("[MealPlanSubscriptionService] $jsonData");

      // Parse del JSON
      final Map<String, dynamic> jsonMap = json.decode(jsonData);
      print("[MealPlanSubscriptionService] 📋 Parsed JSON map: $jsonMap");

      // I dati della subscription sono nested sotto "onMealPlanStatusChanged"
      final Map<String, dynamic>? notificationData =
          jsonMap['onMealPlanStatusChanged'] as Map<String, dynamic>?;

      if (notificationData == null) {
        print(
            "[MealPlanSubscriptionService] ⚠️ No 'onMealPlanStatusChanged' field found in JSON");
        // Fallback: prova a usare il JSON completo
        return _createMealPlanResponse(jsonMap);
      }

      print(
          "[MealPlanSubscriptionService] ✅ Notification data found: $notificationData");
      return _createMealPlanResponse(notificationData);
    } catch (e) {
      print("[MealPlanSubscriptionService] ❌ Error parsing JSON: $e");
      print("[MealPlanSubscriptionService] Raw data was: $jsonData");

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

      print("[MealPlanSubscriptionService] 🏗️ Creating MealPlanResponse:");
      print("[MealPlanSubscriptionService]   success: $success");
      print("[MealPlanSubscriptionService]    message: $message");
      print("[MealPlanSubscriptionService]    mealPlanId: $mealPlanId");

      return MealPlanResponse(
        success: success,
        message: message,
        mealPlanId: mealPlanId,
      );
    } catch (e) {
      print(
          "[MealPlanSubscriptionService] ❌ Error creating MealPlanResponse: $e");
      return MealPlanResponse(
        success: false,
        message: "Error creating response: $e",
        mealPlanId: "creation-error-${DateTime.now().millisecondsSinceEpoch}",
      );
    }
  }

  // Ferma la subscription
  Future<void> stopListening() async {
    await _cleanupResources();
    _currentUserId = null;
    safePrint('[MealPlanSubscriptionService] MealPlan subscription stopped');
  }

  // Pulisce le risorse
  void dispose() {
    stopListening();
    safePrint('[MealPlanSubscriptionService] Service disposed');
  }
}
