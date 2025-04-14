import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Nutritionist Home Screen'),
      actions: [
        IconButton(
        icon: Icon(Icons.logout),
        onPressed: () async {
         await signOutGlobally();
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
