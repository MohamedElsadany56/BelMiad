import 'package:belmiad/core/utilities/scaled_quantity.dart';
import 'package:belmiad/features/inventory/domain/strip_model.dart';
import 'package:flutter_test/flutter_test.dart';

int _s(int units) => units * quantityScale;

void main() {
  group('stripStateFor', () {
    test('unknown pack size draws nothing', () {
      expect(
          stripStateFor(unitsPerPackage: null, availableScaled: _s(5)), isNull);
      expect(stripStateFor(unitsPerPackage: 0, availableScaled: _s(5)), isNull);
    });

    test('7 of 10 tablets remaining', () {
      final s = stripStateFor(unitsPerPackage: 10, availableScaled: _s(7))!;
      expect(s.remaining, 7);
      expect(s.consumed, 3);
      expect(s.extraFullStrips, 0);
    });

    test('full batch of several strips shows one full strip plus extras', () {
      final s = stripStateFor(unitsPerPackage: 10, availableScaled: _s(30))!;
      expect(s.remaining, 10);
      expect(s.extraFullStrips, 2);
      expect(s.totalUnits, 30);
    });

    test('empty and negative stock never go below zero', () {
      for (final v in [0, -5000]) {
        final s = stripStateFor(unitsPerPackage: 10, availableScaled: v)!;
        expect(s.isEmpty, isTrue);
        expect(s.remaining, 0);
      }
    });

    test('half tablets are not shown as a position', () {
      final s = stripStateFor(unitsPerPackage: 10, availableScaled: 7500)!;
      expect(s.remaining, 7);
    });
  });
}
