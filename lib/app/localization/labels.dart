import '../../core/database/app_database.dart';
import '../../core/errors/domain_exceptions.dart';
import '../../core/utilities/scaled_quantity.dart';
import '../../features/health/data/health_repositories.dart';
import '../../features/inventory/domain/stock_forecast.dart';
import '../../l10n/app_localizations.dart';

/// Maps stable codes stored in the database to localized labels.

const doseUnits = [
  'tablet',
  'capsule',
  'ml',
  'drop',
  'puff',
  'sachet',
  'injection',
  'patch',
  'suppository',
  'application',
  'mg',
  'g',
  'unit',
];

String unitLabel(String code, AppLocalizations l10n) => switch (code) {
      'tablet' => l10n.unit_tablet,
      'capsule' => l10n.unit_capsule,
      'ml' => l10n.unit_ml,
      'drop' => l10n.unit_drop,
      'puff' => l10n.unit_puff,
      'sachet' => l10n.unit_sachet,
      'injection' => l10n.unit_injection,
      'patch' => l10n.unit_patch,
      'suppository' => l10n.unit_suppository,
      'application' => l10n.unit_application,
      'mg' => l10n.unit_mg,
      'g' => l10n.unit_g,
      'unit' => l10n.unit_unit,
      _ => code,
    };

const _englishPlurals = {
  'tablet': 'tablets',
  'capsule': 'capsules',
  'drop': 'drops',
  'puff': 'puffs',
  'sachet': 'sachets',
  'injection': 'injections',
  'patch': 'patches',
  'suppository': 'suppositories',
  'application': 'applications',
  'unit': 'units',
};

/// Unit label for a quantity; English units are pluralised when the
/// quantity is not exactly one.
String unitLabelFor(String code, int? scaled, AppLocalizations l10n) {
  if (l10n.localeName == 'en' && scaled != quantityScale) {
    final plural = _englishPlurals[code];
    if (plural != null) return plural;
  }
  return unitLabel(code, l10n);
}

String quantityWithUnit(int? scaled, String unit, AppLocalizations l10n) =>
    '${formatScaled(scaled)} ${unitLabelFor(unit, scaled, l10n)}';

String packagingLabel(String? code, AppLocalizations l10n) => switch (code) {
      'box' => l10n.packaging_box,
      'blister' => l10n.packaging_blister,
      'bottle' => l10n.packaging_bottle,
      'tube' => l10n.packaging_tube,
      'sachet' => l10n.packaging_sachet,
      'vial' => l10n.packaging_vial,
      'ampoule' => l10n.packaging_ampoule,
      'container' => l10n.packaging_container,
      'other' => l10n.packaging_other,
      null => l10n.notSet,
      _ => code,
    };

String adjustmentReasonLabel(String code, AppLocalizations l10n) =>
    switch (code) {
      'manual_correction' => l10n.reason_manual_correction,
      'damaged' => l10n.reason_damaged,
      'lost' => l10n.reason_lost,
      'returned' => l10n.reason_returned,
      'count_correction' => l10n.reason_count_correction,
      _ => l10n.reason_other,
    };

String mealTypeLabel(String code, AppLocalizations l10n) => switch (code) {
      'breakfast' => l10n.meal_breakfast,
      'lunch' => l10n.meal_lunch,
      'dinner' => l10n.meal_dinner,
      'snack' => l10n.meal_snack,
      _ => l10n.meal_custom,
    };

String mealName(Meal meal, AppLocalizations l10n) {
  final arabic = l10n.localeName == 'ar';
  final name = arabic ? meal.nameAr : meal.nameEn;
  return name.trim().isEmpty ? mealTypeLabel(meal.mealType, l10n) : name;
}

String stockStateLabel(StockState state, AppLocalizations l10n) =>
    switch (state) {
      StockState.noStockRecorded => l10n.stockNotRecorded,
      StockState.empty => l10n.stockEmpty,
      StockState.expiredOnly => l10n.stockExpiredOnly,
      StockState.low => l10n.stockLow,
      StockState.expiringSoon => l10n.stockExpiring,
      StockState.normal => l10n.stockNormal,
    };

String vitalTypeLabel(String code, AppLocalizations l10n) => switch (code) {
      VitalTypes.bloodPressure => l10n.vital_blood_pressure,
      VitalTypes.heartRate => l10n.vital_heart_rate,
      VitalTypes.bloodGlucose => l10n.vital_blood_glucose,
      VitalTypes.temperature => l10n.vital_temperature,
      VitalTypes.weight => l10n.vital_weight,
      VitalTypes.oxygenSaturation => l10n.vital_oxygen_saturation,
      VitalTypes.respiratoryRate => l10n.vital_respiratory_rate,
      _ => l10n.vital_other,
    };

String _number(double? value) {
  if (value == null) return '-';
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

String vitalValueText(VitalMeasurement v) {
  final main = v.value2 == null
      ? _number(v.value1)
      : '${_number(v.value1)}/${_number(v.value2)}';
  return v.unit == null || v.unit!.isEmpty ? main : '$main ${v.unit}';
}

String dietRuleLabel(String code, AppLocalizations l10n) => switch (code) {
      DietRuleTypes.avoid => l10n.diet_avoid,
      DietRuleTypes.limit => l10n.diet_limit,
      DietRuleTypes.prefer => l10n.diet_prefer,
      _ => l10n.diet_separate_from_medication,
    };

String appointmentStatusLabel(String code, AppLocalizations l10n) =>
    switch (code) {
      AppointmentStatus.completed => l10n.appointment_completed,
      AppointmentStatus.cancelled => l10n.appointment_cancelled,
      _ => l10n.appointment_scheduled,
    };

String entityLabel(String code, AppLocalizations l10n) => switch (code) {
      'patient' => l10n.entity_patient,
      'medication' => l10n.entity_medication,
      'inventory_batch' => l10n.entity_inventory_batch,
      'appointment' => l10n.entity_appointment,
      'vital_measurement' => l10n.entity_vital_measurement,
      'illness' => l10n.entity_illness,
      'dietary_rule' => l10n.entity_dietary_rule,
      'prescription' => l10n.entity_prescription,
      'meal' => l10n.entity_meal,
      'medication_schedule' => l10n.schedules,
      'dose_instance' => l10n.doseHistory,
      'caregiver_assignment' => l10n.caregivers,
      'person' => l10n.fullName,
      _ => code,
    };

String auditActionLabel(String code, AppLocalizations l10n) => switch (code) {
      'created' => l10n.audit_created,
      'updated' => l10n.audit_updated,
      'deleted' => l10n.audit_deleted,
      'restored' => l10n.audit_restored,
      'permanently_deleted' => l10n.audit_permanently_deleted,
      'archived' => l10n.audit_archived,
      'unarchived' => l10n.audit_unarchived,
      'inventory_added' => l10n.audit_inventory_added,
      'inventory_edited' => l10n.audit_inventory_edited,
      'inventory_adjusted' => l10n.audit_inventory_adjusted,
      'inventory_deleted' => l10n.audit_inventory_deleted,
      'dose_taken' => l10n.audit_dose_taken,
      'dose_undone' => l10n.audit_dose_undone,
      'dose_skipped' => l10n.audit_dose_skipped,
      'dose_missed' => l10n.audit_dose_missed,
      'prn_logged' => l10n.audit_prn_logged,
      'batch_manually_selected' => l10n.audit_batch_manually_selected,
      'maximum_daily_overridden' => l10n.audit_maximum_daily_overridden,
      'caregiver_assigned' => l10n.audit_caregiver_assigned,
      'caregiver_removed' => l10n.audit_caregiver_removed,
      'imported' => l10n.audit_imported,
      'merged' => l10n.audit_merged,
      _ => code,
    };

String notificationTypeLabel(String code, AppLocalizations l10n) =>
    switch (code) {
      'dose_reminder' => l10n.notif_dose_reminder,
      'missed_dose' => l10n.notif_missed_dose,
      'low_stock' => l10n.notif_low_stock,
      'empty_stock' => l10n.notif_empty_stock,
      'expiration' => l10n.notif_expiration,
      _ => l10n.notif_appointment_reminder,
    };

/// User-facing message for any error thrown by a use case.
String errorMessage(Object error, AppLocalizations l10n) {
  if (error is DomainException) {
    return switch (error.code) {
      'nameRequired' => l10n.error_nameRequired,
      'invalidTimezone' => l10n.error_invalidTimezone,
      'doseUnitRequired' => l10n.error_doseUnitRequired,
      'endBeforeStart' => l10n.error_endBeforeStart,
      'invalidMaximum' => l10n.error_invalidMaximum,
      'quantityRequired' => l10n.error_quantityRequired,
      'invalidQuantity' => l10n.error_invalidQuantity,
      'invalidTime' => l10n.error_invalidTime,
      'mealRequired' => l10n.error_mealRequired,
      'weekdaysRequired' => l10n.error_weekdaysRequired,
      'invalidRecurrence' => l10n.error_invalidRecurrence,
      'invalidScheduleType' => l10n.error_invalidScheduleType,
      'useAdjustment' => l10n.error_useAdjustment,
      'negativeStock' => l10n.error_negativeStock,
      'insufficientStock' => l10n.error_insufficientStock,
      'invalidDoseTransition' => l10n.error_invalidDoseTransition,
      'doseWindowClosed' => l10n.error_doseWindowClosed,
      'actualQuantityZero' => l10n.error_actualQuantityZero,
      'batchNotUsable' => l10n.error_batchNotUsable,
      'allocationTotalMismatch' => l10n.error_allocationTotalMismatch,
      'invalidAllocation' => l10n.error_invalidAllocation,
      'batchHasHistory' => l10n.error_batchHasHistory,
      'mealInUse' => l10n.error_mealInUse,
      'valueRequired' => l10n.error_valueRequired,
      'doctorRequired' => l10n.error_doctorRequired,
      'patientAlreadyExists' => l10n.error_patientAlreadyExists,
      'invalidPrice' => l10n.error_invalidPrice,
      'invalidDate' => l10n.error_invalidDate,
      'invalidPackages' => l10n.error_invalidPackages,
      'invalidReason' => l10n.error_invalidReason,
      'notFound' => l10n.error_notFound,
      'maximumDailyExceeded' => l10n.error_maximumDailyExceeded,
      'unsupportedTrashEntity' => l10n.error_unsupportedTrashEntity,
      'invalidBackup' => l10n.error_invalidBackup,
      'newerBackup' => l10n.error_newerBackup,
      'backupPatientMissing' => l10n.error_backupPatientMissing,
      'filesUnsupported' => l10n.error_filesUnsupported,
      _ => l10n.errorGeneric(error.code),
    };
  }
  return l10n.errorGeneric(error.toString());
}
