import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'common.dart';

class PickedFile {
  const PickedFile(this.name, this.bytes);

  final String name;
  final Uint8List bytes;
}

Future<PickedFile?> pickFile({List<String>? extensions}) async {
  final file = await FilePicker.pickFile(
    type: extensions == null ? FileType.any : FileType.custom,
    allowedExtensions: extensions,
  );
  if (file == null) return null;
  return PickedFile(file.name, await file.readAsBytes());
}

/// Lets the user save a generated file to the device or share it with
/// another app (no network needed).
Future<void> saveOrShareFile(
  BuildContext context, {
  required Uint8List bytes,
  required String fileName,
  required String mimeType,
}) async {
  final l10n = context.l10n;
  final choice = await showModalBottomSheet<String>(
    useRootNavigator: true,
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: Text(l10n.save),
            subtitle: Text(fileName),
            onTap: () => Navigator.pop(context, 'save'),
          ),
          if (!kIsWeb)
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(l10n.share),
              onTap: () => Navigator.pop(context, 'share'),
            ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  try {
    if (choice == 'share') {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, name: fileName, mimeType: mimeType)],
          fileNameOverrides: [fileName],
        ),
      );
    } else {
      final saved = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: mimeType,
      );
      if (saved != null && context.mounted) {
        showMessage(context, l10n.savedMessage);
      }
    }
  } catch (error) {
    if (context.mounted) showError(context, error);
  }
}
