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
    modelType: ModelProvider.instance.getModelTypeByModelName(
        'UserDetails'), // Make sure to update the model name
  );

  try {
    final response = await Amplify.API.query(request: request).response;
    final userDetails = response.data;

    if (userDetails != null) {
      safePrint(
          "Utente mangia ${userDetails.dailyMealsPreference} pasti al giorno");
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

Widget _buildFeatureItem(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green.shade600,
          size: 16,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.purple.shade700,
          ),
        ),
      ],
    ),
  );
}

void _showProSubscriptionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text("Upgrade to PRO"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose your PRO plan:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildPlanOption("Monthly", "\$9.99/month", "Best for trying out"),
            _buildPlanOption("Yearly", "\$99/year", "Save 17% (2 months free)"),
            _buildPlanOption("Lifetime", "\$299", "One-time payment"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement actual subscription logic
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Subscription feature coming soon!"),
                  backgroundColor: Colors.purple.shade600,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text("Subscribe"),
          ),
        ],
      );
    },
  );
}

Widget _buildPlanOption(String title, String price, String description) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.purple.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
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
            // PRO Plan Subscription Section
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "PRO Plan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Unlock premium features:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildFeatureItem("Expert meal planning validation"),
                  _buildFeatureItem("Personal nutritionist chat in-app"),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement PRO plan subscription logic
                        _showProSubscriptionDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upgrade, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Subscribe to PRO",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
