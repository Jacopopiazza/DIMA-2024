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

/** This is an auto generated class representing the ChatMessage type in your schema. */
class ChatMessage extends amplify_core.Model {
  static const classType = const _ChatMessageModelType();
  final String id;
  final String? _chatId;
  final String? _messageContent;
  final String? _messageId;
  final String? _senderId;
  final SenderType? _senderType;
  final amplify_core.TemporalDateTime? _sentAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  ChatMessageModelIdentifier get modelIdentifier {
    return ChatMessageModelIdentifier(id: id);
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

  String get messageContent {
    try {
      return _messageContent!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get messageId {
    try {
      return _messageId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get senderId {
    try {
      return _senderId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  SenderType get senderType {
    try {
      return _senderType!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  amplify_core.TemporalDateTime get sentAt {
    try {
      return _sentAt!;
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

  const ChatMessage._internal(
      {required this.id,
      required chatId,
      required messageContent,
      required messageId,
      required senderId,
      required senderType,
      required sentAt,
      createdAt,
      updatedAt})
      : _chatId = chatId,
        _messageContent = messageContent,
        _messageId = messageId,
        _senderId = senderId,
        _senderType = senderType,
        _sentAt = sentAt,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory ChatMessage(
      {String? id,
      required String chatId,
      required String messageContent,
      required String messageId,
      required String senderId,
      required SenderType senderType,
      required amplify_core.TemporalDateTime sentAt}) {
    return ChatMessage._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        chatId: chatId,
        messageContent: messageContent,
        messageId: messageId,
        senderId: senderId,
        senderType: senderType,
        sentAt: sentAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
        id == other.id &&
        _chatId == other._chatId &&
        _messageContent == other._messageContent &&
        _messageId == other._messageId &&
        _senderId == other._senderId &&
        _senderType == other._senderType &&
        _sentAt == other._sentAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ChatMessage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("chatId=" + "$_chatId" + ", ");
    buffer.write("messageContent=" + "$_messageContent" + ", ");
    buffer.write("messageId=" + "$_messageId" + ", ");
    buffer.write("senderId=" + "$_senderId" + ", ");
    buffer.write("senderType=" +
        (_senderType != null
            ? amplify_core.enumToString(_senderType)!
            : "null") +
        ", ");
    buffer.write(
        "sentAt=" + (_sentAt != null ? _sentAt!.format() : "null") + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  ChatMessage copyWith(
      {String? chatId,
      String? messageContent,
      String? messageId,
      String? senderId,
      SenderType? senderType,
      amplify_core.TemporalDateTime? sentAt}) {
    return ChatMessage._internal(
        id: id,
        chatId: chatId ?? this.chatId,
        messageContent: messageContent ?? this.messageContent,
        messageId: messageId ?? this.messageId,
        senderId: senderId ?? this.senderId,
        senderType: senderType ?? this.senderType,
        sentAt: sentAt ?? this.sentAt);
  }

  ChatMessage copyWithModelFieldValues(
      {ModelFieldValue<String>? chatId,
      ModelFieldValue<String>? messageContent,
      ModelFieldValue<String>? messageId,
      ModelFieldValue<String>? senderId,
      ModelFieldValue<SenderType>? senderType,
      ModelFieldValue<amplify_core.TemporalDateTime>? sentAt}) {
    return ChatMessage._internal(
        id: id,
        chatId: chatId == null ? this.chatId : chatId.value,
        messageContent:
            messageContent == null ? this.messageContent : messageContent.value,
        messageId: messageId == null ? this.messageId : messageId.value,
        senderId: senderId == null ? this.senderId : senderId.value,
        senderType: senderType == null ? this.senderType : senderType.value,
        sentAt: sentAt == null ? this.sentAt : sentAt.value);
  }

  ChatMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _chatId = json['chatId'],
        _messageContent = json['messageContent'],
        _messageId = json['messageId'],
        _senderId = json['senderId'],
        _senderType = amplify_core.enumFromString<SenderType>(
            json['senderType'], SenderType.values),
        _sentAt = json['sentAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['sentAt'])
            : null,
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': _chatId,
        'messageContent': _messageContent,
        'messageId': _messageId,
        'senderId': _senderId,
        'senderType': amplify_core.enumToString(_senderType),
        'sentAt': _sentAt?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'chatId': _chatId,
        'messageContent': _messageContent,
        'messageId': _messageId,
        'senderId': _senderId,
        'senderType': _senderType,
        'sentAt': _sentAt,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<ChatMessageModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<ChatMessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CHATID = amplify_core.QueryField(fieldName: "chatId");
  static final MESSAGECONTENT =
      amplify_core.QueryField(fieldName: "messageContent");
  static final MESSAGEID = amplify_core.QueryField(fieldName: "messageId");
  static final SENDERID = amplify_core.QueryField(fieldName: "senderId");
  static final SENDERTYPE = amplify_core.QueryField(fieldName: "senderType");
  static final SENTAT = amplify_core.QueryField(fieldName: "sentAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatMessage";
    modelSchemaDefinition.pluralName = "ChatMessages";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMessage.CHATID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMessage.MESSAGECONTENT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMessage.MESSAGEID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMessage.SENDERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMessage.SENDERTYPE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: ChatMessage.SENTAT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

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

class _ChatMessageModelType extends amplify_core.ModelType<ChatMessage> {
  const _ChatMessageModelType();

  @override
  ChatMessage fromJson(Map<String, dynamic> jsonData) {
    return ChatMessage.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'ChatMessage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatMessage] in your schema.
 */
class ChatMessageModelIdentifier
    implements amplify_core.ModelIdentifier<ChatMessage> {
  final String id;

  /** Create an instance of ChatMessageModelIdentifier using [id] the primary key. */
  const ChatMessageModelIdentifier({required this.id});

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
  String toString() => 'ChatMessageModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ChatMessageModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
