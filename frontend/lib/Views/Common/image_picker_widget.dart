import 'dart:io';

import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:dima_application/services/image_upload_service.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'network_image_with_retry.dart';

/// A reusable widget for picking and displaying profile images
/// Works with S3 keys stored in the database and resolves them to URLs for display
class ImagePickerWidget extends StatefulWidget {
  final String? initialImageUrl; // Can be either S3 key or URL
  final Function(String?) onImageChanged; // Returns S3 key to store
  final double size;
  final bool enabled;

  const ImagePickerWidget({
    super.key,
    this.initialImageUrl,
    required this.onImageChanged,
    this.size = 120,
    this.enabled = true,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? _currentImageUrl; // The resolved URL for display
  String? _currentS3Key; // The S3 key stored in database
  XFile? _pendingImageFile;
  bool _isUploading = false;
  bool _isLoadingUrl = false;
  final ImageUploadService _imageUploadService = ImageUploadService();
  final NutritionistProfileService _profileService =
      NutritionistProfileService();

  @override
  void initState() {
    super.initState();
    _resolveInitialImage();
  }

  @override
  void didUpdateWidget(ImagePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImageUrl != oldWidget.initialImageUrl) {
      setState(() {
        _currentImageUrl = null;
        _currentS3Key = null;
        _pendingImageFile = null;
      });
      _resolveInitialImage();
    }
  }

  Future<void> _resolveInitialImage() async {
    if (widget.initialImageUrl == null || widget.initialImageUrl!.isEmpty) {
      setState(() {
        _currentImageUrl = null;
        _currentS3Key = null;
        _isLoadingUrl = false;
      });
      return;
    }

    setState(() {
      _isLoadingUrl = true;
    });

    try {
      if (widget.initialImageUrl!.startsWith('http')) {
        // It's already a URL, extract S3 key for storage
        _currentImageUrl = widget.initialImageUrl;
        _currentS3Key =
            _imageUploadService.extractS3KeyFromUrl(widget.initialImageUrl!);
      } else {
        // It's an S3 key, resolve to URL
        _currentS3Key = widget.initialImageUrl;
        _currentImageUrl = await _profileService
            .getUrlForProfilePicture(widget.initialImageUrl!);

        // If resolution fails (returns null), treat as no image
        if (_currentImageUrl == null) {
          _currentS3Key = null;
        }
      }
    } catch (e) {
      debugPrint('Error resolving image: $e');
      // Reset to no image state on any error
      _currentImageUrl = null;
      _currentS3Key = null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUrl = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (!widget.enabled || _isUploading) return;

    try {
      // Show image source selection
      final XFile? imageFile = await _showImageSourceDialog();
      if (imageFile == null) return;

      setState(() {
        _pendingImageFile = imageFile;
        _isUploading = true;
      });

      // Upload the image and get S3 key
      final s3Key = await _imageUploadService.uploadProfilePicture(imageFile);

      if (s3Key != null) {
        // Resolve S3 key to URL for display
        final resolvedUrl =
            await _profileService.getUrlForProfilePicture(s3Key);

        setState(() {
          _currentS3Key = s3Key;
          _currentImageUrl = resolvedUrl;
          _pendingImageFile = null;
        });

        // Pass S3 key to parent (to store in database)
        widget.onImageChanged(s3Key);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .errorUploadingImage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _pendingImageFile = null;
        });
      }
    }
  }

  Future<void> _removeImage() async {
    if (!widget.enabled || _isUploading) return;

    try {
      if (_currentS3Key != null) {
        setState(() {
          _isUploading = true;
        });

        await _imageUploadService.deleteProfilePicture(_currentS3Key!);
      }

      setState(() {
        _currentImageUrl = null;
        _currentS3Key = null;
        _pendingImageFile = null;
      });
      widget.onImageChanged(null);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.errorRemovingImage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<XFile?> _showImageSourceDialog() async {
    final theme = Theme.of(context);

    return showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        AppLocalizations.of(context)!.selectPhoto,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Options
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Gallery option
                          _buildImageSourceOption(
                            context: context,
                            icon: Icons.photo_library,
                            title:
                                AppLocalizations.of(context)!.chooseFromGallery,
                            subtitle: AppLocalizations.of(context)!
                                .selectFromExistingPhotos,
                            onTap: () async {
                              final image = await _imageUploadService.pickImage(
                                  source: ImageSource.gallery);
                              if (context.mounted) {
                                Navigator.of(context).pop(image);
                              }
                            },
                          ),

                          if (_currentImageUrl != null) ...[
                            const SizedBox(height: 8),
                            // Remove option
                            _buildImageSourceOption(
                              context: context,
                              icon: Icons.delete_outline,
                              title: AppLocalizations.of(context)!.removePhoto,
                              subtitle: AppLocalizations.of(context)!
                                  .deleteCurrentProfilePicture,
                              isDestructive: true,
                              onTap: () {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                                _removeImage();
                              },
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Cancel button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color =
        isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? color : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Profile Picture Container
        GestureDetector(
          onTap: widget.enabled ? _pickAndUploadImage : null,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 2,
              ),
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  // Image display
                  _buildImageDisplay(theme),

                  // Upload/Loading overlay
                  if (_isUploading || _isLoadingUrl)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),

                  // Plus icon overlay when no image
                  if (_currentImageUrl == null &&
                      _pendingImageFile == null &&
                      !_isUploading &&
                      !_isLoadingUrl)
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: widget.size * 0.4,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Simple instruction text
        if (_currentImageUrl == null)
          Text(
            AppLocalizations.of(context)!.tapToSelectPhoto,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildImageDisplay(ThemeData theme) {
    // Show pending local image
    if (_pendingImageFile != null) {
      return Image.file(
        File(_pendingImageFile!.path),
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
      );
    }

    // Show current network image with auto-retry
    if (_currentImageUrl != null) {
      return NetworkImageWithRetry(
        imageUrl: _currentImageUrl!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        placeholder: Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: Builder(
          builder: (context) {
            // On image error, reset to no image state
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentImageUrl = null;
                  _currentS3Key = null;
                });
              }
            });

            // Return temporary placeholder while state resets
            return Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.person,
                  size: widget.size * 0.4,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
      );
    }

    // Show empty placeholder
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
