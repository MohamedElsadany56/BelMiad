import 'dart:typed_data';

/// Web builds initialise the catalog through `DriftWebOptions` instead.
Future<String> prepareCatalogFile({
  required int version,
  required Future<Uint8List> Function() loadAsset,
}) =>
    throw UnsupportedError('No file system on this platform');
