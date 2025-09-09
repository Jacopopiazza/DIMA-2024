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

/** This is an auto generated class representing the NutritionistLocation type in your schema. */
class NutritionistLocation {
  final String? _address;
  final double? _latitude;
  final double? _longitude;
  final String? _notes;
  final String? _nutritionistId;
  final amplify_core.TemporalDateTime? _updatedAt;

  String? get address {
    return _address;
  }

  double get latitude {
    try {
      return _latitude!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get longitude {
    try {
      return _longitude!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get notes {
    return _notes;
  }

  String get nutritionistId {
    try {
      return _nutritionistId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const NutritionistLocation._internal(
      {address,
      required latitude,
      required longitude,
      notes,
      required nutritionistId,
      updatedAt})
      : _address = address,
        _latitude = latitude,
        _longitude = longitude,
        _notes = notes,
        _nutritionistId = nutritionistId,
        _updatedAt = updatedAt;

  factory NutritionistLocation(
      {String? address,
      required double latitude,
      required double longitude,
      String? notes,
      required String nutritionistId,
      amplify_core.TemporalDateTime? updatedAt}) {
    return NutritionistLocation._internal(
        address: address,
        latitude: latitude,
        longitude: longitude,
        notes: notes,
        nutritionistId: nutritionistId,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NutritionistLocation &&
        _address == other._address &&
        _latitude == other._latitude &&
        _longitude == other._longitude &&
        _notes == other._notes &&
        _nutritionistId == other._nutritionistId &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("NutritionistLocation {");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("latitude=" +
        (_latitude != null ? _latitude!.toString() : "null") +
        ", ");
    buffer.write("longitude=" +
        (_longitude != null ? _longitude!.toString() : "null") +
        ", ");
    buffer.write("notes=" + "$_notes" + ", ");
    buffer.write("nutritionistId=" + "$_nutritionistId" + ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  NutritionistLocation copyWith(
      {String? address,
      double? latitude,
      double? longitude,
      String? notes,
      String? nutritionistId,
      amplify_core.TemporalDateTime? updatedAt}) {
    return NutritionistLocation._internal(
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        notes: notes ?? this.notes,
        nutritionistId: nutritionistId ?? this.nutritionistId,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  NutritionistLocation copyWithModelFieldValues(
      {ModelFieldValue<String?>? address,
      ModelFieldValue<double>? latitude,
      ModelFieldValue<double>? longitude,
      ModelFieldValue<String?>? notes,
      ModelFieldValue<String>? nutritionistId,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return NutritionistLocation._internal(
        address: address == null ? this.address : address.value,
        latitude: latitude == null ? this.latitude : latitude.value,
        longitude: longitude == null ? this.longitude : longitude.value,
        notes: notes == null ? this.notes : notes.value,
        nutritionistId:
            nutritionistId == null ? this.nutritionistId : nutritionistId.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  NutritionistLocation.fromJson(Map<String, dynamic> json)
      : _address = json['address'],
        _latitude = (json['latitude'] as num?)?.toDouble(),
        _longitude = (json['longitude'] as num?)?.toDouble(),
        _notes = json['notes'],
        _nutritionistId = json['nutritionistId'],
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'address': _address,
        'latitude': _latitude,
        'longitude': _longitude,
        'notes': _notes,
        'nutritionistId': _nutritionistId,
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'address': _address,
        'latitude': _latitude,
        'longitude': _longitude,
        'notes': _notes,
        'nutritionistId': _nutritionistId,
        'updatedAt': _updatedAt
      };

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "NutritionistLocation";
    modelSchemaDefinition.pluralName = "NutritionistLocations";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'address',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'latitude',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'longitude',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'notes',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'nutritionistId',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'updatedAt',
            isRequired: false,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}
