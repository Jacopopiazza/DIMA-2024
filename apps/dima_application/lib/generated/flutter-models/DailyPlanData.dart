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

/** This is an auto generated class representing the DailyPlanData type in your schema. */
class DailyPlanData {
  final List<Meal>? _friday;
  final List<Meal>? _monday;
  final List<Meal>? _saturday;
  final List<Meal>? _sunday;
  final List<Meal>? _thursday;
  final List<Meal>? _tuesday;
  final List<Meal>? _wednesday;

  List<Meal>? get friday {
    return _friday;
  }

  List<Meal>? get monday {
    return _monday;
  }

  List<Meal>? get saturday {
    return _saturday;
  }

  List<Meal>? get sunday {
    return _sunday;
  }

  List<Meal>? get thursday {
    return _thursday;
  }

  List<Meal>? get tuesday {
    return _tuesday;
  }

  List<Meal>? get wednesday {
    return _wednesday;
  }

  const DailyPlanData._internal(
      {friday, monday, saturday, sunday, thursday, tuesday, wednesday})
      : _friday = friday,
        _monday = monday,
        _saturday = saturday,
        _sunday = sunday,
        _thursday = thursday,
        _tuesday = tuesday,
        _wednesday = wednesday;

  factory DailyPlanData(
      {List<Meal>? friday,
      List<Meal>? monday,
      List<Meal>? saturday,
      List<Meal>? sunday,
      List<Meal>? thursday,
      List<Meal>? tuesday,
      List<Meal>? wednesday}) {
    return DailyPlanData._internal(
        friday: friday != null ? List<Meal>.unmodifiable(friday) : friday,
        monday: monday != null ? List<Meal>.unmodifiable(monday) : monday,
        saturday:
            saturday != null ? List<Meal>.unmodifiable(saturday) : saturday,
        sunday: sunday != null ? List<Meal>.unmodifiable(sunday) : sunday,
        thursday:
            thursday != null ? List<Meal>.unmodifiable(thursday) : thursday,
        tuesday: tuesday != null ? List<Meal>.unmodifiable(tuesday) : tuesday,
        wednesday:
            wednesday != null ? List<Meal>.unmodifiable(wednesday) : wednesday);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyPlanData &&
        DeepCollectionEquality().equals(_friday, other._friday) &&
        DeepCollectionEquality().equals(_monday, other._monday) &&
        DeepCollectionEquality().equals(_saturday, other._saturday) &&
        DeepCollectionEquality().equals(_sunday, other._sunday) &&
        DeepCollectionEquality().equals(_thursday, other._thursday) &&
        DeepCollectionEquality().equals(_tuesday, other._tuesday) &&
        DeepCollectionEquality().equals(_wednesday, other._wednesday);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("DailyPlanData {");
    buffer.write(
        "friday=" + (_friday != null ? _friday!.toString() : "null") + ", ");
    buffer.write(
        "monday=" + (_monday != null ? _monday!.toString() : "null") + ", ");
    buffer.write("saturday=" +
        (_saturday != null ? _saturday!.toString() : "null") +
        ", ");
    buffer.write(
        "sunday=" + (_sunday != null ? _sunday!.toString() : "null") + ", ");
    buffer.write("thursday=" +
        (_thursday != null ? _thursday!.toString() : "null") +
        ", ");
    buffer.write(
        "tuesday=" + (_tuesday != null ? _tuesday!.toString() : "null") + ", ");
    buffer.write(
        "wednesday=" + (_wednesday != null ? _wednesday!.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  DailyPlanData copyWith(
      {List<Meal>? friday,
      List<Meal>? monday,
      List<Meal>? saturday,
      List<Meal>? sunday,
      List<Meal>? thursday,
      List<Meal>? tuesday,
      List<Meal>? wednesday}) {
    return DailyPlanData._internal(
        friday: friday ?? this.friday,
        monday: monday ?? this.monday,
        saturday: saturday ?? this.saturday,
        sunday: sunday ?? this.sunday,
        thursday: thursday ?? this.thursday,
        tuesday: tuesday ?? this.tuesday,
        wednesday: wednesday ?? this.wednesday);
  }

  DailyPlanData copyWithModelFieldValues(
      {ModelFieldValue<List<Meal>>? friday,
      ModelFieldValue<List<Meal>>? monday,
      ModelFieldValue<List<Meal>>? saturday,
      ModelFieldValue<List<Meal>>? sunday,
      ModelFieldValue<List<Meal>>? thursday,
      ModelFieldValue<List<Meal>>? tuesday,
      ModelFieldValue<List<Meal>>? wednesday}) {
    return DailyPlanData._internal(
        friday: friday == null ? this.friday : friday.value,
        monday: monday == null ? this.monday : monday.value,
        saturday: saturday == null ? this.saturday : saturday.value,
        sunday: sunday == null ? this.sunday : sunday.value,
        thursday: thursday == null ? this.thursday : thursday.value,
        tuesday: tuesday == null ? this.tuesday : tuesday.value,
        wednesday: wednesday == null ? this.wednesday : wednesday.value);
  }

  DailyPlanData.fromJson(Map<String, dynamic> json)
      : _friday = json['friday'] is List
            ? (json['friday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _monday = json['monday'] is List
            ? (json['monday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _saturday = json['saturday'] is List
            ? (json['saturday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _sunday = json['sunday'] is List
            ? (json['sunday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _thursday = json['thursday'] is List
            ? (json['thursday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _tuesday = json['tuesday'] is List
            ? (json['tuesday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null,
        _wednesday = json['wednesday'] is List
            ? (json['wednesday'] as List)
                .where((e) => e != null)
                .map((e) => Meal.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'] ?? e)))
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        'friday': _friday?.map((Meal? e) => e?.toJson()).toList(),
        'monday': _monday?.map((Meal? e) => e?.toJson()).toList(),
        'saturday': _saturday?.map((Meal? e) => e?.toJson()).toList(),
        'sunday': _sunday?.map((Meal? e) => e?.toJson()).toList(),
        'thursday': _thursday?.map((Meal? e) => e?.toJson()).toList(),
        'tuesday': _tuesday?.map((Meal? e) => e?.toJson()).toList(),
        'wednesday': _wednesday?.map((Meal? e) => e?.toJson()).toList()
      };

  Map<String, Object?> toMap() => {
        'friday': _friday,
        'monday': _monday,
        'saturday': _saturday,
        'sunday': _sunday,
        'thursday': _thursday,
        'tuesday': _tuesday,
        'wednesday': _wednesday
      };

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DailyPlanData";
    modelSchemaDefinition.pluralName = "DailyPlanData";

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'friday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'monday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'saturday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'sunday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'thursday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'tuesday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
        fieldName: 'wednesday',
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.embeddedCollection,
            ofCustomTypeName: 'Meal')));
  });
}
