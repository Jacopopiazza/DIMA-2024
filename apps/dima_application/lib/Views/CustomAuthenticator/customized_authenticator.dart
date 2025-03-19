import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/Views/CustomAuthenticator/custom_sign_in.dart';
import 'package:dima_application/Views/CustomAuthenticator/custom_sign_up.dart';
import 'package:dima_application/Views/CustomAuthenticator/localized_button_resolver.dart';
import 'package:dima_application/Views/home_screen.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// A custom authenticator widget with a custom layout
class CustomizedAuthenticator extends StatelessWidget {
  const CustomizedAuthenticator({super.key});

  @override
  Widget build(BuildContext context) {
    const stringResolver = AuthStringResolver(
      buttons: LocalizedButtonResolver(),
    );

    return Authenticator(
      stringResolver: stringResolver,
      // Provide a custom builder for sign in and sign up views
      authenticatorBuilder: (context, state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return SignInView(state: state);
          case AuthenticatorStep.signUp:
            return SignUpView(state: state);
          default:
            // For all other states, fallback to default views.
            return null;
        }
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: Authenticator.builder(),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(useMaterial3: true),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // Adjust your home/route configuration as needed
          home: const HomeScreen()),
    );
  }
}
