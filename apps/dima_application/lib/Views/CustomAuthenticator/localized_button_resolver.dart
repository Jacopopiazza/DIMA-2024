import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

class LocalizedButtonResolver extends ButtonResolver {
  const LocalizedButtonResolver();

  @override
  String signIn(BuildContext context) {
    return AppLocalizations.of(context)!.signIn;
  }

  @override
  String signUp(BuildContext context) {
    return AppLocalizations.of(context)!.signUp;
  }

  @override
  String confirm(BuildContext context) {
    return AppLocalizations.of(context)!.confirm;
  }

  @override
  String continueLabel(BuildContext context) {
    return AppLocalizations.of(context)!.continueLabel;
  }

  @override
  String submit(BuildContext context) {
    return AppLocalizations.of(context)!.submit;
  }

  @override
  String changePassword(BuildContext context) {
    return AppLocalizations.of(context)!.changePassword;
  }

  @override
  String sendCode(BuildContext context) {
    return AppLocalizations.of(context)!.sendCode;
  }

  @override
  String lostCode(BuildContext context) {
    return AppLocalizations.of(context)!.lostCode;
  }

  @override
  String verify(BuildContext context) {
    return AppLocalizations.of(context)!.verify;
  }

  @override
  String signout(BuildContext context) {
    return AppLocalizations.of(context)!.signOut;
  }

  @override
  String signInWith(BuildContext context, AuthProvider provider) {
    return AppLocalizations.of(context)!.signInWith(provider.name);
  }

  @override
  String noAccount(BuildContext context) {
    return AppLocalizations.of(context)!.noAccount;
  }

  @override
  String haveAccount(BuildContext context) {
    return AppLocalizations.of(context)!.haveAccount;
  }

  @override
  String forgotPassword(BuildContext context) {
    return AppLocalizations.of(context)!.forgotPassword;
  }

  @override
  String confirmResetPassword(BuildContext context) {
    return AppLocalizations.of(context)!.confirmResetPassword;
  }

  @override
  String backTo(BuildContext context, AuthenticatorStep previousStep) {
    return AppLocalizations.of(context)!.backTo(previousStep.name);
  }

  @override
  String skip(BuildContext context) {
    return AppLocalizations.of(context)!.skip;
  }

  @override
  String copyKey(BuildContext context) {
    return AppLocalizations.of(context)!.copyKey;
  }

}
