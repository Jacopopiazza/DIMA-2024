import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/providers/meal_plan_notification_provider.dart';
import 'package:dima_application/providers/subscription_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../navigation/route_observer.dart';
import 'read_meal_plan_page.dart';
import '../generate_meal_plan_page.dart';
import 'select_nutritionist_dialog.dart';
import 'modify_plan_name_dialog.dart';
import 'action_confirmation_dialog.dart';

/// Tablet-optimized My Plans page with side-by-side master-detail and grid.
/// Reuses the same providers and actions as the phone page, but adapts layout.
class MyPlansPageTablet extends ConsumerStatefulWidget {
  final bool showBackButton;

  const MyPlansPageTablet({super.key, this.showBackButton = false});

  @override
  ConsumerState<MyPlansPageTablet> createState() => _MyPlansPageTabletState();
}

class _MyPlansPageTabletState extends ConsumerState<MyPlansPageTablet>
    with RouteAware {
  String? _selectedPlanId; // persisted selection for detail pane
  DateTime? _lastVisitTime;
  bool _isManuallyRefreshing = false;
  int _detailRefreshKey = 0; // Key to force refresh of detail pane
  String? _settingActivePlanId; // Track which plan is being set as active

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mark page for notifications
      ref.read(currentPageProvider.notifier).state = 'MyPlansPage';
      // Refresh if stale
      if (ref.read(mealPlansProvider.notifier).isCacheStale) {
        _refreshPlans();
      }
    });
    _lastVisitTime = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _checkAndRefreshIfStale();
  }

  Future<void> _refreshPlans() async {
    if (_isManuallyRefreshing) return;

    _isManuallyRefreshing = true;
    try {
      await ref.read(mealPlansProvider.notifier).listMyMealPlans();
    } finally {
      if (mounted) _isManuallyRefreshing = false;
    }
  }

  void _checkAndRefreshIfStale() {
    if (_lastVisitTime != null) {
      final timeSinceLastVisit = DateTime.now().difference(_lastVisitTime!);
      // Reduced threshold to 10 seconds for better chat return experience
      if (timeSinceLastVisit.inSeconds > 10) {
        _refreshPlans();
      }
    }
    _lastVisitTime = DateTime.now();
  }

  /// Refreshes the detail pane by updating the key
  void _refreshDetailPane() {
    if (mounted) {
      setState(() {
        _detailRefreshKey++;
      });
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    if (mounted) {
      try {
        ref.read(currentPageProvider.notifier).state = null;
      } catch (_) {}
    }
    super.dispose();
  }

  void _showPlanActions(BuildContext context, dynamic plan, bool isActive) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final status = plan.status as PlanStatus?;
    final validationStatus = plan.validationStatus;
    final isRejected = validationStatus == MealPlanValidationStatus.REJECTED;
    final isFailed = status == PlanStatus.FAILED;
    final isNotValidated = validationStatus == null ||
        validationStatus == MealPlanValidationStatus.NOT_VALIDATED;

    // Determine which actions are available
    final canSetActive = !isActive &&
        !isFailed &&
        !isRejected &&
        status != null &&
        status != PlanStatus.PENDING &&
        status != PlanStatus.IN_PROGRESS;

    final canRequestValidation = isNotValidated &&
        !isFailed &&
        status != null &&
        status != PlanStatus.PENDING &&
        status != PlanStatus.IN_PROGRESS;

    final canRename =
        !isFailed && !isRejected; // Failed and rejected plans cannot be renamed

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Set active - only for non-active, non-failed, non-rejected plans
              if (canSetActive)
                ListTile(
                  leading: _settingActivePlanId == plan.mealPlanId
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_rounded),
                  title: Text(l10n.setActive),
                  enabled: _settingActivePlanId != plan.mealPlanId,
                  onTap: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      _settingActivePlanId = plan.mealPlanId;
                    });
                    try {
                      await ref
                          .read(mealPlansProvider.notifier)
                          .setActiveMealPlan(plan.mealPlanId);
                      // Refresh detail pane if this plan is currently selected
                      if (_selectedPlanId == plan.mealPlanId) {
                        _refreshDetailPane();
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _settingActivePlanId = null;
                        });
                      }
                    }
                  },
                ),
              // Rename - not available for failed or rejected plans
              if (canRename)
                ListTile(
                  leading: const Icon(Icons.drive_file_rename_outline_rounded),
                  title: Text(l10n.modifyPlanName),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await showDialog(
                      context: context,
                      builder: (_) => ModifyPlanNameDialog(
                        currentPlanName: plan.planName ?? '',
                        mealPlanId: plan.mealPlanId,
                        onSave: (id, name) async {
                          await ref
                              .read(mealPlansProvider.notifier)
                              .modifyMealPlan(id, name);
                          // Refresh detail pane if this plan is currently selected
                          if (_selectedPlanId == plan.mealPlanId) {
                            _refreshDetailPane();
                          }
                        },
                      ),
                    );
                  },
                ),
              // Request validation - only for not validated, non-failed plans (pro feature)
              if (canRequestValidation)
                Consumer(
                  builder: (context, ref, child) {
                    final subscriptionAsync =
                        ref.watch(subscriptionStatusProvider);
                    final isPro = subscriptionAsync.maybeWhen(
                      data: (data) =>
                          data.$1.subscriptionStatus ==
                          SubscriptionStatusEnum.PRO,
                      orElse: () => false,
                    );

                    return ListTile(
                      leading: Icon(
                        Icons.verified_user_rounded,
                        color: isPro ? null : Colors.grey,
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(l10n.requestValidation)),
                          if (!isPro) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.proFeature,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      enabled: isPro,
                      onTap: isPro
                          ? () async {
                              Navigator.of(context).pop();
                              final mealPlans =
                                  ref.read(mealPlansProvider.notifier);
                              await showDialog(
                                context: context,
                                builder: (_) => SelectNutritionistDialog(
                                  mealPlanId: plan.mealPlanId,
                                  planName: plan.planName ?? '',
                                  onLoadNutritionists: () => mealPlans
                                      .listNutritionists(isAvailable: true),
                                  onAssignNutritionist:
                                      (mealPlanId, nutritionistId) async {
                                    await mealPlans.requestValidation(
                                        mealPlanId, nutritionistId);
                                    // Refresh detail pane if this plan is currently selected
                                    if (_selectedPlanId == plan.mealPlanId) {
                                      _refreshDetailPane();
                                    }
                                    return true;
                                  },
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              // Add divider only if there are actions above delete
              if (canSetActive || canRename || canRequestValidation)
                const Divider(height: 1),
              // Delete - always available
              ListTile(
                leading:
                    const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: Text(l10n.delete, style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _confirmDelete(context, plan.mealPlanId,
                      plan.planName ?? l10n.unnamedPlan);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(mealPlansProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Notifications: show snackbars when on this page
    ref.listen<NotificationState>(mealPlanNotificationProvider,
        (previous, current) {
      final currentPage = ref.read(currentPageProvider);
      if (currentPage == 'MyPlansPage' &&
          current.hasUnreadNotifications &&
          current.notifications.isNotEmpty) {
        final latest = current.notifications.last;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(latest.message),
            backgroundColor: latest.success ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );

        // If the notification is about the currently selected meal plan, refresh the detail pane
        if (_selectedPlanId == latest.mealPlanId) {
          _refreshDetailPane();
        }

        // Mark as read shortly after
        Future.microtask(() =>
            ref.read(mealPlanNotificationProvider.notifier).markAllAsRead());
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: widget.showBackButton
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.mealPlans),
            )
          : null,
      body: SafeArea(
        child: plansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildErrorState(context, e.toString()),
          data: (plans) {
            if (plans.isEmpty) return _buildEmptyState(context);
            final activeId =
                ref.read(mealPlansProvider.notifier).cachedActiveMealPlanId;
            // Ensure selection is valid
            final ids = plans.map((p) => p.mealPlanId).toSet();
            if (_selectedPlanId == null || !ids.contains(_selectedPlanId)) {
              _selectedPlanId = activeId ?? plans.first.mealPlanId;
            }

            return Row(
              children: [
                // Master: grid/list with FAB
                Flexible(
                  flex: 5,
                  child: Stack(
                    children: [
                      _buildGrid(theme, colorScheme, plans, activeId),
                      // FAB positioned in the grid area (bottom-right)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: _buildFAB(context),
                      ),
                    ],
                  ),
                ),
                // Detail: sticky pane
                Flexible(
                  flex: 7,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _selectedPlanId == null
                        ? _buildNoSelection(context)
                        : ReadMealPlanPage(
                            key: ValueKey(
                                '${_selectedPlanId}_$_detailRefreshKey'),
                            mealPlanId: _selectedPlanId!,
                            showBackButton: false, // No back button on tablet
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // Chat button stays as the main floating action button
      floatingActionButton: null, // Moved to grid area
    );
  }

  Widget _buildGrid(
      ThemeData theme, ColorScheme colorScheme, List plans, String? activeId) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive columns based on width
        final width = constraints.maxWidth;
        int crossAxisCount = 3;
        if (width >= 1200) crossAxisCount = 4;
        if (width <= 900) crossAxisCount = 3;
        if (width <= 700) crossAxisCount = 2;

        return RefreshIndicator(
          onRefresh: _refreshPlans,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
            ),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isActive = plan.mealPlanId == activeId;
              final isSelected = plan.mealPlanId == _selectedPlanId;
              return _PlanTile(
                plan: plan,
                isActive: isActive,
                isSelected: isSelected,
                isSettingActive: _settingActivePlanId == plan.mealPlanId,
                onTap: () => setState(() => _selectedPlanId = plan.mealPlanId),
                onLongPress: () => _showPlanActions(context, plan, isActive),
                onSetActive: () async {
                  setState(() {
                    _settingActivePlanId = plan.mealPlanId;
                  });
                  try {
                    await ref
                        .read(mealPlansProvider.notifier)
                        .setActiveMealPlan(plan.mealPlanId);
                    // Refresh detail pane if this plan is currently selected
                    if (_selectedPlanId == plan.mealPlanId) {
                      _refreshDetailPane();
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _settingActivePlanId = null;
                      });
                    }
                  }
                },
                onOpen: () {
                  setState(() => _selectedPlanId = plan.mealPlanId);
                },
                onDelete: () async {
                  await _confirmDelete(
                    context,
                    plan.mealPlanId,
                    plan.planName ?? AppLocalizations.of(context)!.unnamedPlan,
                  );
                },
                onRename: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => ModifyPlanNameDialog(
                      currentPlanName: plan.planName ?? '',
                      mealPlanId: plan.mealPlanId,
                      onSave: (id, name) async {
                        await ref
                            .read(mealPlansProvider.notifier)
                            .modifyMealPlan(id, name);
                        // Refresh detail pane if this plan is currently selected
                        if (_selectedPlanId == plan.mealPlanId) {
                          _refreshDetailPane();
                        }
                      },
                    ),
                  );
                },
                onRequestValidation: () async {
                  final subscriptionAsync =
                      ref.read(subscriptionStatusProvider);
                  final isPro = subscriptionAsync.maybeWhen(
                    data: (data) =>
                        data.$1.subscriptionStatus ==
                        SubscriptionStatusEnum.PRO,
                    orElse: () => false,
                  );
                  if (!isPro) return;

                  final mealPlans = ref.read(mealPlansProvider.notifier);
                  await showDialog(
                    context: context,
                    builder: (_) => SelectNutritionistDialog(
                      mealPlanId: plan.mealPlanId,
                      planName: plan.planName ?? '',
                      onLoadNutritionists: () =>
                          mealPlans.listNutritionists(isAvailable: true),
                      onAssignNutritionist: (mealPlanId, nutritionistId) async {
                        await mealPlans.requestValidation(
                            mealPlanId, nutritionistId);
                        // Refresh detail pane if this plan is currently selected
                        if (_selectedPlanId == plan.mealPlanId) {
                          _refreshDetailPane();
                        }
                        return true;
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return FloatingActionButton.extended(
      heroTag: "tablet_new_plan_button", // Unique hero tag
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GenerateMealPlanPage()),
        );
        // Refresh plans when returning
        await ref.read(mealPlansProvider.notifier).listMyMealPlans();
      },
      icon: const Icon(Icons.add),
      label: Text(localizations.newPlan),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(l10n.noMealPlansYet,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              l10n.createFirstMealPlan,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                            ? l10n.connectionProblem
                            : l10n.somethingWentWrong,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isNetworkError
                            ? l10n.unableToLoadPlansWithConnection
                            : l10n.unableToLoadPlans,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.pullDownToRefresh,
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
                            label: Text(l10n.tryAgain),
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

  Widget _buildNoSelection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        l10n.mealPlans,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, String planId, String planName) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (_) => ActionConfirmationDialog(
        title: l10n.delete,
        content: l10n.deletePlanConfirmation(planName),
        actionLabel: l10n.delete,
        actionColor: Colors.red,
        actionIcon: Icons.delete_forever_rounded,
        onConfirm: () async {
          await ref.read(mealPlansProvider.notifier).deleteMealPlan(planId);
          // Clear selection if the deleted plan was currently selected
          if (_selectedPlanId == planId) {
            setState(() {
              _selectedPlanId = null;
            });
          }
        },
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final dynamic plan; // LightMealPlan
  final bool isActive;
  final bool isSelected;
  final bool isSettingActive;
  final VoidCallback onTap;
  final VoidCallback onOpen;
  final VoidCallback onLongPress;
  final Future<void> Function() onSetActive;
  final Future<void> Function() onDelete;
  final Future<void> Function() onRename;
  final Future<void> Function() onRequestValidation;

  const _PlanTile({
    required this.plan,
    required this.isActive,
    required this.isSelected,
    required this.isSettingActive,
    required this.onTap,
    required this.onOpen,
    required this.onLongPress,
    required this.onSetActive,
    required this.onDelete,
    required this.onRename,
    required this.onRequestValidation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderColor =
        isSelected ? colorScheme.primary : colorScheme.outlineVariant;

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            BorderSide(color: borderColor.withOpacity(isSelected ? 0.7 : 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onDoubleTap: onOpen,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top section with status pills and icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StatusPill(
                            status: plan.status as PlanStatus?,
                            isActive: isActive),
                        const SizedBox(height: 3),
                        // Only show validation pill for plans that are not generating (not IN_PROGRESS or PENDING)
                        if (plan.status != PlanStatus.IN_PROGRESS &&
                            plan.status != PlanStatus.PENDING)
                          _ValidationStatusPill(
                              validationStatus: plan.validationStatus),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  _StatusIcon(
                      plan: plan,
                      isActive: isActive,
                      isSettingActive: isSettingActive),
                ],
              ),
              const SizedBox(height: 6),
              // Plan name below status pills
              Flexible(
                child: Text(
                  plan.planName ?? AppLocalizations.of(context)!.unnamedPlan,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final dynamic plan; // LightMealPlan
  final bool isActive;
  final bool isSettingActive;

  const _StatusIcon(
      {required this.plan,
      required this.isActive,
      required this.isSettingActive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Show loading indicator if setting active
    if (isSettingActive) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ),
      );
    }

    IconData icon;
    Color bg;
    Color fg;
    if (isActive) {
      icon = Icons.restaurant_rounded;
      bg = colorScheme.primary;
      fg = colorScheme.onPrimary;
    } else {
      switch (plan.status) {
        case PlanStatus.IN_PROGRESS:
          icon = Icons.autorenew_rounded;
          bg = Colors.orange.shade600;
          fg = Colors.white;
          break;
        case PlanStatus.PENDING:
          icon = Icons.schedule_rounded;
          bg = Colors.amber.shade600;
          fg = Colors.white;
          break;
        case PlanStatus.FAILED:
          icon = Icons.error_rounded;
          bg = Colors.red.shade600;
          fg = Colors.white;
          break;
        default:
          icon = Icons.restaurant_menu_rounded;
          bg = colorScheme.surfaceContainerHigh;
          fg = colorScheme.onSurfaceVariant;
      }
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: fg, size: 22),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final PlanStatus? status;
  final bool isActive;

  const _StatusPill({required this.status, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String label;
    Color bg;
    Color fg;

    if (isActive) {
      label = l10n.active;
      bg = Colors.green.withOpacity(isDark ? 0.2 : 0.15);
      fg = isDark ? Colors.green[300]! : Colors.green[700]!;
    } else {
      switch (status) {
        case PlanStatus.IN_PROGRESS:
        case PlanStatus.PENDING:
          label = l10n.generating;
          bg = Colors.amber.withOpacity(isDark ? 0.2 : 0.12);
          fg = isDark ? Colors.amber[300]! : Colors.amber[700]!;
          break;

        case PlanStatus.FAILED:
          label = l10n.statusFailed;
          bg = Colors.red.withOpacity(isDark ? 0.2 : 0.12);
          fg = isDark ? Colors.red[300]! : Colors.red[700]!;
          break;
        default: // GENERATED
          label = l10n.statusGenerated;
          bg = Colors.blue.withOpacity(isDark ? 0.2 : 0.12);
          fg = isDark ? Colors.blue[300]! : Colors.blue[700]!;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontSize: 9,
            ),
      ),
    );
  }
}

class _ValidationStatusPill extends StatelessWidget {
  final MealPlanValidationStatus? validationStatus;

  const _ValidationStatusPill({required this.validationStatus});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String label;
    Color bg;
    Color fg;

    switch (validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        label = l10n.validated;
        bg = Colors.green.withOpacity(isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.green[300]! : Colors.green[700]!;
        break;
      case MealPlanValidationStatus.PENDING_REVIEW:
        label = l10n.validationPendingReview;
        bg = Colors.orange.withOpacity(isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.orange[300]! : Colors.orange[700]!;
        break;
      case MealPlanValidationStatus.REJECTED:
        label = l10n.rejected;
        bg = Colors.red.withOpacity(isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.red[300]! : Colors.red[700]!;
        break;
      default:
        label = l10n.validationNotValidated;
        bg = Colors.grey.withOpacity(isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.grey[300]! : Colors.grey[700]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontSize: 9,
            ),
      ),
    );
  }
}

// Removed unused PlanStatus? extension
