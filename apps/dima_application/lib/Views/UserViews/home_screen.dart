import 'package:dima_application/Views/UserViews/SettingsScreen/settings_view.dart';
import 'package:dima_application/Views/UserViews/my_plans_page.dart';
import 'package:flutter/material.dart';

import 'HomeScreen/today_view.dart'; // Assuming this path is correct

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0; // Start with the 'Today' tab (index 0)

  // List of widgets to display based on the selected tab
  // Making it static const improves performance as it's created only once.
  static const List<Widget> _widgetOptions = <Widget>[
    TodayPage(), // Index 0
    MyPlansPage(), // Index 1
    SettingsPage(), // Index 2
  ];

  // Callback function when a bottom navigation item is tapped
  void _onItemTapped(int index) {
    // Update the state to rebuild the widget with the new selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using SafeArea to avoid intrusions by system UI (like notches or status bars)
      body: SafeArea(
        // Display the widget corresponding to the currently selected index
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Use the helper method to build the bottom navigation bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Helper method to build the BottomNavigationBar
  BottomNavigationBar _buildBottomNavigationBar() {
    // The appearance (colors, elevation, etc.) is controlled by
    // the BottomNavigationBarThemeData defined in your app's ThemeData.
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny_outlined), // Icon when tab is inactive
          activeIcon: Icon(Icons.wb_sunny),      // Icon when tab is active
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book),
          label: 'Meal Plans',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex, // Highlights the current tab
      onTap: _onItemTapped,         // Callback when a tab is tapped
      type: BottomNavigationBarType.fixed, // Ensures all items are visible with labels
      showUnselectedLabels: true,      // Keep labels visible even for unselected items
      // No hardcoded colors or elevation here - relies on the theme!
    );
  }
}