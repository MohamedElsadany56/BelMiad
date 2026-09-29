import 'package:timezone/timezone.dart' as tz;

import 'local_date.dart';

const defaultTimezone = 'Africa/Cairo';

/// Converts between UTC instants and a patient's local wall clock.
///
/// Recurring schedules are wall-clock based: when the patient's timezone
/// changes, the same local time is preserved and a new UTC instant results.
class PatientTime {
  PatientTime(String timezone) : location = _resolve(timezone);

  final tz.Location location;

  static tz.Location _resolve(String name) {
    try {
      return tz.getLocation(name);
    } catch (_) {
      try {
        return tz.getLocation(defaultTimezone);
      } catch (_) {
        return tz.UTC;
      }
    }
  }

  static bool isValidTimezone(String name) {
    try {
      tz.getLocation(name);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// UTC instant for a wall-clock [minutesOfDay] on [date].
  ///
  /// Minutes outside `0..1439` roll into the previous/next day, which is how
  /// "30 minutes before a 00:15 breakfast" is represented.
  DateTime toUtc(LocalDate date, int minutesOfDay) {
    final local = tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      0,
      minutesOfDay,
    );
    return local.toUtc();
  }

  tz.TZDateTime toLocal(DateTime instant) =>
      tz.TZDateTime.from(instant.toUtc(), location);

  LocalDate localDateOf(DateTime instant) {
    final local = toLocal(instant);
    return LocalDate(local.year, local.month, local.day);
  }

  LocalTime localTimeOf(DateTime instant) {
    final local = toLocal(instant);
    return LocalTime(local.hour, local.minute);
  }

  LocalDate today(DateTime nowUtc) => localDateOf(nowUtc);
}
