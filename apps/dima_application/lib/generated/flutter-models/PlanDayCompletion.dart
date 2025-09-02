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

/** This is an auto generated class representing the PlanDayCompletion type in your schema. */
class PlanDayCompletion extends amplify_core.Model {
  static const classType = const _PlanDayCompletionModelType();
  final String id;
  final List<MealNameEnum>? _completedMealNames;
  final amplify_core.TemporalDate? _date;
  final String? _planId;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _userId;
  final amplify_core.TemporalDateTime? _createdAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PlanDayCompletionModelIdentifier get modelIdentifier {
    return PlanDayCompletionModelIdentifier(id: id);
  }

  List<MealNameEnum> get completedMealNames {
    try {
      return _completedMealNames!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
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

  String get planId {
    try {
      return _planId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  amplify_core.TemporalDateTime get updatedAt {
    try {
      return _updatedAt!;
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

  const PlanDayCompletion._internal(
      {required this.id,
      required completedMealNames,
      required date,
      required planId,
      required updatedAt,
      required userId,
      createdAt})
      : _completedMealNames = completedMealNames,
        _date = date,
        _planId = planId,
        _updatedAt = updatedAt,
        _userId = userId,
        _createdAt = createdAt;

  factory PlanDayCompletion(
      {String? id,
      required List<MealNameEnum> completedMealNames,
      required amplify_core.TemporalDate date,
      required String planId,
      required amplify_core.TemporalDateTime updatedAt,
      required String userId}) {
    return PlanDayCompletion._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        completedMealNames: completedMealNames != null
            ? List<MealNameEnum>.unmodifiable(completedMealNames)
            : completedMealNames,
        date: date,
        planId: planId,
        updatedAt: updatedAt,
        userId: userId);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlanDayCompletion &&
        id == other.id &&
        DeepCollectionEquality()
            .equals(_completedMealNames, other._completedMealNames) &&
        _date == other._date &&
        _planId == other._planId &&
        _updatedAt == other._updatedAt &&
        _userId == other._userId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("PlanDayCompletion {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("completedMealNames=" +
        (_completedMealNames != null
            ? _completedMealNames!
                .map((e) => amplify_core.enumToString(e))
                .toString()
            : "null") +
        ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("planId=" + "$_planId" + ", ");
    buffer.write("updatedAt=" +
        (_updatedAt != null ? _updatedAt!.format() : "null") +
        ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write(
        "createdAt=" + (_createdAt != null ? _createdAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  PlanDayCompletion copyWith(
      {List<MealNameEnum>? completedMealNames,
      amplify_core.TemporalDate? date,
      String? planId,
      amplify_core.TemporalDateTime? updatedAt,
      String? userId}) {
    return PlanDayCompletion._internal(
        id: id,
        completedMealNames: completedMealNames ?? this.completedMealNames,
        date: date ?? this.date,
        planId: planId ?? this.planId,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId);
  }

  PlanDayCompletion copyWithModelFieldValues(
      {ModelFieldValue<List<MealNameEnum>>? completedMealNames,
      ModelFieldValue<amplify_core.TemporalDate>? date,
      ModelFieldValue<String>? planId,
      ModelFieldValue<amplify_core.TemporalDateTime>? updatedAt,
      ModelFieldValue<String>? userId}) {
    return PlanDayCompletion._internal(
        id: id,
        completedMealNames: completedMealNames == null
            ? this.completedMealNames
            : completedMealNames.value,
        date: date == null ? this.date : date.value,
        planId: planId == null ? this.planId : planId.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
        userId: userId == null ? this.userId : userId.value);
  }

  PlanDayCompletion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _completedMealNames = json['completedMealNames'] is List
            ? (json['completedMealNames'] as List)
                .map((e) => amplify_core.enumFromString<MealNameEnum>(
                    e, MealNameEnum.values)!)
                .toList()
            : null,
        _date = json['date'] != null
            ? amplify_core.TemporalDate.fromString(json['date'])
            : null,
        _planId = json['planId'],
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null,
        _userId = json['userId'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'completedMealNames': _completedMealNames
            ?.map((e) => amplify_core.enumToString(e))
            .toList(),
        'date': _date?.format(),
        'planId': _planId,
        'updatedAt': _updatedAt?.format(),
        'userId': _userId,
        'createdAt': _createdAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'completedMealNames': _completedMealNames,
        'date': _date,
        'planId': _planId,
        'updatedAt': _updatedAt,
        'userId': _userId,
        'createdAt': _createdAt
      };

  static final amplify_core
      .QueryModelIdentifier<PlanDayCompletionModelIdentifier> MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<PlanDayCompletionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final COMPLETEDMEALNAMES =
      amplify_core.QueryField(fieldName: "completedMealNames");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final PLANID = amplify_core.QueryField(fieldName: "planId");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PlanDayCompletion";
    modelSchemaDefinition.pluralName = "PlanDayCompletions";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PlanDayCompletion.COMPLETEDMEALNAMES,
        isRequired: true,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.enumeration.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PlanDayCompletion.DATE,
        isRequired: true,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PlanDayCompletion.PLANID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PlanDayCompletion.UPDATEDAT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PlanDayCompletion.USERID,
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
  });
}

class _PlanDayCompletionModelType
    extends amplify_core.ModelType<PlanDayCompletion> {
  const _PlanDayCompletionModelType();

  @override
  PlanDayCompletion fromJson(Map<String, dynamic> jsonData) {
    return PlanDayCompletion.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'PlanDayCompletion';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PlanDayCompletion] in your schema.
 */
class PlanDayCompletionModelIdentifier
    implements amplify_core.ModelIdentifier<PlanDayCompletion> {
  final String id;

  /** Create an instance of PlanDayCompletionModelIdentifier using [id] the primary key. */
  const PlanDayCompletionModelIdentifier({required this.id});

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
  String toString() => 'PlanDayCompletionModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PlanDayCompletionModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
