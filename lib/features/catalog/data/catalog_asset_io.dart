import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Copies the bundled catalog asset to app storage once per catalog version
/// and returns its path. Older catalog versions are removed.
Future<String> prepareCatalogFile({
  required int version,
  required Future<Uint8List> Function() loadAsset,
}) async {
  final directory = Directory(
    p.join((await getApplicationSupportDirectory()).path, 'catalog'),
  );
  if (!await directory.exists()) await directory.create(recursive: true);
  final target = File(p.join(directory.path, 'drug_catalog_v$version.sqlite'));
  if (!await target.exists() || await target.length() == 0) {
    final temp = File('${target.path}.tmp');
    await temp.writeAsBytes(await loadAsset(), flush: true);
    await temp.rename(target.path);
  }
  await for (final entity in directory.list()) {
    if (entity is File &&
        p.basename(entity.path).startsWith('drug_catalog_v') &&
        entity.path != target.path &&
        !entity.path.startsWith(target.path)) {
      try {
        await entity.delete();
      } catch (_) {}
    }
  }
  return target.path;
}
