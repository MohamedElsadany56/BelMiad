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

class ScheduleFormScreen extends ConsumerStatefulWidget {
  const ScheduleFormScreen({
    required this.medicationId,
    this.scheduleId,
    super.key,
  });

  final String medicationId;
  final String? scheduleId;

  @override
  ConsumerState<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends ConsumerState<ScheduleFormScreen> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '1');
  final _offset = TextEditingController(text: '30');
  final _interval = TextEditingController(text: '2');
  final _onDays = TextEditingController(text: '21');
  final _offDays = TextEditingController(text: '7');
  final _weekdayQuantities = {
    for (var d = 1; d <= 7; d++) d: TextEditingController(),
  };
  String _type = ScheduleTypes.fixedTime;
  String _time = '08:00';
  String? _mealId;
  TimingRelation _relation = TimingRelation.before;
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
      final s = await ref.read(scheduleRepositoryProvider).get(id);
      if (s != null) {
        final rule = RecurrenceRule.decode(s.recurrenceRule);
        _type = s.scheduleType;
        _time = s.fixedTime ?? '08:00';
        _mealId = s.mealId;
        _relation = timingRelationFromCode(s.timingRelation);
        _offset.text = '${s.offsetMinutes ?? 30}';
        _quantity.text = formatScaled(s.doseQuantityScaled);
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
        _validFrom = s.validFrom;
        _validUntil = s.validUntil;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _quantity,
      _offset,
      _interval,
      _onDays,
      _offDays,
      ..._weekdayQuantities.values,
    ]) {
      c.dispose();
    }
    super.dispose();
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
    final input = ScheduleInput(
      scheduleType: _type,
      fixedTime: _type == ScheduleTypes.fixedTime ? _time : null,
      mealId: _type == ScheduleTypes.mealRelative ? _mealId : null,
      timingRelation: _type == ScheduleTypes.mealRelative
          ? timingRelationCode(_relation)
          : null,
      offsetMinutes: _type == ScheduleTypes.mealRelative &&
              _relation != TimingRelation.withMeal
          ? int.tryParse(_offset.text) ?? 0
          : null,
      doseQuantityScaled: ScaledQuantity.tryParse(_quantity.text)?.scaled ?? 0,
      rule: _rule(),
      validFrom: _validFrom,
      validUntil: _validUntil,
    );
    setState(() => _busy = true);
    final repo = ref.read(scheduleRepositoryProvider);
    final ok = await runGuarded(context, () async {
      if (_editing) {
        await repo.update(widget.scheduleId!, input);
      } else {
        await repo.create(widget.medicationId, input);
      }
    }, success: context.l10n.savedMessage);
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
      () => ref.read(scheduleRepositoryProvider).delete(widget.scheduleId!),
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
    final unit = unitLabel(medication.doseUnit, l10n);
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? l10n.editSchedule : l10n.addSchedule),
        actions: [
          if (_editing)
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
            Text(l10n.scheduleType,
                style: Theme.of(context).textTheme.titleSmall),
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
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),
            if (_type == ScheduleTypes.fixedTime)
              TimeField(
                label: l10n.time,
                value: _time,
                onChanged: (v) => setState(() => _time = v),
              )
            else ...[
              DropdownButtonFormField<String>(
                initialValue:
                    meals.any((m) => m.mealId == _mealId) ? _mealId : null,
                decoration: InputDecoration(labelText: l10n.meal),
                validator: (v) => v == null ? l10n.error_mealRequired : null,
                items: [
                  for (final meal in meals)
                    DropdownMenuItem(
                      value: meal.mealId,
                      child: Text(
                        '${mealName(meal, l10n)} · ${formatHHmm(context, effectiveMealTime(meal.mealType, meal.defaultTime).toHHmm())}',
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _mealId = v),
              ),
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
                selected: {_relation},
                onSelectionChanged: (v) => setState(() => _relation = v.first),
              ),
              if (_relation != TimingRelation.withMeal)
                TextFormField(
                  controller: _offset,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.offsetMinutes,
                    suffixText: l10n.offsetMinutes,
                  ),
                  validator: (v) => int.tryParse(v ?? '') == null
                      ? l10n.error_invalidTime
                      : null,
                ),
            ],
            TextFormField(
              controller: _quantity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.quantity,
                suffixText: unit,
              ),
              validator: (v) => validateQuantity(v, l10n),
            ),
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
                          hintText: _quantity.text,
                        ),
                        validator: (v) => validateQuantity(v, l10n,
                            required: false, allowZero: true),
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
