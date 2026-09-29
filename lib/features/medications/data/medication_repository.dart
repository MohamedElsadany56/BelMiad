import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';

abstract final class MedicationStatus {
  static const active = 'active';
  static const archived = 'archived';
}

class MedicationInput {
  const MedicationInput({
    required this.nameEn,
    required this.doseUnit,
    this.nameAr,
    this.catalogId,
    this.catalogPriceEgp,
    this.scientificName,
    this.strength,
    this.dosageForm,
    this.route,
    this.instructionsEn,
    this.instructionsAr,
    this.startDate,
    this.endDate,
    this.isPrn = false,
    this.maximumDailyQuantityScaled,
  });

  final String nameEn;
  final String? nameAr;
  final String? catalogId;
  final double? catalogPriceEgp;
  final String? scientificName;
  final String? strength;
  final String? dosageForm;
  final String? route;
  final String doseUnit;
  final String? instructionsEn;
  final String? instructionsAr;
  final String? startDate;
  final String? endDate;
  final bool isPrn;
  final int? maximumDailyQuantityScaled;
}

class MedicationRepository {
  MedicationRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<Medication>> watchForPatient(
    String patientId, {
    bool includeArchived = true,
  }) {
    final query = _db.select(_db.medications)
      ..where((m) => m.patientId.equals(patientId) & m.deletedAt.isNull())
      ..orderBy([(m) => OrderingTerm.asc(m.nameEn)]);
    if (!includeArchived) {
      query.where((m) => m.status.equals(MedicationStatus.active));
    }
    return query.watch();
  }

  Future<List<Medication>> listForPatient(
    String patientId, {
    bool includeArchived = true,
  }) {
    final query = _db.select(_db.medications)
      ..where((m) => m.patientId.equals(patientId) & m.deletedAt.isNull())
      ..orderBy([(m) => OrderingTerm.asc(m.nameEn)]);
    if (!includeArchived) {
      query.where((m) => m.status.equals(MedicationStatus.active));
    }
    return query.get();
  }

  Future<Medication?> get(String medicationId) => (_db.select(_db.medications)
        ..where((m) => m.medicationId.equals(medicationId)))
      .getSingleOrNull();

  Stream<Medication?> watch(String medicationId) => (_db.select(_db.medications)
        ..where((m) => m.medicationId.equals(medicationId)))
      .watchSingleOrNull();

  Future<String> create(String patientId, MedicationInput input) async {
    _validate(input);
    final now = _clock();
    final id = newId();
    await _db.transaction(() async {
      await _db.into(_db.medications).insert(
            MedicationsCompanion.insert(
              medicationId: id,
              patientId: patientId,
              catalogId: Value(input.catalogId),
              nameEn: input.nameEn.trim(),
              nameAr: Value(_blank(input.nameAr)),
              scientificName: Value(_blank(input.scientificName)),
              strength: Value(_blank(input.strength)),
              dosageForm: Value(_blank(input.dosageForm)),
              route: Value(_blank(input.route)),
              doseUnit: input.doseUnit,
              instructionsEn: Value(_blank(input.instructionsEn)),
              instructionsAr: Value(_blank(input.instructionsAr)),
              startDate: Value(_blank(input.startDate)),
              endDate: Value(_blank(input.endDate)),
              isPrn: Value(input.isPrn),
              maximumDailyQuantityScaled:
                  Value(input.maximumDailyQuantityScaled),
              catalogPriceEgp: Value(input.catalogPriceEgp),
              status: MedicationStatus.active,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.medication,
        entityId: id,
        action: AuditActions.created,
        metadata: {'name': input.nameEn.trim(), 'catalog_id': input.catalogId},
      );
    });
    return id;
  }

  Future<void> update(String medicationId, MedicationInput input) async {
    _validate(input);
    await _db.transaction(() async {
      final current = await get(medicationId);
      if (current == null) throw NotFoundException('medication');
      await (_db.update(_db.medications)
            ..where((m) => m.medicationId.equals(medicationId)))
          .write(MedicationsCompanion(
        catalogId: Value(input.catalogId),
        nameEn: Value(input.nameEn.trim()),
        nameAr: Value(_blank(input.nameAr)),
        scientificName: Value(_blank(input.scientificName)),
        strength: Value(_blank(input.strength)),
        dosageForm: Value(_blank(input.dosageForm)),
        route: Value(_blank(input.route)),
        doseUnit: Value(input.doseUnit),
        instructionsEn: Value(_blank(input.instructionsEn)),
        instructionsAr: Value(_blank(input.instructionsAr)),
        startDate: Value(_blank(input.startDate)),
        endDate: Value(_blank(input.endDate)),
        isPrn: Value(input.isPrn),
        maximumDailyQuantityScaled: Value(input.maximumDailyQuantityScaled),
        catalogPriceEgp: Value(input.catalogPriceEgp),
        updatedAt: Value(_clock()),
      ));
      await _audit.record(
        patientId: current.patientId,
        entityType: EntityTypes.medication,
        entityId: medicationId,
        action: AuditActions.updated,
        metadata: {'name': input.nameEn.trim()},
      );
    });
  }

  Future<void> setArchived(String medicationId, bool archived) async {
    await _db.transaction(() async {
      final current = await get(medicationId);
      if (current == null) throw NotFoundException('medication');
      await (_db.update(_db.medications)
            ..where((m) => m.medicationId.equals(medicationId)))
          .write(MedicationsCompanion(
        status: Value(
          archived ? MedicationStatus.archived : MedicationStatus.active,
        ),
        updatedAt: Value(_clock()),
      ));
      await _audit.record(
        patientId: current.patientId,
        entityType: EntityTypes.medication,
        entityId: medicationId,
        action: archived ? AuditActions.archived : AuditActions.unarchived,
      );
    });
  }

  void _validate(MedicationInput input) {
    if (input.nameEn.trim().isEmpty) {
      throw const ValidationException('nameRequired');
    }
    if (input.doseUnit.trim().isEmpty) {
      throw const ValidationException('doseUnitRequired');
    }
    final start = LocalDate.tryParse(input.startDate);
    final end = LocalDate.tryParse(input.endDate);
    if (start != null && end != null && end.isBefore(start)) {
      throw const ValidationException('endBeforeStart');
    }
    final maximum = input.maximumDailyQuantityScaled;
    if (maximum != null && maximum <= 0) {
      throw const ValidationException('invalidMaximum');
    }
  }
}

String? _blank(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

/// Display name for the current language, falling back to English.
String medicationDisplayName(Medication medication, {required bool arabic}) {
  final base = arabic && (medication.nameAr?.isNotEmpty ?? false)
      ? medication.nameAr!
      : medication.nameEn;
  final strength = medication.strength;
  return strength == null || strength.isEmpty ? base : '$base $strength';
}
