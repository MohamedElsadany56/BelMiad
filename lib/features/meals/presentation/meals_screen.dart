import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/local_date.dart';
import '../../audit/data/audit_log.dart';
import '../../medications/presentation/medication_detail_screen.dart';
import '../../schedules/presentation/schedule_describer.dart';
import '../domain/meal_timing.dart';

/// Meals drive meal-relative dosing (spec §11). A meal can have the same
/// time every day or a different time on each weekday.
class MealsScreen extends ConsumerWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    final today = ref.watch(patientTimeProvider).today(DateTime.now().toUtc());
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(l10n.meals)),
      floatingActionButton: patientId == null
          ? null
          : FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => _edit(context, ref, patientId, null),
              icon: const Icon(Icons.add),
              label: Text(l10n.addMeal),
            ),
      body: ReadableWidth(
          child: RequirePatient(
        builder: (id) => AsyncBody(
          value: ref.watch(patientMealsProvider(id)),
          builder: (meals) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Text(l10n.mealsNote,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              for (final meal in meals)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: Text(mealName(meal, l10n)),
                    subtitle: Text(
                      meal.timeMode == MealTimeModes.weekly
                          ? '${mealTypeLabel(meal.mealType, l10n)} · ${l10n.variesByDay}\n${_weeklySummary(context, meal)}'
                          : mealTypeLabel(meal.mealType, l10n),
                    ),
                    isThreeLine: meal.timeMode == MealTimeModes.weekly,
                    trailing: Text(
                      formatHHmm(
                        context,
                        mealTimeOnWeekday(
                          mealType: meal.mealType,
                          defaultTime: meal.defaultTime,
                          timeMode: meal.timeMode,
                          weekdayTimes: meal.weekdayTimes,
                          weekday: today.weekday,
                        ).toHHmm(),
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => _edit(context, ref, id, meal),
                  ),
                ),
            ],
          ),
        ),
      )),
    );
  }

  String _weeklySummary(BuildContext context, Meal meal) {
    final times = decodeWeekdayTimes(meal.weekdayTimes);
    return [
      for (final day in _weekOrder)
        '${weekdayShortName(day, context.localeName)} ${formatHHmm(context, (times[day] ?? effectiveMealTime(meal.mealType, meal.defaultTime)).toHHmm())}',
    ].join(' · ');
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    String patientId,
    Meal? meal,
  ) async {
    final l10n = context.l10n;
    final nameEn = TextEditingController(text: meal?.nameEn);
    final nameAr = TextEditingController(text: meal?.nameAr);
    var type = meal?.mealType ?? MealType.custom.name;
    var time =
        meal?.defaultTime ?? defaultMealTime(mealTypeFromCode(type)).toHHmm();
    var mode = meal?.timeMode ?? MealTimeModes.daily;
    final weekly = <int, LocalTime>{
      ...decodeWeekdayTimes(meal?.weekdayTimes),
    };
    final action = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(meal == null ? l10n.addMeal : l10n.editMeal),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameEn,
                    decoration: InputDecoration(labelText: l10n.nameEn),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameAr,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(labelText: l10n.nameAr),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: type,
                    decoration: InputDecoration(labelText: l10n.mealType),
                    items: [
                      for (final t in MealType.values)
                        DropdownMenuItem(
                          value: t.name,
                          child: Text(mealTypeLabel(t.name, l10n)),
                        ),
                    ],
                    onChanged: (v) => setState(() => type = v ?? type),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.mealTimeMode,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: MealTimeModes.daily,
                        label: Text(l10n.sameEveryDay),
                      ),
                      ButtonSegment(
                        value: MealTimeModes.weekly,
                        label: Text(l10n.differentByDay),
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (v) => setState(() => mode = v.first),
                  ),
                  const SizedBox(height: 12),
                  TimeField(
                    label: mode == MealTimeModes.weekly
                        ? l10n.mealDefaultTime(formatHHmm(context, time))
                        : l10n.mealTime,
                    value: time,
                    onChanged: (v) => setState(() => time = v),
                  ),
                  if (mode == MealTimeModes.weekly) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.mealWeeklyNote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    for (final day in _weekOrder)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 56,
                              child: Text(
                                weekdayShortName(day, context.localeName),
                              ),
                            ),
                            Expanded(
                              child: TimeField(
                                label: weekly.containsKey(day)
                                    ? l10n.mealTime
                                    : l10n.mealDefaultTime(
                                        formatHHmm(context, time),
                                      ),
                                value: (weekly[day] ??
                                        LocalTime.tryParse(time) ??
                                        const LocalTime(8, 0))
                                    .toHHmm(),
                                onChanged: (v) => setState(
                                  () => weekly[day] = LocalTime.tryParse(v)!,
                                ),
                              ),
                            ),
                            if (weekly.containsKey(day))
                              IconButton(
                                tooltip: l10n.delete,
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => weekly.remove(day)),
                              ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            if (meal != null)
              TextButton(
                onPressed: () => Navigator.pop(context, 'delete'),
                child: Text(l10n.delete),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, 'save'),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    final repo = ref.read(mealRepositoryProvider);
    final english = nameEn.text.trim().isEmpty ? nameAr.text : nameEn.text;
    final arabic = nameAr.text.trim().isEmpty ? nameEn.text : nameAr.text;
    final weekdayTimes =
        mode == MealTimeModes.weekly ? encodeWeekdayTimes(weekly) : null;
    if (action == 'delete') {
      await runGuarded(context, () async {
        if (await repo.isInUse(meal!.mealId)) {
          throw const ValidationException('mealInUse');
        }
        await ref.read(trashRepositoryProvider).moveToTrash(
              entityType: EntityTypes.meal,
              entityId: meal.mealId,
              patientId: patientId,
              label: meal.nameEn,
            );
      }, success: l10n.deletedMessage);
      return;
    }
    await runGuarded(context, () async {
      if (meal == null) {
        await repo.create(
          patientId: patientId,
          nameEn: english,
          nameAr: arabic,
          mealType: type,
          time: time,
          timeMode: mode,
          weekdayTimes: weekdayTimes,
        );
      } else {
        final changed = await repo.update(
          mealId: meal.mealId,
          nameEn: english,
          nameAr: arabic,
          mealType: type,
          time: time,
          timeMode: mode,
          weekdayTimes: weekdayTimes,
        );
        // Doses relative to this meal move with it (spec §11).
        if (changed) {
          ref
              .read(syncCoordinatorProvider)
              .request(regeneratePatientId: patientId);
        }
      }
    }, success: l10n.savedMessage);
  }
}

/// Saturday-first week order, as commonly used in Egypt.
const _weekOrder = [6, 7, 1, 2, 3, 4, 5];
