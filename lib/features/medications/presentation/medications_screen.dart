import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_scaffold.dart';
import '../data/medication_providers.dart';

Future<void> _addMedicine(BuildContext context, WidgetRef ref, String patientId) async {\n  final name = TextEditingController(); final arabic = TextEditingController(); final strength = TextEditingController(); final dose = TextEditingController();\n  final result = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Add medicine'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'Medicine name')), TextField(controller: arabic, decoration: const InputDecoration(labelText: 'Arabic name')), TextField(controller: strength, decoration: const InputDecoration(labelText: 'Strength')), TextField(controller: dose, decoration: const InputDecoration(labelText: 'Dose'))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save'))]));\n  if (result == true && name.text.trim().isNotEmpty) { await ref.read(medicationRepositoryProvider).save(id: DateTime.now().microsecondsSinceEpoch.toString(), patientId: patientId, nameEn: name.text.trim(), nameAr: arabic.text.trim(), strength: strength.text.trim(), doseUnit: dose.text.trim().isEmpty ? 'unit' : dose.text.trim()); ref.invalidate(medicationsForPatientProvider(patientId)); }\n}\n\nclass MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientId = 'current-patient';
    final medications = ref.watch(medicationsForPatientProvider(patientId));
    return AppScaffold(title: 'Medicines', child: medications.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Unable to load medicines: $e')),
      data: (items) => ListView(padding: const EdgeInsets.all(24), children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Your medicines', style: Theme.of(context).textTheme.headlineMedium), FilledButton.icon(onPressed: () => _addMedicine(context, ref, patientId), icon: const Icon(Icons.add), label: const Text('Add medicine'))]),
        const SizedBox(height: 18),
        if (items.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('No medicines yet. Add a medicine even when stock has not been recorded.'))),
        ...items.map((medicine) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.medication_outlined)), title: Text(medicine.nameEn), subtitle: Text([medicine.nameAr, medicine.strength, medicine.dosageForm].whereType<String>().where((v) => v.isNotEmpty).join(' · ')), trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))))),
      ]),
    ));
  }
}

