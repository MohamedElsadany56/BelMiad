import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/session/session_context.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/utilities/ids.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../audit/data/audit_log.dart';
import '../domain/batch_selection.dart';
import '../domain/partial_pack.dart';

abstract final class PackagingTypes {
  static const all = [
    'box',
    'strip',
    'blister',
    'bottle',
    'tube',
    'sachet',
    'vial',
    'ampoule',
    'container',
    'other',
  ];
}

abstract final class AdjustmentReasons {
  static const all = [
    'manual_correction',
    'damaged',
    'lost',
    'returned',
    'count_correction',
    'other',
  ];

  /// One unit marked as used from the inventory strip. Recorded through the
  /// same ledger as manual adjustments, but not offered in the manual list.
  static const stripUse = 'strip_use';

  static bool isValid(String reason) =>
      all.contains(reason) || reason == stripUse;
}

class BatchInput {
  const BatchInput({
    required this.medicationId,
    required this.quantityScaled,
    this.purchaseDate,
    this.purchasePrice,
    this.expirationDate,
    this.packagingType,
    this.packagesCount,
    this.unitsPerPackage,
    this.subPackagingType,
    this.subPackagesPerPackage,
    this.looseQuantityScaled,
    this.partialPacks = const [],
    this.notes,
  });

  /// Builds the input from packages, optionally with inner packs:
  /// `2 boxes × 3 strips × 10 tablets (+ 4 loose) = 64 tablets`.
  factory BatchInput.fromPackages({
    required String medicationId,
    required int packagesCount,
    required int unitsPerPackage,
    int? subPackagesPerPackage,
    String? subPackagingType,
    int looseQuantityScaled = 0,
    List<PartialPack> partialPacks = const [],
    String? packagingType,
    String? purchaseDate,
    double? purchasePrice,
    String? expirationDate,
    String? notes,
  }) =>
      BatchInput(
        medicationId: medicationId,
        quantityScaled: ScaledQuantity.fromPackages(
          packages: packagesCount,
          unitsPerPackage: unitsPerPackage,
          subPackagesPerPackage: subPackagesPerPackage,
          loose: ScaledQuantity(
            looseQuantityScaled + partialPacksTotal(partialPacks),
          ),
        ).scaled,
        packagesCount: packagesCount,
        unitsPerPackage: unitsPerPackage,
        subPackagesPerPackage: subPackagesPerPackage,
        subPackagingType:
            subPackagesPerPackage == null ? null : subPackagingType,
        looseQuantityScaled:
            looseQuantityScaled == 0 ? null : looseQuantityScaled,
        partialPacks: partialPacks,
        packagingType: packagingType,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice,
        expirationDate: expirationDate,
        notes: notes,
      );

  final String medicationId;
  final int quantityScaled;
  final String? purchaseDate;
  final double? purchasePrice;
  final String? expirationDate;
  final String? packagingType;
  final int? packagesCount;
  final int? unitsPerPackage;
  final String? subPackagingType;
  final int? subPackagesPerPackage;
  final int? looseQuantityScaled;

  /// Opened or incomplete packs (e.g. a strip with 9 of 14 tablets left).
  final List<PartialPack> partialPacks;
  final String? notes;
}

class ConsumptionEntry {
  const ConsumptionEntry({
    required this.consumption,
    required this.dose,
    required this.batch,
  });

  final DoseConsumption consumption;
  final DoseInstance dose;
  final InventoryBatch batch;
}

BatchSnapshot snapshotOf(InventoryBatch batch) => BatchSnapshot(
      id: batch.inventoryBatchId,
      availableScaled: batch.availableQuantityScaled,
      expirationDate: LocalDate.tryParse(batch.expirationDate),
      purchaseDate: LocalDate.tryParse(batch.purchaseDate),
      isDeleted: batch.deletedAt != null,
    );

/// Batch ledger repository (spec §12–§20, §38). Hides Drift from the UI.
class InventoryRepository {
  InventoryRepository(
    this._db,
    this._audit,
    this._session, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final AppDatabase _db;
  final AuditLog _audit;
  final SessionContext _session;
  final Clock _clock;

  Future<List<InventoryBatch>> getBatchesForMedication(
    String medicationId, {
    bool includeDeleted = false,
  }) {
    final query = _db.select(_db.medicationInventoryBatches)
      ..where((b) => b.medicationId.equals(medicationId))
      ..orderBy([
        (b) => OrderingTerm.asc(b.expirationDate),
        (b) => OrderingTerm.asc(b.purchaseDate),
      ]);
    if (!includeDeleted) query.where((b) => b.deletedAt.isNull());
    return query.get();
  }

  Stream<List<InventoryBatch>> watchBatchesForMedication(String medicationId) =>
      (_db.select(_db.medicationInventoryBatches)
            ..where(
              (b) => b.medicationId.equals(medicationId) & b.deletedAt.isNull(),
            )
            ..orderBy([
              (b) => OrderingTerm.asc(b.expirationDate),
              (b) => OrderingTerm.asc(b.purchaseDate),
            ]))
          .watch();

  Future<InventoryBatch?> getBatch(String batchId) =>
      (_db.select(_db.medicationInventoryBatches)
            ..where((b) => b.inventoryBatchId.equals(batchId)))
          .getSingleOrNull();

  Future<String> addBatch(BatchInput input) async {
    _validate(input);
    final medication = await _medication(input.medicationId);
    final now = _clock();
    final id = newId();
    await _db.transaction(() async {
      await _db.into(_db.medicationInventoryBatches).insert(
            MedicationInventoryBatchesCompanion.insert(
              inventoryBatchId: id,
              medicationId: input.medicationId,
              purchaseDate: Value(input.purchaseDate),
              purchasePrice: Value(input.purchasePrice),
              expirationDate: Value(input.expirationDate),
              packagingType: Value(input.packagingType),
              unitsPerPackage: Value(input.unitsPerPackage),
              packagesCount: Value(input.packagesCount),
              subPackagingType: Value(input.subPackagingType),
              subPackagesPerPackage: Value(input.subPackagesPerPackage),
              looseQuantityScaled: Value(input.looseQuantityScaled),
              partialPacksJson: Value(encodePartialPacks(input.partialPacks)),
              initialQuantityScaled: input.quantityScaled,
              availableQuantityScaled: input.quantityScaled,
              isDepleted: Value(input.quantityScaled == 0),
              notes: Value(input.notes),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.inventoryBatch,
        entityId: id,
        action: AuditActions.inventoryAdded,
        metadata: {
          'medication': medication.nameEn,
          'quantity_scaled': input.quantityScaled,
          'expiration_date': input.expirationDate,
        },
      );
    });
    return id;
  }

  /// Edits batch details. Once a batch has consumption or adjustment
  /// history, its quantities cannot be silently rewritten; a stock adjustment
  /// must be used instead (spec §20).
  Future<void> updateBatch(String batchId, BatchInput input) async {
    _validate(input);
    await _db.transaction(() async {
      final batch = await getBatch(batchId);
      if (batch == null) throw NotFoundException('inventory_batch');
      final medication = await _medication(batch.medicationId);
      final hasHistory = await this.hasHistory(batchId);
      final quantityChanged =
          input.quantityScaled != batch.initialQuantityScaled;
      if (hasHistory && quantityChanged) {
        throw const ValidationException('useAdjustment');
      }
      await (_db.update(_db.medicationInventoryBatches)
            ..where((b) => b.inventoryBatchId.equals(batchId)))
          .write(MedicationInventoryBatchesCompanion(
        purchaseDate: Value(input.purchaseDate),
        purchasePrice: Value(input.purchasePrice),
        expirationDate: Value(input.expirationDate),
        packagingType: Value(input.packagingType),
        unitsPerPackage: Value(input.unitsPerPackage),
        packagesCount: Value(input.packagesCount),
        subPackagingType: Value(input.subPackagingType),
        subPackagesPerPackage: Value(input.subPackagesPerPackage),
        looseQuantityScaled: Value(input.looseQuantityScaled),
        partialPacksJson: Value(encodePartialPacks(input.partialPacks)),
        notes: Value(input.notes),
        initialQuantityScaled:
            hasHistory ? const Value.absent() : Value(input.quantityScaled),
        availableQuantityScaled:
            hasHistory ? const Value.absent() : Value(input.quantityScaled),
        isDepleted: hasHistory
            ? const Value.absent()
            : Value(input.quantityScaled == 0),
        updatedAt: Value(_clock()),
      ));
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.inventoryBatch,
        entityId: batchId,
        action: AuditActions.inventoryEdited,
        metadata: {
          'medication': medication.nameEn,
          'expiration_date': input.expirationDate,
          if (!hasHistory) 'quantity_scaled': input.quantityScaled,
        },
      );
    });
  }

  Future<bool> hasHistory(String batchId) async {
    final consumption = await (_db.select(_db.doseInventoryConsumption)
          ..where((c) => c.inventoryBatchId.equals(batchId))
          ..limit(1))
        .get();
    if (consumption.isNotEmpty) return true;
    final adjustments = await (_db.select(_db.inventoryAdjustments)
          ..where((a) => a.inventoryBatchId.equals(batchId))
          ..limit(1))
        .get();
    return adjustments.isNotEmpty;
  }

  /// Adds or removes quantity with a recorded reason (spec §20). Stock can
  /// never become negative.
  Future<void> adjustQuantity({
    required String batchId,
    required int deltaScaled,
    required String reason,
    String? notes,
  }) async {
    if (deltaScaled == 0) throw const ValidationException('quantityRequired');
    if (!AdjustmentReasons.isValid(reason)) {
      throw const ValidationException('invalidReason');
    }
    await _db.transaction(() async {
      final batch = await getBatch(batchId);
      if (batch == null) throw NotFoundException('inventory_batch');
      final medication = await _medication(batch.medicationId);
      final previous = batch.availableQuantityScaled;
      final next = previous + deltaScaled;
      if (next < 0) throw const NegativeStockException();
      final now = _clock();
      await _db.into(_db.inventoryAdjustments).insert(
            InventoryAdjustmentsCompanion.insert(
              adjustmentId: newId(),
              inventoryBatchId: batchId,
              medicationId: batch.medicationId,
              previousQuantityScaled: previous,
              deltaScaled: deltaScaled,
              newQuantityScaled: next,
              reason: reason,
              notes: Value(notes),
              actorPersonId: Value(_session.actorPersonId),
              occurredAt: now,
            ),
          );
      await (_db.update(_db.medicationInventoryBatches)
            ..where((b) => b.inventoryBatchId.equals(batchId)))
          .write(MedicationInventoryBatchesCompanion(
        availableQuantityScaled: Value(next),
        isDepleted: Value(next == 0),
        updatedAt: Value(now),
      ));
      await _audit.record(
        patientId: medication.patientId,
        entityType: EntityTypes.inventoryBatch,
        entityId: batchId,
        action: AuditActions.inventoryAdjusted,
        metadata: {
          'medication': medication.nameEn,
          'previous_scaled': previous,
          'delta_scaled': deltaScaled,
          'new_scaled': next,
          'reason': reason,
        },
      );
    });
  }

  /// Total usable (non-expired, non-deleted) quantity.
  Future<int> getTotalAvailableQuantityScaled(
    String medicationId, {
    required LocalDate today,
  }) async {
    final batches = await getBatchesForMedication(medicationId);
    return usableQuantity(batches.map(snapshotOf), today);
  }

  /// Usable batches in FEFO order.
  Future<List<InventoryBatch>> getAvailableBatches(
    String medicationId, {
    required LocalDate today,
  }) async {
    final batches = await getBatchesForMedication(medicationId);
    final order =
        fefoOrder(batches.map(snapshotOf), today).map((b) => b.id).toList();
    final byId = {for (final b in batches) b.inventoryBatchId: b};
    return [for (final id in order) byId[id]!];
  }

  Stream<List<InventoryAdjustment>> watchAdjustments(String medicationId) =>
      (_db.select(_db.inventoryAdjustments)
            ..where((a) => a.medicationId.equals(medicationId))
            ..orderBy([(a) => OrderingTerm.desc(a.occurredAt)]))
          .watch();

  Stream<List<ConsumptionEntry>> watchConsumption(String medicationId) {
    final query = _db.select(_db.doseInventoryConsumption).join([
      innerJoin(
        _db.doseInstances,
        _db.doseInstances.doseInstanceId
            .equalsExp(_db.doseInventoryConsumption.doseInstanceId),
      ),
      innerJoin(
        _db.medicationInventoryBatches,
        _db.medicationInventoryBatches.inventoryBatchId
            .equalsExp(_db.doseInventoryConsumption.inventoryBatchId),
      ),
    ])
      ..where(_db.doseInstances.medicationId.equals(medicationId))
      ..orderBy([OrderingTerm.desc(_db.doseInventoryConsumption.createdAt)]);
    return query.watch().map(
          (rows) => rows
              .map(
                (r) => ConsumptionEntry(
                  consumption: r.readTable(_db.doseInventoryConsumption),
                  dose: r.readTable(_db.doseInstances),
                  batch: r.readTable(_db.medicationInventoryBatches),
                ),
              )
              .toList(),
        );
  }

  Future<Medication> _medication(String medicationId) async {
    final medication = await (_db.select(_db.medications)
          ..where((m) => m.medicationId.equals(medicationId)))
        .getSingleOrNull();
    if (medication == null) throw NotFoundException('medication');
    return medication;
  }

  void _validate(BatchInput input) {
    if (input.quantityScaled < 0) throw const NegativeStockException();
    if (input.packagesCount != null && input.packagesCount! < 0) {
      throw const ValidationException('invalidPackages');
    }
    if (input.unitsPerPackage != null && input.unitsPerPackage! < 0) {
      throw const ValidationException('invalidPackages');
    }
    if (input.subPackagesPerPackage != null &&
        input.subPackagesPerPackage! < 1) {
      throw const ValidationException('invalidPackages');
    }
    if (input.looseQuantityScaled != null && input.looseQuantityScaled! < 0) {
      throw const ValidationException('invalidPackages');
    }
    if (input.partialPacks.any((p) => !p.isValid)) {
      throw const ValidationException('invalidPartialPack');
    }
    if (input.purchasePrice != null && input.purchasePrice! < 0) {
      throw const ValidationException('invalidPrice');
    }
    if (input.expirationDate != null &&
        LocalDate.tryParse(input.expirationDate) == null) {
      throw const ValidationException('invalidDate');
    }
  }
}
