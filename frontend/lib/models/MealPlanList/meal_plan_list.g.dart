// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_list.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealPlanListCacheCollection on Isar {
  IsarCollection<MealPlanListCache> get mealPlanListCaches => this.collection();
}

const MealPlanListCacheSchema = CollectionSchema(
  name: r'MealPlanListCache',
  id: -8052923644984877733,
  properties: {
    r'allMealPlanIds': PropertySchema(
      id: 0,
      name: r'allMealPlanIds',
      type: IsarType.stringList,
    ),
    r'currentMealPlanId': PropertySchema(
      id: 1,
      name: r'currentMealPlanId',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 2,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _mealPlanListCacheEstimateSize,
  serialize: _mealPlanListCacheSerialize,
  deserialize: _mealPlanListCacheDeserialize,
  deserializeProp: _mealPlanListCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mealPlanListCacheGetId,
  getLinks: _mealPlanListCacheGetLinks,
  attach: _mealPlanListCacheAttach,
  version: '3.1.0+1',
);

int _mealPlanListCacheEstimateSize(
  MealPlanListCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.allMealPlanIds.length * 3;
  {
    for (var i = 0; i < object.allMealPlanIds.length; i++) {
      final value = object.allMealPlanIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.currentMealPlanId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _mealPlanListCacheSerialize(
  MealPlanListCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.allMealPlanIds);
  writer.writeString(offsets[1], object.currentMealPlanId);
  writer.writeString(offsets[2], object.userId);
}

MealPlanListCache _mealPlanListCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealPlanListCache(
    allMealPlanIds: reader.readStringList(offsets[0]) ?? const [],
    currentMealPlanId: reader.readStringOrNull(offsets[1]),
  );
  object.id = id;
  object.userId = reader.readString(offsets[2]);
  return object;
}

P _mealPlanListCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? const []) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mealPlanListCacheGetId(MealPlanListCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealPlanListCacheGetLinks(
    MealPlanListCache object) {
  return [];
}

void _mealPlanListCacheAttach(
    IsarCollection<dynamic> col, Id id, MealPlanListCache object) {
  object.id = id;
}

extension MealPlanListCacheByIndex on IsarCollection<MealPlanListCache> {
  Future<MealPlanListCache?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  MealPlanListCache? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<MealPlanListCache?>> getAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<MealPlanListCache?> getAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(MealPlanListCache object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(MealPlanListCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<MealPlanListCache> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<MealPlanListCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension MealPlanListCacheQueryWhereSort
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QWhere> {
  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealPlanListCacheQueryWhere
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QWhereClause> {
  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterWhereClause>
      userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MealPlanListCacheQueryFilter
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QFilterCondition> {
  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allMealPlanIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'allMealPlanIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'allMealPlanIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'allMealPlanIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'allMealPlanIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'allMealPlanIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'allMealPlanIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'allMealPlanIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allMealPlanIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'allMealPlanIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allMealPlanIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allMealPlanIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allMealPlanIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allMealPlanIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allMealPlanIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      allMealPlanIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allMealPlanIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentMealPlanId',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentMealPlanId',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentMealPlanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentMealPlanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      currentMealPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentMealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
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

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension MealPlanListCacheQueryObject
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QFilterCondition> {}

extension MealPlanListCacheQueryLinks
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QFilterCondition> {}

extension MealPlanListCacheQuerySortBy
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QSortBy> {
  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      sortByCurrentMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMealPlanId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      sortByCurrentMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMealPlanId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension MealPlanListCacheQuerySortThenBy
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QSortThenBy> {
  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      thenByCurrentMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMealPlanId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      thenByCurrentMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMealPlanId', Sort.desc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension MealPlanListCacheQueryWhereDistinct
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QDistinct> {
  QueryBuilder<MealPlanListCache, MealPlanListCache, QDistinct>
      distinctByAllMealPlanIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allMealPlanIds');
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QDistinct>
      distinctByCurrentMealPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentMealPlanId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealPlanListCache, MealPlanListCache, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension MealPlanListCacheQueryProperty
    on QueryBuilder<MealPlanListCache, MealPlanListCache, QQueryProperty> {
  QueryBuilder<MealPlanListCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealPlanListCache, List<String>, QQueryOperations>
      allMealPlanIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allMealPlanIds');
    });
  }

  QueryBuilder<MealPlanListCache, String?, QQueryOperations>
      currentMealPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentMealPlanId');
    });
  }

  QueryBuilder<MealPlanListCache, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
