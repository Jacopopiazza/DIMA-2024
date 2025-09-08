import 'package:flutter/material.dart';

import '../../../generated/flutter-models/NutritionistProfile.dart';
import '../../../generated/l10n/app_localizations.dart';

class AvailabilitySection extends StatefulWidget {
  final NutritionistProfile? profile;
  final Future<void> Function(bool) onAvailabilityChanged;

  const AvailabilitySection({
    Key? key,
    required this.profile,
    required this.onAvailabilityChanged,
  }) : super(key: key);

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AvailabilitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile?.isAvailable != widget.profile?.isAvailable) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _handleAvailabilityChange(bool value) async {
    await _animationController.reverse();
    await widget.onAvailabilityChanged(value);
    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = widget.profile?.isAvailable ?? false;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Status Banner
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? Colors.green.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isAvailable
                              ? Colors.green.withOpacity(0.4)
                              : Colors.orange.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: 0.8 + (0.2 * value),
                                child: Icon(
                                  isAvailable ? Icons.check_circle : Icons.pause_circle,
                                  color: isAvailable ? Colors.green : Colors.orange,
                                  size: 20,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isAvailable
                                  ? AppLocalizations.of(context)!.currentlyAvailableForConsultations
                                  : AppLocalizations.of(context)!.currentlyUnavailableForConsultations,
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
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Toggle Switch
            Material(
              color: Colors.transparent,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(AppLocalizations.of(context)!.availableForConsultationsTitle),
                subtitle: Text(
                  isAvailable
                      ? AppLocalizations.of(context)!.usersCanRequestConsultations
                      : AppLocalizations.of(context)!.noNewConsultationRequests,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                value: isAvailable,
                onChanged: widget.profile != null
                    ? _handleAvailabilityChange
                    : null,
                activeColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
