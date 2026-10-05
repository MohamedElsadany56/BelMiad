import 'package:belmiad/app/widgets/common.dart';
import 'package:belmiad/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('only tablets allow halves', () {
    expect(allowsHalfUnit('tablet'), isTrue);
    for (final unit in ['capsule', 'ml', 'drop', 'sachet', 'unit']) {
      expect(allowsHalfUnit(unit), isFalse, reason: unit);
    }
  });

  test('tablets accept whole and half amounts only', () {
    for (final ok in ['1', '0.5', '1.5', '2']) {
      expect(validateUnitQuantity(ok, l10n, 'tablet'), isNull, reason: ok);
    }
    for (final bad in ['0.3', '1.25', '0.75']) {
      expect(validateUnitQuantity(bad, l10n, 'tablet'), isNotNull, reason: bad);
    }
  });

  test('capsules and other units accept whole numbers only', () {
    expect(validateUnitQuantity('2', l10n, 'capsule'), isNull);
    expect(validateUnitQuantity('1.5', l10n, 'capsule'), isNotNull);
    expect(validateUnitQuantity('0.5', l10n, 'capsule'), isNotNull);
    expect(validateUnitQuantity('1.5', l10n, 'ml'), isNotNull);
  });

  test('required and zero rules are kept', () {
    expect(validateUnitQuantity('', l10n, 'tablet'), isNotNull);
    expect(validateUnitQuantity('', l10n, 'tablet', required: false), isNull);
    expect(validateUnitQuantity('0', l10n, 'tablet'), isNotNull);
    expect(validateUnitQuantity('0', l10n, 'tablet', allowZero: true), isNull);
  });
}
