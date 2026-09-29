import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/settings/settings_repository.dart';
import '../../../core/time/clock.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';

class CaregiverLink {
  const CaregiverLink({required this.assignment, required this.person});

  final CaregiverAssignment assignment;
  final Person person;
}

/// Persons, device caregiver identity and caregiver assignments.
class CaregiverRepository {
  CaregiverRepository(
    this._db,
    this._settings,
    this._audit, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final AppDatabase _db;
  final SettingsRepository _settings;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<Person>> watchPersons() => (_db.select(_db.persons)
        ..where((p) => p.deletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.asc(p.fullName)]))
      .watch();

  Future<Person?> getPerson(String personId) =>
      (_db.select(_db.persons)..where((p) => p.personId.equals(personId)))
          .getSingleOrNull();

  /// All persons ever recorded, including removed ones, so historical actors
  /// can always be displayed.
  Stream<Map<String, String>> watchPersonNames() => _db
      .select(_db.persons)
      .watch()
      .map((rows) => {for (final p in rows) p.personId: p.fullName});

  Future<String> createPerson({
    required String fullName,
    String? phone,
    String? email,
    String? preferredLanguage,
  }) async {
    if (fullName.trim().isEmpty) {
      throw const ValidationException('nameRequired');
    }
    final now = _clock();
    final id = newId();
    await _db.into(_db.persons).insert(
          PersonsCompanion.insert(
            personId: id,
            fullName: fullName.trim(),
            phone: Value(_blank(phone)),
            email: Value(_blank(email)),
            preferredLanguage: Value(preferredLanguage),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _audit.record(
      patientId: null,
      entityType: EntityTypes.person,
      entityId: id,
      action: AuditActions.created,
      metadata: {'name': fullName.trim()},
    );
    return id;
  }

  Future<void> updatePerson({
    required String personId,
    required String fullName,
    String? phone,
    String? email,
  }) async {
    if (fullName.trim().isEmpty) {
      throw const ValidationException('nameRequired');
    }
    await (_db.update(_db.persons)..where((p) => p.personId.equals(personId)))
        .write(PersonsCompanion(
      fullName: Value(fullName.trim()),
      phone: Value(_blank(phone)),
      email: Value(_blank(email)),
      updatedAt: Value(_clock()),
    ));
    await _audit.record(
      patientId: null,
      entityType: EntityTypes.person,
      entityId: personId,
      action: AuditActions.updated,
    );
  }

  /// Selects which person is using this phone (attribution only).
  Future<void> setDeviceCaregiver(String personId) =>
      _settings.set(SettingKeys.devicePersonId, personId);

  Stream<List<CaregiverLink>> watchAssignments(
    String patientId, {
    bool includeRemoved = false,
  }) {
    final query = _db.select(_db.caregiverAssignments).join([
      innerJoin(
        _db.persons,
        _db.persons.personId
            .equalsExp(_db.caregiverAssignments.caregiverPersonId),
      ),
    ])
      ..where(_db.caregiverAssignments.patientId.equals(patientId));
    if (!includeRemoved) {
      query.where(_db.caregiverAssignments.removedAt.isNull());
    }
    query.orderBy([OrderingTerm.asc(_db.persons.fullName)]);
    return query.watch().map(
          (rows) => rows
              .map(
                (r) => CaregiverLink(
                  assignment: r.readTable(_db.caregiverAssignments),
                  person: r.readTable(_db.persons),
                ),
              )
              .toList(),
        );
  }

  Future<void> assign({
    required String patientId,
    required String caregiverPersonId,
    String? relationship,
  }) async {
    final existing = await (_db.select(_db.caregiverAssignments)
          ..where(
            (c) =>
                c.patientId.equals(patientId) &
                c.caregiverPersonId.equals(caregiverPersonId) &
                c.removedAt.isNull(),
          ))
        .getSingleOrNull();
    if (existing != null) return;
    final now = _clock();
    final id = newId();
    await _db.transaction(() async {
      await _db.into(_db.caregiverAssignments).insert(
            CaregiverAssignmentsCompanion.insert(
              assignmentId: id,
              patientId: patientId,
              caregiverPersonId: caregiverPersonId,
              relationship: Value(_blank(relationship)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.caregiverAssignment,
        entityId: id,
        action: AuditActions.caregiverAssigned,
        metadata: {'caregiver_person_id': caregiverPersonId},
      );
    });
  }

  /// Ends a relationship. The person row and every historical action they
  /// performed are preserved (spec §2, edge cases 32–33).
  Future<void> removeAssignment(String assignmentId) async {
    await _db.transaction(() async {
      final row = await (_db.select(_db.caregiverAssignments)
            ..where((c) => c.assignmentId.equals(assignmentId)))
          .getSingleOrNull();
      if (row == null) return;
      final now = _clock();
      await (_db.update(_db.caregiverAssignments)
            ..where((c) => c.assignmentId.equals(assignmentId)))
          .write(CaregiverAssignmentsCompanion(
        removedAt: Value(now),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: row.patientId,
        entityType: EntityTypes.caregiverAssignment,
        entityId: assignmentId,
        action: AuditActions.caregiverRemoved,
        metadata: {'caregiver_person_id': row.caregiverPersonId},
      );
    });
  }
}

String? _blank(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
