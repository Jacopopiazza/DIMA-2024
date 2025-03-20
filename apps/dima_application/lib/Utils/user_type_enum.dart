import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum UserTypeEnum {
  user('USER'),
  nutritionist('NUTRITIONIST');

  const UserTypeEnum(this.value);
  final String value;

  // Get localized display value
  String localizedValue(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case UserTypeEnum.user:
        return l10n.userRole;
      case UserTypeEnum.nutritionist:
        return l10n.nutritionistRole;
    }
  }

  static UserTypeEnum fromValue(String value) {
    return UserTypeEnum.values.firstWhere(
      (type) => type.value == value,
    );
  }

  static bool contains(String value) {
    return UserTypeEnum.values.any((type) => type.value == value);
  }

}
