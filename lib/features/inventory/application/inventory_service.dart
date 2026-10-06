import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../../core/utilities/ids.dart';
import '../data/inventory_repository.dart';
import '../domain/batch_selection.dart';

/// Transaction-aware inventory operations used by dose use cases.
///
/// These methods must be called inside a surrounding database transaction so
/// that dose status, consumption and stock changes commit or roll back
/// together (spec §18, §19).
class InventoryService {
  InventoryService(this._db, this._inventory, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final InventoryRepository _inventory;
  final Clock _clock;

  /// Whether any (non-deleted) stock has ever been recorded for the
  /// medication. "Stock not recorded" differs from "stock = 0" (spec §6).
  Future<bool> isStockRecorded(String medicationId) async =>
      (await _inventory.getBatchesForMedication(medicationId)).isNotEmpty;

  /// Chooses batches for [requiredScaled]: the user's manual selection when
  /// given, otherwise FEFO.
  Future<List<BatchAllocation>> selectBatchesForDose({
    required String medicationId,
    required int requiredScaled,
    required LocalDate today,
    List<BatchAllocation>? manualAllocations,
  }) async {
    final batches = await _inventory.getBatchesForMedication(medicationId);
    final snapshots = batches.map(snapshotOf).toList();
    if (manualAllocations != null) {
      return validateManualAllocation(
        snapshots,
        manualAllocations,
        requiredScaled: requiredScaled,
        today: today,
      );
    }
    return allocateFefo(
      snapshots,
      requiredScaled: requiredScaled,
      today: today,
    );
  }

  /// Records consumption rows and decrements each batch.
  Future<void> consumeForDose({
    required String doseInstanceId,
    required List<BatchAllocation> allocations,
  }) async {
    final now = _clock();
    for (final allocation in allocations) {
      final batch = await _inventory.getBatch(allocation.batchId);
      if (batch == null) throw NotFoundException('inventory_batch');
      final next = batch.availableQuantityScaled - allocation.quantityScaled;
      if (next < 0) throw const NegativeStockException();
      await _db.into(_db.doseInventoryConsumption).insert(
            DoseInventoryConsumptionCompanion.insert(
              consumptionId: newId(),
              doseInstanceId: doseInstanceId,
              inventoryBatchId: allocation.batchId,
              quantityScaled: allocation.quantityScaled,
              manuallySelected: Value(allocation.manuallySelected),
              createdAt: now,
            ),
          );
      await (_db.update(_db.medicationInventoryBatches)
            ..where((b) => b.inventoryBatchId.equals(allocation.batchId)))
          .write(MedicationInventoryBatchesCompanion(
        availableQuantityScaled: Value(next),
        isDepleted: Value(next == 0),
        updatedAt: Value(now),
      ));
    }
  }

  /// Restores the exact quantities to the exact original batches and marks
  /// the consumption rows reversed (spec §19). Returns the restored rows.
  Future<List<DoseConsumption>> restoreDoseConsumption(
    String doseInstanceId,
  ) async {
    final now = _clock();
    final rows = await (_db.select(_db.doseInventoryConsumption)
          ..where(
            (c) =>
                c.doseInstanceId.equals(doseInstanceId) & c.reversedAt.isNull(),
          ))
        .get();
    for (final row in rows) {
      final batch = await _inventory.getBatch(row.inventoryBatchId);
      if (batch == null) throw NotFoundException('inventory_batch');
      final next = batch.availableQuantityScaled + row.quantityScaled;
      await (_db.update(_db.medicationInventoryBatches)
            ..where((b) => b.inventoryBatchId.equals(row.inventoryBatchId)))
          .write(MedicationInventoryBatchesCompanion(
        availableQuantityScaled: Value(next),
        isDepleted: Value(next == 0),
        updatedAt: Value(now),
      ));
      await (_db.update(_db.doseInventoryConsumption)
            ..where((c) => c.consumptionId.equals(row.consumptionId)))
          .write(DoseInventoryConsumptionCompanion(reversedAt: Value(now)));
    }
    return rows;
  }

  /// Marks one unit (a tablet, capsule...) of [batchId] as used, from the
  /// inventory strip. The decrement goes through the normal stock ledger
  /// ([InventoryRepository.adjustQuantity]), so history, audit and the
  /// "never negative" rule are the same as for any other stock change.
  ///
  /// Rejected for deleted, expired or empty batches. Returns the quantity
  /// left in the batch (scaled) after the change.
  Future<int> consumeUnit(
    String batchId, {
    int quantityScaled = quantityScale,
  }) async {
    final batch = await _inventory.getBatch(batchId);
    if (batch == null || batch.deletedAt != null) {
      throw NotFoundException('inventory_batch');
    }
    final medication = await (_db.select(_db.medications)
          ..where((m) => m.medicationId.equals(batch.medicationId)))
        .getSingleOrNull();
    if (medication == null) throw NotFoundException('medication');
    final patient = await (_db.select(_db.patients)
          ..where((p) => p.patientId.equals(medication.patientId)))
        .getSingleOrNull();
    final today = PatientTime(patient?.timezone ?? defaultTimezone).today(
      _clock(),
    );
    if (snapshotOf(batch).isExpiredOn(today)) {
      throw const ValidationException('batchNotUsable');
    }
    if (batch.availableQuantityScaled < quantityScaled) {
      throw const NegativeStockException();
    }
    await _inventory.adjustQuantity(
      batchId: batchId,
      deltaScaled: -quantityScaled,
      reason: AdjustmentReasons.stripUse,
    );
    return batch.availableQuantityScaled - quantityScaled;
  }
}
