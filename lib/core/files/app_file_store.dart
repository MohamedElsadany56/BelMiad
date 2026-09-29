import 'dart:typed_data';

import 'app_file_store_stub.dart'
    if (dart.library.io) 'app_file_store_io.dart' as impl;

/// App-private file storage (prescription images, backup staging).
///
/// Paths stored in the database are relative to the store root so the data
/// survives app reinstalls and backup/restore to another device.
abstract class AppFileStore {
  factory AppFileStore() => impl.createFileStore();

  bool get isSupported;

  /// Saves [bytes] under [folder] and returns the relative path.
  Future<String> save(String folder, String fileName, Uint8List bytes);

  Future<Uint8List?> read(String relativePath);

  Future<bool> exists(String relativePath);

  Future<void> delete(String relativePath);

  /// Absolute path for platform viewers/sharing, or null when unavailable.
  Future<String?> absolutePath(String relativePath);
}
