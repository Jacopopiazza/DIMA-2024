import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../generated/flutter-models/ModelProvider.dart';
import '../nutritionist_read_meal_plan_page.dart';

class ValidationMealPlanCard extends StatelessWidget {
  final MealPlan plan;
  final VoidCallback? onRefresh;

  const ValidationMealPlanCard({
    Key? key,
    required this.plan,
    this.onRefresh,
  }) : super(key: key);

  /// Validation status configuration matching user styling
  static const Map<MealPlanValidationStatus, Map<String, dynamic>>
      _validationConfig = {
    MealPlanValidationStatus.VALIDATED: {
      'icon': Icons.verified_rounded,
      'label': 'Validated',
      'color': Colors.green,
    },
    MealPlanValidationStatus.PENDING_REVIEW: {
      'icon': Icons.pending_rounded,
      'label': 'Pending Review',
      'color': Colors.orange,
    },
    MealPlanValidationStatus.NOT_VALIDATED: {
      'icon': Icons.help_outline_rounded,
      'label': 'Not Validated',
      'color': null, // Use theme colors
    },
  };

  Widget _buildValidationChip(MealPlanValidationStatus? validationStatus,
      ColorScheme colorScheme, ThemeData theme) {
    if (validationStatus == null ||
        !_validationConfig.containsKey(validationStatus)) {
      return const SizedBox.shrink();
    }

    final config = _validationConfig[validationStatus]!;
    final baseColor = config['color'] as MaterialColor?;
    final backgroundColor =
        baseColor?.shade100 ?? colorScheme.surfaceContainerHigh;
    final foregroundColor = baseColor?.shade800 ?? colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config['icon'], size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            config['label'],
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _openNutritionistView(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => NutritionistReadMealPlanPage(
          mealPlan: plan,
        ),
      ),
    );
    
    // If changes were made (result is true), trigger refresh
    if (result == true && onRefresh != null) {
      onRefresh!();
    }
  }

  Color _getPlanStatusColor(
      MealPlanValidationStatus? validationStatus, ColorScheme colorScheme) {
    switch (validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        return Colors.green.shade600;
      case MealPlanValidationStatus.PENDING_REVIEW:
        return Colors.orange.shade600;
      case MealPlanValidationStatus.NOT_VALIDATED:
      default:
        return colorScheme.surfaceContainerHigh;
    }
  }

  IconData _getPlanStatusIcon(MealPlanValidationStatus? validationStatus) {
    switch (validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        return Icons.verified_rounded;
      case MealPlanValidationStatus.PENDING_REVIEW:
        return Icons.pending_rounded;
      case MealPlanValidationStatus.NOT_VALIDATED:
      default:
        return Icons.assignment_outlined;
    }
  }

  Color _getPlanStatusIconColor(
      MealPlanValidationStatus? validationStatus, ColorScheme colorScheme) {
    switch (validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
      case MealPlanValidationStatus.PENDING_REVIEW:
        return Colors.white;
      case MealPlanValidationStatus.NOT_VALIDATED:
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPendingReview =
        plan.validationStatus == MealPlanValidationStatus.PENDING_REVIEW;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openNutritionistView(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: isPendingReview
                ? LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.1),
                      colorScheme.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isPendingReview
                ? null
                : colorScheme.surfaceContainerHighest.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: isPendingReview
                ? Border.all(
                    color: colorScheme.primary.withOpacity(0.3), width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Status indicator & icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getPlanStatusColor(plan.validationStatus, colorScheme),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getPlanStatusIcon(plan.validationStatus),
                    color: _getPlanStatusIconColor(plan.validationStatus, colorScheme),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Plan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              plan.planName ?? 'Unnamed Plan',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isPendingReview
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildValidationChip(plan.validationStatus, colorScheme, theme),
                          const SizedBox(width: 8),
                          Text(
                            'Plan ID: ${plan.mealPlanId.substring(0, 8)}...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                      if (plan.generatedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Created: ${DateFormat('MMM dd, yyyy').format(plan.generatedAt!.getDateTimeInUtc().toLocal())}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                      // Add last updated date if available
                      if (plan.updatedAt != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Updated: ${DateFormat('MMM dd, yyyy HH:mm').format(plan.updatedAt!.getDateTimeInUtc().toLocal())}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
