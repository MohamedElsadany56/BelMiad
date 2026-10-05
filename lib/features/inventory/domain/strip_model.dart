import '../../../core/utilities/scaled_quantity.dart';

/// What the strip visual shows for one inventory batch.
///
/// The inventory quantity in the database is the only source of truth; this
/// is a pure view of it. A batch of several strips shows the strip currently
/// in use plus a count of the further full strips.
class StripState {
  const StripState({
    required this.capacity,
    required this.remaining,
    required this.extraFullStrips,
  });

  /// Positions in the strip (tablets per strip as entered with the stock).
  final int capacity;

  /// Units left in the strip in use, `0..capacity`.
  final int remaining;

  /// Further full strips behind the one in use.
  final int extraFullStrips;

  int get consumed => capacity - remaining;

  /// Whole units left in the whole batch.
  int get totalUnits => remaining + extraFullStrips * capacity;

  bool get isEmpty => totalUnits == 0;

  @override
  bool operator ==(Object other) =>
      other is StripState &&
      other.capacity == capacity &&
      other.remaining == remaining &&
      other.extraFullStrips == extraFullStrips;

  @override
  int get hashCode => Object.hash(capacity, remaining, extraFullStrips);

  @override
  String toString() => 'StripState($remaining/$capacity +$extraFullStrips)';
}

/// Builds the strip for a batch whose innermost pack holds
/// [unitsPerPackage] units and which has [availableScaled] left.
///
/// Returns null when the pack size is unknown (nothing meaningful to draw).
/// Fractions of a unit (a half tablet) are not shown as a position.
StripState? stripStateFor({
  required int? unitsPerPackage,
  required int availableScaled,
  int scale = quantityScale,
}) {
  final capacity = unitsPerPackage;
  if (capacity == null || capacity <= 0) return null;
  final total = availableScaled <= 0 ? 0 : availableScaled ~/ scale;
  if (total == 0) {
    return StripState(capacity: capacity, remaining: 0, extraFullStrips: 0);
  }
  final remainder = total % capacity;
  final inUse = remainder == 0 ? capacity : remainder;
  return StripState(
    capacity: capacity,
    remaining: inUse,
    extraFullStrips: (total - inUse) ~/ capacity,
  );
}
