import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/notifications/local_notifier.dart';
import '../../../core/settings/settings_repository.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/ids.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../doses/domain/dose_grouping.dart';
import '../../doses/domain/dose_status.dart';
import '../../health/data/health_repositories.dart';
import '../../inventory/application/stock_forecast_service.dart';
import '../../inventory/domain/stock_forecast.dart';
import '../data/notification_history.dart';
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

class _DoseEntry {
  const _DoseEntry({
    required this.dose,
    required this.medication,
    this.schedule,
    this.meal,
  });

  final DoseInstance dose;
  final Medication medication;
  final MedicationSchedule? schedule;

  /// Set only for meal-relative schedules.
  final Meal? meal;

  DoseGroupInput get groupInput => DoseGroupInput(
        patientId: dose.patientId,
        localDate: dose.localDate,
        scheduledAt: dose.scheduledAt,
        isPrn: dose.isPrn,
        mealId: meal?.mealId,
        timingRelation: schedule?.timingRelation,
      );
}

class _DoseSyncContext {
  const _DoseSyncContext({
    required this.patient,
    required this.patientName,
    required this.settings,
    required this.arabic,
    required this.time,
    required this.now,
    required this.remindersOn,
    required this.missedOn,
    required this.wanted,
  });

  final Patient patient;
  final String patientName;
  final AppSettingsData settings;
  final bool arabic;
  final PatientTime time;
  final DateTime now;
  final bool remindersOn;
  final bool missedOn;
  final Set<String> wanted;
}

const _arabicUnits = {
  'tablet': 'قرص',
  'capsule': 'كبسولة',
  'ml': 'مل',
  'drop': 'نقطة',
  'puff': 'بخة',
  'sachet': 'كيس',
  'injection': 'حقنة',
  'patch': 'لصقة',
  'suppository': 'لبوس',
  'application': 'دهان',
  'mg': 'مجم',
  'g': 'جم',
  'unit': 'وحدة',
};

String _arabicUnit(String code) => _arabicUnits[code] ?? code;

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
      // Seven-day retention for the notification history.
      await purgeExpiredNotifications(_db, _clock());
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

  static const _soundKey = 'notification_sound_key';

  Future<void> _upgradeFormat() async {
    final soundKey = _notifier.reminderSound.key;
    final formatChanged = await _settings.get(_formatKey) != formatVersion;
    final soundChanged =
        (await _settings.get(_soundKey) ?? 'default') != soundKey;
    if (!formatChanged && !soundChanged) return;
    // Scheduled alerts keep the channel (and so the sound) they were created
    // with: reschedule them in the new format or with the new sound.
    await _resetScheduledDoseAlerts();
    if (soundChanged) await _notifier.removeStaleSoundChannels();
    await _settings.set(_formatKey, formatVersion);
    await _settings.set(_soundKey, soundKey);
  }

  Future<void> _resetScheduledDoseAlerts() async {
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
          existing.scheduledAt.toUtc() == at.toUtc() &&
          existing.titleEn == message.titleEn &&
          existing.bodyEn == message.bodyEn &&
          existing.bodyAr == message.bodyAr;
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
    if (existing != null &&
        (existing.status == NotificationStatus.delivered ||
            existing.status == notificationDismissed)) {
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
    if (existing == null ||
        (existing.status != NotificationStatus.delivered &&
            existing.status != notificationDismissed)) {
      return;
    }
    if (existing.status == notificationDismissed) {
      // The user already removed it; once the condition clears the row has
      // served its purpose, so a later recurrence can alert again.
      await (_db.delete(_db.notifications)
            ..where((n) => n.notificationId.equals(existing.notificationId)))
          .go();
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
    final entries = [
      for (final row in rows)
        _DoseEntry(
          dose: row.readTable(_db.doseInstances),
          medication: row.readTable(_db.medications),
          schedule: row.readTableOrNull(_db.medicationSchedules),
          meal: row.readTableOrNull(_db.medicationSchedules)?.scheduleType ==
                  'meal_relative'
              ? row.readTableOrNull(_db.meals)
              : null,
        ),
    ];
    // Same grouping rule as combined dose completion; "separate" simply
    // treats every dose as a group of one.
    final groups = settings.notificationGrouping.isCombined
        ? groupDoses(entries, (e) => e.groupInput)
        : [
            for (final e in entries) [e],
          ];
    final wanted = <String>{};
    final context = _DoseSyncContext(
      patient: patient,
      patientName: patientName,
      settings: settings,
      arabic: arabic,
      time: time,
      now: now,
      remindersOn: remindersOn,
      missedOn: missedOn,
      wanted: wanted,
    );
    for (final group in groups) {
      if (group.length == 1) {
        await _syncSingleDose(group.single, context);
      } else {
        await _syncDoseGroup(group, context);
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

  /// One notification for one medication dose (also used for a group that
  /// only has one open dose, so its key and text never change).
  Future<void> _syncSingleDose(_DoseEntry entry, _DoseSyncContext c) async {
    final dose = entry.dose;
    final medication = entry.medication;
    final schedule = entry.schedule;
    final meal = entry.meal;
    final patient = c.patient;
    final patientName = c.patientName;
    final arabic = c.arabic;
    final payload = NotificationPayload(
      kind: NotificationPayload.dose,
      doseId: dose.doseInstanceId,
      patientId: patient.patientId,
    ).encode();
    final nameEn = medication.nameEn;
    final nameAr = medication.nameAr ?? medication.nameEn;
    final qty = ScaledQuantity(dose.requiredQuantityScaled).format();
    final clock = c.time.localTimeOf(dose.scheduledAt).toHHmm();
    if (c.remindersOn && dose.scheduledAt.isAfter(c.now)) {
      final key = '${NotificationTypes.doseReminder}:${dose.doseInstanceId}';
      c.wanted.add(key);
      await _upsertScheduled(
        key: key,
        type: NotificationTypes.doseReminder,
        patientId: patient.patientId,
        recipient: c.settings.devicePersonId,
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
    if (c.missedOn && missedAt.isAfter(c.now)) {
      final key = '${NotificationTypes.missedDose}:${dose.doseInstanceId}';
      c.wanted.add(key);
      await _upsertScheduled(
        key: key,
        type: NotificationTypes.missedDose,
        patientId: patient.patientId,
        recipient: c.settings.devicePersonId,
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

  /// One notification for a whole dose group (two or more open doses).
  Future<void> _syncDoseGroup(
      List<_DoseEntry> group, _DoseSyncContext c) async {
    final sorted = [...group]
      ..sort((a, b) => a.dose.scheduledAt.compareTo(b.dose.scheduledAt));
    final first = sorted.first;
    final groupKey = doseGroupKey(first.groupInput)!;
    final patient = c.patient;
    final payload = NotificationPayload(
      kind: NotificationPayload.dose,
      doseId: first.dose.doseInstanceId,
      patientId: patient.patientId,
      group: groupKey,
    ).encode();
    final remindAt = first.dose.scheduledAt;
    final missedAt = sorted.last.dose.scheduledAt.add(missedAlertDelay);
    if (c.remindersOn && remindAt.isAfter(c.now)) {
      final key = '${NotificationTypes.doseReminder}:g:$groupKey';
      c.wanted.add(key);
      await _upsertScheduled(
        key: key,
        type: NotificationTypes.doseReminder,
        patientId: patient.patientId,
        recipient: c.settings.devicePersonId,
        at: remindAt,
        doseId: first.dose.doseInstanceId,
        channel: NotificationChannel.doses,
        arabic: c.arabic,
        payload: payload,
        actions: doseReminderActions(arabic: c.arabic, group: true),
        message: _groupReminderMessage(sorted, c),
      );
    }
    if (c.missedOn && missedAt.isAfter(c.now)) {
      final key = '${NotificationTypes.missedDose}:g:$groupKey';
      c.wanted.add(key);
      await _upsertScheduled(
        key: key,
        type: NotificationTypes.missedDose,
        patientId: patient.patientId,
        recipient: c.settings.devicePersonId,
        at: missedAt,
        doseId: first.dose.doseInstanceId,
        channel: NotificationChannel.missed,
        arabic: c.arabic,
        payload: payload,
        message: _groupMissedMessage(sorted, c),
      );
    }
  }

  /// "Lunch dose — Mother" with one line per medication, or
  /// "Time to take your medications — Mother" for fixed-time groups.
  _Message _groupReminderMessage(List<_DoseEntry> group, _DoseSyncContext c) {
    final first = group.first;
    final clock = c.time.localTimeOf(first.dose.scheduledAt).toHHmm();
    final linesEn = [
      for (final e in group)
        '• ${e.medication.nameEn} — '
            '${ScaledQuantity(e.dose.requiredQuantityScaled).format()} '
            '${e.medication.doseUnit}',
    ].join('\n');
    final linesAr = [
      for (final e in group)
        '• ${e.medication.nameAr ?? e.medication.nameEn} — '
            '${ScaledQuantity(e.dose.requiredQuantityScaled).format()} '
            '${_arabicUnit(e.medication.doseUnit)}',
    ].join('\n');
    final meal = first.meal;
    if (meal == null) {
      return _Message(
        'Time to take your medications — ${c.patientName}',
        'موعد أدويتك — ${c.patientName}',
        '$clock\n$linesEn',
        '$clock\n$linesAr',
      );
    }
    final mealEn = meal.nameEn;
    final mealAr = meal.nameAr.isEmpty ? meal.nameEn : meal.nameAr;
    final (relationEn, relationAr) = switch (first.schedule?.timingRelation) {
      'before' => ('Before', 'قبل'),
      'after' => ('After', 'بعد'),
      _ => ('With', 'مع'),
    };
    return _Message(
      '$relationEn ${mealEn.toLowerCase()} — ${c.patientName}',
      '$relationAr $mealAr — ${c.patientName}',
      'Time to take your medications ($clock):\n$linesEn',
      'موعد أدويتك ($clock):\n$linesAr',
    );
  }

  _Message _groupMissedMessage(List<_DoseEntry> group, _DoseSyncContext c) {
    final clock = c.time.localTimeOf(group.first.dose.scheduledAt).toHHmm();
    final namesEn = group.map((e) => e.medication.nameEn).join(', ');
    final namesAr =
        group.map((e) => e.medication.nameAr ?? e.medication.nameEn).join('، ');
    return _Message(
      'Doses not taken — ${c.patientName}',
      'جرعات لم تُؤخذ — ${c.patientName}',
      '${c.patientName} has not taken: $namesEn (scheduled at $clock).',
      'لم يتناول ${c.patientName}: $namesAr (المقرر الساعة $clock).',
    );
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
      final isGroup = row.dedupKey.contains(':g:');
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
                group: isGroup
                    ? row.dedupKey.substring(row.dedupKey.indexOf(':g:') + 3)
                    : null,
              ).encode(),
        actions: isReminder
            ? doseReminderActions(arabic: arabic, group: isGroup)
            : const [],
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
