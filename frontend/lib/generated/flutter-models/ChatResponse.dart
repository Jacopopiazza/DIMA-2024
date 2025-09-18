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

/** This is an auto generated class representing the ChatResponse type in your schema. */
class ChatResponse {
  final ChatMessage? _message;
  final String? _recipientId;

  ChatMessage? get message {
    return _message;
  }

  String get recipientId {
    try {
      return _recipientId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const ChatResponse._internal({message, required recipientId})
      : _message = message,
        _recipientId = recipientId;

  factory ChatResponse({ChatMessage? message, required String recipientId}) {
    return ChatResponse._internal(message: message, recipientId: recipientId);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatResponse &&
        _message == other._message &&
        _recipientId == other._recipientId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ChatResponse {");
    buffer.write(
        "message=" + (_message != null ? _message!.toString() : "null") + ", ");
    buffer.write("recipientId=" + "$_recipientId");
    buffer.write("}");

    return buffer.toString();
  }

  ChatResponse copyWith({ChatMessage? message, String? recipientId}) {
    return ChatResponse._internal(
        message: message ?? this.message,
        recipientId: recipientId ?? this.recipientId);
  }

  ChatResponse copyWithModelFieldValues(
      {ModelFieldValue<ChatMessage?>? message,
      ModelFieldValue<String>? recipientId}) {
    return ChatResponse._internal(
        message: message == null ? this.message : message.value,
        recipientId:
            recipientId == null ? this.recipientId : recipientId.value);
  }

  ChatResponse.fromJson(Map<String, dynamic> json)
      : _message = json['message'] != null
            ? json['message']['serializedData'] != null
                ? ChatMessage.fromJson(new Map<String, dynamic>.from(
                    json['message']['serializedData']))
                : ChatMessage.fromJson(
                    new Map<String, dynamic>.from(json['message']))
            : null,
        _recipientId = json['recipientId'];

  Map<String, dynamic> toJson() =>
      {'message': _message?.toJson(), 'recipientId': _recipientId};

  Map<String, Object?> toMap() =>
      {'message': _message, 'recipientId': _recipientId};

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatResponse";
    modelSchemaDefinition.pluralName = "ChatResponses";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'message',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'recipientId',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));
  });
}
