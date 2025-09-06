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

/** This is an auto generated class representing the MealPlan type in your schema. */
class MealPlan extends amplify_core.Model {
  static const classType = const _MealPlanModelType();
  final String id;
  final String? _assignedNutritionistId;
  final String? _chatId;
  final DailyPlanData? _dailyPlan;
  final String? _errorDetails;
  final amplify_core.TemporalDateTime? _generatedAt;
  final String? _mealPlanId;
  final String? _nutritionistFullName;
  final String? _planName;
  final PlanStatus? _status;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _userFullName;
  final String? _userId;
  final MealPlanValidationStatus? _validationStatus;
  final amplify_core.TemporalDateTime? _createdAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  MealPlanModelIdentifier get modelIdentifier {
    return MealPlanModelIdentifier(id: id);
  }

  String? get assignedNutritionistId {
    return _assignedNutritionistId;
  }

  String? get chatId {
    return _chatId;
  }

  DailyPlanData? get dailyPlan {
    return _dailyPlan;
  }

  String? get errorDetails {
    return _errorDetails;
  }

  amplify_core.TemporalDateTime? get generatedAt {
    return _generatedAt;
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

  String? get nutritionistFullName {
    return _nutritionistFullName;
  }

  String? get planName {
    return _planName;
  }

  PlanStatus? get status {
    return _status;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  String? get userFullName {
    return _userFullName;
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

  MealPlanValidationStatus? get validationStatus {
    return _validationStatus;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  const MealPlan._internal(
      {required this.id,
      assignedNutritionistId,
      chatId,
      dailyPlan,
      errorDetails,
      generatedAt,
      required mealPlanId,
      nutritionistFullName,
      planName,
      status,
      updatedAt,
      userFullName,
      required userId,
      validationStatus,
      createdAt})
      : _assignedNutritionistId = assignedNutritionistId,
        _chatId = chatId,
        _dailyPlan = dailyPlan,
        _errorDetails = errorDetails,
        _generatedAt = generatedAt,
        _mealPlanId = mealPlanId,
        _nutritionistFullName = nutritionistFullName,
        _planName = planName,
        _status = status,
        _updatedAt = updatedAt,
        _userFullName = userFullName,
        _userId = userId,
        _validationStatus = validationStatus,
        _createdAt = createdAt;

  factory MealPlan(
      {String? id,
      String? assignedNutritionistId,
      String? chatId,
      DailyPlanData? dailyPlan,
      String? errorDetails,
      amplify_core.TemporalDateTime? generatedAt,
      required String mealPlanId,
      String? nutritionistFullName,
      String? planName,
      PlanStatus? status,
      amplify_core.TemporalDateTime? updatedAt,
      String? userFullName,
      required String userId,
      MealPlanValidationStatus? validationStatus}) {
    return MealPlan._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        assignedNutritionistId: assignedNutritionistId,
        chatId: chatId,
        dailyPlan: dailyPlan,
        errorDetails: errorDetails,
        generatedAt: generatedAt,
        mealPlanId: mealPlanId,
        nutritionistFullName: nutritionistFullName,
        planName: planName,
        status: status,
        updatedAt: updatedAt,
        userFullName: userFullName,
        userId: userId,
        validationStatus: validationStatus);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MealPlan &&
        id == other.id &&
        _assignedNutritionistId == other._assignedNutritionistId &&
        _chatId == other._chatId &&
        _dailyPlan == other._dailyPlan &&
        _errorDetails == other._errorDetails &&
        _generatedAt == other._generatedAt &&
        _mealPlanId == other._mealPlanId &&
        _nutritionistFullName == other._nutritionistFullName &&
        _planName == other._planName &&
        _status == other._status &&
        _updatedAt == other._updatedAt &&
        _userFullName == other._userFullName &&
        _userId == other._userId &&
        _validationStatus == other._validationStatus;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("MealPlan {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("assignedNutritionistId=" + "$_assignedNutritionistId" + ", ");
    buffer.write("chatId=" + "$_chatId" + ", ");
    buffer.write("dailyPlan=" +
        (_dailyPlan != null ? _dailyPlan!.toString() : "null") +
        ", ");
    buffer.write("errorDetails=" + "$_errorDetails" + ", ");
    buffer.write("generatedAt=" +
        (_generatedAt != null ? _generatedAt!.format() : "null") +
        ", ");
    buffer.write("mealPlanId=" + "$_mealPlanId" + ", ");
    buffer.write("nutritionistFullName=" + "$_nutritionistFullName" + ", ");
    buffer.write("planName=" + "$_planName" + ", ");
    buffer.write("status=" +
        (_status != null ? amplify_core.enumToString(_status)! : "null") +
        ", ");
    buffer.write("updatedAt=" +
        (_updatedAt != null ? _updatedAt!.format() : "null") +
        ", ");
    buffer.write("userFullName=" + "$_userFullName" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("validationStatus=" +
        (_validationStatus != null
            ? amplify_core.enumToString(_validationStatus)!
            : "null") +
        ", ");
    buffer.write(
        "createdAt=" + (_createdAt != null ? _createdAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  MealPlan copyWith(
      {String? assignedNutritionistId,
      String? chatId,
      DailyPlanData? dailyPlan,
      String? errorDetails,
      amplify_core.TemporalDateTime? generatedAt,
      String? mealPlanId,
      String? nutritionistFullName,
      String? planName,
      PlanStatus? status,
      amplify_core.TemporalDateTime? updatedAt,
      String? userFullName,
      String? userId,
      MealPlanValidationStatus? validationStatus}) {
    return MealPlan._internal(
        id: id,
        assignedNutritionistId:
            assignedNutritionistId ?? this.assignedNutritionistId,
        chatId: chatId ?? this.chatId,
        dailyPlan: dailyPlan ?? this.dailyPlan,
        errorDetails: errorDetails ?? this.errorDetails,
        generatedAt: generatedAt ?? this.generatedAt,
        mealPlanId: mealPlanId ?? this.mealPlanId,
        nutritionistFullName: nutritionistFullName ?? this.nutritionistFullName,
        planName: planName ?? this.planName,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
        userFullName: userFullName ?? this.userFullName,
        userId: userId ?? this.userId,
        validationStatus: validationStatus ?? this.validationStatus);
  }

  MealPlan copyWithModelFieldValues(
      {ModelFieldValue<String?>? assignedNutritionistId,
      ModelFieldValue<String?>? chatId,
      ModelFieldValue<DailyPlanData?>? dailyPlan,
      ModelFieldValue<String?>? errorDetails,
      ModelFieldValue<amplify_core.TemporalDateTime?>? generatedAt,
      ModelFieldValue<String>? mealPlanId,
      ModelFieldValue<String?>? nutritionistFullName,
      ModelFieldValue<String?>? planName,
      ModelFieldValue<PlanStatus?>? status,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
      ModelFieldValue<String?>? userFullName,
      ModelFieldValue<String>? userId,
      ModelFieldValue<MealPlanValidationStatus?>? validationStatus}) {
    return MealPlan._internal(
        id: id,
        assignedNutritionistId: assignedNutritionistId == null
            ? this.assignedNutritionistId
            : assignedNutritionistId.value,
        chatId: chatId == null ? this.chatId : chatId.value,
        dailyPlan: dailyPlan == null ? this.dailyPlan : dailyPlan.value,
        errorDetails:
            errorDetails == null ? this.errorDetails : errorDetails.value,
        generatedAt: generatedAt == null ? this.generatedAt : generatedAt.value,
        mealPlanId: mealPlanId == null ? this.mealPlanId : mealPlanId.value,
        nutritionistFullName: nutritionistFullName == null
            ? this.nutritionistFullName
            : nutritionistFullName.value,
        planName: planName == null ? this.planName : planName.value,
        status: status == null ? this.status : status.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
        userFullName:
            userFullName == null ? this.userFullName : userFullName.value,
        userId: userId == null ? this.userId : userId.value,
        validationStatus: validationStatus == null
            ? this.validationStatus
            : validationStatus.value);
  }

  MealPlan.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _assignedNutritionistId = json['assignedNutritionistId'],
        _chatId = json['chatId'],
        _dailyPlan = json['dailyPlan'] != null
            ? json['dailyPlan']['serializedData'] != null
                ? DailyPlanData.fromJson(new Map<String, dynamic>.from(
                    json['dailyPlan']['serializedData']))
                : DailyPlanData.fromJson(
                    new Map<String, dynamic>.from(json['dailyPlan']))
            : null,
        _errorDetails = json['errorDetails'],
        _generatedAt = json['generatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['generatedAt'])
            : null,
        _mealPlanId = json['mealPlanId'],
        _nutritionistFullName = json['nutritionistFullName'],
        _planName = json['planName'],
        _status = amplify_core.enumFromString<PlanStatus>(
            json['status'], PlanStatus.values),
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null,
        _userFullName = json['userFullName'],
        _userId = json['userId'],
        _validationStatus =
            amplify_core.enumFromString<MealPlanValidationStatus>(
                json['validationStatus'], MealPlanValidationStatus.values),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'assignedNutritionistId': _assignedNutritionistId,
        'chatId': _chatId,
        'dailyPlan': _dailyPlan?.toJson(),
        'errorDetails': _errorDetails,
        'generatedAt': _generatedAt?.format(),
        'mealPlanId': _mealPlanId,
        'nutritionistFullName': _nutritionistFullName,
        'planName': _planName,
        'status': amplify_core.enumToString(_status),
        'updatedAt': _updatedAt?.format(),
        'userFullName': _userFullName,
        'userId': _userId,
        'validationStatus': amplify_core.enumToString(_validationStatus),
        'createdAt': _createdAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'assignedNutritionistId': _assignedNutritionistId,
        'chatId': _chatId,
        'dailyPlan': _dailyPlan,
        'errorDetails': _errorDetails,
        'generatedAt': _generatedAt,
        'mealPlanId': _mealPlanId,
        'nutritionistFullName': _nutritionistFullName,
        'planName': _planName,
        'status': _status,
        'updatedAt': _updatedAt,
        'userFullName': _userFullName,
        'userId': _userId,
        'validationStatus': _validationStatus,
        'createdAt': _createdAt
      };

  static final amplify_core.QueryModelIdentifier<MealPlanModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<MealPlanModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ASSIGNEDNUTRITIONISTID =
      amplify_core.QueryField(fieldName: "assignedNutritionistId");
  static final CHATID = amplify_core.QueryField(fieldName: "chatId");
  static final DAILYPLAN = amplify_core.QueryField(fieldName: "dailyPlan");
  static final ERRORDETAILS =
      amplify_core.QueryField(fieldName: "errorDetails");
  static final GENERATEDAT = amplify_core.QueryField(fieldName: "generatedAt");
  static final MEALPLANID = amplify_core.QueryField(fieldName: "mealPlanId");
  static final NUTRITIONISTFULLNAME =
      amplify_core.QueryField(fieldName: "nutritionistFullName");
  static final PLANNAME = amplify_core.QueryField(fieldName: "planName");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final USERFULLNAME =
      amplify_core.QueryField(fieldName: "userFullName");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final VALIDATIONSTATUS =
      amplify_core.QueryField(fieldName: "validationStatus");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MealPlan";
    modelSchemaDefinition.pluralName = "MealPlans";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.ASSIGNEDNUTRITIONISTID,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.CHATID,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'dailyPlan',
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embedded,
            ofCustomTypeName: 'DailyPlanData')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.ERRORDETAILS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.GENERATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.MEALPLANID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.NUTRITIONISTFULLNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.PLANNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.STATUS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.USERFULLNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: MealPlan.VALIDATIONSTATUS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'createdAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _MealPlanModelType extends amplify_core.ModelType<MealPlan> {
  const _MealPlanModelType();

  @override
  MealPlan fromJson(Map<String, dynamic> jsonData) {
    return MealPlan.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'MealPlan';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MealPlan] in your schema.
 */
class MealPlanModelIdentifier
    implements amplify_core.ModelIdentifier<MealPlan> {
  final String id;

  /** Create an instance of MealPlanModelIdentifier using [id] the primary key. */
  const MealPlanModelIdentifier({required this.id});

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
  String toString() => 'MealPlanModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MealPlanModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
