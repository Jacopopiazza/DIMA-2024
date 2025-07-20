import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/NutritionistViews/enter_nutritionist_profile.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
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

class NutritionistSettingsPage extends StatefulWidget {
  const NutritionistSettingsPage({super.key});

  @override
  State<NutritionistSettingsPage> createState() =>
      _NutritionistSettingsPageState();
}

class _NutritionistSettingsPageState extends State<NutritionistSettingsPage> {
  final NutritionistProfileService _profileService =
      NutritionistProfileService();
  NutritionistProfile? _currentProfile;
  bool _isLoading = false;
  bool _checkingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _printUserInfo();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _checkingProfile = true;
    });

    try {
      final profile = await _profileService.getMyProfile();
      if (mounted) {
        final isValid = await _profileService.hasValidProfile();
        if (!isValid) {
          // Redirect to profile creation page and prevent further interaction
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const EnterNutritionistProfile(isFromSettings: true),
            ),
          );
        } else {
          setState(() {
            _currentProfile = profile;
            _isLoading = false;
            _checkingProfile = false;
          });
        }
      }
    } catch (e) {
      safePrint('Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _checkingProfile = false;
        });
      }
    }
  }

  Future<void> _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EnterNutritionistProfile(isFromSettings: true),
      ),
    );
    if (result == true && mounted) {
      // Refresh profile data after editing
      _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Future<String?> user = fetchCurrentUser();

    if (_checkingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: _currentProfile?.profilePictureUrl != null
                  ? NetworkImage(_currentProfile!.profilePictureUrl!)
                  : const AssetImage('assets/profile_picture.jpeg')
                      as ImageProvider,
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  return Text(
                    userData,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  );
                } else {
                  return const Text("No data available");
                }
              },
            ),
            if (_currentProfile != null) ...[
              const SizedBox(height: 5),
              Text(
                '${_currentProfile!.givenName ?? ''} ${_currentProfile!.familyName ?? ''}'
                    .trim(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (_currentProfile!.specialization != null) ...[
                const SizedBox(height: 5),
                Text(
                  _currentProfile!.specialization!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ],
            const SizedBox(height: 20),
            const Divider(),

            // Profile Section
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Edit Profile"),
              subtitle:
                  const Text("Update your nutritionist profile information"),
              onTap: _editProfile,
            ),

            // Availability Toggle
            if (_currentProfile != null)
              SwitchListTile(
                title: const Text("Available for Consultations"),
                subtitle: const Text("Toggle your availability status"),
                value: _currentProfile!.isAvailable ?? false,
                onChanged: (bool value) async {
                  if (_currentProfile != null) {
                    try {
                      final updatedProfile =
                          await _profileService.updateMyProfile(
                        givenName: _currentProfile!.givenName ?? '',
                        familyName: _currentProfile!.familyName ?? '',
                        specialization: _currentProfile!.specialization ?? '',
                        bio: _currentProfile!.bio ?? '',
                        profilePictureUrl: _currentProfile!.profilePictureUrl,
                        isAvailable: value,
                      );

                      if (updatedProfile != null && mounted) {
                        setState(() {
                          _currentProfile = updatedProfile;
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value
                                  ? 'You are now available'
                                  : 'You are now unavailable'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error updating availability: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),

            const Divider(),

            // Account Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.signOut),
              onTap: () => signOutGlobally(),
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
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
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete your account? This action cannot be undone."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete"),
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
