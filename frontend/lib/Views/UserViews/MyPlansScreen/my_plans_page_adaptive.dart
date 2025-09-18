import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'my_plans_page.dart';
import 'my_plans_page_tablet.dart';

/// Picks the appropriate My Plans page implementation based on screen size.
/// - Phones: uses the existing `MyPlansPage` unchanged
/// - Tablets/desktops: uses a tablet-optimized grid UI
class MyPlansPageAdaptive extends StatelessWidget {
  final bool showBackButton;

  const MyPlansPageAdaptive({super.key, this.showBackButton = false});

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
      return MyPlansPageTablet(showBackButton: showBackButton);
    }
    return MyPlansPage(showBackButton: showBackButton);
  }
}
