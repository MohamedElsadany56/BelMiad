import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../medications/data/medication_repository.dart';
import '../../medications/presentation/medications_screen.dart';
import '../data/inventory_repository.dart';

/// Add stock (from inventory, medication details, or after creating a
/// medication) or edit an existing batch (spec §13, §20).
class BatchFormScreen extends ConsumerStatefulWidget {
  const BatchFormScreen({this.medicationId, this.batchId, super.key});

  final String? medicationId;
  final String? batchId;

  @override
  ConsumerState<BatchFormScreen> createState() => _BatchFormScreenState();
}

class _BatchFormScreenState extends ConsumerState<BatchFormScreen> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _packages = TextEditingController(text: '1');
  final _unitsPerPackage = TextEditingController();
  final _price = TextEditingController();
  final _notes = TextEditingController();
  String? _medicationId;
  bool _byPackages = true;
  String _packaging = 'box';
  String? _purchaseDate = LocalDate.fromDateTime(DateTime.now()).toIso();
  String? _expirationDate;
  bool _hasHistory = false;
  bool _loading = true;
  bool _busy = false;

  bool get _editing => widget.batchId != null;

  @override
  void initState() {
    super.initState();
    _medicationId = widget.medicationId;
    _load();
  }

  Future<void> _load() async {
    final id = widget.batchId;
    if (id != null) {
      final repo = ref.read(inventoryRepositoryProvider);
      final batch = await repo.getBatch(id);
      if (batch != null) {
        _medicationId = batch.medicationId;
        _hasHistory = await repo.hasHistory(id);
        _byPackages =
            batch.packagesCount != null && batch.unitsPerPackage != null;
        _packages.text = '${batch.packagesCount ?? 1}';
        _unitsPerPackage.text = '${batch.unitsPerPackage ?? ''}';
        _quantity.text = formatScaled(batch.initialQuantityScaled);
        _packaging = batch.packagingType ?? 'box';
        _purchaseDate = batch.purchaseDate;
        _expirationDate = batch.expirationDate;
        _price.text = batch.purchasePrice?.toStringAsFixed(2) ?? '';
        _notes.text = batch.notes ?? '';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [_quantity, _packages, _unitsPerPackage, _price, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _packageTotal {
    final packages = int.tryParse(_packages.text);
    final units = int.tryParse(_unitsPerPackage.text);
    if (packages == null || units == null) return null;
    return ScaledQuantity.fromPackages(
      packages: packages,
      unitsPerPackage: units,
    ).scaled;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _medicationId == null) return;
    final price = double.tryParse(_price.text.replaceAll(',', '.'));
    final input = _byPackages
        ? BatchInput.fromPackages(
            medicationId: _medicationId!,
            packagesCount: int.parse(_packages.text),
            unitsPerPackage: int.parse(_unitsPerPackage.text),
            packagingType: _packaging,
            purchaseDate: _purchaseDate,
            purchasePrice: price,
            expirationDate: _expirationDate,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          )
        : BatchInput(
            medicationId: _medicationId!,
            quantityScaled: ScaledQuantity.tryParse(_quantity.text)!.scaled,
            packagingType: _packaging,
            purchaseDate: _purchaseDate,
            purchasePrice: price,
            expirationDate: _expirationDate,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          );
    setState(() => _busy = true);
    final repo = ref.read(inventoryRepositoryProvider);
    final ok = await runGuarded(context, () async {
      if (_editing) {
        await repo.updateBatch(widget.batchId!, input);
      } else {
        await repo.addBatch(input);
      }
    }, success: context.l10n.savedMessage);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      ref.read(syncCoordinatorProvider).request();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    if (_loading || patientId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final medications =
        (ref.watch(patientMedicationsProvider(patientId)).valueOrNull ??
                const <Medication>[])
            .where((m) =>
                m.status == MedicationStatus.active ||
                m.medicationId == _medicationId)
            .toList();
    final selected =
        medications.where((m) => m.medicationId == _medicationId).firstOrNull;
    final unit = unitLabel(selected?.doseUnit ?? 'unit', l10n);
    final quantityLocked = _editing && _hasHistory;

    return Scaffold(
      appBar: AppBar(title: Text(_editing ? l10n.editBatch : l10n.addStock)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(l10n.save),
      ),
      body: Form(
        key: _form,
        child: FormBody(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _medicationId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.selectMedication),
              validator: (v) => v == null ? l10n.requiredField : null,
              items: [
                for (final m in medications)
                  DropdownMenuItem(
                    value: m.medicationId,
                    child: Text(
                      medicationDisplayName(m, arabic: context.isArabic),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged:
                  _editing ? null : (v) => setState(() => _medicationId = v),
            ),
            if (quantityLocked)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.useAdjustmentNote),
                ),
              ),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(l10n.byPackages)),
                ButtonSegment(value: false, label: Text(l10n.byQuantity)),
              ],
              selected: {_byPackages},
              onSelectionChanged: quantityLocked
                  ? null
                  : (v) => setState(() => _byPackages = v.first),
            ),
            DropdownButtonFormField<String>(
              initialValue: _packaging,
              decoration: InputDecoration(labelText: l10n.packagingType),
              items: [
                for (final p in PackagingTypes.all)
                  DropdownMenuItem(
                      value: p, child: Text(packagingLabel(p, l10n))),
              ],
              onChanged: (v) => setState(() => _packaging = v ?? 'box'),
            ),
            if (_byPackages) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _packages,
                      enabled: !quantityLocked,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: l10n.packagesCount),
                      onChanged: (_) => setState(() {}),
                      validator: (v) => (int.tryParse(v ?? '') ?? -1) < 0
                          ? l10n.error_invalidPackages
                          : null,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('×'),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _unitsPerPackage,
                      enabled: !quantityLocked,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.unitsPerPackage,
                        suffixText: unit,
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) => (int.tryParse(v ?? '') ?? 0) < 1
                          ? l10n.error_quantityRequired
                          : null,
                    ),
                  ),
                ],
              ),
              if (_packageTotal != null)
                Text(
                  l10n.packagesTotal(quantityWithUnit(
                      _packageTotal, selected?.doseUnit ?? 'unit', l10n)),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
            ] else
              TextFormField(
                controller: _quantity,
                enabled: !quantityLocked,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.availableQuantity,
                  suffixText: unit,
                ),
                validator: (v) => validateQuantity(v, l10n, allowZero: true),
              ),
            DateField(
              label: l10n.expirationDate,
              value: _expirationDate,
              onChanged: (v) => setState(() => _expirationDate = v),
            ),
            DateField(
              label: l10n.purchaseDate,
              value: _purchaseDate,
              onChanged: (v) => setState(() => _purchaseDate = v),
            ),
            TextFormField(
              controller: _price,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.purchasePrice),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final value = double.tryParse(v.replaceAll(',', '.'));
                return value == null || value < 0
                    ? l10n.error_invalidPrice
                    : null;
              },
            ),
            if (selected?.catalogPriceEgp != null)
              Text(
                '${l10n.catalogPrice(selected!.catalogPriceEgp!.toStringAsFixed(2))} · ${l10n.referencePriceNote}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            TextFormField(
              controller: _notes,
              decoration: InputDecoration(labelText: l10n.notes),
            ),
          ],
        ),
      ),
    );
  }
}
