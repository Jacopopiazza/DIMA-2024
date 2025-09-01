import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum GenderTypeEnum {
  Male('MALE'),
  Female('FEMALE'),
  Other('OTHER');

  const GenderTypeEnum(this.value);
  final String value;

  // Get localized display value
  String localizedValue(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case GenderTypeEnum.Male:
        return l10n.maleGender;
      case GenderTypeEnum.Female:
        return l10n.femaleGender;
      case GenderTypeEnum.Other:
        return l10n.otherGender;
    }
  }

  static GenderTypeEnum fromValue(String value) {
    return GenderTypeEnum.values.firstWhere(
      (type) => type.value == value,
    );
  }

  static bool contains(String value) {
    return GenderTypeEnum.values.any((type) => type.value == value);
  }

}
