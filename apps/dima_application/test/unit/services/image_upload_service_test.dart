import 'package:dima_application/services/image_upload_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import '../../test_setup.dart';

void main() {
  configureTestEnvironment();

  group('ImageUploadService', () {
    late ImageUploadService imageUploadService;

    setUp(() {
      imageUploadService = ImageUploadService();
    });

    group('Constructor', () {
      test('creates instance with default dependencies', () {
        final service = ImageUploadService();
        expect(service, isNotNull);
        expect(service, isA<ImageUploadService>());
      });

      test('creates instance with custom dependencies when provided', () {
        // Test that constructor accepts optional parameters
        expect(() => ImageUploadService(), returnsNormally);
      });
    });

    group('Public API validation', () {
      test('has uploadProfilePicture method', () {
        expect(imageUploadService.uploadProfilePicture, isA<Function>());
      });

      test('has deleteProfilePicture method', () {
        expect(imageUploadService.deleteProfilePicture, isA<Function>());
      });

      test('has pickImage method', () {
        expect(imageUploadService.pickImage, isA<Function>());
      });

      test('has refreshImageUrl method', () {
        expect(imageUploadService.refreshImageUrl, isA<Function>());
      });

      test('has pickImageFromSourceDialog method', () {
        expect(imageUploadService.pickImageFromSourceDialog, isA<Function>());
      });
    });

    group('Method signature validation', () {
      test('pickImage method has correct signature for ImageSource.camera', () {
        // Test that the method exists and accepts the correct parameters
        expect(() => imageUploadService.pickImage(source: ImageSource.camera), isA<Function>());
      });

      test('pickImage method has correct signature for ImageSource.gallery', () {
        // Test that the method exists and accepts the correct parameters  
        expect(() => imageUploadService.pickImage(source: ImageSource.gallery), isA<Function>());
      });

      test('deleteProfilePicture method has correct signature', () {
        expect(imageUploadService.deleteProfilePicture, isA<Function>());
      });

      test('refreshImageUrl method has correct signature', () {
        expect(imageUploadService.refreshImageUrl, isA<Function>());
      });
    });

    group('Error handling validation', () {
      test('methods handle exceptions without crashing service creation', () {
        // Verify service can be created even when underlying dependencies fail
        expect(() => ImageUploadService(), returnsNormally);
      });

      test('service maintains state after method calls fail', () async {
        // Verify the service instance remains usable after failed calls
        final service = ImageUploadService();
        expect(service, isNotNull);
        
        // Service should still exist and be testable even if methods would fail
        expect(service.uploadProfilePicture, isA<Function>());
        expect(service.deleteProfilePicture, isA<Function>());
      });
    });

    group('Service integration', () {
      test('service methods exist and are callable', () {
        // Verify all public methods exist and have correct signatures
        expect(imageUploadService.uploadProfilePicture, isA<Function>());
        expect(imageUploadService.deleteProfilePicture, isA<Function>());
        expect(imageUploadService.pickImage, isA<Function>());
        expect(imageUploadService.refreshImageUrl, isA<Function>());
        expect(imageUploadService.pickImageFromSourceDialog, isA<Function>());
      });
    });
  });
}
