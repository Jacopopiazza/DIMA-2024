import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      changes['dailyPlan'] = _editedMeals;
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
                const SizedBox(height: 12),
                ExpansionTile(
                  title: const Text('Nutritional Information'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          _buildMacroInfo('Calories',
                              '${meal.totalMacros.calories.toStringAsFixed(0)} kcal'),
                          _buildMacroInfo('Protein',
                              '${meal.totalMacros.proteins.toStringAsFixed(1)}g'),
                          _buildMacroInfo('Carbs',
                              '${meal.totalMacros.carbohydrates.toStringAsFixed(1)}g'),
                          _buildMacroInfo('Fat',
                              '${meal.totalMacros.fats.toStringAsFixed(1)}g'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
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
