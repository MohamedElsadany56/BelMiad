import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../audit/data/audit_log.dart';
import '../../medications/presentation/medications_screen.dart';
import '../../reports/application/pdf_report_service.dart';
import '../data/inventory_repository.dart';
import '../domain/partial_pack.dart';
import '../domain/strip_model.dart';
import 'med_strip.dart';
import '../domain/stock_forecast.dart';

final _adjustmentsProvider =
    StreamProvider.family<List<InventoryAdjustment>, String>(
  (ref, id) => ref.watch(inventoryRepositoryProvider).watchAdjustments(id),
);

final _consumptionProvider =
    StreamProvider.family<List<ConsumptionEntry>, String>(
  (ref, id) => ref.watch(inventoryRepositoryProvider).watchConsumption(id),
);

/// Medication inventory details (spec §25): totals, remaining days, state,
/// batches with expiration and purchase info, inventory and consumption
/// history.
class MedicationStockTab extends ConsumerWidget {
  const MedicationStockTab({required this.medication, super.key});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stock = ref.watch(medicationStockProvider(medication.medicationId));
    final settings = ref.watch(settingsProvider).valueOrNull;
    final time = ref.watch(patientTimeProvider);
    final today = time.today(DateTime.now().toUtc());
    final unit = medication.doseUnit;
    return AsyncBody(
      value: stock,
      builder: (data) {
        if (data == null) return const SizedBox.shrink();
        final summary = data.summary;
        final batches = [...data.batches]..sort(
            (a, b) => (a.expirationDate ?? '9999').compareTo(
              b.expirationDate ?? '9999',
            ),
          );
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            summary.stockRecorded
                                ? quantityWithUnit(
                                    summary.usableScaled, unit, l10n)
                                : l10n.stockNotRecorded,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        StockStateBadge(state: summary.state),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.totalQuantity),
                    const Divider(height: 24),
                    _Stat(l10n.remainingDays, remainingDaysText(summary, l10n)),
                    _Stat(
                      l10n.projectedThreeDays,
                      quantityWithUnit(
                          summary.projectedThreeDayScaled, unit, l10n),
                    ),
                    if (summary.expiredScaled > 0)
                      _Stat(
                        l10n.expiredQuantity,
                        quantityWithUnit(summary.expiredScaled, unit, l10n),
                      ),
                    if (summary.earliestExpiration != null)
                      _Stat(
                        l10n.earliestExpiration,
                        formatIsoDate(
                            context, summary.earliestExpiration!.toIso()),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => context.push(
                '/inventory/add?medicationId=${medication.medicationId}',
              ),
              icon: const Icon(Icons.add),
              label: Text(l10n.addStock),
            ),
            SectionHeader(l10n.batches),
            if (batches.isEmpty) Text(l10n.noBatches),
            for (final batch in batches)
              _BatchCard(
                batch: batch,
                medication: medication,
                today: today,
                expiringWithinDays: settings?.expiringWithinDays ?? 30,
                lowStock: summary.isLowStock,
              ),
            SectionHeader(l10n.adjustmentHistory),
            ...ref
                .watch(_adjustmentsProvider(medication.medicationId))
                .maybeWhen(
                  data: (rows) => rows.isEmpty
                      ? [Text(l10n.noData)]
                      : [
                          for (final a in rows)
                            ListTile(
                              dense: true,
                              leading: Icon(
                                a.deltaScaled > 0
                                    ? Icons.add_circle_outline
                                    : Icons.remove_circle_outline,
                              ),
                              title: Text(
                                '${adjustmentReasonLabel(a.reason, l10n)} · '
                                '${a.deltaScaled > 0 ? '+' : ''}${formatScaled(a.deltaScaled)}',
                              ),
                              subtitle: Text(
                                '${l10n.quantityChange(formatScaled(a.previousQuantityScaled), formatScaled(a.newQuantityScaled))} · '
                                '${formatDateTime(context, time.toLocal(a.occurredAt))}'
                                '${a.notes == null ? '' : '\n${a.notes}'}',
                              ),
                            ),
                        ],
                  orElse: () => const [],
                ),
            SectionHeader(l10n.consumptionHistory),
            ...ref
                .watch(_consumptionProvider(medication.medicationId))
                .maybeWhen(
                  data: (rows) => rows.isEmpty
                      ? [Text(l10n.noData)]
                      : [
                          for (final c in rows)
                            ListTile(
                              dense: true,
                              leading: Icon(
                                c.consumption.reversedAt == null
                                    ? Icons.medication
                                    : Icons.undo,
                              ),
                              title: Text(
                                '-${quantityWithUnit(c.consumption.quantityScaled, unit, l10n)}'
                                '${c.consumption.manuallySelected ? ' · ${l10n.manual}' : ''}',
                              ),
                              subtitle: Text(
                                '${l10n.consumedForDose(formatDateTime(context, time.toLocal(c.dose.scheduledAt)))}\n'
                                '${c.batch.expirationDate == null ? l10n.noExpiry : l10n.expiresOn(formatIsoDate(context, c.batch.expirationDate))}'
                                '${c.consumption.reversedAt == null ? '' : ' · ${l10n.reversed}'}',
                              ),
                            ),
                        ],
                  orElse: () => const [],
                ),
          ],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _BatchCard extends ConsumerWidget {
  const _BatchCard({
    required this.batch,
    required this.medication,
    required this.today,
    required this.expiringWithinDays,
    this.lowStock = false,
  });

  final InventoryBatch batch;
  final Medication medication;
  final LocalDate today;
  final int expiringWithinDays;
  final bool lowStock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final expiry = LocalDate.tryParse(batch.expirationDate);
    final state = expirationStateOf(
      expiry,
      today: today,
      expiringWithinDays: expiringWithinDays,
    );
    final (label, tone) = batch.isDepleted
        ? (l10n.depleted, BadgeTone.neutral)
        : switch (state) {
            ExpirationState.expired => (l10n.expired, BadgeTone.danger),
            ExpirationState.expiresToday => (
                l10n.expiresToday,
                BadgeTone.warning
              ),
            ExpirationState.expiresSoon => (
                l10n.expiresInDays(today.daysUntil(expiry!)),
                BadgeTone.warning,
              ),
            ExpirationState.none => (
                expiry == null
                    ? l10n.noExpiry
                    : l10n.expiresOn(
                        formatIsoDate(context, batch.expirationDate)),
                BadgeTone.success,
              ),
          };
    final purchase = [
      if (batch.purchaseDate != null)
        '${l10n.purchaseDate}: ${formatIsoDate(context, batch.purchaseDate)}',
      if (batch.purchasePrice != null)
        '${l10n.purchasePrice}: ${batch.purchasePrice!.toStringAsFixed(2)}',
      if (batch.packagesCount != null &&
          batch.packagesCount! > 0 &&
          batch.unitsPerPackage != null)
        [
              '${batch.packagesCount} ${packagingLabel(batch.packagingType, l10n)}',
              if (batch.subPackagesPerPackage != null)
                '${batch.subPackagesPerPackage} ${packagingLabel(batch.subPackagingType, l10n)}',
              '${batch.unitsPerPackage} ${unitLabelFor(medication.doseUnit, null, l10n)}',
            ].join(' × ') +
            (batch.looseQuantityScaled == null
                ? ''
                : ' + ${formatScaled(batch.looseQuantityScaled)}'),
      for (final pack in decodePartialPacks(batch.partialPacksJson))
        l10n.partialPackOf(
          packagingLabel(pack.type, l10n),
          formatScaled(pack.remainingScaled),
          pack.capacity ?? '?',
        ),
    ].join('\n');
    final strip = stripStateFor(
      unitsPerPackage: batch.unitsPerPackage,
      availableScaled: batch.availableQuantityScaled,
      scale: batch.quantityScale,
    );
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              quantityWithUnit(
                  batch.availableQuantityScaled, medication.doseUnit, l10n),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                StatusBadge(label, tone: tone),
                if (purchase.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(purchase),
                ],
              ],
            ),
            isThreeLine: purchase.isNotEmpty,
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'adjust':
                    await showAdjustStockSheet(context, batch, medication);
                  case 'edit':
                    context
                        .push('/inventory/batches/${batch.inventoryBatchId}');
                  case 'delete':
                    final ok = await confirmDialog(
                      context,
                      title: l10n.deleteBatchTitle,
                      body: l10n.deleteBatchBody,
                      confirmLabel: l10n.delete,
                      destructive: true,
                    );
                    if (!ok || !context.mounted) return;
                    await runGuarded(
                      context,
                      () => ref.read(trashRepositoryProvider).moveToTrash(
                            entityType: EntityTypes.inventoryBatch,
                            entityId: batch.inventoryBatchId,
                            patientId: medication.patientId,
                            label:
                                '${medication.nameEn} · ${formatScaled(batch.availableQuantityScaled)}',
                          ),
                      success: l10n.deletedMessage,
                    );
                    ref.read(syncCoordinatorProvider).request();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'adjust', child: Text(l10n.adjustStock)),
                PopupMenuItem(value: 'edit', child: Text(l10n.editBatch)),
                PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
              ],
            ),
          ),
          if (strip != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
              child: _BatchStrip(
                batch: batch,
                medication: medication,
                strip: strip,
                expired: state == ExpirationState.expired,
                lowStock: lowStock,
              ),
            ),
        ],
      ),
    );
  }
}

/// The strip of one batch. The quantity shown always comes from the
/// persisted batch (via the stock stream); tapping asks the inventory use
/// case to consume one unit.
class _BatchStrip extends ConsumerStatefulWidget {
  const _BatchStrip({
    required this.batch,
    required this.medication,
    required this.strip,
    required this.expired,
    required this.lowStock,
  });

  final InventoryBatch batch;
  final Medication medication;
  final StripState strip;
  final bool expired;
  final bool lowStock;

  @override
  ConsumerState<_BatchStrip> createState() => _BatchStripState();
}

class _BatchStripState extends ConsumerState<_BatchStrip> {
  bool _busy = false;

  Future<void> _consume() async {
    if (_busy) return;
    final l10n = context.l10n;
    final unit = widget.medication.doseUnit;
    setState(() => _busy = true);
    await runGuarded(
      context,
      () => ref
          .read(inventoryServiceProvider)
          .consumeUnit(widget.batch.inventoryBatchId),
      success: l10n.stripUnitUsed(quantityWithUnit(quantityScale, unit, l10n)),
    );
    ref.read(syncCoordinatorProvider).request();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final strip = widget.strip;
    return MedStrip(
      state: strip,
      unitLabel: unitLabelFor(
        widget.medication.doseUnit,
        strip.capacity * quantityScale,
        l10n,
      ),
      capsule: widget.medication.doseUnit == 'capsule',
      lowStock: widget.lowStock,
      enabled: !widget.expired && widget.batch.deletedAt == null,
      busy: _busy,
      disabledMessage: widget.expired ? l10n.stripDisabledExpired : null,
      onConsume: _consume,
    );
  }
}

Future<void> showAdjustStockSheet(
  BuildContext context,
  InventoryBatch batch,
  Medication medication,
) =>
    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AdjustStockSheet(batch: batch, medication: medication),
    );

class _AdjustStockSheet extends ConsumerStatefulWidget {
  const _AdjustStockSheet({required this.batch, required this.medication});

  final InventoryBatch batch;
  final Medication medication;

  @override
  ConsumerState<_AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends ConsumerState<_AdjustStockSheet> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _notes = TextEditingController();
  bool _add = false;
  String _reason = AdjustmentReasons.all.first;
  bool _busy = false;

  @override
  void dispose() {
    _quantity.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final amount = ScaledQuantity.tryParse(_quantity.text)!.scaled;
    setState(() => _busy = true);
    final ok = await runGuarded(
      context,
      () => ref.read(inventoryRepositoryProvider).adjustQuantity(
            batchId: widget.batch.inventoryBatchId,
            deltaScaled: _add ? amount : -amount,
            reason: _reason,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          ),
      success: context.l10n.savedMessage,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      ref.read(syncCoordinatorProvider).request();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final unit = unitLabel(widget.medication.doseUnit, l10n);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              Text(l10n.adjustStock,
                  style: Theme.of(context).textTheme.titleLarge),
              Text(
                '${l10n.availableQuantity}: ${quantityWithUnit(widget.batch.availableQuantityScaled, widget.medication.doseUnit, l10n)}',
              ),
              const SizedBox(height: 16),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: false,
                    icon: const Icon(Icons.remove),
                    label: Text(l10n.removeQuantity),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addQuantity),
                  ),
                ],
                selected: {_add},
                onSelectionChanged: (v) => setState(() => _add = v.first),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantity,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.quantity,
                  suffixText: unit,
                ),
                validator: (v) {
                  final error = validateQuantity(v, l10n);
                  if (error != null) return error;
                  final amount = ScaledQuantity.tryParse(v)!.scaled;
                  if (!_add && amount > widget.batch.availableQuantityScaled) {
                    return l10n.error_negativeStock;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _reason,
                decoration: InputDecoration(labelText: l10n.reason),
                items: [
                  for (final reason in AdjustmentReasons.all)
                    DropdownMenuItem(
                      value: reason,
                      child: Text(adjustmentReasonLabel(reason, l10n)),
                    ),
                ],
                onChanged: (v) => setState(() => _reason = v ?? _reason),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                decoration: InputDecoration(labelText: l10n.notes),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _busy ? null : _save,
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
