import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/notifications/local_notifier.dart';
import '../../../core/settings/settings_repository.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/ids.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../doses/domain/dose_status.dart';
import '../../health/data/health_repositories.dart';
import '../../inventory/application/stock_forecast_service.dart';
import '../../inventory/domain/stock_forecast.dart';
import '../domain/notification_types.dart';
import 'notification_actions.dart';

abstract final class NotificationStatus {
  static const scheduled = 'scheduled';
  static const delivered = 'delivered';
  static const cancelled = 'cancelled';

  /// The condition cleared (e.g. stock replenished); a later recurrence may
  /// notify again.
  static const resolved = 'resolved';
}

class _Message {
  const _Message(this.titleEn, this.titleAr, this.bodyEn, this.bodyAr);

  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
}

/// Generates, schedules and deduplicates offline notifications (spec §27).
///
/// Every notification has a stable dedup key persisted in SQLite, so running
/// [sync] on every launch never produces duplicates.
class NotificationEngine {
  NotificationEngine(
    this._db,
    this._notifier,
    this._forecast,
    this._settings, {
    Clock clock = systemClock,
    this.reminderHorizon = const Duration(hours: 48),
    this.missedAlertDelay = const Duration(minutes: 60),
  }) : _clock = clock;

  final AppDatabase _db;
  final LocalNotifier _notifier;
  final StockForecastService _forecast;
  final SettingsRepository _settings;
  final Clock _clock;
  final Duration reminderHorizon;
  final Duration missedAlertDelay;

  bool _running = false;

  Future<void> sync({required String languageCode}) async {
    if (_running) return;
    _running = true;
    try {
      final arabic = languageCode == 'ar';
      await _upgradeFormat();
      final settings = await _settings.load();
      final patients = await (_db.select(_db.patients).join([
        innerJoin(
          _db.persons,
          _db.persons.personId.equalsExp(_db.patients.patientId),
        ),
      ])
            ..where(_db.patients.deletedAt.isNull()))
          .get();
      final activePatientIds = <String>{};
      for (final row in patients) {
        final patient = row.readTable(_db.patients);
        final person = row.readTable(_db.persons);
        activePatientIds.add(patient.patientId);
        final prefs = await _preferences(patient.patientId);
        await _syncDoses(patient, person.fullName, prefs, settings, arabic);
        await _syncInventory(patient, person.fullName, prefs, settings, arabic);
        await _syncAppointments(patient, person.fullName, prefs, arabic);
      }
      await _cancelOrphans(activePatientIds);
      await _restoreMissingPlatformSchedules(arabic);
    } finally {
      _running = false;
    }
  }

  /// Version of the scheduled-notification format. Bumping it reschedules
  /// pending dose alerts once (e.g. to add action buttons).
  static const formatVersion = '2';
  static const _formatKey = 'notification_format_version';

  Future<void> _upgradeFormat() async {
    if (await _settings.get(_formatKey) == formatVersion) return;
    final pending = await (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.status.equals(NotificationStatus.scheduled) &
                n.notificationType.isIn([
                  NotificationTypes.doseReminder,
                  NotificationTypes.missedDose,
                ]),
          ))
        .get();
    for (final row in pending) {
      await _notifier.cancel(notificationIdFor(row.dedupKey));
    }
    if (pending.isNotEmpty) {
      await (_db.delete(_db.notifications)
            ..where(
              (n) =>
                  n.notificationId.isIn(pending.map((r) => r.notificationId)),
            ))
          .go();
    }
    await _settings.set(_formatKey, formatVersion);
  }

  Future<Map<String, bool>> _preferences(String patientId) async {
    final rows = await (_db.select(_db.patientNotificationPreferences)
          ..where((p) => p.patientId.equals(patientId)))
        .get();
    return {
      for (final type in NotificationTypes.all) type: true,
      for (final r in rows) r.notificationType: r.enabled,
    };
  }

  Future<AppNotification?> _byKey(String key) =>
      (_db.select(_db.notifications)..where((n) => n.dedupKey.equals(key)))
          .getSingleOrNull();

  Future<void> _upsertScheduled({
    required String key,
    required String type,
    required String patientId,
    required String? recipient,
    required DateTime at,
    required _Message message,
    required NotificationChannel channel,
    required bool arabic,
    String? doseId,
    String? appointmentId,
    String? payload,
    List<NotifierAction> actions = const [],
  }) async {
    final existing = await _byKey(key);
    final now = _clock();
    if (existing != null) {
      final unchanged = existing.status == NotificationStatus.scheduled &&
          existing.scheduledAt.toUtc() == at.toUtc();
      final alreadyDone = existing.status == NotificationStatus.delivered;
      if (unchanged || alreadyDone) return;
    }
    final companion = NotificationsCompanion(
      notificationId: Value(existing?.notificationId ?? newId()),
      patientId: Value(patientId),
      recipientPersonId: Value(recipient),
      notificationType: Value(type),
      dedupKey: Value(key),
      scheduledAt: Value(at.toUtc()),
      status: const Value(NotificationStatus.scheduled),
      doseInstanceId: Value(doseId),
      appointmentId: Value(appointmentId),
      titleEn: Value(message.titleEn),
      titleAr: Value(message.titleAr),
      bodyEn: Value(message.bodyEn),
      bodyAr: Value(message.bodyAr),
      updatedAt: Value(now),
    );
    if (existing == null) {
      await _db
          .into(_db.notifications)
          .insert(companion.copyWith(createdAt: Value(now)));
    } else {
      await (_db.update(_db.notifications)
            ..where((n) => n.notificationId.equals(existing.notificationId)))
          .write(companion);
    }
    await _notifier.schedule(
      id: notificationIdFor(key),
      title: arabic ? message.titleAr : message.titleEn,
      body: arabic ? message.bodyAr : message.bodyEn,
      at: at,
      channel: channel,
      payload: payload,
      actions: actions,
    );
  }

  /// Shows an immediate notification once per active condition.
  Future<void> _deliverOnce({
    required String key,
    required String type,
    required String patientId,
    required String? recipient,
    required _Message message,
    required bool arabic,
    String? medicationId,
    String? batchId,
  }) async {
    final existing = await _byKey(key);
    if (existing != null && existing.status == NotificationStatus.delivered) {
      return;
    }
    final now = _clock();
    final companion = NotificationsCompanion(
      notificationId: Value(existing?.notificationId ?? newId()),
      patientId: Value(patientId),
      recipientPersonId: Value(recipient),
      notificationType: Value(type),
      dedupKey: Value(key),
      scheduledAt: Value(now),
      deliveredAt: Value(now),
      status: const Value(NotificationStatus.delivered),
      medicationId: Value(medicationId),
      inventoryBatchId: Value(batchId),
      titleEn: Value(message.titleEn),
      titleAr: Value(message.titleAr),
      bodyEn: Value(message.bodyEn),
      bodyAr: Value(message.bodyAr),
      isRead: const Value(false),
      updatedAt: Value(now),
    );
    if (existing == null) {
      await _db
          .into(_db.notifications)
          .insert(companion.copyWith(createdAt: Value(now)));
    } else {
      await (_db.update(_db.notifications)
            ..where((n) => n.notificationId.equals(existing.notificationId)))
          .write(companion);
    }
    await _notifier.show(
      id: notificationIdFor(key),
      title: arabic ? message.titleAr : message.titleEn,
      body: arabic ? message.bodyAr : message.bodyEn,
      channel: NotificationChannel.inventory,
    );
  }

  Future<void> _resolve(String key) async {
    final existing = await _byKey(key);
    if (existing == null || existing.status != NotificationStatus.delivered) {
      return;
    }
    await (_db.update(_db.notifications)
          ..where((n) => n.notificationId.equals(existing.notificationId)))
        .write(NotificationsCompanion(
      status: const Value(NotificationStatus.resolved),
      updatedAt: Value(_clock()),
    ));
  }

  Future<void> _cancelRow(AppNotification row) async {
    await _notifier.cancel(notificationIdFor(row.dedupKey));
    await (_db.update(_db.notifications)
          ..where((n) => n.notificationId.equals(row.notificationId)))
        .write(NotificationsCompanion(
      status: const Value(NotificationStatus.cancelled),
      updatedAt: Value(_clock()),
    ));
  }

  Future<void> _syncDoses(
    Patient patient,
    String patientName,
    Map<String, bool> prefs,
    AppSettingsData settings,
    bool arabic,
  ) async {
    final now = _clock();
    final remindersOn = prefs[NotificationTypes.doseReminder]!;
    final missedOn = prefs[NotificationTypes.missedDose]!;
    final time = PatientTime(patient.timezone);
    final horizon = now.add(reminderHorizon);
    final rows = await (_db.select(_db.doseInstances).join([
      innerJoin(
        _db.medications,
        _db.medications.medicationId.equalsExp(_db.doseInstances.medicationId),
      ),
      leftOuterJoin(
        _db.medicationSchedules,
        _db.medicationSchedules.scheduleId
            .equalsExp(_db.doseInstances.scheduleId),
      ),
      leftOuterJoin(
        _db.meals,
        _db.meals.mealId.equalsExp(_db.medicationSchedules.mealId),
      ),
    ])
          ..where(
            _db.doseInstances.patientId.equals(patient.patientId) &
                _db.doseInstances.status.equals(DoseStatus.scheduled.code) &
                _db.doseInstances.isPrn.equals(false) &
                _db.doseInstances.scheduledAt.isBiggerThanValue(
                  now.subtract(missedAlertDelay),
                ) &
                _db.doseInstances.scheduledAt.isSmallerOrEqualValue(horizon),
          ))
        .get();
    final wanted = <String>{};
    for (final row in rows) {
      final dose = row.readTable(_db.doseInstances);
      final medication = row.readTable(_db.medications);
      final schedule = row.readTableOrNull(_db.medicationSchedules);
      final meal = schedule?.scheduleType == 'meal_relative'
          ? row.readTableOrNull(_db.meals)
          : null;
      final payload = NotificationPayload(
        kind: NotificationPayload.dose,
        doseId: dose.doseInstanceId,
        patientId: patient.patientId,
      ).encode();
      final nameEn = medication.nameEn;
      final nameAr = medication.nameAr ?? medication.nameEn;
      final qty = ScaledQuantity(dose.requiredQuantityScaled).format();
      final clock = time.localTimeOf(dose.scheduledAt).toHHmm();
      if (remindersOn && dose.scheduledAt.isAfter(now)) {
        final key = '${NotificationTypes.doseReminder}:${dose.doseInstanceId}';
        wanted.add(key);
        await _upsertScheduled(
          key: key,
          type: NotificationTypes.doseReminder,
          patientId: patient.patientId,
          recipient: settings.devicePersonId,
          at: dose.scheduledAt,
          doseId: dose.doseInstanceId,
          channel: NotificationChannel.doses,
          arabic: arabic,
          payload: payload,
          actions: doseReminderActions(arabic: arabic),
          message: _doseReminderMessage(
            patientName: patientName,
            nameEn: nameEn,
            nameAr: nameAr,
            quantity: qty,
            unit: medication.doseUnit,
            clock: clock,
            meal: meal,
            relation: schedule?.timingRelation,
          ),
        );
      }
      final missedAt = dose.scheduledAt.add(missedAlertDelay);
      if (missedOn && missedAt.isAfter(now)) {
        final key = '${NotificationTypes.missedDose}:${dose.doseInstanceId}';
        wanted.add(key);
        await _upsertScheduled(
          key: key,
          type: NotificationTypes.missedDose,
          patientId: patient.patientId,
          recipient: settings.devicePersonId,
          at: missedAt,
          doseId: dose.doseInstanceId,
          channel: NotificationChannel.missed,
          arabic: arabic,
          payload: payload,
          message: _Message(
            'Dose not taken — $patientName',
            'جرعة لم تُؤخذ — $patientName',
            '$patientName has not taken $nameEn scheduled at $clock.',
            'لم يتناول $patientName دواء $nameAr المقرر الساعة $clock.',
          ),
        );
      }
    }
    // Cancel pending dose notifications that are no longer wanted (dose
    // taken/skipped/regenerated or preference disabled).
    final pending = await (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.patientId.equals(patient.patientId) &
                n.status.equals(NotificationStatus.scheduled) &
                n.notificationType.isIn([
                  NotificationTypes.doseReminder,
                  NotificationTypes.missedDose,
                ]),
          ))
        .get();
    for (final row in pending) {
      if (wanted.contains(row.dedupKey)) continue;
      if (row.scheduledAt.isBefore(now)) {
        await (_db.update(_db.notifications)
              ..where((n) => n.notificationId.equals(row.notificationId)))
            .write(NotificationsCompanion(
          status: const Value(NotificationStatus.delivered),
          deliveredAt: Value(row.scheduledAt),
        ));
      } else {
        await _cancelRow(row);
      }
    }
    // Scheduled rows whose dose is no longer scheduled were marked cancelled
    // inside the dose transaction; make sure the platform alarm is gone too.
    final cancelled = await (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.patientId.equals(patient.patientId) &
                n.status.equals(NotificationStatus.cancelled) &
                n.scheduledAt.isBiggerThanValue(now),
          ))
        .get();
    for (final row in cancelled) {
      await _notifier.cancel(notificationIdFor(row.dedupKey));
    }
  }

  Future<void> _syncInventory(
    Patient patient,
    String patientName,
    Map<String, bool> prefs,
    AppSettingsData settings,
    bool arabic,
  ) async {
    final data = await _forecast.forPatient(patient.patientId);
    final today = PatientTime(patient.timezone).today(_clock());
    for (final item in data.items) {
      final medication = item.medication;
      final summary = item.summary;
      final nameEn = medication.nameEn;
      final nameAr = medication.nameAr ?? medication.nameEn;
      final id = medication.medicationId;

      final lowKey = '${NotificationTypes.lowStock}:$id';
      if (prefs[NotificationTypes.lowStock]! &&
          summary.isLowStock &&
          summary.usableScaled > 0) {
        final days = summary.remainingDays ?? 0;
        await _deliverOnce(
          key: lowKey,
          type: NotificationTypes.lowStock,
          patientId: patient.patientId,
          recipient: settings.devicePersonId,
          medicationId: id,
          arabic: arabic,
          message: _Message(
            'Low stock: $nameEn',
            'مخزون منخفض: $nameAr',
            '$patientName has $days day${days == 1 ? '' : 's'} of $nameEn remaining.',
            'متبقٍ لدى $patientName من $nameAr ما يكفي $days يوم.',
          ),
        );
      } else if (!summary.isLowStock) {
        await _resolve(lowKey);
      }

      final emptyKey = '${NotificationTypes.emptyStock}:$id';
      final isEmpty = summary.stockRecorded && summary.usableScaled == 0;
      if (prefs[NotificationTypes.emptyStock]! && isEmpty) {
        await _deliverOnce(
          key: emptyKey,
          type: NotificationTypes.emptyStock,
          patientId: patient.patientId,
          recipient: settings.devicePersonId,
          medicationId: id,
          arabic: arabic,
          message: _Message(
            'Out of stock: $nameEn',
            'نفد المخزون: $nameAr',
            '$patientName has no $nameEn remaining.',
            'لم يتبقَّ لدى $patientName أي كمية من $nameAr.',
          ),
        );
      } else if (!isEmpty) {
        await _resolve(emptyKey);
      }

      if (!prefs[NotificationTypes.expiration]!) continue;
      for (final batch in item.batches) {
        if (batch.availableQuantityScaled <= 0) continue;
        final expiry = LocalDate.tryParse(batch.expirationDate);
        final state = expirationStateOf(
          expiry,
          today: today,
          expiringWithinDays: settings.expiringWithinDays,
        );
        if (state == ExpirationState.none) continue;
        final batchId = batch.inventoryBatchId;
        if (state == ExpirationState.expired) {
          await _deliverOnce(
            key: 'expired:$batchId',
            type: NotificationTypes.expiration,
            patientId: patient.patientId,
            recipient: settings.devicePersonId,
            medicationId: id,
            batchId: batchId,
            arabic: arabic,
            message: _Message(
              'Expired: $nameEn',
              'منتهي الصلاحية: $nameAr',
              '$nameEn for $patientName has expired.',
              'انتهت صلاحية $nameAr الخاص بـ $patientName.',
            ),
          );
        } else {
          final days = today.daysUntil(expiry!);
          await _deliverOnce(
            key: 'expiring:$batchId',
            type: NotificationTypes.expiration,
            patientId: patient.patientId,
            recipient: settings.devicePersonId,
            medicationId: id,
            batchId: batchId,
            arabic: arabic,
            message: _Message(
              'Expiring soon: $nameEn',
              'قرب انتهاء الصلاحية: $nameAr',
              days == 0
                  ? '$nameEn for $patientName expires today.'
                  : '$nameEn for $patientName expires in $days days.',
              days == 0
                  ? 'تنتهي صلاحية $nameAr الخاص بـ $patientName اليوم.'
                  : 'تنتهي صلاحية $nameAr الخاص بـ $patientName خلال $days يوم.',
            ),
          );
        }
      }
    }
  }

  Future<void> _syncAppointments(
    Patient patient,
    String patientName,
    Map<String, bool> prefs,
    bool arabic,
  ) async {
    final now = _clock();
    final enabled = prefs[NotificationTypes.appointmentReminder]!;
    final appointments = await (_db.select(_db.appointments)
          ..where(
            (a) =>
                a.patientId.equals(patient.patientId) &
                a.deletedAt.isNull() &
                a.status.equals(AppointmentStatus.scheduled) &
                a.scheduledTime.isBiggerThanValue(now),
          ))
        .get();
    final time = PatientTime(patient.timezone);
    final wanted = <String>{};
    if (enabled) {
      for (final appointment in appointments) {
        final local = time.toLocal(appointment.scheduledTime);
        final when = '${LocalDate(local.year, local.month, local.day).toIso()} '
            '${time.localTimeOf(appointment.scheduledTime).toHHmm()}';
        for (final lead in const [Duration(hours: 24), Duration(hours: 2)]) {
          final at = appointment.scheduledTime.subtract(lead);
          if (!at.isAfter(now)) continue;
          final key = '${NotificationTypes.appointmentReminder}:'
              '${appointment.appointmentId}:${lead.inHours}h';
          wanted.add(key);
          await _upsertScheduled(
            key: key,
            type: NotificationTypes.appointmentReminder,
            patientId: patient.patientId,
            recipient: null,
            at: at,
            appointmentId: appointment.appointmentId,
            channel: NotificationChannel.appointments,
            arabic: arabic,
            message: _Message(
              'Appointment — $patientName',
              'موعد طبي — $patientName',
              '$patientName has an appointment with ${appointment.doctorName} on $when.',
              'لدى $patientName موعد مع ${appointment.doctorName} في $when.',
            ),
          );
        }
      }
    }
    final pending = await (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.patientId.equals(patient.patientId) &
                n.status.equals(NotificationStatus.scheduled) &
                n.notificationType
                    .equals(NotificationTypes.appointmentReminder),
          ))
        .get();
    for (final row in pending) {
      if (!wanted.contains(row.dedupKey)) await _cancelRow(row);
    }
  }

  /// Cancels pending notifications of patients that were moved to trash.
  Future<void> _cancelOrphans(Set<String> activePatientIds) async {
    final pending = await (_db.select(_db.notifications)
          ..where((n) => n.status.equals(NotificationStatus.scheduled)))
        .get();
    for (final row in pending) {
      if (!activePatientIds.contains(row.patientId)) await _cancelRow(row);
    }
  }

  /// Re-registers future alarms missing from the OS (e.g. after restoring a
  /// backup), without creating new rows.
  Future<void> _restoreMissingPlatformSchedules(bool arabic) async {
    final now = _clock();
    final pendingIds = await _notifier.pendingIds();
    final rows = await (_db.select(_db.notifications)
          ..where(
            (n) =>
                n.status.equals(NotificationStatus.scheduled) &
                n.scheduledAt.isBiggerThanValue(now),
          ))
        .get();
    if (pendingIds.isEmpty &&
        rows.isNotEmpty &&
        _notifier is NoopLocalNotifier) {
      return;
    }
    for (final row in rows) {
      final id = notificationIdFor(row.dedupKey);
      if (pendingIds.contains(id)) continue;
      final isReminder = row.notificationType == NotificationTypes.doseReminder;
      await _notifier.schedule(
        id: id,
        title: (arabic ? row.titleAr : row.titleEn) ?? '',
        body: (arabic ? row.bodyAr : row.bodyEn) ?? '',
        payload: row.doseInstanceId == null
            ? null
            : NotificationPayload(
                kind: NotificationPayload.dose,
                doseId: row.doseInstanceId,
                patientId: row.patientId,
              ).encode(),
        actions: isReminder ? doseReminderActions(arabic: arabic) : const [],
        at: row.scheduledAt,
        channel: switch (row.notificationType) {
          NotificationTypes.missedDose => NotificationChannel.missed,
          NotificationTypes.appointmentReminder =>
            NotificationChannel.appointments,
          _ => NotificationChannel.doses,
        },
      );
    }
  }

  /// "Breakfast dose — Mother: take 1 tablet of Panadol at 08:30 (after
  /// breakfast)".
  _Message _doseReminderMessage({
    required String patientName,
    required String nameEn,
    required String nameAr,
    required String quantity,
    required String unit,
    required String clock,
    Meal? meal,
    String? relation,
  }) {
    if (meal == null) {
      return _Message(
        'Time for $nameEn — $patientName',
        'موعد $nameAr — $patientName',
        '$patientName: take $quantity $unit of $nameEn at $clock.',
        '$patientName: تناول $quantity من $nameAr الساعة $clock.',
      );
    }
    final mealEn = meal.nameEn;
    final mealAr = meal.nameAr.isEmpty ? meal.nameEn : meal.nameAr;
    final (relationEn, relationAr) = switch (relation) {
      'before' => ('before', 'قبل'),
      'after' => ('after', 'بعد'),
      _ => ('with', 'مع'),
    };
    return _Message(
      '$mealEn dose — $patientName',
      'جرعة $mealAr — $patientName',
      'Take $quantity $unit of $nameEn at $clock ($relationEn ${mealEn.toLowerCase()}).',
      'تناول $quantity من $nameAr الساعة $clock ($relationAr $mealAr).',
    );
  }
}
