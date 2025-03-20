import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class NutritionistHomeScreen extends StatefulWidget {
  final bool isOffline;

  const NutritionistHomeScreen({super.key, this.isOffline = false});

  @override
  _NutritionistHomeScreenState createState() => _NutritionistHomeScreenState();
}

class _NutritionistHomeScreenState extends State<NutritionistHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Nutritionist Home Screen'),
      actions: [
        IconButton(
        icon: Icon(Icons.logout),
        onPressed: () async {
          try {
          // Add Amplify Auth signOut logic
          await Amplify.Auth.signOut();
          print('User signed out successfully');
          } catch (e) {
          print('Error signing out: $e');
          }
        },
        ),
      ],
      ),
      body: Center(
      child: Text('Nutritionist Home Screen'),
      ),
    );
  }
}
