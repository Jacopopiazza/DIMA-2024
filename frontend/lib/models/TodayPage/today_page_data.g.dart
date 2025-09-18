// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_page_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTodayPageDataCollection on Isar {
  IsarCollection<TodayPageData> get todayPageDatas => this.collection();
}

const TodayPageDataSchema = CollectionSchema(
  name: r'TodayPageData',
  id: 4614289730160283210,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.string,
    ),
    r'carbPercent': PropertySchema(
      id: 1,
      name: r'carbPercent',
      type: IsarType.double,
    ),
    r'dinnerImageUrl': PropertySchema(
      id: 2,
      name: r'dinnerImageUrl',
      type: IsarType.string,
    ),
    r'fatPercent': PropertySchema(
      id: 3,
      name: r'fatPercent',
      type: IsarType.double,
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'lunchImageUrl': PropertySchema(
      id: 5,
      name: r'lunchImageUrl',
      type: IsarType.string,
    ),
    r'proteinPercent': PropertySchema(
      id: 6,
      name: r'proteinPercent',
      type: IsarType.double,
    )
  },
  estimateSize: _todayPageDataEstimateSize,
  serialize: _todayPageDataSerialize,
  deserialize: _todayPageDataDeserialize,
  deserializeProp: _todayPageDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'lastUpdated': IndexSchema(
      id: 8989359681631629925,
      name: r'lastUpdated',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastUpdated',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _todayPageDataGetId,
  getLinks: _todayPageDataGetLinks,
  attach: _todayPageDataAttach,
  version: '3.1.0+1',
);

int _todayPageDataEstimateSize(
  TodayPageData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.calories.length * 3;
  bytesCount += 3 + object.dinnerImageUrl.length * 3;
  bytesCount += 3 + object.lunchImageUrl.length * 3;
  return bytesCount;
}

void _todayPageDataSerialize(
  TodayPageData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.calories);
  writer.writeDouble(offsets[1], object.carbPercent);
  writer.writeString(offsets[2], object.dinnerImageUrl);
  writer.writeDouble(offsets[3], object.fatPercent);
  writer.writeDateTime(offsets[4], object.lastUpdated);
  writer.writeString(offsets[5], object.lunchImageUrl);
  writer.writeDouble(offsets[6], object.proteinPercent);
}

TodayPageData _todayPageDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodayPageData(
    calories: reader.readString(offsets[0]),
    carbPercent: reader.readDouble(offsets[1]),
    dinnerImageUrl: reader.readString(offsets[2]),
    fatPercent: reader.readDouble(offsets[3]),
    lastUpdated: reader.readDateTime(offsets[4]),
    lunchImageUrl: reader.readString(offsets[5]),
    proteinPercent: reader.readDouble(offsets[6]),
  );
  object.id = id;
  return object;
}

P _todayPageDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _todayPageDataGetId(TodayPageData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _todayPageDataGetLinks(TodayPageData object) {
  return [];
}

void _todayPageDataAttach(
    IsarCollection<dynamic> col, Id id, TodayPageData object) {
  object.id = id;
}

extension TodayPageDataQueryWhereSort
    on QueryBuilder<TodayPageData, TodayPageData, QWhere> {
  QueryBuilder<TodayPageData, TodayPageData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhere> anyLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastUpdated'),
      );
    });
  }
}

extension TodayPageDataQueryWhere
    on QueryBuilder<TodayPageData, TodayPageData, QWhereClause> {
  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause> idBetween(
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

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause>
      lastUpdatedEqualTo(DateTime lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastUpdated',
        value: [lastUpdated],
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause>
      lastUpdatedNotEqualTo(DateTime lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [],
              upper: [lastUpdated],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [lastUpdated],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [lastUpdated],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [],
              upper: [lastUpdated],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause>
      lastUpdatedGreaterThan(
    DateTime lastUpdated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [lastUpdated],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause>
      lastUpdatedLessThan(
    DateTime lastUpdated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [],
        upper: [lastUpdated],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterWhereClause>
      lastUpdatedBetween(
    DateTime lowerLastUpdated,
    DateTime upperLastUpdated, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [lowerLastUpdated],
        includeLower: includeLower,
        upper: [upperLastUpdated],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TodayPageDataQueryFilter
    on QueryBuilder<TodayPageData, TodayPageData, QFilterCondition> {
  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'calories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'calories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'calories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'calories',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: '',
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      caloriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'calories',
        value: '',
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      carbPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      carbPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      carbPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      carbPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dinnerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dinnerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dinnerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dinnerImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dinnerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dinnerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dinnerImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dinnerImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dinnerImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      dinnerImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dinnerImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      fatPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      fatPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      fatPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      fatPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
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

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lunchImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lunchImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lunchImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lunchImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lunchImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lunchImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lunchImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lunchImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lunchImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      lunchImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lunchImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      proteinPercentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      proteinPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteinPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      proteinPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteinPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterFilterCondition>
      proteinPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteinPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TodayPageDataQueryObject
    on QueryBuilder<TodayPageData, TodayPageData, QFilterCondition> {}

extension TodayPageDataQueryLinks
    on QueryBuilder<TodayPageData, TodayPageData, QFilterCondition> {}

extension TodayPageDataQuerySortBy
    on QueryBuilder<TodayPageData, TodayPageData, QSortBy> {
  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> sortByCarbPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbPercent', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByCarbPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbPercent', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByDinnerImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerImageUrl', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByDinnerImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerImageUrl', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> sortByFatPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatPercent', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByFatPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatPercent', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByLunchImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchImageUrl', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByLunchImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchImageUrl', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByProteinPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinPercent', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      sortByProteinPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinPercent', Sort.desc);
    });
  }
}

extension TodayPageDataQuerySortThenBy
    on QueryBuilder<TodayPageData, TodayPageData, QSortThenBy> {
  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> thenByCarbPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbPercent', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByCarbPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbPercent', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByDinnerImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerImageUrl', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByDinnerImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerImageUrl', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> thenByFatPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatPercent', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByFatPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatPercent', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByLunchImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchImageUrl', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByLunchImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchImageUrl', Sort.desc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByProteinPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinPercent', Sort.asc);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QAfterSortBy>
      thenByProteinPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinPercent', Sort.desc);
    });
  }
}

extension TodayPageDataQueryWhereDistinct
    on QueryBuilder<TodayPageData, TodayPageData, QDistinct> {
  QueryBuilder<TodayPageData, TodayPageData, QDistinct> distinctByCalories(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QDistinct>
      distinctByCarbPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbPercent');
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QDistinct>
      distinctByDinnerImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dinnerImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QDistinct> distinctByFatPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatPercent');
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QDistinct> distinctByLunchImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lunchImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodayPageData, TodayPageData, QDistinct>
      distinctByProteinPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinPercent');
    });
  }
}

extension TodayPageDataQueryProperty
    on QueryBuilder<TodayPageData, TodayPageData, QQueryProperty> {
  QueryBuilder<TodayPageData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TodayPageData, String, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<TodayPageData, double, QQueryOperations> carbPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbPercent');
    });
  }

  QueryBuilder<TodayPageData, String, QQueryOperations>
      dinnerImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dinnerImageUrl');
    });
  }

  QueryBuilder<TodayPageData, double, QQueryOperations> fatPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatPercent');
    });
  }

  QueryBuilder<TodayPageData, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<TodayPageData, String, QQueryOperations>
      lunchImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lunchImageUrl');
    });
  }

  QueryBuilder<TodayPageData, double, QQueryOperations>
      proteinPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinPercent');
    });
  }
}
