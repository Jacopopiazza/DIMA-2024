// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DailyPlanSchema = Schema(
  name: r'DailyPlan',
  id: 9074873586170206523,
  properties: {
    r'meals': PropertySchema(
      id: 0,
      name: r'meals',
      type: IsarType.objectList,
      target: r'Meal',
    ),
    r'totalMacros': PropertySchema(
      id: 1,
      name: r'totalMacros',
      type: IsarType.object,
      target: r'Macros',
    ),
    r'weekday': PropertySchema(
      id: 2,
      name: r'weekday',
      type: IsarType.string,
    )
  },
  estimateSize: _dailyPlanEstimateSize,
  serialize: _dailyPlanSerialize,
  deserialize: _dailyPlanDeserialize,
  deserializeProp: _dailyPlanDeserializeProp,
);

int _dailyPlanEstimateSize(
  DailyPlan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.meals.length * 3;
  {
    final offsets = allOffsets[Meal]!;
    for (var i = 0; i < object.meals.length; i++) {
      final value = object.meals[i];
      bytesCount += MealSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 +
      MacrosSchema.estimateSize(
          object.totalMacros, allOffsets[Macros]!, allOffsets);
  bytesCount += 3 + object.weekday.length * 3;
  return bytesCount;
}

void _dailyPlanSerialize(
  DailyPlan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Meal>(
    offsets[0],
    allOffsets,
    MealSchema.serialize,
    object.meals,
  );
  writer.writeObject<Macros>(
    offsets[1],
    allOffsets,
    MacrosSchema.serialize,
    object.totalMacros,
  );
  writer.writeString(offsets[2], object.weekday);
}

DailyPlan _dailyPlanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyPlan();
  object.meals = reader.readObjectList<Meal>(
        offsets[0],
        MealSchema.deserialize,
        allOffsets,
        Meal(),
      ) ??
      [];
  object.totalMacros = reader.readObjectOrNull<Macros>(
        offsets[1],
        MacrosSchema.deserialize,
        allOffsets,
      ) ??
      Macros();
  object.weekday = reader.readString(offsets[2]);
  return object;
}

P _dailyPlanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Meal>(
            offset,
            MealSchema.deserialize,
            allOffsets,
            Meal(),
          ) ??
          []) as P;
    case 1:
      return (reader.readObjectOrNull<Macros>(
            offset,
            MacrosSchema.deserialize,
            allOffsets,
          ) ??
          Macros()) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DailyPlanQueryFilter
    on QueryBuilder<DailyPlan, DailyPlan, QFilterCondition> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> mealsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> mealsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> mealsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> mealsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      mealsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> mealsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'meals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weekday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weekday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weekday',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weekday',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> weekdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekday',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      weekdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weekday',
        value: '',
      ));
    });
  }
}

extension DailyPlanQueryObject
    on QueryBuilder<DailyPlan, DailyPlan, QFilterCondition> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> mealsElement(
      FilterQuery<Meal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'meals');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> totalMacros(
      FilterQuery<Macros> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'totalMacros');
    });
  }
}
