import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_file_store.dart';

AppFileStore createFileStore() => IoAppFileStore();

class IoAppFileStore implements AppFileStore {
  IoAppFileStore({Future<Directory> Function()? root})
      : _rootProvider = root ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _rootProvider;
  Directory? _root;

  Future<Directory> _base() async {
    final root = _root ??= Directory(
      p.join((await _rootProvider()).path, 'files'),
    );
    if (!await root.exists()) await root.create(recursive: true);
    return root;
  }

  File _file(Directory base, String relativePath) {
    final normalized = p.normalize(relativePath);
    if (p.isAbsolute(normalized) || normalized.startsWith('..')) {
      throw ArgumentError.value(relativePath, 'relativePath');
    }
    return File(p.join(base.path, normalized));
  }

  @override
  bool get isSupported => true;

  @override
  Future<String> save(String folder, String fileName, Uint8List bytes) async {
    final base = await _base();
    final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final relative = p.join(folder, safeName);
    final file = _file(base, relative);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return relative.replaceAll(r'\', '/');
  }

  @override
  Future<Uint8List?> read(String relativePath) async {
    final file = _file(await _base(), relativePath);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  @override
  Future<bool> exists(String relativePath) async =>
      _file(await _base(), relativePath).exists();

  @override
  Future<void> delete(String relativePath) async {
    final file = _file(await _base(), relativePath);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<String?> absolutePath(String relativePath) async {
    final file = _file(await _base(), relativePath);
    return await file.exists() ? file.path : null;
  }
}
