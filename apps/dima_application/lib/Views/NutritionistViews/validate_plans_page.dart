import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
