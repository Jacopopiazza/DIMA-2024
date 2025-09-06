import 'package:dima_application/Utils/localization_helpers.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/services/client_details_service.dart';
import 'package:dima_application/Views/Common/ChatScreen/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// A modern nutritionist view for meal plans with editing capabilities
class NutritionistReadMealPlanPage extends ConsumerStatefulWidget {
  final MealPlan mealPlan;

  const NutritionistReadMealPlanPage({
    super.key,
    required this.mealPlan,
  });

  @override
  ConsumerState<NutritionistReadMealPlanPage> createState() =>
      _NutritionistReadMealPlanPageState();
}

class _NutritionistReadMealPlanPageState
    extends ConsumerState<NutritionistReadMealPlanPage>
    with TickerProviderStateMixin {
  bool _isDailyPlanExpanded = true;
  bool _isMetadataExpanded = false;
  bool _isClientDetailsExpanded = false;
  bool _isEditing = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Editing state
  Map<String, List<Meal>> _editedMeals = {};
  final Map<String, Map<int, TextEditingController>> _recipeNameControllers =
      {};
  final Map<String, Map<int, TextEditingController>> _recipeControllers = {};

  // Client details state
  final ClientDetailsService _clientDetailsService = ClientDetailsService();
  UserDetails? _clientDetails;
  bool _isLoadingClientDetails = false;
  String? _clientDetailsError;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _initializeEditingState();
    _loadClientDetails();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final dayControllers in _recipeNameControllers.values) {
      for (final controller in dayControllers.values) {
        controller.dispose();
      }
    }
    for (final dayControllers in _recipeControllers.values) {
      for (final controller in dayControllers.values) {
        controller.dispose();
      }
    }
    _recipeNameControllers.clear();
    _recipeControllers.clear();
  }

  void _initializeEditingState() {
    if (widget.mealPlan.dailyPlan != null) {
      final dailyPlan = widget.mealPlan.dailyPlan!;
      _editedMeals = {
        'monday': List<Meal>.from(dailyPlan.monday ?? []),
        'tuesday': List<Meal>.from(dailyPlan.tuesday ?? []),
        'wednesday': List<Meal>.from(dailyPlan.wednesday ?? []),
        'thursday': List<Meal>.from(dailyPlan.thursday ?? []),
        'friday': List<Meal>.from(dailyPlan.friday ?? []),
        'saturday': List<Meal>.from(dailyPlan.saturday ?? []),
        'sunday': List<Meal>.from(dailyPlan.sunday ?? []),
      };

      // Initialize controllers
      _disposeControllers();
      for (final entry in _editedMeals.entries) {
        final dayKey = entry.key;
        final meals = entry.value;
        _recipeNameControllers[dayKey] = {};
        _recipeControllers[dayKey] = {};

        for (int i = 0; i < meals.length; i++) {
          _recipeNameControllers[dayKey]![i] =
              TextEditingController(text: meals[i].recipeName ?? '');
          _recipeControllers[dayKey]![i] =
              TextEditingController(text: meals[i].recipe ?? '');
        }
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  /// Load client details for the meal plan owner
  Future<void> _loadClientDetails() async {
    if (!mounted) return;

    setState(() {
      _isLoadingClientDetails = true;
      _clientDetailsError = null;
    });

    try {
      final clientDetails =
          await _clientDetailsService.getClientDetails(widget.mealPlan.userId);
      if (mounted) {
        setState(() {
          _clientDetails = clientDetails;
          _isLoadingClientDetails = false;
          _clientDetailsError =
              clientDetails == null ? 'Unable to load client details' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingClientDetails = false;
          _clientDetailsError = 'Error loading client details: $e';
        });
      }
    }
  }

  Future<void> _validateMealPlan() async {
    final confirmed = await _showConfirmationDialog(
      'Validate Meal Plan',
      'Are you sure you want to validate "${widget.mealPlan.planName ?? 'Unnamed Plan'}"?',
      'Validate',
      Colors.green,
    );

    if (confirmed != true) return;

    try {
      final success =
          await ref.read(mealPlansProvider.notifier).validateMealPlan(
                widget.mealPlan.mealPlanId,
                widget.mealPlan.assignedNutritionistId ?? '',
                MealPlanValidationStatus.VALIDATED,
              );

      if (mounted) {
        if (success) {
          _showSnackBar('Meal plan validated successfully!', Colors.green);
          Navigator.of(context)
              .pop(true); // Return true to indicate changes were made
        } else {
          _showSnackBar('Failed to validate meal plan', Colors.red);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error validating meal plan: $e', Colors.red);
      }
    }
  }

  Future<void> _rejectMealPlan() async {
    final confirmed = await _showConfirmationDialog(
      'Reject Meal Plan',
      'Are you sure you want to reject "${widget.mealPlan.planName ?? 'Unnamed Plan'}"? This will reset the plan to not validated status.',
      'Reject',
      Colors.red,
    );

    if (confirmed != true) return;

    try {
      final success =
          await ref.read(mealPlansProvider.notifier).validateMealPlan(
                widget.mealPlan.mealPlanId,
                widget.mealPlan.assignedNutritionistId ?? '',
                MealPlanValidationStatus.REJECTED,
              );

      if (mounted) {
        if (success) {
          _showSnackBar('Meal plan rejected', Colors.orange);
          Navigator.of(context)
              .pop(true); // Return true to indicate changes were made
        } else {
          _showSnackBar('Failed to reject meal plan', Colors.red);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error rejecting meal plan: $e', Colors.red);
      }
    }
  }

  Future<void> _saveMealPlan() async {
    try {
      _showSnackBar('Saving meal plan...', Colors.blue);

      // Update meals from controllers
      for (final entry in _editedMeals.entries) {
        final dayKey = entry.key;
        final meals = entry.value;

        for (int i = 0; i < meals.length; i++) {
          final nameController = _recipeNameControllers[dayKey]?[i];
          final recipeController = _recipeControllers[dayKey]?[i];

          if (nameController != null && recipeController != null) {
            meals[i] = Meal(
              name: meals[i].name,
              recipeName: nameController.text,
              recipe: recipeController.text,
              ingredients: meals[i].ingredients,
              totalMacros: meals[i].totalMacros,
            );
          }
        }
      }

      final success =
          await ref.read(mealPlansProvider.notifier).modifyAssignedMealPlan(
        widget.mealPlan.mealPlanId,
        widget.mealPlan.userId,
        {'dailyPlan': _editedMeals},
      );

      if (mounted) {
        if (success) {
          _showSnackBar('Meal plan saved successfully!', Colors.green);
          setState(() {
            _isEditing = false;
          });
          Navigator.of(context)
              .pop(true); // Return true to indicate changes were made
        } else {
          _showSnackBar('Failed to save meal plan', Colors.red);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error saving meal plan: $e', Colors.red);
      }
    }
  }

  Future<bool?> _showConfirmationDialog(
      String title, String content, String actionText, Color actionColor) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: actionColor),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
              ),
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _buildBody(theme, colorScheme),
          ),
          // Modern back button positioned on top
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Action buttons positioned on top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: _buildActionButtons(colorScheme),
          ),
        ],
      ),
      // Chat button - always shown for nutritionists
      floatingActionButton: _buildChatButton(colorScheme),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit/Save button - only show when plan is in pending review
        if (widget.mealPlan.validationStatus ==
            MealPlanValidationStatus.PENDING_REVIEW)
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isEditing ? _saveMealPlan : _toggleEditMode,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    _isEditing ? Icons.save_rounded : Icons.edit_rounded,
                    color: _isEditing ? Colors.green : colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        if (_isEditing &&
            widget.mealPlan.validationStatus ==
                MealPlanValidationStatus.PENDING_REVIEW) ...[
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isEditing = false;
                  });
                  _initializeEditingState(); // Reset to original values
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.close_rounded,
                    color: colorScheme.error,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
        if (!_isEditing &&
            widget.mealPlan.validationStatus ==
                MealPlanValidationStatus.PENDING_REVIEW) ...[
          const SizedBox(width: 8),
          // Validate button
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _validateMealPlan,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Reject button
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _rejectMealPlan,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBody(ThemeData theme, ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetadataSection(theme, colorScheme),
            const SizedBox(height: 16),
            _buildClientDetailsSection(theme, colorScheme),
            const SizedBox(height: 16),
            _buildDailyPlanSection(theme, colorScheme),
            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildClientDetailsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: _isClientDetailsExpanded,
          onExpansionChanged: (expanded) =>
              setState(() => _isClientDetailsExpanded = expanded),
          leading: Icon(
            Icons.person_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
          title: Text(
            'Client Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: _isLoadingClientDetails
              ? Text(
                  'Loading client information...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : _clientDetailsError != null
                  ? Text(
                      _clientDetailsError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    )
                  : _clientDetails != null
                      ? Text(
                          'Health profile and preferences',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Text(
                          'No client details available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
          children: [
            if (_isLoadingClientDetails)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                        strokeWidth: 2,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Loading client details...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_clientDetailsError != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _clientDetailsError!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _loadClientDetails,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (_clientDetails != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClientDetailsContent(theme, colorScheme),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No client details available',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientDetailsContent(ThemeData theme, ColorScheme colorScheme) {
    if (_clientDetails == null) return const SizedBox.shrink();

    final bmi = ClientDetailsService.calculateBMI(
        _clientDetails!.heightCm, _clientDetails!.weightKg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Physical Information Section
        _buildDetailsSubsection(
          theme,
          colorScheme,
          'Physical Information',
          Icons.fitness_center_rounded,
          [
            if (_clientDetails!.heightCm != null)
              _buildDetailRow('Height',
                  '${_clientDetails!.heightCm!.toStringAsFixed(0)} cm'),
            if (_clientDetails!.weightKg != null)
              _buildDetailRow('Weight',
                  '${_clientDetails!.weightKg!.toStringAsFixed(1)} kg'),
            if (bmi != null)
              _buildDetailRow('BMI',
                  '${bmi.toStringAsFixed(1)} (${ClientDetailsService.getBMICategory(bmi)})'),
            _buildDetailRow(
                'Exercise Frequency',
                ClientDetailsService.formatExerciseFrequency(
                    _clientDetails!.exerciseFrequency)),
          ],
        ),

        const SizedBox(height: 16),

        // Dietary Information Section
        _buildDetailsSubsection(
          theme,
          colorScheme,
          'Dietary Information',
          Icons.restaurant_rounded,
          [
            _buildDetailRow('Daily Meals Preference',
                '${_clientDetails!.dailyMealsPreference} meals per day'),
            _buildDetailRow(
                'Allergies',
                ClientDetailsService.formatAllergies(
                    _clientDetails!.allergies)),
            if (_clientDetails!.dietaryRestrictions?.isNotEmpty == true)
              _buildDetailRow(
                  'Dietary Restrictions', _clientDetails!.dietaryRestrictions!),
            if (_clientDetails!.openTextPreferences?.isNotEmpty == true)
              _buildDetailRow('Additional Preferences',
                  _clientDetails!.openTextPreferences!),
          ],
        ),

        const SizedBox(height: 16),

        // Account Information Section
        _buildDetailsSubsection(
          theme,
          colorScheme,
          'Account Information',
          Icons.info_rounded,
          [
            if (_clientDetails!.createdAt != null)
              _buildDetailRow(
                  'Account Created',
                  DateFormat('MMM dd, yyyy').format(
                      _clientDetails!.createdAt!.getDateTimeInUtc().toLocal())),
            if (_clientDetails!.updatedAt != null)
              _buildDetailRow(
                  'Last Updated',
                  DateFormat('MMM dd, yyyy HH:mm').format(
                      _clientDetails!.updatedAt!.getDateTimeInUtc().toLocal())),
            if (_clientDetails!.activeMealPlanId != null)
              _buildDetailRow('Active Plan ID',
                  _clientDetails!.activeMealPlanId!.substring(0, 8) + '...'),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSubsection(ThemeData theme, ColorScheme colorScheme,
      String title, IconData icon, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: _isMetadataExpanded,
          onExpansionChanged: (expanded) =>
              setState(() => _isMetadataExpanded = expanded),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: colorScheme.onSurface,
          collapsedIconColor: colorScheme.onSurface,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: colorScheme.onSecondaryContainer,
              size: 20,
            ),
          ),
          title: Text(
            'Plan Information',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'View plan details',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildInfoRow('Plan Name',
                      widget.mealPlan.planName ?? 'Unnamed Plan', colorScheme),
                  _buildInfoRow(
                      'Plan ID', widget.mealPlan.mealPlanId, colorScheme),
                  if (widget.mealPlan.generatedAt != null)
                    _buildInfoRow(
                      'Generated',
                      DateFormat('MMM dd, yyyy HH:mm').format(
                        widget.mealPlan.generatedAt!
                            .getDateTimeInUtc()
                            .toLocal(),
                      ),
                      colorScheme,
                    ),
                  _buildInfoRow(
                    'Status',
                    _formatEnumValue(
                        widget.mealPlan.status?.toString().split('.').last ??
                            'UNKNOWN'),
                    colorScheme,
                    statusColor:
                        _getStatusColor(widget.mealPlan.status, colorScheme),
                  ),
                  _buildInfoRow(
                    'Validation',
                    _formatEnumValue(widget.mealPlan.validationStatus
                            ?.toString()
                            .split('.')
                            .last ??
                        'NOT_VALIDATED'),
                    colorScheme,
                    statusColor: _getValidationColor(
                        widget.mealPlan.validationStatus, colorScheme),
                  ),
                  if (widget.mealPlan.assignedNutritionistId != null)
                    _buildInfoRow(
                      'Nutritionist ID',
                      widget.mealPlan.assignedNutritionistId!,
                      colorScheme,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ColorScheme colorScheme,
      {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: statusColor != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPlanSection(ThemeData theme, ColorScheme colorScheme) {
    final dailyPlan = widget.mealPlan.dailyPlan;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: _isDailyPlanExpanded,
          onExpansionChanged: (expanded) =>
              setState(() => _isDailyPlanExpanded = expanded),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: colorScheme.onSurface,
          collapsedIconColor: colorScheme.onSurface,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_view_week_rounded,
              color: colorScheme.onTertiaryContainer,
              size: 20,
            ),
          ),
          title: Text(
            'Weekly Meal Plan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            dailyPlan == null
                ? 'No meal plan data available'
                : _isEditing
                    ? '7-day meal schedule (Editing)'
                    : widget.mealPlan.validationStatus ==
                            MealPlanValidationStatus.PENDING_REVIEW
                        ? '7-day meal schedule (View/Edit)'
                        : '7-day meal schedule (View Only)',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          children: [
            if (dailyPlan == null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.no_meals_rounded,
                      size: 48,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No daily plan data found for this meal plan.',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildDayMeals('Monday', 'monday',
                        _editedMeals['monday'] ?? [], colorScheme),
                    _buildDayMeals('Tuesday', 'tuesday',
                        _editedMeals['tuesday'] ?? [], colorScheme),
                    _buildDayMeals('Wednesday', 'wednesday',
                        _editedMeals['wednesday'] ?? [], colorScheme),
                    _buildDayMeals('Thursday', 'thursday',
                        _editedMeals['thursday'] ?? [], colorScheme),
                    _buildDayMeals('Friday', 'friday',
                        _editedMeals['friday'] ?? [], colorScheme),
                    _buildDayMeals('Saturday', 'saturday',
                        _editedMeals['saturday'] ?? [], colorScheme),
                    _buildDayMeals('Sunday', 'sunday',
                        _editedMeals['sunday'] ?? [], colorScheme),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayMeals(String dayName, String dayKey, List<Meal> meals,
      ColorScheme colorScheme) {
    final isToday = DateFormat('EEEE').format(DateTime.now()) == dayName;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isToday ? colorScheme.primaryContainer.withOpacity(0.3) : null,
        border: Border.all(
          color: isToday
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isToday
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                if (isToday)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  dayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isToday
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${meals.length} meals',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (meals.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.no_meals_rounded,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No meals scheduled for this day',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: meals
                    .asMap()
                    .entries
                    .map((entry) =>
                        _buildMeal(dayKey, entry.key, entry.value, colorScheme))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMeal(
      String dayKey, int mealIndex, Meal meal, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: colorScheme.onSurface,
          collapsedIconColor: colorScheme.onSurface,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getMealColor(meal.name, colorScheme).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getMealIcon(meal.name),
              color: _getMealColor(meal.name, colorScheme),
              size: 20,
            ),
          ),
          title: (_isEditing &&
                  widget.mealPlan.validationStatus ==
                      MealPlanValidationStatus.PENDING_REVIEW)
              ? TextField(
                  controller: _recipeNameControllers[dayKey]?[mealIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter recipe name',
                    isDense: true,
                  ),
                )
              : Text(
                  meal.recipeName ?? 'Unnamed meal',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
          subtitle: Text(
            localizeMealName(context, meal.name),
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (meal.recipe != null && meal.recipe!.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Instructions', Icons.list_alt_rounded, colorScheme),
                    const SizedBox(height: 8),
                    (_isEditing &&
                            widget.mealPlan.validationStatus ==
                                MealPlanValidationStatus.PENDING_REVIEW)
                        ? TextField(
                            controller: _recipeControllers[dayKey]?[mealIndex],
                            maxLines: 4,
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Enter cooking instructions...',
                              isDense: true,
                            ),
                          )
                        : _buildExpandableInstructions(
                            meal.recipe!, colorScheme),
                    const SizedBox(height: 16),
                  ],
                  _buildSectionHeader('Nutrition Information',
                      Icons.local_fire_department_rounded, colorScheme),
                  const SizedBox(height: 12),
                  _buildNutritionInfo(meal.totalMacros, colorScheme),
                  const SizedBox(height: 16),
                  _buildSectionHeader(
                      'Ingredients', Icons.eco_rounded, colorScheme),
                  const SizedBox(height: 12),
                  ...meal.ingredients.map((ingredient) =>
                      _buildIngredientRow(ingredient, colorScheme)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableInstructions(
      String instructions, ColorScheme colorScheme) {
    final isLong = instructions.length > 150;

    if (!isLong) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          instructions,
          style: TextStyle(
            color: colorScheme.onSurface,
            height: 1.4,
          ),
        ),
      );
    }

    return ExpandableInstructions(
      instructions: instructions,
      colorScheme: colorScheme,
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(Macros macros, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem(
            'Calories',
            '${macros.calories.round()}',
            'kcal',
            Icons.local_fire_department_rounded,
            Colors.orange,
            colorScheme,
          ),
          _buildNutritionItem(
            'Protein',
            '${macros.proteins.toStringAsFixed(1)}',
            'g',
            Icons.fitness_center_rounded,
            Colors.red,
            colorScheme,
          ),
          _buildNutritionItem(
            'Carbs',
            '${macros.carbohydrates.toStringAsFixed(1)}',
            'g',
            Icons.grain_rounded,
            Colors.green,
            colorScheme,
          ),
          _buildNutritionItem(
            'Fat',
            '${macros.fats.toStringAsFixed(1)}',
            'g',
            Icons.opacity_rounded,
            Colors.blue,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value $unit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIngredientRow(Ingredient ingredient, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.name,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              '${ingredient.amount.toStringAsFixed(1)} ${ingredient.unit ?? 'g'}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMealIcon(MealNameEnum mealName) {
    switch (mealName) {
      case MealNameEnum.BREAKFAST:
        return Icons.wb_sunny_rounded;
      case MealNameEnum.LUNCH:
        return Icons.lunch_dining_rounded;
      case MealNameEnum.DINNER:
        return Icons.dinner_dining_rounded;
      case MealNameEnum.SNACK_MORNING:
        return Icons.local_cafe_rounded;
      case MealNameEnum.SNACK_AFTERNOON:
        return Icons.cookie_rounded;
      case MealNameEnum.SNACK_EVENING:
        return Icons.nightlight_rounded;
    }
  }

  Color _getMealColor(MealNameEnum mealName, ColorScheme colorScheme) {
    switch (mealName) {
      case MealNameEnum.BREAKFAST:
        return Colors.orange;
      case MealNameEnum.LUNCH:
        return Colors.green;
      case MealNameEnum.DINNER:
        return Colors.purple;
      case MealNameEnum.SNACK_MORNING:
        return Colors.amber;
      case MealNameEnum.SNACK_AFTERNOON:
        return Colors.blue;
      case MealNameEnum.SNACK_EVENING:
        return Colors.indigo;
    }
  }

  Color _getStatusColor(dynamic status, ColorScheme colorScheme) {
    final statusString = status?.toString().split('.').last;
    if (statusString == 'ACTIVE') return Colors.green;
    if (statusString == 'GENERATED') return Colors.blue;
    if (statusString == 'ARCHIVED') return Colors.grey;
    if (statusString == 'FAILED') return Colors.red;
    if (statusString == 'IN_PROGRESS') return Colors.orange;
    if (statusString == 'PENDING') return Colors.amber;
    return colorScheme.primary;
  }

  Color _getValidationColor(dynamic validationStatus, ColorScheme colorScheme) {
    final statusString = validationStatus?.toString().split('.').last;
    if (statusString == 'VALIDATED') return Colors.green;
    if (statusString == 'PENDING_REVIEW') return Colors.orange;
    if (statusString == 'NOT_VALIDATED') return Colors.grey;
    return colorScheme.outline;
  }

  String _formatEnumValue(String enumValue) {
    return enumValue
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  Widget _buildChatButton(ColorScheme colorScheme) {
    // Always show chat button for nutritionists since chat exists
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _openChat,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(
          Icons.chat_bubble_rounded,
          color: colorScheme.onPrimary,
        ),
        label: Text(
          'Chat with Patient',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _openChat() {
    if (widget.mealPlan.chatId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            key: UniqueKey(),
            chatId: widget.mealPlan.chatId!,
            title: 'Chat - ${widget.mealPlan.planName ?? 'Meal Plan'}',
          ),
        ),
      );
    }
  }
}

/// A stateful widget for expandable instructions with simpler overflow detection
class ExpandableInstructions extends StatefulWidget {
  final String instructions;
  final ColorScheme colorScheme;

  const ExpandableInstructions({
    super.key,
    required this.instructions,
    required this.colorScheme,
  });

  @override
  State<ExpandableInstructions> createState() => _ExpandableInstructionsState();
}

class _ExpandableInstructionsState extends State<ExpandableInstructions> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Simple heuristic: if instructions are longer than 200 characters, show expand/collapse
    final isLong = widget.instructions.length > 200;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.instructions,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
            style: TextStyle(
              color: widget.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          if (isLong) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Show less' : 'Read more',
                      style: TextStyle(
                        color: widget.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
