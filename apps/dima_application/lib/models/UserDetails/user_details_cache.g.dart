// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserDetailsCacheCollection on Isar {
  IsarCollection<UserDetailsCache> get userDetailsCaches => this.collection();
}

const UserDetailsCacheSchema = CollectionSchema(
  name: r'UserDetailsCache',
  id: -1042812343592549102,
  properties: {
    r'activeMealPlanId': PropertySchema(
      id: 0,
      name: r'activeMealPlanId',
      type: IsarType.string,
    ),
    r'allergiesJson': PropertySchema(
      id: 1,
      name: r'allergiesJson',
      type: IsarType.stringList,
    ),
    r'dailyMealsPreference': PropertySchema(
      id: 2,
      name: r'dailyMealsPreference',
      type: IsarType.long,
    ),
    r'exerciseFrequencyString': PropertySchema(
      id: 3,
      name: r'exerciseFrequencyString',
      type: IsarType.string,
    ),
    r'heightCm': PropertySchema(
      id: 4,
      name: r'heightCm',
      type: IsarType.double,
    ),
    r'lastFetched': PropertySchema(
      id: 5,
      name: r'lastFetched',
      type: IsarType.dateTime,
    ),
    r'openTextPreferences': PropertySchema(
      id: 6,
      name: r'openTextPreferences',
      type: IsarType.string,
    ),
    r'updatedAtString': PropertySchema(
      id: 7,
      name: r'updatedAtString',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 8,
      name: r'userId',
      type: IsarType.string,
    ),
    r'weightKg': PropertySchema(
      id: 9,
      name: r'weightKg',
      type: IsarType.double,
    )
  },
  estimateSize: _userDetailsCacheEstimateSize,
  serialize: _userDetailsCacheSerialize,
  deserialize: _userDetailsCacheDeserialize,
  deserializeProp: _userDetailsCacheDeserializeProp,
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
  getId: _userDetailsCacheGetId,
  getLinks: _userDetailsCacheGetLinks,
  attach: _userDetailsCacheAttach,
  version: '3.1.0+1',
);

int _userDetailsCacheEstimateSize(
  UserDetailsCache object,
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
    final list = object.allergiesJson;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.exerciseFrequencyString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.openTextPreferences;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.updatedAtString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _userDetailsCacheSerialize(
  UserDetailsCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeMealPlanId);
  writer.writeStringList(offsets[1], object.allergiesJson);
  writer.writeLong(offsets[2], object.dailyMealsPreference);
  writer.writeString(offsets[3], object.exerciseFrequencyString);
  writer.writeDouble(offsets[4], object.heightCm);
  writer.writeDateTime(offsets[5], object.lastFetched);
  writer.writeString(offsets[6], object.openTextPreferences);
  writer.writeString(offsets[7], object.updatedAtString);
  writer.writeString(offsets[8], object.userId);
  writer.writeDouble(offsets[9], object.weightKg);
}

UserDetailsCache _userDetailsCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserDetailsCache();
  object.activeMealPlanId = reader.readStringOrNull(offsets[0]);
  object.allergiesJson = reader.readStringList(offsets[1]);
  object.dailyMealsPreference = reader.readLongOrNull(offsets[2]);
  object.exerciseFrequencyString = reader.readStringOrNull(offsets[3]);
  object.heightCm = reader.readDoubleOrNull(offsets[4]);
  object.id = id;
  object.lastFetched = reader.readDateTime(offsets[5]);
  object.openTextPreferences = reader.readStringOrNull(offsets[6]);
  object.updatedAtString = reader.readStringOrNull(offsets[7]);
  object.userId = reader.readString(offsets[8]);
  object.weightKg = reader.readDoubleOrNull(offsets[9]);
  return object;
}

P _userDetailsCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userDetailsCacheGetId(UserDetailsCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userDetailsCacheGetLinks(UserDetailsCache object) {
  return [];
}

void _userDetailsCacheAttach(
    IsarCollection<dynamic> col, Id id, UserDetailsCache object) {
  object.id = id;
}

extension UserDetailsCacheByIndex on IsarCollection<UserDetailsCache> {
  Future<UserDetailsCache?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  UserDetailsCache? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<UserDetailsCache?>> getAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<UserDetailsCache?> getAllByUserIdSync(List<String> userIdValues) {
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

  Future<Id> putByUserId(UserDetailsCache object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(UserDetailsCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<UserDetailsCache> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<UserDetailsCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension UserDetailsCacheQueryWhereSort
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QWhere> {
  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserDetailsCacheQueryWhere
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QWhereClause> {
  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterWhereClause>
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

extension UserDetailsCacheQueryFilter
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QFilterCondition> {
  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      activeMealPlanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeMealPlanId',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      activeMealPlanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeMealPlanId',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      activeMealPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeMealPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      activeMealPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeMealPlanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      activeMealPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeMealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      activeMealPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeMealPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'allergiesJson',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'allergiesJson',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allergiesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'allergiesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'allergiesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'allergiesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'allergiesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'allergiesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'allergiesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'allergiesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allergiesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'allergiesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergiesJson',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergiesJson',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergiesJson',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergiesJson',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergiesJson',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      allergiesJsonLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergiesJson',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      dailyMealsPreferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dailyMealsPreference',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      dailyMealsPreferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dailyMealsPreference',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      dailyMealsPreferenceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyMealsPreference',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      dailyMealsPreferenceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyMealsPreference',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      dailyMealsPreferenceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyMealsPreference',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      dailyMealsPreferenceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyMealsPreference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseFrequencyString',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseFrequencyString',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseFrequencyString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseFrequencyString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseFrequencyString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseFrequencyString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseFrequencyString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseFrequencyString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseFrequencyString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseFrequencyString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseFrequencyString',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      exerciseFrequencyStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseFrequencyString',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      heightCmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'heightCm',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      heightCmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'heightCm',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      heightCmEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heightCm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      heightCmGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heightCm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      heightCmLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heightCm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      heightCmBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heightCm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      lastFetchedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      lastFetchedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      lastFetchedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      lastFetchedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFetched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openTextPreferences',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'openTextPreferences',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openTextPreferences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openTextPreferences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openTextPreferences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openTextPreferences',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'openTextPreferences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'openTextPreferences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'openTextPreferences',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'openTextPreferences',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openTextPreferences',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      openTextPreferencesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'openTextPreferences',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAtString',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAtString',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAtString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAtString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAtString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'updatedAtString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'updatedAtString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updatedAtString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updatedAtString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtString',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      updatedAtStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updatedAtString',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
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

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      weightKgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weightKg',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      weightKgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weightKg',
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      weightKgEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      weightKgGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      weightKgLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterFilterCondition>
      weightKgBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension UserDetailsCacheQueryObject
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QFilterCondition> {}

extension UserDetailsCacheQueryLinks
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QFilterCondition> {}

extension UserDetailsCacheQuerySortBy
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QSortBy> {
  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByActiveMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByActiveMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByDailyMealsPreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMealsPreference', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByDailyMealsPreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMealsPreference', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByExerciseFrequencyString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseFrequencyString', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByExerciseFrequencyStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseFrequencyString', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByHeightCm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByHeightCmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByLastFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByLastFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByOpenTextPreferences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openTextPreferences', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByOpenTextPreferencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openTextPreferences', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByUpdatedAtString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtString', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByUpdatedAtStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtString', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      sortByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension UserDetailsCacheQuerySortThenBy
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QSortThenBy> {
  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByActiveMealPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByActiveMealPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMealPlanId', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByDailyMealsPreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMealsPreference', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByDailyMealsPreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMealsPreference', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByExerciseFrequencyString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseFrequencyString', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByExerciseFrequencyStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseFrequencyString', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByHeightCm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByHeightCmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByLastFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByLastFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetched', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByOpenTextPreferences() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openTextPreferences', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByOpenTextPreferencesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openTextPreferences', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByUpdatedAtString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtString', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByUpdatedAtStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtString', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QAfterSortBy>
      thenByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension UserDetailsCacheQueryWhereDistinct
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct> {
  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByActiveMealPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeMealPlanId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByAllergiesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allergiesJson');
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByDailyMealsPreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyMealsPreference');
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByExerciseFrequencyString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseFrequencyString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByHeightCm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heightCm');
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByLastFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFetched');
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByOpenTextPreferences({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openTextPreferences',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByUpdatedAtString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserDetailsCache, UserDetailsCache, QDistinct>
      distinctByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightKg');
    });
  }
}

extension UserDetailsCacheQueryProperty
    on QueryBuilder<UserDetailsCache, UserDetailsCache, QQueryProperty> {
  QueryBuilder<UserDetailsCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserDetailsCache, String?, QQueryOperations>
      activeMealPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeMealPlanId');
    });
  }

  QueryBuilder<UserDetailsCache, List<String>?, QQueryOperations>
      allergiesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allergiesJson');
    });
  }

  QueryBuilder<UserDetailsCache, int?, QQueryOperations>
      dailyMealsPreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyMealsPreference');
    });
  }

  QueryBuilder<UserDetailsCache, String?, QQueryOperations>
      exerciseFrequencyStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseFrequencyString');
    });
  }

  QueryBuilder<UserDetailsCache, double?, QQueryOperations> heightCmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heightCm');
    });
  }

  QueryBuilder<UserDetailsCache, DateTime, QQueryOperations>
      lastFetchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFetched');
    });
  }

  QueryBuilder<UserDetailsCache, String?, QQueryOperations>
      openTextPreferencesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openTextPreferences');
    });
  }

  QueryBuilder<UserDetailsCache, String?, QQueryOperations>
      updatedAtStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtString');
    });
  }

  QueryBuilder<UserDetailsCache, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<UserDetailsCache, double?, QQueryOperations> weightKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightKg');
    });
  }
}
