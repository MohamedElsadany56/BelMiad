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
