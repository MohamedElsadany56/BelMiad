import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../catalog/data/drug_catalog_repository.dart';
import '../../catalog/presentation/catalog_search.dart';
import '../data/medication_repository.dart';

enum _NextStep { stock, schedule, later }

class MedicationFormScreen extends ConsumerStatefulWidget {
  const MedicationFormScreen({this.medicationId, super.key});

  final String? medicationId;

  @override
  ConsumerState<MedicationFormScreen> createState() =>
      _MedicationFormScreenState();
}

class _MedicationFormScreenState extends ConsumerState<MedicationFormScreen> {
  final _form = GlobalKey<FormState>();
  final _nameEn = TextEditingController();
  final _nameAr = TextEditingController();
  final _scientific = TextEditingController();
  final _strength = TextEditingController();
  final _dosageForm = TextEditingController();
  final _route = TextEditingController();
  final _instructionsEn = TextEditingController();
  final _instructionsAr = TextEditingController();
  final _maximum = TextEditingController();
  String _unit = 'tablet';
  String? _startDate;
  String? _endDate;
  bool _prn = false;
  String? _catalogId;
  double? _catalogPrice;
  bool _loading = true;
  bool _busy = false;
  bool _showForm = false;

  bool get _editing => widget.medicationId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.medicationId;
    if (id != null) {
      final m = await ref.read(medicationRepositoryProvider).get(id);
      if (m != null) {
        _nameEn.text = m.nameEn;
        _nameAr.text = m.nameAr ?? '';
        _scientific.text = m.scientificName ?? '';
        _strength.text = m.strength ?? '';
        _dosageForm.text = m.dosageForm ?? '';
        _route.text = m.route ?? '';
        _instructionsEn.text = m.instructionsEn ?? '';
        _instructionsAr.text = m.instructionsAr ?? '';
        _maximum.text = m.maximumDailyQuantityScaled == null
            ? ''
            : formatScaled(m.maximumDailyQuantityScaled);
        _unit = m.doseUnit;
        _startDate = m.startDate;
        _endDate = m.endDate;
        _prn = m.isPrn;
        _catalogId = m.catalogId;
        _catalogPrice = m.catalogPriceEgp;
      }
      _showForm = true;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _nameEn,
      _nameAr,
      _scientific,
      _strength,
      _dosageForm,
      _route,
      _instructionsEn,
      _instructionsAr,
      _maximum,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectCatalog(DrugSearchResult result) {
    rememberCatalogSelection(
      ref.read(sharedPreferencesProvider),
      result.catalogId,
    );
    setState(() {
      _catalogId = result.catalogId;
      _catalogPrice = result.priceEgp;
      _nameEn.text = result.nameEn;
      _nameAr.text = result.nameAr;
      _showForm = true;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final patientId = ref.read(currentPatientIdProvider);
    if (patientId == null) {
      showMessage(context, context.l10n.noPatientSelected);
      return;
    }
    final input = MedicationInput(
      nameEn: _nameEn.text.trim().isEmpty ? _nameAr.text : _nameEn.text,
      nameAr: _nameAr.text,
      catalogId: _catalogId,
      catalogPriceEgp: _catalogPrice,
      scientificName: _scientific.text,
      strength: _strength.text,
      dosageForm: _dosageForm.text,
      route: _route.text,
      doseUnit: _unit,
      instructionsEn: _instructionsEn.text,
      instructionsAr: _instructionsAr.text,
      startDate: _startDate,
      endDate: _endDate,
      isPrn: _prn,
      maximumDailyQuantityScaled: _maximum.text.trim().isEmpty
          ? null
          : ScaledQuantity.tryParse(_maximum.text)?.scaled,
    );
    final repo = ref.read(medicationRepositoryProvider);
    if (!_editing) {
      // Reuse an existing definition instead of creating a copy.
      final existing = await repo.findDuplicate(patientId, input);
      if (existing != null && mounted) {
        final l10n = context.l10n;
        final addAnyway = await confirmDialog(
          context,
          title: l10n.duplicateMedicationTitle,
          body: l10n.duplicateMedicationBody(
            medicationDisplayName(existing, arabic: context.isArabic),
          ),
          confirmLabel: l10n.addAnyway,
          cancelLabel: l10n.openExisting,
        );
        if (!mounted) return;
        if (!addAnyway) {
          context.pop();
          context.push('/medications/${existing.medicationId}');
          return;
        }
      }
    }
    if (!mounted) return;
    setState(() => _busy = true);
    String? createdId;
    final ok = await runGuarded(context, () async {
      if (_editing) {
        await repo.update(widget.medicationId!, input);
      } else {
        createdId = await repo.create(patientId, input);
      }
    });
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) return;
    ref.read(syncCoordinatorProvider).request(regeneratePatientId: patientId);
    if (_editing) {
      context.pop();
      return;
    }
    // After creating a medication, offer the next steps without forcing any
    // of them: stock and schedule can both be added later (spec §13).
    final next = await _askNextStep(context, allowSchedule: !_prn);
    if (!mounted) return;
    context.pop();
    context.push('/medications/$createdId');
    switch (next) {
      case _NextStep.stock:
        context.push('/inventory/add?medicationId=$createdId');
      case _NextStep.schedule:
        context.push('/medications/$createdId/schedules/new');
      case _NextStep.later:
        break;
    }
  }

  Future<_NextStep> _askNextStep(
    BuildContext context, {
    required bool allowSchedule,
  }) async {
    final l10n = context.l10n;
    final choice = await showModalBottomSheet<_NextStep>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.addMedicationNextTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(l10n.addMedicationNextBody),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, _NextStep.stock),
                icon: const Icon(Icons.inventory_2_outlined),
                label: Text(l10n.addStock),
              ),
              if (allowSchedule) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, _NextStep.schedule),
                  icon: const Icon(Icons.schedule),
                  label: Text(l10n.setSchedule),
                ),
              ],
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context, _NextStep.later),
                child: Text(l10n.later),
              ),
            ],
          ),
        ),
      ),
    );
    return choice ?? _NextStep.later;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(_editing ? l10n.editMedication : l10n.addMedication),
      ),
      floatingActionButton: _showForm
          ? FloatingActionButton.extended(
              heroTag: null,
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.check),
              label: Text(l10n.save),
            )
          : null,
      body: ReadableWidth(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : !_showForm
                  ? CatalogSearch(
                      onSelected: _selectCatalog,
                      onCustom: () => setState(() => _showForm = true),
                    )
                  : Form(key: _form, child: _fields(context))),
    );
  }

  Widget _fields(BuildContext context) {
    final l10n = context.l10n;
    return FormBody(
      children: [
        if (_catalogId != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_pharmacy_outlined),
              title: Text(l10n.fromCatalog),
              subtitle: Text(
                '${l10n.catalogPrice(_catalogPrice?.toStringAsFixed(2) ?? '-')}\n'
                '${l10n.referencePriceNote}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                tooltip: l10n.delete,
                icon: const Icon(Icons.link_off),
                onPressed: () => setState(() {
                  _catalogId = null;
                  _catalogPrice = null;
                }),
              ),
            ),
          ),
        TextFormField(
          controller: _nameEn,
          decoration: InputDecoration(labelText: l10n.nameEn),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) && _nameAr.text.trim().isEmpty
                  ? l10n.error_nameRequired
                  : null,
        ),
        TextFormField(
          controller: _nameAr,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(labelText: l10n.nameAr),
        ),
        TextFormField(
          controller: _strength,
          decoration: InputDecoration(labelText: l10n.strength),
        ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: doseUnits.contains(_unit) ? _unit : 'unit',
          decoration: InputDecoration(labelText: l10n.doseUnit),
          items: [
            for (final unit in doseUnits)
              DropdownMenuItem(value: unit, child: Text(unitLabel(unit, l10n))),
          ],
          onChanged: (v) => setState(() => _unit = v ?? 'tablet'),
        ),
        TextFormField(
          controller: _dosageForm,
          decoration: InputDecoration(labelText: l10n.dosageForm),
        ),
        TextFormField(
          controller: _route,
          decoration: InputDecoration(labelText: l10n.route),
        ),
        TextFormField(
          controller: _scientific,
          decoration: InputDecoration(labelText: l10n.scientificName),
        ),
        Text(l10n.instructionsSeparateNote,
            style: Theme.of(context).textTheme.bodySmall),
        TextFormField(
          controller: _instructionsEn,
          textDirection: TextDirection.ltr,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(labelText: l10n.instructionsEn),
        ),
        TextFormField(
          controller: _instructionsAr,
          textDirection: TextDirection.rtl,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(labelText: l10n.instructionsAr),
        ),
        Row(
          children: [
            Expanded(
              child: DateField(
                label: l10n.startDate,
                value: _startDate,
                onChanged: (v) => setState(() => _startDate = v),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DateField(
                label: l10n.endDate,
                value: _endDate,
                onChanged: (v) => setState(() => _endDate = v),
              ),
            ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _prn,
          title: Text(l10n.prn),
          subtitle: Text(l10n.prnHint),
          onChanged: (v) => setState(() => _prn = v),
        ),
        TextFormField(
          controller: _maximum,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${l10n.maximumDaily} (${l10n.optional})',
            helperText: l10n.maximumDailyHint,
            suffixText: unitLabel(_unit, l10n),
          ),
          validator: (v) => validateQuantity(v, l10n, required: false),
        ),
      ],
    );
  }
}
