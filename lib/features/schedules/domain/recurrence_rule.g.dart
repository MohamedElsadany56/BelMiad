// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) =>
    _RecurrenceRule(
      type: $enumDecodeNullable(_$RecurrenceTypeEnumMap, json['type']) ??
          RecurrenceType.daily,
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      weekdays: (json['weekdays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      onDays: (json['onDays'] as num?)?.toInt() ?? 1,
      offDays: (json['offDays'] as num?)?.toInt() ?? 0,
      anchorDate: json['anchorDate'] as String?,
      weekdayQuantities:
          (json['weekdayQuantities'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
    );

Map<String, dynamic> _$RecurrenceRuleToJson(_RecurrenceRule instance) =>
    <String, dynamic>{
      'type': _$RecurrenceTypeEnumMap[instance.type]!,
      'interval': instance.interval,
      'weekdays': instance.weekdays,
      'onDays': instance.onDays,
      'offDays': instance.offDays,
      'anchorDate': instance.anchorDate,
      'weekdayQuantities': instance.weekdayQuantities,
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.everyNDays: 'everyNDays',
  RecurrenceType.cycle: 'cycle',
};
