import 'dart:convert';
import 'dart:ui' show DartPluginRegistrant;

import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/notifications/local_notifier.dart';
import '../../../core/notifications/reminder_sound.dart';
import '../../../core/session/session_context.dart';
import '../../../core/settings/settings_repository.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/patient_time.dart';
import '../../audit/data/audit_log.dart';
import '../../doses/application/dose_service.dart';
import '../../doses/domain/dose_status.dart';
import '../../inventory/application/inventory_service.dart';
import '../../inventory/data/inventory_repository.dart';
import '../domain/notification_types.dart';

/// Buttons shown on dose reminders.
abstract final class NotificationActionIds {
  static const take = 'take';
  static const snooze = 'snooze';
}

const snoozeDuration = Duration(minutes: 10);

/// Small JSON payload attached to notifications.
class NotificationPayload {
  const NotificationPayload({
    required this.kind,
    this.doseId,
    this.patientId,
    this.group,
  });

  static const dose = 'dose';
  static const open = 'open';

  static NotificationPayload? decode(String? source) {
    if (source == null || source.isEmpty) return null;
    try {
      final json = jsonDecode(source) as Map<String, dynamic>;
      return NotificationPayload(
        kind: json['kind'] as String? ?? open,
        doseId: json['dose'] as String?,
        patientId: json['patient'] as String?,
        group: json['group'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  final String kind;
  final String? doseId;
  final String? patientId;

  /// Dose-group key when the notification covers several medications.
  final String? group;

  String encode() => jsonEncode({
        'kind': kind,
        if (doseId != null) 'dose': doseId,
        if (patientId != null) 'patient': patientId,
        if (group != null) 'group': group,
      });
}

/// Button labels for dose reminders in the app language.
List<NotifierAction> doseReminderActions({
  required bool arabic,
  bool group = false,
}) =>
    [
      NotifierAction(
        NotificationActionIds.take,
        group
            ? (arabic ? '✓ تم تناول الكل' : '✓ Take all')
            : (arabic ? '✓ تم التناول' : '✓ Take'),
      ),
      NotifierAction(
        NotificationActionIds.snooze,
        arabic ? 'تأجيل 10 دقائق' : 'Snooze 10 min',
      ),
    ];

enum ActionOutcome { taken, snoozed, alreadyHandled, failed, ignored }

/// Handles "Take" and "Snooze" pressed on a dose reminder, whether the app
/// is open or not. Taking a dose goes through the same transactional
/// use case as the in-app button (stock, maximum, grace window, audit).
class DoseNotificationActions {
  DoseNotificationActions({
    required AppDatabase db,
    required DoseService doses,
    required SettingsRepository settings,
    required LocalNotifier notifier,
    required this.arabic,
    Clock clock = systemClock,
  })  : _db = db,
        _doses = doses,
        _settings = settings,
        _notifier = notifier,
        _clock = clock;

  /// Builds everything needed from a bare database, for the background
  /// isolate that runs when the app is closed.
  factory DoseNotificationActions.headless(
    AppDatabase db,
    LocalNotifier notifier, {
    required bool arabic,
    required SessionContext session,
  }) {
    final audit = AuditLog(db, session);
    final inventory = InventoryRepository(db, audit, session);
    return DoseNotificationActions(
      db: db,
      doses: DoseService(
        db,
        inventory,
        InventoryService(db, inventory),
        audit,
        session,
      ),
      settings: SettingsRepository(db),
      notifier: notifier,
      arabic: arabic,
    );
  }

  final AppDatabase _db;
  final DoseService _doses;
  final SettingsRepository _settings;
  final LocalNotifier _notifier;
  final Clock _clock;
  final bool arabic;

  Future<ActionOutcome> handle(String? actionId, String? rawPayload) async {
    final payload = NotificationPayload.decode(rawPayload);
    final doseId = payload?.doseId;
    if (payload?.kind != NotificationPayload.dose || doseId == null) {
      return ActionOutcome.ignored;
    }
    return switch (actionId) {
      NotificationActionIds.take => _take(doseId, payload?.group),
      NotificationActionIds.snooze =>
        _snooze(doseId, rawPayload!, payload?.group),
      _ => Future.value(ActionOutcome.ignored),
    };
  }

  Future<ActionOutcome> _take(String doseId, String? group) async {
    final row = await _doseWithMedication(doseId);
    if (row == null) return ActionOutcome.ignored;
    final (dose, medication, patient) = row;
    final name = arabic
        ? (medication.nameAr?.isNotEmpty ?? false
            ? medication.nameAr!
            : medication.nameEn)
        : medication.nameEn;
    if (dose.status != DoseStatus.scheduled.code) {
      return ActionOutcome.alreadyHandled;
    }
    final settings = await _settings.load();
    try {
      await _doses.takeDose(
        doseInstanceId: doseId,
        actualQuantityScaled: dose.requiredQuantityScaled,
        graceMinutes: settings.missedGraceMinutes,
      );
    } on DomainException catch (error) {
      await _notifier.show(
        id: notificationIdFor('action_failed:$doseId'),
        title: arabic ? 'لم يتم تسجيل $name' : 'Could not record $name',
        body: _failureText(error),
        channel: NotificationChannel.doses,
        payload:
            const NotificationPayload(kind: NotificationPayload.open).encode(),
      );
      return ActionOutcome.failed;
    }
    // Combined mode: the rest of the dose group is completed as well.
    var completion = const GroupCompletion();
    if (settings.doseCompletionMode.isCombined) {
      completion = await _doses.completeGroupMates(
        primaryDoseId: doseId,
        graceMinutes: settings.missedGraceMinutes,
      );
    }
    // The doses are handled: remove their pending alerts.
    for (final id in [doseId, ...completion.taken]) {
      for (final key in [
        '${NotificationTypes.doseReminder}:$id',
        '${NotificationTypes.missedDose}:$id',
        'snooze:$id',
      ]) {
        await _notifier.cancel(notificationIdFor(key));
      }
    }
    if (group != null) {
      for (final key in [
        '${NotificationTypes.doseReminder}:g:$group',
        '${NotificationTypes.missedDose}:g:$group',
      ]) {
        await _notifier.cancel(notificationIdFor(key));
      }
    }
    final clock = PatientTime(patient.timezone).localTimeOf(_clock()).toHHmm();
    final more = completion.taken.length;
    await _notifier.show(
      id: notificationIdFor('confirm:$doseId'),
      title: arabic ? '✓ تم التسجيل' : '✓ Recorded',
      body: more == 0
          ? (arabic ? 'تم تناول $name الساعة $clock' : '$name taken at $clock')
          : (arabic
              ? 'تم تسجيل $name و$more دواء آخر الساعة $clock'
              : '$name and $more more taken at $clock'),
      channel: NotificationChannel.confirmations,
      payload:
          const NotificationPayload(kind: NotificationPayload.open).encode(),
    );
    return ActionOutcome.taken;
  }

  Future<ActionOutcome> _snooze(
    String doseId,
    String payload,
    String? group,
  ) async {
    final dose = await (_db.select(_db.doseInstances)
          ..where((d) => d.doseInstanceId.equals(doseId)))
        .getSingleOrNull();
    if (dose == null || dose.status != DoseStatus.scheduled.code) {
      return ActionOutcome.alreadyHandled;
    }
    final reminder = await (_db.select(_db.notifications)
          ..where(
            (n) => n.dedupKey.equals(
              group == null
                  ? '${NotificationTypes.doseReminder}:$doseId'
                  : '${NotificationTypes.doseReminder}:g:$group',
            ),
          ))
        .getSingleOrNull();
    await _notifier.schedule(
      id: notificationIdFor('snooze:$doseId'),
      title: (arabic ? reminder?.titleAr : reminder?.titleEn) ??
          (arabic ? 'موعد الدواء' : 'Medication reminder'),
      body: (arabic ? reminder?.bodyAr : reminder?.bodyEn) ?? '',
      at: _clock().add(snoozeDuration),
      channel: NotificationChannel.doses,
      payload: payload,
      actions: doseReminderActions(arabic: arabic, group: group != null),
    );
    return ActionOutcome.snoozed;
  }

  Future<(DoseInstance, Medication, Patient)?> _doseWithMedication(
    String doseId,
  ) async {
    final row = await (_db.select(_db.doseInstances).join([
      innerJoin(
        _db.medications,
        _db.medications.medicationId.equalsExp(_db.doseInstances.medicationId),
      ),
      innerJoin(
        _db.patients,
        _db.patients.patientId.equalsExp(_db.doseInstances.patientId),
      ),
    ])
          ..where(_db.doseInstances.doseInstanceId.equals(doseId)))
        .getSingleOrNull();
    if (row == null) return null;
    return (
      row.readTable(_db.doseInstances),
      row.readTable(_db.medications),
      row.readTable(_db.patients),
    );
  }

  String _failureText(DomainException error) => switch (error.code) {
        'insufficientStock' => arabic
            ? 'المخزون المسجل غير كافٍ. افتح بالميعاد لتسجيل الكمية الفعلية.'
            : 'Not enough stock recorded. Open BelMiad to record the actual amount.',
        'maximumDailyExceeded' => arabic
            ? 'سيتم تجاوز الحد الأقصى اليومي. افتح بالميعاد للتأكيد.'
            : 'The daily maximum would be exceeded. Open BelMiad to confirm.',
        'doseWindowClosed' || 'invalidDoseTransition' => arabic
            ? 'لم يعد من الممكن تسجيل هذه الجرعة كمتناولة.'
            : 'This dose can no longer be marked taken.',
        _ => arabic
            ? 'افتح بالميعاد لتسجيل الجرعة.'
            : 'Open BelMiad to record the dose.',
      };
}

/// Runs in a background isolate when a notification button is pressed while
/// the app is not running.
@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(
    NotificationResponse response) async {
  DartPluginRegistrant.ensureInitialized();
  tzdata.initializeTimeZones();
  final prefs = await SharedPreferences.getInstance();
  final arabic = prefs.getString('language_code') == 'ar';
  final db = openAppDatabase();
  try {
    final settings = await SettingsRepository(db).load();
    final session = SessionContext()..actorPersonId = settings.devicePersonId;
    final notifier = createPlatformNotifier(
      requestPermissions: false,
      reminderSound: () => ReminderSound.read(prefs),
    );
    await notifier.initialize();
    await DoseNotificationActions.headless(
      db,
      notifier,
      arabic: arabic,
      session: session,
    ).handle(response.actionId, response.payload);
  } finally {
    await db.close();
  }
}
