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

/** This is an auto generated class representing the UserSubscriptionStatus type in your schema. */
class UserSubscriptionStatus {
  final SubscriptionStatusEnum? _subscriptionStatus;
  final String? _userId;

  SubscriptionStatusEnum get subscriptionStatus {
    try {
      return _subscriptionStatus!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get userId {
    try {
      return _userId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const UserSubscriptionStatus._internal(
      {required subscriptionStatus, required userId})
      : _subscriptionStatus = subscriptionStatus,
        _userId = userId;

  factory UserSubscriptionStatus(
      {required SubscriptionStatusEnum subscriptionStatus,
      required String userId}) {
    return UserSubscriptionStatus._internal(
        subscriptionStatus: subscriptionStatus, userId: userId);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSubscriptionStatus &&
        _subscriptionStatus == other._subscriptionStatus &&
        _userId == other._userId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("UserSubscriptionStatus {");
    buffer.write("subscriptionStatus=" +
        (_subscriptionStatus != null
            ? amplify_core.enumToString(_subscriptionStatus)!
            : "null") +
        ", ");
    buffer.write("userId=" + "$_userId");
    buffer.write("}");

    return buffer.toString();
  }

  UserSubscriptionStatus copyWith(
      {SubscriptionStatusEnum? subscriptionStatus, String? userId}) {
    return UserSubscriptionStatus._internal(
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        userId: userId ?? this.userId);
  }

  UserSubscriptionStatus copyWithModelFieldValues(
      {ModelFieldValue<SubscriptionStatusEnum>? subscriptionStatus,
      ModelFieldValue<String>? userId}) {
    return UserSubscriptionStatus._internal(
        subscriptionStatus: subscriptionStatus == null
            ? this.subscriptionStatus
            : subscriptionStatus.value,
        userId: userId == null ? this.userId : userId.value);
  }

  UserSubscriptionStatus.fromJson(Map<String, dynamic> json)
      : _subscriptionStatus =
            amplify_core.enumFromString<SubscriptionStatusEnum>(
                json['subscriptionStatus'], SubscriptionStatusEnum.values),
        _userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'subscriptionStatus': amplify_core.enumToString(_subscriptionStatus),
        'userId': _userId
      };

  Map<String, Object?> toMap() =>
      {'subscriptionStatus': _subscriptionStatus, 'userId': _userId};

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserSubscriptionStatus";
    modelSchemaDefinition.pluralName = "UserSubscriptionStatuses";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'subscriptionStatus',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'userId',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));
  });
}
