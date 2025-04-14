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


/** This is an auto generated class representing the CompletedMealInfo type in your schema. */
class CompletedMealInfo {
  final amplify_core.TemporalDateTime? _completionTimestamp;
  final MealNameEnum? _mealName;
  final String? _mealPlanId;

  amplify_core.TemporalDateTime get completionTimestamp {
    try {
      return _completionTimestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  MealNameEnum get mealName {
    try {
      return _mealName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get mealPlanId {
    try {
      return _mealPlanId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const CompletedMealInfo._internal({required completionTimestamp, required mealName, required mealPlanId}): _completionTimestamp = completionTimestamp, _mealName = mealName, _mealPlanId = mealPlanId;
  
  factory CompletedMealInfo({required amplify_core.TemporalDateTime completionTimestamp, required MealNameEnum mealName, required String mealPlanId}) {
    return CompletedMealInfo._internal(
      completionTimestamp: completionTimestamp,
      mealName: mealName,
      mealPlanId: mealPlanId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompletedMealInfo &&
      _completionTimestamp == other._completionTimestamp &&
      _mealName == other._mealName &&
      _mealPlanId == other._mealPlanId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CompletedMealInfo {");
    buffer.write("completionTimestamp=" + (_completionTimestamp != null ? _completionTimestamp!.format() : "null") + ", ");
    buffer.write("mealName=" + (_mealName != null ? amplify_core.enumToString(_mealName)! : "null") + ", ");
    buffer.write("mealPlanId=" + "$_mealPlanId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CompletedMealInfo copyWith({amplify_core.TemporalDateTime? completionTimestamp, MealNameEnum? mealName, String? mealPlanId}) {
    return CompletedMealInfo._internal(
      completionTimestamp: completionTimestamp ?? this.completionTimestamp,
      mealName: mealName ?? this.mealName,
      mealPlanId: mealPlanId ?? this.mealPlanId);
  }
  
  CompletedMealInfo copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime>? completionTimestamp,
    ModelFieldValue<MealNameEnum>? mealName,
    ModelFieldValue<String>? mealPlanId
  }) {
    return CompletedMealInfo._internal(
      completionTimestamp: completionTimestamp == null ? this.completionTimestamp : completionTimestamp.value,
      mealName: mealName == null ? this.mealName : mealName.value,
      mealPlanId: mealPlanId == null ? this.mealPlanId : mealPlanId.value
    );
  }
  
  CompletedMealInfo.fromJson(Map<String, dynamic> json)  
    : _completionTimestamp = json['completionTimestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['completionTimestamp']) : null,
      _mealName = amplify_core.enumFromString<MealNameEnum>(json['mealName'], MealNameEnum.values),
      _mealPlanId = json['mealPlanId'];
  
  Map<String, dynamic> toJson() => {
    'completionTimestamp': _completionTimestamp?.format(), 'mealName': amplify_core.enumToString(_mealName), 'mealPlanId': _mealPlanId
  };
  
  Map<String, Object?> toMap() => {
    'completionTimestamp': _completionTimestamp,
    'mealName': _mealName,
    'mealPlanId': _mealPlanId
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CompletedMealInfo";
    modelSchemaDefinition.pluralName = "CompletedMealInfos";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'completionTimestamp',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'mealName',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'mealPlanId',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}