import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/Common/image_picker_widget.dart';
import 'package:dima_application/Views/Common/offline_screen.dart';
import 'package:dima_application/Views/NutritionistViews/nutritionist_home_screen.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/services/connectivity_service.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
import 'package:flutter/material.dart';

class EnterNutritionistProfile extends StatefulWidget {
  final bool isFromSettings;

  const EnterNutritionistProfile({super.key, this.isFromSettings = false});

  @override
  State<EnterNutritionistProfile> createState() =>
      _EnterNutritionistProfileState();
}

class _EnterNutritionistProfileState extends State<EnterNutritionistProfile> {
  final _formKey = GlobalKey<FormState>();
  final _specializationController = TextEditingController();
  final _bioController = TextEditingController();
  final _profilePictureUrlController = TextEditingController();
  String? _profilePictureUrl;
  bool _isAvailable = true;
  bool _isLoading = false;
  final _profileService = NutritionistProfileService();

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _specializationController.dispose();
    _bioController.dispose();
    _profilePictureUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final profile = await _profileService.getMyProfile();

      if (profile != null) {
        setState(() {
          _specializationController.text = profile.specialization ?? '';
          _bioController.text = profile.bio ?? '';
          _profilePictureUrlController.text = profile.profilePictureUrl ?? '';
          _profilePictureUrl = profile.profilePictureUrl;
          _isAvailable = profile.isAvailable ?? true;
        });
      }
    } catch (e) {
      safePrint('Error loading nutritionist profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    // Check connectivity before attempting to save
    final connectivityService = ConnectivityService();
    final isConnected = await connectivityService.checkConnectivityManually();

    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.noInternetConnection)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = await _profileService.updateMyProfile(
        specialization: _specializationController.text.trim(),
        bio: _bioController.text.trim(),
        profilePictureUrl: _profilePictureUrl,
        isAvailable: _isAvailable,
      );

      if (updatedProfile != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileSavedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate based on where this page was called from
          if (widget.isFromSettings) {
            // Return to settings page with success result
            Navigator.of(context).pop(true);
          } else {
            // Navigate directly to the nutritionist home screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const NutritionistHomeScreen(),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorSavingProfile),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorSavingProfileWith(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return OfflineScreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isFromSettings
              ? l10n.editProfile
              : l10n.completeYourProfile),
          automaticallyImplyLeading:
              widget.isFromSettings, // Allow back navigation from settings
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Information Section
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary
                          .withOpacity(isDark ? 0.3 : 0.2),
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
                            Icon(
                              Icons.medical_services,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.profileInformation,
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.welcomeCompleteProfile,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Specialization
                        TextFormField(
                          controller: _specializationController,
                          decoration: InputDecoration(
                            labelText: l10n.specialization,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.work),
                            hintText: l10n.specializationHint,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.pleaseEnterSpecialization;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Bio
                        TextFormField(
                          controller: _bioController,
                          decoration: InputDecoration(
                            labelText: l10n.bio,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.description),
                            hintText: l10n.bioHint,
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.pleaseEnterBio;
                            }
                            if (value.trim().length < 50) {
                              return l10n.bioTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Profile Picture Section
                        Center(
                          child: Column(
                            children: [
                              Text(
                                l10n.profilePicture,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ImagePickerWidget(
                                initialImageUrl: _profilePictureUrl,
                                onImageChanged: (url) {
                                  setState(() {
                                    _profilePictureUrl = url;
                                    _profilePictureUrlController.text =
                                        url ?? '';
                                  });
                                },
                                size: 120,
                                enabled: !_isLoading,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.tapToUploadProfilePicture,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Availability Toggle
                        SwitchListTile(
                          title: Text(l10n.availableForNewClients),
                          subtitle: Text(l10n.clientsCanRequestServices),
                          value: _isAvailable,
                          onChanged: (value) {
                            setState(() {
                              _isAvailable = value;
                            });
                          },
                          secondary: const Icon(Icons.visibility),
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    widget.isFromSettings
                                        ? l10n.updateProfile
                                        : l10n.saveProfile,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
