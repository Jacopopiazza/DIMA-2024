// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_completion.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyCompletionCollection on Isar {
  IsarCollection<DailyCompletion> get dailyCompletions => this.collection();
}

const DailyCompletionSchema = CollectionSchema(
  name: r'DailyCompletion',
  id: -8413370184331475747,
  properties: {
    r'completedMealNames': PropertySchema(
      id: 0,
      name: r'completedMealNames',
      type: IsarType.byteList,
      enumMap: _DailyCompletioncompletedMealNamesEnumValueMap,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyCompletionEstimateSize,
  serialize: _dailyCompletionSerialize,
  deserialize: _dailyCompletionDeserialize,
  deserializeProp: _dailyCompletionDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyCompletionGetId,
  getLinks: _dailyCompletionGetLinks,
  attach: _dailyCompletionAttach,
  version: '3.1.0+1',
);

int _dailyCompletionEstimateSize(
  DailyCompletion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completedMealNames.length;
  return bytesCount;
}

void _dailyCompletionSerialize(
  DailyCompletion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(
      offsets[0], object.completedMealNames.map((e) => e.index).toList());
  writer.writeDateTime(offsets[1], object.date);
}

DailyCompletion _dailyCompletionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyCompletion(
    completedMealNames: reader
            .readByteList(offsets[0])
            ?.map((e) =>
                _DailyCompletioncompletedMealNamesValueEnumMap[e] ??
                MealNameEnum.BREAKFAST)
            .toList() ??
        const [],
    date: reader.readDateTime(offsets[1]),
    id: id,
  );
  return object;
}

P _dailyCompletionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _DailyCompletioncompletedMealNamesValueEnumMap[e] ??
                  MealNameEnum.BREAKFAST)
              .toList() ??
          const []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DailyCompletioncompletedMealNamesEnumValueMap = {
  'BREAKFAST': 0,
  'DINNER': 1,
  'LUNCH': 2,
  'SNACK_AFTERNOON': 3,
  'SNACK_EVENING': 4,
  'SNACK_MORNING': 5,
};
const _DailyCompletioncompletedMealNamesValueEnumMap = {
  0: MealNameEnum.BREAKFAST,
  1: MealNameEnum.DINNER,
  2: MealNameEnum.LUNCH,
  3: MealNameEnum.SNACK_AFTERNOON,
  4: MealNameEnum.SNACK_EVENING,
  5: MealNameEnum.SNACK_MORNING,
};

Id _dailyCompletionGetId(DailyCompletion object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyCompletionGetLinks(DailyCompletion object) {
  return [];
}

void _dailyCompletionAttach(
    IsarCollection<dynamic> col, Id id, DailyCompletion object) {
  object.id = id;
}

extension DailyCompletionByIndex on IsarCollection<DailyCompletion> {
  Future<DailyCompletion?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyCompletion? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyCompletion?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyCompletion?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyCompletion object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyCompletion object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyCompletion> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyCompletion> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyCompletionQueryWhereSort
    on QueryBuilder<DailyCompletion, DailyCompletion, QWhere> {
  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyCompletionQueryWhere
    on QueryBuilder<DailyCompletion, DailyCompletion, QWhereClause> {
  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause>
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

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyCompletionQueryFilter
    on QueryBuilder<DailyCompletion, DailyCompletion, QFilterCondition> {
  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesElementEqualTo(MealNameEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedMealNames',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesElementGreaterThan(
    MealNameEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedMealNames',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesElementLessThan(
    MealNameEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedMealNames',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesElementBetween(
    MealNameEnum lower,
    MealNameEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedMealNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedMealNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedMealNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedMealNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedMealNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedMealNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      completedMealNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedMealNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
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

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
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

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterFilterCondition>
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
}

extension DailyCompletionQueryObject
    on QueryBuilder<DailyCompletion, DailyCompletion, QFilterCondition> {}

extension DailyCompletionQueryLinks
    on QueryBuilder<DailyCompletion, DailyCompletion, QFilterCondition> {}

extension DailyCompletionQuerySortBy
    on QueryBuilder<DailyCompletion, DailyCompletion, QSortBy> {
  QueryBuilder<DailyCompletion, DailyCompletion, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension DailyCompletionQuerySortThenBy
    on QueryBuilder<DailyCompletion, DailyCompletion, QSortThenBy> {
  QueryBuilder<DailyCompletion, DailyCompletion, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DailyCompletionQueryWhereDistinct
    on QueryBuilder<DailyCompletion, DailyCompletion, QDistinct> {
  QueryBuilder<DailyCompletion, DailyCompletion, QDistinct>
      distinctByCompletedMealNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedMealNames');
    });
  }

  QueryBuilder<DailyCompletion, DailyCompletion, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension DailyCompletionQueryProperty
    on QueryBuilder<DailyCompletion, DailyCompletion, QQueryProperty> {
  QueryBuilder<DailyCompletion, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyCompletion, List<MealNameEnum>, QQueryOperations>
      completedMealNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedMealNames');
    });
  }

  QueryBuilder<DailyCompletion, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }
}
