import 'package:belmiad/core/errors/domain_exceptions.dart';
import 'package:belmiad/core/settings/settings_repository.dart';
import 'package:belmiad/features/doses/domain/dose_grouping.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

DoseGroupInput _fixed(String id, DateTime at) => DoseGroupInput(
      patientId: 'p',
      localDate: '2026-09-28',
      scheduledAt: at,
    );

DoseGroupInput _meal(String meal, String relation, DateTime at) =>
    DoseGroupInput(
      patientId: 'p',
      localDate: '2026-09-28',
      scheduledAt: at,
      mealId: meal,
      timingRelation: relation,
    );

void main() {
  group('doseGroupKey (pure rule)', () {
    final eight = DateTime.utc(2026, 9, 28, 5);

    test('same exact time shares a group', () {
      expect(
          doseGroupKey(_fixed('a', eight)), doseGroupKey(_fixed('b', eight)));
    });

    test('seconds do not split a minute', () {
      expect(
        doseGroupKey(_fixed('a', eight)),
        doseGroupKey(_fixed('b', eight.add(const Duration(seconds: 20)))),
      );
    });

    test('different times are different groups', () {
      expect(
        doseGroupKey(_fixed('a', eight)),
        isNot(doseGroupKey(_fixed('b', eight.add(const Duration(minutes: 1))))),
      );
    });

    test('same meal event shares a group even with different offsets', () {
      final a =
          _meal('breakfast', 'after', eight.add(const Duration(minutes: 30)));
      final b =
          _meal('breakfast', 'after', eight.add(const Duration(minutes: 45)));
      expect(doseGroupKey(a), doseGroupKey(b));
    });

    test('before / after / with the same meal stay separate', () {
      final keys = {
        for (final r in ['before', 'after', 'with'])
          doseGroupKey(_meal('breakfast', r, eight)),
      };
      expect(keys, hasLength(3));
    });

    test('different meals stay separate even at the same clock time', () {
      expect(
        doseGroupKey(_meal('lunch', 'after', eight)),
        isNot(doseGroupKey(_meal('dinner', 'after', eight))),
      );
    });

    test('a fixed-time dose never merges with a meal-relative one', () {
      expect(
        doseGroupKey(_fixed('a', eight)),
        isNot(doseGroupKey(_meal('breakfast', 'after', eight))),
      );
    });

    test('different days never share a group', () {
      final today = _meal('breakfast', 'after', eight);
      final tomorrow = DoseGroupInput(
        patientId: 'p',
        localDate: '2026-09-29',
        scheduledAt: eight.add(const Duration(days: 1)),
        mealId: 'breakfast',
        timingRelation: 'after',
      );
      expect(doseGroupKey(today), isNot(doseGroupKey(tomorrow)));
    });

    test('PRN doses are never grouped', () {
      final prn = DoseGroupInput(
        patientId: 'p',
        localDate: '2026-09-28',
        scheduledAt: eight,
        isPrn: true,
      );
      expect(doseGroupKey(prn), isNull);
    });

    test('groupDoses keeps order and makes singletons of PRN doses', () {
      final items = [
        ('a', _fixed('a', eight)),
        ('b', _fixed('b', eight.add(const Duration(hours: 1)))),
        ('c', _fixed('c', eight)),
        (
          'prn',
          DoseGroupInput(
            patientId: 'p',
            localDate: '2026-09-28',
            scheduledAt: eight,
            isPrn: true,
          )
        ),
      ];
      final groups = groupDoses(items, (i) => i.$2);
      expect(
        [for (final g in groups) g.map((i) => i.$1).toList()],
        [
          ['a', 'c'],
          ['b'],
          ['prn'],
        ],
      );
    });
  });

  group('combined dose completion (use case)', () {
    late TestHarness h;
    late String patientId;

    // 2026-09-28 09:00 in Cairo.
    setUp(() async {
      h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
      await h.createCaregiver();
      patientId = await h.createPatient();
    });

    tearDown(() => h.close());

    Future<String> fixedMedication(String name, List<String> times) async {
      final id = await h.createMedication(patientId, name: name);
      await h.schedules.saveGroup(
        medicationId: id,
        slots: [
          for (final time in times)
            ScheduleSlot(
              scheduleType: ScheduleTypes.fixedTime,
              fixedTime: time,
              doseQuantityScaled: 1000,
            ),
        ],
        rule: const RecurrenceRule(),
      );
      return id;
    }

    Future<String> mealMedication(
      String name,
      String mealType,
      TimingRelation relation,
    ) async {
      final id = await h.createMedication(patientId, name: name);
      final meal = (await h.meals.listForPatient(patientId))
          .firstWhere((m) => m.mealType == mealType);
      await h.schedules.saveGroup(
        medicationId: id,
        slots: [
          ScheduleSlot(
            scheduleType: ScheduleTypes.mealRelative,
            mealId: meal.mealId,
            timingRelation: timingRelationCode(relation),
            offsetMinutes: relation == TimingRelation.withMeal ? 0 : 30,
            doseQuantityScaled: 1000,
          ),
        ],
        rule: const RecurrenceRule(),
      );
      return id;
    }

    Future<String> doseOf(String medicationId,
        {String date = '2026-09-28'}) async {
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      return (await h.allDoses(patientId))
          .firstWhere(
            (d) => d.medicationId == medicationId && d.localDate == date,
          )
          .doseInstanceId;
    }

    test('same exact time: taking A completes B and C, not D', () async {
      final a = await fixedMedication('A', ['10:00']);
      final b = await fixedMedication('B', ['10:00']);
      final c = await fixedMedication('C', ['10:00']);
      final d = await fixedMedication('D', ['11:00']);
      final doseA = await doseOf(a);
      final doseB = await doseOf(b);
      final doseC = await doseOf(c);
      final doseD = await doseOf(d);

      expect(
        await h.doses.groupMateIds(doseA),
        unorderedEquals([doseB, doseC]),
      );

      await h.doses.takeDose(doseInstanceId: doseA, actualQuantityScaled: 1000);
      final result = await h.doses.completeGroupMates(primaryDoseId: doseA);

      expect(result.taken, unorderedEquals([doseB, doseC]));
      expect(result.failed, isEmpty);
      for (final id in [doseA, doseB, doseC]) {
        expect((await h.dose(id)).status, DoseStatus.taken.code);
      }
      expect((await h.dose(doseD)).status, DoseStatus.scheduled.code);
    });

    test('separate mode: only the dose that was taken changes', () async {
      final a = await fixedMedication('A', ['10:00']);
      final b = await fixedMedication('B', ['10:00']);
      final doseA = await doseOf(a);
      final doseB = await doseOf(b);

      // "Separate" is the absence of completeGroupMates: the setting is read
      // by the callers (sheet, notification button).
      const mode = GroupingMode.separate;
      await h.doses.takeDose(doseInstanceId: doseA, actualQuantityScaled: 1000);
      if (mode.isCombined) {
        await h.doses.completeGroupMates(primaryDoseId: doseA);
      }

      expect((await h.dose(doseA)).status, DoseStatus.taken.code);
      expect((await h.dose(doseB)).status, DoseStatus.scheduled.code);
    });

    test('the settings default to combined and persist both modes', () async {
      expect(
          (await h.settings.load()).doseCompletionMode, GroupingMode.combined);
      expect(
        (await h.settings.load()).notificationGrouping,
        GroupingMode.combined,
      );
      await h.settings.set(SettingKeys.doseCompletionMode, 'separate');
      await h.settings.set(SettingKeys.notificationGrouping, 'separate');
      final loaded = await h.settings.load();
      expect(loaded.doseCompletionMode, GroupingMode.separate);
      expect(loaded.notificationGrouping, GroupingMode.separate);
    });

    test('meal events: after breakfast vs before lunch stay separate',
        () async {
      final a = await mealMedication('A', 'breakfast', TimingRelation.after);
      final b = await mealMedication('B', 'breakfast', TimingRelation.after);
      final c = await mealMedication('C', 'breakfast', TimingRelation.before);
      final d = await mealMedication('D', 'lunch', TimingRelation.after);
      final e = await mealMedication('E', 'lunch', TimingRelation.before);
      // Doses are generated for the next day (breakfast has passed today).
      const day = '2026-09-29';
      final doseA = await doseOf(a, date: day);
      final doseB = await doseOf(b, date: day);
      final doseC = await doseOf(c, date: day);
      final doseD = await doseOf(d, date: day);
      final doseE = await doseOf(e, date: day);

      expect(await h.doses.groupMateIds(doseA), [doseB]);
      expect(await h.doses.groupMateIds(doseC), isEmpty);
      expect(await h.doses.groupMateIds(doseD), isEmpty);
      expect(await h.doses.groupMateIds(doseE), isEmpty);
    });

    test('multiple schedules of one medication group per time slot', () async {
      final a = await fixedMedication('A', ['10:00', '14:00', '20:00']);
      final b = await fixedMedication('B', ['14:00']);
      await h.generation.syncPatient(patientId, graceMinutes: 180);
      final doses = await h.allDoses(patientId);
      String at(String medicationId, int utcHour) => doses
          .firstWhere((d) =>
              d.medicationId == medicationId &&
              d.localDate == '2026-09-28' &&
              d.scheduledAt.toUtc().hour == utcHour)
          .doseInstanceId;
      final a14 = at(a, 11);
      final b14 = at(b, 11);
      final a10 = at(a, 7);

      expect(await h.doses.groupMateIds(a14), [b14]);
      expect(await h.doses.groupMateIds(a10), isEmpty);
    });

    test('a mate that cannot be completed is left as it was', () async {
      final a = await fixedMedication('A', ['10:00']);
      final b = await fixedMedication('B', ['10:00']);
      final doseA = await doseOf(a);
      final doseB = await doseOf(b);
      // B has recorded stock that cannot cover the dose.
      await h.inventory.addBatch(BatchInput(
        medicationId: b,
        quantityScaled: 500,
      ));

      await h.doses.takeDose(doseInstanceId: doseA, actualQuantityScaled: 1000);
      final result = await h.doses.completeGroupMates(primaryDoseId: doseA);

      expect(result.taken, isEmpty);
      expect(result.failed, [doseB]);
      expect((await h.dose(doseA)).status, DoseStatus.taken.code);
      expect((await h.dose(doseB)).status, DoseStatus.scheduled.code);
      expect(
          (await h.batch((await h.inventory.getBatchesForMedication(b))
                  .single
                  .inventoryBatchId))
              .availableQuantityScaled,
          500);
    });

    test('mates consume their own stock (FEFO) when completed', () async {
      final a = await fixedMedication('A', ['10:00']);
      final b = await fixedMedication('B', ['10:00']);
      final doseA = await doseOf(a);
      await doseOf(b);
      final batchId = await h.inventory.addBatch(BatchInput(
        medicationId: b,
        quantityScaled: 5000,
      ));

      await h.doses.takeDose(doseInstanceId: doseA, actualQuantityScaled: 1000);
      await h.doses.completeGroupMates(primaryDoseId: doseA);

      expect((await h.batch(batchId)).availableQuantityScaled, 4000);
    });

    test('PRN doses and doses of taken groups have no mates', () async {
      final prn = await h.createMedication(patientId, name: 'P', prn: true);
      final id = await h.doses.logPrnDose(
        medicationId: prn,
        actualQuantityScaled: 1000,
      );
      expect(await h.doses.groupMateIds(id), isEmpty);
      expect(
        () => h.doses.takeDose(doseInstanceId: id, actualQuantityScaled: 1000),
        throwsA(isA<DomainException>()),
      );
    });
  });
}
