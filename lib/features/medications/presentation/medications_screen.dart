import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/database/app_database.dart';
import '../data/medication_providers.dart';
import '../../patients/data/patient_providers.dart';
import '../../catalog/data/drug_catalog_repository.dart';
import '../../catalog/domain/drug_catalog_entry.dart';

Future<DrugCatalogEntry?> _chooseCatalogEntry(
  BuildContext context,
  DrugCatalogRepository catalog,
) async {
  final query = TextEditingController();
  return showDialog<DrugCatalogEntry>(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add medicine from catalog'),
        content: SizedBox(
          width: 520,
          height: 420,
          child: Column(
            children: [
              TextField(
                controller: query,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Search English or Arabic name',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<DrugCatalogEntry>>(
                  future: catalog.search(query.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Catalog unavailable: ${snapshot.error}');
                    }
                    if (query.text.trim().length < 2) {
                      return const Center(
                          child: Text('Type at least two characters to search.'));
                    }
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final entries = snapshot.data ?? const <DrugCatalogEntry>[];
                    if (entries.isEmpty) {
                      return const Center(child: Text('No matching medicines.'));
                    }
                    return ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (_, index) {
                        final entry = entries[index];
                        return ListTile(
                          title: Text(entry.nameEn),
                          subtitle: Text('${entry.nameAr} · EGP ${entry.priceEgp}'),
                          onTap: () => Navigator.pop(context, entry),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _addMedicine(
  BuildContext context,
  WidgetRef ref,
  String patientId,
  Medication? medication,
) async {
  final name = TextEditingController(text: medication?.nameEn);
  final arabic = TextEditingController(text: medication?.nameAr);
  final strength = TextEditingController(text: medication?.strength);
  final dosageForm = TextEditingController(text: medication?.dosageForm);
  final route = TextEditingController(text: medication?.route);
  final dose = TextEditingController(text: medication?.doseUnit);
  final maxDaily = TextEditingController(
      text: medication?.maxDailyQuantityScaled?.toString());
  var isPrn = medication?.isPrn ?? false;
  String? catalogId = medication?.catalogId;
  final catalog = DrugCatalogRepository();
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(medication == null ? 'Add medicine' : 'Edit medicine'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final entry = await _chooseCatalogEntry(context, catalog);
                  if (entry != null) {
                    name.text = entry.nameEn;
                    arabic.text = entry.nameAr;
                    catalogId = entry.id;
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('Choose from Egyptian drug catalog'),
              ),
            ),
            TextField(
              controller: name,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(labelText: 'Medicine name'),
            ),
            if (name.text.trim().length >= 2)
              FutureBuilder<List<DrugCatalogEntry>>(
                future: catalog.search(name.text),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Catalog unavailable: ${snapshot.error}');
                  }
                  final matches = snapshot.data ?? const <DrugCatalogEntry>[];
                  if (matches.isEmpty) return const SizedBox.shrink();
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 160),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: matches.length,
                      itemBuilder: (_, index) {
                        final entry = matches[index];
                        return ListTile(
                          dense: true,
                          title: Text(entry.nameEn),
                          subtitle: Text('${entry.nameAr} · EGP ${entry.priceEgp}'),
                          onTap: () {
                            name.text = entry.nameEn;
                            arabic.text = entry.nameAr;
                            catalogId = entry.id;
                            setState(() {});
                          },
                        );
                      },
                    ),
                  );
                },
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
              controller: dosageForm,
              decoration: const InputDecoration(labelText: 'Dosage form'),
            ),
            TextField(
              controller: route,
              decoration: const InputDecoration(labelText: 'Route'),
            ),
            TextField(
              controller: dose,
              decoration: const InputDecoration(labelText: 'Dose'),
            ),
            StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('As-needed medicine (PRN)'),
                    value: isPrn,
                    onChanged: (value) => setState(() => isPrn = value),
                  ),
                  if (isPrn)
                    TextField(
                      controller: maxDaily,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximum daily quantity (scaled)',
                      ),
                    ),
                ],
              ),
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
    ),
  );
  if (result == true && name.text.trim().isNotEmpty) {
    await ref.read(medicationRepositoryProvider).save(
          id: medication?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
          patientId: patientId,
          nameEn: name.text.trim(),
          catalogId: catalogId,
          nameAr: arabic.text.trim(),
          strength: strength.text.trim(),
          dosageForm: dosageForm.text.trim(),
          route: route.text.trim(),
          doseUnit: dose.text.trim().isEmpty ? 'unit' : dose.text.trim(),
          isPrn: isPrn,
          maxDailyQuantityScaled: int.tryParse(maxDaily.text.trim()),
        );
    ref.invalidate(medicationsForPatientProvider(patientId));
  }
}

Future<void> _archiveMedicine(
  WidgetRef ref,
  String patientId,
  Medication medicine,
) async {
  await ref.read(medicationRepositoryProvider).archive(medicine.id);
  ref.invalidate(medicationsForPatientProvider(patientId));
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
                    [
                      medicine.nameAr,
                      medicine.strength,
                      medicine.dosageForm,
                      medicine.route,
                      if (medicine.isPrn) 'PRN',
                    ]
                        .whereType<String>()
                        .where((v) => v.isNotEmpty)
                        .join(' · '),
                  ),
                  onTap: () => _addMedicine(context, ref, patientId, medicine),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) {
                      if (action == 'archive') {
                        _archiveMedicine(ref, patientId, medicine);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive medicine'),
                      ),
                    ],
                  ),
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

