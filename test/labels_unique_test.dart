import 'package:belmiad/app/localization/labels.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/l10n/app_localizations.dart';
import 'package:belmiad/l10n/app_localizations_ar.dart';
import 'package:belmiad/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final l10n in <AppLocalizations>[
    AppLocalizationsEn(),
    AppLocalizationsAr(),
  ]) {
    test('dose unit labels are unique (${l10n.localeName})', () {
      final labels = [for (final c in doseUnits) unitLabel(c, l10n)];
      expect(labels.toSet().length, labels.length, reason: '$labels');
    });
    test('packaging labels are unique (${l10n.localeName})', () {
      final labels = [
        for (final c in PackagingTypes.all) packagingLabel(c, l10n)
      ];
      expect(labels.toSet().length, labels.length, reason: '$labels');
    });
  }
}
