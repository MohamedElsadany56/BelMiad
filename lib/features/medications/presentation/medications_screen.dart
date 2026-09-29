import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/database/app_database.dart';
import '../data/medication_providers.dart';
import '../../patients/data/patient_providers.dart';

Future<void> _addMedicine(
  BuildContext context,
  WidgetRef ref,
  String patientId,
  MedicationsData? medication,
) async {
  final name = TextEditingController(text: medication?.nameEn);
  final arabic = TextEditingController(text: medication?.nameAr);
  final strength = TextEditingController(text: medication?.strength);
  final dose = TextEditingController(text: medication?.doseUnit);
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(medication == null ? 'Add medicine' : 'Edit medicine'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Medicine name'),
            ),
            TextField(
              controller: arabic,
              decoration: const InputDecoration(labelText: 'Arabic name'),
            ),
            TextField(
              controller: strength,
              decoration: const InputDecoration(labelText: 'Strength'),
            ),
            TextField(
              controller: dose,
              decoration: const InputDecoration(labelText: 'Dose'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (result == true && name.text.trim().isNotEmpty) {
    await ref.read(medicationRepositoryProvider).save(
          id: medication?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
          patientId: patientId,
          nameEn: name.text.trim(),
          nameAr: arabic.text.trim(),
          strength: strength.text.trim(),
          doseUnit: dose.text.trim().isEmpty ? 'unit' : dose.text.trim(),
        );
    ref.invalidate(medicationsForPatientProvider(patientId));
  }
}

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    return patients.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Unable to load patients: $e')),
      data: (patientItems) {
        if (patientItems.isEmpty) {
          return const AppScaffold(
            title: 'Medicines',
            child: Center(child: Text('Create a patient before adding medicines.')),
          );
        }
        final selectedPatientId = ref.watch(activePatientIdProvider);
        final patientId = patientItems.any((patient) => patient.id == selectedPatientId)
          ? selectedPatientId!
          : patientItems.first.id;
        final medications = ref.watch(medicationsForPatientProvider(patientId));
        return AppScaffold(
          title: 'Medicines',
          child: medications.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Unable to load medicines: $e')),
            data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your medicines',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FilledButton.icon(
                  onPressed: () => _addMedicine(context, ref, patientId, null),
                  icon: const Icon(Icons.add),
                  label: const Text('Add medicine'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No medicines yet. Add a medicine even when stock has not been recorded.',
                  ),
                ),
              ),
            ...items.map(
              (medicine) => Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.medication_outlined),
                  ),
                  title: Text(medicine.nameEn),
                  subtitle: Text(
                    [medicine.nameAr, medicine.strength, medicine.dosageForm]
                        .whereType<String>()
                        .where((v) => v.isNotEmpty)
                        .join(' · '),
                  ),
                  onTap: () => _addMedicine(context, ref, patientId, medicine),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ],
            ),
          ),
        );
      },
    );
  }
}

