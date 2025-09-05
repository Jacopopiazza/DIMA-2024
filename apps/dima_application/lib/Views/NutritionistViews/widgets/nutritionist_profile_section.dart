import 'package:flutter/material.dart';

import '../../../generated/flutter-models/NutritionistProfile.dart';
import '../../Common/network_image_with_retry.dart';

class NutritionistProfileSection extends StatelessWidget {
  final NutritionistProfile? profile;
  final VoidCallback? onEditProfile;

  const NutritionistProfileSection({
    Key? key,
    required this.profile,
    this.onEditProfile,
  }) : super(key: key);

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
            // Profile Picture with auto-retry for expired URLs
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: profile?.profilePictureUrl != null
                  ? ClipOval(
                      child: NetworkImageWithRetry(
                        imageUrl: profile!.profilePictureUrl!,
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
                    )
                  : Icon(
                      Icons.person,
                      size: 50,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
            ),
            const SizedBox(height: 16),

            // Full Name
            if (profile != null &&
                (profile!.givenName != null || profile!.familyName != null))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${profile!.givenName ?? ''} ${profile!.familyName ?? ''}'
                      .trim(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Specialization
            if (profile?.specialization != null &&
                profile!.specialization!.isNotEmpty)
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
                    profile!.specialization!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            // Bio
            if (profile?.bio != null && profile!.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  profile!.bio!,
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
            if (onEditProfile != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onEditProfile,
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
}
