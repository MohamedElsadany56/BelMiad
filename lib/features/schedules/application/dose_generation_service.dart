import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/patient_time.dart';
import '../../audit/data/audit_log.dart';
import '../../doses/domain/dose_status.dart';
import '../domain/schedule_plan.dart';
import 'schedule_plan_loader.dart';

/// Deterministic dose ID: the same schedule and local date always map to the
/// same dose, so repeated generation and backup merges never duplicate doses.
String scheduledDoseId(String scheduleId, String localDate) =>
    '$scheduleId@$localDate';

/// Generates dose instances from schedules and marks overdue doses MISSED.
class DoseGenerationService {
  DoseGenerationService(
    this._db,
    this._loader,
    this._audit, {
    Clock clock = systemClock,
    this.horizonDays = 7,
    this.lookbackDays = 31,
  }) : _clock = clock;

  final AppDatabase _db;
  final SchedulePlanLoader _loader;
  final AuditLog _audit;
  final Clock _clock;
  final int horizonDays;
  final int lookbackDays;

  Future<void> syncAll({required int graceMinutes}) async {
    final patients = await (_db.select(_db.patients)
          ..where((p) => p.deletedAt.isNull()))
        .get();
    for (final patient in patients) {
      await syncPatient(patient.patientId, graceMinutes: graceMinutes);
    }
  }

  /// Ensures doses exist for the generation window and marks overdue ones
  /// MISSED. With [regenerate], future SCHEDULED doses are rebuilt first —
  /// used after schedule, meal-time, medication or timezone changes.
  Future<void> syncPatient(
    String patientId, {
    required int graceMinutes,
    bool regenerate = false,
  }) async {
    final patient = await (_db.select(_db.patients)
          ..where((p) => p.patientId.equals(patientId)))
        .getSingleOrNull();
    if (patient == null || patient.deletedAt != null) return;
    final time = PatientTime(patient.timezone);
    final now = _clock();

    await _db.transaction(() async {
      if (regenerate) await _removeFutureScheduled(patientId, now);
      final plans = await _generationPlans(patientId);
      final today = time.today(now);
      final schedules = await (_db.select(_db.medicationSchedules)
            ..where((s) => s.scheduleId.isIn(plans.map((p) => p.scheduleId))))
          .get();
      final lowerBounds = {
        for (final s in schedules) s.scheduleId: s.updatedAt.toUtc(),
      };
      final planned = expandPlans(
        plans,
        from: today.addDays(-lookbackDays),
        to: today.addDays(horizonDays),
        time: time,
      );
      for (final dose in planned) {
        // Never back-fill occurrences from before the schedule existed (or was
        // last edited); that would fabricate missed doses.
        final bound = lowerBounds[dose.plan.scheduleId];
        if (bound != null && dose.scheduledAt.isBefore(bound)) continue;
        final localDate = dose.localDate.toIso();
        await _db.into(_db.doseInstances).insert(
              DoseInstancesCompanion.insert(
                doseInstanceId:
                    scheduledDoseId(dose.plan.scheduleId, localDate),
                patientId: patientId,
                medicationId: dose.plan.medicationId,
                scheduleId: Value(dose.plan.scheduleId),
                localDate: localDate,
                scheduledAt: dose.scheduledAt,
                requiredQuantityScaled: dose.quantityScaled,
                status: DoseStatus.scheduled.code,
                createdAt: now,
                updatedAt: now,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      await _markMissed(patientId, now, graceMinutes);
    });
  }

  Future<List<SchedulePlan>> _generationPlans(String patientId) async {
    final plans = await _loader.plansForPatient(patientId);
    if (plans.isEmpty) return plans;
    final prnIds = await (_db.selectOnly(_db.medications)
          ..addColumns([_db.medications.medicationId])
          ..where(
            _db.medications.patientId.equals(patientId) &
                _db.medications.isPrn.equals(true),
          ))
        .map((r) => r.read(_db.medications.medicationId)!)
        .get();
    return plans.where((p) => !prnIds.contains(p.medicationId)).toList();
  }

  /// Removes future, still-SCHEDULED, schedule-generated doses. History
  /// (taken/missed/skipped and past doses) is never touched.
  Future<void> _removeFutureScheduled(String patientId, DateTime now) async {
    final ids = await (_db.selectOnly(_db.doseInstances)
          ..addColumns([_db.doseInstances.doseInstanceId])
          ..where(
            _db.doseInstances.patientId.equals(patientId) &
                _db.doseInstances.status.equals(DoseStatus.scheduled.code) &
                _db.doseInstances.scheduleId.isNotNull() &
                _db.doseInstances.scheduledAt.isBiggerThanValue(now),
          ))
        .map((r) => r.read(_db.doseInstances.doseInstanceId)!)
        .get();
    if (ids.isEmpty) return;
    await (_db.update(_db.notifications)
          ..where(
              (n) => n.doseInstanceId.isIn(ids) & n.status.equals('scheduled')))
        .write(NotificationsCompanion(
      status: const Value('cancelled'),
      updatedAt: Value(now),
    ));
    await (_db.delete(_db.doseInstances)
          ..where((d) => d.doseInstanceId.isIn(ids)))
        .go();
  }

  Future<void> _markMissed(
    String patientId,
    DateTime now,
    int graceMinutes,
  ) async {
    final cutoff = now.subtract(Duration(minutes: graceMinutes));
    final overdue = await (_db.select(_db.doseInstances)
          ..where(
            (d) =>
                d.patientId.equals(patientId) &
                d.status.equals(DoseStatus.scheduled.code) &
                d.isPrn.equals(false) &
                d.scheduledAt.isSmallerThanValue(cutoff),
          ))
        .get();
    for (final dose in overdue) {
      await (_db.update(_db.doseInstances)
            ..where((d) => d.doseInstanceId.equals(dose.doseInstanceId)))
          .write(DoseInstancesCompanion(
        status: Value(DoseStatus.missed.code),
        missedAt: Value(now),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.dose,
        entityId: dose.doseInstanceId,
        action: AuditActions.doseMissed,
        systemAction: true,
        metadata: {'scheduled_at': dose.scheduledAt.toUtc().toIso8601String()},
      );
    }
  }
}
