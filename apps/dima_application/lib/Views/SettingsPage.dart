import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> _logout(BuildContext context) async {
  try {
    await Amplify.Auth.signOut();
    safePrint('Signed out');
  } on AuthException catch (e) {
    safePrint('Error signing out: $e');
  }
}

Future<void> _delete_account(BuildContext context) async {
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

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Settings'),
        ElevatedButton(
          onPressed: () => _logout(context),
          child: Text(AppLocalizations.of(context)!.signOut),
        ),
        ElevatedButton(
          onPressed: () => _delete_account(context),
          child: Text("Delete Account"),
        ),
        FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final userData = snapshot.data!;
                return Text(userData);
              } else {
                return const Text("No data available");
              }
            }),
      ]),
    );
  }
}
