import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocalizedInputResolver extends InputResolver {
  const LocalizedInputResolver();

  /// Returns the label displayed as the input hint.
  String hint(BuildContext context, InputField field) {
    final fieldName = title(context, field);
    final lowercasedFieldName = fieldName.toLowerCase();
    return AppLocalizations.of(context)!
        .promptFill(lowercasedFieldName);
  }

  /// Returns the hint text used for confirmation fields where the
  /// user is asked to re-enter information prior to form submission.
  String confirmHint(BuildContext context, InputField field) {
    final fieldName = AppLocalizations.of(context)!.password;
    final lowercasedFieldName = fieldName.toLowerCase();
    return AppLocalizations.of(context)!
        .promptRefill(lowercasedFieldName);
  }

  @override
  String title(BuildContext context, InputField field) {
    switch (field) {
      case InputField.username:
        return AppLocalizations.of(context)!.username;
      case InputField.password:
        return AppLocalizations.of(context)!.password;
      case InputField.email:
        return AppLocalizations.of(context)!.email;
      case InputField.passwordConfirmation:
        return AppLocalizations.of(context)!.confirmNewPassword;
      case InputField.givenName:
        return AppLocalizations.of(context)!.givenName;
      case InputField.familyName:
        return AppLocalizations.of(context)!.familyName;
      case InputField.phoneNumber:
        return AppLocalizations.of(context)!.phoneNumber;
      case InputField.verificationCode:
        return AppLocalizations.of(context)!.verificationCode;
      case InputField.newPassword:
        return AppLocalizations.of(context)!.newPassword;
      case InputField.address:
        return AppLocalizations.of(context)!.address;
      case InputField.birthdate:
        return AppLocalizations.of(context)!.birthdate;
      default:
        return super.title(context, field);
    }
  }

  
}