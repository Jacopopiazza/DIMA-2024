import 'package:dima_application/Views/NutritionistViews/modify_plan_name_dialog.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/validation_empty_state.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/validation_error_state.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/validation_meal_plan_card.dart';
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

  @override
  void dispose() {
    // Cancel any ongoing operations here if needed
    super.dispose();
  }

  Future<void> _loadAssignedMealPlans() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final plans =
          await ref.read(mealPlansProvider.notifier).listMyAssignedMealPlans();
      if (mounted) {
        setState(() {
          _assignedMealPlans = plans;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading assigned meal plans: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _validateMealPlan(MealPlan plan) async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Validate Meal Plan'),
          content: Text(
            'Are you sure you want to validate "${plan.planName ?? 'Unnamed Plan'}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Validate'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validating meal plan...'),
          duration: Duration(seconds: 1),
        ),
      );

      final success =
          await ref.read(mealPlansProvider.notifier).validateMealPlan(
                plan.mealPlanId,
                plan.assignedNutritionistId ?? '',
                'VALIDATED',
              );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal plan validated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Reload the list to reflect changes
          await _loadAssignedMealPlans();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to validate meal plan'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error validating meal plan: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _rejectMealPlan(MealPlan plan) async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              const Text('Reject Meal Plan'),
            ],
          ),
          content: Text(
            'Are you sure you want to reject "${plan.planName ?? 'Unnamed Plan'}"? This action will reset the plan to not validated status.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rejecting meal plan...'),
          duration: Duration(seconds: 1),
        ),
      );

      final success =
          await ref.read(mealPlansProvider.notifier).validateMealPlan(
                plan.mealPlanId,
                plan.assignedNutritionistId ?? '',
                'NOT_VALIDATED',
              );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal plan rejected'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
          // Reload the list to reflect changes
          await _loadAssignedMealPlans();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to reject meal plan'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error rejecting meal plan: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showModifyPlanDialog(MealPlan plan) async {
    if (!mounted) return;

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
    if (!mounted) return;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Meal Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssignedMealPlans,
            tooltip: 'Refresh Plans',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? ValidationErrorState(
                  errorMessage: _errorMessage!,
                  onRetry: _loadAssignedMealPlans,
                )
              : _assignedMealPlans.isEmpty
                  ? ValidationEmptyState(
                      onRefresh: _loadAssignedMealPlans,
                    )
                  : RefreshIndicator(
                      displacement: 60.0,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      onRefresh: _loadAssignedMealPlans,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        itemCount: _assignedMealPlans.length,
                        itemBuilder: (context, index) {
                          final plan = _assignedMealPlans[index];
                          return ValidationMealPlanCard(
                            plan: plan,
                            onValidate: () => _validateMealPlan(plan),
                            onModify: () => _showModifyPlanDialog(plan),
                            onReject: () => _rejectMealPlan(plan),
                            onRefresh: _loadAssignedMealPlans,
                          );
                        },
                      ),
                    ),
    );
  }
}
