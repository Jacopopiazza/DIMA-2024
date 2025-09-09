import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dima_application/Views/Common/image_picker_widget.dart';
import 'package:dima_application/Views/Common/offline_screen.dart';
import 'package:dima_application/Views/NutritionistViews/enter_nutritionist_profile.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/availability_section.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/nutritionist_actions_section.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/nutritionist_location_section.dart';
import 'package:dima_application/Views/NutritionistViews/widgets/nutritionist_profile_section.dart';
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/services/connectivity_service.dart';
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

class _NutritionistSettingsPageState extends State<NutritionistSettingsPage>
    with SingleTickerProviderStateMixin {
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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;

    setState(() {
      _checkingProfile = true;
    });

    try {
      // First check if we have internet connectivity
      final connectivityService = ConnectivityService();
      final isConnected = await connectivityService.checkConnectivityManually();

      if (!isConnected) {
        // If no internet, don't proceed with profile validation
        if (mounted) {
          setState(() {
            _checkingProfile = false;
          });
        }
        return;
      }

      final profile = await _profileService.getMyProfile();
      if (mounted) {
        final isValid = await _profileService.hasValidProfile();
        if (!isValid) {
          // Only redirect to profile creation if we have internet connection
          // This prevents the offline redirect issue
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
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .errorUpdatingProfile(e.toString())),
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

  void _onProfilePictureChanged(String? newImageUrl) {
    setState(() {
      _profilePictureUrl = newImageUrl;
    });

    // If image was removed (set to null), reload profile from database to update info card
    if (newImageUrl == null) {
      _reloadProfileAfterImageRemoval();
    }
  }

  Future<void> _reloadProfileAfterImageRemoval() async {
    try {
      final updatedProfile = await _profileService.getMyProfile();
      if (updatedProfile != null && mounted) {
        setState(() {
          _currentProfile = updatedProfile;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      safePrint(
          '[NutritionistSettings] Error reloading profile after image removal: $e');
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
                    ? AppLocalizations.of(context)!.availableForConsultations
                    : AppLocalizations.of(context)!
                        .unavailableForConsultations),
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
              content: Text(AppLocalizations.of(context)!
                  .errorUpdatingAvailability(e.toString())),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _specializationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_checkingProfile) {
      return OfflineScreen(
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: _buildLoadingState(colorScheme, theme),
        ),
      );
    }

    return OfflineScreen(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: RefreshIndicator(
                onRefresh: _loadProfile,
                backgroundColor: colorScheme.surface,
                color: colorScheme.primary,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.opaque,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Header section
                      _buildHeaderSection(colorScheme, theme),
                      const SizedBox(height: 32),

                      // Profile Section (styled as card)
                      _buildProfileSection(colorScheme, theme),
                      const SizedBox(height: 24),

                      // Edit Form Section (styled as card)
                      _buildEditFormSection(colorScheme, theme),
                      const SizedBox(height: 24),

                      // Availability Section (wrapped in card style)
                      _buildAvailabilitySection(colorScheme, theme),
                      const SizedBox(height: 24),

                      // Location Section (styled as card)
                      const NutritionistLocationSection(),
                      const SizedBox(height: 24),

                      // Actions Section (wrapped in card style)
                      _buildActionsSection(colorScheme, theme),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.loadingNutritionistSettings,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_rounded,
              size: 32,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.nutritionistSettings,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.manageProfileMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.profileInformation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: NutritionistProfileSection(
                key: ValueKey(_currentProfile?.profilePictureUrl ?? 'no-image'),
                profile: _currentProfile,
                onEditProfile: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditFormSection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.editProfessionalDetails,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _specializationController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.specialization,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.work_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterSpecialization;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.professionalBio,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.description_rounded),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterBio;
                      }
                      if (value.trim().length < 50) {
                        return AppLocalizations.of(context)!.bioMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Profile Picture Section
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.profilePicture,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ImagePickerWidget(
                            initialImageUrl: _profilePictureUrl,
                            onImageChanged: _onProfilePictureChanged,
                            enabled: !_isSaving,
                            size: 120,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : _saveInlineProfile,
                      icon: _isSaving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(_isSaving
                          ? AppLocalizations.of(context)!.saving
                          : AppLocalizations.of(context)!.saveChanges),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilitySection(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.availabilitySettings,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AvailabilitySection(
              profile: _currentProfile,
              onAvailabilityChanged: _updateAvailability,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(ColorScheme colorScheme, ThemeData theme) {
    return const NutritionistActionsSection();
  }
}
