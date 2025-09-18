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

/** This is an auto generated class representing the MealPlanNotification type in your schema. */
class MealPlanNotification extends amplify_core.Model {
  static const classType = const _MealPlanNotificationModelType();
  final String id;
  final String? _mealPlanId;
  final String? _message;
  final String? _status;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  MealPlanNotificationModelIdentifier get modelIdentifier {
    return MealPlanNotificationModelIdentifier(id: id);
  }

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

  String get message {
    try {
      return _message!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get status {
    try {
      return _status!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const MealPlanNotification._internal(
      {required this.id,
      required mealPlanId,
      required message,
      required status,
      createdAt,
      updatedAt})
      : _mealPlanId = mealPlanId,
        _message = message,
        _status = status,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory MealPlanNotification(
      {String? id,
      required String mealPlanId,
      required String message,
      required String status}) {
    return MealPlanNotification._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        mealPlanId: mealPlanId,
        message: message,
        status: status);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MealPlanNotification &&
        id == other.id &&
        _mealPlanId == other._mealPlanId &&
        _message == other._message &&
        _status == other._status;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("MealPlanNotification {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("mealPlanId=" + "$_mealPlanId" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  MealPlanNotification copyWith(
      {String? mealPlanId, String? message, String? status}) {
    return MealPlanNotification._internal(
        id: id,
        mealPlanId: mealPlanId ?? this.mealPlanId,
        message: message ?? this.message,
        status: status ?? this.status);
  }

  MealPlanNotification copyWithModelFieldValues(
      {ModelFieldValue<String>? mealPlanId,
      ModelFieldValue<String>? message,
      ModelFieldValue<String>? status}) {
    return MealPlanNotification._internal(
        id: id,
        mealPlanId: mealPlanId == null ? this.mealPlanId : mealPlanId.value,
        message: message == null ? this.message : message.value,
        status: status == null ? this.status : status.value);
  }

  MealPlanNotification.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _mealPlanId = json['mealPlanId'],
        _message = json['message'],
        _status = json['status'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mealPlanId': _mealPlanId,
        'message': _message,
        'status': _status,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'mealPlanId': _mealPlanId,
        'message': _message,
        'status': _status,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core
      .QueryModelIdentifier<MealPlanNotificationModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<MealPlanNotificationModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MEALPLANID = amplify_core.QueryField(fieldName: "mealPlanId");
  static final MESSAGE = amplify_core.QueryField(fieldName: "message");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MealPlanNotification";
    modelSchemaDefinition.pluralName = "MealPlanNotifications";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlanNotification.MEALPLANID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlanNotification.MESSAGE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlanNotification.STATUS,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'createdAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'updatedAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _MealPlanNotificationModelType
    extends amplify_core.ModelType<MealPlanNotification> {
  const _MealPlanNotificationModelType();

  @override
  MealPlanNotification fromJson(Map<String, dynamic> jsonData) {
    return MealPlanNotification.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'MealPlanNotification';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MealPlanNotification] in your schema.
 */
class MealPlanNotificationModelIdentifier
    implements amplify_core.ModelIdentifier<MealPlanNotification> {
  final String id;

  /** Create an instance of MealPlanNotificationModelIdentifier using [id] the primary key. */
  const MealPlanNotificationModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'MealPlanNotificationModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MealPlanNotificationModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
