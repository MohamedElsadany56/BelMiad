import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/app_scaffold.dart';
import '../../../app/localization/app_localization.dart';
import '../../../core/providers/database_provider.dart';
import '../../patients/data/patient_providers.dart';
import '../data/pdf_report_service.dart';
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

  Future<void> _exportInventoryReport(
    BuildContext context,
    WidgetRef ref,
    InventoryReport report,
  ) async {
    final patients = await ref.read(patientsProvider.future);
    final bytes = await PdfReportService().buildInventoryReport(
      patientName: patients.isEmpty ? 'Patient' : patients.first.name,
      report: report,
    );
    await Share.shareXFiles([
      XFile.fromData(
        bytes,
        name: 'belmiad_inventory_report.pdf',
        mimeType: 'application/pdf',
      ),
    ], subject: 'BelMiad inventory report');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(localeProvider));
    final report = ref.watch(inventoryReportProvider);
    return AppScaffold(
      title: 'Reports',
      child: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Unable to load reports: $error')),
        data: (inventory) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(strings.text('inventoryReport'), style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${inventory.rows.length} medicines · ${inventory.totalUnits} total units'),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: inventory.rows.isEmpty
                  ? null
                  : () => _exportInventoryReport(context, ref, inventory),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
            ),
            const SizedBox(height: 12),
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
