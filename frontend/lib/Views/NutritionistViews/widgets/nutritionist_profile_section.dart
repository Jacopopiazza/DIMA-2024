import 'package:flutter/material.dart';

import '../../../generated/flutter-models/NutritionistProfile.dart';
import '../../../services/nutritionist_profile_service.dart';
import '../../Common/network_image_with_retry.dart';

class NutritionistProfileSection extends StatefulWidget {
  final NutritionistProfile? profile;
  final VoidCallback? onEditProfile;

  const NutritionistProfileSection({
    Key? key,
    required this.profile,
    this.onEditProfile,
  }) : super(key: key);

  @override
  State<NutritionistProfileSection> createState() =>
      _NutritionistProfileSectionState();
}

class _NutritionistProfileSectionState
    extends State<NutritionistProfileSection> {
  String? _resolvedImageUrl;
  bool _isLoadingImage = false;
  final NutritionistProfileService _profileService =
      NutritionistProfileService();

  @override
  void initState() {
    super.initState();
    _resolveProfileImage();
  }

  @override
  void didUpdateWidget(NutritionistProfileSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile?.profilePictureUrl !=
        oldWidget.profile?.profilePictureUrl) {
      _resolveProfileImage();
    }
  }

  Future<void> _resolveProfileImage() async {
    if (widget.profile?.profilePictureUrl == null ||
        widget.profile!.profilePictureUrl!.isEmpty) {
      setState(() {
        _resolvedImageUrl = null;
        _isLoadingImage = false;
      });
      return;
    }

    setState(() {
      _isLoadingImage = true;
    });

    try {
      if (widget.profile!.profilePictureUrl!.startsWith('http')) {
        // Already a URL
        _resolvedImageUrl = widget.profile!.profilePictureUrl!;
      } else {
        // S3 key, resolve to URL
        _resolvedImageUrl = await _profileService
            .getUrlForProfilePicture(widget.profile!.profilePictureUrl!);
      }
    } catch (e) {
      debugPrint('Error resolving profile image: $e');
      _resolvedImageUrl = null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with S3 key resolution
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: _buildProfileImage(theme),
            ),
            const SizedBox(height: 16),

            // Full Name
            if (widget.profile != null &&
                (widget.profile!.givenName != null ||
                    widget.profile!.familyName != null))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${widget.profile!.givenName ?? ''} ${widget.profile!.familyName ?? ''}'
                      .trim(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Specialization
            if (widget.profile?.specialization != null &&
                widget.profile!.specialization!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    widget.profile!.specialization!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Bio
            if (widget.profile?.bio != null && widget.profile!.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  widget.profile!.bio!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const SizedBox(height: 20),

            // Edit Profile Button (optional)
            if (widget.onEditProfile != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onEditProfile,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(ThemeData theme) {
    // Show loading state
    if (_isLoadingImage) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    // Show resolved image
    if (_resolvedImageUrl != null) {
      return ClipOval(
        child: NetworkImageWithRetry(
          imageUrl: _resolvedImageUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          placeholder: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          errorWidget: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      );
    }

    // Show fallback icon
    return Icon(
      Icons.person,
      size: 50,
      color: theme.colorScheme.onPrimaryContainer,
    );
  }
}
