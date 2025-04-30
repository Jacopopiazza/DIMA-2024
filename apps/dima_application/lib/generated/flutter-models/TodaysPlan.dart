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


/** This is an auto generated class representing the TodaysPlan type in your schema. */
class TodaysPlan {
  final MealPlan? _activePlanDetails;
  final List<MealWithStatus>? _mealsForToday;

  MealPlan? get activePlanDetails {
    return _activePlanDetails;
  }
  
  List<MealWithStatus>? get mealsForToday {
    return _mealsForToday;
  }
  
  const TodaysPlan._internal({activePlanDetails, mealsForToday}): _activePlanDetails = activePlanDetails, _mealsForToday = mealsForToday;
  
  factory TodaysPlan({MealPlan? activePlanDetails, List<MealWithStatus>? mealsForToday}) {
    return TodaysPlan._internal(
      activePlanDetails: activePlanDetails,
      mealsForToday: mealsForToday != null ? List<MealWithStatus>.unmodifiable(mealsForToday) : mealsForToday);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TodaysPlan &&
      _activePlanDetails == other._activePlanDetails &&
      DeepCollectionEquality().equals(_mealsForToday, other._mealsForToday);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TodaysPlan {");
    buffer.write("activePlanDetails=" + (_activePlanDetails != null ? _activePlanDetails!.toString() : "null") + ", ");
    buffer.write("mealsForToday=" + (_mealsForToday != null ? _mealsForToday!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TodaysPlan copyWith({MealPlan? activePlanDetails, List<MealWithStatus>? mealsForToday}) {
    return TodaysPlan._internal(
      activePlanDetails: activePlanDetails ?? this.activePlanDetails,
      mealsForToday: mealsForToday ?? this.mealsForToday);
  }
  
  TodaysPlan copyWithModelFieldValues({
    ModelFieldValue<MealPlan?>? activePlanDetails,
    ModelFieldValue<List<MealWithStatus>>? mealsForToday
  }) {
    return TodaysPlan._internal(
      activePlanDetails: activePlanDetails == null ? this.activePlanDetails : activePlanDetails.value,
      mealsForToday: mealsForToday == null ? this.mealsForToday : mealsForToday.value
    );
  }
  
  TodaysPlan.fromJson(Map<String, dynamic> json)  
    : _activePlanDetails = json['activePlanDetails'] != null
        ? json['activePlanDetails']['serializedData'] != null
          ? MealPlan.fromJson(new Map<String, dynamic>.from(json['activePlanDetails']['serializedData']))
          : MealPlan.fromJson(new Map<String, dynamic>.from(json['activePlanDetails']))
        : null,
      _mealsForToday = json['mealsForToday'] is List
        ? (json['mealsForToday'] as List)
          .where((e) => e != null)
          .map((e) => MealWithStatus.fromJson(new Map<String, dynamic>.from(e['serializedData'] ?? e)))
          .toList()
        : null;
  
  Map<String, dynamic> toJson() => {
    'activePlanDetails': _activePlanDetails?.toJson(), 'mealsForToday': _mealsForToday?.map((MealWithStatus? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'activePlanDetails': _activePlanDetails,
    'mealsForToday': _mealsForToday
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TodaysPlan";
    modelSchemaDefinition.pluralName = "TodaysPlans";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'activePlanDetails',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'mealsForToday',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'MealWithStatus')
    ));
  });
}