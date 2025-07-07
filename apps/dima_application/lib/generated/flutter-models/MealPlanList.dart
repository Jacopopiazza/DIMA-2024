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


/** This is an auto generated class representing the MealPlanList type in your schema. */
class MealPlanList {
  final String? _activeMealPlan;
  final List<MealPlan>? _items;
  final String? _nextToken;

  String? get activeMealPlan {
    return _activeMealPlan;
  }
  
  List<MealPlan> get items {
    try {
      return _items!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get nextToken {
    return _nextToken;
  }
  
  const MealPlanList._internal({activeMealPlan, required items, nextToken}): _activeMealPlan = activeMealPlan, _items = items, _nextToken = nextToken;
  
  factory MealPlanList({String? activeMealPlan, required List<MealPlan> items, String? nextToken}) {
    return MealPlanList._internal(
      activeMealPlan: activeMealPlan,
      items: items != null ? List<MealPlan>.unmodifiable(items) : items,
      nextToken: nextToken);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MealPlanList &&
      _activeMealPlan == other._activeMealPlan &&
      DeepCollectionEquality().equals(_items, other._items) &&
      _nextToken == other._nextToken;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MealPlanList {");
    buffer.write("activeMealPlan=" + "$_activeMealPlan" + ", ");
    buffer.write("items=" + (_items != null ? _items!.toString() : "null") + ", ");
    buffer.write("nextToken=" + "$_nextToken");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MealPlanList copyWith({String? activeMealPlan, List<MealPlan>? items, String? nextToken}) {
    return MealPlanList._internal(
      activeMealPlan: activeMealPlan ?? this.activeMealPlan,
      items: items ?? this.items,
      nextToken: nextToken ?? this.nextToken);
  }
  
  MealPlanList copyWithModelFieldValues({
    ModelFieldValue<String?>? activeMealPlan,
    ModelFieldValue<List<MealPlan>>? items,
    ModelFieldValue<String?>? nextToken
  }) {
    return MealPlanList._internal(
      activeMealPlan: activeMealPlan == null ? this.activeMealPlan : activeMealPlan.value,
      items: items == null ? this.items : items.value,
      nextToken: nextToken == null ? this.nextToken : nextToken.value
    );
  }
  
  MealPlanList.fromJson(Map<String, dynamic> json)  
    : _activeMealPlan = json['activeMealPlan'],
      _items = json['items']  is Map
        ? (json['items']['items'] is List
          ? (json['items']['items'] as List)
              .where((e) => e != null)
              .map((e) => MealPlan.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['items'] is List
          ? (json['items'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => MealPlan.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _nextToken = json['nextToken'];
  
  Map<String, dynamic> toJson() => {
    'activeMealPlan': _activeMealPlan, 'items': _items?.map((MealPlan? e) => e?.toJson()).toList(), 'nextToken': _nextToken
  };
  
  Map<String, Object?> toMap() => {
    'activeMealPlan': _activeMealPlan,
    'items': _items,
    'nextToken': _nextToken
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MealPlanList";
    modelSchemaDefinition.pluralName = "MealPlanLists";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'activeMealPlan',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'items',
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'nextToken',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}