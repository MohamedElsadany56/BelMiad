import 'package:belmiad/app/app.dart';
import 'package:belmiad/app/providers/app_providers.dart';
import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/core/files/app_file_store.dart';
import 'package:belmiad/core/files/app_file_store_stub.dart';
import 'package:belmiad/core/notifications/local_notifier.dart';
import 'package:belmiad/core/session/session_context.dart';
import 'package:belmiad/core/settings/settings_repository.dart';
import 'package:belmiad/core/time/patient_time.dart';
import 'package:belmiad/features/audit/data/audit_log.dart';
import 'package:belmiad/features/caregivers/data/caregiver_repository.dart';
import 'package:belmiad/features/catalog/data/catalog_importer.dart';
import 'package:belmiad/features/catalog/data/drug_catalog_database.dart';
import 'package:belmiad/features/doses/domain/dose_status.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/patients/data/patient_repository.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

class _Seed {
  late String motherId;
  late String fatherId;
  late String medicationId;
  late String batchId;
  late String doseId;
}

Future<_Seed> _seed(AppDatabase db) async {
  final session = SessionContext();
  final audit = AuditLog(db, session);
  final settings = SettingsRepository(db);
  final caregivers = CaregiverRepository(db, settings, audit);
  final patients = PatientRepository(db, audit);
  final seed = _Seed();
  final nurse = await caregivers.createPerson(fullName: 'Nurse Sara');
  await caregivers.setDeviceCaregiver(nurse);
  session.actorPersonId = nurse;
  seed.motherId = await patients.create(
    const PatientInput(fullName: 'Mother'),
    caregiverPersonId: nurse,
  );
  seed.fatherId = await patients.create(
    const PatientInput(fullName: 'Father'),
    caregiverPersonId: nurse,
  );
  await settings.set(SettingKeys.currentPatientId, seed.motherId);
  seed.medicationId = await MedicationRepository(db, audit).create(
    seed.motherId,
    const MedicationInput(
      nameEn: 'Panadol',
      nameAr: 'بانادول',
      doseUnit: 'tablet',
    ),
  );
  seed.batchId = await InventoryRepository(db, audit, session).addBatch(
    BatchInput(medicationId: seed.medicationId, quantityScaled: 20000),
  );
  // A dose due a minute ago, on the patient's current local date.
  final now = DateTime.now().toUtc();
  final scheduledAt = now.subtract(const Duration(minutes: 1));
  seed.doseId = 'dose-1';
  await db.into(db.doseInstances).insert(
        DoseInstancesCompanion.insert(
          doseInstanceId: seed.doseId,
          patientId: seed.motherId,
          medicationId: seed.medicationId,
          localDate:
              PatientTime(defaultTimezone).localDateOf(scheduledAt).toIso(),
          scheduledAt: scheduledAt,
          requiredQuantityScaled: 1000,
          status: DoseStatus.scheduled.code,
          createdAt: now,
          updatedAt: now,
        ),
      );
  return seed;
}

Future<DoseInstance> _dose(AppDatabase db, String id) =>
    (db.select(db.doseInstances)..where((d) => d.doseInstanceId.equals(id)))
        .getSingle();

Future<InventoryBatch> _batch(AppDatabase db, String id) =>
    (db.select(db.medicationInventoryBatches)
          ..where((b) => b.inventoryBatchId.equals(id)))
        .getSingle();

class _TestCatalog extends DrugCatalogDatabase {
  _TestCatalog() : super(NativeDatabase.memory());
}

Future<(AppDatabase, _Seed)> _pumpApp(
  WidgetTester tester, {
  String language = 'en',
}) async {
  SharedPreferences.setMockInitialValues({'language_code': language});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase(NativeDatabase.memory());
  final seed = (await tester.runAsync(() => _seed(db)))!;
  final catalog = _TestCatalog();
  await tester.binding.setSurfaceSize(const Size(420, 900));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        catalogDatabaseProvider.overrideWithValue(catalog),
        localNotifierProvider.overrideWithValue(NoopLocalNotifier()),
        fileStoreProvider
            .overrideWithValue(MemoryAppFileStore() as AppFileStore),
      ],
      child: const BelMiadApp(),
    ),
  );
  await _settle(tester);
  return (db, seed);
}

/// Lets Drift streams (real async) and the UI settle.
Future<void> _settle(WidgetTester tester, [int rounds = 6]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> _unmount(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox.shrink());
  var closed = false;
  db.close().whenComplete(() => closed = true);
  for (var i = 0; i < 20 && !closed; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    // Keep the catalog schema importable for the test catalog.
    expect(CatalogSchema.statements, isNotEmpty);
  });

  testWidgets('English is LTR and dose confirmation marks the dose taken',
      timeout: const Timeout(Duration(seconds: 90)), (tester) async {
    final (db, seed) = await _pumpApp(tester);
    expect(find.text('Today'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.ltr,
    );
    expect(find.text('Panadol'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Take'));
    await _settle(tester);
    expect(find.text('Mark taken'), findsOneWidget);
    await tester.tap(find.text('Mark taken'));
    await _settle(tester);

    final dose = (await tester.runAsync(() => _dose(db, seed.doseId)))!;
    expect(dose.status, DoseStatus.taken.code);
    final batch = (await tester.runAsync(() => _batch(db, seed.batchId)))!;
    expect(batch.availableQuantityScaled, 19000);
    expect(find.text('Undo taken'), findsOneWidget);
    await _unmount(tester, db);
  });

  testWidgets('Arabic is RTL with localized navigation', (tester) async {
    final (db, _) = await _pumpApp(tester, language: 'ar');
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );
    expect(find.text('الأدوية'), findsOneWidget);
    expect(find.text('بانادول'), findsOneWidget);
    await _unmount(tester, db);
  });

  testWidgets('patient selector switches the current patient', (tester) async {
    final (db, seed) = await _pumpApp(tester);
    await tester.tap(find.text('Mother').first);
    await _settle(tester, 10);
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<String>, 'Father'),
    );
    await _settle(tester, 10);
    final settings = (await tester.runAsync(
      () => SettingsRepository(db).load(),
    ))!;
    expect(settings.currentPatientId, seed.fatherId);
    expect(find.text('Father'), findsWidgets);
    expect(find.text('Panadol'), findsNothing);
    await _unmount(tester, db);
  });

  testWidgets('inventory dashboard and stock adjustment', (tester) async {
    final (db, seed) = await _pumpApp(tester);
    await tester.tap(find.text('Stock').last);
    await _settle(tester);
    expect(find.text('20 tablets'), findsOneWidget);
    expect(find.text('Medicines'), findsWidgets);

    await tester.tap(find.text('Panadol'));
    await _settle(tester, 12);
    final batchMenu = find.descendant(
      of: find.byType(Card),
      matching: find.byType(PopupMenuButton<String>),
    );
    expect(batchMenu, findsOneWidget);
    await tester.tap(batchMenu);
    await _settle(tester);
    await tester.tap(find.text('Adjust stock').last);
    await _settle(tester);
    await tester.enterText(find.byType(TextFormField).first, '2');
    await tester.tap(find.text('Save').last);
    await _settle(tester);

    final batch = (await tester.runAsync(() => _batch(db, seed.batchId)))!;
    expect(batch.availableQuantityScaled, 18000);
    final adjustments = (await tester
        .runAsync(() => db.select(db.inventoryAdjustments).get()))!;
    expect(adjustments.single.reason, 'manual_correction');
    await _unmount(tester, db);
  });
}
