import 'package:dima_application/Utils/localization_helpers.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/meal_plans_service.dart';
import 'package:dima_application/Views/Common/ChatScreen/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A modern, read-only view for meal plans with adaptive theming
/// and improved UX patterns
class ReadMealPlanPage extends StatefulWidget {
  final String mealPlanId;
  final String? initialPlanName;

  const ReadMealPlanPage({
    super.key,
    required this.mealPlanId,
    this.initialPlanName,
  });

  @override
  State<ReadMealPlanPage> createState() => _ReadMealPlanPageState();
}

class _ReadMealPlanPageState extends State<ReadMealPlanPage>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _isDailyPlanExpanded = true;
  bool _isMetadataExpanded = false;
  MealPlan? _mealPlan;
  String? _errorMessage;
  late final MealPlansService _mealPlansService;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _mealPlansService = MealPlansService();
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
    _loadMealPlan();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadMealPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final mealPlan =
          await _mealPlansService.getMealPlanById(widget.mealPlanId);
      if (mounted) {
        setState(() {
          _mealPlan = mealPlan;
          _isLoading = false;
        });
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load meal plan: $e';
          _isLoading = false;
        });
      }
    }
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
        ],
      ),
      // Chat button - only show if chatId is available
      floatingActionButton: _buildChatButton(colorScheme),
    );
  }

  Widget _buildBody(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return _buildLoadingState(colorScheme);
    }

    if (_errorMessage != null) {
      return _buildErrorState(theme, colorScheme);
    }

    if (_mealPlan == null) {
      return _buildNotFoundState(theme, colorScheme);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 80.0, 16.0, 16.0), // Added top padding for floating button
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetadataSection(theme, colorScheme),
            const SizedBox(height: 16),
            _buildDailyPlanSection(theme, colorScheme),
            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Loading your meal plan...',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    // Check if this looks like a network error
    final isNetworkError = _errorMessage!.toLowerCase().contains('network') ||
        _errorMessage!.toLowerCase().contains('connection') ||
        _errorMessage!.toLowerCase().contains('timeout') ||
        _errorMessage!.toLowerCase().contains('socket') ||
        _errorMessage!.toLowerCase().contains('unreachable') ||
        _errorMessage!.contains('SocketException') ||
        _errorMessage!.contains('HttpException') ||
        _errorMessage!.toLowerCase().contains('failed to connect') ||
        _errorMessage!.toLowerCase().contains('no internet');

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isNetworkError
                      ? Colors.orange.shade50
                      : colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isNetworkError
                        ? Colors.orange.shade200
                        : colorScheme.error.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  isNetworkError
                      ? Icons.wifi_off_rounded
                      : Icons.error_outline_rounded,
                  size: 48,
                  color: isNetworkError
                      ? Colors.orange.shade700
                      : colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isNetworkError
                    ? 'Connection Problem'
                    : 'Oops! Something went wrong',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isNetworkError
                    ? 'Please check your internet connection and try again. Make sure you\'re connected to Wi-Fi or cellular data.'
                    : 'We encountered an error while loading your meal plan. This might be a temporary issue.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _loadMealPlan,
                icon: Icon(isNetworkError
                    ? Icons.wifi_rounded
                    : Icons.refresh_rounded),
                label: Text(isNetworkError ? 'Reconnect' : 'Try Again'),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isNetworkError ? Colors.orange.shade600 : null,
                  foregroundColor: isNetworkError ? Colors.white : null,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundState(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.no_meals_rounded,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Meal Plan Not Found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This meal plan might have been deleted or is no longer available. Please try refreshing or go back to select another plan.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _loadMealPlan,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
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
                      _mealPlan!.planName ?? 'Unnamed Plan', colorScheme),
                  _buildInfoRow('Plan ID', _mealPlan!.mealPlanId, colorScheme),
                  if (_mealPlan!.generatedAt != null)
                    _buildInfoRow(
                      'Generated',
                      DateFormat('MMM dd, yyyy HH:mm').format(
                        _mealPlan!.generatedAt!.getDateTimeInUtc().toLocal(),
                      ),
                      colorScheme,
                    ),
                  _buildInfoRow(
                    'Status',
                    _formatEnumValue(
                        _mealPlan!.status?.toString().split('.').last ??
                            'UNKNOWN'),
                    colorScheme,
                    statusColor:
                        _getStatusColor(_mealPlan!.status, colorScheme),
                  ),
                  _buildInfoRow(
                    'Validation',
                    _formatEnumValue(_mealPlan!.validationStatus
                            ?.toString()
                            .split('.')
                            .last ??
                        'NOT_VALIDATED'),
                    colorScheme,
                    statusColor: _getValidationColor(
                        _mealPlan!.validationStatus, colorScheme),
                  ),
                  if (_mealPlan!.assignedNutritionistId != null)
                    _buildInfoRow(
                      'Nutritionist ID',
                      _mealPlan!.assignedNutritionistId!,
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
    final dailyPlan = _mealPlan!.dailyPlan;

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
                : '7-day meal schedule (Read-only)',
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
                    _buildReadOnlyDayMeals(
                        'Monday', dailyPlan.monday, colorScheme),
                    _buildReadOnlyDayMeals(
                        'Tuesday', dailyPlan.tuesday, colorScheme),
                    _buildReadOnlyDayMeals(
                        'Wednesday', dailyPlan.wednesday, colorScheme),
                    _buildReadOnlyDayMeals(
                        'Thursday', dailyPlan.thursday, colorScheme),
                    _buildReadOnlyDayMeals(
                        'Friday', dailyPlan.friday, colorScheme),
                    _buildReadOnlyDayMeals(
                        'Saturday', dailyPlan.saturday, colorScheme),
                    _buildReadOnlyDayMeals(
                        'Sunday', dailyPlan.sunday, colorScheme),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyDayMeals(
      String dayName, List<Meal>? meals, ColorScheme colorScheme) {
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
                    '${meals?.length ?? 0} meals',
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
          if (meals == null || meals.isEmpty)
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
                    .map(
                        (entry) => _buildReadOnlyMeal(entry.value, colorScheme))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyMeal(Meal meal, ColorScheme colorScheme) {
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
          title: Text(
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
                  if (meal.recipeName != null &&
                      meal.recipeName!.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Recipe Name', Icons.restaurant_rounded, colorScheme),
                    const SizedBox(height: 8),
                    Text(
                      meal.recipeName!,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (meal.recipe != null && meal.recipe!.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Instructions', Icons.list_alt_rounded, colorScheme),
                    const SizedBox(height: 8),
                    _buildExpandableInstructions(meal.recipe!, colorScheme),
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
    final isLong =
        instructions.length > 150; // Threshold for showing expand/collapse

    if (!isLong) {
      // If not long, just show the full text
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

    // For long instructions, use ExpandableInstructions widget
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
    // Add logic based on your status enum values
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
    // Add logic based on your validation status enum values
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

  Widget? _buildChatButton(ColorScheme colorScheme) {
    // Only show chat button if meal plan has chatId
    if (_mealPlan?.chatId == null || _mealPlan!.chatId!.isEmpty) {
      return null;
    }

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
          'Chat with Nutritionist',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _openChat() {
    if (_mealPlan?.chatId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            key: UniqueKey(),
            chatId: _mealPlan!.chatId!,
            title: 'Chat - ${_mealPlan!.planName ?? 'Meal Plan'}',
          ),
        ),
      );
    }
  }
}

/// A stateful widget for expandable instructions
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.colorScheme.surfaceVariant.withOpacity(0.5),
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
      ),
    );
  }
}
