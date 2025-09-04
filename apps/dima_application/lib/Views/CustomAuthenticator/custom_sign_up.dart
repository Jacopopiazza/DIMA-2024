import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/Utils/user_type_enum.dart';
import 'package:dima_application/Views/CustomAuthenticator/gender_selection_field.dart';
import 'package:dima_application/Views/CustomAuthenticator/role_selection_field.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Custom Sign Up View with Role Selection Field
class SignUpView extends StatefulWidget {
  final AuthenticatorState state;
  const SignUpView({super.key, required this.state});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.state.authAttributes[CognitoUserAttributeKey.birthdate] =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  // No custom TextField decoration function needed after switching back to built-in fields

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        child: AuthenticatorForm(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person_add_rounded,
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Create your account',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Use Amplify built-in fields for auth wiring, keep our container styling around them
                          SignUpFormField.email(required: true),
                          SignUpFormField.password(),
                          SignUpFormField.passwordConfirmation(),
                          SignUpFormField.givenName(required: true),
                          SignUpFormField.familyName(required: true),
                          const SizedBox(height: 16),

                          GenderSelectionField(
                            onChanged: (value) {
                              if (value == null) {
                                widget.state.authAttributes[
                                    CognitoUserAttributeKey.gender] = 'other';
                              } else {
                                final lower = value.toLowerCase();
                                widget.state.authAttributes[
                                        CognitoUserAttributeKey.gender] =
                                    (lower == 'male' || lower == 'female')
                                        ? lower
                                        : 'other';
                              }
                            },
                            isRequired: false,
                          ),
                          InkWell(
                            onTap: _selectDate,
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Birthdate',
                                prefixIcon:
                                    const Icon(Icons.cake_rounded, size: 20),
                                suffixIcon: const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: colorScheme.outline),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color:
                                          colorScheme.outline.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              child: Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                    : 'Select date',
                                style: TextStyle(
                                  color: _selectedDate != null
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Role Selection
                          RoleSelectionField(
                            onChanged: (role) {
                              widget.state.setCustomAttribute(
                                CognitoUserAttributeKey.custom('role'),
                                role ?? UserTypeEnum.user.value,
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Sign up button styled like settings save
                          Center(
                            child: FilledButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState?.validate() !=
                                          true) {
                                        return;
                                      }
                                      _SignUpButton.trigger(
                                          context, widget.state,
                                          setLoading: (v) {
                                        setState(() => _isLoading = v);
                                      });
                                    },
                              icon: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                colorScheme.onPrimary),
                                      ),
                                    )
                                  : const Icon(Icons.person_add_alt_1_rounded,
                                      size: 20),
                              label: Text(
                                _isLoading
                                    ? 'Creating account...'
                                    : 'Create Account',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          _NavigateToSignInButton(state: widget.state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends SignUpButton {
  _SignUpButton({Key? key}) : super(key: key ?? Key('signUpButton'));

  static void trigger(BuildContext context, AuthenticatorState state,
      {required void Function(bool) setLoading}) async {
    setLoading(true);
    try {
      if (state.getAttribute(CognitoUserAttributeKey.gender) != null) {
        final gender = state.getAttribute(CognitoUserAttributeKey.gender)!;
        if (gender.toLowerCase() != 'male' &&
            gender.toLowerCase() != 'female') {
          state.authAttributes[CognitoUserAttributeKey.gender] = 'other';
        }
      }

      state.setCustomAttribute(
        CognitoUserAttributeKey.custom('subscriptionStatus'),
        'FREE',
      );

      await state.signUp();
    } finally {
      setLoading(false);
    }
  }

  @override
  void onPressed(BuildContext context, AuthenticatorState state) {
    trigger(context, state, setLoading: (_) {});
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
