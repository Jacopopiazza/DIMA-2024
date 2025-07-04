import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// region: Dummy Dialog Widgets
// These are placeholder dialogs to allow the UI to compile.
// They should be replaced with the actual dialog widgets.

// Dummy EditPlanNameDialog
class EditPlanNameDialog extends StatefulWidget {
  final String currentPlanName;
  final Function(String) onSave;

  const EditPlanNameDialog(
      {super.key, required this.currentPlanName, required this.onSave});

  @override
  State<EditPlanNameDialog> createState() => _EditPlanNameDialogState();
}

class _EditPlanNameDialogState extends State<EditPlanNameDialog> {
  late TextEditingController _controller;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Plan Name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter new plan name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Dummy DeleteConfirmationDialog
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
// endregion

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

class MyPlansPage extends ConsumerWidget {
  const MyPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(mealPlansProvider);

    Future<void> loadPlans() async {
      await ref.read(mealPlansProvider.notifier).listMyMealPlans();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meal Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadPlans,
            tooltip: 'Refresh Plans',
          )
        ],
      ),
      body: plansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You haven\'t generated any meal plans yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  title: Text(plan.planName),
                  subtitle: Text('ID: ${plan.mealPlanId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                        tooltip: 'Delete plan',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Delete Meal Plan'),
                                content: Text(
                                    'Are you sure you want to delete the plan "${plan.planName}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await ref
                                          .read(mealPlansProvider.notifier)
                                          .deletePlan(plan.mealPlanId);
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
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
