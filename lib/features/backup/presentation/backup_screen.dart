import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../app/app_scaffold.dart';
import '../../../app/localization/app_localization.dart';
import '../../../core/backup/backup_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../data/backup_merge_service.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  Future<Map<String, dynamic>> _export(WidgetRef ref) async {
    final db = await ref.read(databaseProvider.future);
    final backup = BackupService();
    return backup.encode(
      patients: await db.select(db.patients).get(),
      medications: await db.select(db.medications).get(),
      batches: await db.select(db.inventoryBatches).get(),
      doses: await db.select(db.doseInstances).get(),
      records: await db.select(db.healthRecords).get(),
    );
  }

  Future<void> _showExport(BuildContext context, WidgetRef ref) async {
    final json = BackupService().toJson(await _export(ref));
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Export backup'),
        content: SizedBox(
          width: 560,
          child: TextField(
            controller: TextEditingController(text: json),
            readOnly: true,
            maxLines: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: json));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Copy JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _showImport(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Import backup'),
        content: SizedBox(
          width: 560,
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 14,
            decoration: const InputDecoration(
              hintText: 'Paste a BelMiad backup JSON here',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Merge backup'),
          ),
        ],
      ),
    );
    if (confirmed != true || controller.text.trim().isEmpty) return;
    try {
      final current = await _export(ref);
      final incoming = BackupService().fromJson(controller.text);
      final merged = BackupMergeService().merge(current, incoming);
      await _restore(ref, merged);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup merged successfully')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to import backup: $error')),
        );
      }
    }
  }

  Future<void> _restore(WidgetRef ref, Map<String, dynamic> backup) async {
    final db = await ref.read(databaseProvider.future);
    final now = DateTime.now();
    final patients = _rows(backup['patients']);
    final medications = _rows(backup['medications']);
    final batches = _rows(backup['inventory_batches']);
    final doses = _rows(backup['doses']);
    final records = _rows(backup['health_records']);
    await db.transaction(() async {
      for (final patient in patients) {
        await db.into(db.patients).insertOnConflictUpdate(PatientsCompanion.insert(
          id: _string(patient['id']),
          name: _string(patient['name']),
          relation: drift.Value(_nullableString(patient['relation'])),
          timezone: drift.Value(_string(patient['timezone'], fallback: 'Africa/Cairo')),
          createdAt: now,
          updatedAt: now,
        ));
      }
      for (final medication in medications) {
        await db.into(db.medications).insertOnConflictUpdate(MedicationsCompanion.insert(
          id: _string(medication['id']),
          patientId: _string(medication['patient_id']),
          nameEn: _string(medication['name_en']),
          nameAr: drift.Value(_nullableString(medication['name_ar'])),
          strength: drift.Value(_nullableString(medication['strength'])),
          dosageForm: drift.Value(_nullableString(medication['dosage_form'])),
          isPrn: drift.Value(medication['is_prn'] == true),
          createdAt: now,
          updatedAt: now,
        ));
      }
      for (final batch in batches) {
        await db.into(db.inventoryBatches).insertOnConflictUpdate(
              InventoryBatchesCompanion.insert(
                id: _string(batch['id']),
                medicationId: _string(batch['medication_id']),
                availableQuantityScaled: _int(batch['available_quantity_scaled']),
                quantityScale:
                  drift.Value(_int(batch['quantity_scale'], fallback: 1000)),
                unit: _string(batch['unit'], fallback: 'unit'),
                purchaseDate: DateTime.parse(_string(batch['purchase_date'])),
                expirationDate: drift.Value(_date(batch['expiration_date'])),
                source: drift.Value(_nullableString(batch['source'])),
              ),
            );
      }
      for (final dose in doses) {
        await db.into(db.doseInstances).insertOnConflictUpdate(
              DoseInstancesCompanion.insert(
                id: _string(dose['id']),
                patientId: _string(dose['patient_id']),
                medicationId: _string(dose['medication_id']),
                scheduledAt: DateTime.parse(_string(dose['scheduled_at'])),
                requiredQuantityScaled: _int(dose['required_quantity_scaled']),
                status: drift.Value(_string(dose['status'], fallback: 'SCHEDULED')),
              ),
            );
      }
      for (final record in records) {
        await db.into(db.healthRecords).insertOnConflictUpdate(
              HealthRecordsCompanion.insert(
                id: _string(record['id']),
                patientId: _string(record['patient_id']),
                type: _string(record['type']),
                title: _string(record['title']),
                notes: drift.Value(_nullableString(record['notes'])),
                metadataJson: drift.Value(_nullableString(record['metadata_json'])),
                occurredAt: DateTime.parse(_string(record['occurred_at'])),
              ),
            );
      }
    });
  }

  List<Map<String, dynamic>> _rows(dynamic value) => (value as List? ?? const [])
      .map((row) => Map<String, dynamic>.from(row as Map))
      .toList();

  String _string(dynamic value, {String fallback = ''}) =>
      value?.toString() ?? fallback;

  String? _nullableString(dynamic value) => value?.toString();

  int _int(dynamic value, {int fallback = 0}) => value is num ? value.toInt() : fallback;

  DateTime? _date(dynamic value) => value == null ? null : DateTime.parse(value.toString());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(localeProvider));
    return AppScaffold(
      title: 'Backup',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(strings.text('backupAndRestore'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Export a portable offline backup or merge one from another device.'),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _showExport(context, ref),
            icon: const Icon(Icons.upload_file),
            label: Text(strings.text('exportBackup')),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showImport(context, ref),
            icon: const Icon(Icons.download),
            label: Text(strings.text('importMergeBackup')),
          ),
        ],
      ),
    );
  }
}
