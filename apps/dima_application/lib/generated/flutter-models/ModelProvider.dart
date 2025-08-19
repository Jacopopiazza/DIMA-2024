/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'ChatMessage.dart';
import 'ChatMetadata.dart';
import 'MealPlan.dart';
import 'NutritionistProfile.dart';
import 'PlanDayCompletion.dart';
import 'UserDetails.dart';
import 'ChatMessageConnection.dart';
import 'ChatMetadataConnection.dart';
import 'DailyPlanData.dart';
import 'Ingredient.dart';
import 'Macros.dart';
import 'Meal.dart';
import 'MealPlanConnection.dart';
import 'MealPlanGenerationStatus.dart';
import 'MealPlanList.dart';
import 'MealPlanResponse.dart';
import 'MealWithStatus.dart';
import 'NutritionistProfileConnection.dart';
import 'TodaysPlan.dart';

export 'AllergenEnum.dart';
export 'ChatMessage.dart';
export 'ChatMessageConnection.dart';
export 'ChatMetadata.dart';
export 'ChatMetadataConnection.dart';
export 'DailyPlanData.dart';
export 'ExerciseFrequency.dart';
export 'Ingredient.dart';
export 'Macros.dart';
export 'Meal.dart';
export 'MealNameEnum.dart';
export 'MealPlan.dart';
export 'MealPlanConnection.dart';
export 'MealPlanGenerationStatus.dart';
export 'MealPlanGenerationStatusValue.dart';
export 'MealPlanList.dart';
export 'MealPlanResponse.dart';
export 'MealPlanValidationStatus.dart';
export 'MealWithStatus.dart';
export 'NutritionistProfile.dart';
export 'NutritionistProfileConnection.dart';
export 'PlanDayCompletion.dart';
export 'PlanStatus.dart';
export 'SenderType.dart';
export 'TodaysPlan.dart';
export 'UserDetails.dart';
export 'WeekdayEnum.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "c818e9df2728fb99ab67168dd801561a";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [ChatMessage.schema, ChatMetadata.schema, MealPlan.schema, NutritionistProfile.schema, PlanDayCompletion.schema, UserDetails.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [ChatMessageConnection.schema, ChatMetadataConnection.schema, DailyPlanData.schema, Ingredient.schema, Macros.schema, Meal.schema, MealPlanConnection.schema, MealPlanGenerationStatus.schema, MealPlanList.schema, MealPlanResponse.schema, MealWithStatus.schema, NutritionistProfileConnection.schema, TodaysPlan.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "ChatMessage":
        return ChatMessage.classType;
      case "ChatMetadata":
        return ChatMetadata.classType;
      case "MealPlan":
        return MealPlan.classType;
      case "NutritionistProfile":
        return NutritionistProfile.classType;
      case "PlanDayCompletion":
        return PlanDayCompletion.classType;
      case "UserDetails":
        return UserDetails.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
