import 'package:belmiad/features/catalog/domain/catalog_name_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CatalogDrugFacts parse(String name, [String? route]) =>
      parseCatalogName(name, route: route);

  group('Tablets and capsules', () {
    test('strength, count and film coating', () {
      final f = parse('CONCOR 10 MG 30 F.C. TABS.', 'ORAL.SOLID');
      expect(f.brand, 'Concor');
      expect(f.strength, '10 mg');
      expect(f.form, DrugForms.tablet);
      expect(f.formDetails, [DrugFormDetails.filmCoated]);
      expect(f.doseUnit, 'tablet');
      expect(f.packCount, 30);
      expect(f.route, DrugRoutes.oral);
    });

    test('combination strengths and release details', () {
      expect(
          parse('ALKAPRESS PLUS 10/160MG 20 F.C. TABS.').strength, '10/160 mg');
      expect(
          parse('AUGMENTIN ADULTS 1GM/125MG 12 PWD. ORAL SUSP. SACHETS')
              .strength,
          '1 g/125 mg');
      final xr = parse('ANDODARICIN 7.5 MG 20 EXT. REL. F.C.TAB.');
      expect(xr.packCount, 20);
      expect(
          xr.formDetails,
          containsAll(
              [DrugFormDetails.extendedRelease, DrugFormDetails.filmCoated]));
      final hg = parse('ESOPIROXAN 20 MG 14 DEL. REL. H.G. CAPS.');
      expect(hg.form, DrugForms.capsule);
      expect(hg.packCount, 14);
      expect(
          hg.formDetails,
          containsAll(
              [DrugFormDetails.delayedRelease, DrugFormDetails.hardGelatin]));
    });

    test('strips times units and typos', () {
      final strips = parse('LAXEOL PI 5MG 25 STRIPS X 10 TAB.');
      expect(strips.stripCount, 25);
      expect(strips.unitsPerStrip, 10);
      expect(strips.packCount, 250);
      expect(parse('DOSTA 30 TABLES').packCount, 30);
      expect(parse('BONDIGA 30TABLETS').packCount, 30);
      expect(parse('MARVICA 20 PEICES').form, DrugForms.piece);
    });

    test('large international units', () {
      final f = parse('A-VITON 50.000 I.U. 20 CAPS.');
      expect(f.strength, '50,000 IU');
      expect(f.packCount, 20);
    });
  });

  group('Same medicine in different forms', () {
    test('syrup, drops, vial and sachets each get their own form', () {
      final syrup = parse('DESLORAT 2.5MG/5ML SYRUP 100ML', 'ORAL.LIQUID');
      expect(syrup.form, DrugForms.syrup);
      expect(syrup.doseUnit, 'ml');
      expect(syrup.strength, '2.5 mg/5 ml');
      expect(syrup.contentAmount, 100);
      expect(syrup.contentUnit, 'ml');

      final drops = parse('AUGMENTIN 62.5MG/ML INFANT DROPS 20 ML');
      expect(drops.form, DrugForms.drops);
      expect(drops.doseUnit, 'drop');

      final eye = parse('HYFRESH 0.2% EYE DROPS 10 ML', 'EYE');
      expect(eye.form, DrugForms.eyeDrops);
      expect(eye.route, DrugRoutes.eye);
      expect(eye.strength, '0.2%');

      final vial = parse('AUGMENTIN 1.2G VIAL FOR I.V. INJ./INF.', 'INJECTION');
      expect(vial.form, DrugForms.vial);
      expect(vial.packCount, 1);
      expect(vial.strength, '1.2 g');
      expect(vial.doseUnit, 'injection');
      expect(vial.contentAmount, isNull);

      expect(parse('AUGMENTIN 625 MG 10 F.C.TABS.').brand,
          parse('AUGMENTIN 156 MG/5 ML SUSP. 80 ML').brand);
    });

    test('a cream weight is the tube size, not the strength', () {
      final cream = parse('ALLERGEX 1.5% CREAM 20 GM', 'TOPICAL');
      expect(cream.form, DrugForms.cream);
      expect(cream.strength, '1.5%');
      expect(cream.contentAmount, 20);
      expect(cream.contentUnit, 'g');
      final gel = parse('PHARMAKON DEEP FREEZE GEL 125 GM');
      expect(gel.strength, isNull);
      expect(gel.doseUnit, 'application');
    });

    test('ampoules with a volume each, and subcutaneous injections', () {
      final amps = parse('PROGESTERONE-AIT 100MG/2ML 10 AMP.');
      expect(amps.packCount, 10);
      expect(amps.form, DrugForms.ampoule);
      final pens = parse('ARIXTRA 10MG/0.8ML 10 S.C. PREFILLED SYRINGES(N/A)');
      expect(pens.form, DrugForms.syringe);
      expect(pens.formDetails, contains(DrugFormDetails.subcutaneous));
      expect(pens.formDetails, isNot(contains(DrugFormDetails.sugarCoated)));
      expect(pens.flags, {DrugFlags.notAvailable});
    });

    test('numbers in the brand or with units are not pack counts', () {
      expect(parse('ULTRAVIST-300  VIAL 100 ML').packCount, 1);
      expect(parse('DYSPORT 500UNIT VIAL').packCount, 1);
      expect(parse('3 FLY 600 MG 20 TABS.').packCount, 20);
      expect(parse('1 2 3 (ONE TWO THREE) SUSP. 120 ML').brand, isNotEmpty);
    });
  });

  test('brand drops the form word and keeps short codes', () {
    expect(parse('SANSOVIT PLUS SYRUP 480 ML (N/A)').brand, 'Sansovit Plus');
    expect(parse('METFORMIN-EVA XR 500 MG 30 TABS.').brand, 'Metformin-Eva XR');
    expect(parse('B.C.G. VACCINE 1 MG AMP.').brand, 'B.C.G. Vaccine');
  });

  test('availability notes', () {
    expect(parse('COUGH REST SYRUP 120ML (CANCELLED)').flags,
        {DrugFlags.cancelled});
    expect(parse('5-HT 200 MG 60 CAPS. (ILLEGAL IMPORT)').flags,
        {DrugFlags.illegalImport});
  });

  test('names without structure still give a brand', () {
    final f = parse('CENTRAVITA PRO MAN');
    expect(f.brand, 'Centravita Pro Man');
    expect(f.packCount, isNull);
    expect(f.strength, isNull);
  });
}
