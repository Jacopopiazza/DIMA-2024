import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/NutritionistViews/enter_nutritionist_profile.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/availability_section.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/nutritionist_actions_section.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/nutritionist_profile_section.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
import 'package:flutter/material.dart';

Future<String?> fetchCurrentUser() async {
  try {
    final user = await Amplify.Auth.getCurrentUser();
    return user.username; // Return the username
  } catch (e) {
    debugPrint('Error fetching current user: $e');
    return null;
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
  bool _checkingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;

    setState(() {
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
            _checkingProfile = false;
          });
        }
      }
    } catch (e) {
      safePrint('Error loading profile: $e');
      if (mounted) {
        setState(() {
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

  Future<void> _updateAvailability(bool value) async {
    if (_currentProfile != null) {
      try {
        final updatedProfile = await _profileService.updateMyProfile(
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
                    ? 'You are now available for consultations'
                    : 'You are now unavailable for consultations'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
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
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
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
      body: SafeArea(
        child: RefreshIndicator(
          displacement: 60.0,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onRefresh: _loadProfile,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Section
                          FutureBuilder<String?>(
                            future: user,
                            builder: (context, snapshot) {
                              final username = snapshot.data;
                              return NutritionistProfileSection(
                                profile: _currentProfile,
                                username: username,
                                onEditProfile: _editProfile,
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Availability Section
                          AvailabilitySection(
                            profile: _currentProfile,
                            onAvailabilityChanged: _updateAvailability,
                          ),

                          const SizedBox(height: 24),

                          // Actions and Danger Zone
                          const NutritionistActionsSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
