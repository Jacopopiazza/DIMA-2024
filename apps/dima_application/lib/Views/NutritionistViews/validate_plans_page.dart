import 'package:dima_application/Views/Common/offline_screen.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/validation_empty_state.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/validation_error_state.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/validation_meal_plan_card.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/services/connectivity_service.dart';
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
      // Check connectivity first
      final connectivityService = ConnectivityService();
      final isConnected = await connectivityService.checkConnectivityManually();

      if (!isConnected) {
        if (mounted) {
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.noInternetConnectionValidation;
            _isLoading = false;
          });
        }
        return;
      }

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
          _errorMessage = AppLocalizations.of(context)!.errorLoadingAssignedPlans(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.loadingMealPlansValidation,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineScreen(
      child: Scaffold(
        body: _isLoading
            ? _buildLoadingState(context)
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: _assignedMealPlans.length,
                          itemBuilder: (context, index) {
                            final plan = _assignedMealPlans[index];
                            return ValidationMealPlanCard(
                              plan: plan,
                              onRefresh: _loadAssignedMealPlans,
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
