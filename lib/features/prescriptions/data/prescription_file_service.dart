import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PrescriptionFileService {
  Future<Directory> _directory() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'prescriptions'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<String> save({required String prescriptionId, required File source}) async {
    final dir = await _directory();
    final target = File(p.join(dir.path, '$prescriptionId${p.extension(source.path)}'));
    await source.copy(target.path);
    return target.path;
  }

  Future<void> delete(String path) async { final file = File(path); if (await file.exists()) await file.delete(); }
}
