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

/** This is an auto generated class representing the ChatMessagesResponse type in your schema. */
class ChatMessagesResponse {
  final int? _count;
  final bool? _hasMore;
  final List<ChatMessage>? _messages;
  final String? _oldestTimestamp;

  int get count {
    try {
      return _count!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  bool get hasMore {
    try {
      return _hasMore!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<ChatMessage> get messages {
    try {
      return _messages!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get oldestTimestamp {
    return _oldestTimestamp;
  }

  const ChatMessagesResponse._internal(
      {required count, required hasMore, required messages, oldestTimestamp})
      : _count = count,
        _hasMore = hasMore,
        _messages = messages,
        _oldestTimestamp = oldestTimestamp;

  factory ChatMessagesResponse(
      {required int count,
      required bool hasMore,
      required List<ChatMessage> messages,
      String? oldestTimestamp}) {
    return ChatMessagesResponse._internal(
        count: count,
        hasMore: hasMore,
        messages: messages != null
            ? List<ChatMessage>.unmodifiable(messages)
            : messages,
        oldestTimestamp: oldestTimestamp);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessagesResponse &&
        _count == other._count &&
        _hasMore == other._hasMore &&
        DeepCollectionEquality().equals(_messages, other._messages) &&
        _oldestTimestamp == other._oldestTimestamp;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ChatMessagesResponse {");
    buffer.write(
        "count=" + (_count != null ? _count!.toString() : "null") + ", ");
    buffer.write(
        "hasMore=" + (_hasMore != null ? _hasMore!.toString() : "null") + ", ");
    buffer.write("messages=" +
        (_messages != null ? _messages!.toString() : "null") +
        ", ");
    buffer.write("oldestTimestamp=" + "$_oldestTimestamp");
    buffer.write("}");

    return buffer.toString();
  }

  ChatMessagesResponse copyWith(
      {int? count,
      bool? hasMore,
      List<ChatMessage>? messages,
      String? oldestTimestamp}) {
    return ChatMessagesResponse._internal(
        count: count ?? this.count,
        hasMore: hasMore ?? this.hasMore,
        messages: messages ?? this.messages,
        oldestTimestamp: oldestTimestamp ?? this.oldestTimestamp);
  }

  ChatMessagesResponse copyWithModelFieldValues(
      {ModelFieldValue<int>? count,
      ModelFieldValue<bool>? hasMore,
      ModelFieldValue<List<ChatMessage>>? messages,
      ModelFieldValue<String?>? oldestTimestamp}) {
    return ChatMessagesResponse._internal(
        count: count == null ? this.count : count.value,
        hasMore: hasMore == null ? this.hasMore : hasMore.value,
        messages: messages == null ? this.messages : messages.value,
        oldestTimestamp: oldestTimestamp == null
            ? this.oldestTimestamp
            : oldestTimestamp.value);
  }

  ChatMessagesResponse.fromJson(Map<String, dynamic> json)
      : _count = (json['count'] as num?)?.toInt(),
        _hasMore = json['hasMore'],
        _messages = json['messages'] is Map
            ? (json['messages']['items'] is List
                ? (json['messages']['items'] as List)
                    .where((e) => e != null)
                    .map((e) =>
                        ChatMessage.fromJson(new Map<String, dynamic>.from(e)))
                    .toList()
                : null)
            : (json['messages'] is List
                ? (json['messages'] as List)
                    .where((e) => e?['serializedData'] != null)
                    .map((e) => ChatMessage.fromJson(
                        new Map<String, dynamic>.from(e?['serializedData'])))
                    .toList()
                : null),
        _oldestTimestamp = json['oldestTimestamp'];

  Map<String, dynamic> toJson() => {
        'count': _count,
        'hasMore': _hasMore,
        'messages': _messages?.map((ChatMessage? e) => e?.toJson()).toList(),
        'oldestTimestamp': _oldestTimestamp
      };

  Map<String, Object?> toMap() => {
        'count': _count,
        'hasMore': _hasMore,
        'messages': _messages,
        'oldestTimestamp': _oldestTimestamp
      };

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatMessagesResponse";
    modelSchemaDefinition.pluralName = "ChatMessagesResponses";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'count',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'hasMore',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'messages',
            isRequired: true,
            isArray: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.collection,
                ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'oldestTimestamp',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));
  });
}
