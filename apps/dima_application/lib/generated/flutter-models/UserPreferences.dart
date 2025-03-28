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


/** This is an auto generated class representing the UserPreferences type in your schema. */
class UserPreferences extends amplify_core.Model {
  final List<String>? _allergens;
  final String? _frequencyExercise;
  final int? _mealsPerDay;
  final double? _weight;

  List<String>? get allergens {
    return _allergens;
  }
  
  String? get frequencyExercise {
    return _frequencyExercise;
  }
  
  int? get mealsPerDay {
    return _mealsPerDay;
  }
  
  double? get weight {
    return _weight;
  }
  
  const UserPreferences._internal({allergens, frequencyExercise, mealsPerDay, weight}): _allergens = allergens, _frequencyExercise = frequencyExercise, _mealsPerDay = mealsPerDay, _weight = weight;
  
  factory UserPreferences({List<String>? allergens, String? frequencyExercise, int? mealsPerDay, double? weight}) {
    return UserPreferences._internal(
      allergens: allergens != null ? List<String>.unmodifiable(allergens) : allergens,
      frequencyExercise: frequencyExercise,
      mealsPerDay: mealsPerDay,
      weight: weight);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserPreferences &&
      DeepCollectionEquality().equals(_allergens, other._allergens) &&
      _frequencyExercise == other._frequencyExercise &&
      _mealsPerDay == other._mealsPerDay &&
      _weight == other._weight;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserPreferences {");
    buffer.write("allergens=" + (_allergens != null ? _allergens!.toString() : "null") + ", ");
    buffer.write("frequencyExercise=" + "$_frequencyExercise" + ", ");
    buffer.write("mealsPerDay=" + (_mealsPerDay != null ? _mealsPerDay!.toString() : "null") + ", ");
    buffer.write("weight=" + (_weight != null ? _weight!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserPreferences copyWith({List<String>? allergens, String? frequencyExercise, int? mealsPerDay, double? weight}) {
    return UserPreferences._internal(
      allergens: allergens ?? this.allergens,
      frequencyExercise: frequencyExercise ?? this.frequencyExercise,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      weight: weight ?? this.weight);
  }
  
  UserPreferences copyWithModelFieldValues({
    ModelFieldValue<List<String>?>? allergens,
    ModelFieldValue<String?>? frequencyExercise,
    ModelFieldValue<int?>? mealsPerDay,
    ModelFieldValue<double?>? weight
  }) {
    return UserPreferences._internal(
      allergens: allergens == null ? this.allergens : allergens.value,
      frequencyExercise: frequencyExercise == null ? this.frequencyExercise : frequencyExercise.value,
      mealsPerDay: mealsPerDay == null ? this.mealsPerDay : mealsPerDay.value,
      weight: weight == null ? this.weight : weight.value
    );
  }
  
  UserPreferences.fromJson(Map<String, dynamic> json)  
    : _allergens = json['allergens']?.cast<String>(),
      _frequencyExercise = json['frequencyExercise'],
      _mealsPerDay = (json['mealsPerDay'] as num?)?.toInt(),
      _weight = (json['weight'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'allergens': _allergens, 'frequencyExercise': _frequencyExercise, 'mealsPerDay': _mealsPerDay, 'weight': _weight
  };
  
  Map<String, Object?> toMap() => {
    'allergens': _allergens,
    'frequencyExercise': _frequencyExercise,
    'mealsPerDay': _mealsPerDay,
    'weight': _weight
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserPreferences";
    modelSchemaDefinition.pluralName = "UserPreferences";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'allergens',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'frequencyExercise',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'mealsPerDay',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'weight',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
  });
}