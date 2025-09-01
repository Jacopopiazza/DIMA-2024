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


/** This is an auto generated class representing the PlanRequestPreferences type in your schema. */
class PlanRequestPreferences {
  final List<AllergenEnum>? _allergies;
  final int? _dailyMealsPreference;
  final amplify_core.TemporalDate? _dateOfBirth;
  final String? _dietaryRestrictions;
  final ExerciseFrequency? _exerciseFrequency;
  final String? _gender;
  final double? _heightCm;
  final String? _language;
  final String? _openTextPreferences;
  final double? _weightKg;

  List<AllergenEnum>? get allergies {
    return _allergies;
  }
  
  int? get dailyMealsPreference {
    return _dailyMealsPreference;
  }
  
  amplify_core.TemporalDate get dateOfBirth {
    try {
      return _dateOfBirth!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get dietaryRestrictions {
    return _dietaryRestrictions;
  }
  
  ExerciseFrequency get exerciseFrequency {
    try {
      return _exerciseFrequency!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get gender {
    try {
      return _gender!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get heightCm {
    try {
      return _heightCm!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get language {
    try {
      return _language!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get openTextPreferences {
    return _openTextPreferences;
  }
  
  double get weightKg {
    try {
      return _weightKg!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const PlanRequestPreferences._internal({allergies, dailyMealsPreference, required dateOfBirth, dietaryRestrictions, required exerciseFrequency, required gender, required heightCm, required language, openTextPreferences, required weightKg}): _allergies = allergies, _dailyMealsPreference = dailyMealsPreference, _dateOfBirth = dateOfBirth, _dietaryRestrictions = dietaryRestrictions, _exerciseFrequency = exerciseFrequency, _gender = gender, _heightCm = heightCm, _language = language, _openTextPreferences = openTextPreferences, _weightKg = weightKg;
  
  factory PlanRequestPreferences({List<AllergenEnum>? allergies, int? dailyMealsPreference, required amplify_core.TemporalDate dateOfBirth, String? dietaryRestrictions, required ExerciseFrequency exerciseFrequency, required String gender, required double heightCm, required String language, String? openTextPreferences, required double weightKg}) {
    return PlanRequestPreferences._internal(
      allergies: allergies != null ? List<AllergenEnum>.unmodifiable(allergies) : allergies,
      dailyMealsPreference: dailyMealsPreference,
      dateOfBirth: dateOfBirth,
      dietaryRestrictions: dietaryRestrictions,
      exerciseFrequency: exerciseFrequency,
      gender: gender,
      heightCm: heightCm,
      language: language,
      openTextPreferences: openTextPreferences,
      weightKg: weightKg);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlanRequestPreferences &&
      DeepCollectionEquality().equals(_allergies, other._allergies) &&
      _dailyMealsPreference == other._dailyMealsPreference &&
      _dateOfBirth == other._dateOfBirth &&
      _dietaryRestrictions == other._dietaryRestrictions &&
      _exerciseFrequency == other._exerciseFrequency &&
      _gender == other._gender &&
      _heightCm == other._heightCm &&
      _language == other._language &&
      _openTextPreferences == other._openTextPreferences &&
      _weightKg == other._weightKg;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PlanRequestPreferences {");
    buffer.write("allergies=" + (_allergies != null ? _allergies!.map((e) => amplify_core.enumToString(e)).toString() : "null") + ", ");
    buffer.write("dailyMealsPreference=" + (_dailyMealsPreference != null ? _dailyMealsPreference!.toString() : "null") + ", ");
    buffer.write("dateOfBirth=" + (_dateOfBirth != null ? _dateOfBirth!.format() : "null") + ", ");
    buffer.write("dietaryRestrictions=" + "$_dietaryRestrictions" + ", ");
    buffer.write("exerciseFrequency=" + (_exerciseFrequency != null ? amplify_core.enumToString(_exerciseFrequency)! : "null") + ", ");
    buffer.write("gender=" + "$_gender" + ", ");
    buffer.write("heightCm=" + (_heightCm != null ? _heightCm!.toString() : "null") + ", ");
    buffer.write("language=" + "$_language" + ", ");
    buffer.write("openTextPreferences=" + "$_openTextPreferences" + ", ");
    buffer.write("weightKg=" + (_weightKg != null ? _weightKg!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PlanRequestPreferences copyWith({List<AllergenEnum>? allergies, int? dailyMealsPreference, amplify_core.TemporalDate? dateOfBirth, String? dietaryRestrictions, ExerciseFrequency? exerciseFrequency, String? gender, double? heightCm, String? language, String? openTextPreferences, double? weightKg}) {
    return PlanRequestPreferences._internal(
      allergies: allergies ?? this.allergies,
      dailyMealsPreference: dailyMealsPreference ?? this.dailyMealsPreference,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      language: language ?? this.language,
      openTextPreferences: openTextPreferences ?? this.openTextPreferences,
      weightKg: weightKg ?? this.weightKg);
  }
  
  PlanRequestPreferences copyWithModelFieldValues({
    ModelFieldValue<List<AllergenEnum>>? allergies,
    ModelFieldValue<int?>? dailyMealsPreference,
    ModelFieldValue<amplify_core.TemporalDate>? dateOfBirth,
    ModelFieldValue<String?>? dietaryRestrictions,
    ModelFieldValue<ExerciseFrequency>? exerciseFrequency,
    ModelFieldValue<String>? gender,
    ModelFieldValue<double>? heightCm,
    ModelFieldValue<String>? language,
    ModelFieldValue<String?>? openTextPreferences,
    ModelFieldValue<double>? weightKg
  }) {
    return PlanRequestPreferences._internal(
      allergies: allergies == null ? this.allergies : allergies.value,
      dailyMealsPreference: dailyMealsPreference == null ? this.dailyMealsPreference : dailyMealsPreference.value,
      dateOfBirth: dateOfBirth == null ? this.dateOfBirth : dateOfBirth.value,
      dietaryRestrictions: dietaryRestrictions == null ? this.dietaryRestrictions : dietaryRestrictions.value,
      exerciseFrequency: exerciseFrequency == null ? this.exerciseFrequency : exerciseFrequency.value,
      gender: gender == null ? this.gender : gender.value,
      heightCm: heightCm == null ? this.heightCm : heightCm.value,
      language: language == null ? this.language : language.value,
      openTextPreferences: openTextPreferences == null ? this.openTextPreferences : openTextPreferences.value,
      weightKg: weightKg == null ? this.weightKg : weightKg.value
    );
  }
  
  PlanRequestPreferences.fromJson(Map<String, dynamic> json)  
    : _allergies = json['allergies'] is List
        ? (json['allergies'] as List)
          .map((e) => amplify_core.enumFromString<AllergenEnum>(e, AllergenEnum.values)!)
          .toList()
        : null,
      _dailyMealsPreference = (json['dailyMealsPreference'] as num?)?.toInt(),
      _dateOfBirth = json['dateOfBirth'] != null ? amplify_core.TemporalDate.fromString(json['dateOfBirth']) : null,
      _dietaryRestrictions = json['dietaryRestrictions'],
      _exerciseFrequency = amplify_core.enumFromString<ExerciseFrequency>(json['exerciseFrequency'], ExerciseFrequency.values),
      _gender = json['gender'],
      _heightCm = (json['heightCm'] as num?)?.toDouble(),
      _language = json['language'],
      _openTextPreferences = json['openTextPreferences'],
      _weightKg = (json['weightKg'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'allergies': _allergies?.map((e) => amplify_core.enumToString(e)).toList(), 'dailyMealsPreference': _dailyMealsPreference, 'dateOfBirth': _dateOfBirth?.format(), 'dietaryRestrictions': _dietaryRestrictions, 'exerciseFrequency': amplify_core.enumToString(_exerciseFrequency), 'gender': _gender, 'heightCm': _heightCm, 'language': _language, 'openTextPreferences': _openTextPreferences, 'weightKg': _weightKg
  };
  
  Map<String, Object?> toMap() => {
    'allergies': _allergies,
    'dailyMealsPreference': _dailyMealsPreference,
    'dateOfBirth': _dateOfBirth,
    'dietaryRestrictions': _dietaryRestrictions,
    'exerciseFrequency': _exerciseFrequency,
    'gender': _gender,
    'heightCm': _heightCm,
    'language': _language,
    'openTextPreferences': _openTextPreferences,
    'weightKg': _weightKg
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PlanRequestPreferences";
    modelSchemaDefinition.pluralName = "PlanRequestPreferences";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'allergies',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.enumeration.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'dailyMealsPreference',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'dateOfBirth',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'dietaryRestrictions',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'exerciseFrequency',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'gender',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'heightCm',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'language',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'openTextPreferences',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'weightKg',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
  });
}