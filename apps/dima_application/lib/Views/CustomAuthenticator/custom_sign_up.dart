import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/Utils/user_type_enum.dart';
import 'package:dima_application/Views/CustomAuthenticator/role_selection_field.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Custom Sign Up View with Role Selection Field
class SignUpView extends StatelessWidget {
  final AuthenticatorState state;
  const SignUpView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: AuthenticatorForm(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Your app logo
                const Center(child: FlutterLogo(size: 100)),
                // Prebuilt fields for username, email, and passwords
                SignUpFormField.email(required: true),
                SignUpFormField.password(),
                SignUpFormField.passwordConfirmation(),
                SignUpFormField.givenName(required: true),
                SignUpFormField.familyName(required: true),
                SignUpFormField.gender(required: false),
                SignUpFormField.birthdate(required: false),

                // Custom Role Selection field
                RoleSelectionField(
                  onChanged: (role) {
                    // Save the selected role as a custom attribute
                    state.setCustomAttribute(
                      CognitoUserAttributeKey.custom('role'),
                      role ?? UserTypeEnum.user.value,
                    );
                  },
                ), // Built-in sign up Rbutton
                _SignUpButton(),
                const SizedBox(height: 16),
                const Divider(),
                // Navigation to Sign In
                _NavigateToSignInButton(state: state),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends SignUpButton {
  _SignUpButton({Key? key})
      : super(
          key: key ?? Key('signUpButton'),
        );

  @override
  void onPressed(BuildContext context, AuthenticatorState state) {
    // Set a default custom attribute for subscription status
    state.setCustomAttribute(
      CognitoUserAttributeKey.custom('subscriptionStatus'),
      'FREE',
    );
    // Trigger the sign-up process
    state.signUp();
  }
}

// Button to navigate from Sign Up to Sign In
class _NavigateToSignInButton extends StatelessWidget {
  final AuthenticatorState state;
  const _NavigateToSignInButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.haveAccount),
        TextButton(
          onPressed: () => state.changeStep(AuthenticatorStep.signIn),
          child: Text(l10n.signIn),
        ),
      ],
    );
  }
}
