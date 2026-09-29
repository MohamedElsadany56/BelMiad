import 'package:intl/intl.dart';

import '../../../app/localization/labels.dart';
import '../../../core/database/app_database.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../../l10n/app_localizations.dart';
import '../../meals/domain/meal_timing.dart';
import '../data/schedule_repository.dart';
import '../domain/recurrence_rule.dart';

String weekdayShortName(int isoWeekday, String locale) =>
    // 2024-01-01 is a Monday.
    DateFormat.E(locale).format(DateTime(2024, 1, isoWeekday));

String describeRecurrence(RecurrenceRule rule, AppLocalizations l10n) {
  final locale = l10n.localeName;
  String days() => ([...rule.weekdays]..sort())
      .map((d) => weekdayShortName(d, locale))
      .join(locale == 'ar' ? '، ' : ', ');
  return switch (rule.type) {
    RecurrenceType.daily => l10n.scheduleEveryDay,
    RecurrenceType.weekly => rule.interval > 1
        ? l10n.scheduleEveryNWeeks(rule.interval, days())
        : l10n.scheduleWeekdays(days()),
    RecurrenceType.everyNDays => rule.interval <= 1
        ? l10n.scheduleEveryDay
        : l10n.scheduleEveryNDays(rule.interval),
    RecurrenceType.cycle => l10n.scheduleCycle(rule.onDays, rule.offDays),
  };
}

String describeTiming(
  MedicationSchedule schedule,
  Meal? meal,
  AppLocalizations l10n,
) {
  String clock(String? hhmm) {
    final t = LocalTime.tryParse(hhmm);
    if (t == null) return '--:--';
    return DateFormat.jm(l10n.localeName)
        .format(DateTime(2000, 1, 1, t.hour, t.minute));
  }

  if (schedule.scheduleType != ScheduleTypes.mealRelative) {
    return clock(schedule.fixedTime);
  }
  final name = meal == null ? l10n.meal : mealName(meal, l10n);
  final minutes = schedule.offsetMinutes ?? 0;
  final relation = timingRelationFromCode(schedule.timingRelation);
  final text = switch (relation) {
    TimingRelation.before => l10n.scheduleBeforeMeal(minutes, name),
    TimingRelation.after => l10n.scheduleAfterMeal(minutes, name),
    TimingRelation.withMeal => l10n.scheduleWithMeal(name),
  };
  if (meal == null) return text;
  if (meal.timeMode == MealTimeModes.weekly) {
    return '$text (${l10n.variesByDay})';
  }
  final effective = LocalTime.fromMinutes(
    mealRelativeMinutes(
      mealTime: effectiveMealTime(meal.mealType, meal.defaultTime),
      relation: relation,
      offsetMinutes: minutes,
    ),
  );
  return '$text (${clock(effective.toHHmm())})';
}

/// One-line description, e.g. "8:00 AM · 1 tablet · every day".
String describeSchedule(
  MedicationSchedule schedule,
  Medication medication,
  Meal? meal,
  AppLocalizations l10n,
) {
  final rule = RecurrenceRule.decode(schedule.recurrenceRule);
  final quantity =
      '${formatScaled(schedule.doseQuantityScaled)} ${unitLabel(medication.doseUnit, l10n)}';
  return [
    describeTiming(schedule, meal, l10n),
    quantity,
    describeRecurrence(rule, l10n),
  ].join(' · ');
}
