import 'package:flutter/material.dart';

import '../../../generated/flutter-models/NutritionistProfile.dart';

class NutritionistProfileSection extends StatelessWidget {
  final NutritionistProfile? profile;
  final String? username;
  final VoidCallback onEditProfile;

  const NutritionistProfileSection({
    Key? key,
    required this.profile,
    required this.username,
    required this.onEditProfile,
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
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: profile?.profilePictureUrl != null
                  ? NetworkImage(profile!.profilePictureUrl!)
                  : const AssetImage('assets/profile_picture.jpeg')
                      as ImageProvider,
              child: profile?.profilePictureUrl == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: theme.colorScheme.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            // Username
            if (username != null)
              Text(
                username!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

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

            // Edit Profile Button
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
