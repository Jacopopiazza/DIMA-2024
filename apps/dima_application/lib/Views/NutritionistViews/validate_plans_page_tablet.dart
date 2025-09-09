import 'package:dima_application/Views/Common/offline_screen.dart';
import 'package:dima_application/Views/NutritionistViews/nutritionist_read_meal_plan_page.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/providers/meal_plans_provider.dart';
import 'package:dima_application/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Tablet-optimized Validate Plans page with side-by-side master-detail layout.
/// Reuses the same providers and actions as the phone page, but adapts layout for iPad.
class ValidatePlansPageTablet extends ConsumerStatefulWidget {
  const ValidatePlansPageTablet({super.key});

  @override
  ConsumerState<ValidatePlansPageTablet> createState() =>
      _ValidatePlansPageTabletState();
}

class _ValidatePlansPageTabletState
    extends ConsumerState<ValidatePlansPageTablet> {
  List<MealPlan> _assignedMealPlans = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _selectedPlanId; // persisted selection for detail pane
  bool _isManuallyRefreshing = false;
  int _detailRefreshKey = 0; // Key to force refresh of detail pane

  @override
  void initState() {
    super.initState();
    _loadAssignedMealPlans();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadAssignedMealPlans() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check connectivity first
      final connectivityService = ConnectivityService();
      final isConnected = await connectivityService.checkConnectivityManually();

      if (!isConnected) {
        if (mounted) {
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.noInternetConnectionValidation;
            _isLoading = false;
          });
        }
        return;
      }

      final plans =
          await ref.read(mealPlansProvider.notifier).listMyAssignedMealPlans();
      if (mounted) {
        setState(() {
          _assignedMealPlans = plans;
          _isLoading = false;

          _ensureValidSelection(plans);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!
              .errorLoadingAssignedPlans(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshPlans() async {
    if (_isManuallyRefreshing) return;

    _isManuallyRefreshing = true;
    try {
      await _loadAssignedMealPlans();
    } finally {
      if (mounted) _isManuallyRefreshing = false;
    }
  }

  void _refreshDetailPane() {
    if (mounted) {
      setState(() {
        _detailRefreshKey++;
      });
    }
  }

  void _ensureValidSelection(List<MealPlan> plans) {
    final ids = plans.map((p) => p.mealPlanId).toSet();
    if (_selectedPlanId == null || !ids.contains(_selectedPlanId)) {
      _selectedPlanId = plans.isNotEmpty ? plans.first.mealPlanId : null;
    }
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState(context);
    if (_errorMessage != null) return _buildErrorState(context, _errorMessage!);
    if (_assignedMealPlans.isEmpty) return _buildEmptyState(context);

    return Row(
      children: [
        Flexible(
          flex: 5,
          child: _buildGrid(_assignedMealPlans),
        ),
        Flexible(
          flex: 7,
          child: _buildDetailPane(),
        ),
      ],
    );
  }

  Widget _buildDetailPane() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _selectedPlanId == null
          ? _buildNoSelection(context)
          : NutritionistReadMealPlanPage(
              key: ValueKey('${_selectedPlanId}_$_detailRefreshKey'),
              mealPlan: _assignedMealPlans.firstWhere(
                (p) => p.mealPlanId == _selectedPlanId,
              ),
              showBackButton: false,
              onOperationComplete: () {
                _refreshPlans();
                _refreshDetailPane();
              },
            ),
    );
  }

  Widget _buildPlanTile(MealPlan plan, bool isLandscape) {
    final isSelected = plan.mealPlanId == _selectedPlanId;

    return _ValidationPlanTile(
      plan: plan,
      isSelected: isSelected,
      isLandscape: isLandscape,
      onTap: () => setState(() => _selectedPlanId = plan.mealPlanId),
      onRefresh: () {
        _refreshPlans();
        if (_selectedPlanId == plan.mealPlanId) {
          _refreshDetailPane();
        }
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 72,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noMealPlansYet,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Assigned plans for validation will appear here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
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
    return Center(
      child: Text(
        AppLocalizations.of(context)!.mealPlans,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildGrid(List<MealPlan> plans) {
    return Consumer(
      builder: (context, ref, child) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        const cardPadding = 12.0;
        const crossAxisCount = 2;
        final childAspectRatio = isLandscape ? 1.3 : 1.0;

        return RefreshIndicator(
          onRefresh: _refreshPlans,
          child: GridView.builder(
            padding: const EdgeInsets.all(cardPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: cardPadding,
              mainAxisSpacing: cardPadding,
            ),
            itemCount: plans.length,
            itemBuilder: (context, index) =>
                _buildPlanTile(plans[index], isLandscape),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineScreen(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }
}

class _ValidationPlanTile extends StatelessWidget {
  final MealPlan plan;
  final bool isSelected;
  final bool isLandscape;
  final VoidCallback onTap;
  final VoidCallback onRefresh;

  const _ValidationPlanTile({
    required this.plan,
    required this.isSelected,
    required this.isLandscape,
    required this.onTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    
    // Detect small tablets (close to phone threshold)
    final isSmallTablet = screenSize.shortestSide < 700 || 
                         (isLandscape && screenSize.height < 450);

    final borderColor =
        isSelected ? colorScheme.primary : colorScheme.outlineVariant;

    // Adaptive sizing based on tablet size
    final cardPadding = isSmallTablet ? 8.0 : 12.0;
    final titleMaxLines = isSmallTablet ? 1 : 3;
    final titleFontSize = isSmallTablet 
        ? (isLandscape ? 10.0 : 11.0)
        : (isLandscape ? 12.0 : 13.0);
    final clientFontSize = isSmallTablet 
        ? (isLandscape ? 9.0 : 9.5)
        : (isLandscape ? 10.0 : 10.5);
    final statusFontSize = isSmallTablet 
        ? (isLandscape ? 8.0 : 8.5)
        : (isLandscape ? 9.0 : 9.5);
    final iconSize = isSmallTablet 
        ? (isLandscape ? 18.0 : 20.0)
        : (isLandscape ? 22.0 : 24.0);
    final verticalSpacing = isSmallTablet 
        ? (isLandscape ? 4.0 : 5.0)
        : (isLandscape ? 6.0 : 8.0);

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: borderColor.withValues(alpha: isSelected ? 0.7 : 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top section with validation status and icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ValidationStatusPill(
                          validationStatus: plan.validationStatus,
                          fontSize: statusFontSize,
                          isSmallTablet: isSmallTablet,
                        ),
                        SizedBox(height: verticalSpacing * 0.5),
                        if (plan.userFullName != null)
                          _ClientPill(
                            clientName: plan.userFullName!,
                            fontSize: clientFontSize,
                            isLandscape: isLandscape,
                            isSmallTablet: isSmallTablet,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  _ValidationStatusIcon(
                    plan: plan,
                    isSelected: isSelected,
                    iconSize: iconSize,
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              // Plan name below status pills - takes available space but leaves room for date
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      plan.planName ??
                          AppLocalizations.of(context)!.unnamedPlan,
                      maxLines: titleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        fontSize: titleFontSize,
                      ),
                    ),
                    if (plan.generatedAt != null) ...[
                      SizedBox(height: isSmallTablet ? 1.0 : 2.0),
                      Text(
                        DateFormat.yMMMd(
                                Localizations.localeOf(context).toString())
                            .format(plan.generatedAt!
                                .getDateTimeInUtc()
                                .toLocal()),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: isSmallTablet 
                              ? (isLandscape ? 7.0 : 8.0)
                              : (isLandscape ? 8.0 : 9.0),
                          height: 1.0,
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
    );
  }
}

class _ValidationStatusIcon extends StatelessWidget {
  final MealPlan plan;
  final bool isSelected;
  final double iconSize;

  const _ValidationStatusIcon({
    required this.plan,
    required this.isSelected,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    Color bg;
    Color fg;

    switch (plan.validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        icon = Icons.verified_rounded;
        bg = Colors.green.shade600;
        fg = Colors.white;
        break;
      case MealPlanValidationStatus.PENDING_REVIEW:
        icon = Icons.pending_rounded;
        bg = Colors.orange.shade600;
        fg = Colors.white;
        break;
      case MealPlanValidationStatus.REJECTED:
        icon = Icons.cancel_rounded;
        bg = Colors.red.shade600;
        fg = Colors.white;
        break;
      default:
        icon = Icons.assignment_outlined;
        bg = colorScheme.surfaceContainerHigh;
        fg = colorScheme.onSurfaceVariant;
    }

    final containerSize =
        iconSize * 1.6; // Container is proportionally larger than icon

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: fg, size: iconSize),
    );
  }
}

class _ValidationStatusPill extends StatelessWidget {
  final MealPlanValidationStatus? validationStatus;
  final double fontSize;
  final bool isSmallTablet;

  const _ValidationStatusPill({
    required this.validationStatus,
    required this.fontSize,
    required this.isSmallTablet,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String label;
    Color bg;
    Color fg;

    switch (validationStatus) {
      case MealPlanValidationStatus.VALIDATED:
        label = l10n.validatedStatus;
        bg = Colors.green.withValues(alpha: isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.green[300]! : Colors.green[700]!;
        break;
      case MealPlanValidationStatus.PENDING_REVIEW:
        label = l10n.pendingReviewStatus;
        bg = Colors.orange.withValues(alpha: isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.orange[300]! : Colors.orange[700]!;
        break;
      case MealPlanValidationStatus.REJECTED:
        label = l10n.rejected;
        bg = Colors.red.withValues(alpha: isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.red[300]! : Colors.red[700]!;
        break;
      default:
        label = l10n.notValidatedStatus;
        bg = Colors.grey.withValues(alpha: isDark ? 0.2 : 0.12);
        fg = isDark ? Colors.grey[300]! : Colors.grey[700]!;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallTablet ? 6 : 8, 
        vertical: isSmallTablet ? 2 : 3
      ),
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
              fontSize: fontSize,
            ),
      ),
    );
  }
}

class _ClientPill extends StatelessWidget {
  final String clientName;
  final double fontSize;
  final bool isLandscape;
  final bool isSmallTablet;

  const _ClientPill({
    required this.clientName,
    required this.fontSize,
    required this.isLandscape,
    required this.isSmallTablet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallTablet ? 6 : 8, 
        vertical: isSmallTablet ? 2 : 3
      ),
      decoration: BoxDecoration(
        color:
            colorScheme.primaryContainer.withValues(alpha: isDark ? 0.3 : 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        clientName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontSize: fontSize,
            ),
        maxLines: isLandscape ? 1 : 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
