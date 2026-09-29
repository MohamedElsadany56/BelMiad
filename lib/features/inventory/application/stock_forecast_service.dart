import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/settings/settings_repository.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/patient_time.dart';
import '../../medications/data/medication_repository.dart';
import '../../schedules/application/schedule_plan_loader.dart';
import '../../schedules/domain/schedule_plan.dart';
import '../data/inventory_repository.dart';
import '../domain/stock_forecast.dart';

class MedicationStock {
  const MedicationStock({
    required this.medication,
    required this.summary,
    required this.batches,
  });

  final Medication medication;
  final StockSummary summary;
  final List<InventoryBatch> batches;
}

class InventoryDashboardData {
  const InventoryDashboardData(this.items);

  final List<MedicationStock> items;

  int get totalMedications => items.length;
  int get withStock => items.where((i) => i.summary.usableScaled > 0).length;
  int get lowStock => items.where((i) => i.summary.isLowStock).length;
  int get emptyStock => items
      .where(
        (i) =>
            i.summary.state == StockState.empty ||
            i.summary.state == StockState.expiredOnly,
      )
      .length;
  int get expiringSoon => items.where((i) => i.summary.hasExpiringBatch).length;
  int get noStockRecorded =>
      items.where((i) => i.summary.state == StockState.noStockRecorded).length;
}

/// Computes stock state, low-stock forecast and remaining days (spec §21–§23)
/// in a single place so widgets never duplicate the calculation.
class StockForecastService {
  StockForecastService(
    this._db,
    this._loader,
    this._settings, {
    Clock clock = systemClock,
    StockForecaster forecaster = const StockForecaster(),
  })  : _clock = clock,
        _forecaster = forecaster;

  final AppDatabase _db;
  final SchedulePlanLoader _loader;
  final SettingsRepository _settings;
  final Clock _clock;
  final StockForecaster _forecaster;

  /// Tables whose changes invalidate a forecast.
  List<TableInfo> get dependencies => [
        _db.medications,
        _db.medicationInventoryBatches,
        _db.medicationSchedules,
        _db.meals,
        _db.patients,
        _db.appSettings,
      ];

  Future<InventoryDashboardData> forPatient(
    String patientId, {
    bool includeArchived = false,
  }) async {
    final patient = await (_db.select(_db.patients)
          ..where((p) => p.patientId.equals(patientId)))
        .getSingleOrNull();
    if (patient == null) return const InventoryDashboardData([]);
    final settings = await _settings.load();
    final time = PatientTime(patient.timezone);
    final medsQuery = _db.select(_db.medications)
      ..where((m) => m.patientId.equals(patientId) & m.deletedAt.isNull())
      ..orderBy([(m) => OrderingTerm.asc(m.nameEn)]);
    if (!includeArchived) {
      medsQuery.where((m) => m.status.equals(MedicationStatus.active));
    }
    final medications = await medsQuery.get();
    final plans = await _loader.forecastPlans(patientId);
    final batches = medications.isEmpty
        ? <InventoryBatch>[]
        : await (_db.select(_db.medicationInventoryBatches)
              ..where(
                (b) =>
                    b.medicationId
                        .isIn(medications.map((m) => m.medicationId)) &
                    b.deletedAt.isNull(),
              ))
            .get();
    final now = _clock();
    return InventoryDashboardData([
      for (final medication in medications)
        _build(
          medication,
          batches
              .where((b) => b.medicationId == medication.medicationId)
              .toList(),
          plans[medication.medicationId] ?? const [],
          now,
          time,
          settings.expiringWithinDays,
        ),
    ]);
  }

  Future<MedicationStock?> forMedication(String medicationId) async {
    final medication = await (_db.select(_db.medications)
          ..where((m) => m.medicationId.equals(medicationId)))
        .getSingleOrNull();
    if (medication == null) return null;
    final patient = await (_db.select(_db.patients)
          ..where((p) => p.patientId.equals(medication.patientId)))
        .getSingleOrNull();
    final settings = await _settings.load();
    final time = PatientTime(patient?.timezone ?? defaultTimezone);
    final plans = medication.status == MedicationStatus.active
        ? await _loader.plansForPatient(
            medication.patientId,
            medicationId: medicationId,
          )
        : const <SchedulePlan>[];
    final batches = await (_db.select(_db.medicationInventoryBatches)
          ..where(
            (b) => b.medicationId.equals(medicationId) & b.deletedAt.isNull(),
          ))
        .get();
    return _build(
      medication,
      batches,
      plans,
      _clock(),
      time,
      settings.expiringWithinDays,
    );
  }

  MedicationStock _build(
    Medication medication,
    List<InventoryBatch> batches,
    List<SchedulePlan> plans,
    DateTime now,
    PatientTime time,
    int expiringWithinDays,
  ) {
    final summary = _forecaster.summarize(
      batches: batches.map(snapshotOf).toList(),
      plans: plans,
      now: now,
      time: time,
      expiringWithinDays: expiringWithinDays,
    );
    return MedicationStock(
      medication: medication,
      summary: summary,
      batches: batches,
    );
  }
}
