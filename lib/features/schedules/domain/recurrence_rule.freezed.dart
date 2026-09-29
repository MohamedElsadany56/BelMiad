// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurrenceRule {
  RecurrenceType get type;
  int get interval;
  List<int> get weekdays;
  int get onDays;
  int get offDays;

  /// `yyyy-MM-dd` start of the pattern for interval-based rules.
  String? get anchorDate;

  /// Optional per-weekday quantity overrides (ISO weekday → scaled qty).
  Map<String, int> get weekdayQuantities;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<RecurrenceRule> get copyWith =>
      _$RecurrenceRuleCopyWithImpl<RecurrenceRule>(
          this as RecurrenceRule, _$identity);

  /// Serializes this RecurrenceRule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurrenceRule &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality().equals(other.weekdays, weekdays) &&
            (identical(other.onDays, onDays) || other.onDays == onDays) &&
            (identical(other.offDays, offDays) || other.offDays == offDays) &&
            (identical(other.anchorDate, anchorDate) ||
                other.anchorDate == anchorDate) &&
            const DeepCollectionEquality()
                .equals(other.weekdayQuantities, weekdayQuantities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      interval,
      const DeepCollectionEquality().hash(weekdays),
      onDays,
      offDays,
      anchorDate,
      const DeepCollectionEquality().hash(weekdayQuantities));

  @override
  String toString() {
    return 'RecurrenceRule(type: $type, interval: $interval, weekdays: $weekdays, onDays: $onDays, offDays: $offDays, anchorDate: $anchorDate, weekdayQuantities: $weekdayQuantities)';
  }
}

/// @nodoc
abstract mixin class $RecurrenceRuleCopyWith<$Res> {
  factory $RecurrenceRuleCopyWith(
          RecurrenceRule value, $Res Function(RecurrenceRule) _then) =
      _$RecurrenceRuleCopyWithImpl;
  @useResult
  $Res call(
      {RecurrenceType type,
      int interval,
      List<int> weekdays,
      int onDays,
      int offDays,
      String? anchorDate,
      Map<String, int> weekdayQuantities});
}

/// @nodoc
class _$RecurrenceRuleCopyWithImpl<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  _$RecurrenceRuleCopyWithImpl(this._self, this._then);

  final RecurrenceRule _self;
  final $Res Function(RecurrenceRule) _then;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? interval = null,
    Object? weekdays = null,
    Object? onDays = null,
    Object? offDays = null,
    Object? anchorDate = freezed,
    Object? weekdayQuantities = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      weekdays: null == weekdays
          ? _self.weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      onDays: null == onDays
          ? _self.onDays
          : onDays // ignore: cast_nullable_to_non_nullable
              as int,
      offDays: null == offDays
          ? _self.offDays
          : offDays // ignore: cast_nullable_to_non_nullable
              as int,
      anchorDate: freezed == anchorDate
          ? _self.anchorDate
          : anchorDate // ignore: cast_nullable_to_non_nullable
              as String?,
      weekdayQuantities: null == weekdayQuantities
          ? _self.weekdayQuantities
          : weekdayQuantities // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecurrenceRule].
extension RecurrenceRulePatterns on RecurrenceRule {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecurrenceRule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecurrenceRule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecurrenceRule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            RecurrenceType type,
            int interval,
            List<int> weekdays,
            int onDays,
            int offDays,
            String? anchorDate,
            Map<String, int> weekdayQuantities)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
        return $default(
            _that.type,
            _that.interval,
            _that.weekdays,
            _that.onDays,
            _that.offDays,
            _that.anchorDate,
            _that.weekdayQuantities);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            RecurrenceType type,
            int interval,
            List<int> weekdays,
            int onDays,
            int offDays,
            String? anchorDate,
            Map<String, int> weekdayQuantities)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule():
        return $default(
            _that.type,
            _that.interval,
            _that.weekdays,
            _that.onDays,
            _that.offDays,
            _that.anchorDate,
            _that.weekdayQuantities);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            RecurrenceType type,
            int interval,
            List<int> weekdays,
            int onDays,
            int offDays,
            String? anchorDate,
            Map<String, int> weekdayQuantities)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
        return $default(
            _that.type,
            _that.interval,
            _that.weekdays,
            _that.onDays,
            _that.offDays,
            _that.anchorDate,
            _that.weekdayQuantities);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecurrenceRule extends RecurrenceRule {
  const _RecurrenceRule(
      {this.type = RecurrenceType.daily,
      this.interval = 1,
      final List<int> weekdays = const <int>[],
      this.onDays = 1,
      this.offDays = 0,
      this.anchorDate,
      final Map<String, int> weekdayQuantities = const <String, int>{}})
      : _weekdays = weekdays,
        _weekdayQuantities = weekdayQuantities,
        super._();
  factory _RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);

  @override
  @JsonKey()
  final RecurrenceType type;
  @override
  @JsonKey()
  final int interval;
  final List<int> _weekdays;
  @override
  @JsonKey()
  List<int> get weekdays {
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdays);
  }

  @override
  @JsonKey()
  final int onDays;
  @override
  @JsonKey()
  final int offDays;

  /// `yyyy-MM-dd` start of the pattern for interval-based rules.
  @override
  final String? anchorDate;

  /// Optional per-weekday quantity overrides (ISO weekday → scaled qty).
  final Map<String, int> _weekdayQuantities;

  /// Optional per-weekday quantity overrides (ISO weekday → scaled qty).
  @override
  @JsonKey()
  Map<String, int> get weekdayQuantities {
    if (_weekdayQuantities is EqualUnmodifiableMapView)
      return _weekdayQuantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weekdayQuantities);
  }

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurrenceRuleCopyWith<_RecurrenceRule> get copyWith =>
      __$RecurrenceRuleCopyWithImpl<_RecurrenceRule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecurrenceRuleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurrenceRule &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays) &&
            (identical(other.onDays, onDays) || other.onDays == onDays) &&
            (identical(other.offDays, offDays) || other.offDays == offDays) &&
            (identical(other.anchorDate, anchorDate) ||
                other.anchorDate == anchorDate) &&
            const DeepCollectionEquality()
                .equals(other._weekdayQuantities, _weekdayQuantities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      interval,
      const DeepCollectionEquality().hash(_weekdays),
      onDays,
      offDays,
      anchorDate,
      const DeepCollectionEquality().hash(_weekdayQuantities));

  @override
  String toString() {
    return 'RecurrenceRule(type: $type, interval: $interval, weekdays: $weekdays, onDays: $onDays, offDays: $offDays, anchorDate: $anchorDate, weekdayQuantities: $weekdayQuantities)';
  }
}

/// @nodoc
abstract mixin class _$RecurrenceRuleCopyWith<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  factory _$RecurrenceRuleCopyWith(
          _RecurrenceRule value, $Res Function(_RecurrenceRule) _then) =
      __$RecurrenceRuleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {RecurrenceType type,
      int interval,
      List<int> weekdays,
      int onDays,
      int offDays,
      String? anchorDate,
      Map<String, int> weekdayQuantities});
}

/// @nodoc
class __$RecurrenceRuleCopyWithImpl<$Res>
    implements _$RecurrenceRuleCopyWith<$Res> {
  __$RecurrenceRuleCopyWithImpl(this._self, this._then);

  final _RecurrenceRule _self;
  final $Res Function(_RecurrenceRule) _then;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? interval = null,
    Object? weekdays = null,
    Object? onDays = null,
    Object? offDays = null,
    Object? anchorDate = freezed,
    Object? weekdayQuantities = null,
  }) {
    return _then(_RecurrenceRule(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      weekdays: null == weekdays
          ? _self._weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      onDays: null == onDays
          ? _self.onDays
          : onDays // ignore: cast_nullable_to_non_nullable
              as int,
      offDays: null == offDays
          ? _self.offDays
          : offDays // ignore: cast_nullable_to_non_nullable
              as int,
      anchorDate: freezed == anchorDate
          ? _self.anchorDate
          : anchorDate // ignore: cast_nullable_to_non_nullable
              as String?,
      weekdayQuantities: null == weekdayQuantities
          ? _self._weekdayQuantities
          : weekdayQuantities // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

// dart format on
