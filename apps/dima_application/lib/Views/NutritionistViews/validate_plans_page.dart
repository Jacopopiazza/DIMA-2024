import 'package:dima_application/Views/NutritionistViews/modify_plan_name_dialog.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Fix NutritionistView file structure and move this to the correct folder

class ValidatePlansPage extends ConsumerStatefulWidget {
  const ValidatePlansPage({super.key});

  @override
  ConsumerState<ValidatePlansPage> createState() => _ValidatePlansPageState();
}

class _ValidatePlansPageState extends ConsumerState<ValidatePlansPage> {
  List<MealPlan> _assignedMealPlans = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAssignedMealPlans();
  }

  Future<void> _loadAssignedMealPlans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final plans =
          await ref.read(mealPlansProvider.notifier).listMyAssignedMealPlans();
      setState(() {
        _assignedMealPlans = plans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading assigned meal plans: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _validateMealPlan(MealPlan plan, String validationStatus) async {
    try {
      final success =
          await ref.read(mealPlansProvider.notifier).validateMealPlan(
                plan.mealPlanId,
                plan.assignedNutritionistId ?? '',
                validationStatus,
              );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Meal plan ${validationStatus.toLowerCase()} successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload the list to reflect changes
        await _loadAssignedMealPlans();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to validate meal plan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error validating meal plan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showModifyPlanDialog(MealPlan plan) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ModifyMealPlanDialog(
          mealPlan: plan,
          onSave: (mealPlanId, changes) async {
            await _modifyMealPlan(plan, changes);
          },
        );
      },
    );
  }

  Future<void> _modifyMealPlan(
      MealPlan plan, Map<String, dynamic> changes) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modifying meal plan...')),
    );

    try {
      bool success = false;
      String changesDescription = '';

      // Build the input object for the API
      Map<String, dynamic> input = {};

      // Handle plan name changes
      if (changes.containsKey('planName')) {
        final newName = changes['planName'] as String;
        input['planName'] = newName;
        changesDescription = 'Plan name changed to "$newName"';
      }

      // Handle meal plan changes (dailyPlan)
      if (changes.containsKey('dailyPlan')) {
        input['dailyPlan'] = changes['dailyPlan'];
        changesDescription += changesDescription.isEmpty
            ? 'Meal plan updated'
            : '\nMeal plan updated';
      }

      // Only make API call if there are actual changes to apply
      if (input.isNotEmpty) {
        success = await ref
            .read(mealPlansProvider.notifier)
            .modifyAssignedMealPlan(plan.mealPlanId, plan.userId, input);
      }

      // Note: Status changes would require additional API endpoints
      if (changes.containsKey('status')) {
        changesDescription += changesDescription.isEmpty
            ? 'Status modification attempted (not yet supported by API)'
            : '\nNote: Status modification is not yet supported by the API';
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Meal plan modified successfully!\n$changesDescription\nValidation status reset to pending review.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );

          // Reload the list to reflect changes
          await _loadAssignedMealPlans();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed to modify meal plan. You may not be authorized to modify this plan.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error modifying meal plan: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildValidationStatusChip(MealPlanValidationStatus? status) {
    Color color;
    String text;

    switch (status) {
      case MealPlanValidationStatus.PENDING_REVIEW:
        color = Colors.orange;
        text = 'Pending Review';
        break;
      case MealPlanValidationStatus.VALIDATED:
        color = Colors.green;
        text = 'Validated';
        break;
      case MealPlanValidationStatus.NOT_VALIDATED:
        color = Colors.grey;
        text = 'Not Validated';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Chip(
      label: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildMealPlanCard(MealPlan plan) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.planName ?? 'Unnamed Plan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildValidationStatusChip(plan.validationStatus),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: plan.validationStatus ==
                            MealPlanValidationStatus.PENDING_REVIEW
                        ? () => _validateMealPlan(plan, 'VALIDATED')
                        : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Validate'),
                    style: ElevatedButton.styleFrom(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: plan.validationStatus ==
                            MealPlanValidationStatus.PENDING_REVIEW
                        ? () => _showModifyPlanDialog(plan)
                        : null,
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Modify'),
                    style: ElevatedButton.styleFrom(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssignedMealPlans,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
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
                        _errorMessage!,
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAssignedMealPlans,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _assignedMealPlans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No meal plans assigned for validation',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Meal plans will appear here when users request validation',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadAssignedMealPlans,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _assignedMealPlans.length,
                        itemBuilder: (context, index) {
                          return _buildMealPlanCard(_assignedMealPlans[index]);
                        },
                      ),
                    ),
    );
  }
}
