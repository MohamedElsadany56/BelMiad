import '../../../core/utilities/scaled_quantity.dart';

/// Most units a single strip or blister holds. Real strips hold 6 to 30;
/// the limit keeps the drawing readable and stops typos like 100.
const maxStripCapacity = 30;

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
    this.hasHalf = false,
  });

  /// Positions in the strip (tablets per strip as entered with the stock).
  final int capacity;

  /// Units left in the strip in use, `0..capacity`.
  final int remaining;

  /// Further full strips behind the one in use.
  final int extraFullStrips;

  /// Half a tablet is left on top of [remaining] (it sits in the pocket
  /// just before the full ones).
  final bool hasHalf;

  int get consumed => capacity - remaining;

  /// Whole units left in the whole batch.
  int get totalUnits => remaining + extraFullStrips * capacity;

  bool get isEmpty => totalUnits == 0 && !hasHalf;

  @override
  bool operator ==(Object other) =>
      other is StripState &&
      other.capacity == capacity &&
      other.remaining == remaining &&
      other.extraFullStrips == extraFullStrips &&
      other.hasHalf == hasHalf;

  @override
  int get hashCode =>
      Object.hash(capacity, remaining, extraFullStrips, hasHalf);

  @override
  String toString() =>
      'StripState($remaining/$capacity +$extraFullStrips${hasHalf ? ' +½' : ''})';
}

/// Builds the strip for a batch whose innermost pack holds
/// [unitsPerPackage] units and which has [availableScaled] left.
///
/// Returns null when the pack size is unknown (nothing meaningful to draw).
/// A half tablet is shown as a half-filled pocket; other fractions are not
/// shown.
StripState? stripStateFor({
  required int? unitsPerPackage,
  required int availableScaled,
  int scale = quantityScale,
}) {
  final capacity = unitsPerPackage;
  if (capacity == null || capacity <= 0) return null;
  final total = availableScaled <= 0 ? 0 : availableScaled ~/ scale;
  final half = availableScaled > 0 && availableScaled % scale >= scale ~/ 2;
  if (total == 0) {
    return StripState(
      capacity: capacity,
      remaining: 0,
      extraFullStrips: 0,
      hasHalf: half,
    );
  }
  final remainder = total % capacity;
  final inUse = remainder == 0 ? capacity : remainder;
  return StripState(
    capacity: capacity,
    remaining: inUse,
    extraFullStrips: (total - inUse) ~/ capacity,
    // A half needs an empty pocket to sit in.
    hasHalf: half && inUse < capacity,
  );
}
