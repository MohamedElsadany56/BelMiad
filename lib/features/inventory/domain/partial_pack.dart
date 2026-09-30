import 'dart:convert';

import '../../../core/utilities/scaled_quantity.dart';

/// An opened or incomplete pack in a batch, e.g. a strip with 9 of its 14
/// tablets left, or a box where some strips were already used.
class PartialPack {
  const PartialPack({
    required this.type,
    required this.remainingScaled,
    this.capacity,
  });

  factory PartialPack.fromJson(Map<String, dynamic> json) => PartialPack(
        type: json['type'] as String? ?? 'other',
        remainingScaled: (json['remaining'] as num?)?.toInt() ?? 0,
        capacity: (json['capacity'] as num?)?.toInt(),
      );

  /// Packaging code (strip, blister, box, bottle, ...).
  final String type;

  /// Units still inside the pack, as a scaled quantity.
  final int remainingScaled;

  /// Units the pack holds when full (for display: "9 of 14").
  final int? capacity;

  Map<String, Object?> toJson() => {
        'type': type,
        'remaining': remainingScaled,
        if (capacity != null) 'capacity': capacity,
      };

  /// Remaining is within 0..capacity (when capacity is known).
  bool get isValid =>
      remainingScaled >= 0 &&
      (capacity == null ||
          (capacity! > 0 &&
              remainingScaled <= ScaledQuantity.units(capacity!).scaled));

  @override
  bool operator ==(Object other) =>
      other is PartialPack &&
      other.type == type &&
      other.remainingScaled == remainingScaled &&
      other.capacity == capacity;

  @override
  int get hashCode => Object.hash(type, remainingScaled, capacity);
}

List<PartialPack> decodePartialPacks(String? json) {
  if (json == null || json.isEmpty) return const [];
  try {
    return [
      for (final item in jsonDecode(json) as List)
        PartialPack.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  } catch (_) {
    return const [];
  }
}

String? encodePartialPacks(List<PartialPack> packs) =>
    packs.isEmpty ? null : jsonEncode([for (final p in packs) p.toJson()]);

int partialPacksTotal(Iterable<PartialPack> packs) =>
    packs.fold(0, (sum, p) => sum + p.remainingScaled);
