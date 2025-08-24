import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../generated/flutter-models/ModelProvider.dart';

class ValidationMealPlanCard extends StatelessWidget {
  final MealPlan plan;
  final VoidCallback? onValidate;
  final VoidCallback? onModify;
  final VoidCallback? onReject;

  const ValidationMealPlanCard({
    Key? key,
    required this.plan,
    this.onValidate,
    this.onModify,
    this.onReject,
  }) : super(key: key);

  Widget _buildValidationStatusIndicator(BuildContext context) {
    final theme = Theme.of(context);

    switch (plan.validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              Text(
                'Validated',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case MealPlanValidationStatus.PENDING_REVIEW:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pending, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text(
                'Pending Review',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case MealPlanValidationStatus.NOT_VALIDATED:
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline,
                  color: theme.colorScheme.outline, size: 16),
              const SizedBox(width: 4),
              Text(
                'Not Validated',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPendingReview =
        plan.validationStatus == MealPlanValidationStatus.PENDING_REVIEW;
    final isValidated =
        plan.validationStatus == MealPlanValidationStatus.VALIDATED;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: isPendingReview ? 4.0 : 2.0,
      color:
          isPendingReview ? theme.colorScheme.primary.withOpacity(0.08) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: isPendingReview
            ? BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3), width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Row(
          children: [
            Expanded(
              child: Text(
                plan.planName ?? 'Unnamed Plan',
                style: isPendingReview
                    ? TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )
                    : theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
              ),
            ),
            _buildValidationStatusIndicator(context),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Plan ID: ${plan.mealPlanId}'),
            if (plan.generatedAt != null) ...[
              const SizedBox(height: 2),
              Text(
                'Generated: ${DateFormat('MMM dd, yyyy').format(plan.generatedAt!.getDateTimeInUtc().toLocal())}',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        trailing: SizedBox(
          width: 150, // Reduced width since we removed the view button
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Validate/Check button
              SizedBox(
                width: 48,
                child: IconButton(
                  icon: Icon(isValidated ? Icons.check_circle : Icons.check),
                  color: isValidated ? Colors.green : theme.colorScheme.primary,
                  tooltip: isValidated ? 'Already validated' : 'Validate plan',
                  onPressed:
                      isPendingReview && !isValidated ? onValidate : null,
                ),
              ),

              // Modify button
              SizedBox(
                width: 48,
                child: IconButton(
                  icon: const Icon(Icons.edit_note),
                  color: theme.colorScheme.secondary,
                  tooltip: 'Modify plan',
                  onPressed: isPendingReview ? onModify : null,
                ),
              ),

              // Reject button
              SizedBox(
                width: 48,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: theme.colorScheme.error,
                  tooltip: 'Reject plan',
                  onPressed: isPendingReview ? onReject : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
