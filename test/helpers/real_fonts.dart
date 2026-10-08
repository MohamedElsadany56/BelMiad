import 'dart:io';

import 'package:flutter/services.dart';

/// Measures with the fonts phones use instead of the square test font.
Future<void> loadRealFonts() async {
  Future<void> load(String family, List<String> paths) async {
    final loader = FontLoader(family);
    for (final path in paths) {
      final bytes = File(path).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  // The test runner lives under <flutter>/bin/cache/artifacts/engine/...
  var dir = File(Platform.resolvedExecutable).parent;
  while (!Directory('${dir.path}/material_fonts').existsSync() &&
      dir.parent.path != dir.path) {
    dir = dir.parent;
  }
  final material = '${dir.path}/material_fonts';
  await load('Roboto', [
    for (final w in ['regular', 'medium', 'bold'])
      if (File('$material/roboto-$w.ttf').existsSync())
        '$material/roboto-$w.ttf',
  ]);
  await load('MaterialIcons', ['$material/materialicons-regular.otf']);
  await load('NotoNaskhArabic', [
    'assets/fonts/NotoNaskhArabic-Regular.ttf',
    'assets/fonts/NotoNaskhArabic-Bold.ttf',
  ]);
}
