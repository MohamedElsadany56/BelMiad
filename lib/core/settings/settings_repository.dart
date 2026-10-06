import 'package:drift/drift.dart';

import '../database/app_database.dart';

abstract final class SettingKeys {
  static const devicePersonId = 'device_person_id';
  static const currentPatientId = 'current_patient_id';
  static const expiringWithinDays = 'expiring_within_days';
  static const missedGraceMinutes = 'missed_grace_minutes';
  static const inactivityMinutes = 'inactivity_minutes';
  static const reminderLeadMinutes = 'reminder_lead_minutes';
  static const doseCompletionMode = 'dose_completion_mode';
  static const notificationGrouping = 'notification_grouping';
}

/// Whether related doses/notifications are handled together or one by one.
///
/// Used by both "dose completion" and "notification grouping" settings. What
/// counts as *related* is decided in one place:
/// `features/doses/domain/dose_grouping.dart`.
enum GroupingMode {
  combined('combined'),
  separate('separate');

  const GroupingMode(this.code);

  final String code;

  bool get isCombined => this == combined;

  static GroupingMode fromCode(String? code, {GroupingMode? fallback}) =>
      GroupingMode.values.firstWhere(
        (m) => m.code == code,
        orElse: () => fallback ?? GroupingMode.combined,
      );
}

/// Device-level settings persisted in the patient database.
class AppSettingsData {
  const AppSettingsData({
    this.devicePersonId,
    this.currentPatientId,
    this.expiringWithinDays = 30,
    this.missedGraceMinutes = 180,
    this.inactivityMinutes = 10,
    this.doseCompletionMode = GroupingMode.combined,
    this.notificationGrouping = GroupingMode.combined,
  });

  final String? devicePersonId;
  final String? currentPatientId;

  /// Expiration warning threshold (spec §24, default 30 days).
  final int expiringWithinDays;

  /// A scheduled dose becomes MISSED once this grace window has passed.
  final int missedGraceMinutes;

  /// Inactivity reset (0 disables). Not a security lock (spec §3).
  final int inactivityMinutes;

  /// Combined: taking one dose also completes the other doses of its group.
  final GroupingMode doseCompletionMode;

  /// Combined: one notification per dose group instead of one per medication.
  final GroupingMode notificationGrouping;
}

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> get(String key) async {
    final row = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String? value) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(AppSettingsCompanion.insert(
        key: key,
        value: Value(value),
      ));

  Stream<AppSettingsData> watch() =>
      _db.select(_db.appSettings).watch().map(_fromRows);

  Future<AppSettingsData> load() async =>
      _fromRows(await _db.select(_db.appSettings).get());

  AppSettingsData _fromRows(List<AppSetting> rows) {
    final map = {for (final r in rows) r.key: r.value};
    int intOf(String key, int fallback) =>
        int.tryParse(map[key] ?? '') ?? fallback;
    return AppSettingsData(
      devicePersonId: map[SettingKeys.devicePersonId],
      currentPatientId: map[SettingKeys.currentPatientId],
      expiringWithinDays: intOf(SettingKeys.expiringWithinDays, 30),
      missedGraceMinutes: intOf(SettingKeys.missedGraceMinutes, 180),
      inactivityMinutes: intOf(SettingKeys.inactivityMinutes, 10),
      doseCompletionMode:
          GroupingMode.fromCode(map[SettingKeys.doseCompletionMode]),
      notificationGrouping:
          GroupingMode.fromCode(map[SettingKeys.notificationGrouping]),
    );
  }
}
