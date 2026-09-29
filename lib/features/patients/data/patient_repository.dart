import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';
import '../../meals/domain/meal_timing.dart';
import '../../notifications/domain/notification_types.dart';
import '../domain/patient_profile.dart';

class PatientInput {
  const PatientInput({
    required this.fullName,
    this.phone,
    this.email,
    this.dateOfBirth,
    this.sex,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.notes,
    this.timezone = defaultTimezone,
  });

  final String fullName;
  final String? phone;
  final String? email;
  final String? dateOfBirth;
  final String? sex;
  final String? bloodType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? notes;
  final String timezone;
}

class PatientRepository {
  PatientRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  JoinedSelectStatement<HasResultSet, dynamic> _joined() =>
      _db.select(_db.patients).join([
        innerJoin(
          _db.persons,
          _db.persons.personId.equalsExp(_db.patients.patientId),
        ),
      ]);

  PatientProfile _map(TypedResult row) => PatientProfile(
        person: row.readTable(_db.persons),
        patient: row.readTable(_db.patients),
      );

  Stream<List<PatientProfile>> watchActive() {
    final query = _joined()
      ..where(_db.patients.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.persons.fullName)]);
    return query.watch().map((rows) => rows.map(_map).toList());
  }

  Future<List<PatientProfile>> listActive() async {
    final query = _joined()
      ..where(_db.patients.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.persons.fullName)]);
    return (await query.get()).map(_map).toList();
  }

  Future<PatientProfile?> get(String patientId) async {
    final query = _joined()..where(_db.patients.patientId.equals(patientId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Stream<PatientProfile?> watch(String patientId) {
    final query = _joined()..where(_db.patients.patientId.equals(patientId));
    return query.watchSingleOrNull().map((r) => r == null ? null : _map(r));
  }

  /// Creates a patient profile. When [existingPersonId] is given (e.g. the
  /// device caregiver is also a patient) that person record is reused.
  Future<String> create(
    PatientInput input, {
    String? existingPersonId,
    String? caregiverPersonId,
    String? relationship,
  }) async {
    _validate(input);
    final now = _clock();
    final patientId = existingPersonId ?? newId();
    await _db.transaction(() async {
      if (existingPersonId == null) {
        await _db.into(_db.persons).insert(
              PersonsCompanion.insert(
                personId: patientId,
                fullName: input.fullName.trim(),
                phone: Value(_blank(input.phone)),
                email: Value(_blank(input.email)),
                createdAt: now,
                updatedAt: now,
              ),
            );
      } else {
        final existing = await (_db.select(_db.patients)
              ..where((p) => p.patientId.equals(existingPersonId)))
            .getSingleOrNull();
        if (existing != null) {
          throw const ValidationException('patientAlreadyExists');
        }
        await (_db.update(_db.persons)
              ..where((p) => p.personId.equals(existingPersonId)))
            .write(PersonsCompanion(
          fullName: Value(input.fullName.trim()),
          updatedAt: Value(now),
        ));
      }
      await _db.into(_db.patients).insert(
            PatientsCompanion.insert(
              patientId: patientId,
              dateOfBirth: Value(_blank(input.dateOfBirth)),
              sex: Value(_blank(input.sex)),
              bloodType: Value(_blank(input.bloodType)),
              emergencyContactName: Value(_blank(input.emergencyContactName)),
              emergencyContactPhone:
                  Value(_blank(input.emergencyContactPhone)),
              notes: Value(_blank(input.notes)),
              timezone: input.timezone,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _createDefaultMeals(patientId, now);
      for (final type in NotificationTypes.all) {
        await _db.into(_db.patientNotificationPreferences).insert(
              PatientNotificationPreferencesCompanion.insert(
                preferenceId: newId(),
                patientId: patientId,
                notificationType: type,
                enabled: true,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      if (caregiverPersonId != null) {
        await _db.into(_db.caregiverAssignments).insert(
              CaregiverAssignmentsCompanion.insert(
                assignmentId: newId(),
                patientId: patientId,
                caregiverPersonId: caregiverPersonId,
                relationship: Value(
                  caregiverPersonId == patientId
                      ? 'self'
                      : _blank(relationship),
                ),
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.patient,
        entityId: patientId,
        action: AuditActions.created,
        metadata: {'name': input.fullName.trim()},
      );
    });
    return patientId;
  }

  /// Updates the profile. Returns true when the timezone changed, in which
  /// case future doses must be regenerated at the same wall-clock times.
  Future<bool> update(String patientId, PatientInput input) async {
    _validate(input);
    final now = _clock();
    var timezoneChanged = false;
    await _db.transaction(() async {
      final current = await get(patientId);
      if (current == null) throw NotFoundException('patient');
      timezoneChanged = current.patient.timezone != input.timezone;
      await (_db.update(_db.persons)
            ..where((p) => p.personId.equals(patientId)))
          .write(PersonsCompanion(
        fullName: Value(input.fullName.trim()),
        phone: Value(_blank(input.phone)),
        email: Value(_blank(input.email)),
        updatedAt: Value(now),
      ));
      await (_db.update(_db.patients)
            ..where((p) => p.patientId.equals(patientId)))
          .write(PatientsCompanion(
        dateOfBirth: Value(_blank(input.dateOfBirth)),
        sex: Value(_blank(input.sex)),
        bloodType: Value(_blank(input.bloodType)),
        emergencyContactName: Value(_blank(input.emergencyContactName)),
        emergencyContactPhone: Value(_blank(input.emergencyContactPhone)),
        notes: Value(_blank(input.notes)),
        timezone: Value(input.timezone),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.patient,
        entityId: patientId,
        action: AuditActions.updated,
        metadata: {
          'name': input.fullName.trim(),
          if (timezoneChanged) 'timezone': input.timezone,
        },
      );
    });
    return timezoneChanged;
  }

  Future<void> _createDefaultMeals(String patientId, DateTime now) async {
    const defaults = [
      ('Breakfast', 'الإفطار', MealType.breakfast),
      ('Lunch', 'الغداء', MealType.lunch),
      ('Dinner', 'العشاء', MealType.dinner),
      ('Snack', 'وجبة خفيفة', MealType.snack),
    ];
    for (final meal in defaults) {
      await _db.into(_db.meals).insert(
            MealsCompanion.insert(
              mealId: newId(),
              patientId: patientId,
              nameEn: meal.$1,
              nameAr: meal.$2,
              mealType: meal.$3.name,
              defaultTime: Value(defaultMealTime(meal.$3).toHHmm()),
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
  }

  void _validate(PatientInput input) {
    if (input.fullName.trim().isEmpty) {
      throw const ValidationException('nameRequired');
    }
    if (!PatientTime.isValidTimezone(input.timezone)) {
      throw const ValidationException('invalidTimezone');
    }
  }
}

String? _blank(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
