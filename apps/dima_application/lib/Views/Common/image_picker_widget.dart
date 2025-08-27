import 'dart:io';

import 'package:dima_application/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A reusable widget for picking and displaying profile images
class ImagePickerWidget extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String?) onImageChanged;
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
  String? _currentImageUrl;
  XFile? _pendingImageFile;
  bool _isUploading = false;
  final ImageUploadService _imageUploadService = ImageUploadService();

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.initialImageUrl;
  }

  @override
  void didUpdateWidget(ImagePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImageUrl != oldWidget.initialImageUrl) {
      setState(() {
        _currentImageUrl = widget.initialImageUrl;
        _pendingImageFile = null;
      });
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

      // Upload the image
      final imageUrl =
          await _imageUploadService.uploadProfilePicture(imageFile);

      if (imageUrl != null) {
        setState(() {
          _currentImageUrl = imageUrl;
          _pendingImageFile = null;
        });
        widget.onImageChanged(imageUrl);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
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
      if (_currentImageUrl != null) {
        setState(() {
          _isUploading = true;
        });

        await _imageUploadService.deleteProfilePicture(_currentImageUrl!);
      }

      setState(() {
        _currentImageUrl = null;
        _pendingImageFile = null;
      });
      widget.onImageChanged(null);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing image: $e'),
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
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Select Photo Source',
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
                      // Camera option
                      _buildImageSourceOption(
                        context: context,
                        icon: Icons.camera_alt,
                        title: 'Take Photo',
                        subtitle: 'Use camera to take a new photo',
                        onTap: () async {
                          final image = await _imageUploadService.pickImage(
                              source: ImageSource.camera);
                          if (context.mounted) {
                            Navigator.of(context).pop(image);
                          }
                        },
                      ),

                      const SizedBox(height: 8),

                      // Gallery option
                      _buildImageSourceOption(
                        context: context,
                        icon: Icons.photo_library,
                        title: 'Choose from Gallery',
                        subtitle: 'Select from existing photos',
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
                          title: 'Remove Photo',
                          subtitle: 'Delete current profile picture',
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
                      child: const Text('Cancel'),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
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

                  // Upload overlay
                  if (_isUploading)
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

                  // Camera icon overlay - FIXED ALIGNMENT
                  if (_currentImageUrl == null &&
                      _pendingImageFile == null &&
                      !_isUploading)
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: widget.size * 0.3,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                  // Edit overlay when image exists
                  if (_currentImageUrl != null && !_isUploading)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Enhanced instruction text
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _currentImageUrl != null ? Icons.edit : Icons.touch_app,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                _currentImageUrl != null
                    ? 'Tap to change photo'
                    : 'Tap to upload a profile picture',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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

    // Show current network image
    if (_currentImageUrl != null) {
      return Image.network(
        _currentImageUrl!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: theme.colorScheme.surfaceContainerHighest,
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
          return Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Center(
              child: Icon(
                Icons.add_a_photo,
                size: widget.size * 0.3,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        },
      );
    }

    // Show placeholder
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
