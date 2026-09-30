import '../../../core/errors/domain_exceptions.dart';

/// Dose state machine (spec §9). "Late" is not a state; it is derived from
/// `late_minutes`.
enum DoseStatus {
  scheduled('SCHEDULED'),
  taken('TAKEN'),
  missed('MISSED'),
  skipped('SKIPPED');

  const DoseStatus(this.code);

  final String code;

  static DoseStatus fromCode(String code) => DoseStatus.values.firstWhere(
        (s) => s.code == code,
        orElse: () => DoseStatus.scheduled,
      );

  bool get isTerminal => this == missed || this == skipped;

  static const _allowed = {
    DoseStatus.scheduled: {
      DoseStatus.taken,
      DoseStatus.missed,
      DoseStatus.skipped
    },
    DoseStatus.taken: {DoseStatus.scheduled},
    DoseStatus.missed: <DoseStatus>{},
    DoseStatus.skipped: <DoseStatus>{},
  };

  bool canTransitionTo(DoseStatus next) => _allowed[this]!.contains(next);

  void ensureCanTransitionTo(DoseStatus next) {
    if (!canTransitionTo(next)) {
      throw InvalidDoseTransitionException(code, next.code);
    }
  }
}

/// Minutes a dose was taken after its scheduled time (never negative).
int calculateLateMinutes(DateTime scheduledAt, DateTime takenAt) {
  final minutes = takenAt.toUtc().difference(scheduledAt.toUtc()).inMinutes;
  return minutes > 0 ? minutes : 0;
}

/// Whether a still-scheduled dose has passed its grace window.
bool isPastGraceWindow({
  required DateTime scheduledAt,
  required DateTime now,
  required int graceMinutes,
}) =>
    now.toUtc().isAfter(
          scheduledAt.toUtc().add(Duration(minutes: graceMinutes)),
        );

/// Late threshold for classifying "taken on time" vs "taken late" in reports.
const onTimeToleranceMinutes = 30;

bool isTakenLate(int? lateMinutes) =>
    (lateMinutes ?? 0) > onTimeToleranceMinutes;

/// How far before the scheduled time an intake may be recorded (e.g. a dose
/// taken early with breakfast).
const earlyIntakeWindow = Duration(hours: 12);

/// A dose counts as "recorded later" when it was logged more than this long
/// after the actual intake.
const recordedLaterThreshold = Duration(minutes: 5);

bool isRecordedLater(DateTime takenAt, DateTime loggedAt) =>
    loggedAt.toUtc().difference(takenAt.toUtc()) > recordedLaterThreshold;

/// Validates an intake time recorded after the fact. The intake must not be
/// in the future, not unreasonably early, and — for scheduled doses — within
/// the grace window, so a truly missed dose can never become "taken".
void validateIntakeTime({
  required DateTime scheduledAt,
  required DateTime takenAt,
  required DateTime now,
  required int? graceMinutes,
}) {
  final intake = takenAt.toUtc();
  if (intake.isAfter(now.toUtc().add(const Duration(minutes: 1)))) {
    throw const ValidationException('takenInFuture');
  }
  if (intake.isBefore(scheduledAt.toUtc().subtract(earlyIntakeWindow))) {
    throw const ValidationException('takenTooEarly');
  }
  if (graceMinutes != null &&
      isPastGraceWindow(
        scheduledAt: scheduledAt,
        now: intake,
        graceMinutes: graceMinutes,
      )) {
    throw const DoseWindowClosedException();
  }
}
