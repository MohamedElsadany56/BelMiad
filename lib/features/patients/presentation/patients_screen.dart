import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_scaffold.dart';
import '../../../core/database/app_database.dart';
import '../data/patient_providers.dart';

Future<void> _editPatient(
  BuildContext context,
  WidgetRef ref,
  PatientsData? patient,
) async {
  final name = TextEditingController(text: patient?.name);
  final relation = TextEditingController(text: patient?.relation);
  final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
              title: Text(patient == null ? 'Add patient' : 'Edit patient'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    controller: name,
                    decoration:
                        const InputDecoration(labelText: 'Patient name')),
                TextField(
                    controller: relation,
                    decoration: const InputDecoration(labelText: 'Relation'))
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Save'))
              ]));
  if (result == true && name.text.trim().isNotEmpty) {
    await ref.read(patientRepositoryProvider).save(
        id: patient?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.text.trim(),
        relation: relation.text.trim());
    ref.invalidate(patientsProvider);
  }
}

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    return AppScaffold(
        title: 'Patients',
        child: patients.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Unable to load patients: $e')),
          data: (items) =>
              ListView(padding: const EdgeInsets.all(24), children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Patients',
                  style: Theme.of(context).textTheme.headlineMedium),
              FilledButton.icon(
                  onPressed: () => _editPatient(context, ref, null),
                  icon: const Icon(Icons.add),
                  label: const Text('Add patient'))
            ]),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Card(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                          'Create a patient profile to begin managing medicines and records.'))),
            ...items.map((patient) => Card(
                child: ListTile(
                    leading:
                        const CircleAvatar(child: Icon(Icons.person_outline)),
                    title: Text(patient.name),
                    subtitle: Text(
                        '${patient.relation ?? 'Patient'} · ${patient.timezone}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _editPatient(context, ref, patient)))),
          ]),
        ));
  }
}

