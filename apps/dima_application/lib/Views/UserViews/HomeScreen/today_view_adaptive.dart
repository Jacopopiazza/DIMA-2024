import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'today_view.dart';
import 'today_view_tablet.dart';

/// Picks the appropriate Today page implementation based on screen size.
/// - Phones: uses the existing `TodayPage` unchanged
/// - Tablets/iPads: uses a tablet-optimized layout with better use of screen space
class TodayPageAdaptive extends StatelessWidget {
  final VoidCallback? onNavigateToMealPlans;

  const TodayPageAdaptive({super.key, this.onNavigateToMealPlans});

  bool _isLargeLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // A conservative breakpoint that targets iPad in both orientations,
    // while keeping phones on the original page.
    // iPad portrait is ~768, landscape is >= 1024.
    const tabletBreakpoint = 768.0;
    return width >= tabletBreakpoint || kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLargeLayout(context)) {
      return TodayPageTablet(onNavigateToMealPlans: onNavigateToMealPlans);
    }
    return const TodayPage();
  }
}
