import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Custom input formatter that replaces commas with dots for decimal input
class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Replace comma with dot for decimal separator
    String newText = newValue.text.replaceAll(',', '.');
    
    // Ensure we only allow valid decimal characters
    newText = newText.replaceAll(RegExp(r'[^0-9.]'), '');
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ModifyMealPlanDialog extends StatefulWidget {
  final MealPlan mealPlan;
  final Function(String, Map<String, dynamic>) onSave;

  const ModifyMealPlanDialog({
    super.key,
    required this.mealPlan,
    required this.onSave,
  });

  @override
  State<ModifyMealPlanDialog> createState() => _ModifyMealPlanDialogState();
}

class _ModifyMealPlanDialogState extends State<ModifyMealPlanDialog> {
  bool _isLoading = false;
  bool _isDailyPlanExpanded = true;
  bool _isMetadataExpanded = false;
  Map<String, List<Meal>> _editedMeals = {};

  @override
  void initState() {
    super.initState();
    _initializeEditedMeals();
  }

  void _initializeEditedMeals() {
    final dailyPlan = widget.mealPlan.dailyPlan;
    if (dailyPlan != null) {
      _editedMeals = {
        'monday': List<Meal>.from(dailyPlan.monday ?? []),
        'tuesday': List<Meal>.from(dailyPlan.tuesday ?? []),
        'wednesday': List<Meal>.from(dailyPlan.wednesday ?? []),
        'thursday': List<Meal>.from(dailyPlan.thursday ?? []),
        'friday': List<Meal>.from(dailyPlan.friday ?? []),
        'saturday': List<Meal>.from(dailyPlan.saturday ?? []),
        'sunday': List<Meal>.from(dailyPlan.sunday ?? []),
      };
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? _validateMealName(String value) {
    if (value.trim().isEmpty) {
      return 'Meal name cannot be empty';
    }
    if (value.trim().length < 2) {
      return 'Meal name must be at least 2 characters long';
    }
    if (value.trim().length > 100) {
      return 'Meal name must be less than 100 characters';
    }
    return null;
  }

  String? _validateIngredientName(String value) {
    if (value.trim().isEmpty) {
      return 'Ingredient name cannot be empty';
    }
    if (value.trim().length < 2) {
      return 'Ingredient name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Ingredient name must be less than 50 characters';
    }
    return null;
  }

  String? _validateMacroValue(double value, String macroName) {
    if (value < 0) {
      return '$macroName cannot be negative';
    }
    if (value > 10000) {
      return '$macroName value seems too high (max 10000)';
    }
    return null;
  }

  String? _validateAmount(double value) {
    if (value < 0) {
      return 'Amount cannot be negative';
    }
    if (value > 10000) {
      return 'Amount seems too high (max 10000)';
    }
    return null;
  }

  bool _hasChanges() {
    final originalMeals = widget.mealPlan.dailyPlan;
    if (originalMeals == null) return _editedMeals.isNotEmpty;

    final originalMap = {
      'monday': originalMeals.monday ?? [],
      'tuesday': originalMeals.tuesday ?? [],
      'wednesday': originalMeals.wednesday ?? [],
      'thursday': originalMeals.thursday ?? [],
      'friday': originalMeals.friday ?? [],
      'saturday': originalMeals.saturday ?? [],
      'sunday': originalMeals.sunday ?? [],
    };

    for (String day in _editedMeals.keys) {
      final originalDayMeals = originalMap[day] ?? [];
      final editedDayMeals = _editedMeals[day] ?? [];

      if (originalDayMeals.length != editedDayMeals.length) return true;

      for (int i = 0; i < originalDayMeals.length; i++) {
        if (originalDayMeals[i].recipeName != editedDayMeals[i].recipeName ||
            originalDayMeals[i].recipe != editedDayMeals[i].recipe) {
          return true;
        }
      }
    }

    return false;
  }

  Map<String, dynamic> _getChangedFields() {
    Map<String, dynamic> changes = {};

    if (_hasChanges()) {
      // Convert the edited meals to the proper format for the API
      final dailyPlanData = <String, List<Map<String, dynamic>>>{};

      for (String dayKey in _editedMeals.keys) {
        final meals = _editedMeals[dayKey]!;
        dailyPlanData[dayKey] = meals
            .map((meal) => {
                  'name': meal.name.name,
                  'recipeName': meal.recipeName,
                  'recipe': meal.recipe,
                  'ingredients': meal.ingredients
                      .map((ingredient) => {
                            'name': ingredient.name,
                            'amount': ingredient.amount,
                            'unit': ingredient.unit,
                            'macros': {
                              'calories': ingredient.macros.calories,
                              'proteins': ingredient.macros.proteins,
                              'carbohydrates': ingredient.macros.carbohydrates,
                              'fats': ingredient.macros.fats,
                            },
                          })
                      .toList(),
                  'totalMacros': {
                    'calories': meal.totalMacros.calories,
                    'proteins': meal.totalMacros.proteins,
                    'carbohydrates': meal.totalMacros.carbohydrates,
                    'fats': meal.totalMacros.fats,
                  },
                })
            .toList();
      }

      changes['dailyPlan'] = dailyPlanData;
    }

    return changes;
  }

  Future<void> _handleSave() async {
    // Validate all meal names
    for (String day in _editedMeals.keys) {
      for (Meal meal in _editedMeals[day] ?? []) {
        final validationError = _validateMealName(meal.recipeName ?? '');
        if (validationError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$day: $validationError'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Validate ingredients
        for (int i = 0; i < meal.ingredients.length; i++) {
          final ingredient = meal.ingredients[i];

          // Validate ingredient name
          final nameError = _validateIngredientName(ingredient.name);
          if (nameError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$day - Ingredient ${i + 1}: $nameError'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Validate amount
          final amountError = _validateAmount(ingredient.amount);
          if (amountError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$day - Ingredient ${i + 1}: $amountError'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Validate macronutrients
          final caloriesError =
              _validateMacroValue(ingredient.macros.calories, 'Calories');
          if (caloriesError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$day - Ingredient ${i + 1}: $caloriesError'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          final proteinsError =
              _validateMacroValue(ingredient.macros.proteins, 'Proteins');
          if (proteinsError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$day - Ingredient ${i + 1}: $proteinsError'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          final carbsError = _validateMacroValue(
              ingredient.macros.carbohydrates, 'Carbohydrates');
          if (carbsError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$day - Ingredient ${i + 1}: $carbsError'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          final fatsError = _validateMacroValue(ingredient.macros.fats, 'Fats');
          if (fatsError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$day - Ingredient ${i + 1}: $fatsError'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        // Validate total macros
        final totalCaloriesError =
            _validateMacroValue(meal.totalMacros.calories, 'Total Calories');
        if (totalCaloriesError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$day: $totalCaloriesError'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final totalProteinsError =
            _validateMacroValue(meal.totalMacros.proteins, 'Total Proteins');
        if (totalProteinsError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$day: $totalProteinsError'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final totalCarbsError = _validateMacroValue(
            meal.totalMacros.carbohydrates, 'Total Carbohydrates');
        if (totalCarbsError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$day: $totalCarbsError'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final totalFatsError =
            _validateMacroValue(meal.totalMacros.fats, 'Total Fats');
        if (totalFatsError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$day: $totalFatsError'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    if (!_hasChanges()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final changes = _getChangedFields();
      await widget.onSave(widget.mealPlan.mealPlanId, changes);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to modify meal plan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPlanInfoSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Plan Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
                'Plan Name', widget.mealPlan.planName ?? 'Unnamed Plan'),
            _buildInfoRow('Status',
                _formatEnumValue(widget.mealPlan.status?.name ?? 'UNKNOWN')),
            const Divider(),
            const Text(
              'Tip: You can modify the meals for each day below. Click on a meal to edit its recipe name and instructions.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyPlanSection() {
    final dailyPlan = widget.mealPlan.dailyPlan;
    if (dailyPlan == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          initiallyExpanded: _isDailyPlanExpanded,
          onExpansionChanged: (expanded) =>
              setState(() => _isDailyPlanExpanded = expanded),
          leading: const Icon(Icons.restaurant_menu),
          title: const Text('Daily Plan'),
          subtitle: const Text('No meal plan data available'),
          children: const [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('No daily plan data found for this meal plan.'),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: _isDailyPlanExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _isDailyPlanExpanded = expanded),
        leading: const Icon(Icons.restaurant_menu),
        title: const Text('Daily Plan'),
        subtitle: const Text('7-day meal schedule (Editable)'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildEditableDayMeals('Monday', 'monday'),
                _buildEditableDayMeals('Tuesday', 'tuesday'),
                _buildEditableDayMeals('Wednesday', 'wednesday'),
                _buildEditableDayMeals('Thursday', 'thursday'),
                _buildEditableDayMeals('Friday', 'friday'),
                _buildEditableDayMeals('Saturday', 'saturday'),
                _buildEditableDayMeals('Sunday', 'sunday'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableDayMeals(String dayName, String dayKey) {
    final meals = _editedMeals[dayKey] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (meals.isEmpty)
            const Text('No meals planned', style: TextStyle(color: Colors.grey))
          else
            ...meals.asMap().entries.map((entry) {
              final index = entry.key;
              final meal = entry.value;
              return _buildEditableMeal(dayKey, index, meal);
            }),
        ],
      ),
    );
  }

  Widget _buildEditableMeal(String dayKey, int mealIndex, Meal meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(
          _getMealIcon(meal.name),
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          meal.recipeName ?? 'Unnamed meal',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          _formatEnumValue(meal.name.name),
          style: const TextStyle(color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Name
                TextFormField(
                  initialValue: meal.recipeName ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Recipe Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _updateMealProperty(dayKey, mealIndex, 'recipeName', value);
                  },
                ),
                const SizedBox(height: 12),

                // Recipe Instructions
                TextFormField(
                  initialValue: meal.recipe ?? '',
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Instructions',
                    border: OutlineInputBorder(),
                    hintText: 'Enter cooking instructions...',
                  ),
                  onChanged: (value) {
                    _updateMealProperty(dayKey, mealIndex, 'recipe', value);
                  },
                ),
                const SizedBox(height: 16),

                // Total Macros Section
                _buildTotalMacrosSection(dayKey, mealIndex, meal),
                const SizedBox(height: 16),

                // Ingredients Section
                _buildIngredientsSection(dayKey, mealIndex, meal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalMacrosSection(String dayKey, int mealIndex, Meal meal) {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department_rounded,
                    color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Total Nutritional Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMacroInputField(
                    'Calories (kcal)',
                    meal.totalMacros.calories,
                    (value) =>
                        _updateTotalMacro(dayKey, mealIndex, 'calories', value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMacroInputField(
                    'Proteins (g)',
                    meal.totalMacros.proteins,
                    (value) =>
                        _updateTotalMacro(dayKey, mealIndex, 'proteins', value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMacroInputField(
                    'Carbs (g)',
                    meal.totalMacros.carbohydrates,
                    (value) => _updateTotalMacro(
                        dayKey, mealIndex, 'carbohydrates', value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMacroInputField(
                    'Fats (g)',
                    meal.totalMacros.fats,
                    (value) =>
                        _updateTotalMacro(dayKey, mealIndex, 'fats', value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroInputField(
      String label, double value, Function(double) onChanged) {
    return TextFormField(
      initialValue: value.toStringAsFixed(1),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        DecimalInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (text) {
        final parsed = double.tryParse(text.replaceAll(',', '.'));
        if (parsed != null && parsed >= 0) {
          onChanged(parsed);
        }
      },
    );
  }

  Widget _buildIngredientsSection(String dayKey, int mealIndex, Meal meal) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.eco_rounded,
                    color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _addIngredient(dayKey, mealIndex),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Ingredient'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...meal.ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;
              return _buildIngredientCard(dayKey, mealIndex, index, ingredient);
            }).toList(),
            if (meal.ingredients.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No ingredients added yet',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientCard(String dayKey, int mealIndex, int ingredientIndex,
      Ingredient ingredient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: ingredient.name,
                    decoration: const InputDecoration(
                      labelText: 'Ingredient Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) => _updateIngredientProperty(
                        dayKey, mealIndex, ingredientIndex, 'name', value),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () =>
                      _removeIngredient(dayKey, mealIndex, ingredientIndex),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Remove ingredient',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: ingredient.amount.toStringAsFixed(1),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      DecimalInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value.replaceAll(',', '.'));
                      if (parsed != null && parsed >= 0) {
                        _updateIngredientProperty(dayKey, mealIndex,
                            ingredientIndex, 'amount', parsed);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: ingredient.unit ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Unit (g, ml, cup, etc.)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) => _updateIngredientProperty(
                        dayKey, mealIndex, ingredientIndex, 'unit', value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Nutritional Values (per unit)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMacroInputField(
                    'Calories',
                    ingredient.macros.calories,
                    (value) => _updateIngredientMacro(
                        dayKey, mealIndex, ingredientIndex, 'calories', value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroInputField(
                    'Proteins',
                    ingredient.macros.proteins,
                    (value) => _updateIngredientMacro(
                        dayKey, mealIndex, ingredientIndex, 'proteins', value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMacroInputField(
                    'Carbs',
                    ingredient.macros.carbohydrates,
                    (value) => _updateIngredientMacro(dayKey, mealIndex,
                        ingredientIndex, 'carbohydrates', value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroInputField(
                    'Fats',
                    ingredient.macros.fats,
                    (value) => _updateIngredientMacro(
                        dayKey, mealIndex, ingredientIndex, 'fats', value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(MealNameEnum mealType) {
    switch (mealType) {
      case MealNameEnum.BREAKFAST:
        return Icons.free_breakfast;
      case MealNameEnum.LUNCH:
        return Icons.lunch_dining;
      case MealNameEnum.DINNER:
        return Icons.dinner_dining;
      case MealNameEnum.SNACK_MORNING:
      case MealNameEnum.SNACK_AFTERNOON:
      case MealNameEnum.SNACK_EVENING:
        return Icons.local_cafe;
    }
  }

  void _updateMealProperty(
      String dayKey, int mealIndex, String property, String value) {
    setState(() {
      final meals = _editedMeals[dayKey]!;
      final meal = meals[mealIndex];

      Meal updatedMeal;
      if (property == 'recipeName') {
        updatedMeal = Meal(
          name: meal.name,
          recipeName: value,
          recipe: meal.recipe,
          ingredients: meal.ingredients,
          totalMacros: meal.totalMacros,
        );
      } else if (property == 'recipe') {
        updatedMeal = Meal(
          name: meal.name,
          recipeName: meal.recipeName,
          recipe: value,
          ingredients: meal.ingredients,
          totalMacros: meal.totalMacros,
        );
      } else {
        return;
      }

      meals[mealIndex] = updatedMeal;
    });
  }

  void _updateTotalMacro(
      String dayKey, int mealIndex, String macroType, double value) {
    setState(() {
      final meals = _editedMeals[dayKey]!;
      final meal = meals[mealIndex];

      Macros updatedMacros;
      switch (macroType) {
        case 'calories':
          updatedMacros = Macros(
            calories: value,
            proteins: meal.totalMacros.proteins,
            carbohydrates: meal.totalMacros.carbohydrates,
            fats: meal.totalMacros.fats,
          );
          break;
        case 'proteins':
          updatedMacros = Macros(
            calories: meal.totalMacros.calories,
            proteins: value,
            carbohydrates: meal.totalMacros.carbohydrates,
            fats: meal.totalMacros.fats,
          );
          break;
        case 'carbohydrates':
          updatedMacros = Macros(
            calories: meal.totalMacros.calories,
            proteins: meal.totalMacros.proteins,
            carbohydrates: value,
            fats: meal.totalMacros.fats,
          );
          break;
        case 'fats':
          updatedMacros = Macros(
            calories: meal.totalMacros.calories,
            proteins: meal.totalMacros.proteins,
            carbohydrates: meal.totalMacros.carbohydrates,
            fats: value,
          );
          break;
        default:
          return;
      }

      final updatedMeal = Meal(
        name: meal.name,
        recipeName: meal.recipeName,
        recipe: meal.recipe,
        ingredients: meal.ingredients,
        totalMacros: updatedMacros,
      );

      meals[mealIndex] = updatedMeal;
    });
  }

  void _addIngredient(String dayKey, int mealIndex) {
    setState(() {
      final meals = _editedMeals[dayKey]!;
      final meal = meals[mealIndex];

      final newIngredient = Ingredient(
        name: 'New Ingredient',
        amount: 1.0,
        unit: 'g',
        macros: Macros(
          calories: 0.0,
          proteins: 0.0,
          carbohydrates: 0.0,
          fats: 0.0,
        ),
      );

      final updatedIngredients = List<Ingredient>.from(meal.ingredients)
        ..add(newIngredient);

      final updatedMeal = Meal(
        name: meal.name,
        recipeName: meal.recipeName,
        recipe: meal.recipe,
        ingredients: updatedIngredients,
        totalMacros: meal.totalMacros,
      );

      meals[mealIndex] = updatedMeal;
    });
  }

  void _removeIngredient(String dayKey, int mealIndex, int ingredientIndex) {
    setState(() {
      final meals = _editedMeals[dayKey]!;
      final meal = meals[mealIndex];

      final updatedIngredients = List<Ingredient>.from(meal.ingredients)
        ..removeAt(ingredientIndex);

      final updatedMeal = Meal(
        name: meal.name,
        recipeName: meal.recipeName,
        recipe: meal.recipe,
        ingredients: updatedIngredients,
        totalMacros: meal.totalMacros,
      );

      meals[mealIndex] = updatedMeal;
    });
  }

  void _updateIngredientProperty(String dayKey, int mealIndex,
      int ingredientIndex, String property, dynamic value) {
    setState(() {
      final meals = _editedMeals[dayKey]!;
      final meal = meals[mealIndex];
      final ingredient = meal.ingredients[ingredientIndex];

      Ingredient updatedIngredient;
      if (property == 'name') {
        updatedIngredient = Ingredient(
          name: value,
          amount: ingredient.amount,
          unit: ingredient.unit,
          macros: ingredient.macros,
        );
      } else if (property == 'amount') {
        updatedIngredient = Ingredient(
          name: ingredient.name,
          amount: value,
          unit: ingredient.unit,
          macros: ingredient.macros,
        );
      } else if (property == 'unit') {
        updatedIngredient = Ingredient(
          name: ingredient.name,
          amount: ingredient.amount,
          unit: value,
          macros: ingredient.macros,
        );
      } else {
        return;
      }

      final updatedIngredients = List<Ingredient>.from(meal.ingredients)
        ..[ingredientIndex] = updatedIngredient;

      final updatedMeal = Meal(
        name: meal.name,
        recipeName: meal.recipeName,
        recipe: meal.recipe,
        ingredients: updatedIngredients,
        totalMacros: meal.totalMacros,
      );

      meals[mealIndex] = updatedMeal;
    });
  }

  void _updateIngredientMacro(String dayKey, int mealIndex, int ingredientIndex,
      String macroType, double value) {
    setState(() {
      final meals = _editedMeals[dayKey]!;
      final meal = meals[mealIndex];
      final ingredient = meal.ingredients[ingredientIndex];

      Macros updatedMacros;
      switch (macroType) {
        case 'calories':
          updatedMacros = Macros(
            calories: value,
            proteins: ingredient.macros.proteins,
            carbohydrates: ingredient.macros.carbohydrates,
            fats: ingredient.macros.fats,
          );
          break;
        case 'proteins':
          updatedMacros = Macros(
            calories: ingredient.macros.calories,
            proteins: value,
            carbohydrates: ingredient.macros.carbohydrates,
            fats: ingredient.macros.fats,
          );
          break;
        case 'carbohydrates':
          updatedMacros = Macros(
            calories: ingredient.macros.calories,
            proteins: ingredient.macros.proteins,
            carbohydrates: value,
            fats: ingredient.macros.fats,
          );
          break;
        case 'fats':
          updatedMacros = Macros(
            calories: ingredient.macros.calories,
            proteins: ingredient.macros.proteins,
            carbohydrates: ingredient.macros.carbohydrates,
            fats: value,
          );
          break;
        default:
          return;
      }

      final updatedIngredient = Ingredient(
        name: ingredient.name,
        amount: ingredient.amount,
        unit: ingredient.unit,
        macros: updatedMacros,
      );

      final updatedIngredients = List<Ingredient>.from(meal.ingredients)
        ..[ingredientIndex] = updatedIngredient;

      final updatedMeal = Meal(
        name: meal.name,
        recipeName: meal.recipeName,
        recipe: meal.recipe,
        ingredients: updatedIngredients,
        totalMacros: meal.totalMacros,
      );

      meals[mealIndex] = updatedMeal;
    });
  }

  Widget _buildMetadataSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: _isMetadataExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _isMetadataExpanded = expanded),
        leading: const Icon(Icons.info),
        title: const Text('Metadata'),
        subtitle: const Text('Read-only information'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('Plan ID', widget.mealPlan.mealPlanId),
                _buildInfoRow('User ID', widget.mealPlan.userId),
                _buildInfoRow('Assigned Nutritionist',
                    widget.mealPlan.assignedNutritionistId ?? 'None'),
                _buildInfoRow('Chat ID', widget.mealPlan.chatId ?? 'None'),
                _buildInfoRow(
                    'Validation Status',
                    _formatEnumValue(
                        widget.mealPlan.validationStatus?.name ?? 'UNKNOWN')),
                _buildInfoRow('Generated At',
                    _formatDateTime(widget.mealPlan.generatedAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return 'Not set';
    try {
      final dt = dateTime.getDateTime();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatEnumValue(String enumValue) {
    return enumValue
        .split('_')
        .map((word) => word.toLowerCase().replaceFirstMapped(
            RegExp(r'^.'), (match) => match.group(0)!.toUpperCase()))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_note, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Edit Meal Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPlanInfoSection(),
                    _buildDailyPlanSection(),
                    _buildMetadataSection(),
                  ],
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed:
                        _isLoading || !_hasChanges() ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
