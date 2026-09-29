import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';

typedef DeleteStoredFile = Future<void> Function(String relativePath);

/// Trash / recovery (spec §32). Nothing is destroyed until the user explicitly
/// chooses "Permanently delete" from the trash.
class TrashRepository {
  TrashRepository(
    this._db,
    this._audit, {
    Clock clock = systemClock,
    DeleteStoredFile? deleteFile,
  })  : _clock = clock,
        _deleteFile = deleteFile;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;
  final DeleteStoredFile? _deleteFile;

  Stream<List<TrashItem>> watchActive({String? patientId}) {
    final query = _db.select(_db.trashItems)
      ..where(
        (t) => t.restoredAt.isNull() & t.permanentlyDeletedAt.isNull(),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]);
    if (patientId != null) {
      query.where(
        (t) =>
            t.patientId.equals(patientId) |
            t.entityType.equals(EntityTypes.patient),
      );
    }
    return query.watch();
  }

  Future<void> moveToTrash({
    required String entityType,
    required String entityId,
    required String? patientId,
    required String label,
  }) async {
    await _db.transaction(() async {
      final now = _clock();
      final snapshot = await _setDeletedAt(entityType, entityId, now);
      await _db.into(_db.trashItems).insert(
            TrashItemsCompanion.insert(
              trashItemId: newId(),
              patientId: Value(patientId),
              entityType: entityType,
              entityId: entityId,
              label: Value(label),
              deletedAt: now,
              snapshotJson: Value(snapshot),
            ),
          );
      await _audit.record(
        patientId: patientId,
        entityType: entityType,
        entityId: entityId,
        action: entityType == EntityTypes.inventoryBatch
            ? AuditActions.inventoryDeleted
            : AuditActions.deleted,
        metadata: {'label': label},
      );
    });
  }

  Future<void> restore(String trashItemId) async {
    await _db.transaction(() async {
      final item = await _item(trashItemId);
      await _setDeletedAt(item.entityType, item.entityId, null);
      await (_db.update(_db.trashItems)
            ..where((t) => t.trashItemId.equals(trashItemId)))
          .write(TrashItemsCompanion(restoredAt: Value(_clock())));
      await _audit.record(
        patientId: item.patientId,
        entityType: item.entityType,
        entityId: item.entityId,
        action: AuditActions.restored,
        metadata: {'label': item.label},
      );
    });
  }

  Future<void> permanentlyDelete(String trashItemId) async {
    final filesToDelete = <String>[];
    await _db.transaction(() async {
      final item = await _item(trashItemId);
      switch (item.entityType) {
        case EntityTypes.patient:
          filesToDelete.addAll(await _deletePatientData(item.entityId));
        case EntityTypes.medication:
          await _deleteMedicationData([item.entityId]);
        case EntityTypes.inventoryBatch:
          final history = await (_db.select(_db.doseInventoryConsumption)
                ..where((c) => c.inventoryBatchId.equals(item.entityId)))
              .get();
          if (history.isNotEmpty) {
            throw const ValidationException('batchHasHistory');
          }
          await (_db.delete(_db.inventoryAdjustments)
                ..where((a) => a.inventoryBatchId.equals(item.entityId)))
              .go();
          await (_db.delete(_db.medicationInventoryBatches)
                ..where((b) => b.inventoryBatchId.equals(item.entityId)))
              .go();
        case EntityTypes.appointment:
          await (_db.delete(_db.appointments)
                ..where((a) => a.appointmentId.equals(item.entityId)))
              .go();
        case EntityTypes.vital:
          await (_db.delete(_db.vitalsMeasurements)
                ..where((v) => v.measurementId.equals(item.entityId)))
              .go();
        case EntityTypes.illness:
          await (_db.delete(_db.patientIllnesses)
                ..where((i) => i.illnessId.equals(item.entityId)))
              .go();
        case EntityTypes.dietRule:
          await (_db.delete(_db.dietaryRules)
                ..where((d) => d.dietRuleId.equals(item.entityId)))
              .go();
        case EntityTypes.meal:
          await (_db.delete(_db.meals)
                ..where((m) => m.mealId.equals(item.entityId)))
              .go();
        case EntityTypes.prescription:
          final row = await (_db.select(_db.prescriptions)
                ..where((p) => p.prescriptionId.equals(item.entityId)))
              .getSingleOrNull();
          if (row != null) filesToDelete.add(row.filePath);
          await (_db.delete(_db.prescriptions)
                ..where((p) => p.prescriptionId.equals(item.entityId)))
              .go();
      }
      await (_db.update(_db.trashItems)
            ..where((t) => t.trashItemId.equals(trashItemId)))
          .write(TrashItemsCompanion(
        permanentlyDeletedAt: Value(_clock()),
        snapshotJson: const Value(null),
      ));
      await _audit.record(
        patientId:
            item.entityType == EntityTypes.patient ? null : item.patientId,
        entityType: item.entityType,
        entityId: item.entityId,
        action: AuditActions.permanentlyDeleted,
        metadata: {'label': item.label},
      );
    });
    final deleteFile = _deleteFile;
    if (deleteFile != null) {
      for (final path in filesToDelete) {
        try {
          await deleteFile(path);
        } catch (_) {
          // A missing file must not block deletion (edge case 34).
        }
      }
    }
  }

  Future<TrashItem> _item(String id) async {
    final item = await (_db.select(_db.trashItems)
          ..where((t) => t.trashItemId.equals(id)))
        .getSingleOrNull();
    if (item == null) throw NotFoundException('trash_item');
    return item;
  }

  /// Sets or clears `deleted_at` and returns a JSON snapshot of the row.
  Future<String?> _setDeletedAt(
    String entityType,
    String entityId,
    DateTime? value,
  ) async {
    final now = _clock();
    switch (entityType) {
      case EntityTypes.patient:
        final q = _db.update(_db.patients)
          ..where((t) => t.patientId.equals(entityId));
        await q.write(PatientsCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
        final row = await (_db.select(_db.patients)
              ..where((t) => t.patientId.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : jsonEncode(row.toJson());
      case EntityTypes.medication:
        await (_db.update(_db.medications)
              ..where((t) => t.medicationId.equals(entityId)))
            .write(MedicationsCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
        final row = await (_db.select(_db.medications)
              ..where((t) => t.medicationId.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : jsonEncode(row.toJson());
      case EntityTypes.inventoryBatch:
        await (_db.update(_db.medicationInventoryBatches)
              ..where((t) => t.inventoryBatchId.equals(entityId)))
            .write(MedicationInventoryBatchesCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
        final row = await (_db.select(_db.medicationInventoryBatches)
              ..where((t) => t.inventoryBatchId.equals(entityId)))
            .getSingleOrNull();
        return row == null ? null : jsonEncode(row.toJson());
      case EntityTypes.appointment:
        await (_db.update(_db.appointments)
              ..where((t) => t.appointmentId.equals(entityId)))
            .write(AppointmentsCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
      case EntityTypes.vital:
        await (_db.update(_db.vitalsMeasurements)
              ..where((t) => t.measurementId.equals(entityId)))
            .write(VitalsMeasurementsCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
      case EntityTypes.illness:
        await (_db.update(_db.patientIllnesses)
              ..where((t) => t.illnessId.equals(entityId)))
            .write(PatientIllnessesCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
      case EntityTypes.dietRule:
        await (_db.update(_db.dietaryRules)
              ..where((t) => t.dietRuleId.equals(entityId)))
            .write(DietaryRulesCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
      case EntityTypes.prescription:
        await (_db.update(_db.prescriptions)
              ..where((t) => t.prescriptionId.equals(entityId)))
            .write(PrescriptionsCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
      case EntityTypes.meal:
        await (_db.update(_db.meals)..where((t) => t.mealId.equals(entityId)))
            .write(MealsCompanion(
          deletedAt: Value(value),
          updatedAt: Value(now),
        ));
      default:
        throw ValidationException('unsupportedTrashEntity', {
          'entityType': entityType,
        });
    }
    return null;
  }

  Future<void> _deleteMedicationData(List<String> medicationIds) async {
    if (medicationIds.isEmpty) return;
    final doseIds = await (_db.selectOnly(_db.doseInstances)
          ..addColumns([_db.doseInstances.doseInstanceId])
          ..where(_db.doseInstances.medicationId.isIn(medicationIds)))
        .map((r) => r.read(_db.doseInstances.doseInstanceId)!)
        .get();
    final batchIds = await (_db.selectOnly(_db.medicationInventoryBatches)
          ..addColumns([_db.medicationInventoryBatches.inventoryBatchId])
          ..where(
            _db.medicationInventoryBatches.medicationId.isIn(medicationIds),
          ))
        .map((r) => r.read(_db.medicationInventoryBatches.inventoryBatchId)!)
        .get();
    if (doseIds.isNotEmpty) {
      await (_db.delete(_db.doseInventoryConsumption)
            ..where((c) => c.doseInstanceId.isIn(doseIds)))
          .go();
      await (_db.delete(_db.notifications)
            ..where((n) => n.doseInstanceId.isIn(doseIds)))
          .go();
    }
    if (batchIds.isNotEmpty) {
      await (_db.delete(_db.doseInventoryConsumption)
            ..where((c) => c.inventoryBatchId.isIn(batchIds)))
          .go();
    }
    await (_db.delete(_db.notifications)
          ..where((n) => n.medicationId.isIn(medicationIds)))
        .go();
    await (_db.delete(_db.doseInstances)
          ..where((d) => d.medicationId.isIn(medicationIds)))
        .go();
    await (_db.delete(_db.inventoryAdjustments)
          ..where((a) => a.medicationId.isIn(medicationIds)))
        .go();
    await (_db.delete(_db.medicationInventoryBatches)
          ..where((b) => b.medicationId.isIn(medicationIds)))
        .go();
    await (_db.delete(_db.medicationSchedules)
          ..where((s) => s.medicationId.isIn(medicationIds)))
        .go();
    await (_db.delete(_db.medications)
          ..where((m) => m.medicationId.isIn(medicationIds)))
        .go();
  }

  /// Removes all data belonging to a patient. Returns stored file paths that
  /// should be removed from disk after the transaction commits.
  Future<List<String>> _deletePatientData(String patientId) async {
    final medicationIds = await (_db.selectOnly(_db.medications)
          ..addColumns([_db.medications.medicationId])
          ..where(_db.medications.patientId.equals(patientId)))
        .map((r) => r.read(_db.medications.medicationId)!)
        .get();
    await _deleteMedicationData(medicationIds);
    final files = await (_db.select(_db.prescriptions)
          ..where((p) => p.patientId.equals(patientId)))
        .map((p) => p.filePath)
        .get();
    await (_db.delete(_db.doseInstances)
          ..where((d) => d.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.prescriptions)
          ..where((p) => p.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.appointments)
          ..where((a) => a.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.vitalsMeasurements)
          ..where((v) => v.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.patientIllnesses)
          ..where((i) => i.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.dietaryRules)
          ..where((d) => d.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.meals)..where((m) => m.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.notifications)
          ..where((n) => n.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.patientNotificationPreferences)
          ..where((p) => p.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.caregiverAssignments)
          ..where((c) => c.patientId.equals(patientId)))
        .go();
    await (_db.delete(_db.auditEvents)
          ..where((a) => a.patientId.equals(patientId)))
        .go();
    await (_db.update(_db.trashItems)
          ..where(
            (t) =>
                t.patientId.equals(patientId) &
                t.permanentlyDeletedAt.isNull(),
          ))
        .write(TrashItemsCompanion(
      permanentlyDeletedAt: Value(_clock()),
      snapshotJson: const Value(null),
    ));
    await (_db.delete(_db.patients)
          ..where((p) => p.patientId.equals(patientId)))
        .go();
    // The person row is only soft-deleted: it may still be a caregiver, the
    // device user, or the actor of historical actions for other patients.
    final stillCaregiver = await (_db.select(_db.caregiverAssignments)
          ..where(
            (c) => c.caregiverPersonId.equals(patientId) & c.removedAt.isNull(),
          ))
        .get();
    final device = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals('device_person_id')))
        .getSingleOrNull();
    if (stillCaregiver.isEmpty && device?.value != patientId) {
      await (_db.update(_db.persons)
            ..where((p) => p.personId.equals(patientId)))
          .write(PersonsCompanion(deletedAt: Value(_clock())));
    }
    return files;
  }
}
