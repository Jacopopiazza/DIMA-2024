import 'package:dima_application/Utils/localization_helpers.dart';
import 'package:dima_application/Views/UserViews/MyPlansScreen/modify_plan_name_dialog.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// A read-only view for meal plans similar to the nutritionist interface
/// but without edit capabilities (except for plan name)
class ReadMealPlanPage extends ConsumerStatefulWidget {
  final String mealPlanId;
  final String? initialPlanName;

  const ReadMealPlanPage({
    super.key,
    required this.mealPlanId,
    this.initialPlanName,
  });

  @override
  ConsumerState<ReadMealPlanPage> createState() => _ReadMealPlanPageState();
}

class _ReadMealPlanPageState extends ConsumerState<ReadMealPlanPage> {
  bool _isLoading = true;
  bool _isDailyPlanExpanded = true;
  bool _isMetadataExpanded = false;
  MealPlan? _mealPlan;
  String? _errorMessage;
  late final MealPlansService _mealPlansService;

  @override
  void initState() {
    super.initState();
    _mealPlansService = MealPlansService();
    _loadMealPlan();
  }

  Future<void> _loadMealPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final mealPlan =
          await _mealPlansService.getMealPlanById(widget.mealPlanId);

      if (mounted) {
        setState(() {
          _mealPlan = mealPlan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load meal plan: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_mealPlan?.planName ?? widget.initialPlanName ?? 'Meal Plan'),
        actions: [
          if (_mealPlan != null)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit plan name',
              onPressed: () => _showEditNameDialog(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadMealPlan,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Error Loading Meal Plan',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadMealPlan,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_mealPlan == null) {
      return const Center(
        child: Text('Meal plan not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetadataSection(),
          const SizedBox(height: 16),
          _buildDailyPlanSection(),
        ],
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: _isMetadataExpanded,
        onExpansionChanged: (expanded) =>
            setState(() => _isMetadataExpanded = expanded),
        leading: const Icon(Icons.info_outline),
        title: const Text('Plan Information'),
        subtitle: const Text('View plan details'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    'Plan Name', _mealPlan!.planName ?? 'Unnamed Plan'),
                _buildInfoRow('Plan ID', _mealPlan!.mealPlanId),
                if (_mealPlan!.generatedAt != null)
                  _buildInfoRow(
                    'Generated',
                    DateFormat('MMM dd, yyyy HH:mm').format(
                      _mealPlan!.generatedAt!.getDateTimeInUtc().toLocal(),
                    ),
                  ),
                _buildInfoRow('Status',
                    _formatEnumValue(_mealPlan!.status?.name ?? 'UNKNOWN')),
                _buildInfoRow(
                    'Validation',
                    _formatEnumValue(
                        _mealPlan!.validationStatus?.name ?? 'NOT_VALIDATED')),
                if (_mealPlan!.assignedNutritionistId != null)
                  _buildInfoRow(
                      'Nutritionist ID', _mealPlan!.assignedNutritionistId!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPlanSection() {
    final dailyPlan = _mealPlan!.dailyPlan;
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
        title: const Text('Weekly Meal Plan'),
        subtitle: const Text('7-day meal schedule (Read-only)'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildReadOnlyDayMeals('Monday', dailyPlan.monday),
                _buildReadOnlyDayMeals('Tuesday', dailyPlan.tuesday),
                _buildReadOnlyDayMeals('Wednesday', dailyPlan.wednesday),
                _buildReadOnlyDayMeals('Thursday', dailyPlan.thursday),
                _buildReadOnlyDayMeals('Friday', dailyPlan.friday),
                _buildReadOnlyDayMeals('Saturday', dailyPlan.saturday),
                _buildReadOnlyDayMeals('Sunday', dailyPlan.sunday),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyDayMeals(String dayName, List<Meal>? meals) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${meals?.length ?? 0} meals',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (meals == null || meals.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No meals scheduled for this day',
                style:
                    TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            )
          else
            ...meals
                .asMap()
                .entries
                .map((entry) => _buildReadOnlyMeal(entry.value)),
        ],
      ),
    );
  }

  Widget _buildReadOnlyMeal(Meal meal) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          localizeMealName(context, meal.name),
          style: const TextStyle(color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal.recipeName != null && meal.recipeName!.isNotEmpty) ...[
                  const Text(
                    'Recipe Name:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(meal.recipeName!),
                  const SizedBox(height: 12),
                ],
                if (meal.recipe != null && meal.recipe!.isNotEmpty) ...[
                  const Text(
                    'Instructions:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.recipe!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],
                const Text(
                  'Nutrition Information:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _buildNutritionInfo(meal.totalMacros),
                const SizedBox(height: 12),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...meal.ingredients
                    .map((ingredient) => _buildIngredientRow(ingredient)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(Macros macros) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem('Calories', '${macros.calories.round()}', 'kcal'),
          _buildNutritionItem(
              'Protein', '${macros.proteins.toStringAsFixed(1)}', 'g'),
          _buildNutritionItem(
              'Carbs', '${macros.carbohydrates.toStringAsFixed(1)}', 'g'),
          _buildNutritionItem('Fat', '${macros.fats.toStringAsFixed(1)}', 'g'),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildIngredientRow(Ingredient ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(ingredient.name),
          ),
          Text(
            '${ingredient.amount.toStringAsFixed(1)} ${ingredient.unit ?? 'g'}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditNameDialog() async {
    if (_mealPlan == null) return;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ModifyPlanNameDialog(
          currentPlanName: _mealPlan!.planName ?? 'Unnamed Plan',
          mealPlanId: _mealPlan!.mealPlanId,
          onSave: (mealPlanId, newName) async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Updating plan name...'),
                duration: Duration(seconds: 1),
              ),
            );
            final success = await ref
                .read(mealPlansProvider.notifier)
                .modifyMealPlan(mealPlanId, newName);
            if (!mounted) return;
            if (success) {
              // Reload the meal plan to get the updated name
              await _loadMealPlan();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Plan name updated successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update plan name'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
        );
      },
    );
  }

  IconData _getMealIcon(MealNameEnum mealName) {
    switch (mealName) {
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

  String _formatEnumValue(String enumValue) {
    return enumValue
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
