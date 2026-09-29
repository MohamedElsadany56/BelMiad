import 'dart:typed_data';

import 'app_file_store.dart';

AppFileStore createFileStore() => MemoryAppFileStore();

/// Fallback for platforms without a file system (web). Files live only for
/// the current session.
class MemoryAppFileStore implements AppFileStore {
  final _files = <String, Uint8List>{};

  @override
  bool get isSupported => false;

  @override
  Future<String> save(String folder, String fileName, Uint8List bytes) async {
    final path = '$folder/$fileName';
    _files[path] = bytes;
    return path;
  }

  @override
  Future<Uint8List?> read(String relativePath) async => _files[relativePath];

  @override
  Future<bool> exists(String relativePath) async =>
      _files.containsKey(relativePath);

  @override
  Future<void> delete(String relativePath) async => _files.remove(relativePath);

  @override
  Future<String?> absolutePath(String relativePath) async => null;
}
