import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'delete_confirmation_dialog.dart';

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
  @override
  void initState() {
    super.initState();
    // Load plans on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlansProvider.notifier).listMyMealPlans();
    });
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(mealPlansProvider.notifier).listMyMealPlans();
            },
            tooltip: 'Refresh Plans',
          )
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
                        // Navigate to meal plan generation page
                        Navigator.pushNamed(context,
                            '/generate-meal-plan'); // TODO: Implement meal plan generation page
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Meal Plan'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text(plan.planName ?? 'Unnamed Plan'),
                  subtitle: Text('ID: ${plan.mealPlanId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Deleting meal plan...'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                  final success = await ref
                                      .read(mealPlansProvider.notifier)
                                      .deleteMealPlan(plan.mealPlanId);
                                  if (!mounted) return;
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Meal plan deleted successfully'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Failed to delete meal plan'),
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
                    ],
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
