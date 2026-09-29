import 'dart:convert';

import '../../../core/time/local_date.dart';

enum MealType { breakfast, lunch, dinner, snack, custom }

MealType mealTypeFromCode(String code) => MealType.values.firstWhere(
      (t) => t.name == code,
      orElse: () => MealType.custom,
    );

/// Default wall-clock times used when a meal has no configured time.
LocalTime defaultMealTime(MealType type) => switch (type) {
      MealType.breakfast => const LocalTime(8, 0),
      MealType.lunch => const LocalTime(14, 0),
      MealType.dinner => const LocalTime(20, 0),
      MealType.snack => const LocalTime(17, 0),
      MealType.custom => const LocalTime(12, 0),
    };

LocalTime effectiveMealTime(String mealType, String? configuredTime) =>
    LocalTime.tryParse(configuredTime) ??
    defaultMealTime(mealTypeFromCode(mealType));

/// A meal either has the same time every day, or its own time per weekday
/// (e.g. breakfast 08:00 on Saturday but 09:00 on Friday).
abstract final class MealTimeModes {
  static const daily = 'daily';
  static const weekly = 'weekly';
}

/// Decodes `{"1": "08:00", ...}` (ISO weekday → HH:mm).
Map<int, LocalTime> decodeWeekdayTimes(String? json) {
  if (json == null || json.isEmpty) return const {};
  try {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return {
      for (final entry in map.entries)
        if (int.tryParse(entry.key) != null &&
            LocalTime.tryParse(entry.value as String?) != null)
          int.parse(entry.key): LocalTime.tryParse(entry.value as String)!,
    };
  } catch (_) {
    return const {};
  }
}

String? encodeWeekdayTimes(Map<int, LocalTime> times) => times.isEmpty
    ? null
    : jsonEncode({
        for (final entry in times.entries) '${entry.key}': entry.value.toHHmm(),
      });

/// Meal time on a given ISO weekday, honouring the weekly mode.
LocalTime mealTimeOnWeekday({
  required String mealType,
  required String? defaultTime,
  required String timeMode,
  required String? weekdayTimes,
  required int weekday,
}) {
  final base = effectiveMealTime(mealType, defaultTime);
  if (timeMode != MealTimeModes.weekly) return base;
  return decodeWeekdayTimes(weekdayTimes)[weekday] ?? base;
}

enum TimingRelation { before, withMeal, after }

TimingRelation timingRelationFromCode(String? code) => switch (code) {
      'before' => TimingRelation.before,
      'after' => TimingRelation.after,
      _ => TimingRelation.withMeal,
    };

String timingRelationCode(TimingRelation relation) => switch (relation) {
      TimingRelation.before => 'before',
      TimingRelation.after => 'after',
      TimingRelation.withMeal => 'with',
    };

/// Minutes of the day for a meal-relative dose. The result may fall outside
/// `0..1439` when the offset crosses midnight.
int mealRelativeMinutes({
  required LocalTime mealTime,
  required TimingRelation relation,
  required int offsetMinutes,
}) =>
    switch (relation) {
      TimingRelation.before => mealTime.minutesOfDay - offsetMinutes.abs(),
      TimingRelation.after => mealTime.minutesOfDay + offsetMinutes.abs(),
      TimingRelation.withMeal => mealTime.minutesOfDay,
    };
