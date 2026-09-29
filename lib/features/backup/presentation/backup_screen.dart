import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../app/widgets/file_actions.dart';
import '../../../core/settings/settings_repository.dart';

/// Export, import-as-new and same-patient merge (spec §34).
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => _run(() async {
        final patient = ref.read(currentPatientProvider);
        if (patient == null) return;
        final service = ref.read(backupServiceProvider);
        final bytes = await service.exportPatient(patient.id);
        if (!mounted) return;
        final name = service.fileNameFor(patient.name);
        await saveOrShareFile(
          context,
          bytes: bytes,
          fileName: name,
          mimeType: 'application/zip',
        );
      });

  Future<void> _import({required bool merge}) => _run(() async {
        final l10n = context.l10n;
        final file = await pickFile(extensions: const ['zip', 'json']);
        if (file == null) return;
        final service = ref.read(backupServiceProvider);
        final packages = service.decode(file.bytes);
        String? lastPatientId;
        for (final package in packages) {
          if (merge) {
            final result = await service.mergeSamePatient(package);
            lastPatientId = result.patientId;
            if (mounted) {
              showMessage(
                  context, l10n.mergeDone(result.added, result.updated));
            }
            ref
                .read(syncCoordinatorProvider)
                .request(regeneratePatientId: result.patientId);
          } else {
            final result = await service.importAsNew(package);
            lastPatientId = result.patientId;
            if (mounted) {
              showMessage(context, l10n.importDone(result.patientName));
            }
            ref
                .read(syncCoordinatorProvider)
                .request(regeneratePatientId: result.patientId);
          }
        }
        if (lastPatientId != null) {
          await ref
              .read(settingsRepositoryProvider)
              .set(SettingKeys.currentPatientId, lastPatientId);
        }
      });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final patient = ref.watch(currentPatientProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_busy) const LinearProgressIndicator(),
            Text(l10n.backupNote),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file),
                title: Text(l10n.exportBackup),
                subtitle: Text(
                  '${patient?.name ?? ''}\n${l10n.exportBackupBody}',
                ),
                isThreeLine: true,
                enabled: patient != null,
                onTap: _export,
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_add_alt),
                title: Text(l10n.importAsNew),
                subtitle: Text(l10n.importAsNewBody),
                onTap: () => _import(merge: false),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.merge_type),
                title: Text(l10n.mergeBackup),
                subtitle: Text(l10n.mergeBackupBody),
                onTap: () => _import(merge: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
