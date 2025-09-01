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
    extends ConsumerState<ProSubscriptionSectionRiverpod> {
  String? _currentStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Schedule the status loading for after the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSubscriptionStatus();
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Handle subscribe button press
  Future<void> _subscribe() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Force fresh execution by invalidating the provider cache
      ref.invalidate(subscribeProvider);
      final success = await ref.read(subscribeProvider.future);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully subscribed to PRO!'),
              backgroundColor: Colors.green,
            ),
          );

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

    try {
      safePrint('[ProSubscriptionSection] Calling unsubscribeProvider...');
      // Force fresh execution by invalidating the provider cache
      ref.invalidate(unsubscribeProvider);
      final success = await ref.read(unsubscribeProvider.future);
      safePrint(
          '[ProSubscriptionSection] unsubscribeProvider returned: $success');

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully unsubscribed to FREE!'),
              backgroundColor: Colors.orange,
            ),
          );

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
    final isDark = theme.brightness == Brightness.dark;
    final isPro = _currentStatus == 'PRO';

    // Show loading state while initializing
    if (_currentStatus == null) {
      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.secondary.withValues(alpha: 0.1)
              : theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.secondary.withValues(alpha: 0.1)
            : theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPro
              ? Colors.green.withValues(alpha: isDark ? 0.6 : 0.4)
              : theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 2,
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
                  isPro ? Icons.star : Icons.star_border,
                  color: isPro ? Colors.green : Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isPro ? 'PRO Plan (Active)' : 'PRO Plan',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isPro ? Colors.green : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show current status
            if (_currentStatus != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPro ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPro ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Current Status: ${_currentStatus}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        isPro ? Colors.green.shade800 : Colors.orange.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (!isPro) ...[
              Text(
                'Unlock premium features:',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                  context, theme, "Expert meal planning validation"),
              _buildFeatureItem(
                  context, theme, "Personal nutritionist chat in-app"),
              const SizedBox(height: 20),
            ] else ...[
              Text(
                'You have access to:',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                  context, theme, "Expert meal planning validation"),
              _buildFeatureItem(
                  context, theme, "Personal nutritionist chat in-app"),
              const SizedBox(height: 20),
            ],

            // Dynamic button based on subscription status
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : isPro
                      ? ElevatedButton(
                          onPressed: _unsubscribe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.remove_circle_outline, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Unsubscribe from PRO',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _subscribe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upgrade, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Subscribe to PRO',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
