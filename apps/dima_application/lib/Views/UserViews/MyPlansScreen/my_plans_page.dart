import 'package:dima_application/Views/UserViews/generate_meal_plan_page.dart';
import 'package:dima_application/Views/components/delete_confirmation_dialog.dart';
import 'package:dima_application/Views/components/edit_plan_name_dialog.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/providers/today_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyPlansPage extends ConsumerWidget {
  const MyPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealPlansState = ref.watch(mealPlansProvider);
    final plans = mealPlansState.plans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meal Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(mealPlansProvider.notifier).loadPlans(),
            tooltip: 'Refresh Plans',
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          switch (mealPlansState.status) {
            case DataStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case DataStatus.errorNetwork:
            case DataStatus.errorOther:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    mealPlansState.errorMessage ?? 'An unknown error occurred.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              );
            case DataStatus.loadedOnline:
            case DataStatus.initial: // Also handle initial state
              if (plans == null || plans.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You haven\'t generated any meal plans yet.\nTap the "+" button to create your first one!',
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
                  final isCurrent =
                      plan.mealPlanId == mealPlansState.activePlanId;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    elevation: isCurrent ? 6.0 : 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: isCurrent
                          ? BorderSide(
                              color: Theme.of(context).primaryColor, width: 2)
                          : BorderSide.none,
                    ),
                    child: ListTile(
                      title: Text(
                        plan.planName ?? 'Unnamed Plan',
                        style: TextStyle(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                          'Generated on ${DateFormat.yMMMd().format(plan.generatedAt!.getDateTimeInUtc().toLocal())}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (isCurrent)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: Theme.of(context).indicatorColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit plan name',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return EditPlanNameDialog(
                                    currentPlanName: plan.planName ?? '',
                                    onSave: (newName) {
                                      ref
                                          .read(mealPlansProvider.notifier)
                                          .updatePlanName(
                                              plan.mealPlanId, newName);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).colorScheme.error,
                            tooltip: 'Delete plan',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return DeleteConfirmationDialog(
                                    title: 'Delete Meal Plan',
                                    content:
                                        'Are you sure you want to delete the plan "${plan.planName ?? 'Unnamed Plan'}"?',
                                    onConfirm: () {
                                      ref
                                          .read(mealPlansProvider.notifier)
                                          .deletePlan(plan.mealPlanId);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        if (!isCurrent) {
                          ref
                              .read(mealPlansProvider.notifier)
                              .setActivePlan(plan.mealPlanId);
                        }
                      },
                    ),
                  );
                },
              );
            default:
              return const Center(child: Text("Unhandled state"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GenerateMealPlanPage()),
          );
        },
        tooltip: 'Generate new meal plan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
