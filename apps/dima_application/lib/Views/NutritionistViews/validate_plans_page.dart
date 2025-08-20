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
        return _ModifyPlanNameDialog(
          currentPlanName: plan.planName ?? 'Unnamed Plan',
          mealPlanId: plan.mealPlanId,
          onSave: (mealPlanId, newName) async {
            await _modifyMealPlan(plan, newName);
          },
        );
      },
    );
  }

  Future<void> _modifyMealPlan(MealPlan plan, String newName) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modifying meal plan...')),
    );

    try {
      // Use the nutritionist-specific method with proper authorization
      final success = await ref
          .read(mealPlansProvider.notifier)
          .modifyAssignedMealPlan(plan.mealPlanId, plan.userId, newName);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Meal plan "$newName" modified successfully!\nValidation status reset to pending review.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: plan.validationStatus ==
                            MealPlanValidationStatus.PENDING_REVIEW
                        ? () => _validateMealPlan(plan, 'VALIDATED')
                        : null,
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Validate',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: plan.validationStatus ==
                            MealPlanValidationStatus.PENDING_REVIEW
                        ? () => _validateMealPlan(plan, 'NOT_VALIDATED')
                        : null,
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text('Reject',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: plan.validationStatus ==
                        MealPlanValidationStatus.PENDING_REVIEW
                    ? () => _showModifyPlanDialog(plan)
                    : null,
                icon: const Icon(Icons.edit_note),
                label: const Text('Modify Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                ),
              ),
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

class _ModifyPlanNameDialog extends StatefulWidget {
  final String currentPlanName;
  final String mealPlanId;
  final Function(String, String) onSave;

  const _ModifyPlanNameDialog({
    required this.currentPlanName,
    required this.mealPlanId,
    required this.onSave,
  });

  @override
  State<_ModifyPlanNameDialog> createState() => _ModifyPlanNameDialogState();
}

class _ModifyPlanNameDialogState extends State<_ModifyPlanNameDialog> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPlanName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateInput(String value) {
    if (value.trim().isEmpty) {
      return 'Plan name cannot be empty';
    }
    if (value.trim().length < 2) {
      return 'Plan name must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return 'Plan name must be less than 50 characters';
    }
    return null;
  }

  Future<void> _handleSave() async {
    final newName = _controller.text.trim();
    final validationError = _validateInput(newName);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newName == widget.currentPlanName) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSave(widget.mealPlanId, newName);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to modify plan: $e'),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modify Plan Name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              hintText: 'Enter new plan name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Clear any previous validation errors
              setState(() {});
            },
          ),
          if (_controller.text.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _validateInput(_controller.text.trim()) ?? 'Valid name',
                style: TextStyle(
                  color: _validateInput(_controller.text.trim()) != null
                      ? Colors.red
                      : Colors.green,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
