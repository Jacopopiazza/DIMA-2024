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


/** This is an auto generated class representing the Ingredient type in your schema. */
class Ingredient {
  final double? _amount;
  final Macros? _macros;
  final String? _name;
  final String? _unit;

  double get amount {
    try {
      return _amount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Macros get macros {
    try {
      return _macros!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get unit {
    return _unit;
  }
  
  const Ingredient._internal({required amount, required macros, required name, unit}): _amount = amount, _macros = macros, _name = name, _unit = unit;
  
  factory Ingredient({required double amount, required Macros macros, required String name, String? unit}) {
    return Ingredient._internal(
      amount: amount,
      macros: macros,
      name: name,
      unit: unit);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ingredient &&
      _amount == other._amount &&
      _macros == other._macros &&
      _name == other._name &&
      _unit == other._unit;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Ingredient {");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null") + ", ");
    buffer.write("macros=" + (_macros != null ? _macros!.toString() : "null") + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("unit=" + "$_unit");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Ingredient copyWith({double? amount, Macros? macros, String? name, String? unit}) {
    return Ingredient._internal(
      amount: amount ?? this.amount,
      macros: macros ?? this.macros,
      name: name ?? this.name,
      unit: unit ?? this.unit);
  }
  
  Ingredient copyWithModelFieldValues({
    ModelFieldValue<double>? amount,
    ModelFieldValue<Macros>? macros,
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? unit
  }) {
    return Ingredient._internal(
      amount: amount == null ? this.amount : amount.value,
      macros: macros == null ? this.macros : macros.value,
      name: name == null ? this.name : name.value,
      unit: unit == null ? this.unit : unit.value
    );
  }
  
  Ingredient.fromJson(Map<String, dynamic> json)  
    : _amount = (json['amount'] as num?)?.toDouble(),
      _macros = json['macros'] != null
          ? json['macros']['serializedData'] != null
              ? Macros.fromJson(new Map<String, dynamic>.from(json['macros']['serializedData']))
              : Macros.fromJson(new Map<String, dynamic>.from(json['macros']))
        : null,
      _name = json['name'],
      _unit = json['unit'];
  
  Map<String, dynamic> toJson() => {
    'amount': _amount, 'macros': _macros?.toJson(), 'name': _name, 'unit': _unit
  };
  
  Map<String, Object?> toMap() => {
    'amount': _amount,
    'macros': _macros,
    'name': _name,
    'unit': _unit
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Ingredient";
    modelSchemaDefinition.pluralName = "Ingredients";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'amount',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'macros',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'Macros')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'name',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'unit',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}