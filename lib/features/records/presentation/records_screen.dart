import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../patients/data/patient_providers.dart';

final healthRecordsProvider = FutureProvider.autoDispose((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.select(db.healthRecords).get();
});
Future<void> _editRecord(
  BuildContext context,
  WidgetRef ref,
  HealthRecordsData? record,
) async {
  final title = TextEditingController(text: record?.title);
  final notes = TextEditingController(text: record?.notes);
  String type = record?.type ?? 'Vital';
  final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                  title: Text(record == null ? 'Add health record' : 'Edit health record'),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    DropdownButtonFormField<String>(
                        initialValue: type,
                        items: [
                          'Vital',
                          'Appointment',
                          'Illness',
                          'Diet',
                          'Prescription'
                        ]
                            .map((v) =>
                                DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (v) => setState(() => type = v!),
                        decoration: const InputDecoration(labelText: 'Type')),
                    TextField(
                        controller: title,
                        decoration: const InputDecoration(labelText: 'Title')),
                    TextField(
                        controller: notes,
                        decoration: const InputDecoration(labelText: 'Notes'))
                  ]),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Save'))
                  ])));
  if (result == true && title.text.trim().isNotEmpty) {
    final patients = await ref.read(patientsProvider.future);
    if (patients.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create a patient first')));
      }
      return;
    }
    final db = await ref.read(databaseProvider.future);
    await db.into(db.healthRecords).insertOnConflictUpdate(HealthRecordsCompanion.insert(
        id: record?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        patientId: record?.patientId ?? patients.first.id,
        type: type,
        title: title.text.trim(),
        notes: drift.Value(notes.text.trim()),
        occurredAt: record?.occurredAt ?? DateTime.now()));
    ref.invalidate(healthRecordsProvider);
  }
}

class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthRecordsProvider);
    return AppScaffold(
        title: 'Health records',
        child: records.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Unable to load records: $e')),
          data: (items) =>
              ListView(padding: const EdgeInsets.all(24), children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Health records',
                  style: Theme.of(context).textTheme.headlineMedium),
              FilledButton.icon(
                  onPressed: () => _editRecord(context, ref, null),
                  icon: const Icon(Icons.add),
                  label: const Text('Add record'))
            ]),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Card(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                          'Appointments, vitals, illnesses, diet notes, and prescriptions will appear here.'))),
            ...items.map((record) => Card(
                child: ListTile(
                    leading: const Icon(Icons.favorite_outline),
                    title: Text(record.title),
                    subtitle: Text(
                      '${record.type} · ${record.occurredAt.toLocal().toString().split(' ').first}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _editRecord(context, ref, record)))),
          ]),
        ));
  }
}
