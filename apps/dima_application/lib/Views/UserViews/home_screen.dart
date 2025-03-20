import 'package:dima_application/Views/UserViews/my_plans_page.dart';
import 'package:dima_application/Views/UserViews/new_plans_page.dart';
import 'package:dima_application/Views/UserViews/settings_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool isOffline;

  const HomeScreen({super.key, this.isOffline = false});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define the pages for each tab
  final List<Widget> _pages = [
    NewPlansPage(),
    MyPlansPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
