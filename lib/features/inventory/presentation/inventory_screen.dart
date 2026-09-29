import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../../../app/widgets/file_actions.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../medications/data/medication_repository.dart';
import '../../medications/presentation/medications_screen.dart';
import '../../reports/application/pdf_report_service.dart';
import '../../reports/domain/report_models.dart';
import '../application/stock_forecast_service.dart';

/// Inventory dashboard (spec §25).
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryTitle),
        actions: [
          IconButton(
            tooltip: l10n.storageReport,
            icon: const Icon(Icons.summarize_outlined),
            onPressed: () => context.push('/inventory/report'),
          ),
          const PatientSwitcher(),
        ],
      ),
      floatingActionButton: ref.watch(currentPatientIdProvider) == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push('/inventory/add'),
              icon: const Icon(Icons.add),
              label: Text(l10n.addStock),
            ),
      body: RequirePatient(
        builder: (patientId) => AsyncBody(
          value: ref.watch(inventoryDashboardProvider(patientId)),
          builder: (data) => _Dashboard(data: data),
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.data});

  final InventoryDashboardData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.statusColors;
    final tiles = [
      (l10n.totalMedications, data.totalMedications, BrandColors.blue),
      (l10n.withStock, data.withStock, colors.success),
      (l10n.lowStock, data.lowStock, colors.warning),
      (l10n.emptyStock, data.emptyStock, colors.danger),
      (l10n.expiringSoon, data.expiringSoon, colors.warning),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 600 ? 5 : 3;
            final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (label, value, color) in tiles)
                  SizedBox(
                    width: width,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$value',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              label,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        if (data.items.isEmpty)
          EmptyState(
              icon: Icons.inventory_2_outlined, message: l10n.noMedications),
        for (final item in data.items)
          Card(
            child: ListTile(
              title: Text(
                medicationDisplayName(item.medication,
                    arabic: context.isArabic),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.summary.stockRecorded
                          ? quantityWithUnit(
                              item.summary.usableScaled,
                              item.medication.doseUnit,
                              l10n,
                            )
                          : l10n.stockNotRecorded,
                    ),
                    Text(remainingDaysText(item.summary, l10n)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        StockStateBadge(state: item.summary.state),
                        if (item.medication.storageOnly)
                          StatusBadge(l10n.storageBadge),
                        if (item.summary.isLowStock &&
                            item.summary.hasExpiringBatch)
                          StatusBadge(l10n.expiringSoon,
                              tone: BadgeTone.warning),
                      ],
                    ),
                  ],
                ),
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                '/medications/${item.medication.medicationId}?tab=2',
              ),
            ),
          ),
      ],
    );
  }
}

final _inventoryReportProvider =
    FutureProvider.autoDispose.family<InventoryReport, (String, bool)>(
  (ref, key) => ref
      .watch(reportServiceProvider)
      .inventoryReport(patientId: key.$1, arabic: key.$2),
);

/// Storage/inventory report (spec §26): what we have and what to buy.
class InventoryReportScreen extends ConsumerWidget {
  const InventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patient = ref.watch(currentPatientProvider);
    if (patient == null) return const Scaffold();
    final report =
        ref.watch(_inventoryReportProvider((patient.id, context.isArabic)));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.storageReport),
        actions: [
          IconButton(
            tooltip: l10n.exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: report.valueOrNull == null
                ? null
                : () => _export(context, ref, report.value!, patient.timezone),
          ),
        ],
      ),
      body: AsyncBody(
        value: report,
        builder: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            SectionHeader(l10n.whatToBuy),
            if (data.toPurchase.isEmpty) Text(l10n.nothingToBuy),
            for (final row in data.toPurchase) _ReportRow(row: row),
            SectionHeader(l10n.whatWeHave),
            for (final row in data.rows) _ReportRow(row: row),
          ],
        ),
      ),
    );
  }

  Future<void> _export(
    BuildContext context,
    WidgetRef ref,
    InventoryReport report,
    String timezone,
  ) async {
    final l10n = context.l10n;
    try {
      final bytes = await ref.read(pdfReportServiceProvider).inventoryReport(
            report,
            l10n,
            timezone: timezone,
            unitLabel: (code) => unitLabel(code, l10n),
          );
      if (!context.mounted) return;
      await saveOrShareFile(
        context,
        bytes: bytes,
        fileName: 'belmiad_storage_report.pdf',
        mimeType: 'application/pdf',
      );
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.row});

  final InventoryReportRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = row.summary;
    final unit = row.medication.doseUnit;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StockStateBadge(state: s.state),
              ],
            ),
            const SizedBox(height: 6),
            Text(
                '${l10n.currentQuantity}: ${quantityWithUnit(s.usableScaled, unit, l10n)}'),
            Text('${l10n.batchCount}: ${row.batchCount}'),
            Text('${l10n.remainingDays}: ${remainingDaysText(s, l10n)}'),
            if (s.earliestExpiration != null)
              Text(
                '${l10n.earliestExpiration}: ${formatIsoDate(context, s.earliestExpiration!.toIso())}',
              ),
            if (s.expiredScaled > 0)
              Text('${l10n.expiredQuantity}: ${formatScaled(s.expiredScaled)}'),
            if (row.lastPurchaseDate != null || row.lastPurchasePrice != null)
              Text(
                '${l10n.lastPurchase}: ${formatIsoDate(context, row.lastPurchaseDate)}'
                '${row.lastPurchasePrice == null ? '' : ' · ${row.lastPurchasePrice!.toStringAsFixed(2)}'}',
              ),
          ],
        ),
      ),
    );
  }
}
