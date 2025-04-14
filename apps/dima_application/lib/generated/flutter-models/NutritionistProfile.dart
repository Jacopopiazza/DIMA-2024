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


/** This is an auto generated class representing the NutritionistProfile type in your schema. */
class NutritionistProfile extends amplify_core.Model {
  static const classType = const _NutritionistProfileModelType();
  final String id;
  final String? _bio;
  final String? _familyName;
  final String? _givenName;
  final bool? _isAvailable;
  final String? _nutritionistId;
  final String? _profilePictureUrl;
  final String? _specialization;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  NutritionistProfileModelIdentifier get modelIdentifier {
      return NutritionistProfileModelIdentifier(
        id: id
      );
  }
  
  String? get bio {
    return _bio;
  }
  
  String? get familyName {
    return _familyName;
  }
  
  String? get givenName {
    return _givenName;
  }
  
  bool? get isAvailable {
    return _isAvailable;
  }
  
  String get nutritionistId {
    try {
      return _nutritionistId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get profilePictureUrl {
    return _profilePictureUrl;
  }
  
  String? get specialization {
    return _specialization;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const NutritionistProfile._internal({required this.id, bio, familyName, givenName, isAvailable, required nutritionistId, profilePictureUrl, specialization, createdAt, updatedAt}): _bio = bio, _familyName = familyName, _givenName = givenName, _isAvailable = isAvailable, _nutritionistId = nutritionistId, _profilePictureUrl = profilePictureUrl, _specialization = specialization, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory NutritionistProfile({String? id, String? bio, String? familyName, String? givenName, bool? isAvailable, required String nutritionistId, String? profilePictureUrl, String? specialization}) {
    return NutritionistProfile._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      bio: bio,
      familyName: familyName,
      givenName: givenName,
      isAvailable: isAvailable,
      nutritionistId: nutritionistId,
      profilePictureUrl: profilePictureUrl,
      specialization: specialization);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NutritionistProfile &&
      id == other.id &&
      _bio == other._bio &&
      _familyName == other._familyName &&
      _givenName == other._givenName &&
      _isAvailable == other._isAvailable &&
      _nutritionistId == other._nutritionistId &&
      _profilePictureUrl == other._profilePictureUrl &&
      _specialization == other._specialization;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("NutritionistProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("bio=" + "$_bio" + ", ");
    buffer.write("familyName=" + "$_familyName" + ", ");
    buffer.write("givenName=" + "$_givenName" + ", ");
    buffer.write("isAvailable=" + (_isAvailable != null ? _isAvailable!.toString() : "null") + ", ");
    buffer.write("nutritionistId=" + "$_nutritionistId" + ", ");
    buffer.write("profilePictureUrl=" + "$_profilePictureUrl" + ", ");
    buffer.write("specialization=" + "$_specialization" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  NutritionistProfile copyWith({String? bio, String? familyName, String? givenName, bool? isAvailable, String? nutritionistId, String? profilePictureUrl, String? specialization}) {
    return NutritionistProfile._internal(
      id: id,
      bio: bio ?? this.bio,
      familyName: familyName ?? this.familyName,
      givenName: givenName ?? this.givenName,
      isAvailable: isAvailable ?? this.isAvailable,
      nutritionistId: nutritionistId ?? this.nutritionistId,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      specialization: specialization ?? this.specialization);
  }
  
  NutritionistProfile copyWithModelFieldValues({
    ModelFieldValue<String?>? bio,
    ModelFieldValue<String?>? familyName,
    ModelFieldValue<String?>? givenName,
    ModelFieldValue<bool?>? isAvailable,
    ModelFieldValue<String>? nutritionistId,
    ModelFieldValue<String?>? profilePictureUrl,
    ModelFieldValue<String?>? specialization
  }) {
    return NutritionistProfile._internal(
      id: id,
      bio: bio == null ? this.bio : bio.value,
      familyName: familyName == null ? this.familyName : familyName.value,
      givenName: givenName == null ? this.givenName : givenName.value,
      isAvailable: isAvailable == null ? this.isAvailable : isAvailable.value,
      nutritionistId: nutritionistId == null ? this.nutritionistId : nutritionistId.value,
      profilePictureUrl: profilePictureUrl == null ? this.profilePictureUrl : profilePictureUrl.value,
      specialization: specialization == null ? this.specialization : specialization.value
    );
  }
  
  NutritionistProfile.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _bio = json['bio'],
      _familyName = json['familyName'],
      _givenName = json['givenName'],
      _isAvailable = json['isAvailable'],
      _nutritionistId = json['nutritionistId'],
      _profilePictureUrl = json['profilePictureUrl'],
      _specialization = json['specialization'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'bio': _bio, 'familyName': _familyName, 'givenName': _givenName, 'isAvailable': _isAvailable, 'nutritionistId': _nutritionistId, 'profilePictureUrl': _profilePictureUrl, 'specialization': _specialization, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'bio': _bio,
    'familyName': _familyName,
    'givenName': _givenName,
    'isAvailable': _isAvailable,
    'nutritionistId': _nutritionistId,
    'profilePictureUrl': _profilePictureUrl,
    'specialization': _specialization,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<NutritionistProfileModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<NutritionistProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final BIO = amplify_core.QueryField(fieldName: "bio");
  static final FAMILYNAME = amplify_core.QueryField(fieldName: "familyName");
  static final GIVENNAME = amplify_core.QueryField(fieldName: "givenName");
  static final ISAVAILABLE = amplify_core.QueryField(fieldName: "isAvailable");
  static final NUTRITIONISTID = amplify_core.QueryField(fieldName: "nutritionistId");
  static final PROFILEPICTUREURL = amplify_core.QueryField(fieldName: "profilePictureUrl");
  static final SPECIALIZATION = amplify_core.QueryField(fieldName: "specialization");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "NutritionistProfile";
    modelSchemaDefinition.pluralName = "NutritionistProfiles";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.BIO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.FAMILYNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.GIVENNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.ISAVAILABLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.NUTRITIONISTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.PROFILEPICTUREURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: NutritionistProfile.SPECIALIZATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _NutritionistProfileModelType extends amplify_core.ModelType<NutritionistProfile> {
  const _NutritionistProfileModelType();
  
  @override
  NutritionistProfile fromJson(Map<String, dynamic> jsonData) {
    return NutritionistProfile.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'NutritionistProfile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [NutritionistProfile] in your schema.
 */
class NutritionistProfileModelIdentifier implements amplify_core.ModelIdentifier<NutritionistProfile> {
  final String id;

  /** Create an instance of NutritionistProfileModelIdentifier using [id] the primary key. */
  const NutritionistProfileModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'NutritionistProfileModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is NutritionistProfileModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}