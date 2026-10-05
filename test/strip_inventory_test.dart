import 'package:belmiad/core/errors/domain_exceptions.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  late TestHarness h;
  late String patientId;
  late String medicationId;

  // 2026-09-28 09:00 in Cairo.
  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    await h.createCaregiver();
    patientId = await h.createPatient();
    medicationId = await h.createMedication(patientId);
  });

  tearDown(() => h.close());

  Future<String> addBatch(int units, {String? expires}) =>
      h.inventory.addBatch(
        BatchInput(
          medicationId: medicationId,
          quantityScaled: units * 1000,
          unitsPerPackage: 10,
          expirationDate: expires,
        ),
      );

  test('one tap uses one unit and the database keeps the new quantity',
      () async {
    final batch = await addBatch(7);
    final left = await h.inventoryService.consumeUnit(batch);
    expect(left, 6000);
    expect((await h.batch(batch)).availableQuantityScaled, 6000);
  });

  test('the strip can be used down to zero and never below', () async {
    final batch = await addBatch(2);
    await h.inventoryService.consumeUnit(batch);
    expect(await h.inventoryService.consumeUnit(batch), 0);
    await expectLater(
      h.inventoryService.consumeUnit(batch),
      throwsA(isA<NegativeStockException>()),
    );
    expect((await h.batch(batch)).availableQuantityScaled, 0);
  });

  test('an expired batch cannot be used', () async {
    final batch = await addBatch(5, expires: '2026-09-01');
    await expectLater(
      h.inventoryService.consumeUnit(batch),
      throwsA(isA<ValidationException>()),
    );
    expect((await h.batch(batch)).availableQuantityScaled, 5000);
  });

  test('a deleted or unknown batch cannot be used', () async {
    await expectLater(
      h.inventoryService.consumeUnit('missing'),
      throwsA(isA<NotFoundException>()),
    );
  });

  test('every tap is recorded in the adjustment ledger', () async {
    final batch = await addBatch(3);
    await h.inventoryService.consumeUnit(batch);
    await h.inventoryService.consumeUnit(batch);
    final rows = await h.db.select(h.db.inventoryAdjustments).get();
    expect(rows.where((r) => r.reason == AdjustmentReasons.stripUse).length, 2);
  });
}
