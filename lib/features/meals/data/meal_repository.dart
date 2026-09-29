import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';
import '../domain/meal_timing.dart';

class MealRepository {
  MealRepository(this._db, this._audit, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final Clock _clock;

  Stream<List<Meal>> watchForPatient(String patientId) => (_db.select(_db.meals)
        ..where((m) => m.patientId.equals(patientId) & m.deletedAt.isNull())
        ..orderBy([(m) => OrderingTerm.asc(m.defaultTime)]))
      .watch();

  Future<List<Meal>> listForPatient(String patientId) => (_db.select(_db.meals)
        ..where((m) => m.patientId.equals(patientId) & m.deletedAt.isNull())
        ..orderBy([(m) => OrderingTerm.asc(m.defaultTime)]))
      .get();

  Future<String> create({
    required String patientId,
    required String nameEn,
    required String nameAr,
    required String mealType,
    String? time,
    String timeMode = MealTimeModes.daily,
    String? weekdayTimes,
  }) async {
    _validate(nameEn, nameAr, time);
    final now = _clock();
    final id = newId();
    await _db.into(_db.meals).insert(
          MealsCompanion.insert(
            mealId: id,
            patientId: patientId,
            nameEn: nameEn.trim(),
            nameAr: nameAr.trim(),
            mealType: mealType,
            defaultTime: Value(time),
            timeMode: Value(timeMode),
            weekdayTimes: Value(weekdayTimes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _audit.record(
      patientId: patientId,
      entityType: EntityTypes.meal,
      entityId: id,
      action: AuditActions.created,
      metadata: {'name': nameEn.trim(), 'time': time},
    );
    return id;
  }

  /// Returns true when the meal time changed, in which case meal-relative
  /// doses must be regenerated (spec §11).
  Future<bool> update({
    required String mealId,
    required String nameEn,
    required String nameAr,
    required String mealType,
    String? time,
    String timeMode = MealTimeModes.daily,
    String? weekdayTimes,
    bool isActive = true,
  }) async {
    _validate(nameEn, nameAr, time);
    final current = await (_db.select(_db.meals)
          ..where((m) => m.mealId.equals(mealId)))
        .getSingleOrNull();
    if (current == null) throw NotFoundException('meal');
    await (_db.update(_db.meals)..where((m) => m.mealId.equals(mealId)))
        .write(MealsCompanion(
      nameEn: Value(nameEn.trim()),
      nameAr: Value(nameAr.trim()),
      mealType: Value(mealType),
      defaultTime: Value(time),
      timeMode: Value(timeMode),
      weekdayTimes: Value(weekdayTimes),
      isActive: Value(isActive),
      updatedAt: Value(_clock()),
    ));
    await _audit.record(
      patientId: current.patientId,
      entityType: EntityTypes.meal,
      entityId: mealId,
      action: AuditActions.updated,
      metadata: {
        'name': nameEn.trim(),
        'time': time,
        'time_mode': timeMode,
        'weekday_times': weekdayTimes,
      },
    );
    return current.defaultTime != time ||
        current.mealType != mealType ||
        current.timeMode != timeMode ||
        current.weekdayTimes != weekdayTimes;
  }

  Future<bool> isInUse(String mealId) async {
    final rows = await (_db.select(_db.medicationSchedules)
          ..where((s) => s.mealId.equals(mealId) & s.deletedAt.isNull()))
        .get();
    return rows.isNotEmpty;
  }

  void _validate(String nameEn, String nameAr, String? time) {
    if (nameEn.trim().isEmpty && nameAr.trim().isEmpty) {
      throw const ValidationException('nameRequired');
    }
    if (time != null && LocalTime.tryParse(time) == null) {
      throw const ValidationException('invalidTime');
    }
  }
}
