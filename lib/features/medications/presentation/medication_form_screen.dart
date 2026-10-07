import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../catalog/data/drug_catalog_repository.dart';
import '../../catalog/presentation/catalog_labels.dart';
import '../../catalog/presentation/catalog_search.dart';
import '../data/medication_repository.dart';

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

  /// The catalog entry picked for a new medicine, the other forms and sizes
  /// of the same medicine, and the values last filled in from the catalog.
  DrugSearchResult? _catalogEntry;
  List<DrugSearchResult> _variants = const [];
  CatalogSuggestion? _suggested;
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
    _applyCatalog(result);
    setState(() => _showForm = true);
    ref.read(catalogRepositoryProvider).variantsOf(result).then((variants) {
      if (mounted) setState(() => _variants = variants);
    });
  }

  /// Fills the form from a catalog entry. When switching to another form or
  /// size, fields the user already changed are left as they are.
  void _applyCatalog(DrugSearchResult entry) {
    final next = CatalogSuggestion.from(entry, context.l10n);
    final previous = _suggested;
    void fill(TextEditingController field, String value, String? before) {
      if (field.text.trim().isEmpty || field.text == before) field.text = value;
    }

    setState(() {
      fill(_nameEn, next.nameEn, previous?.nameEn);
      fill(_nameAr, next.nameAr, previous?.nameAr);
      fill(_strength, next.strength, previous?.strength);
      fill(_dosageForm, next.dosageForm, previous?.dosageForm);
      fill(_route, next.route, previous?.route);
      fill(_scientific, next.scientificName, previous?.scientificName);
      if (next.doseUnit != null &&
          (previous == null || _unit == previous.doseUnit)) {
        _unit = next.doseUnit!;
      }
      _catalogEntry = entry;
      _catalogId = entry.catalogId;
      _catalogPrice = entry.priceEgp;
      _suggested = next;
    });
  }

  /// Marks a field whose value still comes from the catalog.
  Widget? _suggestedMark(String current, String? suggested) =>
      suggested != null && suggested.isNotEmpty && current == suggested
          ? Tooltip(
              message: context.l10n.catalogSuggested,
              child: const Icon(Icons.auto_awesome_outlined, size: 18),
            )
          : null;

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final patientId = ref.read(currentPatientIdProvider);
    if (patientId == null) return;
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
    setState(() => _busy = true);
    final repo = ref.read(medicationRepositoryProvider);
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
    // After creating a medication, optionally add stock (spec §13).
    final l10n = context.l10n;
    final addStock = await confirmDialog(
      context,
      title: l10n.addStockNowTitle,
      body: l10n.addStockNowBody,
      confirmLabel: l10n.addStock,
      cancelLabel: l10n.later,
    );
    if (!mounted) return;
    context.pop();
    if (addStock) {
      context.push('/inventory/add?medicationId=$createdId');
    } else {
      context.push('/medications/$createdId');
    }
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
        if (_catalogId != null) _catalogCard(context),
        TextFormField(
          controller: _nameEn,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.nameEn,
            suffixIcon: _suggestedMark(_nameEn.text, _suggested?.nameEn),
          ),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) && _nameAr.text.trim().isEmpty
                  ? l10n.error_nameRequired
                  : null,
        ),
        TextFormField(
          controller: _nameAr,
          textDirection: TextDirection.rtl,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.nameAr,
            suffixIcon: _suggestedMark(_nameAr.text, _suggested?.nameAr),
          ),
        ),
        TextFormField(
          controller: _strength,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.strength,
            suffixIcon: _suggestedMark(_strength.text, _suggested?.strength),
          ),
        ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: doseUnits.contains(_unit) ? _unit : 'unit',
          decoration: InputDecoration(
            labelText: l10n.doseUnit,
            helperText:
                _suggested?.doseUnit != null && _unit == _suggested?.doseUnit
                    ? l10n.catalogSuggested
                    : null,
          ),
          items: [
            for (final unit in doseUnits)
              DropdownMenuItem(value: unit, child: Text(unitLabel(unit, l10n))),
          ],
          onChanged: (v) => setState(() => _unit = v ?? 'tablet'),
        ),
        TextFormField(
          controller: _dosageForm,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.dosageForm,
            suffixIcon:
                _suggestedMark(_dosageForm.text, _suggested?.dosageForm),
          ),
        ),
        TextFormField(
          controller: _route,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.route,
            suffixIcon: _suggestedMark(_route.text, _suggested?.route),
          ),
        ),
        TextFormField(
          controller: _scientific,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.scientificName,
            suffixIcon:
                _suggestedMark(_scientific.text, _suggested?.scientificName),
          ),
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

  /// Where the values came from, a reminder to check them, and the other
  /// forms and sizes of the same medicine.
  Widget _catalogCard(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final entry = _catalogEntry;
    final flags = entry?.facts?.flags ?? const <String>{};
    final others = _variants.length - 1;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.local_pharmacy_outlined),
            title: Text(l10n.fromCatalog),
            subtitle: Text(
              [
                if (entry != null) l10n.catalogSourceName(entry.nameEn),
                l10n.catalogPrice(_catalogPrice?.toStringAsFixed(2) ?? '-'),
                l10n.referencePriceNote,
              ].join('\n'),
            ),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.link_off),
              onPressed: () => setState(() {
                _catalogId = null;
                _catalogPrice = null;
                _catalogEntry = null;
                _variants = const [];
                _suggested = null;
              }),
            ),
          ),
          if (_suggested != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome_outlined,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.catalogAutofillNote,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          if (flags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final flag in flags)
                    StatusBadge(
                      drugFlagLabel(flag, l10n),
                      tone: BadgeTone.warning,
                      icon: Icons.warning_amber_rounded,
                    ),
                ],
              ),
            ),
          if (others > 0)
            ExpansionTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.otherFormsTitle(others)),
              subtitle: Text(
                l10n.otherFormsHint,
                style: theme.textTheme.bodySmall,
              ),
              children: [
                for (final variant in _variants)
                  ListTile(
                    leading: Icon(drugFormIcon(variant.facts?.form)),
                    title: Text(catalogVariantSummary(variant, l10n)),
                    subtitle: MixedText(variant.nameEn),
                    selected: variant == entry,
                    trailing: variant == entry
                        ? Tooltip(
                            message: l10n.catalogVariantSelected,
                            child: const Icon(Icons.check_circle),
                          )
                        : null,
                    onTap:
                        variant == entry ? null : () => _applyCatalog(variant),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
