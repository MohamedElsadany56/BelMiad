import '../../meals/domain/meal_timing.dart';

/// Everything the grouping rule needs to know about one dose.
class DoseGroupInput {
  const DoseGroupInput({
    required this.patientId,
    required this.localDate,
    required this.scheduledAt,
    this.isPrn = false,
    this.mealId,
    this.timingRelation,
  });

  final String patientId;

  /// Patient-local calendar date (`yyyy-MM-dd`).
  final String localDate;

  /// UTC instant.
  final DateTime scheduledAt;
  final bool isPrn;

  /// Set only for meal-relative schedules.
  final String? mealId;

  /// `before`, `with` or `after` (meal-relative schedules only).
  final String? timingRelation;

  bool get isMealRelative => mealId != null;
}

/// The single rule that decides which doses belong together. Dose
/// completion, notification scheduling and notification display all use it,
/// so they can never disagree.
///
/// * Meal-relative doses group by **meal event**: the same meal, on the same
///   day, with the same relation. "Before breakfast" and "after breakfast"
///   are different events; so are "after lunch" and "before dinner" even if
///   their clock times are close.
/// * Fixed-time doses group by the **exact same minute**. They are never
///   merged with meal-relative doses, even when the times coincide.
/// * As-needed (PRN) doses are never grouped (returns null).
String? doseGroupKey(DoseGroupInput dose) {
  if (dose.isPrn) return null;
  if (dose.isMealRelative) {
    final relation = timingRelationCode(
      timingRelationFromCode(dose.timingRelation),
    );
    return 'meal:${dose.patientId}:${dose.localDate}:'
        '${dose.mealId}:$relation';
  }
  final minute = dose.scheduledAt.toUtc().millisecondsSinceEpoch ~/ 60000;
  return 'time:${dose.patientId}:$minute';
}

/// Splits [items] into groups, keeping the incoming order. Items without a
/// key (PRN) each form a group of their own.
List<List<T>> groupDoses<T>(
  Iterable<T> items,
  DoseGroupInput Function(T item) inputOf,
) {
  final groups = <List<T>>[];
  final byKey = <String, List<T>>{};
  for (final item in items) {
    final key = doseGroupKey(inputOf(item));
    if (key == null) {
      groups.add([item]);
      continue;
    }
    var group = byKey[key];
    if (group == null) {
      group = [];
      byKey[key] = group;
      groups.add(group);
    }
    group.add(item);
  }
  return groups;
}
