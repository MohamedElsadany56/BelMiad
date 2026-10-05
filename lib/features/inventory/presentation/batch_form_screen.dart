import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../catalog/data/drug_catalog_repository.dart';
import '../../medications/data/medication_repository.dart';
import '../../catalog/presentation/catalog_search.dart';
import '../../medications/presentation/medications_screen.dart';
import '../data/inventory_repository.dart';
import '../domain/partial_pack.dart';
import 'blister_grid.dart';
import '../domain/strip_model.dart' show maxStripCapacity;

/// Outer packages that commonly contain inner packs (box → strips).
const _outerWithInner = {'box', 'container'};
const _innerTypes = ['strip', 'sachet', 'ampoule', 'vial', 'bottle'];

/// Older stock may still say "blister"; it is the same as a strip.
String _normalizePackaging(String? type) =>
    type == 'blister' ? 'strip' : type ?? 'other';
const _newStorageMedicine = '__new_storage__';

/// Add stock (from inventory, medication details, after creating a
/// medication, or for a storage-only medicine) or edit a batch (spec §13,
/// §20). Supports nested packaging such as boxes of strips of tablets.
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
  final _innerPerPackage = TextEditingController(text: '2');
  final _unitsPerPack = TextEditingController();
  final _loose = TextEditingController();
  final List<_OpenedPack> _opened = [];
  final _price = TextEditingController();
  final _notes = TextEditingController();
  String? _medicationId;
  bool _byPackages = true;

  /// Only an opened pack, no full packs ("I just have this strip").
  bool _onlyOpened = false;
  String _packaging = 'box';
  bool _hasInner = true;
  String _innerType = 'strip';
  String? _purchaseDate = LocalDate.fromDateTime(DateTime.now()).toIso();
  String? _expirationDate;
  bool _hasHistory = false;
  bool _loading = true;
  bool _busy = false;

  bool get _editing => widget.batchId != null;
  bool get _innerApplies =>
      !_onlyOpened && _hasInner && _outerWithInner.contains(_packaging);

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
        _unitsPerPack.text = '${batch.unitsPerPackage ?? ''}';
        _hasInner = batch.subPackagesPerPackage != null;
        _innerPerPackage.text = '${batch.subPackagesPerPackage ?? 2}';
        _innerType = _normalizePackaging(batch.subPackagingType ?? 'strip');
        _loose.text = batch.looseQuantityScaled == null
            ? ''
            : formatScaled(batch.looseQuantityScaled);
        _opened.addAll([
          for (final pack in decodePartialPacks(batch.partialPacksJson))
            _OpenedPack(
              type: _normalizePackaging(pack.type),
              remaining: formatScaled(pack.remainingScaled),
              capacity: pack.capacity,
            ),
        ]);
        _onlyOpened = batch.packagesCount == 0 && _opened.isNotEmpty;
        _quantity.text = formatScaled(batch.initialQuantityScaled);
        _packaging = _normalizePackaging(batch.packagingType ?? 'box');
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
    for (final c in [
      _quantity,
      _packages,
      _innerPerPackage,
      _unitsPerPack,
      _loose,
      _price,
      _notes,
    ]) {
      c.dispose();
    }
    for (final pack in _opened) {
      pack.dispose();
    }
    super.dispose();
  }

  String get _packType => _innerApplies ? _innerType : _packaging;
  int? get _packCapacity => int.tryParse(_unitsPerPack.text);

  List<PartialPack> get _openedPacks => [
        for (final pack in _opened)
          if (ScaledQuantity.tryParse(pack.remaining.text) != null)
            PartialPack(
              type: pack.type ?? _packType,
              remainingScaled:
                  ScaledQuantity.tryParse(pack.remaining.text)!.scaled,
              capacity: pack.capacity ?? _packCapacity,
            ),
      ];

  void _setOnlyOpened(bool value) => setState(() {
        _onlyOpened = value;
        if (value) {
          _packages.text = '0';
          if (_opened.isEmpty) _opened.add(_OpenedPack());
        } else if (_packages.text.trim() == '0') {
          _packages.text = '1';
        }
      });

  void _addOpenedPack() => setState(() => _opened.add(_OpenedPack()));

  int get _looseScaled => ScaledQuantity.tryParse(_loose.text)?.scaled ?? 0;

  int? get _packageTotal {
    final packages = int.tryParse(_packages.text);
    final units =
        int.tryParse(_unitsPerPack.text) ?? (packages == 0 ? 0 : null);
    final inner = _innerApplies ? int.tryParse(_innerPerPackage.text) : null;
    if (packages == null || units == null) return null;
    if (_innerApplies && inner == null) return null;
    return ScaledQuantity.fromPackages(
      packages: packages,
      unitsPerPackage: units,
      subPackagesPerPackage: inner,
      loose: ScaledQuantity(_looseScaled + partialPacksTotal(_openedPacks)),
    ).scaled;
  }

  String _breakdown(String unitCode) {
    final l10n = context.l10n;
    final parts = [
      '${_packages.text} ${packagingLabel(_packaging, l10n)}',
      if (_innerApplies)
        '${_innerPerPackage.text} ${packagingLabel(_innerType, l10n)}',
      '${_unitsPerPack.text} ${unitLabelFor(unitCode, null, l10n)}',
    ];
    final full = int.tryParse(_packages.text) == 0 ? '' : parts.join(' × ');
    final extras = [
      for (final pack in _openedPacks)
        l10n.partialPackOf(
          packagingLabel(pack.type, l10n),
          formatScaled(pack.remainingScaled),
          pack.capacity ?? '?',
        ),
      if (_looseScaled > 0) formatScaled(_looseScaled),
    ];
    return [if (full.isNotEmpty) full, ...extras].join(' + ');
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _medicationId == null) return;
    final price = double.tryParse(_price.text.replaceAll(',', '.'));
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
    final input = _byPackages
        ? BatchInput.fromPackages(
            medicationId: _medicationId!,
            packagesCount: int.parse(_packages.text),
            unitsPerPackage: int.tryParse(_unitsPerPack.text) ?? 0,
            subPackagesPerPackage:
                _innerApplies ? int.parse(_innerPerPackage.text) : null,
            subPackagingType: _innerApplies ? _innerType : null,
            looseQuantityScaled: _looseScaled,
            partialPacks: _openedPacks,
            packagingType: _packaging,
            purchaseDate: _purchaseDate,
            purchasePrice: price,
            expirationDate: _expirationDate,
            notes: notes,
          )
        : BatchInput(
            medicationId: _medicationId!,
            quantityScaled: ScaledQuantity.tryParse(_quantity.text)!.scaled,
            packagingType: _packaging,
            purchaseDate: _purchaseDate,
            purchasePrice: price,
            expirationDate: _expirationDate,
            notes: notes,
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

  Future<void> _createStorageMedicine() async {
    final id = await Navigator.of(context, rootNavigator: true).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const StorageMedicineScreen(),
      ),
    );
    if (id != null && mounted) setState(() => _medicationId = id);
  }

  /// Opened packs that can be drawn tablet by tablet.
  static const _drawable = {'strip'};

  /// Rebuilds the picked pockets from the typed quantity when they disagree.
  void _syncCells(_OpenedPack pack, int capacity) {
    final scaled = ScaledQuantity.tryParse(pack.remaining.text)?.scaled;
    final expected =
        (capacity - pack.used.length) * quantityScale - pack.half.length * 500;
    final inRange = pack.used.every((i) => i < capacity) &&
        pack.half.every((i) => i < capacity);
    if (scaled == null) {
      if (pack.used.isNotEmpty || pack.half.isNotEmpty) {
        pack.used = {};
        pack.half = {};
      }
      return;
    }
    if (inRange && scaled == expected) return;
    final hasHalf = scaled % quantityScale >= 500;
    final filled = math.min(
      capacity,
      scaled ~/ quantityScale + (hasHalf ? 1 : 0),
    );
    final usedCount = capacity - filled;
    pack.used = {for (var i = 0; i < usedCount; i++) i};
    pack.half = hasHalf && filled > 0 ? {usedCount} : {};
  }

  /// Tap on a pocket: full -> half -> empty -> full for tablets (they can be
  /// split), full <-> empty for everything else.
  void _cycleCell(_OpenedPack pack, int capacity, int i, bool halves) {
    setState(() {
      if (pack.used.contains(i)) {
        pack.used = {...pack.used}..remove(i);
      } else if (pack.half.contains(i)) {
        pack.half = {};
        pack.used = {...pack.used, i};
      } else if (halves) {
        pack.half = {i};
      } else {
        pack.used = {...pack.used, i};
      }
      final left = capacity - pack.used.length;
      pack.remaining.text = pack.half.isEmpty ? '$left' : '${left - 1}.5';
    });
  }

  Widget _openedPackCard(
    _OpenedPack pack,
    AppLocalizations l10n,
    String unitCode,
    String unit,
    bool locked,
  ) {
    final halves = allowsHalfUnit(unitCode);
    final capacity = pack.capacity ?? _packCapacity;
    final type = pack.type ?? _packType;
    final pickable = !locked &&
        _drawable.contains(type) &&
        capacity != null &&
        capacity >= 1 &&
        capacity <= maxStripCapacity;
    Widget? picker;
    if (pickable) {
      _syncCells(pack, capacity);
      picker = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            halves ? l10n.blisterPickHintHalf : l10n.blisterPickHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          BlisterGrid(
            capacity: capacity,
            used: pack.used,
            half: pack.half,
            shape: unitCode == 'capsule' ? PillShape.capsule : PillShape.tablet,
            tapUsed: true,
            look: PillLook.forSeed(_medicationId ?? 'pack'),
            labelFor: (i, state) => switch (state) {
              PocketState.empty => l10n.stripCellUsed(i + 1, capacity),
              PocketState.half => l10n.stripCellHalf(i + 1, capacity),
              PocketState.full => l10n.stripCellRemaining(i + 1, capacity),
            },
            onTapCell: (i) => _cycleCell(pack, capacity, i, halves),
          ),
        ],
      );
    }
    return Card(
      key: ObjectKey(pack),
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pack.remaining,
                    enabled: !locked,
                    keyboardType: quantityKeyboard(unitCode),
                    decoration: InputDecoration(
                      labelText: l10n.unitsLeft,
                      suffixText: unit,
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      final error = validateUnitQuantity(v, l10n, unitCode);
                      if (error != null) return error;
                      final cap = capacity;
                      final left = ScaledQuantity.tryParse(v)!;
                      if (cap != null && left > ScaledQuantity.units(cap)) {
                        return l10n.error_invalidPartialPack;
                      }
                      return null;
                    },
                  ),
                ),
                if (!locked && !(_onlyOpened && _opened.length == 1))
                  IconButton(
                    tooltip: l10n.delete,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _opened.remove(pack);
                      pack.dispose();
                    }),
                  ),
              ],
            ),
            if (picker != null) picker,
          ],
        ),
      ),
    );
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
            .where(
              (m) =>
                  m.status == MedicationStatus.active ||
                  m.medicationId == _medicationId,
            )
            .toList();
    final selected =
        medications.where((m) => m.medicationId == _medicationId).firstOrNull;
    final unitCode = selected?.doseUnit ?? 'unit';
    final unit = unitLabelFor(unitCode, null, l10n);
    final quantityLocked = _editing && _hasHistory;
    final innerPackLabel =
        packagingLabel(_innerApplies ? _innerType : _packaging, l10n);

    return Scaffold(
      appBar:
          AppBar(title: AppBarTitle(_editing ? l10n.editBatch : l10n.addStock)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: _busy ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(l10n.save),
      ),
      body: ReadableWidth(
          child: Form(
        key: _form,
        child: FormBody(
          children: [
            DropdownButtonFormField<String>(
              key: ValueKey(_medicationId),
              initialValue: _medicationId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.selectMedication),
              validator: (v) => v == null ? l10n.requiredField : null,
              items: [
                for (final m in medications)
                  DropdownMenuItem(
                    value: m.medicationId,
                    child: Text(
                      m.storageOnly
                          ? '${medicationDisplayName(m, arabic: context.isArabic)} · ${l10n.storageBadge}'
                          : medicationDisplayName(m, arabic: context.isArabic),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (!_editing)
                  DropdownMenuItem(
                    value: _newStorageMedicine,
                    child: Row(
                      children: [
                        const Icon(Icons.add_box_outlined, size: 20),
                        const SizedBox(width: 8),
                        Flexible(child: Text(l10n.newStorageMedicine)),
                      ],
                    ),
                  ),
              ],
              onChanged: _editing
                  ? null
                  : (v) {
                      if (v == _newStorageMedicine) {
                        _createStorageMedicine();
                      } else {
                        setState(() => _medicationId = v);
                      }
                    },
            ),
            if (selected?.storageOnly ?? false)
              Text(
                l10n.storageOnlyHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (quantityLocked)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.useAdjustmentNote),
                ),
              ),
            if (_byPackages)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.fullPacksMode),
                    selected: !_onlyOpened,
                    onSelected:
                        quantityLocked ? null : (_) => _setOnlyOpened(false),
                  ),
                  ChoiceChip(
                    label: Text(l10n.openedOnlyMode),
                    selected: _onlyOpened,
                    onSelected:
                        quantityLocked ? null : (_) => _setOnlyOpened(true),
                  ),
                ],
              ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _packaging,
              decoration: InputDecoration(labelText: l10n.packagingType),
              items: [
                for (final p in PackagingTypes.all)
                  DropdownMenuItem(
                    value: p,
                    child: Text(packagingLabel(p, l10n)),
                  ),
              ],
              onChanged: quantityLocked
                  ? null
                  : (v) => setState(() => _packaging = v ?? 'box'),
            ),
            if (_byPackages) ...[
              if (!_onlyOpened)
                TextFormField(
                  controller: _packages,
                  enabled: !quantityLocked,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.packagesCount} (${packagingLabel(_packaging, l10n)})',
                    helperText: l10n.fullPacksHint,
                    helperMaxLines: 2,
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    final count = int.tryParse(v ?? '');
                    if (count == null || count < 0) {
                      return l10n.error_invalidPackages;
                    }
                    if (count == 0 && _opened.isEmpty) {
                      return l10n.error_invalidPackages;
                    }
                    return null;
                  },
                ),
              if (!_onlyOpened && _outerWithInner.contains(_packaging)) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _hasInner,
                  title: Text(l10n.containsInnerPacks),
                  onChanged: quantityLocked
                      ? null
                      : (v) => setState(() => _hasInner = v),
                ),
                if (_hasInner)
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _innerType,
                          decoration:
                              InputDecoration(labelText: l10n.innerPackType),
                          items: [
                            for (final t in _innerTypes)
                              DropdownMenuItem(
                                value: t,
                                child: Text(packagingLabel(t, l10n)),
                              ),
                          ],
                          onChanged: quantityLocked
                              ? null
                              : (v) =>
                                  setState(() => _innerType = v ?? 'strip'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _innerPerPackage,
                          enabled: !quantityLocked,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.innerPacksPer(
                              packagingLabel(_innerType, l10n),
                              packagingLabel(_packaging, l10n),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) => (int.tryParse(v ?? '') ?? 0) < 1
                              ? l10n.error_invalidPackages
                              : null,
                        ),
                      ),
                    ],
                  ),
              ],
              TextFormField(
                controller: _unitsPerPack,
                enabled: !quantityLocked,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.unitsPer(unit, innerPackLabel),
                  suffixText: unit,
                ),
                onChanged: (_) => setState(() {}),
                // The pack size is always needed: opened packs use it too.
                validator: (v) {
                  final units = int.tryParse(v ?? '') ?? 0;
                  if (units < 1) return l10n.error_quantityRequired;
                  final inner = _innerApplies ? _innerType : _packaging;
                  if (inner == 'strip' && units > maxStripCapacity) {
                    return l10n.stripMaxUnits(maxStripCapacity);
                  }
                  return null;
                },
              ),
              if (_editing && _looseScaled > 0)
                TextFormField(
                  controller: _loose,
                  enabled: !quantityLocked,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '${l10n.looseUnits} (${l10n.optional})',
                    suffixText: unit,
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) => validateQuantity(
                    v,
                    l10n,
                    required: false,
                    allowZero: true,
                  ),
                ),
              SectionHeader(l10n.openedPacks),
              if (!_onlyOpened)
                Text(
                  l10n.openedPacksHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              for (final pack in _opened)
                _openedPackCard(pack, l10n, unitCode, unit, quantityLocked),
              if (!quantityLocked)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    onPressed: _addOpenedPack,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addOpenedPack),
                  ),
                ),
              if (_packageTotal != null)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.packagingBreakdown(
                        _breakdown(unitCode),
                        quantityWithUnit(_packageTotal, unitCode, l10n),
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
            ] else
              TextFormField(
                controller: _quantity,
                enabled: !quantityLocked,
                keyboardType: quantityKeyboard(unitCode),
                decoration: InputDecoration(
                  labelText: l10n.availableQuantity,
                  suffixText: unit,
                ),
                validator: (v) =>
                    validateUnitQuantity(v, l10n, unitCode, allowZero: true),
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
      )),
    );
  }
}

/// Creates a medicine that is only kept in storage (no schedules), from the
/// catalog or as a custom entry. Pops with the new medication ID.
class StorageMedicineScreen extends ConsumerStatefulWidget {
  const StorageMedicineScreen({super.key});

  @override
  ConsumerState<StorageMedicineScreen> createState() =>
      _StorageMedicineScreenState();
}

class _StorageMedicineScreenState extends ConsumerState<StorageMedicineScreen> {
  final _form = GlobalKey<FormState>();
  final _nameEn = TextEditingController();
  final _nameAr = TextEditingController();
  final _strength = TextEditingController();
  String _unit = 'tablet';
  String? _catalogId;
  double? _catalogPrice;
  bool _showForm = false;
  bool _busy = false;

  @override
  void dispose() {
    _nameEn.dispose();
    _nameAr.dispose();
    _strength.dispose();
    super.dispose();
  }

  void _selected(DrugSearchResult result) => setState(() {
        _catalogId = result.catalogId;
        _catalogPrice = result.priceEgp;
        _nameEn.text = result.nameEn;
        _nameAr.text = result.nameAr;
        _showForm = true;
      });

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final patientId = ref.read(currentPatientIdProvider);
    if (patientId == null) return;
    setState(() => _busy = true);
    String? id;
    await runGuarded(context, () async {
      id = await ref.read(medicationRepositoryProvider).create(
            patientId,
            MedicationInput(
              nameEn: _nameEn.text.trim().isEmpty ? _nameAr.text : _nameEn.text,
              nameAr: _nameAr.text,
              strength: _strength.text,
              doseUnit: _unit,
              catalogId: _catalogId,
              catalogPriceEgp: _catalogPrice,
              storageOnly: true,
            ),
          );
    });
    if (!mounted) return;
    setState(() => _busy = false);
    if (id != null) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(l10n.newStorageMedicine)),
      floatingActionButton: _showForm
          ? FloatingActionButton.extended(
              heroTag: null,
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.check),
              label: Text(l10n.save),
            )
          : null,
      body: ReadableWidth(
          child: !_showForm
              ? CatalogSearch(
                  onSelected: _selected,
                  onCustom: () => setState(() => _showForm = true),
                )
              : Form(
                  key: _form,
                  child: FormBody(
                    children: [
                      Text(l10n.storageOnlyHint),
                      TextFormField(
                        controller: _nameEn,
                        decoration: InputDecoration(labelText: l10n.nameEn),
                        validator: (v) => (v?.trim().isEmpty ?? true) &&
                                _nameAr.text.trim().isEmpty
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
                        initialValue: _unit,
                        decoration: InputDecoration(labelText: l10n.doseUnit),
                        items: [
                          for (final unit in doseUnits)
                            DropdownMenuItem(
                              value: unit,
                              child: Text(unitLabel(unit, l10n)),
                            ),
                        ],
                        onChanged: (v) => setState(() => _unit = v ?? 'tablet'),
                      ),
                    ],
                  ),
                )),
    );
  }
}

/// One opened or incomplete pack. Its type and size come from the pack
/// definition above (only older records keep their own).
class _OpenedPack {
  _OpenedPack({this.type, this.capacity, String remaining = ''})
      : remaining = TextEditingController(text: remaining);

  /// Packaging code and size kept from an older record; null = use the
  /// current pack definition.
  final String? type;
  final int? capacity;
  final TextEditingController remaining;

  /// Pockets already used / holding half a tablet (visual picker).
  Set<int> used = {};
  Set<int> half = {};

  void dispose() => remaining.dispose();
}
