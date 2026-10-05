import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../schedules/data/schedule_repository.dart';
import '../domain/dose_grouping.dart';
import '../domain/dose_status.dart';

class DoseView {
  const DoseView({
    required this.dose,
    required this.medication,
    this.schedule,
  });

  final DoseInstance dose;
  final Medication medication;

  /// The schedule the dose was generated from (null for PRN doses).
  final MedicationSchedule? schedule;

  DoseStatus get status => DoseStatus.fromCode(dose.status);

  /// Input of the shared grouping rule (`dose_grouping.dart`).
  DoseGroupInput get groupInput {
    final mealRelative = schedule?.scheduleType == ScheduleTypes.mealRelative;
    return DoseGroupInput(
      patientId: dose.patientId,
      localDate: dose.localDate,
      scheduledAt: dose.scheduledAt,
      isPrn: dose.isPrn,
      mealId: mealRelative ? schedule?.mealId : null,
      timingRelation: mealRelative ? schedule?.timingRelation : null,
    );
  }
}

/// Read-side dose queries. All mutations go through [DoseService].
class DoseRepository {
  DoseRepository(this._db);

  final AppDatabase _db;

  JoinedSelectStatement<HasResultSet, dynamic> _joined() =>
      _db.select(_db.doseInstances).join([
        innerJoin(
          _db.medications,
          _db.medications.medicationId
              .equalsExp(_db.doseInstances.medicationId),
        ),
        leftOuterJoin(
          _db.medicationSchedules,
          _db.medicationSchedules.scheduleId
              .equalsExp(_db.doseInstances.scheduleId),
        ),
      ]);

  DoseView _map(TypedResult r) => DoseView(
        dose: r.readTable(_db.doseInstances),
        medication: r.readTable(_db.medications),
        schedule: r.readTableOrNull(_db.medicationSchedules),
      );

  /// Hides undone PRN entries, which only exist for history.
  Expression<bool> get _visible =>
      _db.doseInstances.isPrn.equals(false) |
      _db.doseInstances.status.equals(DoseStatus.taken.code);

  /// Doses on a patient-local calendar date.
  Stream<List<DoseView>> watchDay(String patientId, String localDate) {
    final query = _joined()
      ..where(
        _db.doseInstances.patientId.equals(patientId) &
            _db.doseInstances.localDate.equals(localDate) &
            _visible,
      )
      ..orderBy([OrderingTerm.asc(_db.doseInstances.scheduledAt)]);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  Stream<List<DoseView>> watchMedicationHistory(
    String medicationId, {
    int limit = 200,
  }) {
    final query = _joined()
      ..where(
        _db.doseInstances.medicationId.equals(medicationId) &
            _visible &
            (_db.doseInstances.status.equals(DoseStatus.scheduled.code).not() |
                _db.doseInstances.scheduledAt
                    .isSmallerOrEqualValue(DateTime.now().toUtc())),
      )
      ..orderBy([OrderingTerm.desc(_db.doseInstances.scheduledAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  /// Doses for a patient within an optional UTC period (reports).
  Future<List<DoseView>> forPatient(
    String patientId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final query = _joined()
      ..where(_db.doseInstances.patientId.equals(patientId) & _visible)
      ..orderBy([OrderingTerm.asc(_db.doseInstances.scheduledAt)]);
    if (from != null) {
      query.where(_db.doseInstances.scheduledAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where(_db.doseInstances.scheduledAt.isSmallerOrEqualValue(to));
    }
    return (await query.get()).map(_map).toList();
  }

  Future<List<DoseConsumption>> consumptionFor(String doseInstanceId) =>
      (_db.select(_db.doseInventoryConsumption)
            ..where((c) => c.doseInstanceId.equals(doseInstanceId))
            ..orderBy([(c) => OrderingTerm.asc(c.createdAt)]))
          .get();
}
