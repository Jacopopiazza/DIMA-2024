import 'package:dima_application/Views/UserViews/MyPlansScreen/action_confirmation_dialog.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/providers/meal_plan_notification_provider.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../navigation/route_observer.dart';

import '../generate_meal_plan_page.dart';
import 'modify_plan_name_dialog.dart';
import 'read_meal_plan_page.dart';
import 'select_nutritionist_dialog.dart';

class MyPlansPage extends ConsumerStatefulWidget {
  const MyPlansPage({super.key});

  @override
  ConsumerState<MyPlansPage> createState() => _MyPlansPageState();
}

class _MyPlansPageState extends ConsumerState<MyPlansPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  bool _isManuallyRefreshing = false;
  DateTime? _lastVisitTime;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    // Smart initialization: check cache status and refresh if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePageSmart();
    });
    _lastVisitTime = DateTime.now();
  }

  /// Initialize page and set current page state
  void _initializePageSmart() {
    ref.read(currentPageProvider.notifier).state = 'MyPlansPage';
    
    final mealPlansNotifier = ref.read(mealPlansProvider.notifier);
    
    // Only refresh if cache is stale (notifications are handled by background refresh)
    if (mealPlansNotifier.isCacheStale) {
      print('[MyPlansPage] Cache is stale, refreshing...');
      _refreshPlans();
    } else {
      print('[MyPlansPage] Cache is fresh, no refresh needed');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register with route observer for navigation callbacks
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when user navigates back to this page
    print('[MyPlansPage] User navigated back to my plans page');
    _checkAndRefreshIfStale();
    super.didPopNext();
  }

  void _checkAndRefreshIfStale() {
    final now = DateTime.now();
    if (_lastVisitTime != null) {
      final timeSinceLastVisit = now.difference(_lastVisitTime!);
      print('[MyPlansPage] Time since last visit: ${timeSinceLastVisit.inSeconds} seconds');
      
      // If user was away for more than 30 seconds, refresh the data
      if (timeSinceLastVisit.inSeconds > 30) {
        print('[MyPlansPage] Data potentially stale, refreshing...');
        _refreshPlans();
      }
    }
    _lastVisitTime = now;
  }

  @override
  void dispose() {
    // Unregister from route observer
    routeObserver.unsubscribe(this);
    
    // Mark that we're leaving MyPlansPage - only if still mounted
    if (mounted) {
      try {
        ref.read(currentPageProvider.notifier).state = null;
      } catch (e) {
        // Ignore errors if ref is no longer available
      }
    }
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _openGenerateMealPlan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GenerateMealPlanPage(),
      ),
    );
  }

  Future<void> _refreshPlans() async {
    if (_isManuallyRefreshing) return;
    
    _isManuallyRefreshing = true;
    try {
      final notifier = ref.read(mealPlansProvider.notifier);
      await notifier.listMyMealPlans();
    } finally {
      if (mounted) {
        _isManuallyRefreshing = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(mealPlansProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Listen for notifications and show user feedback (background refresh is handled globally)
    ref.listen<NotificationState>(mealPlanNotificationProvider,
        (previous, current) {
      final currentPage = ref.read(currentPageProvider);
      
      // Show notification message if we're on this page
      if (currentPage == 'MyPlansPage' &&
          current.hasUnreadNotifications &&
          current.notifications.isNotEmpty) {
        final latestNotification = current.notifications.last;
        
        // Mark notifications as read since we're showing them
        ref.read(mealPlanNotificationProvider.notifier).markAllAsRead();

        // Show user feedback (data is already being refreshed in background)
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
                  child: Icon(
                      latestNotification.success ? Icons.refresh : Icons.info,
                      color: Colors.white,
                      size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(latestNotification.success
                      ? 'New meal plan available!'
                      : 'Meal plan status updated.'),
                ),
              ],
            ),
            backgroundColor: latestNotification.success
                ? Colors.green.shade600
                : Colors.blue.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    final showAppBar = Navigator.canPop(context);
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: showAppBar ? AppBar(
        title: Text(
          'My Plans',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ) : null,
      body: plansAsync.when(
        data: (plans) {
          final activePlanId = ref.watch(activeMealPlanIdProvider);
          String? resolvedActivePlanId = activePlanId;
          if (resolvedActivePlanId == null && plans.isNotEmpty) {
            final activeByStatus =
                plans.where((p) => p.status == PlanStatus.ACTIVE).firstOrNull;
            resolvedActivePlanId = activeByStatus?.mealPlanId;
          }

          // Avvolgiamo TUTTO con RefreshIndicator, anche l'empty state
          return RefreshIndicator(
            onRefresh: _refreshPlans,
            backgroundColor: colorScheme.surface,
            color: colorScheme.primary,
            child: plans.isEmpty
                ? _buildEmptyState(context, colorScheme)
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final isActive = plan.mealPlanId == resolvedActivePlanId;
                      return _buildMealPlanCard(
                          context, plan, isActive, colorScheme, theme);
                    },
                  ),
          );
        },
        loading: () => Center(
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
                'Loading your meal plans...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        error: (e, st) =>
            _buildErrorState(context, e.toString(), colorScheme, theme),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            _fabAnimationController.forward().then((_) {
              _fabAnimationController.reverse();
            });
            _openGenerateMealPlan(context);
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 8,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'New Plan',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No meal plans yet',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Create your first personalized meal plan\nto get started with healthy eating',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pull down to refresh',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Replace the existing _buildErrorState method with this improved version:

  Widget _buildErrorState(BuildContext context, String error,
      ColorScheme colorScheme, ThemeData theme) {
    // Check if this looks like a network error
    final isNetworkError = error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('timeout') ||
        error.toLowerCase().contains('socket') ||
        error.toLowerCase().contains('unreachable') ||
        error.contains('SocketException') ||
        error.contains('HttpException');

    return RefreshIndicator(
      onRefresh: _refreshPlans,
      backgroundColor: colorScheme.surface,
      color: colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
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
                              ? Colors.orange.shade100
                              : colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isNetworkError
                              ? Icons.wifi_off_rounded
                              : Icons.error_outline_rounded,
                          size: 48,
                          color: isNetworkError
                              ? Colors.orange.shade700
                              : colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isNetworkError
                            ? 'Connection Problem'
                            : 'Something went wrong',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isNetworkError
                            ? 'Unable to load your meal plans.\nCheck your internet connection and try again.'
                            : 'Unable to load your meal plans',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Pull down to refresh',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: _refreshPlans,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try Again'),
                            style: FilledButton.styleFrom(
                              backgroundColor: isNetworkError
                                  ? Colors.orange.shade600
                                  : null,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGeneratingCard(BuildContext context, plan, bool isActive,
      ColorScheme colorScheme, ThemeData theme) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Status indicator & icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getPlanStatusColor(plan.status, isActive, colorScheme),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getPlanStatusIcon(plan.status, isActive),
                color:
                    _getPlanStatusIconColor(plan.status, isActive, colorScheme),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Plan info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.planName ?? 'Unnamed Plan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatusChip(plan.status, colorScheme, theme),
                      const Spacer(),
                      Icon(
                        Icons.hourglass_empty_rounded,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(BuildContext context, plan, bool isActive,
      ColorScheme colorScheme, ThemeData theme) {
    final bool isGenerating = plan.status == PlanStatus.PENDING ||
        plan.status == PlanStatus.IN_PROGRESS;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: isGenerating
          ? _buildGeneratingCard(context, plan, isActive, colorScheme, theme)
          : Dismissible(
              key: Key(plan.mealPlanId),
              background: _buildSwipeBackground(
                colorScheme.primary,
                Icons.radio_button_checked_rounded,
                'Set Active',
                Alignment.centerLeft,
              ),
              secondaryBackground: _buildSwipeBackground(
                colorScheme.error,
                Icons.delete_rounded,
                'Delete',
                Alignment.centerRight,
              ),
              confirmDismiss: (direction) =>
                  _handleSwipe(context, plan, direction, isActive),
              child: InkWell(
                onTap: () => _openPlanDetails(context, plan),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              colorScheme.primary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color:
                        isActive ? null : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive
                        ? Border.all(
                            color: colorScheme.primary.withOpacity(0.3),
                            width: 1.5)
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
                            color: _getPlanStatusColor(
                                plan.status, isActive, colorScheme),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getPlanStatusIcon(plan.status, isActive),
                            color: _getPlanStatusIconColor(
                                plan.status, isActive, colorScheme),
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
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isActive
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'ACTIVE',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildStatusChip(
                                      plan.status, colorScheme, theme),
                                  if (plan.status != PlanStatus.PENDING &&
                                      plan.status != PlanStatus.IN_PROGRESS)
                                    _buildValidationChip(plan.validationStatus,
                                        colorScheme, theme),
                                  const Spacer(),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildValidationChip(MealPlanValidationStatus validationStatus,
      ColorScheme colorScheme, ThemeData theme) {
    IconData icon;
    Color backgroundColor;
    Color foregroundColor;
    String label;

    switch (validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        icon = Icons.verified_rounded;
        backgroundColor = Colors.green.shade100;
        foregroundColor = Colors.green.shade800;
        label = 'Validated';
        break;
      case MealPlanValidationStatus.PENDING_REVIEW:
        icon = Icons.pending_rounded;
        backgroundColor = Colors.orange.shade100;
        foregroundColor = Colors.orange.shade800;
        label = 'Pending Validation';
        break;
      case MealPlanValidationStatus.NOT_VALIDATED:
        icon = Icons.help_outline_rounded;
        backgroundColor = colorScheme.surfaceContainerHigh;
        foregroundColor = colorScheme.onSurfaceVariant;
        label = 'Not validated';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground(
      Color color, IconData icon, String label, Alignment alignment) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(status, ColorScheme colorScheme, ThemeData theme) {
    if (status == null) return const SizedBox.shrink();

    IconData icon;
    Color backgroundColor;
    Color foregroundColor;
    String label;

    switch (status) {
      case PlanStatus.IN_PROGRESS:
      case PlanStatus.PENDING:
        icon = Icons.autorenew_rounded;
        backgroundColor = Colors.blue.shade100;
        foregroundColor = Colors.blue.shade800;
        label = 'Generating';
        break;
      default:
        return const SizedBox.shrink(); // Hide other statuses
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: foregroundColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Color _getPlanStatusColor(
      PlanStatus status, bool isActive, ColorScheme colorScheme) {
    if (isActive) return colorScheme.primary;

    if (status == PlanStatus.IN_PROGRESS) {
      return Colors.blue.shade600;
    } else if (status == PlanStatus.PENDING) {
      return Colors.amber.shade600;
    }

    return colorScheme.surfaceContainerHigh;
  }

  IconData _getPlanStatusIcon(PlanStatus status, bool isActive) {
    if (isActive) return Icons.restaurant_rounded;

    if (status == PlanStatus.IN_PROGRESS) {
      return Icons.autorenew_rounded;
    } else if (status == PlanStatus.PENDING) {
      return Icons.schedule_rounded;
    }

    return Icons.restaurant_menu_rounded;
  }

  Color _getPlanStatusIconColor(
      PlanStatus status, bool isActive, ColorScheme colorScheme) {
    if (isActive) return colorScheme.onPrimary;

    if (status == PlanStatus.IN_PROGRESS) {
      return Colors.white;
    } else if (status == PlanStatus.PENDING) {
      return Colors.white;
    }

    return colorScheme.onSurfaceVariant;
  }

  Future<bool> _handleSwipe(BuildContext context, plan,
      DismissDirection direction, bool isActive) async {
    // For SET ACTIVE (startToEnd):
    if (direction == DismissDirection.startToEnd && !isActive) {
      // Set as active
      await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return ActionConfirmationDialog(
            title: 'Set Active Plan',
            content:
                'Make "${plan.planName ?? 'Unnamed Plan'}" your active meal plan?',
            actionLabel: 'Set Active',
            actionColor: Theme.of(context).colorScheme.primary,
            actionIcon: Icons.radio_button_checked_rounded,
            onConfirm: () async {
              final success = await ref
                  .read(mealPlansProvider.notifier)
                  .setActiveMealPlan(plan.mealPlanId);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Active meal plan updated!'
                        : 'Failed to set active meal plan'),
                    backgroundColor:
                        success ? Colors.green.shade600 : Colors.red.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }

              if (!success) {
                throw Exception('Failed to set active meal plan');
              }
            },
          );
        },
      );
      return false;
    }

// For DELETE (endToStart):
    else if (direction == DismissDirection.endToStart) {
      // Delete
      await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return ActionConfirmationDialog(
            title: 'Delete Meal Plan',
            content:
                'Are you sure you want to delete "${plan.planName ?? 'Unnamed Plan'}"?',
            actionLabel: 'Delete',
            actionColor: Colors.red,
            actionIcon: Icons.delete_rounded,
            actionTextColor: Colors.white,
            onConfirm: () async {
              final success = await ref
                  .read(mealPlansProvider.notifier)
                  .deleteMealPlan(plan.mealPlanId);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Meal plan deleted successfully'
                        : 'Failed to delete meal plan'),
                    backgroundColor:
                        success ? Colors.green.shade600 : Colors.red.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }

              if (!success) {
                throw Exception('Failed to delete meal plan');
              }
            },
          );
        },
      );
      return false;
    }
    return false;
  }

  void _openPlanDetails(BuildContext context, plan) {
    // Show bottom sheet with quick actions
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildActionBottomSheet(context, plan),
    );
  }

  Widget _buildActionBottomSheet(BuildContext context, plan) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Plan title
            Text(
              plan.planName ?? 'Unnamed Plan',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Plan ID: ${plan.mealPlanId}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            _buildActionButton(
              context,
              Icons.visibility_rounded,
              'View Plan',
              'See detailed meal plan',
              colorScheme.primary,
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadMealPlanPage(
                      mealPlanId: plan.mealPlanId,
                      initialPlanName: plan.planName,
                    ),
                  ),
                );
              },
            ),
            _buildActionButton(
              context,
              Icons.edit_rounded,
              'Edit Name',
              'Change the plan name',
              colorScheme.secondary,
              () async {
                Navigator.pop(context);
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return ModifyPlanNameDialog(
                      currentPlanName: plan.planName ?? 'Unnamed Plan',
                      mealPlanId: plan.mealPlanId,
                      onSave: (mealPlanId, newName) async {
                        final success = await ref
                            .read(mealPlansProvider.notifier)
                            .modifyMealPlan(mealPlanId, newName);

                        if (!success) {
                          throw Exception('Failed to update meal plan');
                        }
                      },
                    );
                  },
                );
              },
            ),
            if (plan.validationStatus == MealPlanValidationStatus.NOT_VALIDATED)
              _buildActionButton(
                context,
                Icons.person_add_rounded,
                'Request Validation',
                'Get nutritionist approval',
                Colors.orange,
                () async {
                  Navigator.pop(context);
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return SelectNutritionistDialog(
                        mealPlanId: plan.mealPlanId,
                        planName: plan.planName ?? 'Unnamed Plan',
                        onLoadNutritionists: () => ref
                            .read(mealPlansProvider.notifier)
                            .listNutritionists(isAvailable: true),
                        onAssignNutritionist: (mealPlanId, nutritionistId) =>
                            ref
                                .read(mealPlansProvider.notifier)
                                .requestValidation(mealPlanId, nutritionistId),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
