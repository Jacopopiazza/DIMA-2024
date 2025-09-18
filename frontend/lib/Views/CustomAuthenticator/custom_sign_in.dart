import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Custom Sign In View
class SignInView extends StatelessWidget {
  final AuthenticatorState state;
  const SignInView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Your app logo
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/logo_no_background.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Divider(),

            // Built-in sign in form (keeps the default Amplify form)
            SignInForm(),

            const SizedBox(height: 16),
            const Divider(),

            // Informational message regarding social login
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                l10n.socialSignUpNotice,
                textAlign: TextAlign.center,
              ),
            ),

            // Social sign-in buttons would be rendered here by Amplify
            // This is automatically handled by the SignInForm if social providers are configured

            const Divider(),

            // Navigation to Sign Up
            _NavigateToSignUpButton(state: state),
          ],
        ),
      ),
    );
  }
}

// Button to navigate from Sign In to Sign Up
class _NavigateToSignUpButton extends StatelessWidget {
  final AuthenticatorState state;
  const _NavigateToSignUpButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.noAccount),
        TextButton(
          onPressed: () => state.changeStep(AuthenticatorStep.signUp),
          child: Text(l10n.signUp),
        ),
      ],
    );
  }
}
