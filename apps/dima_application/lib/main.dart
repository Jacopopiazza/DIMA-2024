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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'amplify_outputs.dart';

/// Determines if the current device is a tablet using device_info_plus
Future<bool> isTablet() async {
  // Return true for web platform
  if (kIsWeb) return true;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Android tablets typically have screen sizes >= 7 inches
      // We can also check for tablet-specific features
      final physicalSize =
          WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
      final devicePixelRatio = WidgetsBinding
          .instance.platformDispatcher.views.first.devicePixelRatio;
      final logicalWidth = physicalSize.width / devicePixelRatio;
      final logicalHeight = physicalSize.height / devicePixelRatio;
      final largerDimension =
          logicalWidth > logicalHeight ? logicalWidth : logicalHeight;

      // Use 768px as tablet breakpoint for Android
      return largerDimension >= 768.0;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // iPad models - check device model
      return iosInfo.model.toLowerCase().contains('ipad');
    }
  } catch (e) {
    // Fallback to screen size if device info fails
    final physicalSize =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    final devicePixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final logicalWidth = physicalSize.width / devicePixelRatio;
    final logicalHeight = physicalSize.height / devicePixelRatio;
    final largerDimension =
        logicalWidth > logicalHeight ? logicalWidth : logicalHeight;
    return largerDimension >= 768.0;
  }

  return false;
}

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

    final tablet = await isTablet();

    if (!tablet) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the auth state provider early to start listening for auth events
    ref.watch(authStateProvider);

    // Initialize the app lifecycle provider to handle background/foreground detection
    ref.watch(appLifecycleProvider);

    return CustomizedAuthenticator();
  }
}
