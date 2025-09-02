// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_plan_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetActivePlanCacheCollection on Isar {
  IsarCollection<ActivePlanCache> get activePlanCaches => this.collection();
}

const ActivePlanCacheSchema = CollectionSchema(
  name: r'ActivePlanCache',
  id: 926388966052476200,
  properties: {
    r'activeMealPlanId': PropertySchema(
      id: 0,
      name: r'activeMealPlanId',
      type: IsarType.string,
    ),
    r'confirmedNoActivePlan': PropertySchema(
      id: 1,
      name: r'confirmedNoActivePlan',
      type: IsarType.bool,
    ),
    r'isFresh': PropertySchema(
      id: 2,
      name: r'isFresh',
      type: IsarType.bool,
    ),
    r'isUsable': PropertySchema(
      id: 3,
      name: r'isUsable',
      type: IsarType.bool,
    ),
    r'lastConfirmedAt': PropertySchema(
      id: 4,
      name: r'lastConfirmedAt',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 6,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _activePlanCacheEstimateSize,
  serialize: _activePlanCacheSerialize,
  deserialize: _activePlanCacheDeserialize,
  deserializeProp: _activePlanCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
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
  getId: _activePlanCacheGetId,
  getLinks: _activePlanCacheGetLinks,
  attach: _activePlanCacheAttach,
  version: '3.1.0+1',
);

int _activePlanCacheEstimateSize(
  ActivePlanCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeMealPlanId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _activePlanCacheSerialize(
  ActivePlanCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeMealPlanId);
  writer.writeBool(offsets[1], object.confirmedNoActivePlan);
  writer.writeBool(offsets[2], object.isFresh);
  writer.writeBool(offsets[3], object.isUsable);
  writer.writeDateTime(offsets[4], object.lastConfirmedAt);
  writer.writeDateTime(offsets[5], object.updatedAt);
  writer.writeString(offsets[6], object.userId);
}

ActivePlanCache _activePlanCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ActivePlanCache(
    activeMealPlanId: reader.readStringOrNull(offsets[0]),
    confirmedNoActivePlan: reader.readBool(offsets[1]),
    lastConfirmedAt: reader.readDateTime(offsets[4]),
    updatedAt: reader.readDateTime(offsets[5]),
    userId: reader.readStringOrNull(offsets[6]),
  );
  object.id = id;
  return object;
}

P _activePlanCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _activePlanCacheGetId(ActivePlanCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _activePlanCacheGetLinks(ActivePlanCache object) {
  return [];
}

void _activePlanCacheAttach(
    IsarCollection<dynamic> col, Id id, ActivePlanCache object) {
  object.id = id;
}

extension ActivePlanCacheQueryWhereSort
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QWhere> {
  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ActivePlanCacheQueryWhere
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QWhereClause> {
  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause>
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause>
      userIdEqualTo(String? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterWhereClause>
      userIdNotEqualTo(String? userId) {
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

extension ActivePlanCacheQueryFilter
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QFilterCondition> {
  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeMealPlanId',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeMealPlanId',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeMealPlanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeMealPlanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeMealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      activeMealPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeMealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      confirmedNoActivePlanEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedNoActivePlan',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      isFreshEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFresh',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      isUsableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isUsable',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      lastConfirmedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      lastConfirmedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      lastConfirmedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      lastConfirmedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastConfirmedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdEqualTo(
    String? value, {
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
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

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension ActivePlanCacheQueryObject
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QFilterCondition> {}

extension ActivePlanCacheQueryLinks
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QFilterCondition> {}

extension ActivePlanCacheQuerySortBy
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QSortBy> {
  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByActiveMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByActiveMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByConfirmedNoActivePlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedNoActivePlan', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByConfirmedNoActivePlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedNoActivePlan', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy> sortByIsFresh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFresh', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByIsFreshDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFresh', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByIsUsable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsable', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByIsUsableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsable', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByLastConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConfirmedAt', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByLastConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConfirmedAt', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ActivePlanCacheQuerySortThenBy
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QSortThenBy> {
  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByActiveMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByActiveMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByConfirmedNoActivePlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedNoActivePlan', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByConfirmedNoActivePlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedNoActivePlan', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy> thenByIsFresh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFresh', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByIsFreshDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFresh', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByIsUsable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsable', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByIsUsableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUsable', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByLastConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConfirmedAt', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByLastConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConfirmedAt', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ActivePlanCacheQueryWhereDistinct
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct> {
  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct>
      distinctByActiveMealPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeMealPlanId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct>
      distinctByConfirmedNoActivePlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedNoActivePlan');
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct>
      distinctByIsFresh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFresh');
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct>
      distinctByIsUsable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUsable');
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct>
      distinctByLastConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastConfirmedAt');
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ActivePlanCache, ActivePlanCache, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension ActivePlanCacheQueryProperty
    on QueryBuilder<ActivePlanCache, ActivePlanCache, QQueryProperty> {
  QueryBuilder<ActivePlanCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ActivePlanCache, String?, QQueryOperations>
      activeMealPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeMealPlanId');
    });
  }

  QueryBuilder<ActivePlanCache, bool, QQueryOperations>
      confirmedNoActivePlanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedNoActivePlan');
    });
  }

  QueryBuilder<ActivePlanCache, bool, QQueryOperations> isFreshProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFresh');
    });
  }

  QueryBuilder<ActivePlanCache, bool, QQueryOperations> isUsableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUsable');
    });
  }

  QueryBuilder<ActivePlanCache, DateTime, QQueryOperations>
      lastConfirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastConfirmedAt');
    });
  }

  QueryBuilder<ActivePlanCache, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ActivePlanCache, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
