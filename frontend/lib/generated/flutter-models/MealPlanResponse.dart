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

/** This is an auto generated class representing the MealPlanResponse type in your schema. */
class MealPlanResponse {
  final String? _mealPlanId;
  final String? _message;
  final bool? _success;

  String get mealPlanId {
    try {
      return _mealPlanId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get message {
    return _message;
  }

  bool get success {
    try {
      return _success!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const MealPlanResponse._internal(
      {required mealPlanId, message, required success})
      : _mealPlanId = mealPlanId,
        _message = message,
        _success = success;

  factory MealPlanResponse(
      {required String mealPlanId, String? message, required bool success}) {
    return MealPlanResponse._internal(
        mealPlanId: mealPlanId, message: message, success: success);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MealPlanResponse &&
        _mealPlanId == other._mealPlanId &&
        _message == other._message &&
        _success == other._success;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("MealPlanResponse {");
    buffer.write("mealPlanId=" + "$_mealPlanId" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer
        .write("success=" + (_success != null ? _success!.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  MealPlanResponse copyWith(
      {String? mealPlanId, String? message, bool? success}) {
    return MealPlanResponse._internal(
        mealPlanId: mealPlanId ?? this.mealPlanId,
        message: message ?? this.message,
        success: success ?? this.success);
  }

  MealPlanResponse copyWithModelFieldValues(
      {ModelFieldValue<String>? mealPlanId,
      ModelFieldValue<String?>? message,
      ModelFieldValue<bool>? success}) {
    return MealPlanResponse._internal(
        mealPlanId: mealPlanId == null ? this.mealPlanId : mealPlanId.value,
        message: message == null ? this.message : message.value,
        success: success == null ? this.success : success.value);
  }

  MealPlanResponse.fromJson(Map<String, dynamic> json)
      : _mealPlanId = json['mealPlanId'],
        _message = json['message'],
        _success = json['success'];

  Map<String, dynamic> toJson() =>
      {'mealPlanId': _mealPlanId, 'message': _message, 'success': _success};

  Map<String, Object?> toMap() =>
      {'mealPlanId': _mealPlanId, 'message': _message, 'success': _success};

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MealPlanResponse";
    modelSchemaDefinition.pluralName = "MealPlanResponses";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'mealPlanId',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'message',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'success',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.bool)));
  });
}
