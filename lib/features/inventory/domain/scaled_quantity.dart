class ScaledQuantity {
  const ScaledQuantity(this.value, {this.scale = 1000});
  final int value;
  final int scale;
  double get asDouble => value / scale;
  ScaledQuantity operator +(ScaledQuantity other) { _check(other); return ScaledQuantity(value + other.value, scale: scale); }
  ScaledQuantity operator -(ScaledQuantity other) { _check(other); return ScaledQuantity(value - other.value, scale: scale); }
  ScaledQuantity operator *(int multiplier) => ScaledQuantity(value * multiplier, scale: scale);
  void _check(ScaledQuantity other) { if (scale != other.scale) throw ArgumentError('Quantity scales must match'); }
}
