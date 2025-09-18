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

/** This is an auto generated class representing the Meal type in your schema. */
class Meal {
  final List<Ingredient>? _ingredients;
  final MealNameEnum? _name;
  final String? _recipe;
  final String? _recipeName;
  final Macros? _totalMacros;

  List<Ingredient> get ingredients {
    try {
      return _ingredients!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  MealNameEnum get name {
    try {
      return _name!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get recipe {
    return _recipe;
  }

  String? get recipeName {
    return _recipeName;
  }

  Macros get totalMacros {
    try {
      return _totalMacros!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const Meal._internal(
      {required ingredients,
      required name,
      recipe,
      recipeName,
      required totalMacros})
      : _ingredients = ingredients,
        _name = name,
        _recipe = recipe,
        _recipeName = recipeName,
        _totalMacros = totalMacros;

  factory Meal(
      {required List<Ingredient> ingredients,
      required MealNameEnum name,
      String? recipe,
      String? recipeName,
      required Macros totalMacros}) {
    return Meal._internal(
        ingredients: ingredients != null
            ? List<Ingredient>.unmodifiable(ingredients)
            : ingredients,
        name: name,
        recipe: recipe,
        recipeName: recipeName,
        totalMacros: totalMacros);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Meal &&
        DeepCollectionEquality().equals(_ingredients, other._ingredients) &&
        _name == other._name &&
        _recipe == other._recipe &&
        _recipeName == other._recipeName &&
        _totalMacros == other._totalMacros;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Meal {");
    buffer.write("ingredients=" +
        (_ingredients != null ? _ingredients!.toString() : "null") +
        ", ");
    buffer.write("name=" +
        (_name != null ? amplify_core.enumToString(_name)! : "null") +
        ", ");
    buffer.write("recipe=" + "$_recipe" + ", ");
    buffer.write("recipeName=" + "$_recipeName" + ", ");
    buffer.write("totalMacros=" +
        (_totalMacros != null ? _totalMacros!.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Meal copyWith(
      {List<Ingredient>? ingredients,
      MealNameEnum? name,
      String? recipe,
      String? recipeName,
      Macros? totalMacros}) {
    return Meal._internal(
        ingredients: ingredients ?? this.ingredients,
        name: name ?? this.name,
        recipe: recipe ?? this.recipe,
        recipeName: recipeName ?? this.recipeName,
        totalMacros: totalMacros ?? this.totalMacros);
  }

  Meal copyWithModelFieldValues(
      {ModelFieldValue<List<Ingredient>>? ingredients,
      ModelFieldValue<MealNameEnum>? name,
      ModelFieldValue<String?>? recipe,
      ModelFieldValue<String?>? recipeName,
      ModelFieldValue<Macros>? totalMacros}) {
    return Meal._internal(
        ingredients: ingredients == null ? this.ingredients : ingredients.value,
        name: name == null ? this.name : name.value,
        recipe: recipe == null ? this.recipe : recipe.value,
        recipeName: recipeName == null ? this.recipeName : recipeName.value,
        totalMacros:
            totalMacros == null ? this.totalMacros : totalMacros.value);
  }

  Meal.fromJson(Map<String, dynamic> json)
      : _ingredients = json['ingredients'] is List
            ? (json['ingredients'] as List)
                .where((e) => e != null)
                .map((e) => Ingredient.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _name = amplify_core.enumFromString<MealNameEnum>(
            json['name'], MealNameEnum.values),
        _recipe = json['recipe'],
        _recipeName = json['recipeName'],
        _totalMacros = json['totalMacros'] != null
            ? json['totalMacros']['serializedData'] != null
                ? Macros.fromJson(new Map<String, dynamic>.from(
                    json['totalMacros']['serializedData']))
                : Macros.fromJson(
                    new Map<String, dynamic>.from(json['totalMacros']))
            : null;

  Map<String, dynamic> toJson() => {
        'ingredients':
            _ingredients?.map((Ingredient? e) => e?.toJson()).toList(),
        'name': amplify_core.enumToString(_name),
        'recipe': _recipe,
        'recipeName': _recipeName,
        'totalMacros': _totalMacros?.toJson()
      };

  Map<String, Object?> toMap() => {
        'ingredients': _ingredients,
        'name': _name,
        'recipe': _recipe,
        'recipeName': _recipeName,
        'totalMacros': _totalMacros
      };

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Meal";
    modelSchemaDefinition.pluralName = "Meals";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'ingredients',
        isRequired: true,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Ingredient')));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'name',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'recipe',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'recipeName',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'totalMacros',
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embedded,
            ofCustomTypeName: 'Macros')));
  });
}
