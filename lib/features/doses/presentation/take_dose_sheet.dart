import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../inventory/domain/batch_selection.dart';
import '../../medications/data/medication_repository.dart';
import '../application/dose_service.dart';

/// Opens the dose confirmation flow for a scheduled dose.
Future<void> showTakeDoseSheet(
  BuildContext context,
  WidgetRef ref, {
  required String doseInstanceId,
}) async {
  final dose = ref.read(doseServiceProvider);
  final TakeDoseContext data;
  try {
    data = await dose.prepareTake(doseInstanceId);
  } catch (error) {
    if (context.mounted) showError(context, error);
    return;
  }
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => TakeDoseSheet(data: data),
  );
}

/// Opens the as-needed (PRN) logging flow for [medicationId].
Future<void> showPrnSheet(
  BuildContext context,
  WidgetRef ref, {
  required String medicationId,
}) async {
  final TakeDoseContext data;
  try {
    data = await ref
        .read(doseServiceProvider)
        .preparePrn(medicationId, quantityScaled: quantityScale);
  } catch (error) {
    if (context.mounted) showError(context, error);
    return;
  }
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => TakeDoseSheet(data: data),
  );
}

class TakeDoseSheet extends ConsumerStatefulWidget {
  const TakeDoseSheet({required this.data, super.key});

  final TakeDoseContext data;

  @override
  ConsumerState<TakeDoseSheet> createState() => _TakeDoseSheetState();
}

class _TakeDoseSheetState extends ConsumerState<TakeDoseSheet> {
  late final TextEditingController _quantity;
  final _manual = <String, TextEditingController>{};
  bool _manualMode = false;
  bool _busy = false;
  String? _quantityError;

  TakeDoseContext get data => widget.data;
  bool get isPrn => data.dose == null;

  @override
  void initState() {
    super.initState();
    final initial = data.isInsufficient
        ? ScaledQuantity.min(
            ScaledQuantity(data.usableScaled),
            ScaledQuantity(data.requiredScaled),
          )
        : ScaledQuantity(data.requiredScaled);
    _quantity = TextEditingController(text: initial.format());
    for (final batch in data.usableBatches) {
      _manual[batch.inventoryBatchId] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _quantity.dispose();
    for (final c in _manual.values) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _actualScaled => ScaledQuantity.tryParse(_quantity.text)?.scaled;

  int get _manualTotal => _manual.values.fold(
        0,
        (sum, c) => sum + (ScaledQuantity.tryParse(c.text)?.scaled ?? 0),
      );

  void _setQuantity(int scaled) {
    setState(() {
      _quantity.text = ScaledQuantity(scaled).format();
      _quantityError = null;
    });
  }

  Future<void> _submit({bool overrideMaximum = false}) async {
    final l10n = context.l10n;
    final actual = _actualScaled;
    if (actual == null) {
      setState(() => _quantityError = l10n.error_invalidQuantity);
      return;
    }
    if (actual == 0) {
      await _handleZero();
      return;
    }
    List<BatchAllocation>? manual;
    if (_manualMode && data.stockRecorded) {
      manual = [
        for (final entry in _manual.entries)
          if ((ScaledQuantity.tryParse(entry.value.text)?.scaled ?? 0) > 0)
            BatchAllocation(
              batchId: entry.key,
              quantityScaled: ScaledQuantity.tryParse(entry.value.text)!.scaled,
            ),
      ];
    }
    setState(() => _busy = true);
    final service = ref.read(doseServiceProvider);
    final settings = await ref.read(settingsRepositoryProvider).load();
    try {
      if (isPrn) {
        await service.logPrnDose(
          medicationId: data.medication.medicationId,
          actualQuantityScaled: actual,
          manualAllocations: manual,
          overrideMaximum: overrideMaximum,
        );
      } else {
        await service.takeDose(
          doseInstanceId: data.dose!.doseInstanceId,
          actualQuantityScaled: actual,
          manualAllocations: manual,
          overrideMaximum: overrideMaximum,
          graceMinutes: settings.missedGraceMinutes,
        );
      }
      ref.read(syncCoordinatorProvider).request();
      if (!mounted) return;
      Navigator.pop(context);
      showMessage(context, l10n.doseTaken);
    } on MaximumDailyQuantityExceededException catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      final proceed = await confirmDialog(
        context,
        title: l10n.maxExceededTitle,
        body: l10n.maxExceededBody(
          quantityWithUnit(error.maximumScaled, data.medication.doseUnit, l10n),
          quantityWithUnit(
              error.alreadyTakenScaled, data.medication.doseUnit, l10n),
          quantityWithUnit(error.attemptScaled, data.medication.doseUnit, l10n),
        ),
        confirmLabel: l10n.recordAnyway,
        destructive: true,
      );
      if (proceed) await _submit(overrideMaximum: true);
    } on DoseWindowClosedException catch (error) {
      ref.read(syncCoordinatorProvider).request();
      if (!mounted) return;
      Navigator.pop(context);
      showError(context, error);
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      showError(context, error);
    }
  }

  /// Actual = 0: never TAKEN, no consumption; offer Skip or leave scheduled.
  Future<void> _handleZero() async {
    final l10n = context.l10n;
    if (isPrn) {
      Navigator.pop(context);
      return;
    }
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.zeroTakenNote),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'leave'),
            child: Text(l10n.leaveScheduled),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'skip'),
            child: Text(l10n.skip),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == 'skip') {
      final ok = await runGuarded(
        context,
        () => ref.read(doseServiceProvider).skipDose(data.dose!.doseInstanceId),
      );
      if (ok) ref.read(syncCoordinatorProvider).request();
    }
    if (mounted) {
      Navigator.pop(context);
      if (choice == 'skip') showMessage(context, l10n.doseSkippedMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final unit = unitLabel(data.medication.doseUnit, l10n);
    final name =
        medicationDisplayName(data.medication, arabic: context.isArabic);
    final actual = _actualScaled ?? 0;
    final suggested = data.suggestedAllocation(actual);
    final batchesById = {
      for (final b in data.usableBatches) b.inventoryBatchId: b,
    };

    final quickOptions = <int>{
      0,
      500,
      1000,
      if (data.isInsufficient) data.usableScaled,
      data.requiredScaled,
    }.where((q) => !data.stockRecorded || q <= data.usableScaled).toList()
      ..sort();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isPrn ? l10n.logPrn : name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (isPrn) Text(name),
              const SizedBox(height: 4),
              Text(
                '${l10n.requiredQuantity}: ${quantityWithUnit(data.requiredScaled, data.medication.doseUnit, l10n)}',
              ),
              if (data.maximumScaled != null)
                Text(l10n.maxPerDay(
                  quantityWithUnit(
                      data.maximumScaled, data.medication.doseUnit, l10n),
                )),
              const SizedBox(height: 12),
              if (!data.stockRecorded)
                _Note(icon: Icons.info_outline, text: l10n.stockNotRecordedNote)
              else if (data.isInsufficient)
                _Note(
                  icon: Icons.warning_amber_rounded,
                  warning: true,
                  text:
                      '${l10n.insufficientStockTitle}. ${l10n.insufficientStockBody(quantityWithUnit(data.requiredScaled, data.medication.doseUnit, l10n), quantityWithUnit(data.usableScaled, data.medication.doseUnit, l10n))}',
                ),
              const SizedBox(height: 12),
              Text(
                data.isInsufficient ? l10n.howMuchTaken : l10n.actualQuantity,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final option in quickOptions)
                    ChoiceChip(
                      label: Text(quantityWithUnit(
                          option, data.medication.doseUnit, l10n)),
                      selected: actual == option,
                      onSelected: (_) => _setQuantity(option),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _quantity,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.customAmount,
                  suffixText: unit,
                  errorText: _quantityError,
                ),
                onChanged: (_) => setState(() => _quantityError = null),
              ),
              if (data.stockRecorded && actual > 0) ...[
                const SizedBox(height: 16),
                Text(l10n.chooseBatches,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: false,
                      label: Text(l10n.automaticFefo),
                    ),
                    ButtonSegment(
                        value: true, label: Text(l10n.manualSelection)),
                  ],
                  selected: {_manualMode},
                  onSelectionChanged: (v) =>
                      setState(() => _manualMode = v.first),
                ),
                const SizedBox(height: 8),
                if (!_manualMode)
                  for (final allocation in suggested)
                    _BatchLine(
                      label: _batchLabel(
                        context,
                        batchesById[allocation.batchId]?.expirationDate,
                      ),
                      trailing: quantityWithUnit(allocation.quantityScaled,
                          data.medication.doseUnit, l10n),
                    )
                else ...[
                  for (final batch in data.usableBatches)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _manual[batch.inventoryBatchId],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: _batchLabel(context, batch.expirationDate),
                          helperText:
                              '${l10n.availableQuantity}: ${quantityWithUnit(batch.availableQuantityScaled, data.medication.doseUnit, l10n)}',
                          suffixText: unit,
                        ),
                      ),
                    ),
                  Text(
                    l10n.allocatedOf(
                      quantityWithUnit(
                          _manualTotal, data.medication.doseUnit, l10n),
                      quantityWithUnit(actual, data.medication.doseUnit, l10n),
                    ),
                    style: TextStyle(
                      color: _manualTotal == actual
                          ? null
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  if (!isPrn && data.isInsufficient)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy ? null : () => Navigator.pop(context),
                        child: Text(l10n.leaveScheduled),
                      ),
                    ),
                  if (!isPrn && data.isInsufficient) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _busy ? null : () => _submit(),
                      icon: const Icon(Icons.check),
                      label: Text(l10n.confirmTake),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _batchLabel(BuildContext context, String? expiration) =>
      expiration == null
          ? context.l10n.noExpiry
          : context.l10n.expiresOn(formatIsoDate(context, expiration));
}

class _BatchLine extends StatelessWidget {
  const _BatchLine({required this.label, required this.trailing});

  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.inventory_2_outlined),
        title: Text(label),
        trailing: Text(trailing),
      );
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text, this.warning = false});

  final IconData icon;
  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warning ? colors.warningContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: warning ? colors.warning : scheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
