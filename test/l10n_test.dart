import 'dart:convert';
import 'dart:io';

import 'package:belmiad/app/widgets/common.dart';
import 'package:belmiad/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final ar = lookupAppLocalizations(const Locale('ar'));

  test('multi-placeholder messages keep their argument order', () {
    expect(en.scheduleAfterMeal(30, 'Lunch'), '30 min after Lunch');
    expect(en.scheduleCycle(21, 7), '21 days on, 7 days off');
    expect(
      en.insufficientStockBody('2 tablets', '1 tablet'),
      'Required 2 tablets, but only 1 tablet is available in usable stock.',
    );
    expect(
      en.maxExceededBody('4', '3', '2'),
      'Maximum 4 per day. Already taken today: 3. This dose: 2.',
    );
    expect(en.quantityChange('10', '7'), '10 → 7');
    expect(en.unitsPer('tablets', 'Strip'), 'tablets per Strip');
    expect(ar.scheduleAfterMeal(30, 'الغداء'), 'بعد الغداء بـ 30 دقيقة');
  });

  test('every message with several placeholders declares their order', () {
    final arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
        as Map<String, dynamic>;
    for (final entry in arb.entries) {
      if (entry.key.startsWith('@') || entry.value is! String) continue;
      final names = RegExp(r'\{(\w+)\}')
          .allMatches(entry.value as String)
          .map((m) => m.group(1))
          .toSet();
      if (names.length < 2) continue;
      expect(
        arb.containsKey('@${entry.key}'),
        isTrue,
        reason: '${entry.key} needs placeholder metadata to fix its order',
      );
    }
  });

  test('English and numbers keep their order inside Arabic text', () {
    expect(contentDirection('Take after meals.'), TextDirection.ltr);
    expect(contentDirection('500 mg'), TextDirection.ltr);
    expect(contentDirection('يؤخذ بعد الأكل'), TextDirection.rtl);
    expect(contentDirection('12:30'), isNull);
  });
}
