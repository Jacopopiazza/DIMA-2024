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


/** This is an auto generated class representing the UserDetails type in your schema. */
class UserDetails extends amplify_core.Model {
  static const classType = const _UserDetailsModelType();
  final String? _activeMealPlanId;
  final List<AllergenEnum>? _allergies;
  final amplify_core.TemporalDateTime? _createdAt;
  final int? _dailyMealsPreference;
  final List<String>? _dietaryRestrictions;
  final ExerciseFrequency? _exerciseFrequency;
  final double? _heightCm;
  final String? _openTextPreferences;
  final double? _targetCalories;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _userId;
  final double? _weightKg;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => modelIdentifier.serializeAsString();
  
  UserDetailsModelIdentifier get modelIdentifier {
    try {
      return UserDetailsModelIdentifier(
        userId: _userId!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get activeMealPlanId {
    return _activeMealPlanId;
  }
  
  List<AllergenEnum>? get allergies {
    return _allergies;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  int? get dailyMealsPreference {
    return _dailyMealsPreference;
  }
  
  List<String>? get dietaryRestrictions {
    return _dietaryRestrictions;
  }
  
  ExerciseFrequency? get exerciseFrequency {
    return _exerciseFrequency;
  }
  
  double? get heightCm {
    return _heightCm;
  }
  
  String? get openTextPreferences {
    return _openTextPreferences;
  }
  
  double? get targetCalories {
    return _targetCalories;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String get userId {
    try {
      return _userId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get weightKg {
    return _weightKg;
  }
  
  const UserDetails._internal({activeMealPlanId, allergies, createdAt, dailyMealsPreference, dietaryRestrictions, exerciseFrequency, heightCm, openTextPreferences, targetCalories, updatedAt, required userId, weightKg}): _activeMealPlanId = activeMealPlanId, _allergies = allergies, _createdAt = createdAt, _dailyMealsPreference = dailyMealsPreference, _dietaryRestrictions = dietaryRestrictions, _exerciseFrequency = exerciseFrequency, _heightCm = heightCm, _openTextPreferences = openTextPreferences, _targetCalories = targetCalories, _updatedAt = updatedAt, _userId = userId, _weightKg = weightKg;
  
  factory UserDetails({String? activeMealPlanId, List<AllergenEnum>? allergies, amplify_core.TemporalDateTime? createdAt, int? dailyMealsPreference, List<String>? dietaryRestrictions, ExerciseFrequency? exerciseFrequency, double? heightCm, String? openTextPreferences, double? targetCalories, amplify_core.TemporalDateTime? updatedAt, required String userId, double? weightKg}) {
    return UserDetails._internal(
      activeMealPlanId: activeMealPlanId,
      allergies: allergies != null ? List<AllergenEnum>.unmodifiable(allergies) : allergies,
      createdAt: createdAt,
      dailyMealsPreference: dailyMealsPreference,
      dietaryRestrictions: dietaryRestrictions != null ? List<String>.unmodifiable(dietaryRestrictions) : dietaryRestrictions,
      exerciseFrequency: exerciseFrequency,
      heightCm: heightCm,
      openTextPreferences: openTextPreferences,
      targetCalories: targetCalories,
      updatedAt: updatedAt,
      userId: userId,
      weightKg: weightKg);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDetails &&
      _activeMealPlanId == other._activeMealPlanId &&
      DeepCollectionEquality().equals(_allergies, other._allergies) &&
      _createdAt == other._createdAt &&
      _dailyMealsPreference == other._dailyMealsPreference &&
      DeepCollectionEquality().equals(_dietaryRestrictions, other._dietaryRestrictions) &&
      _exerciseFrequency == other._exerciseFrequency &&
      _heightCm == other._heightCm &&
      _openTextPreferences == other._openTextPreferences &&
      _targetCalories == other._targetCalories &&
      _updatedAt == other._updatedAt &&
      _userId == other._userId &&
      _weightKg == other._weightKg;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserDetails {");
    buffer.write("activeMealPlanId=" + "$_activeMealPlanId" + ", ");
    buffer.write("allergies=" + (_allergies != null ? _allergies!.map((e) => amplify_core.enumToString(e)).toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("dailyMealsPreference=" + (_dailyMealsPreference != null ? _dailyMealsPreference!.toString() : "null") + ", ");
    buffer.write("dietaryRestrictions=" + (_dietaryRestrictions != null ? _dietaryRestrictions!.toString() : "null") + ", ");
    buffer.write("exerciseFrequency=" + (_exerciseFrequency != null ? amplify_core.enumToString(_exerciseFrequency)! : "null") + ", ");
    buffer.write("heightCm=" + (_heightCm != null ? _heightCm!.toString() : "null") + ", ");
    buffer.write("openTextPreferences=" + "$_openTextPreferences" + ", ");
    buffer.write("targetCalories=" + (_targetCalories != null ? _targetCalories!.toString() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("weightKg=" + (_weightKg != null ? _weightKg!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserDetails copyWith({String? activeMealPlanId, List<AllergenEnum>? allergies, amplify_core.TemporalDateTime? createdAt, int? dailyMealsPreference, List<String>? dietaryRestrictions, ExerciseFrequency? exerciseFrequency, double? heightCm, String? openTextPreferences, double? targetCalories, amplify_core.TemporalDateTime? updatedAt, double? weightKg}) {
    return UserDetails._internal(
      activeMealPlanId: activeMealPlanId ?? this.activeMealPlanId,
      allergies: allergies ?? this.allergies,
      createdAt: createdAt ?? this.createdAt,
      dailyMealsPreference: dailyMealsPreference ?? this.dailyMealsPreference,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      heightCm: heightCm ?? this.heightCm,
      openTextPreferences: openTextPreferences ?? this.openTextPreferences,
      targetCalories: targetCalories ?? this.targetCalories,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId,
      weightKg: weightKg ?? this.weightKg);
  }
  
  UserDetails copyWithModelFieldValues({
    ModelFieldValue<String?>? activeMealPlanId,
    ModelFieldValue<List<AllergenEnum>>? allergies,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<int?>? dailyMealsPreference,
    ModelFieldValue<List<String>>? dietaryRestrictions,
    ModelFieldValue<ExerciseFrequency?>? exerciseFrequency,
    ModelFieldValue<double?>? heightCm,
    ModelFieldValue<String?>? openTextPreferences,
    ModelFieldValue<double?>? targetCalories,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
    ModelFieldValue<double?>? weightKg
  }) {
    return UserDetails._internal(
      activeMealPlanId: activeMealPlanId == null ? this.activeMealPlanId : activeMealPlanId.value,
      allergies: allergies == null ? this.allergies : allergies.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      dailyMealsPreference: dailyMealsPreference == null ? this.dailyMealsPreference : dailyMealsPreference.value,
      dietaryRestrictions: dietaryRestrictions == null ? this.dietaryRestrictions : dietaryRestrictions.value,
      exerciseFrequency: exerciseFrequency == null ? this.exerciseFrequency : exerciseFrequency.value,
      heightCm: heightCm == null ? this.heightCm : heightCm.value,
      openTextPreferences: openTextPreferences == null ? this.openTextPreferences : openTextPreferences.value,
      targetCalories: targetCalories == null ? this.targetCalories : targetCalories.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      userId: userId,
      weightKg: weightKg == null ? this.weightKg : weightKg.value
    );
  }
  
  UserDetails.fromJson(Map<String, dynamic> json)  
    : _activeMealPlanId = json['activeMealPlanId'],
      _allergies = json['allergies'] is List
        ? (json['allergies'] as List)
          .map((e) => amplify_core.enumFromString<AllergenEnum>(e, AllergenEnum.values)!)
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _dailyMealsPreference = (json['dailyMealsPreference'] as num?)?.toInt(),
      _dietaryRestrictions = json['dietaryRestrictions']?.cast<String>(),
      _exerciseFrequency = amplify_core.enumFromString<ExerciseFrequency>(json['exerciseFrequency'], ExerciseFrequency.values),
      _heightCm = (json['heightCm'] as num?)?.toDouble(),
      _openTextPreferences = json['openTextPreferences'],
      _targetCalories = (json['targetCalories'] as num?)?.toDouble(),
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _userId = json['userId'],
      _weightKg = (json['weightKg'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'activeMealPlanId': _activeMealPlanId, 'allergies': _allergies?.map((e) => amplify_core.enumToString(e)).toList(), 'createdAt': _createdAt?.format(), 'dailyMealsPreference': _dailyMealsPreference, 'dietaryRestrictions': _dietaryRestrictions, 'exerciseFrequency': amplify_core.enumToString(_exerciseFrequency), 'heightCm': _heightCm, 'openTextPreferences': _openTextPreferences, 'targetCalories': _targetCalories, 'updatedAt': _updatedAt?.format(), 'userId': _userId, 'weightKg': _weightKg
  };
  
  Map<String, Object?> toMap() => {
    'activeMealPlanId': _activeMealPlanId,
    'allergies': _allergies,
    'createdAt': _createdAt,
    'dailyMealsPreference': _dailyMealsPreference,
    'dietaryRestrictions': _dietaryRestrictions,
    'exerciseFrequency': _exerciseFrequency,
    'heightCm': _heightCm,
    'openTextPreferences': _openTextPreferences,
    'targetCalories': _targetCalories,
    'updatedAt': _updatedAt,
    'userId': _userId,
    'weightKg': _weightKg
  };

  static final amplify_core.QueryModelIdentifier<UserDetailsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserDetailsModelIdentifier>();
  static final ACTIVEMEALPLANID = amplify_core.QueryField(fieldName: "activeMealPlanId");
  static final ALLERGIES = amplify_core.QueryField(fieldName: "allergies");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final DAILYMEALSPREFERENCE = amplify_core.QueryField(fieldName: "dailyMealsPreference");
  static final DIETARYRESTRICTIONS = amplify_core.QueryField(fieldName: "dietaryRestrictions");
  static final EXERCISEFREQUENCY = amplify_core.QueryField(fieldName: "exerciseFrequency");
  static final HEIGHTCM = amplify_core.QueryField(fieldName: "heightCm");
  static final OPENTEXTPREFERENCES = amplify_core.QueryField(fieldName: "openTextPreferences");
  static final TARGETCALORIES = amplify_core.QueryField(fieldName: "targetCalories");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final WEIGHTKG = amplify_core.QueryField(fieldName: "weightKg");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserDetails";
    modelSchemaDefinition.pluralName = "UserDetails";
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["userId"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.ACTIVEMEALPLANID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.ALLERGIES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.enumeration.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.DAILYMEALSPREFERENCE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.DIETARYRESTRICTIONS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.EXERCISEFREQUENCY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.HEIGHTCM,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.OPENTEXTPREFERENCES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.TARGETCALORIES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserDetails.WEIGHTKG,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
  });
}

class _UserDetailsModelType extends amplify_core.ModelType<UserDetails> {
  const _UserDetailsModelType();
  
  @override
  UserDetails fromJson(Map<String, dynamic> jsonData) {
    return UserDetails.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserDetails';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserDetails] in your schema.
 */
class UserDetailsModelIdentifier implements amplify_core.ModelIdentifier<UserDetails> {
  final String userId;

  /** Create an instance of UserDetailsModelIdentifier using [userId] the primary key. */
  const UserDetailsModelIdentifier({
    required this.userId});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'userId': userId
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserDetailsModelIdentifier(userId: $userId)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserDetailsModelIdentifier &&
      userId == other.userId;
  }
  
  @override
  int get hashCode =>
    userId.hashCode;
}