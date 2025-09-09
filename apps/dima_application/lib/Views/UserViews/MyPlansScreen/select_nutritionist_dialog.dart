import 'package:dima_application/generated/flutter-models/NutritionistProfile.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
import 'package:flutter/material.dart';

class SelectNutritionistDialog extends StatefulWidget {
  final String mealPlanId;
  final String planName;
  final Future<List<NutritionistProfile>> Function() onLoadNutritionists;
  final Future<bool> Function(String, String) onAssignNutritionist;

  const SelectNutritionistDialog({
    super.key,
    required this.mealPlanId,
    required this.planName,
    required this.onLoadNutritionists,
    required this.onAssignNutritionist,
  });

  @override
  State<SelectNutritionistDialog> createState() =>
      _SelectNutritionistDialogState();
}

class _SelectNutritionistDialogState extends State<SelectNutritionistDialog> {
  List<NutritionistProfile> _nutritionists = [];
  bool _isLoading = true;
  bool _isAssigning = false;
  String? _selectedNutritionistId;

  @override
  void initState() {
    super.initState();
    _loadNutritionists();
  }

  Future<void> _loadNutritionists() async {
    try {
      print('[SelectNutritionistDialog] Loading nutritionists...');
      final nutritionists = await widget.onLoadNutritionists();
      print(
          '[SelectNutritionistDialog] Loaded ${nutritionists.length} nutritionists');

      // Debug log each nutritionist's profile picture URL
      for (int i = 0; i < nutritionists.length; i++) {
        final nutritionist = nutritionists[i];
        print('[SelectNutritionistDialog] Nutritionist $i:');
        print('  - Name: ${nutritionist.givenName} ${nutritionist.familyName}');
        print('  - Profile Picture URL: "${nutritionist.profilePictureUrl}"');
        print('  - Is Available: ${nutritionist.isAvailable}');
        print('  - Address: "${nutritionist.address}"');
      }

      if (mounted) {
        setState(() {
          _nutritionists = nutritionists;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.errorLoadingNutritionists +
                    e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _assignNutritionist() async {
    if (_selectedNutritionistId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.pleaseSelectNutritionist),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Check if selected nutritionist is available
    final selectedNutritionist = _nutritionists.firstWhere(
      (n) => n.nutritionistId == _selectedNutritionistId,
    );

    if (selectedNutritionist.isAvailable != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.nutritionistNotAvailable),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isAssigning = true;
      });
    }

    try {
      final success = await widget.onAssignNutritionist(
        widget.mealPlanId,
        _selectedNutritionistId!,
      );

      if (mounted) {
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.validationRequestSent),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.failedToSendValidationRequest),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.errorSendingValidationRequest +
                    e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
      }
    }
  }

  bool _isSelectedNutritionistUnavailable() {
    if (_selectedNutritionistId == null) return false;

    final selectedNutritionist = _nutritionists.firstWhere(
      (n) => n.nutritionistId == _selectedNutritionistId,
      orElse: () => NutritionistProfile(
        nutritionistId: '',
        givenName: '',
        familyName: '',
        specialization: '',
        bio: '',
        isAvailable: false,
      ),
    );

    return selectedNutritionist.isAvailable != true;
  }

  Widget _buildProfileImage(String? imageUrlOrKey, {double size = 60}) {
    return NutritionistProfileImage(
      imageUrlOrKey: imageUrlOrKey,
      size: size,
    );
  }

  Widget _buildNutritionistCard(NutritionistProfile nutritionist) {
    final isSelected = _selectedNutritionistId == nutritionist.nutritionistId;
    final isUnavailable = nutritionist.isAvailable != true;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isUnavailable
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
          : isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
      elevation: isSelected ? 2 : 1,
      child: InkWell(
        onTap: isUnavailable
            ? null
            : () {
                if (mounted) {
                  setState(() {
                    _selectedNutritionistId = nutritionist.nutritionistId;
                  });
                }
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              _buildProfileImage(nutritionist.profilePictureUrl),
              const SizedBox(width: 16),

              // Nutritionist Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      '${nutritionist.givenName ?? ''} ${nutritionist.familyName ?? ''}'
                          .trim(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isUnavailable
                            ? colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6)
                            : isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Specialization/Role
                    if (nutritionist.specialization != null &&
                        nutritionist.specialization!.isNotEmpty)
                      Text(
                        nutritionist.specialization!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isUnavailable
                              ? colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    // Bio (truncated)
                    if (nutritionist.bio != null &&
                        nutritionist.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          nutritionist.bio!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isUnavailable
                                ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Address
                    if (nutritionist.address != null &&
                        nutritionist.address!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: isUnavailable
                                  ? colorScheme.onSurfaceVariant
                                      .withOpacity(0.5)
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                nutritionist.address!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isUnavailable
                                      ? colorScheme.onSurfaceVariant
                                          .withOpacity(0.5)
                                      : colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Availability Status
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            nutritionist.isAvailable == true
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 16,
                            color: nutritionist.isAvailable == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            nutritionist.isAvailable == true
                                ? AppLocalizations.of(context)!.available
                                : AppLocalizations.of(context)!.unavailable,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: nutritionist.isAvailable == true
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.requestNutritionistValidation),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .selectNutritionistToReview(widget.planName),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_nutritionists.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noNutritionistsAvailable,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _nutritionists.length,
                  itemBuilder: (context, index) {
                    final nutritionist = _nutritionists[index];
                    return _buildNutritionistCard(nutritionist);
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAssigning ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _isAssigning ||
                  _selectedNutritionistId == null ||
                  _isSelectedNutritionistUnavailable()
              ? null
              : _assignNutritionist,
          child: _isAssigning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.requestValidationButton),
        ),
      ],
    );
  }
}

/// Widget to handle S3 key resolution for nutritionist profile images
class NutritionistProfileImage extends StatefulWidget {
  final String? imageUrlOrKey;
  final double size;

  const NutritionistProfileImage({
    super.key,
    required this.imageUrlOrKey,
    this.size = 60,
  });

  @override
  State<NutritionistProfileImage> createState() =>
      _NutritionistProfileImageState();
}

class _NutritionistProfileImageState extends State<NutritionistProfileImage> {
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
  void didUpdateWidget(NutritionistProfileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrlOrKey != oldWidget.imageUrlOrKey) {
      _resolveProfileImage();
    }
  }

  Future<void> _resolveProfileImage() async {
    if (widget.imageUrlOrKey == null || widget.imageUrlOrKey!.isEmpty) {
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
      if (widget.imageUrlOrKey!.startsWith('http')) {
        // Already a URL
        _resolvedImageUrl = widget.imageUrlOrKey!;
      } else {
        // S3 key, resolve to URL
        _resolvedImageUrl = await _profileService
            .getUrlForProfilePicture(widget.imageUrlOrKey!);
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

    // Show loading state
    if (_isLoadingImage) {
      return Container(
        width: widget.size,
        height: widget.size,
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
        child: Image.network(
          _resolvedImageUrl!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default avatar on error
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: widget.size * 0.5,
                color: theme.colorScheme.onErrorContainer,
              ),
            );
          },
        ),
      );
    }

    // Show fallback icon
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
