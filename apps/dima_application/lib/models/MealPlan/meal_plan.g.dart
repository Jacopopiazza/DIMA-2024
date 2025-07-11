// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealPlanCacheCollection on Isar {
  IsarCollection<MealPlanCache> get mealPlanCaches => this.collection();
}

const MealPlanCacheSchema = CollectionSchema(
  name: r'MealPlanCache',
  id: -8556752169949088239,
  properties: {
    r'assignedNutritionistId': PropertySchema(
      id: 0,
      name: r'assignedNutritionistId',
      type: IsarType.string,
    ),
    r'chatId': PropertySchema(
      id: 1,
      name: r'chatId',
      type: IsarType.string,
    ),
    r'dailyPlan': PropertySchema(
      id: 2,
      name: r'dailyPlan',
      type: IsarType.object,
      target: r'DailyPlanCache',
    ),
    r'generatedAtTimestamp': PropertySchema(
      id: 3,
      name: r'generatedAtTimestamp',
      type: IsarType.string,
    ),
    r'lastFetchedTimestamp': PropertySchema(
      id: 4,
      name: r'lastFetchedTimestamp',
      type: IsarType.string,
    ),
    r'mealPlanId': PropertySchema(
      id: 5,
      name: r'mealPlanId',
      type: IsarType.string,
    ),
    r'planName': PropertySchema(
      id: 6,
      name: r'planName',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
      type: IsarType.byte,
      enumMap: _MealPlanCachestatusEnumValueMap,
    ),
    r'userId': PropertySchema(
      id: 8,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _mealPlanCacheEstimateSize,
  serialize: _mealPlanCacheSerialize,
  deserialize: _mealPlanCacheDeserialize,
  deserializeProp: _mealPlanCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'mealPlanId': IndexSchema(
      id: 3168714601529429647,
      name: r'mealPlanId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'mealPlanId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'planName': IndexSchema(
      id: -2372009361415681807,
      name: r'planName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'planName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'DailyPlanCache': DailyPlanCacheSchema,
    r'MealCache': MealCacheSchema,
    r'IngredientCache': IngredientCacheSchema,
    r'MacrosCache': MacrosCacheSchema
  },
  getId: _mealPlanCacheGetId,
  getLinks: _mealPlanCacheGetLinks,
  attach: _mealPlanCacheAttach,
  version: '3.1.0+1',
);

int _mealPlanCacheEstimateSize(
  MealPlanCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.assignedNutritionistId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chatId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      DailyPlanCacheSchema.estimateSize(
          object.dailyPlan, allOffsets[DailyPlanCache]!, allOffsets);
  bytesCount += 3 + object.generatedAtTimestamp.length * 3;
  bytesCount += 3 + object.lastFetchedTimestamp.length * 3;
  bytesCount += 3 + object.mealPlanId.length * 3;
  bytesCount += 3 + object.planName.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _mealPlanCacheSerialize(
  MealPlanCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assignedNutritionistId);
  writer.writeString(offsets[1], object.chatId);
  writer.writeObject<DailyPlanCache>(
    offsets[2],
    allOffsets,
    DailyPlanCacheSchema.serialize,
    object.dailyPlan,
  );
  writer.writeString(offsets[3], object.generatedAtTimestamp);
  writer.writeString(offsets[4], object.lastFetchedTimestamp);
  writer.writeString(offsets[5], object.mealPlanId);
  writer.writeString(offsets[6], object.planName);
  writer.writeByte(offsets[7], object.status.index);
  writer.writeString(offsets[8], object.userId);
}

MealPlanCache _mealPlanCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealPlanCache();
  object.assignedNutritionistId = reader.readStringOrNull(offsets[0]);
  object.chatId = reader.readStringOrNull(offsets[1]);
  object.dailyPlan = reader.readObjectOrNull<DailyPlanCache>(
        offsets[2],
        DailyPlanCacheSchema.deserialize,
        allOffsets,
      ) ??
      DailyPlanCache();
  object.generatedAtTimestamp = reader.readString(offsets[3]);
  object.id = id;
  object.lastFetchedTimestamp = reader.readString(offsets[4]);
  object.mealPlanId = reader.readString(offsets[5]);
  object.planName = reader.readString(offsets[6]);
  object.status =
      _MealPlanCachestatusValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          PlanStatus.ACTIVE;
  object.userId = reader.readString(offsets[8]);
  return object;
}

P _mealPlanCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readObjectOrNull<DailyPlanCache>(
            offset,
            DailyPlanCacheSchema.deserialize,
            allOffsets,
          ) ??
          DailyPlanCache()) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (_MealPlanCachestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          PlanStatus.ACTIVE) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MealPlanCachestatusEnumValueMap = {
  'ACTIVE': 0,
  'ARCHIVED': 1,
  'GENERATED': 2,
};
const _MealPlanCachestatusValueEnumMap = {
  0: PlanStatus.ACTIVE,
  1: PlanStatus.ARCHIVED,
  2: PlanStatus.GENERATED,
};

Id _mealPlanCacheGetId(MealPlanCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealPlanCacheGetLinks(MealPlanCache object) {
  return [];
}

void _mealPlanCacheAttach(
    IsarCollection<dynamic> col, Id id, MealPlanCache object) {
  object.id = id;
}

extension MealPlanCacheByIndex on IsarCollection<MealPlanCache> {
  Future<MealPlanCache?> getByMealPlanId(String mealPlanId) {
    return getByIndex(r'mealPlanId', [mealPlanId]);
  }

  MealPlanCache? getByMealPlanIdSync(String mealPlanId) {
    return getByIndexSync(r'mealPlanId', [mealPlanId]);
  }

  Future<bool> deleteByMealPlanId(String mealPlanId) {
    return deleteByIndex(r'mealPlanId', [mealPlanId]);
  }

  bool deleteByMealPlanIdSync(String mealPlanId) {
    return deleteByIndexSync(r'mealPlanId', [mealPlanId]);
  }

  Future<List<MealPlanCache?>> getAllByMealPlanId(
      List<String> mealPlanIdValues) {
    final values = mealPlanIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'mealPlanId', values);
  }

  List<MealPlanCache?> getAllByMealPlanIdSync(List<String> mealPlanIdValues) {
    final values = mealPlanIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'mealPlanId', values);
  }

  Future<int> deleteAllByMealPlanId(List<String> mealPlanIdValues) {
    final values = mealPlanIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'mealPlanId', values);
  }

  int deleteAllByMealPlanIdSync(List<String> mealPlanIdValues) {
    final values = mealPlanIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'mealPlanId', values);
  }

  Future<Id> putByMealPlanId(MealPlanCache object) {
    return putByIndex(r'mealPlanId', object);
  }

  Id putByMealPlanIdSync(MealPlanCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'mealPlanId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMealPlanId(List<MealPlanCache> objects) {
    return putAllByIndex(r'mealPlanId', objects);
  }

  List<Id> putAllByMealPlanIdSync(List<MealPlanCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'mealPlanId', objects, saveLinks: saveLinks);
  }

  Future<MealPlanCache?> getByPlanName(String planName) {
    return getByIndex(r'planName', [planName]);
  }

  MealPlanCache? getByPlanNameSync(String planName) {
    return getByIndexSync(r'planName', [planName]);
  }

  Future<bool> deleteByPlanName(String planName) {
    return deleteByIndex(r'planName', [planName]);
  }

  bool deleteByPlanNameSync(String planName) {
    return deleteByIndexSync(r'planName', [planName]);
  }

  Future<List<MealPlanCache?>> getAllByPlanName(List<String> planNameValues) {
    final values = planNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'planName', values);
  }

  List<MealPlanCache?> getAllByPlanNameSync(List<String> planNameValues) {
    final values = planNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'planName', values);
  }

  Future<int> deleteAllByPlanName(List<String> planNameValues) {
    final values = planNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'planName', values);
  }

  int deleteAllByPlanNameSync(List<String> planNameValues) {
    final values = planNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'planName', values);
  }

  Future<Id> putByPlanName(MealPlanCache object) {
    return putByIndex(r'planName', object);
  }

  Id putByPlanNameSync(MealPlanCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'planName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPlanName(List<MealPlanCache> objects) {
    return putAllByIndex(r'planName', objects);
  }

  List<Id> putAllByPlanNameSync(List<MealPlanCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'planName', objects, saveLinks: saveLinks);
  }
}

extension MealPlanCacheQueryWhereSort
    on QueryBuilder<MealPlanCache, MealPlanCache, QWhere> {
  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealPlanCacheQueryWhere
    on QueryBuilder<MealPlanCache, MealPlanCache, QWhereClause> {
  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause>
      mealPlanIdEqualTo(String mealPlanId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mealPlanId',
        value: [mealPlanId],
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause>
      mealPlanIdNotEqualTo(String mealPlanId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mealPlanId',
              lower: [],
              upper: [mealPlanId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mealPlanId',
              lower: [mealPlanId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mealPlanId',
              lower: [mealPlanId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mealPlanId',
              lower: [],
              upper: [mealPlanId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause> planNameEqualTo(
      String planName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planName',
        value: [planName],
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterWhereClause>
      planNameNotEqualTo(String planName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planName',
              lower: [],
              upper: [planName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planName',
              lower: [planName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planName',
              lower: [planName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planName',
              lower: [],
              upper: [planName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MealPlanCacheQueryFilter
    on QueryBuilder<MealPlanCache, MealPlanCache, QFilterCondition> {
  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assignedNutritionistId',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assignedNutritionistId',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignedNutritionistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assignedNutritionistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assignedNutritionistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assignedNutritionistId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assignedNutritionistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assignedNutritionistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assignedNutritionistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assignedNutritionistId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignedNutritionistId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      assignedNutritionistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assignedNutritionistId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatId',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatId',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      chatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAtTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAtTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAtTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAtTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'generatedAtTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'generatedAtTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'generatedAtTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'generatedAtTimestamp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAtTimestamp',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      generatedAtTimestampIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'generatedAtTimestamp',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFetchedTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFetchedTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFetchedTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFetchedTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastFetchedTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastFetchedTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastFetchedTimestamp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastFetchedTimestamp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFetchedTimestamp',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      lastFetchedTimestampIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastFetchedTimestamp',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealPlanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mealPlanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      mealPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planName',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      planNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planName',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      statusEqualTo(PlanStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      statusGreaterThan(
    PlanStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      statusLessThan(
    PlanStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      statusBetween(
    PlanStatus lower,
    PlanStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension MealPlanCacheQueryObject
    on QueryBuilder<MealPlanCache, MealPlanCache, QFilterCondition> {
  QueryBuilder<MealPlanCache, MealPlanCache, QAfterFilterCondition> dailyPlan(
      FilterQuery<DailyPlanCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dailyPlan');
    });
  }
}

extension MealPlanCacheQueryLinks
    on QueryBuilder<MealPlanCache, MealPlanCache, QFilterCondition> {}

extension MealPlanCacheQuerySortBy
    on QueryBuilder<MealPlanCache, MealPlanCache, QSortBy> {
  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByAssignedNutritionistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedNutritionistId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByAssignedNutritionistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedNutritionistId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByGeneratedAtTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtTimestamp', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByGeneratedAtTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtTimestamp', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByLastFetchedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedTimestamp', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByLastFetchedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedTimestamp', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPlanId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPlanId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      sortByPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension MealPlanCacheQuerySortThenBy
    on QueryBuilder<MealPlanCache, MealPlanCache, QSortThenBy> {
  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByAssignedNutritionistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedNutritionistId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByAssignedNutritionistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedNutritionistId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByGeneratedAtTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtTimestamp', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByGeneratedAtTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtTimestamp', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByLastFetchedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedTimestamp', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByLastFetchedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedTimestamp', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPlanId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealPlanId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy>
      thenByPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension MealPlanCacheQueryWhereDistinct
    on QueryBuilder<MealPlanCache, MealPlanCache, QDistinct> {
  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct>
      distinctByAssignedNutritionistId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assignedNutritionistId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct> distinctByChatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct>
      distinctByGeneratedAtTimestamp({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAtTimestamp',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct>
      distinctByLastFetchedTimestamp({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFetchedTimestamp',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct> distinctByMealPlanId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealPlanId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct> distinctByPlanName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<MealPlanCache, MealPlanCache, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension MealPlanCacheQueryProperty
    on QueryBuilder<MealPlanCache, MealPlanCache, QQueryProperty> {
  QueryBuilder<MealPlanCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealPlanCache, String?, QQueryOperations>
      assignedNutritionistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assignedNutritionistId');
    });
  }

  QueryBuilder<MealPlanCache, String?, QQueryOperations> chatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatId');
    });
  }

  QueryBuilder<MealPlanCache, DailyPlanCache, QQueryOperations>
      dailyPlanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyPlan');
    });
  }

  QueryBuilder<MealPlanCache, String, QQueryOperations>
      generatedAtTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAtTimestamp');
    });
  }

  QueryBuilder<MealPlanCache, String, QQueryOperations>
      lastFetchedTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFetchedTimestamp');
    });
  }

  QueryBuilder<MealPlanCache, String, QQueryOperations> mealPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealPlanId');
    });
  }

  QueryBuilder<MealPlanCache, String, QQueryOperations> planNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planName');
    });
  }

  QueryBuilder<MealPlanCache, PlanStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<MealPlanCache, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
