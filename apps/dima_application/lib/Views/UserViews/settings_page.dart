import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
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

Future<void> _getData() async {
  final request = GraphQLRequest<UserDetails>(
    document: '''
    query GetMyUserDetails {
      getMyUserDetails {
        userId
        allergens
        mealsPerDay
        weight
        frequencyExercise
        // Include any other fields from your new UserDetails type
      }
    }
    ''',
    decodePath: 'getMyUserDetails',
    modelType:
      ModelProvider.instance.getModelTypeByModelName('UserDetails'), // Make sure to update the model name
  );
  
  try {
    final response = await Amplify.API.query(request: request).response;
    final userDetails = response.data;
    
    if (userDetails != null) {
      safePrint("Utente mangia ${userDetails.dailyMealsPreference} pasti al giorno");
    } else {
      safePrint("Nessun dettaglio utente trovato");
    }
  } catch (e) {
    safePrint("Errore nel recupero dei dettagli utente: $e");
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

Future<void> _printUserInfo() async {
  try {
    // Get current auth session
    final session = await Amplify.Auth.fetchAuthSession();
    print('User is signed in: ${session.isSignedIn}');

    // Get current user attributes
    final attributes = await Amplify.Auth.fetchUserAttributes();
    print('User attributes:');
    for (final attribute in attributes) {
      print('${attribute.userAttributeKey}: ${attribute.value}');
    }

    // Get user details
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      print('Username: ${currentUser.username}');
      print('User ID: ${currentUser.userId}');
    } catch (e) {
      print('Error getting current user: $e');
    }
  } catch (e) {
    print('Error fetching user info: $e');
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<String?> user = fetchCurrentUser();
    _printUserInfo();
    _getData();

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
              onTap: () => signOutGlobally(),
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
