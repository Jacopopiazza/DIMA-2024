// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MealCacheSchema = Schema(
  name: r'MealCache',
  id: -65665653055929442,
  properties: {
    r'ingredients': PropertySchema(
      id: 0,
      name: r'ingredients',
      type: IsarType.objectList,
      target: r'IngredientCache',
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
      enumMap: _MealCachenameEnumValueMap,
    ),
    r'recipe': PropertySchema(
      id: 2,
      name: r'recipe',
      type: IsarType.string,
    ),
    r'recipeName': PropertySchema(
      id: 3,
      name: r'recipeName',
      type: IsarType.string,
    ),
    r'totalMacros': PropertySchema(
      id: 4,
      name: r'totalMacros',
      type: IsarType.object,
      target: r'MacrosCache',
    )
  },
  estimateSize: _mealCacheEstimateSize,
  serialize: _mealCacheSerialize,
  deserialize: _mealCacheDeserialize,
  deserializeProp: _mealCacheDeserializeProp,
);

int _mealCacheEstimateSize(
  MealCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.ingredients.length * 3;
  {
    final offsets = allOffsets[IngredientCache]!;
    for (var i = 0; i < object.ingredients.length; i++) {
      final value = object.ingredients[i];
      bytesCount +=
          IngredientCacheSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  bytesCount += 3 + object.recipe.length * 3;
  bytesCount += 3 + object.recipeName.length * 3;
  bytesCount += 3 +
      MacrosCacheSchema.estimateSize(
          object.totalMacros, allOffsets[MacrosCache]!, allOffsets);
  return bytesCount;
}

void _mealCacheSerialize(
  MealCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<IngredientCache>(
    offsets[0],
    allOffsets,
    IngredientCacheSchema.serialize,
    object.ingredients,
  );
  writer.writeString(offsets[1], object.name?.name);
  writer.writeString(offsets[2], object.recipe);
  writer.writeString(offsets[3], object.recipeName);
  writer.writeObject<MacrosCache>(
    offsets[4],
    allOffsets,
    MacrosCacheSchema.serialize,
    object.totalMacros,
  );
}

MealCache _mealCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealCache();
  object.ingredients = reader.readObjectList<IngredientCache>(
        offsets[0],
        IngredientCacheSchema.deserialize,
        allOffsets,
        IngredientCache(),
      ) ??
      [];
  object.name = _MealCachenameValueEnumMap[reader.readStringOrNull(offsets[1])];
  object.recipe = reader.readString(offsets[2]);
  object.recipeName = reader.readString(offsets[3]);
  object.totalMacros = reader.readObjectOrNull<MacrosCache>(
        offsets[4],
        MacrosCacheSchema.deserialize,
        allOffsets,
      ) ??
      MacrosCache();
  return object;
}

P _mealCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<IngredientCache>(
            offset,
            IngredientCacheSchema.deserialize,
            allOffsets,
            IngredientCache(),
          ) ??
          []) as P;
    case 1:
      return (_MealCachenameValueEnumMap[reader.readStringOrNull(offset)]) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectOrNull<MacrosCache>(
            offset,
            MacrosCacheSchema.deserialize,
            allOffsets,
          ) ??
          MacrosCache()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MealCachenameEnumValueMap = {
  r'BREAKFAST': r'BREAKFAST',
  r'DINNER': r'DINNER',
  r'LUNCH': r'LUNCH',
  r'SNACK_AFTERNOON': r'SNACK_AFTERNOON',
  r'SNACK_EVENING': r'SNACK_EVENING',
  r'SNACK_MORNING': r'SNACK_MORNING',
};
const _MealCachenameValueEnumMap = {
  r'BREAKFAST': MealNameEnum.BREAKFAST,
  r'DINNER': MealNameEnum.DINNER,
  r'LUNCH': MealNameEnum.LUNCH,
  r'SNACK_AFTERNOON': MealNameEnum.SNACK_AFTERNOON,
  r'SNACK_EVENING': MealNameEnum.SNACK_EVENING,
  r'SNACK_MORNING': MealNameEnum.SNACK_MORNING,
};

extension MealCacheQueryFilter
    on QueryBuilder<MealCache, MealCache, QFilterCondition> {
  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      ingredientsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredients',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      ingredientsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredients',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      ingredientsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredients',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      ingredientsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredients',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      ingredientsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredients',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      ingredientsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ingredients',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameEqualTo(
    MealNameEnum? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameGreaterThan(
    MealNameEnum? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameLessThan(
    MealNameEnum? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameBetween(
    MealNameEnum? lower,
    MealNameEnum? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipe',
        value: '',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipe',
        value: '',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      recipeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      recipeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> recipeNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      recipeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipeName',
        value: '',
      ));
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition>
      recipeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipeName',
        value: '',
      ));
    });
  }
}

extension MealCacheQueryObject
    on QueryBuilder<MealCache, MealCache, QFilterCondition> {
  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> ingredientsElement(
      FilterQuery<IngredientCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ingredients');
    });
  }

  QueryBuilder<MealCache, MealCache, QAfterFilterCondition> totalMacros(
      FilterQuery<MacrosCache> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'totalMacros');
    });
  }
}
