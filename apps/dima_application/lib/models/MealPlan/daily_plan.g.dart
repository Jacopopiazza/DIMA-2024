// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DailyPlanCacheSchema = Schema(
  name: r'DailyPlanCache',
  id: 774429399523561471,
  properties: {
    r'friday': PropertySchema(
      id: 0,
      name: r'friday',
      type: IsarType.objectList,
      target: r'MealCache',
    ),
    r'monday': PropertySchema(
      id: 1,
      name: r'monday',
      type: IsarType.objectList,
      target: r'MealCache',
    ),
    r'saturday': PropertySchema(
      id: 2,
      name: r'saturday',
      type: IsarType.objectList,
      target: r'MealCache',
    ),
    r'sunday': PropertySchema(
      id: 3,
      name: r'sunday',
      type: IsarType.objectList,
      target: r'MealCache',
    ),
    r'thursday': PropertySchema(
      id: 4,
      name: r'thursday',
      type: IsarType.objectList,
      target: r'MealCache',
    ),
    r'tuesday': PropertySchema(
      id: 5,
      name: r'tuesday',
      type: IsarType.objectList,
      target: r'MealCache',
    ),
    r'wednesday': PropertySchema(
      id: 6,
      name: r'wednesday',
      type: IsarType.objectList,
      target: r'MealCache',
    )
  },
  estimateSize: _dailyPlanCacheEstimateSize,
  serialize: _dailyPlanCacheSerialize,
  deserialize: _dailyPlanCacheDeserialize,
  deserializeProp: _dailyPlanCacheDeserializeProp,
);

int _dailyPlanCacheEstimateSize(
  DailyPlanCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.friday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.friday.length; i++) {
      final value = object.friday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.monday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.monday.length; i++) {
      final value = object.monday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.saturday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.saturday.length; i++) {
      final value = object.saturday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.sunday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.sunday.length; i++) {
      final value = object.sunday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.thursday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.thursday.length; i++) {
      final value = object.thursday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.tuesday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.tuesday.length; i++) {
      final value = object.tuesday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.wednesday.length * 3;
  {
    final offsets = allOffsets[MealCache]!;
    for (var i = 0; i < object.wednesday.length; i++) {
      final value = object.wednesday[i];
      bytesCount += MealCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _dailyPlanCacheSerialize(
  DailyPlanCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<MealCache>(
    offsets[0],
    allOffsets,
    MealCacheSchema.serialize,
    object.friday,
  );
  writer.writeObjectList<MealCache>(
    offsets[1],
    allOffsets,
    MealCacheSchema.serialize,
    object.monday,
  );
  writer.writeObjectList<MealCache>(
    offsets[2],
    allOffsets,
    MealCacheSchema.serialize,
    object.saturday,
  );
  writer.writeObjectList<MealCache>(
    offsets[3],
    allOffsets,
    MealCacheSchema.serialize,
    object.sunday,
  );
  writer.writeObjectList<MealCache>(
    offsets[4],
    allOffsets,
    MealCacheSchema.serialize,
    object.thursday,
  );
  writer.writeObjectList<MealCache>(
    offsets[5],
    allOffsets,
    MealCacheSchema.serialize,
    object.tuesday,
  );
  writer.writeObjectList<MealCache>(
    offsets[6],
    allOffsets,
    MealCacheSchema.serialize,
    object.wednesday,
  );
}

DailyPlanCache _dailyPlanCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyPlanCache();
  object.friday = reader.readObjectList<MealCache>(
        offsets[0],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  object.monday = reader.readObjectList<MealCache>(
        offsets[1],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  object.saturday = reader.readObjectList<MealCache>(
        offsets[2],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  object.sunday = reader.readObjectList<MealCache>(
        offsets[3],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  object.thursday = reader.readObjectList<MealCache>(
        offsets[4],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  object.tuesday = reader.readObjectList<MealCache>(
        offsets[5],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  object.wednesday = reader.readObjectList<MealCache>(
        offsets[6],
        MealCacheSchema.deserialize,
        allOffsets,
        MealCache(),
      ) ??
      [];
  return object;
}

P _dailyPlanCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    case 1:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    case 2:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    case 3:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    case 4:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    case 5:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    case 6:
      return (reader.readObjectList<MealCache>(
            offset,
            MealCacheSchema.deserialize,
            allOffsets,
            MealCache(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DailyPlanCacheQueryFilter
    on QueryBuilder<DailyPlanCache, DailyPlanCache, QFilterCondition> {
  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'monday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'monday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'monday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'monday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'monday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'monday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saturday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saturday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saturday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saturday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saturday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saturday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sunday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sunday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sunday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sunday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sunday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sunday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thursday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thursday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thursday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thursday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thursday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'thursday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tuesday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tuesday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tuesday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tuesday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tuesday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tuesday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'wednesday',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'wednesday',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'wednesday',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'wednesday',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'wednesday',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'wednesday',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DailyPlanCacheQueryObject
    on QueryBuilder<DailyPlanCache, DailyPlanCache, QFilterCondition> {
  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      fridayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'friday');
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      mondayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'monday');
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      saturdayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'saturday');
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      sundayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sunday');
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      thursdayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'thursday');
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      tuesdayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tuesday');
    });
  }

  QueryBuilder<DailyPlanCache, DailyPlanCache, QAfterFilterCondition>
      wednesdayElement(FilterQuery<MealCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'wednesday');
    });
  }
}
