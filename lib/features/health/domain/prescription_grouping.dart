import '../../../core/time/local_date.dart';

/// Prescriptions issued in one calendar month.
class MonthGroup<T> {
  const MonthGroup({required this.month, required this.items});

  /// First day of the month, or null for prescriptions without a date.
  final LocalDate? month;
  final List<T> items;
}

/// Groups [items] by the month of their ISO issue date.
///
/// The order is chronological (newest month first, undated last) and comes
/// from the dates themselves, never from the localized month names, so it is
/// the same in every language. Inside a month the newest prescription comes
/// first; ties keep the incoming order.
List<MonthGroup<T>> groupByIssueMonth<T>(
  Iterable<T> items,
  String? Function(T item) issueDateOf,
) {
  final dated = <(LocalDate, T)>[];
  final undated = <T>[];
  for (final item in items) {
    final date = LocalDate.tryParse(issueDateOf(item));
    if (date == null) {
      undated.add(item);
    } else {
      dated.add((date, item));
    }
  }
  // List.sort is not stable: sort by date, then by original position.
  final indexed = [
    for (var i = 0; i < dated.length; i++) (i, dated[i].$1, dated[i].$2),
  ]..sort((a, b) {
      final byDate = b.$2.compareTo(a.$2);
      return byDate != 0 ? byDate : a.$1.compareTo(b.$1);
    });
  final groups = <MonthGroup<T>>[];
  LocalDate? currentMonth;
  var current = <T>[];
  for (final (_, date, item) in indexed) {
    final month = LocalDate(date.year, date.month, 1);
    if (currentMonth != month) {
      if (currentMonth != null) {
        groups.add(MonthGroup(month: currentMonth, items: current));
      }
      currentMonth = month;
      current = [];
    }
    current.add(item);
  }
  if (currentMonth != null) {
    groups.add(MonthGroup(month: currentMonth, items: current));
  }
  if (undated.isNotEmpty) {
    groups.add(MonthGroup(month: null, items: undated));
  }
  return groups;
}
