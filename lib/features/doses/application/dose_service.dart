import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/session/session_context.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';
import '../../inventory/application/inventory_service.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../inventory/domain/batch_selection.dart';
import '../domain/dose_status.dart';

/// Everything the dose confirmation UI needs to decide how to proceed.
class TakeDoseContext {
  const TakeDoseContext({
    required this.medication,
    required this.requiredScaled,
    required this.stockRecorded,
    required this.usableScaled,
    required this.usableBatches,
    required this.takenTodayScaled,
    required this.today,
    this.dose,
  });

  final DoseInstance? dose;
  final Medication medication;
  final int requiredScaled;
  final bool stockRecorded;
  final int usableScaled;

  /// Usable batches in FEFO order.
  final List<InventoryBatch> usableBatches;
  final int takenTodayScaled;
  final LocalDate today;

  int? get maximumScaled => medication.maximumDailyQuantityScaled;

  /// Stock is recorded but cannot cover the required quantity (spec §17).
  bool get isInsufficient => stockRecorded && usableScaled < requiredScaled;

  bool wouldExceedMaximum(int attemptScaled) {
    final maximum = maximumScaled;
    return maximum != null && takenTodayScaled + attemptScaled > maximum;
  }

  /// Automatic FEFO suggestion, or empty when not applicable.
  List<BatchAllocation> suggestedAllocation(int quantityScaled) {
    if (!stockRecorded || quantityScaled <= 0) return const [];
    try {
      return allocateFefo(
        usableBatches.map(snapshotOf),
        requiredScaled: quantityScaled,
        today: today,
      );
    } on InsufficientStockException {
      return const [];
    }
  }
}

/// Transactional dose use cases (spec §9, §17–§19, §28).
class DoseService {
  DoseService(
    this._db,
    this._inventory,
    this._inventoryService,
    this._audit,
    this._session, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final AppDatabase _db;
  final InventoryRepository _inventory;
  final InventoryService _inventoryService;
  final AuditLog _audit;
  final SessionContext _session;
  final Clock _clock;

  Future<TakeDoseContext> prepareTake(String doseInstanceId) async {
    final dose = await _dose(doseInstanceId);
    return _context(
      medicationId: dose.medicationId,
      requiredScaled: dose.requiredQuantityScaled,
      dose: dose,
    );
  }

  Future<TakeDoseContext> preparePrn(
    String medicationId, {
    required int quantityScaled,
  }) =>
      _context(medicationId: medicationId, requiredScaled: quantityScaled);

  Future<TakeDoseContext> _context({
    required String medicationId,
    required int requiredScaled,
    DoseInstance? dose,
  }) async {
    final medication = await _medication(medicationId);
    final time = await _patientTime(medication.patientId);
    final now = _clock();
    final today = time.today(now);
    final dayDate = dose == null ? today : LocalDate.parse(dose.localDate);
    final batches = await _inventory.getBatchesForMedication(medicationId);
    final usable = await _inventory.getAvailableBatches(
      medicationId,
      today: today,
    );
    return TakeDoseContext(
      dose: dose,
      medication: medication,
      requiredScaled: requiredScaled,
      stockRecorded: batches.isNotEmpty,
      usableScaled: usable.fold(0, (s, b) => s + b.availableQuantityScaled),
      usableBatches: usable,
      takenTodayScaled: await _takenOn(medicationId, dayDate),
      today: today,
    );
  }

  /// Marks a scheduled dose TAKEN in one transaction: validation, maximum
  /// daily check, batch selection, consumption, stock decrement, status,
  /// late minutes, audit and notification state (spec §18). Any failure rolls
  /// back everything.
  ///
  /// [takenAt] records an intake that happened earlier, e.g. the patient took
  /// the dose alone and the caregiver records it on arrival. The grace window
  /// is checked against the actual intake time, so a dose the app already
  /// marked MISSED only because nobody logged it can be corrected — but a
  /// dose that really was missed can still never be taken late.
  Future<void> takeDose({
    required String doseInstanceId,
    required int actualQuantityScaled,
    List<BatchAllocation>? manualAllocations,
    bool overrideMaximum = false,
    int graceMinutes = 180,
    DateTime? takenAt,
  }) async {
    await _db.transaction(() async {
      final now = _clock();
      final dose = await _dose(doseInstanceId);
      final status = DoseStatus.fromCode(dose.status);
      final intake = takenAt?.toUtc() ?? now;
      final correctingMissed = status == DoseStatus.missed && takenAt != null;
      if (!correctingMissed) status.ensureCanTransitionTo(DoseStatus.taken);
      if (takenAt != null) {
        validateIntakeTime(
          scheduledAt: dose.scheduledAt,
          takenAt: intake,
          now: now,
          graceMinutes: dose.isPrn ? null : graceMinutes,
        );
      } else if (!dose.isPrn &&
          isPastGraceWindow(
            scheduledAt: dose.scheduledAt,
            now: now,
            graceMinutes: graceMinutes,
          )) {
        throw const DoseWindowClosedException();
      }
      await _recordTaken(
        dose: dose,
        actualQuantityScaled: actualQuantityScaled,
        manualAllocations: manualAllocations,
        overrideMaximum: overrideMaximum,
        now: now,
        takenAt: intake,
        auditAction: isRecordedLater(intake, now)
            ? AuditActions.doseRecordedLate
            : AuditActions.doseTaken,
        correctedMissed: correctingMissed,
      );
    });
  }

  /// Records an as-needed (PRN) dose at the moment it was taken. No future
  /// PRN consumption is ever invented (spec §8).
  Future<String> logPrnDose({
    required String medicationId,
    required int actualQuantityScaled,
    List<BatchAllocation>? manualAllocations,
    bool overrideMaximum = false,
    String? notes,
    DateTime? takenAt,
  }) async {
    final id = newId();
    await _db.transaction(() async {
      final now = _clock();
      final intake = takenAt?.toUtc() ?? now;
      if (intake.isAfter(now.add(const Duration(minutes: 1)))) {
        throw const ValidationException('takenInFuture');
      }
      final medication = await _medication(medicationId);
      final time = await _patientTime(medication.patientId);
      await _db.into(_db.doseInstances).insert(
            DoseInstancesCompanion.insert(
              doseInstanceId: id,
              patientId: medication.patientId,
              medicationId: medicationId,
              localDate: time.localDateOf(intake).toIso(),
              scheduledAt: intake,
              requiredQuantityScaled: actualQuantityScaled,
              status: DoseStatus.scheduled.code,
              isPrn: const Value(true),
              notes: Value(notes),
              createdAt: now,
              updatedAt: now,
            ),
          );
      final dose = await _dose(id);
      await _recordTaken(
        dose: dose,
        actualQuantityScaled: actualQuantityScaled,
        manualAllocations: manualAllocations,
        overrideMaximum: overrideMaximum,
        now: now,
        takenAt: intake,
        auditAction: AuditActions.prnLogged,
      );
    });
    return id;
  }

  Future<void> _recordTaken({
    required DoseInstance dose,
    required int actualQuantityScaled,
    required List<BatchAllocation>? manualAllocations,
    required bool overrideMaximum,
    required DateTime now,
    required DateTime takenAt,
    required String auditAction,
    bool correctedMissed = false,
  }) async {
    // 2. Actual quantity: zero is never TAKEN and never consumes stock.
    if (actualQuantityScaled <= 0) {
      throw const ValidationException('actualQuantityZero');
    }
    final medication = await _medication(dose.medicationId);
    final time = await _patientTime(medication.patientId);
    // Stock usability (expiry) is judged on the day of the actual intake.
    final today = time.today(takenAt);

    // 3. Maximum daily quantity.
    final maximum = medication.maximumDailyQuantityScaled;
    if (maximum != null) {
      final taken =
          await _takenOn(dose.medicationId, LocalDate.parse(dose.localDate));
      if (taken + actualQuantityScaled > maximum) {
        if (!overrideMaximum) {
          throw MaximumDailyQuantityExceededException(
            maximumScaled: maximum,
            alreadyTakenScaled: taken,
            attemptScaled: actualQuantityScaled,
          );
        }
        await _audit.record(
          patientId: dose.patientId,
          entityType: EntityTypes.dose,
          entityId: dose.doseInstanceId,
          action: AuditActions.maximumOverridden,
          metadata: {
            'maximum_scaled': maximum,
            'taken_scaled': taken,
            'attempt_scaled': actualQuantityScaled,
          },
        );
      }
    }

    // 4–6. Batch selection, consumption records, stock decrement. A
    // medication without recorded stock is tracked without consumption.
    var allocations = const <BatchAllocation>[];
    if (await _inventoryService.isStockRecorded(dose.medicationId)) {
      allocations = await _inventoryService.selectBatchesForDose(
        medicationId: dose.medicationId,
        requiredScaled: actualQuantityScaled,
        today: today,
        manualAllocations: manualAllocations,
      );
      await _inventoryService.consumeForDose(
        doseInstanceId: dose.doseInstanceId,
        allocations: allocations,
      );
    }

    // 7–8. Status and late minutes.
    final lateMinutes =
        dose.isPrn ? 0 : calculateLateMinutes(dose.scheduledAt, takenAt);
    await (_db.update(_db.doseInstances)
          ..where((d) => d.doseInstanceId.equals(dose.doseInstanceId)))
        .write(DoseInstancesCompanion(
      status: Value(DoseStatus.taken.code),
      actualQuantityScaled: Value(actualQuantityScaled),
      takenAt: Value(takenAt),
      loggedAt: Value(now),
      missedAt: const Value(null),
      lateMinutes: Value(lateMinutes),
      loggedByPersonId: Value(_session.actorPersonId),
      updatedAt: Value(now),
    ));

    // 9. Audit.
    await _audit.record(
      patientId: dose.patientId,
      entityType: EntityTypes.dose,
      entityId: dose.doseInstanceId,
      action: auditAction,
      metadata: {
        'medication': medication.nameEn,
        'required_scaled': dose.requiredQuantityScaled,
        'actual_scaled': actualQuantityScaled,
        'late_minutes': lateMinutes,
        'taken_at': takenAt.toUtc().toIso8601String(),
        'recorded_at': now.toUtc().toIso8601String(),
        if (correctedMissed) 'corrected_missed': true,
        'batches': [
          for (final a in allocations)
            {'batch_id': a.batchId, 'quantity_scaled': a.quantityScaled},
        ],
      },
    );
    if (manualAllocations != null && allocations.isNotEmpty) {
      await _audit.record(
        patientId: dose.patientId,
        entityType: EntityTypes.dose,
        entityId: dose.doseInstanceId,
        action: AuditActions.batchManuallySelected,
        metadata: {
          'batches': [
            for (final a in allocations)
              {'batch_id': a.batchId, 'quantity_scaled': a.quantityScaled},
          ],
        },
      );
    }

    // 10. Notification state.
    await _cancelDoseNotifications(dose.doseInstanceId, now);
  }

  /// Undoes a TAKEN dose, restoring the exact original batches (spec §19).
  Future<void> undoDose(String doseInstanceId) async {
    await _db.transaction(() async {
      final now = _clock();
      final dose = await _dose(doseInstanceId);
      final status = DoseStatus.fromCode(dose.status);
      if (status != DoseStatus.taken) {
        throw InvalidDoseTransitionException(dose.status, 'UNDO');
      }
      final restored =
          await _inventoryService.restoreDoseConsumption(doseInstanceId);
      await (_db.update(_db.doseInstances)
            ..where((d) => d.doseInstanceId.equals(doseInstanceId)))
          .write(DoseInstancesCompanion(
        status: Value(DoseStatus.scheduled.code),
        takenAt: const Value(null),
        loggedAt: const Value(null),
        actualQuantityScaled: const Value(null),
        lateMinutes: const Value(null),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: dose.patientId,
        entityType: EntityTypes.dose,
        entityId: doseInstanceId,
        action: AuditActions.doseUndone,
        metadata: {
          'restored': [
            for (final c in restored)
              {
                'batch_id': c.inventoryBatchId,
                'quantity_scaled': c.quantityScaled,
              },
          ],
        },
      );
    });
  }

  Future<void> skipDose(String doseInstanceId, {String? reason}) async {
    await _db.transaction(() async {
      final now = _clock();
      final dose = await _dose(doseInstanceId);
      DoseStatus.fromCode(dose.status)
          .ensureCanTransitionTo(DoseStatus.skipped);
      await (_db.update(_db.doseInstances)
            ..where((d) => d.doseInstanceId.equals(doseInstanceId)))
          .write(DoseInstancesCompanion(
        status: Value(DoseStatus.skipped.code),
        skippedAt: Value(now),
        loggedByPersonId: Value(_session.actorPersonId),
        notes: Value(reason),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: dose.patientId,
        entityType: EntityTypes.dose,
        entityId: doseInstanceId,
        action: AuditActions.doseSkipped,
        metadata: {'reason': reason},
      );
      await _cancelDoseNotifications(doseInstanceId, now);
    });
  }

  Future<void> _cancelDoseNotifications(String doseId, DateTime now) async {
    await (_db.update(_db.notifications)
          ..where(
            (n) =>
                n.doseInstanceId.equals(doseId) & n.status.equals('scheduled'),
          ))
        .write(NotificationsCompanion(
      status: const Value('cancelled'),
      updatedAt: Value(now),
    ));
  }

  /// Quantity already TAKEN of a medication on a patient-local date.
  Future<int> _takenOn(String medicationId, LocalDate date) async {
    final rows = await (_db.select(_db.doseInstances)
          ..where(
            (d) =>
                d.medicationId.equals(medicationId) &
                d.localDate.equals(date.toIso()) &
                d.status.equals(DoseStatus.taken.code),
          ))
        .get();
    return rows.fold<int>(0, (s, d) => s + (d.actualQuantityScaled ?? 0));
  }

  Future<DoseInstance> _dose(String id) async {
    final dose = await (_db.select(_db.doseInstances)
          ..where((d) => d.doseInstanceId.equals(id)))
        .getSingleOrNull();
    if (dose == null) throw NotFoundException('dose');
    return dose;
  }

  Future<Medication> _medication(String id) async {
    final medication = await (_db.select(_db.medications)
          ..where((m) => m.medicationId.equals(id)))
        .getSingleOrNull();
    if (medication == null) throw NotFoundException('medication');
    return medication;
  }

  Future<PatientTime> _patientTime(String patientId) async {
    final patient = await (_db.select(_db.patients)
          ..where((p) => p.patientId.equals(patientId)))
        .getSingleOrNull();
    return PatientTime(patient?.timezone ?? defaultTimezone);
  }
}
