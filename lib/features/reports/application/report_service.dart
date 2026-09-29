import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/clock.dart';
import '../../doses/domain/dose_status.dart';
import '../../inventory/application/stock_forecast_service.dart';
import '../../medications/data/medication_repository.dart';
import '../domain/report_models.dart';

typedef ScheduleDescriber = String Function(
  MedicationSchedule schedule,
  Medication medication,
  Meal? meal,
);

DoseOutcome outcomeOf(DoseInstance dose) =>
    switch (DoseStatus.fromCode(dose.status)) {
      DoseStatus.taken => isTakenLate(dose.lateMinutes)
          ? DoseOutcome.takenLate
          : DoseOutcome.takenOnTime,
      DoseStatus.missed => DoseOutcome.missed,
      DoseStatus.skipped => DoseOutcome.skipped,
      DoseStatus.scheduled => DoseOutcome.pending,
    };

/// Builds doctor and storage reports from the local database (spec §26, §31).
class ReportService {
  ReportService(this._db, this._forecast, {Clock clock = systemClock})
      : _clock = clock;

  final AppDatabase _db;
  final StockForecastService _forecast;
  final Clock _clock;

  Future<DoctorReport> doctorReport({
    required String patientId,
    required ReportLevel level,
    required bool arabic,
    required ScheduleDescriber describeSchedule,
    DateTime? from,
    DateTime? to,
  }) async {
    final now = _clock();
    final patient = await (_db.select(_db.patients)
          ..where((p) => p.patientId.equals(patientId)))
        .getSingle();
    final person = await (_db.select(_db.persons)
          ..where((p) => p.personId.equals(patientId)))
        .getSingle();
    final medications = await (_db.select(_db.medications)
          ..where((m) => m.patientId.equals(patientId) & m.deletedAt.isNull())
          ..orderBy([(m) => OrderingTerm.asc(m.nameEn)]))
        .get();
    final schedules = medications.isEmpty
        ? <MedicationSchedule>[]
        : await (_db.select(_db.medicationSchedules)
              ..where(
                (s) =>
                    s.medicationId
                        .isIn(medications.map((m) => m.medicationId)) &
                    s.deletedAt.isNull() &
                    s.isActive.equals(true),
              ))
            .get();
    final meals = await (_db.select(_db.meals)
          ..where((m) => m.patientId.equals(patientId)))
        .get();
    final mealsById = {for (final m in meals) m.mealId: m};

    final doseQuery = _db.select(_db.doseInstances)
      ..where(
        (d) =>
            d.patientId.equals(patientId) &
            (d.isPrn.equals(false) | d.status.equals(DoseStatus.taken.code)) &
            // Due doses, plus doses already resolved ahead of time (e.g.
            // taken early).
            (d.scheduledAt.isSmallerOrEqualValue(to ?? now) |
                d.status.equals(DoseStatus.scheduled.code).not()),
      )
      ..orderBy([(d) => OrderingTerm.asc(d.scheduledAt)]);
    if (from != null) {
      doseQuery.where((d) => d.scheduledAt.isBiggerOrEqualValue(from));
    }
    final doses = await doseQuery.get();
    final medsById = {for (final m in medications) m.medicationId: m};

    var overall = const AdherenceStats();
    final perMedication = <String, AdherenceStats>{};
    final reportDoses = <ReportDose>[];
    for (final dose in doses) {
      final medication = medsById[dose.medicationId];
      if (medication == null) continue;
      final outcome = outcomeOf(dose);
      if (!dose.isPrn) {
        overall = overall.add(outcome);
        perMedication[dose.medicationId] =
            (perMedication[dose.medicationId] ?? const AdherenceStats())
                .add(outcome);
      }
      if (level == ReportLevel.detailed) {
        reportDoses.add(ReportDose(
          medicationName: medicationDisplayName(medication, arabic: arabic),
          scheduledAt: dose.scheduledAt,
          outcome: outcome,
          requiredScaled: dose.requiredQuantityScaled,
          actualScaled: dose.actualQuantityScaled,
          takenAt: dose.takenAt,
          lateMinutes: dose.lateMinutes,
          isPrn: dose.isPrn,
        ));
      }
    }

    final includeMedication = medications.where(
      (m) =>
          m.status == MedicationStatus.active ||
          perMedication.containsKey(m.medicationId),
    );

    final vitalsQuery = _db.select(_db.vitalsMeasurements)
      ..where((v) => v.patientId.equals(patientId) & v.deletedAt.isNull())
      ..orderBy([(v) => OrderingTerm.desc(v.measuredAt)]);
    if (from != null) {
      vitalsQuery.where((v) => v.measuredAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      vitalsQuery.where((v) => v.measuredAt.isSmallerOrEqualValue(to));
    }
    var vitals = await vitalsQuery.get();
    if (level == ReportLevel.summary) {
      final latest = <String, VitalMeasurement>{};
      for (final v in vitals) {
        latest.putIfAbsent('${v.measurementType}|${v.context}', () => v);
      }
      vitals = latest.values.toList();
    }

    final appointmentsQuery = _db.select(_db.appointments)
      ..where((a) => a.patientId.equals(patientId) & a.deletedAt.isNull())
      ..orderBy([(a) => OrderingTerm.desc(a.scheduledTime)]);
    if (from != null) {
      appointmentsQuery.where(
        (a) =>
            a.scheduledTime.isBiggerOrEqualValue(from) |
            a.scheduledTime.isBiggerThanValue(now),
      );
    }
    final appointments = await appointmentsQuery.get();

    return DoctorReport(
      mealNames: {
        for (final m in meals)
          m.mealId: arabic && m.nameAr.isNotEmpty ? m.nameAr : m.nameEn,
      },
      medicationNames: {
        for (final m in medications)
          m.medicationId: medicationDisplayName(m, arabic: arabic),
      },
      level: level,
      generatedAt: now,
      patientName: person.fullName,
      patient: patient,
      periodFrom: from,
      periodTo: to,
      overall: overall,
      doses: reportDoses,
      medications: [
        for (final medication in includeMedication)
          ReportMedication(
            medication: medication,
            displayName: medicationDisplayName(medication, arabic: arabic),
            instructions: arabic
                ? (medication.instructionsAr ?? medication.instructionsEn)
                : (medication.instructionsEn ?? medication.instructionsAr),
            scheduleLines: [
              for (final s in schedules.where(
                (s) => s.medicationId == medication.medicationId,
              ))
                describeSchedule(s, medication, mealsById[s.mealId]),
            ],
            adherence: perMedication[medication.medicationId] ??
                const AdherenceStats(),
          ),
      ],
      vitals: vitals,
      appointments: appointments,
      illnesses: await (_db.select(_db.patientIllnesses)
            ..where((i) => i.patientId.equals(patientId) & i.deletedAt.isNull())
            ..orderBy([(i) => OrderingTerm.desc(i.diagnosedDate)]))
          .get(),
      dietaryRules: await (_db.select(_db.dietaryRules)
            ..where(
                (d) => d.patientId.equals(patientId) & d.deletedAt.isNull()))
          .get(),
    );
  }

  Future<InventoryReport> inventoryReport({
    required String patientId,
    required bool arabic,
  }) async {
    final person = await (_db.select(_db.persons)
          ..where((p) => p.personId.equals(patientId)))
        .getSingle();
    final data = await _forecast.forPatient(patientId);
    return InventoryReport(
      generatedAt: _clock(),
      patientName: person.fullName,
      rows: [
        for (final item in data.items) _inventoryRow(item, arabic),
      ],
    );
  }

  InventoryReportRow _inventoryRow(MedicationStock item, bool arabic) {
    final purchases = [...item.batches]
      ..sort((a, b) => (b.purchaseDate ?? '').compareTo(a.purchaseDate ?? ''));
    final last = purchases.isEmpty ? null : purchases.first;
    return InventoryReportRow(
      medication: item.medication,
      displayName: medicationDisplayName(item.medication, arabic: arabic),
      summary: item.summary,
      batchCount: item.batches.length,
      lastPurchaseDate: last?.purchaseDate,
      lastPurchasePrice: last?.purchasePrice,
      totalSpent: item.batches.fold(0.0, (s, b) => s + (b.purchasePrice ?? 0)),
    );
  }
}
