import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../patients/data/patient_providers.dart';

final healthRecordsProvider = FutureProvider.autoDispose((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final selectedPatientId = ref.watch(activePatientIdProvider);
  final query = db.select(db.healthRecords);
  if (selectedPatientId != null) {
    query.where((record) => record.patientId.equals(selectedPatientId));
  }
  return query.get();
});
Future<void> _editRecord(
  BuildContext context,
  WidgetRef ref,
  HealthRecord? record,
) async {
  final title = TextEditingController(text: record?.title);
  final notes = TextEditingController(text: record?.notes);
  final metadata = TextEditingController(text: record?.metadataJson);
  final bloodPressure = TextEditingController();
  final pulse = TextEditingController();
  final weight = TextEditingController();
  final doctor = TextEditingController();
  final location = TextEditingController();
  final diagnosis = TextEditingController();
  final symptoms = TextEditingController();
  final dietRule = TextEditingController();
  final prescriptionPath = TextEditingController();
  String type = record?.type ?? 'Vital';
  DateTime occurredAt = record?.occurredAt ?? DateTime.now();
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
                      decoration: const InputDecoration(labelText: 'Notes')),
                    TextField(
                      controller: metadata,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Details (JSON, optional)')),
                      if (type == 'Vital') ...[
                        TextField(
                          controller: bloodPressure,
                          decoration:
                            const InputDecoration(labelText: 'Blood pressure')),
                        TextField(
                          controller: pulse,
                          keyboardType: TextInputType.number,
                          decoration:
                            const InputDecoration(labelText: 'Pulse (bpm)')),
                        TextField(
                          controller: weight,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                          decoration:
                            const InputDecoration(labelText: 'Weight (kg)')),
                      ],
                      if (type == 'Appointment') ...[
                        TextField(
                          controller: doctor,
                          decoration:
                            const InputDecoration(labelText: 'Doctor')),
                        TextField(
                          controller: location,
                          decoration:
                            const InputDecoration(labelText: 'Location')),
                      ],
                      if (type == 'Illness') ...[
                        TextField(
                          controller: diagnosis,
                          decoration:
                            const InputDecoration(labelText: 'Diagnosis')),
                        TextField(
                          controller: symptoms,
                          decoration:
                            const InputDecoration(labelText: 'Symptoms')),
                      ],
                      if (type == 'Diet')
                        TextField(
                          controller: dietRule,
                          decoration: const InputDecoration(
                            labelText: 'Dietary rule or restriction')),
                      if (type == 'Prescription')
                        TextField(
                          controller: prescriptionPath,
                          decoration: const InputDecoration(
                            labelText: 'Prescription image/file path')),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Occurred: ${occurredAt.toLocal().toString().split(' ').first}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: occurredAt);
                        if (picked != null) {
                        setState(() => occurredAt = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          occurredAt.hour,
                          occurredAt.minute));
                        }
                      })
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
        metadataJson: drift.Value(_buildMetadata(
          type,
          metadata.text,
          bloodPressure.text,
          pulse.text,
          weight.text,
          doctor.text,
          location.text,
          diagnosis.text,
          symptoms.text,
          dietRule.text,
          prescriptionPath.text)),
        occurredAt: occurredAt));
    ref.invalidate(healthRecordsProvider);
  }
}

String? _validMetadata(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  try {
    final decoded = jsonDecode(trimmed);
    return decoded is Map<String, dynamic> ? trimmed : null;
  } on FormatException {
    return null;
  }
}

String? _buildMetadata(
  String type,
  String manual,
  String bloodPressure,
  String pulse,
  String weight,
  String doctor,
  String location,
  String diagnosis,
  String symptoms,
  String dietRule,
  String prescriptionPath,
) {
  final values = <String, dynamic>{};
  dynamic manualValue;
  try {
    manualValue = manual.trim().isEmpty ? null : jsonDecode(manual);
  } on FormatException {
    manualValue = null;
  }
  if (manualValue is Map<String, dynamic>) values.addAll(manualValue);
  void add(String key, String value) {
    if (value.trim().isNotEmpty) values[key] = value.trim();
  }
  switch (type) {
    case 'Vital':
      add('blood_pressure', bloodPressure);
      add('pulse_bpm', pulse);
      add('weight_kg', weight);
    case 'Appointment':
      add('doctor', doctor);
      add('location', location);
    case 'Illness':
      add('diagnosis', diagnosis);
      add('symptoms', symptoms);
    case 'Diet':
      add('diet_rule', dietRule);
    case 'Prescription':
      add('file_path', prescriptionPath);
  }
  return values.isEmpty ? null : jsonEncode(values);
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
