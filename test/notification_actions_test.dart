import 'package:belmiad/core/notifications/local_notifier.dart';
import 'package:belmiad/core/notifications/reminder_sound.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/notifications/application/notification_actions.dart';
import 'package:belmiad/features/notifications/application/notification_engine.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_notifier.dart';
import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late FakeNotifier notifier;
  late NotificationEngine engine;
  late DoseNotificationActions actions;
  late String patientId;
  late String medicationId;
  late String doseId;

  // Now: 2026-09-28 09:00 Cairo. The dose is 30 min after lunch (14:00),
  // i.e. 14:30 Cairo = 11:30 UTC.
  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    notifier = FakeNotifier();
    engine = NotificationEngine(
      h.db,
      notifier,
      h.forecast,
      h.settings,
      clock: h.clock,
    );
    actions = DoseNotificationActions(
      db: h.db,
      doses: h.doses,
      settings: h.settings,
      notifier: notifier,
      arabic: false,
      clock: h.clock,
    );
    await h.createCaregiver();
    patientId = await h.createPatient();
    medicationId = await h.createMedication(patientId);
    final lunch = (await h.meals.listForPatient(patientId))
        .firstWhere((m) => m.mealType == 'lunch');
    await h.schedules.saveGroup(
      medicationId: medicationId,
      slots: [
        ScheduleSlot(
          scheduleType: ScheduleTypes.mealRelative,
          mealId: lunch.mealId,
          timingRelation: timingRelationCode(TimingRelation.after),
          offsetMinutes: 30,
          doseQuantityScaled: 1000,
        ),
      ],
      rule: const RecurrenceRule(),
    );
    await h.generation.syncPatient(patientId, graceMinutes: 180);
    doseId = (await h.allDoses(patientId))
        .firstWhere((d) => d.localDate == '2026-09-28')
        .doseInstanceId;
  });

  tearDown(() => h.close());

  RecordedNotification reminder() =>
      notifier.details[notificationIdFor('dose_reminder:$doseId')]!;

  test('reminders pop up with Take and Snooze buttons and the meal name',
      () async {
    await engine.sync(languageCode: 'en');
    final shown = reminder();
    expect(shown.channel, NotificationChannel.doses);
    expect(shown.title, 'Lunch dose — Mother');
    expect(shown.body, contains('after lunch'));
    expect(shown.actions.map((a) => a.id), [
      NotificationActionIds.take,
      NotificationActionIds.snooze,
    ]);
    final payload = NotificationPayload.decode(shown.payload)!;
    expect(payload.doseId, doseId);
    expect(payload.patientId, patientId);
  });

  test('Take records the dose, uses stock and confirms', () async {
    final batch = await h.inventory.addBatch(
      BatchInput(medicationId: medicationId, quantityScaled: 5000),
    );
    await engine.sync(languageCode: 'en');
    h.now = DateTime.utc(2026, 9, 28, 11, 35);
    final outcome = await actions.handle(
      NotificationActionIds.take,
      reminder().payload,
    );
    expect(outcome, ActionOutcome.taken);
    final dose = await h.dose(doseId);
    expect(dose.status, DoseStatus.taken.code);
    expect(dose.lateMinutes, 5);
    expect((await h.batch(batch)).availableQuantityScaled, 4000);
    expect(
      notifier.cancelled,
      contains(notificationIdFor('missed_dose:$doseId')),
    );
    final confirmation =
        notifier.details[notificationIdFor('confirm:$doseId')]!;
    expect(confirmation.channel, NotificationChannel.confirmations);
    expect(confirmation.body, contains('14:35'));

    // Pressing Take again changes nothing.
    expect(
      await actions.handle(NotificationActionIds.take, reminder().payload),
      ActionOutcome.alreadyHandled,
    );
    expect((await h.batch(batch)).availableQuantityScaled, 4000);
  });

  test('Take without enough stock asks to open the app', () async {
    await h.inventory.addBatch(
      BatchInput(medicationId: medicationId, quantityScaled: 500),
    );
    await engine.sync(languageCode: 'en');
    h.now = DateTime.utc(2026, 9, 28, 11, 30);
    final outcome = await actions.handle(
      NotificationActionIds.take,
      reminder().payload,
    );
    expect(outcome, ActionOutcome.failed);
    expect((await h.dose(doseId)).status, DoseStatus.scheduled.code);
    final failure =
        notifier.details[notificationIdFor('action_failed:$doseId')]!;
    expect(failure.body, contains('Open BelMiad'));
  });

  test('Snooze reminds again in 10 minutes with the same buttons', () async {
    await engine.sync(languageCode: 'en');
    h.now = DateTime.utc(2026, 9, 28, 11, 30);
    final outcome = await actions.handle(
      NotificationActionIds.snooze,
      reminder().payload,
    );
    expect(outcome, ActionOutcome.snoozed);
    final snoozed = notifier.details[notificationIdFor('snooze:$doseId')]!;
    expect(snoozed.at, DateTime.utc(2026, 9, 28, 11, 40));
    expect(snoozed.title, 'Lunch dose — Mother');
    expect(snoozed.actions, hasLength(2));
  });

  test('old-format reminders are rescheduled once with buttons', () async {
    await engine.sync(languageCode: 'en');
    await h.settings.set('notification_format_version', '1');
    notifier.details.clear();
    await engine.sync(languageCode: 'en');
    expect(reminder().actions, hasLength(2));
    notifier.details.clear();
    await engine.sync(languageCode: 'en');
    expect(
        notifier.details
            .containsKey(notificationIdFor('dose_reminder:$doseId')),
        isFalse);
  });

  test('changing the reminder sound reschedules pending reminders once',
      () async {
    await engine.sync(languageCode: 'en');
    expect(notifier.staleChannelCleanups, 0);

    notifier.sound = ReminderSound.builtIn(BuiltInTone.chime);
    notifier.details.clear();
    await engine.sync(languageCode: 'en');
    expect(reminder().actions, hasLength(2));
    expect(notifier.staleChannelCleanups, 1);

    // Same sound: nothing is rescheduled again.
    notifier.details.clear();
    await engine.sync(languageCode: 'en');
    expect(
        notifier.details
            .containsKey(notificationIdFor('dose_reminder:$doseId')),
        isFalse);
    expect(notifier.staleChannelCleanups, 1);
  });

  test('reminder sounds survive being saved and read back', () {
    final sounds = [
      const ReminderSound.systemDefault(),
      const ReminderSound.silent(),
      ReminderSound.builtIn(BuiltInTone.bell),
      const ReminderSound.device(
        uri: 'content://media/internal/audio/media/42',
        title: 'Oxygen',
      ),
    ];
    for (final sound in sounds) {
      final decoded = ReminderSound.decode(sound.encode());
      expect(decoded, sound);
      expect(decoded.title, sound.title);
    }
    // Every sound gets its own Android channel.
    expect(sounds.map((s) => s.key).toSet(), hasLength(sounds.length));
    expect(
        ReminderSound.decode('nonsense'), const ReminderSound.systemDefault());
    expect(
      ReminderSound.decode('{"kind":"builtIn","value":"removed_tone"}'),
      const ReminderSound.systemDefault(),
    );
  });

  test('payload round trip ignores malformed input', () {
    const payload = NotificationPayload(
      kind: NotificationPayload.dose,
      doseId: 'd1',
      patientId: 'p1',
    );
    final decoded = NotificationPayload.decode(payload.encode())!;
    expect(decoded.doseId, 'd1');
    expect(NotificationPayload.decode('not json'), isNull);
  });
}
