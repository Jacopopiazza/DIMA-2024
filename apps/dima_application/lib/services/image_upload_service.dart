import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyAuth.dart';
import 'package:dima_application/AmplifyWrapper/AmplifyStorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

/// Service for handling image uploads to S3
class ImageUploadService {
  final AmplifyAuth _amplifyAuth;
  final AmplifyStorage _amplifyStorage;

  ImageUploadService({AmplifyAuth? amplifyAuth, AmplifyStorage? amplifyStorage})
      : _amplifyAuth = amplifyAuth ?? AmplifyAuth(),
        _amplifyStorage = amplifyStorage ?? AmplifyStorage();
  static const String _profilePicturesPrefix = 'profile-pictures/';
  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  /// Upload a profile picture for the current user
  /// Returns the URL of the uploaded image
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

      // Get the URL for the uploaded file (maximum expiration allowed by AWS)
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
  Future<void> deleteProfilePicture(String imageUrl) async {
    try {
      // Extract S3 key from URL
      final s3Key = _extractS3KeyFromUrl(imageUrl);
      if (s3Key == null) {
        throw Exception('Invalid image URL');
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

      await _amplifyStorage.remove(path: StoragePath.fromString(s3Key));
      safePrint('Image deleted successfully: $s3Key');
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
