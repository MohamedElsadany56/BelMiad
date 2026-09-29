import 'dart:async';

import 'package:drift/drift.dart' show TableInfo, TableUpdateQuery;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../core/files/app_file_store.dart';
import '../../core/notifications/local_notifier.dart';
import '../../core/session/session_context.dart';
import '../../core/settings/settings_repository.dart';
import '../../core/time/clock.dart';
import '../../core/time/patient_time.dart';
import '../../features/audit/data/audit_log.dart';
import '../../features/backup/application/backup_service.dart';
import '../../features/caregivers/data/caregiver_repository.dart';
import '../../features/catalog/data/drug_catalog_database.dart';
import '../../features/catalog/data/drug_catalog_repository.dart';
import '../../features/doses/application/dose_service.dart';
import '../../features/doses/data/dose_repository.dart';
import '../../features/health/data/health_repositories.dart';
import '../../features/inventory/application/inventory_service.dart';
import '../../features/inventory/application/stock_forecast_service.dart';
import '../../features/inventory/data/inventory_repository.dart';
import '../../features/meals/data/meal_repository.dart';
import '../../features/medications/data/medication_repository.dart';
import '../../features/notifications/application/notification_engine.dart';
import '../../features/notifications/data/notification_repository.dart';
import '../../features/patients/data/patient_repository.dart';
import '../../features/patients/domain/patient_profile.dart';
import '../../features/reports/application/pdf_report_service.dart';
import '../../features/reports/application/report_service.dart';
import '../../features/schedules/application/dose_generation_service.dart';
import '../../features/schedules/application/schedule_plan_loader.dart';
import '../../features/schedules/data/schedule_repository.dart';
import '../../features/trash/data/trash_repository.dart';

// ------------------------------------------------------------- infrastructure

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Overridden in main()'),
);

final clockProvider = Provider<Clock>((ref) => systemClock);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = openAppDatabase();
  ref.onDispose(db.close);
  return db;
});

final catalogDatabaseProvider = Provider<DrugCatalogDatabase>((ref) {
  final db = openDrugCatalogDatabase();
  ref.onDispose(db.close);
  return db;
});

final fileStoreProvider = Provider<AppFileStore>((ref) => AppFileStore());

final localNotifierProvider =
    Provider<LocalNotifier>((ref) => createPlatformNotifier());

final settingsRepositoryProvider =
    Provider((ref) => SettingsRepository(ref.watch(databaseProvider)));

final settingsProvider = StreamProvider<AppSettingsData>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// Caregiver identity attached to recorded actions (not authentication).
final sessionProvider = Provider<SessionContext>((ref) {
  final session = SessionContext();
  ref.listen<AsyncValue<AppSettingsData>>(
    settingsProvider,
    (_, next) => session.actorPersonId = next.valueOrNull?.devicePersonId,
    fireImmediately: true,
  );
  return session;
});

// ---------------------------------------------------------------- services

final auditLogProvider = Provider((ref) => AuditLog(
      ref.watch(databaseProvider),
      ref.watch(sessionProvider),
      clock: ref.watch(clockProvider),
    ));

final patientRepositoryProvider = Provider((ref) => PatientRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final caregiverRepositoryProvider = Provider((ref) => CaregiverRepository(
      ref.watch(databaseProvider),
      ref.watch(settingsRepositoryProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final medicationRepositoryProvider = Provider((ref) => MedicationRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final mealRepositoryProvider = Provider((ref) => MealRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final scheduleRepositoryProvider = Provider((ref) => ScheduleRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final planLoaderProvider =
    Provider((ref) => SchedulePlanLoader(ref.watch(databaseProvider)));

final doseGenerationProvider = Provider((ref) => DoseGenerationService(
      ref.watch(databaseProvider),
      ref.watch(planLoaderProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final inventoryRepositoryProvider = Provider((ref) => InventoryRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      ref.watch(sessionProvider),
      clock: ref.watch(clockProvider),
    ));

final inventoryServiceProvider = Provider((ref) => InventoryService(
      ref.watch(databaseProvider),
      ref.watch(inventoryRepositoryProvider),
      clock: ref.watch(clockProvider),
    ));

final doseServiceProvider = Provider((ref) => DoseService(
      ref.watch(databaseProvider),
      ref.watch(inventoryRepositoryProvider),
      ref.watch(inventoryServiceProvider),
      ref.watch(auditLogProvider),
      ref.watch(sessionProvider),
      clock: ref.watch(clockProvider),
    ));

final doseRepositoryProvider =
    Provider((ref) => DoseRepository(ref.watch(databaseProvider)));

final stockForecastServiceProvider = Provider((ref) => StockForecastService(
      ref.watch(databaseProvider),
      ref.watch(planLoaderProvider),
      ref.watch(settingsRepositoryProvider),
      clock: ref.watch(clockProvider),
    ));

final trashRepositoryProvider = Provider((ref) {
  final files = ref.watch(fileStoreProvider);
  return TrashRepository(
    ref.watch(databaseProvider),
    ref.watch(auditLogProvider),
    clock: ref.watch(clockProvider),
    deleteFile: files.delete,
  );
});

final appointmentRepositoryProvider = Provider((ref) => AppointmentRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final vitalsRepositoryProvider = Provider((ref) => VitalsRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final illnessRepositoryProvider = Provider((ref) => IllnessRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final dietaryRuleRepositoryProvider = Provider((ref) => DietaryRuleRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final prescriptionRepositoryProvider = Provider((ref) => PrescriptionRepository(
      ref.watch(databaseProvider),
      ref.watch(auditLogProvider),
      ref.watch(fileStoreProvider),
      clock: ref.watch(clockProvider),
    ));

final notificationRepositoryProvider = Provider((ref) => NotificationRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider)));

final notificationEngineProvider = Provider((ref) => NotificationEngine(
      ref.watch(databaseProvider),
      ref.watch(localNotifierProvider),
      ref.watch(stockForecastServiceProvider),
      ref.watch(settingsRepositoryProvider),
      clock: ref.watch(clockProvider),
    ));

final reportServiceProvider = Provider((ref) => ReportService(
      ref.watch(databaseProvider),
      ref.watch(stockForecastServiceProvider),
      clock: ref.watch(clockProvider),
    ));

final pdfReportServiceProvider = Provider((ref) => PdfReportService());

final backupServiceProvider = Provider((ref) => BackupService(
      ref.watch(databaseProvider),
      ref.watch(fileStoreProvider),
      ref.watch(auditLogProvider),
      clock: ref.watch(clockProvider),
    ));

final catalogRepositoryProvider = Provider(
  (ref) => DrugCatalogRepository(ref.watch(catalogDatabaseProvider)),
);

// ------------------------------------------------------------- app state

final patientsProvider = StreamProvider<List<PatientProfile>>(
  (ref) => ref.watch(patientRepositoryProvider).watchActive(),
);

/// The explicitly selected patient; falls back to the first active patient.
final currentPatientProvider = Provider<PatientProfile?>((ref) {
  final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
  if (patients.isEmpty) return null;
  final selected = ref.watch(settingsProvider).valueOrNull?.currentPatientId;
  return patients.firstWhere(
    (p) => p.id == selected,
    orElse: () => patients.first,
  );
});

final currentPatientIdProvider =
    Provider<String?>((ref) => ref.watch(currentPatientProvider)?.id);

final patientTimeProvider = Provider<PatientTime>((ref) {
  final patient = ref.watch(currentPatientProvider);
  return PatientTime(patient?.timezone ?? defaultTimezone);
});

final devicePersonProvider = StreamProvider<Person?>((ref) {
  final id = ref.watch(settingsProvider).valueOrNull?.devicePersonId;
  if (id == null) return Stream.value(null);
  final db = ref.watch(databaseProvider);
  return (db.select(db.persons)..where((p) => p.personId.equals(id)))
      .watchSingleOrNull();
});

final personNamesProvider = StreamProvider<Map<String, String>>(
  (ref) => ref.watch(caregiverRepositoryProvider).watchPersonNames(),
);

Future<void> selectCurrentPatient(WidgetRef ref, String patientId) => ref
    .read(settingsRepositoryProvider)
    .set(SettingKeys.currentPatientId, patientId);

/// Re-runs [compute] whenever one of [tables] changes.
Stream<T> watchComputation<T>(
  AppDatabase db,
  List<TableInfo> tables,
  Future<T> Function() compute,
) async* {
  yield await compute();
  await for (final _ in db.tableUpdates(TableUpdateQuery.onAllTables(tables))) {
    yield await compute();
  }
}

final inventoryDashboardProvider =
    StreamProvider.family<InventoryDashboardData, String>((ref, patientId) {
  final db = ref.watch(databaseProvider);
  final service = ref.watch(stockForecastServiceProvider);
  return watchComputation(
    db,
    service.dependencies,
    () => service.forPatient(patientId),
  );
});

final medicationStockProvider =
    StreamProvider.family<MedicationStock?, String>((ref, medicationId) {
  final db = ref.watch(databaseProvider);
  final service = ref.watch(stockForecastServiceProvider);
  return watchComputation(
    db,
    service.dependencies,
    () => service.forMedication(medicationId),
  );
});

// ------------------------------------------------------ language and theme

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._prefs)
      : super(Locale(_prefs.getString(_key) == 'ar' ? 'ar' : 'en'));

  static const _key = 'language_code';
  final SharedPreferences _prefs;

  Future<void> set(String languageCode) async {
    state = Locale(languageCode);
    await _prefs.setString(_key, languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(ref.watch(sharedPreferencesProvider)),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._prefs) : super(_read(_prefs));

  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  /// Light mode is the default.
  static ThemeMode _read(SharedPreferences prefs) =>
      switch (prefs.getString(_key)) {
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.light,
      };

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(ref.watch(sharedPreferencesProvider)),
);

// --------------------------------------------------------------- syncing

/// Keeps doses generated, missed doses marked and notifications scheduled.
class SyncCoordinator {
  SyncCoordinator(this._ref);

  final Ref _ref;
  Timer? _debounce;
  Future<void>? _running;
  final _regenerate = <String>{};

  /// Runs a sync soon; [regeneratePatientId] rebuilds that patient's future
  /// doses (after schedule, meal, medication or timezone changes).
  void request({String? regeneratePatientId}) {
    if (regeneratePatientId != null) _regenerate.add(regeneratePatientId);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), run);
  }

  Future<void> run() async {
    if (_running != null) {
      await _running;
    }
    final completer = Completer<void>();
    _running = completer.future;
    try {
      final settings = await _ref.read(settingsRepositoryProvider).load();
      final generation = _ref.read(doseGenerationProvider);
      final regenerate = {..._regenerate};
      _regenerate.clear();
      for (final patientId in regenerate) {
        await generation.syncPatient(
          patientId,
          graceMinutes: settings.missedGraceMinutes,
          regenerate: true,
        );
      }
      await generation.syncAll(graceMinutes: settings.missedGraceMinutes);
      await _ref.read(notificationEngineProvider).sync(
            languageCode: _ref.read(localeProvider).languageCode,
          );
    } catch (error, stack) {
      debugPrint('Sync failed: $error\n$stack');
    } finally {
      completer.complete();
      _running = null;
    }
  }

  void dispose() => _debounce?.cancel();
}

final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final coordinator = SyncCoordinator(ref);
  ref.onDispose(coordinator.dispose);
  return coordinator;
});
