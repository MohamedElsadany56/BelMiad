import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';

final healthRecordsProvider = FutureProvider.autoDispose((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.select(db.healthRecords).get();
});

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
                  onPressed: () {},
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
                        '${record.type} · ${record.occurredAt.toLocal().toString().split(' ').first}')))),
          ]),
        ));
  }
}
