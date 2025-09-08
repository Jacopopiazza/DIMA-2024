import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/Common/offline_screen.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/services/connectivity_service.dart';
import 'package:flutter/material.dart';

import 'nutritionist_settings_page.dart';
import 'validate_plans_page_adaptive.dart';

class NutritionistHomeScreen extends StatefulWidget {
  final bool isOffline;

  const NutritionistHomeScreen({super.key, this.isOffline = false});

  @override
  _NutritionistHomeScreenState createState() => _NutritionistHomeScreenState();
}

Future<void> signOutGlobally() async {
  final result = await Amplify.Auth.signOut(
    options: const SignOutOptions(globalSignOut: true),
  );
  if (result is CognitoCompleteSignOut) {
    safePrint('Sign out completed successfully');
  } else if (result is CognitoPartialSignOut) {
    final globalSignOutException = result.globalSignOutException!;
    final accessToken = globalSignOutException.accessToken;
    // Retry the global sign out using the access token, if desired
    // ...
    safePrint('Error signing user out: ${globalSignOutException.message}');
  } else if (result is CognitoFailedSignOut) {
    safePrint('Error signing user out: ${result.exception.message}');
  }
}

class _NutritionistHomeScreenState extends State<NutritionistHomeScreen> {
  int _selectedIndex = 0; // Start with the 'Validate Plans' tab (index 0)

  @override
  void initState() {
    super.initState();
    // Initialize connectivity service
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    await ConnectivityService().initialize();
  }

  @override
  void dispose() {
    ConnectivityService().dispose();
    super.dispose();
  }

  // List of widgets to display based on the selected tab
  static final List<Widget> _widgetOptions = <Widget>[
    ValidatePlansPageAdaptive(), // Index 0
    NutritionistSettingsPage(), // Index 1
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
    return OfflineScreen(
      child: Scaffold(
        // Using SafeArea to avoid intrusions by system UI (like notches or status bars)
        body: SafeArea(
          // Display the widget corresponding to the currently selected index
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        // Use the helper method to build the bottom navigation bar
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Helper method to build the BottomNavigationBar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.assignment_outlined),
          activeIcon: const Icon(Icons.assignment),
          label: AppLocalizations.of(context)!.validatePlans,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
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
