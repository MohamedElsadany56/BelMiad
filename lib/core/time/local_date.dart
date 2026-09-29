/// A calendar date with no time or timezone (`yyyy-MM-dd`).
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime value) =>
      LocalDate(value.year, value.month, value.day);

  static LocalDate? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(value);
    if (match == null) return null;
    return LocalDate(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    ).normalized();
  }

  static LocalDate parse(String value) =>
      tryParse(value) ?? (throw FormatException('Invalid date', value));

  final int year;
  final int month;
  final int day;

  DateTime get _utc => DateTime.utc(year, month, day);

  LocalDate normalized() => LocalDate.fromDateTime(_utc);

  /// ISO weekday: Monday = 1 ... Sunday = 7.
  int get weekday => _utc.weekday;

  LocalDate addDays(int days) =>
      LocalDate.fromDateTime(DateTime.utc(year, month, day + days));

  int daysUntil(LocalDate other) => other._utc.difference(_utc).inDays;

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// A `DateTime` in local device time at midnight, for date pickers.
  DateTime toDateTime() => DateTime(year, month, day);

  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}'
      '-${day.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}

/// A wall-clock time of day (`HH:mm`).
class LocalTime implements Comparable<LocalTime> {
  const LocalTime(this.hour, this.minute);

  factory LocalTime.fromMinutes(int minutes) {
    final normalized = ((minutes % 1440) + 1440) % 1440;
    return LocalTime(normalized ~/ 60, normalized % 60);
  }

  static LocalTime? tryParse(String? value) {
    if (value == null) return null;
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(value.trim());
    if (match == null) return null;
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) return null;
    return LocalTime(hour, minute);
  }

  final int hour;
  final int minute;

  int get minutesOfDay => hour * 60 + minute;

  String toHHmm() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalTime other) => minutesOfDay.compareTo(other.minutesOfDay);

  @override
  bool operator ==(Object other) =>
      other is LocalTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => toHHmm();
}
