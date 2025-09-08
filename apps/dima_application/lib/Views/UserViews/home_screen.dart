import 'package:dima_application/Views/Common/in_app_notification.dart';
import 'package:dima_application/Views/UserViews/MyPlansScreen/my_plans_page_adaptive.dart';
import 'package:dima_application/Views/UserViews/SettingsScreen/settings_screen_riverpod.dart';
import 'package:dima_application/providers/meal_plan_notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';

import 'HomeScreen/today_view_adaptive.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {
  int _selectedIndex = 0; // Start with the 'Today' tab (index 0)

  @override
  void initState() {
    super.initState();
    // Initialize current page state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Since we start at index 0 (TodayPage), set currentPage to null
        ref.read(currentPageProvider.notifier).state = null;
      }
    });
  }

  // Method to get widgets with navigation callbacks
  List<Widget> _getWidgetOptions() {
    return [
      TodayPageAdaptive(onNavigateToMealPlans: () => _onItemTapped(1)), // Index 0 (adaptive: phone vs tablet)
      const MyPlansPageAdaptive(), // Index 1 (adaptive: phone vs tablet)
      const SettingsScreenRiverpod(), // Index 2 - Using the new Riverpod version
    ];
  }

  // Callback function when a bottom navigation item is tapped
  void _onItemTapped(int index) {
    // Update the state to rebuild the widget with the new selected index
    setState(() {
      _selectedIndex = index;
    });

    // Update current page for notification handling
    final pageName = index == 1 ? 'MyPlansPage' : null;
    ref.read(currentPageProvider.notifier).state = pageName;
  }

  @override
  Widget build(BuildContext context) {
    // Listen for meal plan notifications and show in-app notifications when NOT on MyPlansPage
    ref.listen<NotificationState>(mealPlanNotificationProvider,
        (previous, current) {
      if (!mounted) return;
      if (current.hasUnreadNotifications && current.notifications.isNotEmpty) {
        final latestNotification = current.notifications.last;
        final currentPage = ref.read(currentPageProvider);

        // Defer UI/provider changes to next frame to avoid build-phase mutations
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (currentPage != 'MyPlansPage') {
            InAppNotificationManager.show(
              context,
              latestNotification,
              onTap: () {
                InAppNotificationManager.hide();
                setState(() {
                  _selectedIndex = 1; // Navigate to Meal Plans tab
                });
                // Defer marking notifications as read outside build lifecycle
                Future.microtask(() {
                  if (!mounted) return;
                  ref
                      .read(mealPlanNotificationProvider.notifier)
                      .markAllAsRead();
                });
              },
            );
          }
        });
      }
    });

    return Scaffold(
      // Using SafeArea to avoid intrusions by system UI (like notches or status bars)
      body: SafeArea(
        // Display the widget corresponding to the currently selected index
        child: _getWidgetOptions().elementAt(_selectedIndex),
      ),
      /*
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final test = MealPlanNotification(
            mealPlanId: 'test-${DateTime.now().millisecondsSinceEpoch}',
            message: 'This is a test notification. Tap to open Meal Plans.',
            success: true,
            timestamp: DateTime.now(),
          );
          InAppNotificationManager.show(
            context,
            test,
            onTap: () {
              InAppNotificationManager.hide();
              setState(() {
                _selectedIndex = 1; // Navigate to Meal Plans tab
              });
            },
          );
        },
        icon: const Icon(Icons.notifications_active),
        label: const Text('Test notification'),
      ),
      */
      // Use the helper method to build the bottom navigation bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Helper method to build the BottomNavigationBar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny_outlined), // Icon when tab is inactive
          activeIcon: Icon(Icons.wb_sunny), // Icon when tab is active
          label: AppLocalizations.of(context)!.today,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book),
          label: AppLocalizations.of(context)!.mealPlans,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings,
        ),
      ],
      currentIndex: _selectedIndex, // Highlights the current tab
      onTap: _onItemTapped, // Callback when a tab is tapped
      type: BottomNavigationBarType
          .fixed, // Ensures all items are visible with labels
      showUnselectedLabels:
          true, // Keep labels visible even for unselected items
    );
  }
}
