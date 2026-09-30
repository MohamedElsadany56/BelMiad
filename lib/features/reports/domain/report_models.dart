import '../../../core/database/app_database.dart';
import '../../inventory/domain/stock_forecast.dart';

enum ReportLevel { summary, detailed }

/// How a dose appears in a doctor report (spec §31). Actor identity is never
/// included.
enum DoseOutcome { takenOnTime, takenLate, missed, skipped, pending }

class AdherenceStats {
  const AdherenceStats({
    this.takenOnTime = 0,
    this.takenLate = 0,
    this.missed = 0,
    this.skipped = 0,
    this.pending = 0,
  });

  final int takenOnTime;
  final int takenLate;
  final int missed;
  final int skipped;
  final int pending;

  int get taken => takenOnTime + takenLate;

  /// Resolved doses only (pending doses are not yet due).
  int get due => taken + missed + skipped;

  /// Percentage 0–100, or null when nothing is due yet.
  int? get adherencePercent => due == 0 ? null : (taken * 100 / due).round();

  AdherenceStats add(DoseOutcome outcome) => AdherenceStats(
        takenOnTime: takenOnTime + (outcome == DoseOutcome.takenOnTime ? 1 : 0),
        takenLate: takenLate + (outcome == DoseOutcome.takenLate ? 1 : 0),
        missed: missed + (outcome == DoseOutcome.missed ? 1 : 0),
        skipped: skipped + (outcome == DoseOutcome.skipped ? 1 : 0),
        pending: pending + (outcome == DoseOutcome.pending ? 1 : 0),
      );
}

class ReportDose {
  const ReportDose({
    required this.medicationName,
    required this.scheduledAt,
    required this.outcome,
    required this.requiredScaled,
    this.actualScaled,
    this.takenAt,
    this.lateMinutes,
    this.isPrn = false,
    this.recordedLater = false,
  });

  final String medicationName;
  final DateTime scheduledAt;
  final DoseOutcome outcome;
  final int requiredScaled;
  final int? actualScaled;
  final DateTime? takenAt;
  final int? lateMinutes;
  final bool isPrn;

  /// Logged by a caregiver after the patient took it on their own.
  final bool recordedLater;
}

class ReportMedication {
  const ReportMedication({
    required this.medication,
    required this.displayName,
    required this.instructions,
    required this.scheduleLines,
    required this.adherence,
  });

  final Medication medication;
  final String displayName;
  final String? instructions;
  final List<String> scheduleLines;
  final AdherenceStats adherence;
}

class DoctorReport {
  const DoctorReport({
    required this.level,
    required this.generatedAt,
    required this.patientName,
    required this.patient,
    required this.periodFrom,
    required this.periodTo,
    required this.medications,
    required this.overall,
    required this.doses,
    required this.vitals,
    required this.appointments,
    required this.illnesses,
    required this.dietaryRules,
    this.mealNames = const {},
    this.medicationNames = const {},
  });

  final ReportLevel level;
  final DateTime generatedAt;
  final String patientName;
  final Patient patient;

  /// Null means "everything" (the default period).
  final DateTime? periodFrom;
  final DateTime? periodTo;
  final List<ReportMedication> medications;
  final AdherenceStats overall;

  /// Full dose history (detailed report only; empty for summary).
  final List<ReportDose> doses;
  final List<VitalMeasurement> vitals;
  final List<Appointment> appointments;
  final List<Illness> illnesses;
  final List<DietaryRule> dietaryRules;

  /// Names used to describe measurement context ("after lunch").
  final Map<String, String> mealNames;
  final Map<String, String> medicationNames;
}

class InventoryReportRow {
  const InventoryReportRow({
    required this.medication,
    required this.displayName,
    required this.summary,
    required this.batchCount,
    required this.lastPurchaseDate,
    required this.lastPurchasePrice,
    required this.totalSpent,
  });

  final Medication medication;
  final String displayName;
  final StockSummary summary;
  final int batchCount;
  final String? lastPurchaseDate;
  final double? lastPurchasePrice;
  final double totalSpent;

  /// Answers "what needs to be purchased?".
  bool get needsPurchase =>
      summary.isLowStock ||
      summary.state == StockState.empty ||
      summary.state == StockState.expiredOnly;
}

class InventoryReport {
  const InventoryReport({
    required this.generatedAt,
    required this.patientName,
    required this.rows,
  });

  final DateTime generatedAt;
  final String patientName;
  final List<InventoryReportRow> rows;

  List<InventoryReportRow> get toPurchase =>
      rows.where((r) => r.needsPurchase).toList();
}
