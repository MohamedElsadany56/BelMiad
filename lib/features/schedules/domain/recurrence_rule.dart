enum RecurrenceType { daily, weekly, everyNDays }

class RecurrenceRule {
  const RecurrenceRule({required this.type, this.weekdays = const {}, this.interval = 1});
  final RecurrenceType type;
  final Set<int> weekdays;
  final int interval;

  bool occursOn(DateTime date, {DateTime? anchor}) {
    switch (type) {
      case RecurrenceType.daily: return true;
      case RecurrenceType.weekly: return weekdays.isEmpty || weekdays.contains(date.weekday);
      case RecurrenceType.everyNDays:
        final base = anchor ?? date;
        return date.difference(DateTime(base.year, base.month, base.day)).inDays % interval == 0;
    }
  }
}
