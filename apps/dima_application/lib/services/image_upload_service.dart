import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyStorage.dart';
import 'package:dima_application/services/nutritionist_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

/// Service for handling image uploads to S3
class ImageUploadService {
  final AmplifyAuth _amplifyAuth;
  final AmplifyStorage _amplifyStorage;
  final NutritionistProfileService _profileService;

  ImageUploadService({
    AmplifyAuth? amplifyAuth,
    AmplifyStorage? amplifyStorage,
    NutritionistProfileService? profileService,
  })  : _amplifyAuth = amplifyAuth ?? AmplifyAuth(),
        _amplifyStorage = amplifyStorage ?? AmplifyStorage(),
        _profileService = profileService ?? NutritionistProfileService();
  static const String _profilePicturesPrefix = 'profile-pictures/';
  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  /// Upload a profile picture for the current user
  /// Returns the S3 key of the uploaded image
  Future<String?> uploadProfilePicture(XFile imageFile) async {
    try {
      // Validate file size
      final fileSize = await imageFile.length();
      if (fileSize > _maxFileSizeBytes) {
        throw Exception('Image file size must be less than 5MB');
      }

      // Validate file extension
      final extension =
          path.extension(imageFile.name).toLowerCase().replaceFirst('.', '');
      if (!_allowedExtensions.contains(extension)) {
        throw Exception('Only JPG, PNG, and WebP files are allowed');
      }

      // Get current user ID
      final user = await _amplifyAuth.getCurrentUser();
      final userId = user.userId;

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${userId}_$timestamp.$extension';
      final s3Key = '$_profilePicturesPrefix$fileName';

      // Read file as bytes
      final fileBytes = await imageFile.readAsBytes();

      // Upload to S3
      final uploadResult = await _amplifyStorage.uploadData(
        data: StorageDataPayload.bytes(
          fileBytes,
          contentType: _getContentType(extension),
        ),
        path: StoragePath.fromString(s3Key),
        options: const StorageUploadDataOptions(
          metadata: {
            'type': 'profile-picture',
            'uploaded-by': 'mobile-app',
          },
        ),
      );

      safePrint(
          'Image uploaded successfully: ${uploadResult.uploadedItem.path}');

      // Return the S3 key instead of the URL
      return s3Key;
    } on StorageException catch (e) {
      safePrint('Storage error: ${e.message}');
      rethrow;
    } on AuthException catch (e) {
      safePrint('Auth error: ${e.message}');
      rethrow;
    } catch (e) {
      safePrint('Unexpected error uploading image: $e');
      rethrow;
    }
  }

  /// Delete a profile picture from S3
  /// Accepts either an S3 key or URL
  Future<void> deleteProfilePicture(String imageUrlOrKey) async {
    try {
      String s3Key;

      // Check if input is an S3 key or URL
      if (imageUrlOrKey.startsWith('http')) {
        // It's a URL, extract S3 key
        final extractedKey = _extractS3KeyFromUrl(imageUrlOrKey);
        if (extractedKey == null) {
          throw Exception('Invalid image URL');
        }
        s3Key = extractedKey;
      } else {
        // It's already an S3 key
        s3Key = imageUrlOrKey;
      }

      // Only allow deletion of profile pictures
      if (!s3Key.startsWith(_profilePicturesPrefix)) {
        throw Exception('Can only delete profile pictures');
      }

      // Verify ownership - key should contain current user ID
      final user = await _amplifyAuth.getCurrentUser();
      final userId = user.userId;

      if (!s3Key.contains(userId)) {
        throw Exception('Cannot delete image that doesn\'t belong to you');
      }

      // Delete from S3
      await _amplifyStorage.remove(path: StoragePath.fromString(s3Key));
      safePrint('Image deleted successfully: $s3Key');

      // Update database to set profilePictureUrl to null
      await _updateProfilePictureToNull();
    } on StorageException catch (e) {
      safePrint('Storage error deleting image: ${e.message}');
      rethrow;
    } on AuthException catch (e) {
      safePrint('Auth error: ${e.message}');
      rethrow;
    } catch (e) {
      safePrint('Unexpected error deleting image: $e');
      rethrow;
    }
  }

  /// Pick an image from camera or gallery
  Future<XFile?> pickImage({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85, // Compress to reduce file size
      );
      return image;
    } catch (e) {
      safePrint('Error picking image: $e');
      rethrow;
    }
  }

  /// Refresh an expired image URL by generating a new presigned URL
  /// This is useful when S3 presigned URLs expire (default 15 minutes)
  Future<String?> refreshImageUrl(String expiredUrl) async {
    try {
      // Extract S3 key from the expired URL
      final s3Key = _extractS3KeyFromUrl(expiredUrl);
      if (s3Key == null) {
        throw Exception('Invalid image URL - cannot extract S3 key');
      }

      // Generate a new presigned URL (maximum expiration allowed by AWS)
      final urlResult = await _amplifyStorage.getUrl(
        path: StoragePath.fromString(s3Key),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 7), // Maximum allowed by AWS S3
          ),
        ),
      );

      return urlResult.url.toString();
    } on StorageException catch (e) {
      safePrint('Storage error refreshing URL: ${e.message}');
      return null;
    } catch (e) {
      safePrint('Unexpected error refreshing image URL: $e');
      return null;
    }
  }

  /// Show image source selection dialog
  Future<XFile?> pickImageFromSourceDialog(BuildContext context) async {
    return showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImage(source: ImageSource.camera);
                  Navigator.of(context).pop(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImage(source: ImageSource.gallery);
                  Navigator.of(context).pop(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Get content type based on file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Update nutritionist profile to set profilePictureUrl to null
  Future<void> _updateProfilePictureToNull() async {
    try {
      // Get current profile to preserve other fields
      final currentProfile = await _profileService.getMyProfile();

      if (currentProfile == null) {
        safePrint(
            '[ImageUploadService] Warning: Could not load current profile to update');
        return;
      }

      // Update profile with null profilePictureUrl
      final updatedProfile = await _profileService.updateMyProfile(
        specialization: currentProfile.specialization ?? '',
        bio: currentProfile.bio ?? '',
        profilePictureUrl: null, // Set to null
        isAvailable: currentProfile.isAvailable ?? true,
      );

      if (updatedProfile != null) {
        safePrint(
            '[ImageUploadService] Successfully updated profile to remove profilePictureUrl');
      } else {
        safePrint('[ImageUploadService] Warning: Profile update returned null');
      }
    } catch (e) {
      safePrint(
          '[ImageUploadService] Error updating profile after image deletion: $e');
      // Don't rethrow - we don't want S3 deletion to fail if profile update fails
    }
  }

  /// Extract S3 key from a presigned URL (public method for other services)
  String? extractS3KeyFromUrl(String url) {
    return _extractS3KeyFromUrl(url);
  }

  /// Extract S3 key from a presigned URL
  String? _extractS3KeyFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // For S3 URLs, the key is the path without the leading slash
      if (uri.host.contains('amazonaws.com')) {
        return uri.path.substring(1); // Remove leading slash
      }

      return null;
    } catch (e) {
      safePrint('Error extracting S3 key from URL: $e');
      return null;
    }
  }
}
