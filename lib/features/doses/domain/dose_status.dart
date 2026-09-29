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
    DoseStatus.scheduled: {DoseStatus.taken, DoseStatus.missed, DoseStatus.skipped},
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
