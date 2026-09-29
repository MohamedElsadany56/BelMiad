import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../schedules/domain/schedule_plan.dart';
import 'batch_selection.dart';

/// Derived stock state (spec §23). Computed in one place only.
enum StockState {
  noStockRecorded,
  empty,
  expiredOnly,
  low,
  expiringSoon,
  normal,
}

enum ExpirationState { none, expired, expiresToday, expiresSoon }

ExpirationState expirationStateOf(
  LocalDate? expirationDate, {
  required LocalDate today,
  required int expiringWithinDays,
}) {
  if (expirationDate == null) return ExpirationState.none;
  if (expirationDate.isBefore(today)) return ExpirationState.expired;
  if (expirationDate == today) return ExpirationState.expiresToday;
  if (today.daysUntil(expirationDate) <= expiringWithinDays) {
    return ExpirationState.expiresSoon;
  }
  return ExpirationState.none;
}

class StockSummary {
  const StockSummary({
    required this.state,
    required this.stockRecorded,
    required this.usableScaled,
    required this.expiredScaled,
    required this.projectedThreeDayScaled,
    required this.remainingDays,
    required this.dailyRequirementScaled,
    required this.activeBatchCount,
    required this.isLowStock,
    required this.isEmpty,
    required this.hasExpiredBatch,
    required this.hasExpiringBatch,
    required this.earliestExpiration,
  });

  final StockState state;

  /// False means "stock not recorded", which is different from zero stock.
  final bool stockRecorded;
  final int usableScaled;
  final int expiredScaled;
  final int projectedThreeDayScaled;

  /// Number of whole days the usable stock covers following the real future
  /// schedule; null when there is no scheduled requirement (e.g. PRN).
  final int? remainingDays;

  /// Average scheduled requirement per day over the next week.
  final int dailyRequirementScaled;
  final int activeBatchCount;
  final bool isLowStock;
  final bool isEmpty;
  final bool hasExpiredBatch;
  final bool hasExpiringBatch;
  final LocalDate? earliestExpiration;

  int get totalScaled => usableScaled + expiredScaled;
}

/// Forecasts stock from actual future schedules (spec §21–§24).
///
/// PRN usage is never invented: callers must pass only non-PRN plans.
class StockForecaster {
  const StockForecaster({
    this.lowStockHorizon = const Duration(days: 3),
    this.simulationDays = 730,
  });

  final Duration lowStockHorizon;
  final int simulationDays;

  StockSummary summarize({
    required List<BatchSnapshot> batches,
    required List<SchedulePlan> plans,
    required DateTime now,
    required PatientTime time,
    int expiringWithinDays = 30,
  }) {
    final today = time.today(now);
    final live = batches.where((b) => !b.isDeleted).toList();
    final stockRecorded = live.isNotEmpty;
    final usable = fefoOrder(live, today);
    final usableScaled = usable.fold(0, (s, b) => s + b.availableScaled);
    final expiredScaled = live
        .where((b) => b.availableScaled > 0 && b.isExpiredOn(today))
        .fold(0, (s, b) => s + b.availableScaled);

    var hasExpiring = false;
    LocalDate? earliest;
    for (final batch in usable) {
      final state = expirationStateOf(
        batch.expirationDate,
        today: today,
        expiringWithinDays: expiringWithinDays,
      );
      if (state == ExpirationState.expiresToday ||
          state == ExpirationState.expiresSoon) {
        hasExpiring = true;
      }
      final expiry = batch.expirationDate;
      if (expiry != null && (earliest == null || expiry.isBefore(earliest))) {
        earliest = expiry;
      }
    }

    final horizonEnd = now.toUtc().add(lowStockHorizon);
    final nearTerm = expandPlans(
      plans,
      from: today,
      to: time.localDateOf(horizonEnd).addDays(1),
      time: time,
    );
    final projected = nearTerm
        .where(
          (d) =>
              d.scheduledAt.isAfter(now.toUtc()) &&
              !d.scheduledAt.isAfter(horizonEnd),
        )
        .fold(0, (s, d) => s + d.quantityScaled);

    final weekDoses = expandPlans(
      plans,
      from: today,
      to: today.addDays(6),
      time: time,
    );
    final daily =
        (weekDoses.fold(0, (s, d) => s + d.quantityScaled) / 7).round();

    final remainingDays = _simulateRemainingDays(
      usable: usable,
      plans: plans,
      now: now,
      today: today,
      time: time,
    );

    final isEmpty = stockRecorded && usableScaled == 0 && expiredScaled == 0;
    final isLow = stockRecorded && usableScaled < projected;
    final StockState state;
    if (!stockRecorded) {
      state = StockState.noStockRecorded;
    } else if (isEmpty) {
      state = StockState.empty;
    } else if (usableScaled == 0) {
      state = StockState.expiredOnly;
    } else if (isLow) {
      state = StockState.low;
    } else if (hasExpiring) {
      state = StockState.expiringSoon;
    } else {
      state = StockState.normal;
    }

    return StockSummary(
      state: state,
      stockRecorded: stockRecorded,
      usableScaled: usableScaled,
      expiredScaled: expiredScaled,
      projectedThreeDayScaled: projected,
      remainingDays: remainingDays,
      dailyRequirementScaled: daily,
      activeBatchCount: usable.length,
      isLowStock: isLow,
      isEmpty: isEmpty || (stockRecorded && usableScaled == 0),
      hasExpiredBatch: expiredScaled > 0,
      hasExpiringBatch: hasExpiring,
      earliestExpiration: earliest,
    );
  }

  /// Simulates consumption day by day using the real future schedule and
  /// FEFO order, discarding batches as they expire. Returns how many whole
  /// days (today counting as day 1) are fully covered.
  int? _simulateRemainingDays({
    required List<BatchSnapshot> usable,
    required List<SchedulePlan> plans,
    required DateTime now,
    required LocalDate today,
    required PatientTime time,
  }) {
    if (plans.isEmpty) return null;
    final lastDay = today.addDays(simulationDays);
    final hasFutureDoses = expandPlans(
      plans,
      from: today,
      to: lastDay,
      time: time,
    ).any((d) => d.scheduledAt.isAfter(now.toUtc()));
    if (!hasFutureDoses) return null;

    final remaining = [
      for (final b in usable)
        _MutableBatch(b.expirationDate, b.availableScaled),
    ];
    var coveredDays = 0;
    for (var day = today; !day.isAfter(lastDay); day = day.addDays(1)) {
      final doses = expandPlans(plans, from: day, to: day, time: time)
          .where((d) => d.scheduledAt.isAfter(now.toUtc()));
      var required = doses.fold(0, (s, d) => s + d.quantityScaled);
      for (final batch in remaining) {
        if (required == 0) break;
        if (batch.expiration != null && batch.expiration!.isBefore(day)) {
          continue;
        }
        final take = required < batch.quantity ? required : batch.quantity;
        batch.quantity -= take;
        required -= take;
      }
      if (required > 0) return coveredDays;
      coveredDays++;
    }
    return coveredDays;
  }
}

class _MutableBatch {
  _MutableBatch(this.expiration, this.quantity);
  final LocalDate? expiration;
  int quantity;
}
