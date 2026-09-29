import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/files/app_file_store.dart';
import '../../../core/time/clock.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';

abstract final class AppointmentStatus {
  static const scheduled = 'scheduled';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const all = [scheduled, completed, cancelled];
}

abstract final class VitalTypes {
  static const bloodPressure = 'blood_pressure';
  static const heartRate = 'heart_rate';
  static const bloodGlucose = 'blood_glucose';
  static const temperature = 'temperature';
  static const weight = 'weight';
  static const oxygenSaturation = 'oxygen_saturation';
  static const respiratoryRate = 'respiratory_rate';
  static const other = 'other';

  static const all = [
    bloodPressure,
    heartRate,
    bloodGlucose,
    temperature,
    weight,
    oxygenSaturation,
    respiratoryRate,
    other,
  ];

  static String defaultUnit(String type) => switch (type) {
        bloodPressure => 'mmHg',
        heartRate => 'bpm',
        bloodGlucose => 'mg/dL',
        temperature => '°C',
        weight => 'kg',
        oxygenSaturation => '%',
        respiratoryRate => '/min',
        _ => '',
      };

  static bool hasSecondValue(String type) => type == bloodPressure;
}

/// When a measurement was taken relative to meals or medicines. Offered for
/// blood pressure and blood glucose.
abstract final class VitalContexts {
  static const random = 'random';
  static const fasting = 'fasting';
  static const beforeMeal = 'before_meal';
  static const afterMeal = 'after_meal';
  static const afterMedication = 'after_medication';
  static const all = [random, fasting, beforeMeal, afterMeal, afterMedication];

  static bool appliesTo(String measurementType) =>
      measurementType == VitalTypes.bloodPressure ||
      measurementType == VitalTypes.bloodGlucose;
}

abstract final class DietRuleTypes {
  static const avoid = 'avoid';
  static const limit = 'limit';
  static const prefer = 'prefer';
  static const separateFromMedication = 'separate_from_medication';
  static const all = [avoid, limit, prefer, separateFromMedication];
}

String? _blank(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

class AppointmentRepository {
  AppointmentRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<Appointment>> watchForPatient(String patientId) =>
      (_db.select(_db.appointments)
            ..where((a) => a.patientId.equals(patientId) & a.deletedAt.isNull())
            ..orderBy([(a) => OrderingTerm.desc(a.scheduledTime)]))
          .watch();

  Future<String> save({
    String? appointmentId,
    required String patientId,
    required String doctorName,
    String? specialty,
    required DateTime scheduledTime,
    String? location,
    String? notes,
    String status = AppointmentStatus.scheduled,
  }) async {
    if (doctorName.trim().isEmpty) {
      throw const ValidationException('doctorRequired');
    }
    final now = _clock();
    final id = appointmentId ?? newId();
    final companion = AppointmentsCompanion(
      appointmentId: Value(id),
      patientId: Value(patientId),
      doctorName: Value(doctorName.trim()),
      specialty: Value(_blank(specialty)),
      scheduledTime: Value(scheduledTime.toUtc()),
      location: Value(_blank(location)),
      notes: Value(_blank(notes)),
      status: Value(status),
      updatedAt: Value(now),
    );
    await _db.transaction(() async {
      if (appointmentId == null) {
        await _db
            .into(_db.appointments)
            .insert(companion.copyWith(createdAt: Value(now)));
      } else {
        await (_db.update(_db.appointments)
              ..where((a) => a.appointmentId.equals(appointmentId)))
            .write(companion);
      }
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.appointment,
        entityId: id,
        action:
            appointmentId == null ? AuditActions.created : AuditActions.updated,
        metadata: {'doctor': doctorName.trim(), 'status': status},
      );
    });
    return id;
  }
}

class VitalsRepository {
  VitalsRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<VitalMeasurement>> watchForPatient(String patientId) =>
      (_db.select(_db.vitalsMeasurements)
            ..where((v) => v.patientId.equals(patientId) & v.deletedAt.isNull())
            ..orderBy([(v) => OrderingTerm.desc(v.measuredAt)]))
          .watch();

  Future<String> save({
    String? measurementId,
    required String patientId,
    required String measurementType,
    double? value1,
    double? value2,
    String? unit,
    required DateTime measuredAt,
    String? notes,
    String? context,
    String? relatedMealId,
    String? relatedMedicationId,
    int? minutesAfter,
  }) async {
    if (value1 == null) throw const ValidationException('valueRequired');
    final hasContext = VitalContexts.appliesTo(measurementType) &&
        context != null &&
        context != VitalContexts.random;
    final afterMeal = hasContext && context == VitalContexts.afterMeal;
    final afterMedication =
        hasContext && context == VitalContexts.afterMedication;
    if (minutesAfter != null && minutesAfter < 0) {
      throw const ValidationException('invalidTime');
    }
    final now = _clock();
    final id = measurementId ?? newId();
    final companion = VitalsMeasurementsCompanion(
      measurementId: Value(id),
      patientId: Value(patientId),
      measurementType: Value(measurementType),
      value1: Value(value1),
      value2: Value(value2),
      unit: Value(_blank(unit)),
      context: Value(
        VitalContexts.appliesTo(measurementType) ? context : null,
      ),
      relatedMealId: Value(afterMeal ? relatedMealId : null),
      relatedMedicationId: Value(afterMedication ? relatedMedicationId : null),
      minutesAfter: Value(afterMeal || afterMedication ? minutesAfter : null),
      measuredAt: Value(measuredAt.toUtc()),
      notes: Value(_blank(notes)),
      updatedAt: Value(now),
    );
    await _db.transaction(() async {
      if (measurementId == null) {
        await _db
            .into(_db.vitalsMeasurements)
            .insert(companion.copyWith(createdAt: Value(now)));
      } else {
        await (_db.update(_db.vitalsMeasurements)
              ..where((v) => v.measurementId.equals(measurementId)))
            .write(companion);
      }
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.vital,
        entityId: id,
        action:
            measurementId == null ? AuditActions.created : AuditActions.updated,
        metadata: {
          'type': measurementType,
          'value_1': value1,
          'value_2': value2,
          'context': context,
        },
      );
    });
    return id;
  }
}

class IllnessRepository {
  IllnessRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<Illness>> watchForPatient(String patientId) =>
      (_db.select(_db.patientIllnesses)
            ..where((i) => i.patientId.equals(patientId) & i.deletedAt.isNull())
            ..orderBy([(i) => OrderingTerm.desc(i.diagnosedDate)]))
          .watch();

  Future<String> save({
    String? illnessId,
    required String patientId,
    required String conditionName,
    String? diagnosedDate,
    String? notes,
  }) async {
    if (conditionName.trim().isEmpty) {
      throw const ValidationException('nameRequired');
    }
    final now = _clock();
    final id = illnessId ?? newId();
    final companion = PatientIllnessesCompanion(
      illnessId: Value(id),
      patientId: Value(patientId),
      conditionName: Value(conditionName.trim()),
      diagnosedDate: Value(_blank(diagnosedDate)),
      notes: Value(_blank(notes)),
      updatedAt: Value(now),
    );
    await _db.transaction(() async {
      if (illnessId == null) {
        await _db
            .into(_db.patientIllnesses)
            .insert(companion.copyWith(createdAt: Value(now)));
      } else {
        await (_db.update(_db.patientIllnesses)
              ..where((i) => i.illnessId.equals(illnessId)))
            .write(companion);
      }
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.illness,
        entityId: id,
        action: illnessId == null ? AuditActions.created : AuditActions.updated,
        metadata: {'condition': conditionName.trim()},
      );
    });
    return id;
  }
}

class DietaryRuleRepository {
  DietaryRuleRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<DietaryRule>> watchForPatient(String patientId) =>
      (_db.select(_db.dietaryRules)
            ..where((d) => d.patientId.equals(patientId) & d.deletedAt.isNull())
            ..orderBy([(d) => OrderingTerm.asc(d.foodItemEn)]))
          .watch();

  Future<String> save({
    String? dietRuleId,
    required String patientId,
    required String foodItemEn,
    String? foodItemAr,
    required String ruleType,
    String? notes,
  }) async {
    if (foodItemEn.trim().isEmpty && (foodItemAr?.trim().isEmpty ?? true)) {
      throw const ValidationException('nameRequired');
    }
    final now = _clock();
    final id = dietRuleId ?? newId();
    final english =
        foodItemEn.trim().isEmpty ? foodItemAr!.trim() : foodItemEn.trim();
    final companion = DietaryRulesCompanion(
      dietRuleId: Value(id),
      patientId: Value(patientId),
      foodItemEn: Value(english),
      foodItemAr: Value(_blank(foodItemAr)),
      ruleType: Value(ruleType),
      notes: Value(_blank(notes)),
      updatedAt: Value(now),
    );
    await _db.transaction(() async {
      if (dietRuleId == null) {
        await _db
            .into(_db.dietaryRules)
            .insert(companion.copyWith(createdAt: Value(now)));
      } else {
        await (_db.update(_db.dietaryRules)
              ..where((d) => d.dietRuleId.equals(dietRuleId)))
            .write(companion);
      }
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.dietRule,
        entityId: id,
        action:
            dietRuleId == null ? AuditActions.created : AuditActions.updated,
        metadata: {'food': english, 'rule': ruleType},
      );
    });
    return id;
  }
}

/// Prescription metadata in SQLite; the image/PDF lives in app-private
/// storage and the DB stores only its relative path (spec §30).
class PrescriptionRepository {
  PrescriptionRepository(
    this._db,
    this._audit,
    this._files, {
    Clock clock = systemClock,
  }) : _clock = clock;

  static const folder = 'prescriptions';

  final AppDatabase _db;
  final AuditLog _audit;
  final AppFileStore _files;
  final Clock _clock;

  AppFileStore get files => _files;

  Stream<List<Prescription>> watchForPatient(String patientId) =>
      (_db.select(_db.prescriptions)
            ..where((p) => p.patientId.equals(patientId) & p.deletedAt.isNull())
            ..orderBy([(p) => OrderingTerm.desc(p.issueDate)]))
          .watch();

  Future<String> create({
    required String patientId,
    required String fileName,
    required Uint8List bytes,
    String? doctorName,
    String? issueDate,
    String? notes,
  }) async {
    final id = newId();
    final extension = fileName.contains('.')
        ? fileName.substring(fileName.lastIndexOf('.'))
        : '';
    final path = await _files.save(folder, '$id$extension', bytes);
    final now = _clock();
    try {
      await _db.transaction(() async {
        await _db.into(_db.prescriptions).insert(
              PrescriptionsCompanion.insert(
                prescriptionId: id,
                patientId: patientId,
                doctorName: Value(_blank(doctorName)),
                issueDate: Value(_blank(issueDate)),
                filePath: path,
                notes: Value(_blank(notes)),
                createdAt: now,
                updatedAt: now,
              ),
            );
        await _audit.record(
          patientId: patientId,
          entityType: EntityTypes.prescription,
          entityId: id,
          action: AuditActions.created,
          metadata: {'doctor': doctorName},
        );
      });
    } catch (_) {
      await _files.delete(path);
      rethrow;
    }
    return id;
  }

  Future<void> update({
    required String prescriptionId,
    String? doctorName,
    String? issueDate,
    String? notes,
  }) async {
    final row = await (_db.select(_db.prescriptions)
          ..where((p) => p.prescriptionId.equals(prescriptionId)))
        .getSingleOrNull();
    if (row == null) throw NotFoundException('prescription');
    await (_db.update(_db.prescriptions)
          ..where((p) => p.prescriptionId.equals(prescriptionId)))
        .write(PrescriptionsCompanion(
      doctorName: Value(_blank(doctorName)),
      issueDate: Value(_blank(issueDate)),
      notes: Value(_blank(notes)),
      updatedAt: Value(_clock()),
    ));
    await _audit.record(
      patientId: row.patientId,
      entityType: EntityTypes.prescription,
      entityId: prescriptionId,
      action: AuditActions.updated,
    );
  }

  /// Returns null when the file is missing on disk (edge case 34).
  Future<Uint8List?> readFile(Prescription prescription) =>
      _files.read(prescription.filePath);
}
