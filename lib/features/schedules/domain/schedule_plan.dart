import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import 'recurrence_rule.dart';

/// A schedule resolved to a concrete wall-clock time, ready to expand into
/// dose occurrences. Built from a `medication_schedules` row, its meal and its
/// medication.
class SchedulePlan {
  const SchedulePlan({
    required this.scheduleId,
    required this.medicationId,
    required this.minutesOfDay,
    required this.doseQuantityScaled,
    required this.rule,
    required this.anchor,
    this.validFrom,
    this.validUntil,
    this.medicationStart,
    this.medicationEnd,
  });

  final String scheduleId;
  final String medicationId;

  /// Local wall-clock minutes; may be negative or ≥ 1440 for meal offsets
  /// that cross midnight.
  final int minutesOfDay;
  final int doseQuantityScaled;
  final RecurrenceRule rule;
  final LocalDate anchor;
  final LocalDate? validFrom;
  final LocalDate? validUntil;
  final LocalDate? medicationStart;
  final LocalDate? medicationEnd;

  bool isActiveOn(LocalDate date) {
    if (validFrom != null && date.isBefore(validFrom!)) return false;
    if (validUntil != null && date.isAfter(validUntil!)) return false;
    if (medicationStart != null && date.isBefore(medicationStart!)) {
      return false;
    }
    if (medicationEnd != null && date.isAfter(medicationEnd!)) return false;
    return rule.occursOn(date, fallbackAnchor: anchor);
  }
}

class PlannedDose {
  const PlannedDose({
    required this.plan,
    required this.localDate,
    required this.scheduledAt,
    required this.quantityScaled,
  });

  final SchedulePlan plan;
  final LocalDate localDate;

  /// UTC instant.
  final DateTime scheduledAt;
  final int quantityScaled;
}

/// Expands [plans] into dose occurrences for local dates `from..to`
/// (inclusive), ordered by time.
List<PlannedDose> expandPlans(
  Iterable<SchedulePlan> plans, {
  required LocalDate from,
  required LocalDate to,
  required PatientTime time,
}) {
  final result = <PlannedDose>[];
  for (final plan in plans) {
    for (var date = from; !date.isAfter(to); date = date.addDays(1)) {
      if (!plan.isActiveOn(date)) continue;
      final quantity = plan.rule.quantityOn(date, plan.doseQuantityScaled);
      if (quantity <= 0) continue;
      result.add(
        PlannedDose(
          plan: plan,
          localDate: date,
          scheduledAt: time.toUtc(date, plan.minutesOfDay),
          quantityScaled: quantity,
        ),
      );
    }
  }
  result.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  return result;
}
