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

/** This is an auto generated class representing the ChatMetadata type in your schema. */
class ChatMetadata extends amplify_core.Model {
  static const classType = const _ChatMetadataModelType();
  final String id;
  final String? _chatId;
  final amplify_core.TemporalDateTime? _createdAt;
  final String? _lastMessageSnippet;
  final amplify_core.TemporalDateTime? _lastMessageTimestamp;
  final String? _mealPlanId;
  final String? _nutritionistGivenName;
  final String? _nutritionistId;
  final int? _nutritionistUnreadCount;
  final String? _planName;
  final String? _userGivenName;
  final String? _userId;
  final int? _userUnreadCount;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  ChatMetadataModelIdentifier get modelIdentifier {
    return ChatMetadataModelIdentifier(id: id);
  }

  String get chatId {
    try {
      return _chatId!;
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

  String? get lastMessageSnippet {
    return _lastMessageSnippet;
  }

  amplify_core.TemporalDateTime? get lastMessageTimestamp {
    return _lastMessageTimestamp;
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

  String? get nutritionistGivenName {
    return _nutritionistGivenName;
  }

  String get nutritionistId {
    try {
      return _nutritionistId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int? get nutritionistUnreadCount {
    return _nutritionistUnreadCount;
  }

  String? get planName {
    return _planName;
  }

  String? get userGivenName {
    return _userGivenName;
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

  int? get userUnreadCount {
    return _userUnreadCount;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const ChatMetadata._internal(
      {required this.id,
      required chatId,
      createdAt,
      lastMessageSnippet,
      lastMessageTimestamp,
      required mealPlanId,
      nutritionistGivenName,
      required nutritionistId,
      nutritionistUnreadCount,
      planName,
      userGivenName,
      required userId,
      userUnreadCount,
      updatedAt})
      : _chatId = chatId,
        _createdAt = createdAt,
        _lastMessageSnippet = lastMessageSnippet,
        _lastMessageTimestamp = lastMessageTimestamp,
        _mealPlanId = mealPlanId,
        _nutritionistGivenName = nutritionistGivenName,
        _nutritionistId = nutritionistId,
        _nutritionistUnreadCount = nutritionistUnreadCount,
        _planName = planName,
        _userGivenName = userGivenName,
        _userId = userId,
        _userUnreadCount = userUnreadCount,
        _updatedAt = updatedAt;

  factory ChatMetadata(
      {String? id,
      required String chatId,
      amplify_core.TemporalDateTime? createdAt,
      String? lastMessageSnippet,
      amplify_core.TemporalDateTime? lastMessageTimestamp,
      required String mealPlanId,
      String? nutritionistGivenName,
      required String nutritionistId,
      int? nutritionistUnreadCount,
      String? planName,
      String? userGivenName,
      required String userId,
      int? userUnreadCount}) {
    return ChatMetadata._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        chatId: chatId,
        createdAt: createdAt,
        lastMessageSnippet: lastMessageSnippet,
        lastMessageTimestamp: lastMessageTimestamp,
        mealPlanId: mealPlanId,
        nutritionistGivenName: nutritionistGivenName,
        nutritionistId: nutritionistId,
        nutritionistUnreadCount: nutritionistUnreadCount,
        planName: planName,
        userGivenName: userGivenName,
        userId: userId,
        userUnreadCount: userUnreadCount);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMetadata &&
        id == other.id &&
        _chatId == other._chatId &&
        _createdAt == other._createdAt &&
        _lastMessageSnippet == other._lastMessageSnippet &&
        _lastMessageTimestamp == other._lastMessageTimestamp &&
        _mealPlanId == other._mealPlanId &&
        _nutritionistGivenName == other._nutritionistGivenName &&
        _nutritionistId == other._nutritionistId &&
        _nutritionistUnreadCount == other._nutritionistUnreadCount &&
        _planName == other._planName &&
        _userGivenName == other._userGivenName &&
        _userId == other._userId &&
        _userUnreadCount == other._userUnreadCount;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ChatMetadata {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("chatId=" + "$_chatId" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write("lastMessageSnippet=" + "$_lastMessageSnippet" + ", ");
    buffer.write("lastMessageTimestamp=" +
        (_lastMessageTimestamp != null
            ? _lastMessageTimestamp!.format()
            : "null") +
        ", ");
    buffer.write("mealPlanId=" + "$_mealPlanId" + ", ");
    buffer.write("nutritionistGivenName=" + "$_nutritionistGivenName" + ", ");
    buffer.write("nutritionistId=" + "$_nutritionistId" + ", ");
    buffer.write("nutritionistUnreadCount=" +
        (_nutritionistUnreadCount != null
            ? _nutritionistUnreadCount!.toString()
            : "null") +
        ", ");
    buffer.write("planName=" + "$_planName" + ", ");
    buffer.write("userGivenName=" + "$_userGivenName" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("userUnreadCount=" +
        (_userUnreadCount != null ? _userUnreadCount!.toString() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  ChatMetadata copyWith(
      {String? chatId,
      amplify_core.TemporalDateTime? createdAt,
      String? lastMessageSnippet,
      amplify_core.TemporalDateTime? lastMessageTimestamp,
      String? mealPlanId,
      String? nutritionistGivenName,
      String? nutritionistId,
      int? nutritionistUnreadCount,
      String? planName,
      String? userGivenName,
      String? userId,
      int? userUnreadCount}) {
    return ChatMetadata._internal(
        id: id,
        chatId: chatId ?? this.chatId,
        createdAt: createdAt ?? this.createdAt,
        lastMessageSnippet: lastMessageSnippet ?? this.lastMessageSnippet,
        lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
        mealPlanId: mealPlanId ?? this.mealPlanId,
        nutritionistGivenName:
            nutritionistGivenName ?? this.nutritionistGivenName,
        nutritionistId: nutritionistId ?? this.nutritionistId,
        nutritionistUnreadCount:
            nutritionistUnreadCount ?? this.nutritionistUnreadCount,
        planName: planName ?? this.planName,
        userGivenName: userGivenName ?? this.userGivenName,
        userId: userId ?? this.userId,
        userUnreadCount: userUnreadCount ?? this.userUnreadCount);
  }

  ChatMetadata copyWithModelFieldValues(
      {ModelFieldValue<String>? chatId,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<String?>? lastMessageSnippet,
      ModelFieldValue<amplify_core.TemporalDateTime?>? lastMessageTimestamp,
      ModelFieldValue<String>? mealPlanId,
      ModelFieldValue<String?>? nutritionistGivenName,
      ModelFieldValue<String>? nutritionistId,
      ModelFieldValue<int?>? nutritionistUnreadCount,
      ModelFieldValue<String?>? planName,
      ModelFieldValue<String?>? userGivenName,
      ModelFieldValue<String>? userId,
      ModelFieldValue<int?>? userUnreadCount}) {
    return ChatMetadata._internal(
        id: id,
        chatId: chatId == null ? this.chatId : chatId.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        lastMessageSnippet: lastMessageSnippet == null
            ? this.lastMessageSnippet
            : lastMessageSnippet.value,
        lastMessageTimestamp: lastMessageTimestamp == null
            ? this.lastMessageTimestamp
            : lastMessageTimestamp.value,
        mealPlanId: mealPlanId == null ? this.mealPlanId : mealPlanId.value,
        nutritionistGivenName: nutritionistGivenName == null
            ? this.nutritionistGivenName
            : nutritionistGivenName.value,
        nutritionistId:
            nutritionistId == null ? this.nutritionistId : nutritionistId.value,
        nutritionistUnreadCount: nutritionistUnreadCount == null
            ? this.nutritionistUnreadCount
            : nutritionistUnreadCount.value,
        planName: planName == null ? this.planName : planName.value,
        userGivenName:
            userGivenName == null ? this.userGivenName : userGivenName.value,
        userId: userId == null ? this.userId : userId.value,
        userUnreadCount: userUnreadCount == null
            ? this.userUnreadCount
            : userUnreadCount.value);
  }

  ChatMetadata.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _chatId = json['chatId'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _lastMessageSnippet = json['lastMessageSnippet'],
        _lastMessageTimestamp = json['lastMessageTimestamp'] != null
            ? amplify_core.TemporalDateTime.fromString(
                json['lastMessageTimestamp'])
            : null,
        _mealPlanId = json['mealPlanId'],
        _nutritionistGivenName = json['nutritionistGivenName'],
        _nutritionistId = json['nutritionistId'],
        _nutritionistUnreadCount =
            (json['nutritionistUnreadCount'] as num?)?.toInt(),
        _planName = json['planName'],
        _userGivenName = json['userGivenName'],
        _userId = json['userId'],
        _userUnreadCount = (json['userUnreadCount'] as num?)?.toInt(),
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': _chatId,
        'createdAt': _createdAt?.format(),
        'lastMessageSnippet': _lastMessageSnippet,
        'lastMessageTimestamp': _lastMessageTimestamp?.format(),
        'mealPlanId': _mealPlanId,
        'nutritionistGivenName': _nutritionistGivenName,
        'nutritionistId': _nutritionistId,
        'nutritionistUnreadCount': _nutritionistUnreadCount,
        'planName': _planName,
        'userGivenName': _userGivenName,
        'userId': _userId,
        'userUnreadCount': _userUnreadCount,
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'chatId': _chatId,
        'createdAt': _createdAt,
        'lastMessageSnippet': _lastMessageSnippet,
        'lastMessageTimestamp': _lastMessageTimestamp,
        'mealPlanId': _mealPlanId,
        'nutritionistGivenName': _nutritionistGivenName,
        'nutritionistId': _nutritionistId,
        'nutritionistUnreadCount': _nutritionistUnreadCount,
        'planName': _planName,
        'userGivenName': _userGivenName,
        'userId': _userId,
        'userUnreadCount': _userUnreadCount,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<ChatMetadataModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<ChatMetadataModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CHATID = amplify_core.QueryField(fieldName: "chatId");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final LASTMESSAGESNIPPET =
      amplify_core.QueryField(fieldName: "lastMessageSnippet");
  static final LASTMESSAGETIMESTAMP =
      amplify_core.QueryField(fieldName: "lastMessageTimestamp");
  static final MEALPLANID = amplify_core.QueryField(fieldName: "mealPlanId");
  static final NUTRITIONISTGIVENNAME =
      amplify_core.QueryField(fieldName: "nutritionistGivenName");
  static final NUTRITIONISTID =
      amplify_core.QueryField(fieldName: "nutritionistId");
  static final NUTRITIONISTUNREADCOUNT =
      amplify_core.QueryField(fieldName: "nutritionistUnreadCount");
  static final PLANNAME = amplify_core.QueryField(fieldName: "planName");
  static final USERGIVENNAME =
      amplify_core.QueryField(fieldName: "userGivenName");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final USERUNREADCOUNT =
      amplify_core.QueryField(fieldName: "userUnreadCount");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatMetadata";
    modelSchemaDefinition.pluralName = "ChatMetadata";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.CHATID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.LASTMESSAGESNIPPET,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.LASTMESSAGETIMESTAMP,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.MEALPLANID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.NUTRITIONISTGIVENNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.NUTRITIONISTID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.NUTRITIONISTUNREADCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.PLANNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.USERGIVENNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMetadata.USERUNREADCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'updatedAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _ChatMetadataModelType extends amplify_core.ModelType<ChatMetadata> {
  const _ChatMetadataModelType();

  @override
  ChatMetadata fromJson(Map<String, dynamic> jsonData) {
    return ChatMetadata.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'ChatMetadata';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatMetadata] in your schema.
 */
class ChatMetadataModelIdentifier
    implements amplify_core.ModelIdentifier<ChatMetadata> {
  final String id;

  /** Create an instance of ChatMetadataModelIdentifier using [id] the primary key. */
  const ChatMetadataModelIdentifier({required this.id});

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
  String toString() => 'ChatMetadataModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ChatMetadataModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
