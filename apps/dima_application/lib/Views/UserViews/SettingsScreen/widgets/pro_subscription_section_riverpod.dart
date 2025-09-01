import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/cognito_profile_provider.dart';

class ProSubscriptionSectionRiverpod extends ConsumerStatefulWidget {
  const ProSubscriptionSectionRiverpod({super.key});

  @override
  ConsumerState<ProSubscriptionSectionRiverpod> createState() =>
      _ProSubscriptionSectionRiverpodState();
}

class _ProSubscriptionSectionRiverpodState
    extends ConsumerState<ProSubscriptionSectionRiverpod>
    with SingleTickerProviderStateMixin {
  String? _currentStatus;
  bool _isLoading = false;

  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    
    // Schedule the status loading for after the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSubscriptionStatus();
    });
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  /// Load current subscription status
  Future<void> _loadSubscriptionStatus() async {
    try {
      safePrint('[ProSubscriptionSection] Loading subscription status...');

      // Force refresh by invalidating the provider cache
      ref.invalidate(subscriptionStatusProvider);

      final status = await ref.read(subscriptionStatusProvider.future);
      if (mounted) {
        setState(() {
          _currentStatus = status ?? 'FREE'; // Fallback to FREE if null
        });
        safePrint('[ProSubscriptionSection] Loaded status: $_currentStatus');
      }
    } catch (e) {
      safePrint('[ProSubscriptionSection] Error loading status: $e');
      // Don't show SnackBar here during initialization
      // Just log the error and set a default status
      if (mounted) {
        setState(() {
          _currentStatus = 'FREE'; // Default fallback
        });
      }
    }
  }

  /// Safely show error message
  void _showError(String message) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.error_outline_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(message),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      });
    }
  }

  /// Handle subscribe button press
  Future<void> _subscribe() async {
    setState(() {
      _isLoading = true;
    });

    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    try {
      // Force fresh execution by invalidating the provider cache
      ref.invalidate(subscribeProvider);
      final success = await ref.read(subscribeProvider.future);

      if (mounted) {
        if (success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Text('Successfully subscribed to PRO!'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          });

          // Force refresh the subscription status
          safePrint(
              '[ProSubscriptionSection] Subscription successful, refreshing status...');

          // Wait a moment for Cognito to update, then refresh
          await Future.delayed(const Duration(milliseconds: 500));
          await _loadSubscriptionStatus();

          // Force a rebuild
          setState(() {});
        } else {
          _showError('Failed to subscribe. Please try again.');
        }
      }
    } catch (e) {
      _showError('Error subscribing: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle unsubscribe button press
  Future<void> _unsubscribe() async {
    safePrint('[ProSubscriptionSection] Unsubscribe button clicked!');

    setState(() {
      _isLoading = true;
    });

    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    try {
      safePrint('[ProSubscriptionSection] Calling unsubscribeProvider...');
      // Force fresh execution by invalidating the provider cache
      ref.invalidate(unsubscribeProvider);
      final success = await ref.read(unsubscribeProvider.future);
      safePrint(
          '[ProSubscriptionSection] unsubscribeProvider returned: $success');

      if (mounted) {
        if (success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Text('Successfully unsubscribed to FREE!'),
                    ],
                  ),
                  backgroundColor: Colors.orange.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          });

          // Force refresh the subscription status
          safePrint(
              '[ProSubscriptionSection] Unsubscription successful, refreshing status...');

          // Wait a moment for Cognito to update, then refresh
          await Future.delayed(const Duration(milliseconds: 500));
          await _loadSubscriptionStatus();

          // Force a rebuild
          setState(() {});
        } else {
          _showError('Failed to unsubscribe. Please try again.');
        }
      }
    } catch (e) {
      _showError('Error unsubscribing: $e');
      safePrint('[ProSubscriptionSection] Error unsubscribing: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPro = _currentStatus == 'PRO';

    // Show loading state while initializing
    if (_currentStatus == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 3,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: isPro
            ? Border.all(
                color: Colors.green.withOpacity(0.6),
                width: 2,
              )
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isPro ? Colors.green : Colors.amber.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isPro ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPro ? 'PRO Plan' : 'PRO Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPro ? Colors.green.shade700 : colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        isPro ? 'Active subscription' : 'Upgrade to unlock premium features',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Current Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPro ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPro ? Colors.green.shade200 : Colors.orange.shade200,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isPro ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Status: $_currentStatus',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isPro ? Colors.green.shade800 : Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPro ? Icons.check_circle_rounded : Icons.upgrade_rounded,
                        color: isPro ? Colors.green : colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPro ? 'You have access to:' : 'Unlock premium features:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPro ? Colors.green.shade700 : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context, 
                    theme, 
                    colorScheme,
                    "Expert meal planning validation", 
                    isPro
                  ),
                  _buildFeatureItem(
                    context, 
                    theme, 
                    colorScheme,
                    "Personal nutritionist chat in-app", 
                    isPro
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            Center(
              child: ScaleTransition(
                scale: _buttonScale,
                child: _isLoading
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                          strokeWidth: 3,
                        ),
                      )
                    : isPro
                        ? FilledButton.icon(
                            onPressed: _unsubscribe,
                            icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                            label: Text(
                              'Unsubscribe from PRO',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSecondary,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        : FilledButton.icon(
                            onPressed: _subscribe,
                            icon: const Icon(Icons.upgrade_rounded, size: 20),
                            label: Text(
                              'Subscribe to PRO',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSecondary,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, 
    ThemeData theme, 
    ColorScheme colorScheme,
    String text, 
    bool isPro
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isPro ? Colors.green.shade100 : colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: isPro ? Colors.green.shade600 : colorScheme.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}