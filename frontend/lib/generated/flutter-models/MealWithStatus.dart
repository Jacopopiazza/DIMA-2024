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

/** This is an auto generated class representing the MealWithStatus type in your schema. */
class MealWithStatus {
  final bool? _isCompleted;
  final Meal? _meal;

  bool get isCompleted {
    try {
      return _isCompleted!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  Meal get meal {
    try {
      return _meal!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const MealWithStatus._internal({required isCompleted, required meal})
      : _isCompleted = isCompleted,
        _meal = meal;

  factory MealWithStatus({required bool isCompleted, required Meal meal}) {
    return MealWithStatus._internal(isCompleted: isCompleted, meal: meal);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MealWithStatus &&
        _isCompleted == other._isCompleted &&
        _meal == other._meal;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("MealWithStatus {");
    buffer.write("isCompleted=" +
        (_isCompleted != null ? _isCompleted!.toString() : "null") +
        ", ");
    buffer.write("meal=" + (_meal != null ? _meal!.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  MealWithStatus copyWith({bool? isCompleted, Meal? meal}) {
    return MealWithStatus._internal(
        isCompleted: isCompleted ?? this.isCompleted, meal: meal ?? this.meal);
  }

  MealWithStatus copyWithModelFieldValues(
      {ModelFieldValue<bool>? isCompleted, ModelFieldValue<Meal>? meal}) {
    return MealWithStatus._internal(
        isCompleted: isCompleted == null ? this.isCompleted : isCompleted.value,
        meal: meal == null ? this.meal : meal.value);
  }

  MealWithStatus.fromJson(Map<String, dynamic> json)
      : _isCompleted = json['isCompleted'],
        _meal = json['meal'] != null
            ? json['meal']['serializedData'] != null
                ? Meal.fromJson(new Map<String, dynamic>.from(
                    json['meal']['serializedData']))
                : Meal.fromJson(new Map<String, dynamic>.from(json['meal']))
            : null;

  Map<String, dynamic> toJson() =>
      {'isCompleted': _isCompleted, 'meal': _meal?.toJson()};

  Map<String, Object?> toMap() => {'isCompleted': _isCompleted, 'meal': _meal};

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MealWithStatus";
    modelSchemaDefinition.pluralName = "MealWithStatuses";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'isCompleted',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'meal',
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embedded,
            ofCustomTypeName: 'Meal')));
  });
}
