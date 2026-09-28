import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class InventoryService {
  InventoryService(this.database);
  final AppDatabase database;

  Future<List<InventoryBatchesData>> getAvailableBatches(
      String medicationId) async {
    final rows = await database.batchesForMedication(medicationId);
    final now = DateTime.now();
    rows.removeWhere(
      (b) =>
          b.isDepleted ||
          (b.expirationDate != null && b.expirationDate!.isBefore(now)),
    );
    rows.sort((a, b) {
      final expiry = (a.expirationDate ?? DateTime(9999)).compareTo(
        b.expirationDate ?? DateTime(9999),
      );
      if (expiry != 0) return expiry;
      return a.purchaseDate.compareTo(b.purchaseDate);
    });
    return rows;
  }

  Future<int> totalAvailableQuantity(String medicationId) async {
    final batches = await getAvailableBatches(medicationId);
    return batches.fold(0, (sum, batch) => sum + batch.availableQuantityScaled);
  }

  Future<void> adjustQuantity({
    required String batchId,
    required int deltaScaled,
    required String reason,
  }) async {
    await database.transaction(() async {
      final batch = await (database.select(
        database.inventoryBatches,
      )..where((b) => b.id.equals(batchId)))
          .getSingle();
      final next = batch.availableQuantityScaled + deltaScaled;
      if (next < 0) throw StateError('Inventory cannot become negative');
      await (database.update(
        database.inventoryBatches,
      )..where((b) => b.id.equals(batchId)))
          .write(
        InventoryBatchesCompanion(
          availableQuantityScaled: Value(next),
          isDepleted: Value(next == 0),
        ),
      );
      await database.into(database.auditEvents).insert(
            AuditEventsCompanion.insert(
              id: '${DateTime.now().microsecondsSinceEpoch}',
              entityType: 'inventory_batch',
              entityId: batchId,
              action: 'adjust:$reason',
              occurredAt: DateTime.now(),
            ),
          );
    });
  }
}
