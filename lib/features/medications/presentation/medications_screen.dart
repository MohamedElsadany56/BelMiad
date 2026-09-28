import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_scaffold.dart';
import '../data/medication_providers.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientId = 'current-patient';
    final medications = ref.watch(medicationsForPatientProvider(patientId));
    return AppScaffold(title: 'Medicines', child: medications.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Unable to load medicines: $e')),
      data: (items) => ListView(padding: const EdgeInsets.all(24), children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Your medicines', style: Theme.of(context).textTheme.headlineMedium), FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Add medicine'))]),
        const SizedBox(height: 18),
        if (items.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('No medicines yet. Add a medicine even when stock has not been recorded.'))),
        ...items.map((medicine) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.medication_outlined)), title: Text(medicine.nameEn), subtitle: Text([medicine.nameAr, medicine.strength, medicine.dosageForm].whereType<String>().where((v) => v.isNotEmpty).join(' · ')), trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))))),
      ]),
    ));
  }
}
