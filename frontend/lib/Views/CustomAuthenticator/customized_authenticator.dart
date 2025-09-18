import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/Views/CustomAuthenticator/custom_sign_in.dart';
import 'package:dima_application/Views/CustomAuthenticator/custom_sign_up.dart';
import 'package:dima_application/Views/CustomAuthenticator/localized_button_resolver.dart';
import 'package:dima_application/Views/CustomAuthenticator/localized_input_resolver.dart';
import 'package:dima_application/Views/CustomAuthenticator/localized_message_resolver.dart';
import 'package:dima_application/Views/CustomAuthenticator/localized_titles_resolver.dart';
import 'package:dima_application/Views/UserTypeRouter/user_type_router.dart';
import 'package:dima_application/Views/Common/global_chat_notification_handler.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/navigation/route_observer.dart';
import 'package:flutter/material.dart';

const Color _seedColor = Color(0xFFF9A8D4); // rosa tenue - cambia se vuoi

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
    surface: Color(0xFF121212), // dark cards/dialogs
  ),
  // Removed explicit scaffoldBackgroundColor to use Material 3 theme colors
);

// A custom authenticator widget with a custom layout
class CustomizedAuthenticator extends StatelessWidget {
  const CustomizedAuthenticator({super.key});

  @override
  Widget build(BuildContext context) {
    const stringResolver = AuthStringResolver(
      buttons: LocalizedButtonResolver(),
      inputs: LocalizedInputResolver(),
      messages: LocalizedMessageResolver(),
      titles: LocalizedTitlesResolver(),
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
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: darkTheme,
          navigatorObservers: [routeObserver],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // Adjust your home/route configuration as needed
          home: const GlobalChatNotificationHandler(
            child: UserTypeRouter(),
          )),
    );
  }
}
