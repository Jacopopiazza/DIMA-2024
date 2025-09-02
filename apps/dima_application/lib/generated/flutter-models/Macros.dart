/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;

/** This is an auto generated class representing the Macros type in your schema. */
class Macros {
  final double? _calories;
  final double? _carbohydrates;
  final double? _fats;
  final double? _proteins;

  double get calories {
    try {
      return _calories!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get carbohydrates {
    try {
      return _carbohydrates!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get fats {
    try {
      return _fats!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get proteins {
    try {
      return _proteins!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const Macros._internal(
      {required calories,
      required carbohydrates,
      required fats,
      required proteins})
      : _calories = calories,
        _carbohydrates = carbohydrates,
        _fats = fats,
        _proteins = proteins;

  factory Macros(
      {required double calories,
      required double carbohydrates,
      required double fats,
      required double proteins}) {
    return Macros._internal(
        calories: calories,
        carbohydrates: carbohydrates,
        fats: fats,
        proteins: proteins);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Macros &&
        _calories == other._calories &&
        _carbohydrates == other._carbohydrates &&
        _fats == other._fats &&
        _proteins == other._proteins;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Macros {");
    buffer.write("calories=" +
        (_calories != null ? _calories!.toString() : "null") +
        ", ");
    buffer.write("carbohydrates=" +
        (_carbohydrates != null ? _carbohydrates!.toString() : "null") +
        ", ");
    buffer.write("fats=" + (_fats != null ? _fats!.toString() : "null") + ", ");
    buffer.write(
        "proteins=" + (_proteins != null ? _proteins!.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Macros copyWith(
      {double? calories,
      double? carbohydrates,
      double? fats,
      double? proteins}) {
    return Macros._internal(
        calories: calories ?? this.calories,
        carbohydrates: carbohydrates ?? this.carbohydrates,
        fats: fats ?? this.fats,
        proteins: proteins ?? this.proteins);
  }

  Macros copyWithModelFieldValues(
      {ModelFieldValue<double>? calories,
      ModelFieldValue<double>? carbohydrates,
      ModelFieldValue<double>? fats,
      ModelFieldValue<double>? proteins}) {
    return Macros._internal(
        calories: calories == null ? this.calories : calories.value,
        carbohydrates:
            carbohydrates == null ? this.carbohydrates : carbohydrates.value,
        fats: fats == null ? this.fats : fats.value,
        proteins: proteins == null ? this.proteins : proteins.value);
  }

  Macros.fromJson(Map<String, dynamic> json)
      : _calories = (json['calories'] as num?)?.toDouble(),
        _carbohydrates = (json['carbohydrates'] as num?)?.toDouble(),
        _fats = (json['fats'] as num?)?.toDouble(),
        _proteins = (json['proteins'] as num?)?.toDouble();

  Map<String, dynamic> toJson() => {
        'calories': _calories,
        'carbohydrates': _carbohydrates,
        'fats': _fats,
        'proteins': _proteins
      };

  Map<String, Object?> toMap() => {
        'calories': _calories,
        'carbohydrates': _carbohydrates,
        'fats': _fats,
        'proteins': _proteins
      };

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Macros";
    modelSchemaDefinition.pluralName = "Macros";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'calories',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'carbohydrates',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'fats',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'proteins',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.double)));
  });
}
