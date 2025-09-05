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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _profilePictureUrl;
  bool _isAvailable = true;
  bool _isSaving = false;

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
            _specializationController.text = profile?.specialization ?? '';
            _bioController.text = profile?.bio ?? '';
            _profilePictureUrl = profile?.profilePictureUrl;
            _isAvailable = profile?.isAvailable ?? true;
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

  Future<void> _saveInlineProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
    });
    try {
      final updatedProfile = await _profileService.updateMyProfile(
        specialization: _specializationController.text.trim(),
        bio: _bioController.text.trim(),
        profilePictureUrl: _profilePictureUrl,
        isAvailable: _isAvailable,
      );
      if (updatedProfile != null && mounted) {
        setState(() {
          _currentProfile = updatedProfile;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
                              return Center(
                                child: NutritionistProfileSection(
                                  profile: _currentProfile,
                                  onEditProfile: null,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Inline Edit Form as a styled section
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1)
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 0.3
                                        : 0.2),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.manage_accounts,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      const SizedBox(width: 8),
                                      Text('Edit Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        TextFormField(
                                          controller: _specializationController,
                                          decoration: const InputDecoration(
                                            labelText: 'Specialization',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.work),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter your specialization';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _bioController,
                                          decoration: const InputDecoration(
                                            labelText: 'Bio',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.description),
                                          ),
                                          maxLines: 4,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter your bio';
                                            }
                                            if (value.trim().length < 50) {
                                              return 'Bio should be at least 50 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        SwitchListTile(
                                          title: const Text(
                                              'Available for new clients'),
                                          subtitle: const Text(
                                              'Clients can request your services'),
                                          value: _isAvailable,
                                          onChanged: (value) {
                                            setState(() {
                                              _isAvailable = value;
                                            });
                                          },
                                          secondary:
                                              const Icon(Icons.visibility),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FilledButton.icon(
                                            onPressed: _isSaving
                                                ? null
                                                : _saveInlineProfile,
                                            icon: _isSaving
                                                ? const SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  )
                                                : const Icon(Icons.save),
                                            label: Text(_isSaving
                                                ? 'Saving...'
                                                : 'Save Changes'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
