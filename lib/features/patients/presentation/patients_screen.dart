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
    final id = patient?.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    await ref.read(patientRepositoryProvider).save(
      id: id,
        name: name.text.trim(),
        relation: relation.text.trim());
    ref.read(activePatientIdProvider.notifier).state = id;
    ref.invalidate(patientsProvider);
  }
}

Future<void> _archivePatient(
  BuildContext context,
  WidgetRef ref,
  PatientsData patient,
) async {
  await ref.read(patientRepositoryProvider).archive(patient.id);
  if (ref.read(activePatientIdProvider) == patient.id) {
    ref.read(activePatientIdProvider.notifier).state = null;
  }
  ref.invalidate(patientsProvider);
}

Future<void> _showArchivedPatients(BuildContext context, WidgetRef ref) async {
  var archived = await ref.read(patientRepositoryProvider).list(includeArchived: true);
  archived = archived.where((patient) => patient.isArchived).toList();
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Archived patients'),
        content: SizedBox(
          width: 420,
          child: archived.isEmpty
              ? const Text('No archived patients.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: archived.length,
                  itemBuilder: (_, index) {
                    final patient = archived[index];
                    return ListTile(
                      title: Text(patient.name),
                      subtitle: Text(patient.relation ?? 'Patient'),
                      trailing: IconButton(
                        tooltip: 'Restore patient',
                        icon: const Icon(Icons.restore),
                        onPressed: () async {
                          await ref.read(patientRepositoryProvider).restore(patient.id);
                          archived = archived.where((item) => item.id != patient.id).toList();
                          ref.invalidate(patientsProvider);
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    ),
  );
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
                  label: const Text('Add patient')),
                OutlinedButton.icon(
                  onPressed: () => _showArchivedPatients(context, ref),
                  icon: const Icon(Icons.archive_outlined),
                  label: const Text('Archived'))
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
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'archive') {
                            _archivePatient(context, ref, patient);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'archive',
                            child: Text('Archive patient'),
                          ),
                        ],
                      ),
                      onTap: () {
                        ref.read(activePatientIdProvider.notifier).state = patient.id;
                        _editPatient(context, ref, patient);
                      }))),
          ]),
        ));
  }
}

