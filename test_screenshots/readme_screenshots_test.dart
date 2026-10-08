// Renders the README screenshots at a phone resolution (1080 × 2340, the
// size of a typical Android phone) in English and Arabic, from the demo data.
//
//   flutter test test_screenshots
//
// Writes docs/screenshots/{en,ar}/*.png. Not part of the normal test run.
//
// Lives outside test/ so `flutter test` skips it; the analyzer then treats
// it as app code, hence:
// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:io';
import 'dart:ui' as ui;

import 'package:belmiad/app/app.dart';
import 'package:belmiad/app/demo/demo_seed.dart';
import 'package:belmiad/app/providers/app_providers.dart';
import 'package:belmiad/app/router/app_router.dart';
import 'package:belmiad/core/database/app_database.dart';
import 'package:belmiad/core/files/app_file_store.dart';
import 'package:belmiad/core/files/app_file_store_stub.dart';
import 'package:belmiad/core/notifications/local_notifier.dart';
import 'package:belmiad/features/catalog/data/drug_catalog_database.dart';
import 'package:belmiad/features/notifications/presentation/reminder_sound_picker.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../test/helpers/real_fonts.dart';

/// 1080 × 2340 pixels at 2.625 dpi: 411 × 891 logical pixels.
const _physical = Size(1080, 2340);
const _pixelRatio = 2.625;

final _boundary = GlobalKey();

Future<void> _settle(WidgetTester tester, [int rounds = 10]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Waits for database work by pumping the test clock.
Future<T> _wait<T>(WidgetTester tester, Future<T> future) async {
  T? value;
  Object? error;
  var done = false;
  future.then((v) {
    value = v;
    done = true;
  }, onError: (Object e) {
    error = e;
    done = true;
  });
  for (var i = 0; i < 600 && !done; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  if (error != null) throw error!;
  if (!done) throw StateError('timed out');
  return value as T;
}

Future<void> _shot(WidgetTester tester, String language, String name) async {
  await _settle(tester);
  final boundary =
      _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: _pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('docs/screenshots/$language/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

class _TestCatalog extends DrugCatalogDatabase {
  _TestCatalog(File file) : super(NativeDatabase(file));
}

/// Starts the app on fresh demo data.
Future<(ProviderContainer, AppDatabase)> _start(
  WidgetTester tester, {
  required String language,
  required bool dark,
}) async {
  SharedPreferences.setMockInitialValues({
    'language_code': language,
    'theme_mode': dark ? 'dark' : 'light',
  });
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase(NativeDatabase.memory());
  // A copy, so the bundled catalog is never touched.
  final catalogFile = File(
    '${Directory.systemTemp.createTempSync('belmiad_shots').path}/catalog.sqlite',
  );
  File('assets/data/drug_catalog.sqlite').copySync(catalogFile.path);
  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    databaseProvider.overrideWithValue(db),
    catalogDatabaseProvider.overrideWithValue(_TestCatalog(catalogFile)),
    localNotifierProvider.overrideWithValue(NoopLocalNotifier()),
    fileStoreProvider.overrideWithValue(MemoryAppFileStore() as AppFileStore),
  ]);
  await _wait(tester, container.read(demoSeedProvider.future));

  // Tests draw shadows as black outlines unless told otherwise.
  debugDisableShadows = false;
  tester.view
    ..physicalSize = _physical
    ..devicePixelRatio = _pixelRatio;
  await tester.pumpWidget(RepaintBoundary(
    key: _boundary,
    child: UncontrolledProviderScope(
      container: container,
      child: const BelMiadApp(),
    ),
  ));
  await _settle(tester, 20);
  return (container, db);
}

Future<void> _stop(
  WidgetTester tester,
  ProviderContainer container,
  AppDatabase db,
) async {
  await tester.pumpWidget(const SizedBox.shrink());
  container.dispose();
  var closed = false;
  db.close().whenComplete(() => closed = true);
  for (var i = 0; i < 20 && !closed; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pump(const Duration(seconds: 2));
  tester.view.reset();
  debugDisableShadows = true;
}

void main() {
  setUpAll(() async {
    await loadRealFonts();
    tzdata.initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  for (final language in ['en', 'ar']) {
    testWidgets('screenshots ($language)',
        timeout: const Timeout(Duration(minutes: 5)), (tester) async {
      final (container, db) =
          await _start(tester, language: language, dark: false);
      final router = container.read(routerProvider);
      Future<void> open(String location) async {
        router.go(location);
        await _settle(tester, 15);
      }

      final glucophage = await _wait(
        tester,
        (db.select(db.medications)
              ..where((m) => m.nameEn.equals('Glucophage')))
            .getSingle(),
      );
      final plan = (await _wait(
        tester,
        (db.select(db.medicationSchedules)
              ..where((s) => s.medicationId.equals(glucophage.medicationId)))
            .get(),
      ))
          .first;

      await open('/today');
      await _shot(tester, language, 'today');

      // Recording a dose the patient already took.
      await tester.tap(find.byType(FloatingActionButton));
      await _settle(tester);
      await tester.tap(find.byIcon(Icons.history).last);
      await _shot(tester, language, 'record-earlier');
      await tester.tapAt(const Offset(200, 40));
      await _settle(tester);

      await open('/medications');
      await _shot(tester, language, 'medicines');

      // Catalog search: each variant shows its form and pack size.
      await open('/medications/new');
      await tester.enterText(find.byType(TextField).first, 'augmentin');
      await _settle(tester, 15);
      await _shot(tester, language, 'catalog-search');

      // Picking one fills the form.
      await tester.tap(find.ancestor(
        of: find.text('AUGMENTIN 625 MG 10 F.C.TABS.'),
        matching: find.byType(ListTile),
      ));
      await _settle(tester, 15);
      await _shot(tester, language, 'catalog-autofill');

      // Other forms of the same medicine.
      await tester.tap(find.byType(ExpansionTile));
      await _settle(tester);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -210));
      await _shot(tester, language, 'catalog-other-forms');

      await open(
        '/medications/${glucophage.medicationId}/schedules/'
        '${plan.groupId ?? plan.scheduleId}',
      );
      await _shot(tester, language, 'dose-plan');

      await open('/inventory');
      await _shot(tester, language, 'stock');

      await open('/medications/${glucophage.medicationId}?tab=2');
      await _shot(tester, language, 'stock-batch');

      await open('/health?tab=1');
      await _shot(tester, language, 'vitals');

      await open('/more/reports');
      await _shot(tester, language, 'reports');

      await open('/more/settings');
      await tester.tap(find.byType(ReminderSoundTile));
      await _settle(tester);
      await _shot(tester, language, 'reminder-sound');

      await _stop(tester, container, db);
    });

    testWidgets('dark screenshots ($language)',
        timeout: const Timeout(Duration(minutes: 2)), (tester) async {
      final (container, db) =
          await _start(tester, language: language, dark: true);
      container.read(routerProvider).go('/today');
      await _settle(tester, 15);
      await _shot(tester, language, 'today-dark');
      await _stop(tester, container, db);
    });
  }
}
