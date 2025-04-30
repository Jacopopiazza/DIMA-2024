// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'macros.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MacrosCacheSchema = Schema(
  name: r'MacrosCache',
  id: -3067593784191098365,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.double,
    ),
    r'carbohydrates': PropertySchema(
      id: 1,
      name: r'carbohydrates',
      type: IsarType.double,
    ),
    r'fats': PropertySchema(
      id: 2,
      name: r'fats',
      type: IsarType.double,
    ),
    r'proteins': PropertySchema(
      id: 3,
      name: r'proteins',
      type: IsarType.double,
    )
  },
  estimateSize: _macrosCacheEstimateSize,
  serialize: _macrosCacheSerialize,
  deserialize: _macrosCacheDeserialize,
  deserializeProp: _macrosCacheDeserializeProp,
);

int _macrosCacheEstimateSize(
  MacrosCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _macrosCacheSerialize(
  MacrosCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.calories);
  writer.writeDouble(offsets[1], object.carbohydrates);
  writer.writeDouble(offsets[2], object.fats);
  writer.writeDouble(offsets[3], object.proteins);
}

MacrosCache _macrosCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MacrosCache(
    calories: reader.readDoubleOrNull(offsets[0]) ?? 0.0,
    carbohydrates: reader.readDoubleOrNull(offsets[1]) ?? 0.0,
    fats: reader.readDoubleOrNull(offsets[2]) ?? 0.0,
    proteins: reader.readDoubleOrNull(offsets[3]) ?? 0.0,
  );
  return object;
}

P _macrosCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MacrosCacheQueryFilter
    on QueryBuilder<MacrosCache, MacrosCache, QFilterCondition> {
  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> caloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      caloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      caloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> caloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      carbohydratesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbohydrates',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      carbohydratesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbohydrates',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      carbohydratesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbohydrates',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      carbohydratesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbohydrates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> fatsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> fatsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> fatsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> fatsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> proteinsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteins',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      proteinsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteins',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition>
      proteinsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteins',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MacrosCache, MacrosCache, QAfterFilterCondition> proteinsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteins',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension MacrosCacheQueryObject
    on QueryBuilder<MacrosCache, MacrosCache, QFilterCondition> {}
