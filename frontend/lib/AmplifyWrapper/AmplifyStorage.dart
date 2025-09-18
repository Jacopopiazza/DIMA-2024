import 'package:amplify_flutter/amplify_flutter.dart';
// S3 types are re-exported via amplify_flutter in recent versions; keep code generic

class AmplifyStorage {
  // Convenience wrappers that return the underlying operation results

  Future<StorageUploadDataResult> uploadData({
    required StorageDataPayload data,
    required StoragePath path,
    StorageUploadDataOptions options = const StorageUploadDataOptions(),
  }) async {
    final operation = Amplify.Storage.uploadData(
      data: data,
      path: path,
      options: options,
    );
    return await operation.result;
  }

  Future<StorageGetUrlResult> getUrl({
    required StoragePath path,
    StorageGetUrlOptions options = const StorageGetUrlOptions(),
  }) async {
    final operation = Amplify.Storage.getUrl(
      path: path,
      options: options,
    );
    return await operation.result;
  }

  Future<StorageRemoveResult> remove({
    required StoragePath path,
  }) async {
    final operation = Amplify.Storage.remove(path: path);
    return await operation.result;
  }
}
