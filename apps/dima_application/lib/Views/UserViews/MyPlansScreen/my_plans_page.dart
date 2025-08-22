import 'package:dima_application/Views/UserViews/MyPlansScreen/subscription_test_page.dart';
import 'package:dima_application/generated/flutter-models/MealPlanValidationStatus.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generate_meal_plan_page.dart';
import 'delete_confirmation_dialog.dart';
import 'modify_plan_name_dialog.dart';
import 'select_nutritionist_dialog.dart';

class MealPlanDetailsPage extends StatelessWidget {
  final String planId;

  const MealPlanDetailsPage({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan Details'),
      ),
      body: Center(
        child: Text('Details for plan: $planId\nTo be implemented'),
      ),
    );
  }
}

class MyPlansPage extends ConsumerStatefulWidget {
  const MyPlansPage({super.key});

  @override
  ConsumerState<MyPlansPage> createState() => _MyPlansPageState();
}

class _MyPlansPageState extends ConsumerState<MyPlansPage> {
  void _openGenerateMealPlan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GenerateMealPlanPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Plans are now automatically loaded by the provider on initialization
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(mealPlansProvider);
    print('[MyPlansPage] Building with state: ${plansAsync.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meal Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _openGenerateMealPlan(context);
            },
            tooltip: 'Create New Meal Plan',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(mealPlansProvider.notifier).listMyMealPlans();
            },
            tooltip: 'Refresh Plans',
          ),
          IconButton(
            icon: const Icon(Icons.repartition),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionTestPage(),
                ),
              );
            },
            tooltip: 'Test Subscription',
          ),
        ],
      ),
      body: plansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No meal plans found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You haven\'t generated any meal plans yet, or all plans have been deleted.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _openGenerateMealPlan(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Generate New Meal Plan'),
                    ),
                  ],
                ),
              ),
            );
          }
          // Get the active plan ID directly (no longer async)
          final activePlanId = ref.watch(activeMealPlanIdProvider);
          String? resolvedActivePlanId = activePlanId;
          if (resolvedActivePlanId == null && plans.isNotEmpty) {
            // Only use a plan with ACTIVE status, don't fallback to first plan
            final activeByStatus =
                plans.where((p) => p.status?.name == 'ACTIVE').firstOrNull;
            resolvedActivePlanId = activeByStatus?.mealPlanId;
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isActive = plan.mealPlanId == resolvedActivePlanId;
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                elevation: isActive ? 6.0 : 2.0,
                color: isActive
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: isActive
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  title: Text(
                    plan.planName ?? 'Unnamed Plan',
                    style: isActive
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          )
                        : null,
                  ),
                  subtitle: Text('ID: ${plan.mealPlanId}'),
                  trailing: SizedBox(
                    width: 200, // Fixed width to ensure consistent layout
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Active/Inactive indicator - same size for both
                        SizedBox(
                          width: 48,
                          child: isActive
                              ? Tooltip(
                                  message: 'Active plan',
                                  child: Icon(Icons.check_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              : Tooltip(
                                  message: 'Make this plan active',
                                  child: IconButton(
                                    icon: Icon(Icons.radio_button_unchecked),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title:
                                                const Text('Set Active Plan'),
                                            content: Text(
                                                'Do you want to make "${plan.planName ?? 'Unnamed Plan'}" your active meal plan?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(dialogContext)
                                                        .pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(dialogContext)
                                                        .pop(true),
                                                child: const Text('Set Active'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirmed == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Setting active meal plan...'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                        final success = await ref
                                            .read(mealPlansProvider.notifier)
                                            .setActiveMealPlan(plan.mealPlanId);
                                        if (!mounted) return;
                                        if (success) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Active meal plan updated!'),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Failed to set active meal plan'),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                        ),
                        // Validation button
                        SizedBox(
                          width: 48,
                          child: Builder(
                            builder: (context) {
                              final validationStatus = plan.validationStatus;

                              // Determine icon and color based on validation status
                              IconData iconData;
                              Color iconColor;
                              String tooltipText;
                              bool isValidated = false;

                              switch (validationStatus) {
                                case MealPlanValidationStatus.VALIDATED:
                                  iconData = Icons
                                      .person; // Man icon (validated - highlighted green)
                                  iconColor = Colors.green;
                                  tooltipText =
                                      'Plan validated by nutritionist';
                                  isValidated = true;
                                  break;
                                case MealPlanValidationStatus.PENDING_REVIEW:
                                  iconData = Icons
                                      .person_outline; // Man icon outline (pending)
                                  iconColor = Colors.orange;
                                  tooltipText = 'Validation in progress';
                                  break;
                                case MealPlanValidationStatus.NOT_VALIDATED:
                                case null:
                                  iconData = Icons
                                      .person_add; // Man icon for request validation
                                  iconColor =
                                      Theme.of(context).colorScheme.tertiary;
                                  tooltipText =
                                      'Request nutritionist validation';
                                  break;
                              }

                              return IconButton(
                                icon: Icon(iconData),
                                color: iconColor,
                                tooltip: tooltipText,
                                onPressed: isValidated
                                    ? null
                                    : () async {
                                        // Only allow action if not validated
                                        await showDialog<void>(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return SelectNutritionistDialog(
                                              mealPlanId: plan.mealPlanId,
                                              planName: plan.planName ??
                                                  'Unnamed Plan',
                                              onLoadNutritionists: () => ref
                                                  .read(mealPlansProvider
                                                      .notifier)
                                                  .listNutritionists(
                                                      isAvailable: true),
                                              onAssignNutritionist: (mealPlanId,
                                                      nutritionistId) =>
                                                  ref
                                                      .read(mealPlansProvider
                                                          .notifier)
                                                      .requestValidation(
                                                          mealPlanId,
                                                          nutritionistId),
                                            );
                                          },
                                        );
                                      },
                              );
                            },
                          ),
                        ),
                        // Edit button
                        SizedBox(
                          width: 48,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Theme.of(context).colorScheme.secondary,
                            tooltip: 'Edit plan name',
                            onPressed: () async {
                              await showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return ModifyPlanNameDialog(
                                    currentPlanName:
                                        plan.planName ?? 'Unnamed Plan',
                                    mealPlanId: plan.mealPlanId,
                                    onSave: (mealPlanId, newName) async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Updating plan name...'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      final success = await ref
                                          .read(mealPlansProvider.notifier)
                                          .modifyMealPlan(mealPlanId, newName);
                                      if (!mounted) return;
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Plan name updated successfully!'),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to update plan name'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // Delete button
                        SizedBox(
                          width: 48,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).colorScheme.error,
                            tooltip: 'Delete plan',
                            onPressed: () async {
                              await showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return DeleteConfirmationDialog(
                                    title: 'Delete Meal Plan',
                                    content:
                                        'Are you sure you want to delete the plan "${plan.planName ?? 'Unnamed Plan'}"?',
                                    onConfirm: () async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Deleting meal plan...'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      final success = await ref
                                          .read(mealPlansProvider.notifier)
                                          .deleteMealPlan(plan.mealPlanId);
                                      if (!mounted) return;
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Meal plan deleted successfully'),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to delete meal plan'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
