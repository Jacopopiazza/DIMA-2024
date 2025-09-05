import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:dima_application/Views/CustomAuthenticator/customized_authenticator.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/models/ActivePlanCache/active_plan_cache.dart';
import 'package:dima_application/models/DailyCompletion/daily_completion.dart';
import 'package:dima_application/models/MealPlan/meal_plan.dart';
import 'package:dima_application/models/TodayPage/today_page_data.dart';
import 'package:dima_application/models/UserDetails/user_details_cache.dart';
import 'package:dima_application/providers/isar_provider.dart';
import 'package:dima_application/providers/auth_state_provider.dart';
import 'package:dima_application/providers/app_lifecycle_provider.dart';
// Add chat imports
import 'package:dima_application/services/chat_service.dart';
import 'package:dima_application/providers/chat_notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'amplify_outputs.dart';

Future<void> _configureAmplify() async {
  try {
    final api = AmplifyAPI(
      options: APIPluginOptions(
        modelProvider: ModelProvider.instance,
      ),
    );

    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.addPlugin(api);
    await Amplify.addPlugin(AmplifyStorageS3());
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await _configureAmplify();

    // --- Isar Initialization ---
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        ActivePlanCacheSchema,
        TodayPageDataSchema,
        DailyCompletionSchema,
        MealPlanCacheSchema,
        UserDetailsCacheSchema
      ], // Add your schema here
      directory: dir.path,
    );
    // --- End Isar Initialization ---

    runApp(ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyApp(),
    ));
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  GlobalChatSubscriptionService? _chatService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize chat service after auth is configured
    _initializeChatService();
  }

  Future<void> _initializeChatService() async {
    try {
      // Wait a bit to ensure auth is ready
      await Future.delayed(const Duration(seconds: 1));

      // Check if user is authenticated
      final authSession = await Amplify.Auth.fetchAuthSession();
      if (authSession.isSignedIn) {
        _chatService = GlobalChatSubscriptionService();
        await _chatService!.initialize();

        // Set up notification handler
        _chatService!.onNewMessage = (notification) {
          // Show notification using the provider
          ref
              .read(chatNotificationProvider.notifier)
              .showNotification(notification);
        };

        safePrint('Chat service initialized successfully');
      }
    } catch (e) {
      safePrint('Error initializing chat service: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - reconnect if needed
      if (_chatService == null) {
        _initializeChatService();
      }
    } else if (state == AppLifecycleState.paused) {
      // App went to background
      safePrint('App paused - chat subscription active in background');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chatService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the auth state provider early to start listening for auth events
    ref.watch(authStateProvider);

    // Initialize the app lifecycle provider to handle background/foreground detection
    ref.watch(appLifecycleProvider);

    // Listen to auth state changes to reinitialize chat when user logs in
    final authStateAsyncProvider = authStateProvider
        .select((state) => AsyncValue.data(state == AuthState.signedIn));
    ref.listen<AsyncValue<bool>>(authStateAsyncProvider, (previous, next) {
      next.whenData((isAuthenticated) {
        if (isAuthenticated && _chatService == null) {
          _initializeChatService();
        } else if (!isAuthenticated && _chatService != null) {
          _chatService?.dispose();
          _chatService = null;
        }
      });
    });

    return CustomizedAuthenticator();
  }
}
