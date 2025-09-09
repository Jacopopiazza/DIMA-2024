import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocalizedTitlesResolver extends TitleResolver {
  const LocalizedTitlesResolver();

  /// The title for the confirm sign up Widget.
  @override
  String confirmSignUp(BuildContext context) {
    return AppLocalizations.of(context)!.confirmSignUp;
  }

  /// The title for the confirm sign in (custom auth) Widget.
  @override
  String confirmSignInCustomAuth(BuildContext context) {
    return AppLocalizations.of(context)!.confirmSignInCustomAuth;
  }

  /// The title for the confirm sign in (MFA) Widget.
  @override
  String confirmSignInMfa(BuildContext context) {
    return AppLocalizations.of(context)!.confirmSignInMfa;
  }

  /// The title for the confirm sign in (new password) Widget.
  @override
  String confirmSignInNewPassword(BuildContext context) {
    return AppLocalizations.of(context)!.confirmSignInNewPassword;
  }

  /// The title for the continue sign in (mfa selection) Widget.
  @override
  String continueSignInWithMfaSelection(BuildContext context) {
    return AppLocalizations.of(context)!.continueSignInWithMfaSelection;
  }

  /// The title for the continue sign in (totp setup) Widget.
  @override
  String continueSignInWithTotpSetup(BuildContext context) {
    return AppLocalizations.of(context)!.continueSignInWithTotpSetup;
  }

  /// The title for the confirm sign in (totp MFA code) Widget.
  @override
  String confirmSignInWithTotpMfaCode(BuildContext context) {
    return AppLocalizations.of(context)!.confirmSignInWithTotpMfaCode;
  }

  /// The title for the confirm sign in (email MFA code) Widget.
  @override
  String confirmSignInWithOtpCode(BuildContext context) {
    return AppLocalizations.of(context)!.confirmSignInWithTotpMfaCode;
  }

  /// The title for the continue sign in (email MFA setup) Widget.
  @override
  String continueSignInWithEmailMfaSetup(BuildContext context) {
    return AppLocalizations.of(context)!.continueSignInWithMfaSelection;
  }

  /// The title for the continue sign in (mfa setup selection) Widget.
  @override
  String continueSignInWithMfaSetupSelection(BuildContext context) {
    return AppLocalizations.of(context)!.continueSignInWithTotpSetup;
  }

  /// The title for the reset password Widget.
  @override
  String resetPassword(BuildContext context) {
    return AppLocalizations.of(context)!.resetPassword;
  }

  /// The title for the confirm reset password Widget.
  @override
  String confirmResetPassword(BuildContext context) {
    return AppLocalizations.of(context)!.confirmResetPassword;
  }

  /// The title for the verify user Widget.
  @override
  String verifyUser(BuildContext context) {
    return AppLocalizations.of(context)!.verifyUser;
  }

  @override
  String resolve(BuildContext context, AuthenticatorStep key) {
    switch (key) {
      case AuthenticatorStep.confirmSignUp:
        return confirmSignUp(context);
      case AuthenticatorStep.confirmSignInCustomAuth:
        return confirmSignInCustomAuth(context);
      case AuthenticatorStep.confirmSignInMfa:
        return confirmSignInMfa(context);
      case AuthenticatorStep.confirmSignInNewPassword:
        return confirmSignInNewPassword(context);
      case AuthenticatorStep.continueSignInWithMfaSelection:
        return continueSignInWithMfaSelection(context);
      case AuthenticatorStep.continueSignInWithTotpSetup:
        return continueSignInWithTotpSetup(context);
      case AuthenticatorStep.confirmSignInWithTotpMfaCode:
        return confirmSignInWithTotpMfaCode(context);
      case AuthenticatorStep.confirmSignInWithOtpCode:
        return confirmSignInWithOtpCode(context);
      case AuthenticatorStep.continueSignInWithEmailMfaSetup:
        return continueSignInWithEmailMfaSetup(context);
      case AuthenticatorStep.continueSignInWithMfaSetupSelection:
        return continueSignInWithMfaSetupSelection(context);
      case AuthenticatorStep.resetPassword:
        return resetPassword(context);
      case AuthenticatorStep.confirmResetPassword:
        return confirmResetPassword(context);
      case AuthenticatorStep.verifyUser:
      case AuthenticatorStep.confirmVerifyUser:
        return verifyUser(context);
      case AuthenticatorStep.loading:
      case AuthenticatorStep.onboarding:
      case AuthenticatorStep.signIn:
      case AuthenticatorStep.signUp:
        throw StateError('Invalid step: $this');
    }
  }
}