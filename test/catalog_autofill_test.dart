import 'dart:convert';

import 'package:belmiad/app/app.dart';
import 'package:belmiad/app/providers/app_providers.dart';
import 'package:belmiad/app/router/app_router.dart';
import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/core/files/app_file_store.dart';
import 'package:belmiad/core/files/app_file_store_stub.dart';
import 'package:belmiad/core/notifications/local_notifier.dart';
import 'package:belmiad/core/session/session_context.dart';
import 'package:belmiad/core/settings/settings_repository.dart';
import 'package:belmiad/features/audit/data/audit_log.dart';
import 'package:belmiad/features/caregivers/data/caregiver_repository.dart';
import 'package:belmiad/features/catalog/data/catalog_importer.dart';
import 'package:belmiad/features/catalog/data/drug_catalog_database.dart';
import 'package:belmiad/features/patients/data/patient_repository.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

class _TestCatalog extends DrugCatalogDatabase {
  _TestCatalog() : super(NativeDatabase.memory());
}

class _Sink implements CatalogSink {
  _Sink(this.db);

  final GeneratedDatabase db;

  @override
  Future<void> insertBatch(List<CatalogRow> rows) async {
    for (final row in rows) {
      await db.customInsert(
        CatalogSchema.insert,
        variables: [
          for (final p in row.parameters)
            switch (p) {
              null => const Variable<String>(null),
              final double d => Variable.withReal(d),
              final int i => Variable.withInt(i),
              _ => Variable.withString(p as String),
            },
        ],
      );
    }
  }
}

const _csv = 'commercial_name_en,commercial_name_ar,scientific_name,'
    'manufacturer,drug_class,route,price_egp\n'
    'AUGMENTIN 625 MG 10 F.C.TABS.,اوجمنتين,AMOXICILLIN+CLAVULANIC ACID,'
    'GSK,ANTIBIOTIC,ORAL.SOLID,90\n'
    'AUGMENTIN 312 MG/5ML SUSP. 80 ML,اوجمنتين,AMOXICILLIN+CLAVULANIC ACID,'
    'GSK,ANTIBIOTIC,ORAL.LIQUID,60\n';

Future<void> _settle(WidgetTester tester, [int rounds = 8]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

String _field(WidgetTester tester, String label) => tester
    .widget<TextField>(find.descendant(
      of: find.widgetWithText(TextFormField, label),
      matching: find.byType(TextField),
    ))
    .controller!
    .text;

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  testWidgets(
      'picking a catalog medicine fills the form, other forms can be '
      'switched to, and the stock pack size is suggested',
      timeout: const Timeout(Duration(seconds: 90)), (tester) async {
    SharedPreferences.setMockInitialValues({'language_code': 'en'});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    final catalog = _TestCatalog();
    await tester.runAsync(() async {
      final session = SessionContext();
      final audit = AuditLog(db, session);
      final settings = SettingsRepository(db);
      final caregivers = CaregiverRepository(db, settings, audit);
      final nurse = await caregivers.createPerson(fullName: 'Nurse Sara');
      await caregivers.setDeviceCaregiver(nurse);
      session.actorPersonId = nurse;
      final patient = await PatientRepository(db, audit).create(
        const PatientInput(fullName: 'Mother'),
        caregiverPersonId: nurse,
      );
      await settings.set(SettingKeys.currentPatientId, patient);
      await catalog.customSelect('SELECT 1').get();
      await CatalogImporter().import(
        Stream.fromIterable(const LineSplitter().convert(_csv)),
        _Sink(catalog),
      );
      await catalog.customStatement(CatalogSchema.rebuildFts);
    });

    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(420, 1600);
    addTearDown(tester.view.reset);
    final container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      databaseProvider.overrideWithValue(db),
      catalogDatabaseProvider.overrideWithValue(catalog),
      localNotifierProvider.overrideWithValue(NoopLocalNotifier()),
      fileStoreProvider.overrideWithValue(MemoryAppFileStore() as AppFileStore),
    ]);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const BelMiadApp(),
    ));
    await _settle(tester);

    // Search the catalog: each result says its form and pack size.
    container.read(routerProvider).go('/medications/new');
    await _settle(tester);
    await tester.enterText(find.byType(TextField).first, 'augmentin');
    await _settle(tester);
    expect(find.text('Tablet (film-coated) · 625 mg · 10 tablets'),
        findsOneWidget);
    expect(find.text('Suspension · 312 mg/5 ml · 80 ml'), findsOneWidget);

    // Picking the tablets fills the form.
    await tester.tap(find.ancestor(
      of: find.text('AUGMENTIN 625 MG 10 F.C.TABS.'),
      matching: find.byType(ListTile),
    ));
    await _settle(tester);
    expect(_field(tester, 'Name (English)'), 'Augmentin');
    expect(_field(tester, 'Strength (e.g. 500 mg)'), '625 mg');
    expect(_field(tester, 'Dosage form'), 'Tablet (film-coated)');
    expect(_field(tester, 'Route'), 'By mouth');
    expect(_field(tester, 'Scientific / generic name'),
        'Amoxicillin + Clavulanic Acid');
    expect(find.text('tablet'), findsWidgets); // dose unit
    expect(find.byIcon(Icons.auto_awesome_outlined), findsWidgets);

    // The user renames it, then switches to the suspension: their name is
    // kept, the rest follows the new form.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name (English)'),
      'Augmentin for Mother',
    );
    await tester.tap(find.text('Other forms and sizes (1)'));
    await _settle(tester);
    await tester.tap(find.text('Suspension · 312 mg/5 ml · 80 ml'));
    await _settle(tester);
    expect(_field(tester, 'Name (English)'), 'Augmentin for Mother');
    expect(_field(tester, 'Strength (e.g. 500 mg)'), '312 mg/5 ml');
    expect(_field(tester, 'Dosage form'), 'Suspension');
    expect(find.text('ml'), findsWidgets); // dose unit follows the form

    // Save and add stock: an 80 ml bottle is suggested.
    await tester.tap(find.text('Save'));
    await _settle(tester, 12);
    await tester.tap(find.widgetWithText(FilledButton, 'Add stock'));
    await _settle(tester, 12);
    expect(
      find.textContaining('Suggested from the drug catalog: 80 ml'),
      findsOneWidget,
    );
    expect(find.text('Bottle'), findsWidgets);
    expect(find.widgetWithText(TextFormField, '80'), findsOneWidget);

    final medication =
        (await tester.runAsync(() => db.select(db.medications).getSingle()))!;
    expect(medication.nameEn, 'Augmentin for Mother');
    expect(medication.doseUnit, 'ml');
    expect(medication.strength, '312 mg/5 ml');

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    var closed = 0;
    db.close().whenComplete(() => closed++);
    catalog.close().whenComplete(() => closed++);
    for (var i = 0; i < 20 && closed < 2; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(const Duration(seconds: 2));
  });
}
