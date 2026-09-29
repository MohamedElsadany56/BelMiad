import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/local_date.dart';

/// Minimal view of an inventory batch used by selection and forecasting.
class BatchSnapshot {
  const BatchSnapshot({
    required this.id,
    required this.availableScaled,
    this.expirationDate,
    this.purchaseDate,
    this.isDeleted = false,
  });

  final String id;
  final int availableScaled;
  final LocalDate? expirationDate;
  final LocalDate? purchaseDate;
  final bool isDeleted;

  /// A batch is expired after its expiration date has passed.
  bool isExpiredOn(LocalDate today) =>
      expirationDate != null && expirationDate!.isBefore(today);

  bool isUsableOn(LocalDate today) =>
      !isDeleted && availableScaled > 0 && !isExpiredOn(today);
}

class BatchAllocation {
  const BatchAllocation({
    required this.batchId,
    required this.quantityScaled,
    this.manuallySelected = false,
  });

  final String batchId;
  final int quantityScaled;
  final bool manuallySelected;

  @override
  bool operator ==(Object other) =>
      other is BatchAllocation &&
      other.batchId == batchId &&
      other.quantityScaled == quantityScaled &&
      other.manuallySelected == manuallySelected;

  @override
  int get hashCode => Object.hash(batchId, quantityScaled, manuallySelected);

  @override
  String toString() => 'BatchAllocation($batchId, $quantityScaled)';
}

/// FEFO ordering (spec §15): only valid, non-expired stock; earliest
/// expiration, then earliest purchase date, then stable ID. Batches without an
/// expiration date are used last.
List<BatchSnapshot> fefoOrder(
    Iterable<BatchSnapshot> batches, LocalDate today) {
  final usable = batches.where((b) => b.isUsableOn(today)).toList();
  int compareNullableDates(LocalDate? a, LocalDate? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  usable.sort((a, b) {
    final byExpiry = compareNullableDates(a.expirationDate, b.expirationDate);
    if (byExpiry != 0) return byExpiry;
    final byPurchase = compareNullableDates(a.purchaseDate, b.purchaseDate);
    if (byPurchase != 0) return byPurchase;
    return a.id.compareTo(b.id);
  });
  return usable;
}

int usableQuantity(Iterable<BatchSnapshot> batches, LocalDate today) => batches
    .where((b) => b.isUsableOn(today))
    .fold(0, (sum, b) => sum + b.availableScaled);

/// Automatically allocates [requiredScaled] across batches using FEFO; a
/// single dose may span several batches (spec §16).
List<BatchAllocation> allocateFefo(
  Iterable<BatchSnapshot> batches, {
  required int requiredScaled,
  required LocalDate today,
}) {
  if (requiredScaled <= 0) return const [];
  final ordered = fefoOrder(batches, today);
  final available = ordered.fold(0, (sum, b) => sum + b.availableScaled);
  if (available < requiredScaled) {
    throw InsufficientStockException(
      requiredScaled: requiredScaled,
      availableScaled: available,
    );
  }
  var remaining = requiredScaled;
  final allocations = <BatchAllocation>[];
  for (final batch in ordered) {
    if (remaining == 0) break;
    final take =
        remaining < batch.availableScaled ? remaining : batch.availableScaled;
    allocations.add(BatchAllocation(batchId: batch.id, quantityScaled: take));
    remaining -= take;
  }
  return allocations;
}

/// Validates a user-chosen allocation: each batch must be usable, have enough
/// stock, and the total must equal [requiredScaled].
List<BatchAllocation> validateManualAllocation(
  Iterable<BatchSnapshot> batches,
  List<BatchAllocation> allocations, {
  required int requiredScaled,
  required LocalDate today,
}) {
  final byId = {for (final b in batches) b.id: b};
  final merged = <String, int>{};
  for (final allocation in allocations) {
    if (allocation.quantityScaled < 0) {
      throw const ValidationException('invalidAllocation');
    }
    if (allocation.quantityScaled == 0) continue;
    merged.update(
      allocation.batchId,
      (value) => value + allocation.quantityScaled,
      ifAbsent: () => allocation.quantityScaled,
    );
  }
  var total = 0;
  for (final entry in merged.entries) {
    final batch = byId[entry.key];
    if (batch == null || !batch.isUsableOn(today)) {
      throw const ValidationException('batchNotUsable');
    }
    if (entry.value > batch.availableScaled) {
      throw InsufficientStockException(
        requiredScaled: entry.value,
        availableScaled: batch.availableScaled,
      );
    }
    total += entry.value;
  }
  if (total != requiredScaled) {
    throw ValidationException('allocationTotalMismatch', {
      'required': requiredScaled,
      'allocated': total,
    });
  }
  return [
    for (final entry in merged.entries)
      BatchAllocation(
        batchId: entry.key,
        quantityScaled: entry.value,
        manuallySelected: true,
      ),
  ];
}
