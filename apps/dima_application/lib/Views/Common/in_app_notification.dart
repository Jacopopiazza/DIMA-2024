import 'package:dima_application/providers/meal_plan_notification_provider.dart';
import 'package:flutter/material.dart';

/// In-app notification widget that slides down from the top
class InAppNotification extends StatefulWidget {
  final MealPlanNotification notification;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const InAppNotification({
    super.key,
    required this.notification,
    required this.onDismiss,
    this.onTap,
  });

  @override
  State<InAppNotification> createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the slide-in animation
    _animationController.forward();

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _animationController.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.notification.success
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap ?? _dismiss,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.notification.success
                                ? theme.colorScheme.primary.withOpacity(0.2)
                                : theme.colorScheme.error.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.notification.success
                                ? Icons.check_circle
                                : Icons.error,
                            color: widget.notification.success
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.notification.success
                                    ? 'Meal Plan Ready!'
                                    : 'Generation Failed',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.notification.success
                                      ? theme.colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onErrorContainer,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.notification.message,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: widget.notification.success
                                      ? theme.colorScheme.onPrimaryContainer
                                          .withOpacity(0.8)
                                      : theme.colorScheme.onErrorContainer
                                          .withOpacity(0.8),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Dismiss button
                        IconButton(
                          onPressed: _dismiss,
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: widget.notification.success
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onErrorContainer,
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Overlay manager for showing in-app notifications
class InAppNotificationManager {
  static OverlayEntry? _currentOverlay;

  /// Show an in-app notification
  static void show(
    BuildContext context,
    MealPlanNotification notification, {
    VoidCallback? onTap,
  }) {
    // Remove any existing notification
    hide();

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 0,
        right: 0,
        child: InAppNotification(
          notification: notification,
          onDismiss: hide,
          onTap: onTap,
        ),
      ),
    );

    // Use the root overlay to ensure it shows above nested navigators
    final overlayState = Overlay.of(context, rootOverlay: true);
    if (overlayState != null) {
      overlayState.insert(_currentOverlay!);
    }
  }

  /// Hide the current notification
  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
