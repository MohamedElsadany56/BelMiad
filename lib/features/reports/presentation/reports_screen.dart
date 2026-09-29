import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/inventory_report.dart';

final inventoryReportProvider = FutureProvider.autoDispose<InventoryReport>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final medications = await db.select(db.medications).get();
  final batches = await db.select(db.inventoryBatches).get();
  final rows = <InventoryReportRow>[];
  for (final medication in medications) {
    final medicationBatches = batches
        .where((batch) => batch.medicationId == medication.id)
        .toList();
    if (medicationBatches.isEmpty) continue;
    final available = medicationBatches.fold<int>(
        0, (sum, batch) => sum + batch.availableQuantityScaled);
    final scale = medicationBatches.first.quantityScale;
    final expirations = medicationBatches
        .map((batch) => batch.expirationDate)
        .whereType<DateTime>()
        .toList()
      ..sort();
    rows.add(InventoryReportRow(
      medicationName: medication.nameEn,
      quantity: available ~/ scale,
      unit: medication.doseUnit,
      batchCount: medicationBatches.length,
      earliestExpiration: expirations.isEmpty ? null : expirations.first,
      stockState: available == 0
          ? 'OUT'
          : available <= scale
              ? 'LOW'
              : 'OK',
    ));
  }
  rows.sort((a, b) => a.medicationName.compareTo(b.medicationName));
  return InventoryReport(rows);
});

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(inventoryReportProvider);
    return AppScaffold(
      title: 'Reports',
      child: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Unable to load reports: $error')),
        data: (inventory) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Inventory report', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${inventory.rows.length} medicines · ${inventory.totalUnits} total units'),
            const SizedBox(height: 18),
            if (inventory.rows.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Add stock batches to generate an inventory report.'),
                ),
              ),
            ...inventory.rows.map(
              (row) => Card(
                child: ListTile(
                  leading: Icon(
                    row.stockState == 'OK'
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_outlined,
                  ),
                  title: Text(row.medicationName),
                  subtitle: Text(
                    '${row.quantity} ${row.unit} · ${row.batchCount} batch(es)',
                  ),
                  trailing: Text(row.stockState),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
