import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'validate_plans_page.dart';
import 'validate_plans_page_tablet.dart';

/// Picks the appropriate Validate Plans page implementation based on screen size.
/// - Phones: uses the existing `ValidatePlansPage` unchanged
/// - Tablets/desktops: uses a tablet-optimized dual-pane UI
class ValidatePlansPageAdaptive extends StatelessWidget {
  const ValidatePlansPageAdaptive({super.key});

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
      return const ValidatePlansPageTablet();
    }
    return const ValidatePlansPage();
  }
}
