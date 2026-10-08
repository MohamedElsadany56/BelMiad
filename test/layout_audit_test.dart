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
import 'package:belmiad/features/catalog/data/drug_catalog_database.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/meals/data/meal_repository.dart';
import 'package:belmiad/features/meals/domain/meal_timing.dart';
import 'package:belmiad/features/medications/data/medication_repository.dart';
import 'package:belmiad/features/patients/data/patient_repository.dart';
import 'package:belmiad/features/schedules/data/schedule_repository.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'helpers/real_fonts.dart';

/// Renders every screen on small phones, large phones and tablets, in
/// English and Arabic, at normal and large font sizes, and fails when any
/// text is cut off ("Add medi…") or a layout overflows.
class _Seed {
  late String patientId;
  late String medicationId;
  late String scheduleId;
  late String batchId;
}

Future<_Seed> _seed(AppDatabase db) async {
  final session = SessionContext();
  final audit = AuditLog(db, session);
  final settings = SettingsRepository(db);
  final caregivers = CaregiverRepository(db, settings, audit);
  final seed = _Seed();
  final nurse = await caregivers.createPerson(fullName: 'Nurse Sara Hassan');
  await caregivers.setDeviceCaregiver(nurse);
  session.actorPersonId = nurse;
  seed.patientId = await PatientRepository(db, audit).create(
    const PatientInput(fullName: 'Mother'),
    caregiverPersonId: nurse,
  );
  await settings.set(SettingKeys.currentPatientId, seed.patientId);
  seed.medicationId = await MedicationRepository(db, audit).create(
    seed.patientId,
    const MedicationInput(
      nameEn: 'Glucophage',
      nameAr: 'جلوكوفاج',
      strength: '500 mg',
      doseUnit: 'tablet',
    ),
  );
  final breakfast =
      (await MealRepository(db, audit).listForPatient(seed.patientId))
          .firstWhere((m) => m.mealType == 'breakfast');
  final schedules = ScheduleRepository(db, audit);
  await schedules.saveGroup(
    medicationId: seed.medicationId,
    slots: [
      ScheduleSlot(
        scheduleType: ScheduleTypes.mealRelative,
        mealId: breakfast.mealId,
        timingRelation: timingRelationCode(TimingRelation.after),
        offsetMinutes: 30,
        doseQuantityScaled: 1000,
      ),
    ],
    rule: const RecurrenceRule(),
  );
  seed.scheduleId =
      (await db.select(db.medicationSchedules).get()).first.scheduleId;
  seed.batchId = await InventoryRepository(db, audit, session).addBatch(
    BatchInput.fromPackages(
      medicationId: seed.medicationId,
      packagesCount: 1,
      subPackagesPerPackage: 3,
      subPackagingType: 'strip',
      unitsPerPackage: 10,
      packagingType: 'box',
    ),
  );
  return seed;
}

class _TestCatalog extends DrugCatalogDatabase {
  _TestCatalog() : super(NativeDatabase.memory());
}

/// Text that is cut off: ellipsised, faded or clipped at its box edge.
List<String> _truncatedTexts(WidgetTester tester) {
  final found = <String>[];
  void visit(RenderObject node) {
    if (node is RenderParagraph && node.hasSize && node.size.width > 0) {
      final text = node.text.toPlainText().trim();
      if (text.isNotEmpty) {
        final clipped = node.maxLines != null || !node.softWrap
            ? node.didExceedMaxLines ||
                node.getMaxIntrinsicWidth(double.infinity) >
                        node.size.width + 1 &&
                    (node.maxLines == 1 || !node.softWrap)
            : false;
        if (clipped) {
          final where =
              node.debugCreator.toString().split(' ← ').skip(1).take(4);
          found.add('$text (in ${where.join(' ← ')})');
        }
      }
    }
    // Only what is on screen: skips offstage tabs and covered routes.
    node.visitChildrenForSemantics(visit);
  }

  for (final view in tester.binding.renderViews) {
    visit(view);
  }
  return found;
}

const _screens = [
  '/today',
  '/medications',
  '/medications/new',
  '/medications/{med}',
  '/medications/{med}?tab=1',
  '/medications/{med}?tab=2',
  '/medications/{med}?tab=3',
  '/medications/{med}/edit',
  '/medications/{med}/schedules/new',
  '/medications/{med}/schedules/{schedule}',
  '/inventory',
  '/inventory/add',
  '/inventory/batches/{batch}',
  '/health',
  '/health?tab=1',
  '/health?tab=2',
  '/health?tab=3',
  '/health?tab=4',
  '/more',
  '/more/patients',
  '/more/patients/new',
  '/more/meals',
  '/more/reports',
  '/more/notifications',
  '/more/backup',
  '/more/trash',
  '/more/audit',
  '/more/settings',
];

const _sizes = {
  'small phone': Size(320, 1400),
  'phone': Size(360, 1400),
  'large phone': Size(412, 1400),
  'tablet': Size(800, 1400),
  'landscape tablet': Size(1280, 800),
};

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUpAll(() async {
    await loadRealFonts();
    tzdata.initializeTimeZones();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  for (final language in ['en', 'ar']) {
    // System text size x in-app "Font size" setting (Settings → Font size).
    for (final (scale, fontSize) in <(double, String?)>[
      (1.0, null),
      (1.3, null),
      (1.5, null),
      (1.0, 'maximum'),
    ]) {
      testWidgets(
          'no text is cut off ($language, text x$scale'
          '${fontSize == null ? '' : ', font size $fontSize'})',
          timeout: const Timeout(Duration(minutes: 5)), (tester) async {
        SharedPreferences.setMockInitialValues({
          'language_code': language,
          if (fontSize != null) 'font_size': fontSize,
        });
        final prefs = await SharedPreferences.getInstance();
        final db = AppDatabase(NativeDatabase.memory());
        final seed = (await tester.runAsync(() => _seed(db)))!;
        final problems = <String>{};
        final container = ProviderContainer(overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          databaseProvider.overrideWithValue(db),
          catalogDatabaseProvider.overrideWithValue(_TestCatalog()),
          localNotifierProvider.overrideWithValue(NoopLocalNotifier()),
          fileStoreProvider
              .overrideWithValue(MemoryAppFileStore() as AppFileStore),
        ]);
        tester.platformDispatcher.textScaleFactorTestValue = scale;

        for (final MapEntry(key: sizeName, value: size) in _sizes.entries) {
          tester.view
            ..devicePixelRatio = 1
            ..physicalSize = size;
          await tester.pumpWidget(UncontrolledProviderScope(
            container: container,
            child: const BelMiadApp(),
          ));
          await _settle(tester);
          for (final path in _screens) {
            final location = path
                .replaceAll('{med}', seed.medicationId)
                .replaceAll('{schedule}', seed.scheduleId)
                .replaceAll('{batch}', seed.batchId);
            container.read(routerProvider).go(location);
            await _settle(tester);
            void check(String step) {
              for (final text in _truncatedTexts(tester)) {
                problems.add('$sizeName $step: "$text"');
              }
              final error = tester.takeException();
              if (error != null) {
                problems.add(
                    '$sizeName $step: ${error.toString().split('\n').first}');
              }
            }

            check(path);
            // The dose plan editor changes a lot as it is used: try every
            // preset and both kinds of time.
            if (path.contains('/schedules/')) {
              Future<void> tapAll(Finder finder, String what) async {
                for (var i = 0; i < finder.evaluate().length; i++) {
                  await tester.ensureVisible(finder.at(i));
                  await tester.tap(finder.at(i), warnIfMissed: false);
                  await _settle(tester);
                  check('$path [$what ${i + 1}]');
                }
              }

              await tapAll(find.byType(ActionChip), 'preset');
              await tapAll(
                find.descendant(
                  of: find.byType(SegmentedButton<String>),
                  matching: find.byType(Text),
                ),
                'time type',
              );
            }
          }
        }

        await tester.pumpWidget(const SizedBox.shrink());
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        tester.view.reset();
        container.dispose();
        var closed = false;
        db.close().whenComplete(() => closed = true);
        for (var i = 0; i < 20 && !closed; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.pump(const Duration(seconds: 2));
        final sorted = problems.toList()..sort();
        for (final p in sorted) {
          printOnFailure('PROBLEM[$language x$scale] $p');
        }
        expect(sorted, isEmpty);
      });
    }
  }
}
