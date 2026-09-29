import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../meals/domain/meal_timing.dart';
import '../../medications/presentation/medication_detail_screen.dart';
import '../data/schedule_repository.dart';
import '../domain/recurrence_rule.dart';
import 'schedule_describer.dart';

/// One editable time within the dose plan.
class _Slot {
  _Slot({
    this.scheduleId,
    this.type = ScheduleTypes.fixedTime,
    this.time = '08:00',
    this.mealId,
    this.relation = TimingRelation.after,
    int offset = 30,
    String quantity = '1',
  })  : offset = TextEditingController(text: '$offset'),
        quantity = TextEditingController(text: quantity);

  final String? scheduleId;
  String type;
  String time;
  String? mealId;
  TimingRelation relation;
  final TextEditingController offset;
  final TextEditingController quantity;

  void dispose() {
    offset.dispose();
    quantity.dispose();
  }
}

enum _Preset {
  once,
  twice,
  three,
  four,
  every8h,
  every12h,
  afterMeals,
  beforeMeals
}

/// Dose plan editor: several times of day for one medicine (e.g. 3 times a
/// day after meals) are configured once and saved together.
class ScheduleFormScreen extends ConsumerStatefulWidget {
  const ScheduleFormScreen({
    required this.medicationId,
    this.scheduleId,
    super.key,
  });

  final String medicationId;

  /// A schedule or dose-plan group ID when editing.
  final String? scheduleId;

  @override
  ConsumerState<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends ConsumerState<ScheduleFormScreen> {
  final _form = GlobalKey<FormState>();
  final _interval = TextEditingController(text: '2');
  final _onDays = TextEditingController(text: '21');
  final _offDays = TextEditingController(text: '7');
  final _weekdayQuantities = {
    for (var d = 1; d <= 7; d++) d: TextEditingController(),
  };
  final List<_Slot> _slots = [_Slot()];
  String? _groupId;
  RecurrenceType _recurrence = RecurrenceType.daily;
  final Set<int> _weekdays = {};
  String? _anchor;
  String? _validFrom;
  String? _validUntil;
  bool _perDay = false;
  bool _loading = true;
  bool _busy = false;

  bool get _editing => widget.scheduleId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.scheduleId;
    if (id != null) {
      final rows = await ref.read(scheduleRepositoryProvider).getGroup(id);
      rows.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      if (rows.isNotEmpty) {
        final first = rows.first;
        _groupId = first.groupId ?? first.scheduleId;
        for (final slot in _slots) {
          slot.dispose();
        }
        _slots
          ..clear()
          ..addAll([
            for (final s in rows)
              _Slot(
                scheduleId: s.scheduleId,
                type: s.scheduleType,
                time: s.fixedTime ?? '08:00',
                mealId: s.mealId,
                relation: timingRelationFromCode(s.timingRelation),
                offset: s.offsetMinutes ?? 30,
                quantity: formatScaled(s.doseQuantityScaled),
              ),
          ]);
        final rule = RecurrenceRule.decode(first.recurrenceRule);
        _recurrence = rule.type;
        _weekdays.addAll(rule.weekdays);
        _interval.text = '${rule.interval < 2 ? 2 : rule.interval}';
        _onDays.text = '${rule.onDays}';
        _offDays.text = '${rule.offDays}';
        _anchor = rule.anchorDate;
        _perDay = rule.weekdayQuantities.isNotEmpty;
        for (final entry in rule.weekdayQuantities.entries) {
          _weekdayQuantities[int.parse(entry.key)]!.text =
              formatScaled(entry.value);
        }
        _validFrom = first.validFrom;
        _validUntil = first.validUntil;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _interval,
      _onDays,
      _offDays,
      ..._weekdayQuantities.values,
    ]) {
      c.dispose();
    }
    for (final slot in _slots) {
      slot.dispose();
    }
    super.dispose();
  }

  void _applyPreset(_Preset preset, List<Meal> meals) {
    final quantity = _slots.isEmpty ? '1' : _slots.first.quantity.text;
    List<_Slot> times(List<String> clock) => [
          for (final t in clock) _Slot(time: t, quantity: quantity),
        ];
    List<_Slot> mealSlots(TimingRelation relation) {
      const main = ['breakfast', 'lunch', 'dinner'];
      final chosen = [
        for (final type in main)
          ...meals.where((m) => m.mealType == type).take(1),
      ];
      return [
        for (final meal in chosen.isEmpty ? meals.take(3) : chosen)
          _Slot(
            type: ScheduleTypes.mealRelative,
            mealId: meal.mealId,
            relation: relation,
            offset: relation == TimingRelation.withMeal ? 0 : 30,
            quantity: quantity,
          ),
      ];
    }

    final next = switch (preset) {
      _Preset.once => times(['08:00']),
      _Preset.twice => times(['08:00', '20:00']),
      _Preset.three => times(['08:00', '14:00', '20:00']),
      _Preset.four => times(['08:00', '12:00', '16:00', '20:00']),
      _Preset.every8h => times(['06:00', '14:00', '22:00']),
      _Preset.every12h => times(['09:00', '21:00']),
      _Preset.afterMeals => mealSlots(TimingRelation.after),
      _Preset.beforeMeals => mealSlots(TimingRelation.before),
    };
    if (next.isEmpty) return;
    setState(() {
      // Keep existing schedule IDs so history stays attached when editing.
      for (var i = 0; i < next.length && i < _slots.length; i++) {
        final old = _slots[i];
        final fresh = next[i];
        next[i] = _Slot(
          scheduleId: old.scheduleId,
          type: fresh.type,
          time: fresh.time,
          mealId: fresh.mealId,
          relation: fresh.relation,
          offset: int.tryParse(fresh.offset.text) ?? 30,
          quantity: fresh.quantity.text,
        );
        fresh.dispose();
      }
      for (final slot in _slots) {
        slot.dispose();
      }
      _slots
        ..clear()
        ..addAll(next);
    });
  }

  RecurrenceRule _rule() {
    final interval = int.tryParse(_interval.text) ?? 1;
    return RecurrenceRule(
      type: _recurrence,
      interval: switch (_recurrence) {
        RecurrenceType.weekly || RecurrenceType.everyNDays => interval,
        _ => 1,
      },
      weekdays: _recurrence == RecurrenceType.weekly
          ? (_weekdays.toList()..sort())
          : const [],
      onDays: _recurrence == RecurrenceType.cycle
          ? (int.tryParse(_onDays.text) ?? 1)
          : 1,
      offDays: _recurrence == RecurrenceType.cycle
          ? (int.tryParse(_offDays.text) ?? 0)
          : 0,
      anchorDate: _anchor,
      weekdayQuantities: _perDay
          ? {
              for (final entry in _weekdayQuantities.entries)
                if (ScaledQuantity.tryParse(entry.value.text) != null)
                  '${entry.key}':
                      ScaledQuantity.tryParse(entry.value.text)!.scaled,
            }
          : const {},
    );
  }

  Future<void> _save(Medication medication) async {
    if (!_form.currentState!.validate()) return;
    final slots = [
      for (final slot in _slots)
        ScheduleSlot(
          scheduleId: slot.scheduleId,
          scheduleType: slot.type,
          fixedTime: slot.type == ScheduleTypes.fixedTime ? slot.time : null,
          mealId: slot.type == ScheduleTypes.mealRelative ? slot.mealId : null,
          timingRelation: slot.type == ScheduleTypes.mealRelative
              ? timingRelationCode(slot.relation)
              : null,
          offsetMinutes: slot.type == ScheduleTypes.mealRelative &&
                  slot.relation != TimingRelation.withMeal
              ? int.tryParse(slot.offset.text) ?? 0
              : null,
          doseQuantityScaled:
              ScaledQuantity.tryParse(slot.quantity.text)?.scaled ?? 0,
        ),
    ];
    setState(() => _busy = true);
    final ok = await runGuarded(
      context,
      () => ref.read(scheduleRepositoryProvider).saveGroup(
            medicationId: widget.medicationId,
            groupId: _groupId,
            slots: slots,
            rule: _rule(),
            validFrom: _validFrom,
            validUntil: _validUntil,
          ),
      success: context.l10n.savedMessage,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      ref
          .read(syncCoordinatorProvider)
          .request(regeneratePatientId: medication.patientId);
      context.pop();
    }
  }

  Future<void> _delete(Medication medication) async {
    final l10n = context.l10n;
    final confirmed = await confirmDialog(
      context,
      title: l10n.deleteScheduleTitle,
      body: l10n.deleteScheduleBody,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final ok = await runGuarded(
      context,
      () => ref.read(scheduleRepositoryProvider).deleteGroup(_groupId!),
    );
    if (ok && mounted) {
      ref
          .read(syncCoordinatorProvider)
          .request(regeneratePatientId: medication.patientId);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final medication =
        ref.watch(medicationProvider(widget.medicationId)).valueOrNull;
    if (_loading || medication == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final meals =
        ref.watch(patientMealsProvider(medication.patientId)).valueOrNull ??
            const <Meal>[];
    final unit = unitLabelFor(medication.doseUnit, null, l10n);
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? l10n.editSchedule : l10n.dosePlan),
        actions: [
          if (_editing && _groupId != null)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(medication),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : () => _save(medication),
        icon: const Icon(Icons.check),
        label: Text(l10n.save),
      ),
      body: Form(
        key: _form,
        child: FormBody(
          children: [
            if (medication.isPrn) Text(l10n.prnPlannedNote),
            Text(l10n.quickSetup,
                style: Theme.of(context).textTheme.titleSmall),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final (preset, label) in [
                  (_Preset.once, l10n.presetOnce),
                  (_Preset.twice, l10n.presetTwice),
                  (_Preset.three, l10n.presetThree),
                  (_Preset.four, l10n.presetFour),
                  (_Preset.afterMeals, l10n.presetAfterMeals),
                  (_Preset.beforeMeals, l10n.presetBeforeMeals),
                  (_Preset.every8h, l10n.presetEvery8h),
                  (_Preset.every12h, l10n.presetEvery12h),
                ])
                  ActionChip(
                    label: Text(label),
                    onPressed: () => _applyPreset(preset, meals),
                  ),
              ],
            ),
            SectionHeader(
              '${l10n.doseTimes} · ${l10n.timesPerDay(_slots.length)}',
            ),
            for (var i = 0; i < _slots.length; i++)
              _SlotCard(
                key: ObjectKey(_slots[i]),
                index: i,
                slot: _slots[i],
                meals: meals,
                unit: unit,
                canRemove: _slots.length > 1,
                onChanged: () => setState(() {}),
                onRemove: () => setState(() => _slots.removeAt(i).dispose()),
              ),
            OutlinedButton.icon(
              onPressed: () => setState(
                () => _slots.add(
                  _Slot(
                    quantity: _slots.isEmpty ? '1' : _slots.last.quantity.text,
                  ),
                ),
              ),
              icon: const Icon(Icons.add_alarm),
              label: Text(l10n.addTime),
            ),
            SectionHeader(l10n.sharedSettings),
            DropdownButtonFormField<RecurrenceType>(
              initialValue: _recurrence,
              decoration: InputDecoration(labelText: l10n.recurrence),
              items: [
                DropdownMenuItem(
                  value: RecurrenceType.daily,
                  child: Text(l10n.daily),
                ),
                DropdownMenuItem(
                  value: RecurrenceType.weekly,
                  child: Text(l10n.weekly),
                ),
                DropdownMenuItem(
                  value: RecurrenceType.everyNDays,
                  child: Text(l10n.everyNDays),
                ),
                DropdownMenuItem(
                  value: RecurrenceType.cycle,
                  child: Text(l10n.customCycle),
                ),
              ],
              onChanged: (v) =>
                  setState(() => _recurrence = v ?? RecurrenceType.daily),
            ),
            if (_recurrence == RecurrenceType.weekly) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var d = 1; d <= 7; d++)
                    FilterChip(
                      label: Text(weekdayShortName(d, context.localeName)),
                      selected: _weekdays.contains(d),
                      onSelected: (selected) => setState(() {
                        selected ? _weekdays.add(d) : _weekdays.remove(d);
                      }),
                    ),
                ],
              ),
              TextFormField(
                controller: _interval,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.intervalWeeks),
              ),
            ],
            if (_recurrence == RecurrenceType.everyNDays)
              TextFormField(
                controller: _interval,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.intervalDays),
                validator: (v) => (int.tryParse(v ?? '') ?? 0) < 1
                    ? l10n.error_invalidRecurrence
                    : null,
              ),
            if (_recurrence == RecurrenceType.cycle)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _onDays,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.onDays),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _offDays,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.offDays),
                    ),
                  ),
                ],
              ),
            if (_recurrence != RecurrenceType.daily)
              DateField(
                label: l10n.cycleStart,
                value: _anchor,
                onChanged: (v) => setState(() => _anchor = v),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _perDay,
              title: Text(l10n.differentQuantityByDay),
              onChanged: (v) => setState(() => _perDay = v),
            ),
            if (_perDay)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var d = 1; d <= 7; d++)
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _weekdayQuantities[d],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: weekdayShortName(d, context.localeName),
                          hintText: _slots.first.quantity.text,
                        ),
                        validator: (v) => validateQuantity(
                          v,
                          l10n,
                          required: false,
                          allowZero: true,
                        ),
                      ),
                    ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: DateField(
                    label: l10n.validFrom,
                    value: _validFrom,
                    onChanged: (v) => setState(() => _validFrom = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DateField(
                    label: l10n.validUntil,
                    value: _validUntil,
                    onChanged: (v) => setState(() => _validUntil = v),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.index,
    required this.slot,
    required this.meals,
    required this.unit,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final int index;
  final _Slot slot;
  final List<Meal> meals;
  final String unit;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mealIds = meals.map((m) => m.mealId).toSet();
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.doseTimeNumber(index + 1),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (canRemove)
                  IconButton(
                    tooltip: l10n.removeTime,
                    icon: const Icon(Icons.close),
                    onPressed: onRemove,
                  ),
              ],
            ),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: ScheduleTypes.fixedTime,
                  icon: const Icon(Icons.alarm),
                  label: Text(l10n.fixedTime),
                ),
                ButtonSegment(
                  value: ScheduleTypes.mealRelative,
                  icon: const Icon(Icons.restaurant),
                  label: Text(l10n.mealRelative),
                ),
              ],
              selected: {slot.type},
              onSelectionChanged: (v) {
                slot.type = v.first;
                if (slot.type == ScheduleTypes.mealRelative &&
                    slot.mealId == null &&
                    meals.isNotEmpty) {
                  slot.mealId = meals.first.mealId;
                }
                onChanged();
              },
            ),
            const SizedBox(height: 12),
            if (slot.type == ScheduleTypes.fixedTime)
              TimeField(
                label: l10n.time,
                value: slot.time,
                onChanged: (v) {
                  slot.time = v;
                  onChanged();
                },
              )
            else ...[
              DropdownButtonFormField<String>(
                initialValue:
                    mealIds.contains(slot.mealId) ? slot.mealId : null,
                decoration: InputDecoration(labelText: l10n.meal),
                validator: (v) => v == null ? l10n.error_mealRequired : null,
                items: [
                  for (final meal in meals)
                    DropdownMenuItem(
                      value: meal.mealId,
                      child: Text(
                        meal.timeMode == MealTimeModes.weekly
                            ? '${mealName(meal, l10n)} · ${l10n.variesByDay}'
                            : '${mealName(meal, l10n)} · ${formatHHmm(context, effectiveMealTime(meal.mealType, meal.defaultTime).toHHmm())}',
                      ),
                    ),
                ],
                onChanged: (v) {
                  slot.mealId = v;
                  onChanged();
                },
              ),
              const SizedBox(height: 12),
              SegmentedButton<TimingRelation>(
                segments: [
                  ButtonSegment(
                    value: TimingRelation.before,
                    label: Text(l10n.beforeMeal),
                  ),
                  ButtonSegment(
                    value: TimingRelation.withMeal,
                    label: Text(l10n.withMeal),
                  ),
                  ButtonSegment(
                    value: TimingRelation.after,
                    label: Text(l10n.afterMeal),
                  ),
                ],
                selected: {slot.relation},
                onSelectionChanged: (v) {
                  slot.relation = v.first;
                  onChanged();
                },
              ),
              if (slot.relation != TimingRelation.withMeal) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: slot.offset,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.offsetMinutes),
                  validator: (v) => int.tryParse(v ?? '') == null
                      ? l10n.error_invalidTime
                      : null,
                ),
              ],
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: slot.quantity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.quantity,
                suffixText: unit,
              ),
              validator: (v) => validateQuantity(v, l10n),
            ),
          ],
        ),
      ),
    );
  }
}
