import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Utils/user_type_enum.dart';
import 'package:dima_application/Views/UserViews/home_screen.dart';
import 'package:dima_application/Views/NutritionistViews/nutritionist_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTypeRouter extends StatelessWidget {
  const UserTypeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('Error: ${snapshot.error}')),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Amplify.Auth.signOut();
                    } catch (e) {
                      safePrint('Error during logout: $e');
                    }
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          );
        } else {
          final role = snapshot.data as String?;
          if (role == 'USER') {
            return UserHomeScreen();
          } else if (role == 'NUTRITIONIST') {
            return NutritionistHomeScreen();
          } else {
            return Center(
              child: Text('Unknown role'),
            );
          }
        }
      },
    );
  }

  Future<String?> _checkUserRole() async {
    // Key for storing the role in SharedPreferences
    const String roleKey = 'user_role';

    AuthUserAttribute role;

    try {
      // First attempt to get role from Amplify
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final roleAttribute = attributes.firstWhere(
        (attr) =>
            attr.userAttributeKey.key ==
            CognitoUserAttributeKey.custom('role').key,
        orElse: () => AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.custom('role'),
            value: ''),
      );

      safePrint('User role from Amplify: ${roleAttribute.value}');

      role = roleAttribute;
    } catch (e) {
      safePrint('Error checking user role from Amplify: $e');

      try {
        // If Amplify fails (likely due to no connection), try to get role from local storage
        final prefs = await SharedPreferences.getInstance();
        final localRole = prefs.getString(roleKey);

        if (localRole == null || localRole.isEmpty) {
          throw Exception(
              'User role stored locally is empty. This should never happen.');
        }
        safePrint('Using locally stored role: $localRole');
        return localRole;
      } catch (localError) {
        safePrint('Error retrieving role from local storage: $localError');
        throw Exception(
            'User role stored locally is invalid. This should never happen. Trying to log you out.');
      }
    }

    if (role.value.isEmpty) {
      throw Exception(
          'User role attribute is empty. This should never happen.');
    }

    if (!UserTypeEnum.contains(role.value)) {
      throw Exception('User role attribute is invalid: ${role.value}');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(roleKey, role.value);

    return role.value;
  }
}
