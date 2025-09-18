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
import 'package:collection/collection.dart';

/** This is an auto generated class representing the CompletedMealLog type in your schema. */
class CompletedMealLog extends amplify_core.Model {
  static const classType = const _CompletedMealLogModelType();
  final String id;
  final List<String>? _completedMealKeys;
  final amplify_core.TemporalDate? _date;
  final String? _userId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  CompletedMealLogModelIdentifier get modelIdentifier {
    return CompletedMealLogModelIdentifier(id: id);
  }

  List<String>? get completedMealKeys {
    return _completedMealKeys;
  }

  amplify_core.TemporalDate get date {
    try {
      return _date!;
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

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const CompletedMealLog._internal(
      {required this.id,
      completedMealKeys,
      required date,
      required userId,
      createdAt,
      updatedAt})
      : _completedMealKeys = completedMealKeys,
        _date = date,
        _userId = userId,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory CompletedMealLog(
      {String? id,
      List<String>? completedMealKeys,
      required amplify_core.TemporalDate date,
      required String userId}) {
    return CompletedMealLog._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        completedMealKeys: completedMealKeys != null
            ? List<String>.unmodifiable(completedMealKeys)
            : completedMealKeys,
        date: date,
        userId: userId);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompletedMealLog &&
        id == other.id &&
        DeepCollectionEquality()
            .equals(_completedMealKeys, other._completedMealKeys) &&
        _date == other._date &&
        _userId == other._userId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("CompletedMealLog {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("completedMealKeys=" +
        (_completedMealKeys != null ? _completedMealKeys!.toString() : "null") +
        ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  CompletedMealLog copyWith(
      {List<String>? completedMealKeys,
      amplify_core.TemporalDate? date,
      String? userId}) {
    return CompletedMealLog._internal(
        id: id,
        completedMealKeys: completedMealKeys ?? this.completedMealKeys,
        date: date ?? this.date,
        userId: userId ?? this.userId);
  }

  CompletedMealLog copyWithModelFieldValues(
      {ModelFieldValue<List<String>>? completedMealKeys,
      ModelFieldValue<amplify_core.TemporalDate>? date,
      ModelFieldValue<String>? userId}) {
    return CompletedMealLog._internal(
        id: id,
        completedMealKeys: completedMealKeys == null
            ? this.completedMealKeys
            : completedMealKeys.value,
        date: date == null ? this.date : date.value,
        userId: userId == null ? this.userId : userId.value);
  }

  CompletedMealLog.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _completedMealKeys = json['completedMealKeys']?.cast<String>(),
        _date = json['date'] != null
            ? amplify_core.TemporalDate.fromString(json['date'])
            : null,
        _userId = json['userId'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'completedMealKeys': _completedMealKeys,
        'date': _date?.format(),
        'userId': _userId,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'completedMealKeys': _completedMealKeys,
        'date': _date,
        'userId': _userId,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core
      .QueryModelIdentifier<CompletedMealLogModelIdentifier> MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<CompletedMealLogModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final COMPLETEDMEALKEYS =
      amplify_core.QueryField(fieldName: "completedMealKeys");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CompletedMealLog";
    modelSchemaDefinition.pluralName = "CompletedMealLogs";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: CompletedMealLog.COMPLETEDMEALKEYS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: CompletedMealLog.DATE,
        isRequired: true,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: CompletedMealLog.USERID,
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

class _CompletedMealLogModelType
    extends amplify_core.ModelType<CompletedMealLog> {
  const _CompletedMealLogModelType();

  @override
  CompletedMealLog fromJson(Map<String, dynamic> jsonData) {
    return CompletedMealLog.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'CompletedMealLog';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [CompletedMealLog] in your schema.
 */
class CompletedMealLogModelIdentifier
    implements amplify_core.ModelIdentifier<CompletedMealLog> {
  final String id;

  /** Create an instance of CompletedMealLogModelIdentifier using [id] the primary key. */
  const CompletedMealLogModelIdentifier({required this.id});

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
  String toString() => 'CompletedMealLogModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CompletedMealLogModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
