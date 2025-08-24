import 'package:flutter/material.dart';

import '../../../generated/flutter-models/NutritionistProfile.dart';

class AvailabilitySection extends StatelessWidget {
  final NutritionistProfile? profile;
  final Future<void> Function(bool) onAvailabilityChanged;

  const AvailabilitySection({
    Key? key,
    required this.profile,
    required this.onAvailabilityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAvailable = profile?.isAvailable ?? false;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.secondary.withOpacity(0.1)
            : theme.colorScheme.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Availability',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current Status Indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAvailable
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isAvailable
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isAvailable ? Icons.check_circle : Icons.pause_circle,
                    color: isAvailable ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isAvailable
                          ? 'You are currently available for consultations'
                          : 'You are currently unavailable for consultations',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isAvailable
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Toggle Switch
            Material(
              color: Colors.transparent,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available for Consultations'),
                subtitle: Text(
                  isAvailable
                      ? 'Users can request consultations from you'
                      : 'You will not receive new consultation requests',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                value: isAvailable,
                onChanged: profile != null
                    ? (bool value) => onAvailabilityChanged(value)
                    : null,
                activeColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
