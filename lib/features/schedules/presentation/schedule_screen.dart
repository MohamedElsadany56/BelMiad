import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../doses/data/dose_repository.dart';

final todaysDosesProvider = FutureProvider.autoDispose((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.select(db.doseInstances).get();
});

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doses = ref.watch(todaysDosesProvider);
    return AppScaffold(
      title: 'Medicine schedule',
      child: doses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Unable to load schedule: $e')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medicine schedule',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add schedule'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Scheduled doses remain visible until they are taken, skipped, or marked missed.',
            ),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No dose instances have been generated yet.'),
                ),
              ),
            ...items.map(
              (dose) => Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.medication_outlined),
                  ),
                  title: Text(
                    'Dose at ${dose.scheduledAt.toLocal().toString().substring(11, 16)}',
                  ),
                  subtitle: Text(
                    '${dose.requiredQuantityScaled / dose.quantityScale} units · ${dose.status}',
                  ),
                  trailing: dose.status == 'SCHEDULED'
                      ? Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: 'Taken',
                              onPressed: () async {
                                final db = await ref.read(
                                  databaseProvider.future,
                                );
                                await DoseRepository(db).markTaken(
                                  dose.id,
                                  actualQuantityScaled:
                                      dose.requiredQuantityScaled,
                                );
                                ref.invalidate(todaysDosesProvider);
                              },
                              icon: const Icon(Icons.check_circle_outline),
                            ),
                            IconButton(
                              tooltip: 'Skip',
                              onPressed: () async {
                                final db = await ref.read(
                                  databaseProvider.future,
                                );
                                await DoseRepository(db).skip(dose.id);
                                ref.invalidate(todaysDosesProvider);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        )
                      : Chip(label: Text(dose.status)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
