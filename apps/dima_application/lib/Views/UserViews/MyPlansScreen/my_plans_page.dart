import 'package:dima_application/Views/UserViews/generate_meal_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// region: Mock Provider and Data
// This section contains mock data and providers for demonstration purposes.
// It should be replaced with actual data providers when ready.

enum DataStatus {
  initial,
  loading,
  loadedOnline,
  loadedOffline,
  errorNetwork,
  errorOther
}

// Mock AmplifyDateTime for demonstration purposes
class MockAmplifyDateTime {
  final DateTime _dateTime;

  MockAmplifyDateTime.now() : _dateTime = DateTime.now();
  MockAmplifyDateTime(this._dateTime);

  DateTime getDateTimeInUtc() {
    return _dateTime.toUtc();
  }

  @override
  String toString() => _dateTime.toIso8601String();
}

// Mock MealPlan for demonstration purposes
class MealPlan {
  final String mealPlanId;
  String? planName;
  final MockAmplifyDateTime? generatedAt;

  MealPlan({
    required this.mealPlanId,
    this.planName,
    this.generatedAt,
  });
}

// Mock MealPlansState for demonstration purposes
class MealPlansState {
  final DataStatus status;
  final List<MealPlan>? plans;
  final String? activePlanId;
  final String? errorMessage;

  const MealPlansState({
    this.status = DataStatus.initial,
    this.plans,
    this.activePlanId,
    this.errorMessage,
  });

  MealPlansState copyWith({
    DataStatus? status,
    List<MealPlan>? plans,
    String? activePlanId,
    String? errorMessage,
  }) {
    return MealPlansState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      activePlanId: activePlanId ?? this.activePlanId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Mock MealPlansNotifier for demonstration purposes
class MealPlansNotifier extends StateNotifier<MealPlansState> {
  MealPlansNotifier() : super(const MealPlansState()) {
    loadPlans();
  }

  final List<MealPlan> _mockPlans = [
    MealPlan(
      mealPlanId: 'plan1',
      planName: 'My First Plan',
      generatedAt:
          MockAmplifyDateTime(DateTime.now().subtract(const Duration(days: 5))),
    ),
    MealPlan(
      mealPlanId: 'plan2',
      planName: 'Bulk-up Plan',
      generatedAt:
          MockAmplifyDateTime(DateTime.now().subtract(const Duration(days: 2))),
    ),
    MealPlan(
      mealPlanId: 'plan3',
      planName: 'Cutting Season',
      generatedAt: MockAmplifyDateTime(DateTime.now()),
    ),
  ];

  Future<void> loadPlans() async {
    state = state.copyWith(status: DataStatus.loading);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    state = state.copyWith(
      status: DataStatus.loadedOnline,
      plans: _mockPlans,
      activePlanId: 'plan2', // Let's make the second one active
    );
  }

  void setActivePlan(String planId) {
    state = state.copyWith(activePlanId: planId);
    // ignore: avoid_print
    print('Active plan set to: $planId');
  }

  void updatePlanName(String planId, String newName) {
    final planIndex = _mockPlans.indexWhere((p) => p.mealPlanId == planId);
    if (planIndex != -1) {
      _mockPlans[planIndex].planName = newName;
      state = state.copyWith(plans: List.from(_mockPlans));
      // ignore: avoid_print
      print('Plan $planId name updated to: $newName');
    }
  }

  void deletePlan(String planId) {
    _mockPlans.removeWhere((p) => p.mealPlanId == planId);
    state = state.copyWith(plans: List.from(_mockPlans));
    // ignore: avoid_print
    print('Plan $planId deleted.');
  }
}

/// Mock provider that will be replaced by the actual Riverpod provider.
final mealPlansProvider =
    StateNotifierProvider<MealPlansNotifier, MealPlansState>((ref) {
  return MealPlansNotifier();
});

// endregion

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
            case DataStatus.loadedOffline:
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
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (!isCurrent)
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              tooltip: 'Make this plan active',
                              onPressed: () {
                                ref
                                    .read(mealPlansProvider.notifier)
                                    .setActivePlan(plan.mealPlanId);
                              },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MealPlanDetailsPage(planId: plan.mealPlanId),
                          ),
                        );
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
