import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../meals/domain/meal_timing.dart';
import '../../medications/data/medication_repository.dart';
import '../data/schedule_repository.dart';
import '../domain/recurrence_rule.dart';
import '../domain/schedule_plan.dart';

/// Resolves stored schedules (fixed or meal-relative) into [SchedulePlan]s.
class SchedulePlanLoader {
  SchedulePlanLoader(this._db);

  final AppDatabase _db;

  /// Plans for active, non-deleted schedules of active medications.
  Future<List<SchedulePlan>> plansForPatient(
    String patientId, {
    String? medicationId,
  }) async {
    final medsQuery = _db.select(_db.medications)
      ..where(
        (m) =>
            m.patientId.equals(patientId) &
            m.deletedAt.isNull() &
            m.status.equals(MedicationStatus.active),
      );
    if (medicationId != null) {
      medsQuery.where((m) => m.medicationId.equals(medicationId));
    }
    final medications = await medsQuery.get();
    if (medications.isEmpty) return const [];
    final byId = {for (final m in medications) m.medicationId: m};
    final schedules = await (_db.select(_db.medicationSchedules)
          ..where(
            (s) =>
                s.medicationId.isIn(byId.keys) &
                s.deletedAt.isNull() &
                s.isActive.equals(true),
          ))
        .get();
    final meals = await (_db.select(_db.meals)
          ..where((m) => m.patientId.equals(patientId)))
        .get();
    final mealsById = {for (final m in meals) m.mealId: m};
    return [
      for (final schedule in schedules)
        planFor(
          schedule,
          byId[schedule.medicationId]!,
          mealsById[schedule.mealId],
        ),
    ];
  }

  static SchedulePlan planFor(
    MedicationSchedule schedule,
    Medication medication,
    Meal? meal,
  ) {
    final int minutes;
    if (schedule.scheduleType == ScheduleTypes.mealRelative) {
      final mealTime = meal == null
          ? defaultMealTime(MealType.custom)
          : effectiveMealTime(meal.mealType, meal.defaultTime);
      minutes = mealRelativeMinutes(
        mealTime: mealTime,
        relation: timingRelationFromCode(schedule.timingRelation),
        offsetMinutes: schedule.offsetMinutes ?? 0,
      );
    } else {
      minutes =
          (LocalTime.tryParse(schedule.fixedTime) ?? const LocalTime(8, 0))
              .minutesOfDay;
    }
    final created = LocalDate.fromDateTime(schedule.createdAt.toUtc());
    return SchedulePlan(
      scheduleId: schedule.scheduleId,
      medicationId: schedule.medicationId,
      minutesOfDay: minutes,
      doseQuantityScaled: schedule.doseQuantityScaled,
      rule: RecurrenceRule.decode(schedule.recurrenceRule),
      anchor: LocalDate.tryParse(schedule.validFrom) ?? created,
      validFrom: LocalDate.tryParse(schedule.validFrom),
      validUntil: LocalDate.tryParse(schedule.validUntil),
      medicationStart: LocalDate.tryParse(medication.startDate),
      medicationEnd: LocalDate.tryParse(medication.endDate),
    );
  }

  /// Plans grouped by medication, for stock forecasting.
  ///
  /// For PRN medications, schedules represent a user-configured *planned
  /// frequency*: they are forecast, but never generate dose instances. A PRN
  /// medication without schedules has no forecast (usage is never invented).
  Future<Map<String, List<SchedulePlan>>> forecastPlans(
    String patientId,
  ) async {
    final plans = await plansForPatient(patientId);
    final result = <String, List<SchedulePlan>>{};
    for (final plan in plans) {
      result.putIfAbsent(plan.medicationId, () => []).add(plan);
    }
    return result;
  }

  static PatientTime timeFor(Patient patient) => PatientTime(patient.timezone);
}
