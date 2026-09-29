import 'package:drift/drift.dart';

import 'dart:convert';

import '../../../core/database/app_database.dart';
import '../../../core/session/session_context.dart';
import '../../../core/time/clock.dart';
import '../../../core/utilities/ids.dart';

abstract final class AuditActions {
  static const created = 'created';
  static const updated = 'updated';
  static const deleted = 'deleted';
  static const restored = 'restored';
  static const permanentlyDeleted = 'permanently_deleted';
  static const archived = 'archived';
  static const unarchived = 'unarchived';
  static const inventoryAdded = 'inventory_added';
  static const inventoryEdited = 'inventory_edited';
  static const inventoryAdjusted = 'inventory_adjusted';
  static const inventoryDeleted = 'inventory_deleted';
  static const doseTaken = 'dose_taken';
  static const doseUndone = 'dose_undone';
  static const doseSkipped = 'dose_skipped';
  static const doseMissed = 'dose_missed';
  static const prnLogged = 'prn_logged';
  static const batchManuallySelected = 'batch_manually_selected';
  static const maximumOverridden = 'maximum_daily_overridden';
  static const caregiverAssigned = 'caregiver_assigned';
  static const caregiverRemoved = 'caregiver_removed';
  static const imported = 'imported';
  static const merged = 'merged';
}

abstract final class EntityTypes {
  static const person = 'person';
  static const patient = 'patient';
  static const caregiverAssignment = 'caregiver_assignment';
  static const medication = 'medication';
  static const schedule = 'medication_schedule';
  static const inventoryBatch = 'inventory_batch';
  static const dose = 'dose_instance';
  static const meal = 'meal';
  static const appointment = 'appointment';
  static const vital = 'vital_measurement';
  static const illness = 'illness';
  static const dietRule = 'dietary_rule';
  static const prescription = 'prescription';
}

/// Append-only audit history (spec §33). The actor is stored by person ID so
/// it survives removal of a caregiver relationship.
class AuditLog {
  AuditLog(this._db, this._session, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final SessionContext _session;
  final Clock _clock;

  Future<void> record({
    required String? patientId,
    required String entityType,
    required String entityId,
    required String action,
    Map<String, Object?>? metadata,
    String? actorPersonId,
    bool systemAction = false,
  }) async {
    await _db.into(_db.auditEvents).insert(
          AuditEventsCompanion.insert(
            auditEventId: newId(),
            patientId: Value(patientId),
            actorPersonId: Value(
              systemAction ? null : actorPersonId ?? _session.actorPersonId,
            ),
            entityType: entityType,
            entityId: entityId,
            action: action,
            occurredAt: _clock(),
            metadataJson: Value(metadata == null ? null : jsonEncode(metadata)),
          ),
        );
  }

  Stream<List<AuditEvent>> watchForPatient(String patientId,
          {int limit = 300}) =>
      (_db.select(_db.auditEvents)
            ..where((a) => a.patientId.equals(patientId))
            ..orderBy([(a) => OrderingTerm.desc(a.occurredAt)])
            ..limit(limit))
          .watch();
}
