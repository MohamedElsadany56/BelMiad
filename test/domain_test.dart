import 'package:belmiad/core/errors/domain_exceptions.dart';
import 'package:belmiad/core/time/local_date.dart';
import 'package:belmiad/core/time/patient_time.dart';
import 'package:belmiad/core/utilities/scaled_quantity.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/inventory/domain/batch_selection.dart';
import 'package:belmiad/features/inventory/domain/stock_forecast.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:belmiad/features/schedules/domain/schedule_plan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

void main() {
  tzdata.initializeTimeZones();

  group('ScaledQuantity', () {
    test('parses fractional input without floating point', () {
      expect(ScaledQuantity.tryParse('0.25')!.scaled, 250);
      expect(ScaledQuantity.tryParse('1.5')!.scaled, 1500);
      expect(ScaledQuantity.tryParse('½')!.scaled, 500);
      expect(ScaledQuantity.tryParse('1,5')!.scaled, 1500);
      expect(ScaledQuantity.tryParse('٢')!.scaled, 2000);
      expect(ScaledQuantity.tryParse('0.0001'), isNull);
      expect(ScaledQuantity.tryParse('abc'), isNull);
    });

    test('arithmetic and formatting', () {
      const a = ScaledQuantity(250);
      const b = ScaledQuantity(500);
      expect((a + b).scaled, 750);
      expect((b - a).format(), '0.25');
      expect(const ScaledQuantity(2000).format(), '2');
      expect(const ScaledQuantity(1500).format(), '1.5');
    });

    test('package conversion: 2 boxes × 20 tablets = 40 tablets', () {
      expect(
        ScaledQuantity.fromPackages(packages: 2, unitsPerPackage: 20).scaled,
        40000,
      );
    });
  });

  group('RecurrenceRule', () {
    const anchor = LocalDate(2026, 9, 28); // Monday

    test('daily', () {
      const rule = RecurrenceRule();
      expect(rule.occursOn(anchor.addDays(5), fallbackAnchor: anchor), isTrue);
    });

    test('selected weekdays', () {
      const rule = RecurrenceRule(type: RecurrenceType.weekly, weekdays: [1, 3]);
      expect(rule.occursOn(anchor, fallbackAnchor: anchor), isTrue);
      expect(rule.occursOn(anchor.addDays(1), fallbackAnchor: anchor), isFalse);
      expect(rule.occursOn(anchor.addDays(2), fallbackAnchor: anchor), isTrue);
    });

    test('every other week', () {
      const rule = RecurrenceRule(
        type: RecurrenceType.weekly,
        weekdays: [1],
        interval: 2,
      );
      expect(rule.occursOn(anchor, fallbackAnchor: anchor), isTrue);
      expect(rule.occursOn(anchor.addDays(7), fallbackAnchor: anchor), isFalse);
      expect(rule.occursOn(anchor.addDays(14), fallbackAnchor: anchor), isTrue);
    });

    test('every N days', () {
      const rule = RecurrenceRule(type: RecurrenceType.everyNDays, interval: 3);
      expect(rule.occursOn(anchor, fallbackAnchor: anchor), isTrue);
      expect(rule.occursOn(anchor.addDays(1), fallbackAnchor: anchor), isFalse);
      expect(rule.occursOn(anchor.addDays(3), fallbackAnchor: anchor), isTrue);
      expect(rule.occursOn(anchor.addDays(-3), fallbackAnchor: anchor), isFalse);
    });

    test('custom cycle: 21 days on, 7 days off', () {
      const rule = RecurrenceRule(
        type: RecurrenceType.cycle,
        onDays: 21,
        offDays: 7,
      );
      expect(rule.occursOn(anchor.addDays(20), fallbackAnchor: anchor), isTrue);
      expect(rule.occursOn(anchor.addDays(21), fallbackAnchor: anchor), isFalse);
      expect(rule.occursOn(anchor.addDays(27), fallbackAnchor: anchor), isFalse);
      expect(rule.occursOn(anchor.addDays(28), fallbackAnchor: anchor), isTrue);
    });

    test('different quantities by weekday', () {
      const rule = RecurrenceRule(weekdayQuantities: {'5': 2000});
      expect(rule.quantityOn(anchor, 1000), 1000);
      expect(rule.quantityOn(const LocalDate(2026, 10, 2), 1000), 2000);
    });

    test('JSON round trip', () {
      const rule = RecurrenceRule(
        type: RecurrenceType.weekly,
        weekdays: [2, 4],
        weekdayQuantities: {'2': 500},
      );
      expect(RecurrenceRule.decode(rule.encode()), rule);
    });
  });

  group('Meal timing', () {
    test('before, with and after meal offsets', () {
      const breakfast = LocalTime(8, 0);
      expect(
        mealRelativeMinutes(
          mealTime: breakfast,
          relation: TimingRelation.before,
          offsetMinutes: 30,
        ),
        7 * 60 + 30,
      );
      expect(
        mealRelativeMinutes(
          mealTime: const LocalTime(14, 0),
          relation: TimingRelation.after,
          offsetMinutes: 45,
        ),
        14 * 60 + 45,
      );
      expect(
        mealRelativeMinutes(
          mealTime: breakfast,
          relation: TimingRelation.withMeal,
          offsetMinutes: 99,
        ),
        8 * 60,
      );
    });

    test('meal without configured time uses its default', () {
      expect(effectiveMealTime('lunch', null), const LocalTime(14, 0));
      expect(effectiveMealTime('lunch', '13:15'), const LocalTime(13, 15));
    });
  });

  group('Dose state machine', () {
    test('allowed transitions', () {
      expect(DoseStatus.scheduled.canTransitionTo(DoseStatus.taken), isTrue);
      expect(DoseStatus.scheduled.canTransitionTo(DoseStatus.missed), isTrue);
      expect(DoseStatus.scheduled.canTransitionTo(DoseStatus.skipped), isTrue);
      expect(DoseStatus.taken.canTransitionTo(DoseStatus.scheduled), isTrue);
    });

    test('missed and skipped are terminal', () {
      expect(DoseStatus.missed.canTransitionTo(DoseStatus.taken), isFalse);
      expect(DoseStatus.skipped.canTransitionTo(DoseStatus.taken), isFalse);
      expect(
        () => DoseStatus.missed.ensureCanTransitionTo(DoseStatus.taken),
        throwsA(isA<InvalidDoseTransitionException>()),
      );
    });

    test('late minutes are calculated, never negative', () {
      final scheduled = DateTime.utc(2026, 1, 1, 8);
      expect(calculateLateMinutes(scheduled, scheduled.add(const Duration(minutes: 47))), 47);
      expect(calculateLateMinutes(scheduled, scheduled.subtract(const Duration(minutes: 5))), 0);
      expect(isTakenLate(20), isFalse);
      expect(isTakenLate(45), isTrue);
    });

    test('missed calculation uses the grace window', () {
      final scheduled = DateTime.utc(2026, 1, 1, 8);
      expect(
        isPastGraceWindow(
          scheduledAt: scheduled,
          now: scheduled.add(const Duration(minutes: 179)),
          graceMinutes: 180,
        ),
        isFalse,
      );
      expect(
        isPastGraceWindow(
          scheduledAt: scheduled,
          now: scheduled.add(const Duration(minutes: 181)),
          graceMinutes: 180,
        ),
        isTrue,
      );
    });
  });

  group('FEFO batch selection', () {
    const today = LocalDate(2026, 9, 28);
    final batches = [
      const BatchSnapshot(
        id: 'b',
        availableScaled: 10000,
        expirationDate: LocalDate(2027, 2, 1),
      ),
      const BatchSnapshot(
        id: 'a',
        availableScaled: 2000,
        expirationDate: LocalDate(2026, 10, 1),
      ),
      const BatchSnapshot(
        id: 'expired',
        availableScaled: 50000,
        expirationDate: LocalDate(2026, 9, 1),
      ),
      const BatchSnapshot(id: 'no-expiry', availableScaled: 5000),
    ];

    test('orders by earliest expiration, excluding expired stock', () {
      expect(fefoOrder(batches, today).map((b) => b.id), ['a', 'b', 'no-expiry']);
    });

    test('one dose can span multiple batches', () {
      expect(
        allocateFefo(batches, requiredScaled: 5000, today: today),
        const [
          BatchAllocation(batchId: 'a', quantityScaled: 2000),
          BatchAllocation(batchId: 'b', quantityScaled: 3000),
        ],
      );
    });

    test('ties break on purchase date then stable ID', () {
      final tied = [
        const BatchSnapshot(
          id: 'z',
          availableScaled: 1000,
          expirationDate: LocalDate(2027, 1, 1),
          purchaseDate: LocalDate(2026, 1, 1),
        ),
        const BatchSnapshot(
          id: 'y',
          availableScaled: 1000,
          expirationDate: LocalDate(2027, 1, 1),
          purchaseDate: LocalDate(2026, 1, 1),
        ),
        const BatchSnapshot(
          id: 'x',
          availableScaled: 1000,
          expirationDate: LocalDate(2027, 1, 1),
          purchaseDate: LocalDate(2026, 3, 1),
        ),
      ];
      expect(fefoOrder(tied, today).map((b) => b.id), ['y', 'z', 'x']);
    });

    test('batch expiring today is still usable', () {
      const batch = BatchSnapshot(
        id: 't',
        availableScaled: 1000,
        expirationDate: today,
      );
      expect(batch.isUsableOn(today), isTrue);
      expect(batch.isUsableOn(today.addDays(1)), isFalse);
    });

    test('insufficient stock is reported, expired stock never used', () {
      expect(
        () => allocateFefo(batches, requiredScaled: 20000, today: today),
        throwsA(
          isA<InsufficientStockException>()
              .having((e) => e.availableScaled, 'available', 17000),
        ),
      );
    });

    test('manual allocation must be usable and match the total', () {
      expect(
        validateManualAllocation(
          batches,
          const [BatchAllocation(batchId: 'b', quantityScaled: 2000)],
          requiredScaled: 2000,
          today: today,
        ).single.manuallySelected,
        isTrue,
      );
      expect(
        () => validateManualAllocation(
          batches,
          const [BatchAllocation(batchId: 'expired', quantityScaled: 1000)],
          requiredScaled: 1000,
          today: today,
        ),
        throwsA(isA<ValidationException>()),
      );
      expect(
        () => validateManualAllocation(
          batches,
          const [BatchAllocation(batchId: 'a', quantityScaled: 1000)],
          requiredScaled: 2000,
          today: today,
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('Stock forecast', () {
    final time = PatientTime('Africa/Cairo');
    // 2026-09-28 00:30 Cairo, before any dose that day.
    final now = DateTime.utc(2026, 9, 27, 21, 30);
    const today = LocalDate(2026, 9, 28);

    SchedulePlan plan({
      int minutes = 8 * 60,
      int quantity = 1000,
      RecurrenceRule rule = const RecurrenceRule(),
      String id = 's1',
    }) =>
        SchedulePlan(
          scheduleId: id,
          medicationId: 'm',
          minutesOfDay: minutes,
          doseQuantityScaled: quantity,
          rule: rule,
          anchor: today,
        );

    test('no batches means stock not recorded (different from zero)', () {
      final summary = const StockForecaster().summarize(
        batches: const [],
        plans: [plan()],
        now: now,
        time: time,
      );
      expect(summary.state, StockState.noStockRecorded);
      expect(summary.stockRecorded, isFalse);
    });

    test('zero stock is EMPTY', () {
      final summary = const StockForecaster().summarize(
        batches: const [BatchSnapshot(id: 'a', availableScaled: 0)],
        plans: [plan()],
        now: now,
        time: time,
      );
      expect(summary.state, StockState.empty);
    });

    test('low stock uses the upcoming 3-day requirement', () {
      // 2 tablets/day → 6 needed over 3 days.
      final plans = [plan(), plan(id: 's2', minutes: 20 * 60)];
      final low = const StockForecaster().summarize(
        batches: const [BatchSnapshot(id: 'a', availableScaled: 5000)],
        plans: plans,
        now: now,
        time: time,
      );
      expect(low.projectedThreeDayScaled, 6000);
      expect(low.state, StockState.low);
      final normal = const StockForecaster().summarize(
        batches: const [BatchSnapshot(id: 'a', availableScaled: 6000)],
        plans: plans,
        now: now,
        time: time,
      );
      expect(normal.state, StockState.normal);
    });

    test('remaining days simulate irregular schedules (spec §22)', () {
      // Day quantities 2,1,2,2,1,2,... via weekday overrides; stock 10.
      final quantities = [2000, 1000, 2000, 2000, 1000, 2000, 2000];
      final rule = RecurrenceRule(weekdayQuantities: {
        for (var i = 0; i < 7; i++)
          '${today.addDays(i).weekday}': quantities[i],
      });
      final summary = const StockForecaster().summarize(
        batches: const [BatchSnapshot(id: 'a', availableScaled: 10000)],
        plans: [plan(rule: rule)],
        now: now,
        time: time,
      );
      expect(summary.remainingDays, 6);
    });

    test('PRN without planned frequency has no forecast', () {
      final summary = const StockForecaster().summarize(
        batches: const [BatchSnapshot(id: 'a', availableScaled: 1000)],
        plans: const [],
        now: now,
        time: time,
      );
      expect(summary.remainingDays, isNull);
      expect(summary.projectedThreeDayScaled, 0);
      expect(summary.isLowStock, isFalse);
    });

    test('expiration states and LOW + EXPIRING SOON together', () {
      expect(
        expirationStateOf(today, today: today, expiringWithinDays: 30),
        ExpirationState.expiresToday,
      );
      expect(
        expirationStateOf(today.addDays(-1), today: today, expiringWithinDays: 30),
        ExpirationState.expired,
      );
      expect(
        expirationStateOf(today.addDays(10), today: today, expiringWithinDays: 30),
        ExpirationState.expiresSoon,
      );
      expect(
        expirationStateOf(today.addDays(40), today: today, expiringWithinDays: 30),
        ExpirationState.none,
      );
      final summary = const StockForecaster().summarize(
        batches: [
          BatchSnapshot(
            id: 'a',
            availableScaled: 1000,
            expirationDate: today.addDays(10),
          ),
        ],
        plans: [plan()],
        now: now,
        time: time,
      );
      expect(summary.isLowStock, isTrue);
      expect(summary.hasExpiringBatch, isTrue);
    });

    test('only expired stock is EXPIRED_ONLY and stays visible', () {
      final summary = const StockForecaster().summarize(
        batches: [
          BatchSnapshot(
            id: 'a',
            availableScaled: 3000,
            expirationDate: today.addDays(-2),
          ),
        ],
        plans: [plan()],
        now: now,
        time: time,
      );
      expect(summary.state, StockState.expiredOnly);
      expect(summary.expiredScaled, 3000);
    });
  });

  group('Patient timezone', () {
    test('same wall-clock time is preserved when timezone changes', () {
      const date = LocalDate(2026, 12, 1);
      final cairo = PatientTime('Africa/Cairo').toUtc(date, 8 * 60);
      final dubai = PatientTime('Asia/Dubai').toUtc(date, 8 * 60);
      expect(cairo, DateTime.utc(2026, 12, 1, 6));
      expect(dubai, DateTime.utc(2026, 12, 1, 4));
    });

    test('plan expansion respects start and end dates', () {
      const start = LocalDate(2026, 9, 28);
      final plan = SchedulePlan(
        scheduleId: 's',
        medicationId: 'm',
        minutesOfDay: 480,
        doseQuantityScaled: 1000,
        rule: const RecurrenceRule(),
        anchor: start,
        medicationEnd: start.addDays(2),
      );
      final doses = expandPlans(
        [plan],
        from: start,
        to: start.addDays(10),
        time: PatientTime('Africa/Cairo'),
      );
      expect(doses, hasLength(3));
    });
  });
}
