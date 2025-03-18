import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Future<void> _logout(BuildContext context) async {
  try {
    await Amplify.Auth.signOut();
    safePrint('Signed out');
  } on AuthException catch (e) {
    safePrint('Error signing out: $e');
  }
}

Future<void> _deleteAccount(BuildContext context) async {
  try {
    await Amplify.Auth.deleteUser();
    safePrint('Delete user succeeded');
  } on AuthException catch (e) {
    safePrint('Error deleting user : $e');
  }
}

Future<String?> fetchCurrentUser() async {
  try {
    final user = await Amplify.Auth.getCurrentUser();

    return user.username; // Return the username
  } catch (e) {
    debugPrint('Error fetching current user: $e');
    return null;
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<String?> user = fetchCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.jpeg'),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  return Text(userData,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
                } else {
                  return const Text("No data available");
                }
              },
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.signOut),
              onTap: () => _logout(context),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(
                "Delete Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                bool? confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Delete"),
                      content:
                          Text("Are you sure you want to delete your account?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
                if (confirm == true) {
                  _deleteAccount(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
