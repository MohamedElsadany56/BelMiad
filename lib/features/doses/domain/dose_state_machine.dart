enum DoseStatus { scheduled, taken, missed, skipped }

class DoseStateMachine {
  static bool canTransition(DoseStatus from, DoseStatus to) =>
      switch ((from, to)) {
        (DoseStatus.scheduled, DoseStatus.taken) => true,
        (DoseStatus.scheduled, DoseStatus.missed) => true,
        (DoseStatus.scheduled, DoseStatus.skipped) => true,
        (DoseStatus.taken, DoseStatus.scheduled) => true,
        _ => false,
      };

  static DoseStatus transition(DoseStatus from, DoseStatus to) {
    if (!canTransition(from, to)) {
      throw StateError('Invalid dose transition: $from → $to');
    }
    return to;
  }
}

