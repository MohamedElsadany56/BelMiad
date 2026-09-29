import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';
import '../domain/recurrence_rule.dart';

abstract final class ScheduleTypes {
  static const fixedTime = 'fixed_time';
  static const mealRelative = 'meal_relative';
}

class ScheduleInput {
  const ScheduleInput({
    required this.scheduleType,
    required this.doseQuantityScaled,
    required this.rule,
    this.fixedTime,
    this.mealId,
    this.timingRelation,
    this.offsetMinutes,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
  });

  final String scheduleType;
  final String? fixedTime;
  final String? mealId;
  final String? timingRelation;
  final int? offsetMinutes;
  final int doseQuantityScaled;
  final RecurrenceRule rule;
  final String? validFrom;
  final String? validUntil;
  final bool isActive;
}

/// One time of day within a dose plan.
class ScheduleSlot {
  const ScheduleSlot({
    required this.scheduleType,
    required this.doseQuantityScaled,
    this.scheduleId,
    this.fixedTime,
    this.mealId,
    this.timingRelation,
    this.offsetMinutes,
  });

  /// Existing schedule being edited, or null for a new time.
  final String? scheduleId;
  final String scheduleType;
  final String? fixedTime;
  final String? mealId;
  final String? timingRelation;
  final int? offsetMinutes;
  final int doseQuantityScaled;

  ScheduleInput toInput({
    required RecurrenceRule rule,
    String? validFrom,
    String? validUntil,
  }) =>
      ScheduleInput(
        scheduleType: scheduleType,
        fixedTime: fixedTime,
        mealId: mealId,
        timingRelation: timingRelation,
        offsetMinutes: offsetMinutes,
        doseQuantityScaled: doseQuantityScaled,
        rule: rule,
        validFrom: validFrom,
        validUntil: validUntil,
      );
}

class ScheduleRepository {
  ScheduleRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<MedicationSchedule>> watchForMedication(String medicationId) =>
      (_db.select(_db.medicationSchedules)
            ..where(
              (s) => s.medicationId.equals(medicationId) & s.deletedAt.isNull(),
            )
            ..orderBy([
              (s) => OrderingTerm.asc(s.fixedTime),
              (s) => OrderingTerm.asc(s.createdAt),
            ]))
          .watch();

  Stream<List<MedicationSchedule>> watchForPatient(String patientId) {
    final query = _db.select(_db.medicationSchedules).join([
      innerJoin(
        _db.medications,
        _db.medications.medicationId
            .equalsExp(_db.medicationSchedules.medicationId),
      ),
    ])
      ..where(
        _db.medications.patientId.equals(patientId) &
            _db.medications.deletedAt.isNull() &
            _db.medicationSchedules.deletedAt.isNull(),
      );
    return query.watch().map((rows) =>
        rows.map((r) => r.readTable(_db.medicationSchedules)).toList());
  }

  Future<MedicationSchedule?> get(String scheduleId) =>
      (_db.select(_db.medicationSchedules)
            ..where((s) => s.scheduleId.equals(scheduleId)))
          .getSingleOrNull();

  Future<String> create(String medicationId, ScheduleInput input) async {
    _validate(input);
    final medication = await _medication(medicationId);
    final now = _clock();
    final id = newId();
    await _db.transaction(() async {
      await _db.into(_db.medicationSchedules).insert(
            MedicationSchedulesCompanion.insert(
              scheduleId: id,
              medicationId: medicationId,
              scheduleType: input.scheduleType,
              fixedTime: Value(input.fixedTime),
              mealId: Value(input.mealId),
              timingRelation: Value(input.timingRelation),
              offsetMinutes: Value(input.offsetMinutes),
              doseQuantityScaled: input.doseQuantityScaled,
              recurrenceRule: input.rule.encode(),
              validFrom: Value(input.validFrom),
              validUntil: Value(input.validUntil),
              isActive: Value(input.isActive),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.schedule,
        entityId: id,
        action: AuditActions.created,
        metadata: _metadata(medication, input),
      );
    });
    return id;
  }

  Future<void> update(String scheduleId, ScheduleInput input) async {
    _validate(input);
    final current = await get(scheduleId);
    if (current == null) throw NotFoundException('schedule');
    final medication = await _medication(current.medicationId);
    await _db.transaction(() async {
      await (_db.update(_db.medicationSchedules)
            ..where((s) => s.scheduleId.equals(scheduleId)))
          .write(MedicationSchedulesCompanion(
        scheduleType: Value(input.scheduleType),
        fixedTime: Value(input.fixedTime),
        mealId: Value(input.mealId),
        timingRelation: Value(input.timingRelation),
        offsetMinutes: Value(input.offsetMinutes),
        doseQuantityScaled: Value(input.doseQuantityScaled),
        recurrenceRule: Value(input.rule.encode()),
        validFrom: Value(input.validFrom),
        validUntil: Value(input.validUntil),
        isActive: Value(input.isActive),
        updatedAt: Value(_clock()),
      ));
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.schedule,
        entityId: scheduleId,
        action: AuditActions.updated,
        metadata: _metadata(medication, input),
      );
    });
  }

  /// Schedules are soft-deleted; their historical doses remain.
  Future<void> delete(String scheduleId) async {
    final current = await get(scheduleId);
    if (current == null) return;
    final medication = await _medication(current.medicationId);
    final now = _clock();
    await _db.transaction(() async {
      await (_db.update(_db.medicationSchedules)
            ..where((s) => s.scheduleId.equals(scheduleId)))
          .write(MedicationSchedulesCompanion(
        isActive: const Value(false),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.schedule,
        entityId: scheduleId,
        action: AuditActions.deleted,
      );
    });
  }

  /// Schedules of one dose plan (or a single ungrouped schedule).
  Future<List<MedicationSchedule>> getGroup(String groupOrScheduleId) =>
      (_db.select(_db.medicationSchedules)
            ..where(
              (s) =>
                  (s.groupId.equals(groupOrScheduleId) |
                      s.scheduleId.equals(groupOrScheduleId)) &
                  s.deletedAt.isNull(),
            ))
          .get();

  /// Saves a dose plan with several times of day in one transaction, e.g.
  /// "3 times a day after meals". Times removed from an existing plan are
  /// soft-deleted; their past doses stay in the history.
  Future<String> saveGroup({
    required String medicationId,
    required List<ScheduleSlot> slots,
    required RecurrenceRule rule,
    String? groupId,
    String? validFrom,
    String? validUntil,
  }) async {
    if (slots.isEmpty) throw const ValidationException('timesRequired');
    for (final slot in slots) {
      _validate(
        slot.toInput(rule: rule, validFrom: validFrom, validUntil: validUntil),
      );
    }
    final medication = await _medication(medicationId);
    final id = groupId ?? newId();
    final now = _clock();
    await _db.transaction(() async {
      final existing =
          groupId == null ? <MedicationSchedule>[] : await getGroup(groupId);
      final kept = slots.map((s) => s.scheduleId).whereType<String>().toSet();
      for (final old in existing) {
        if (kept.contains(old.scheduleId)) continue;
        await (_db.update(_db.medicationSchedules)
              ..where((s) => s.scheduleId.equals(old.scheduleId)))
            .write(MedicationSchedulesCompanion(
          isActive: const Value(false),
          deletedAt: Value(now),
          updatedAt: Value(now),
        ));
      }
      for (final slot in slots) {
        final input = slot.toInput(
            rule: rule, validFrom: validFrom, validUntil: validUntil);
        final companion = MedicationSchedulesCompanion(
          groupId: Value(id),
          scheduleType: Value(input.scheduleType),
          fixedTime: Value(input.fixedTime),
          mealId: Value(input.mealId),
          timingRelation: Value(input.timingRelation),
          offsetMinutes: Value(input.offsetMinutes),
          doseQuantityScaled: Value(input.doseQuantityScaled),
          recurrenceRule: Value(rule.encode()),
          validFrom: Value(validFrom),
          validUntil: Value(validUntil),
          isActive: const Value(true),
          updatedAt: Value(now),
        );
        if (slot.scheduleId != null &&
            existing.any((e) => e.scheduleId == slot.scheduleId)) {
          await (_db.update(_db.medicationSchedules)
                ..where((s) => s.scheduleId.equals(slot.scheduleId!)))
              .write(companion);
        } else {
          await _db.into(_db.medicationSchedules).insert(
                companion.copyWith(
                  scheduleId: Value(newId()),
                  medicationId: Value(medicationId),
                  createdAt: Value(now),
                ),
              );
        }
      }
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.schedule,
        entityId: id,
        action: groupId == null ? AuditActions.created : AuditActions.updated,
        metadata: {
          'medication': medication.nameEn,
          'times': slots.length,
          'rule': rule.toJson(),
        },
      );
    });
    return id;
  }

  Future<void> deleteGroup(String groupOrScheduleId) async {
    final schedules = await getGroup(groupOrScheduleId);
    for (final schedule in schedules) {
      await delete(schedule.scheduleId);
    }
  }

  Future<Medication> _medication(String medicationId) async {
    final medication = await (_db.select(_db.medications)
          ..where((m) => m.medicationId.equals(medicationId)))
        .getSingleOrNull();
    if (medication == null) throw NotFoundException('medication');
    return medication;
  }

  Map<String, Object?> _metadata(Medication medication, ScheduleInput input) =>
      {
        'medication': medication.nameEn,
        'type': input.scheduleType,
        'time': input.fixedTime,
        'meal_id': input.mealId,
        'quantity_scaled': input.doseQuantityScaled,
        'rule': input.rule.toJson(),
      };

  void _validate(ScheduleInput input) {
    if (input.doseQuantityScaled <= 0) {
      throw const ValidationException('quantityRequired');
    }
    if (input.scheduleType == ScheduleTypes.fixedTime) {
      if (LocalTime.tryParse(input.fixedTime) == null) {
        throw const ValidationException('invalidTime');
      }
    } else if (input.scheduleType == ScheduleTypes.mealRelative) {
      if (input.mealId == null) {
        throw const ValidationException('mealRequired');
      }
    } else {
      throw const ValidationException('invalidScheduleType');
    }
    final rule = input.rule;
    if (rule.type == RecurrenceType.weekly && rule.weekdays.isEmpty) {
      throw const ValidationException('weekdaysRequired');
    }
    if (rule.interval < 1 || rule.onDays < 1 || rule.offDays < 0) {
      throw const ValidationException('invalidRecurrence');
    }
    final from = LocalDate.tryParse(input.validFrom);
    final until = LocalDate.tryParse(input.validUntil);
    if (from != null && until != null && until.isBefore(from)) {
      throw const ValidationException('endBeforeStart');
    }
  }
}
