import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'amplify_outputs.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp());
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }
}

class LocalizedButtonResolver extends ButtonResolver {
  const LocalizedButtonResolver();

  /// Override the signIn function with a localized value
  @override
  String signIn(BuildContext context) {
    return AppLocalizations.of(context)!.signIn;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

const stringResolver = AuthStringResolver(
  buttons: LocalizedButtonResolver(),
);

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyConfig);
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  /*
  Future<void> _logout(BuildContext context) async {
    try {
      await Amplify.Auth.signOut();
      safePrint('Signed out');
    } on AuthException catch (e) {
      safePrint('Error signing out: $e');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      stringResolver: stringResolver,
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp(
        title: 'Localizations Sample App',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: Authenticator.builder(),
        home: HomeScreen(),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Authenticator(
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('it'), // Italian
        ],
        builder: Authenticator.builder(),
        home: Scaffold(
          
        )
      ),
    );
  }*/
}
