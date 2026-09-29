import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/time/local_date.dart';

part 'recurrence_rule.freezed.dart';
part 'recurrence_rule.g.dart';

enum RecurrenceType {
  /// Every day.
  daily,

  /// Selected weekdays, every [RecurrenceRule.interval] weeks.
  weekly,

  /// Every N days from the anchor date.
  everyNDays,

  /// Custom cycle: [RecurrenceRule.onDays] active days followed by
  /// [RecurrenceRule.offDays] pause days, repeating from the anchor date.
  cycle,
}

/// Generic recurrence engine. Never inferred from sex/age; the user
/// configures the pattern explicitly (spec §7).
@freezed
abstract class RecurrenceRule with _$RecurrenceRule {
  const RecurrenceRule._();

  const factory RecurrenceRule({
    @Default(RecurrenceType.daily) RecurrenceType type,
    @Default(1) int interval,
    @Default(<int>[]) List<int> weekdays,
    @Default(1) int onDays,
    @Default(0) int offDays,

    /// `yyyy-MM-dd` start of the pattern for interval-based rules.
    String? anchorDate,

    /// Optional per-weekday quantity overrides (ISO weekday → scaled qty).
    @Default(<String, int>{}) Map<String, int> weekdayQuantities,
  }) = _RecurrenceRule;

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);

  static RecurrenceRule decode(String? source) {
    if (source == null || source.trim().isEmpty) return const RecurrenceRule();
    try {
      return RecurrenceRule.fromJson(
        jsonDecode(source) as Map<String, dynamic>,
      );
    } catch (_) {
      return const RecurrenceRule();
    }
  }

  String encode() => jsonEncode(toJson());

  /// Whether the rule produces an occurrence on [date].
  ///
  /// [fallbackAnchor] is used when [anchorDate] is not set.
  bool occursOn(LocalDate date, {required LocalDate fallbackAnchor}) {
    final anchor = LocalDate.tryParse(anchorDate) ?? fallbackAnchor;
    switch (type) {
      case RecurrenceType.daily:
        return true;
      case RecurrenceType.weekly:
        final days = weekdays.isEmpty ? const [1, 2, 3, 4, 5, 6, 7] : weekdays;
        if (!days.contains(date.weekday)) return false;
        final step = interval < 1 ? 1 : interval;
        if (step == 1) return true;
        final anchorWeekStart = anchor.addDays(1 - anchor.weekday);
        final dateWeekStart = date.addDays(1 - date.weekday);
        final weeks = anchorWeekStart.daysUntil(dateWeekStart) ~/ 7;
        return weeks >= 0 && weeks % step == 0;
      case RecurrenceType.everyNDays:
        final step = interval < 1 ? 1 : interval;
        final diff = anchor.daysUntil(date);
        return diff >= 0 && diff % step == 0;
      case RecurrenceType.cycle:
        final active = onDays < 1 ? 1 : onDays;
        final pause = offDays < 0 ? 0 : offDays;
        final diff = anchor.daysUntil(date);
        if (diff < 0) return false;
        return diff % (active + pause) < active;
    }
  }

  /// Quantity for [date], honouring per-weekday overrides.
  int quantityOn(LocalDate date, int defaultScaled) =>
      weekdayQuantities['${date.weekday}'] ?? defaultScaled;
}
