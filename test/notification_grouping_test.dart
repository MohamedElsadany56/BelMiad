import 'package:belmiad/core/settings/settings_repository.dart';
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
  late String patientId;

  // 2026-09-28 09:00 in Cairo.
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
    await h.createCaregiver();
    patientId = await h.createPatient();
  });

  tearDown(() => h.close());

  Future<void> fixedMedication(String name, String time) async {
    final id = await h.createMedication(patientId, name: name);
    await h.schedules.saveGroup(
      medicationId: id,
      slots: [
        ScheduleSlot(
          scheduleType: ScheduleTypes.fixedTime,
          fixedTime: time,
          doseQuantityScaled: 1000,
        ),
      ],
      rule: const RecurrenceRule(),
    );
  }

  Future<void> mealMedication(
    String name,
    TimingRelation relation,
  ) async {
    final id = await h.createMedication(patientId, name: name);
    final lunch = (await h.meals.listForPatient(patientId))
        .firstWhere((m) => m.mealType == 'lunch');
    await h.schedules.saveGroup(
      medicationId: id,
      slots: [
        ScheduleSlot(
          scheduleType: ScheduleTypes.mealRelative,
          mealId: lunch.mealId,
          timingRelation: timingRelationCode(relation),
          offsetMinutes: relation == TimingRelation.withMeal ? 0 : 30,
          doseQuantityScaled: 1000,
        ),
      ],
      rule: const RecurrenceRule(),
    );
  }

  Future<List<RecordedNotification>> reminders() async {
    await h.generation.syncPatient(patientId, graceMinutes: 180);
    await engine.sync(languageCode: 'en');
    return notifier.details.values
        .where((n) =>
            n.actions.any((a) => a.id == NotificationActionIds.take) &&
            n.at!.toUtc().day == 28)
        .toList();
  }

  test('combined: same exact time gives one notification for the group',
      () async {
    await fixedMedication('Panadol', '10:00');
    await fixedMedication('Augmentin', '10:00');
    await fixedMedication('Vitamin', '12:00');
    final shown = await reminders();
    expect(shown.length, 2);
    final group = shown.firstWhere((n) => n.body.contains('Panadol'));
    expect(group.body, contains('Augmentin'));
    expect(group.body, isNot(contains('Vitamin')));
    expect(group.actions.first.title, contains('all'));
  });

  test('separate: every medication keeps its own notification', () async {
    await h.settings.set(SettingKeys.notificationGrouping, 'separate');
    await fixedMedication('Panadol', '10:00');
    await fixedMedication('Augmentin', '10:00');
    final shown = await reminders();
    expect(shown.length, 2);
    for (final n in shown) {
      expect(n.actions.first.title, isNot(contains('all')));
    }
  });

  test('combined: same meal event groups, before/after stay separate',
      () async {
    await mealMedication('A', TimingRelation.after);
    await mealMedication('B', TimingRelation.after);
    await mealMedication('C', TimingRelation.before);
    final shown = await reminders();
    // A+B (after lunch) in one notification, C (before lunch) on its own.
    expect(shown.length, 2);
    expect(shown.where((n) => n.body.contains('A') && n.body.contains('B')),
        hasLength(1));
  });

  test('switching the mode re-plans without leaving stale notifications',
      () async {
    await fixedMedication('Panadol', '10:00');
    await fixedMedication('Augmentin', '10:00');
    expect((await reminders()).length, 1);
    await h.settings.set(SettingKeys.notificationGrouping, 'separate');
    await engine.sync(languageCode: 'en');
    final active = notifier.details.keys
        .where((id) => !notifier.cancelled.contains(id))
        .length;
    expect(active, greaterThanOrEqualTo(2));
  });
}
