import 'package:drift/drift.dart';

// Patient database schema (spec §36).
//
// Conventions:
// * Event timestamps are stored as UTC instants.
// * Calendar dates are stored as ISO `yyyy-MM-dd` text, wall-clock times as
//   `HH:mm` text, so they never shift with the device timezone.
// * Medication quantities are scaled integers (`quantity_scale` = 1000).
// * Mutable records carry `updated_at` for merge conflict resolution and
//   `deleted_at` for soft deletion / trash.

class Persons extends Table {
  TextColumn get personId => text()();
  TextColumn get fullName => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get preferredLanguage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {personId};
}

class Patients extends Table {
  TextColumn get patientId => text()();
  TextColumn get dateOfBirth => text().nullable()();
  TextColumn get sex => text().nullable()();
  TextColumn get bloodType => text().nullable()();
  TextColumn get emergencyContactName => text().nullable()();
  TextColumn get emergencyContactPhone => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get timezone => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {patientId};
}

class CaregiverAssignments extends Table {
  TextColumn get assignmentId => text()();
  TextColumn get patientId => text()();
  TextColumn get caregiverPersonId => text()();
  TextColumn get relationship => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get removedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {assignmentId};
}

@DataClassName('Illness')
class PatientIllnesses extends Table {
  TextColumn get illnessId => text()();
  TextColumn get patientId => text()();
  TextColumn get conditionName => text()();
  TextColumn get diagnosedDate => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {illnessId};
}

class Medications extends Table {
  TextColumn get medicationId => text()();
  TextColumn get patientId => text()();
  TextColumn get catalogId => text().nullable()();
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get scientificName => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get route => text().nullable()();
  TextColumn get doseUnit => text()();
  TextColumn get instructionsEn => text().nullable()();
  TextColumn get instructionsAr => text().nullable()();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  BoolColumn get isPrn => boolean().withDefault(const Constant(false))();
  IntColumn get maximumDailyQuantityScaled => integer().nullable()();
  RealColumn get catalogPriceEgp => real().nullable()();

  /// Stock kept in storage without being part of the patient's treatment.
  BoolColumn get storageOnly => boolean().withDefault(const Constant(false))();

  /// `active` or `archived`.
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {medicationId};
}

@DataClassName('InventoryBatch')
class MedicationInventoryBatches extends Table {
  TextColumn get inventoryBatchId => text()();
  TextColumn get medicationId => text()();
  TextColumn get purchaseDate => text().nullable()();
  RealColumn get purchasePrice => real().nullable()();
  TextColumn get expirationDate => text().nullable()();
  TextColumn get packagingType => text().nullable()();

  /// Units per innermost pack (per package, or per sub-package when set).
  IntColumn get unitsPerPackage => integer().nullable()();
  IntColumn get packagesCount => integer().nullable()();

  /// Optional inner packaging, e.g. strips/blisters inside a box.
  TextColumn get subPackagingType => text().nullable()();
  IntColumn get subPackagesPerPackage => integer().nullable()();

  /// Extra loose units added to the packaged quantity.
  IntColumn get looseQuantityScaled => integer().nullable()();

  /// JSON list of opened/incomplete packs, e.g. a strip with 9 of 14
  /// tablets left: `[{"type":"strip","remaining":9000,"capacity":14}]`.
  TextColumn get partialPacksJson => text().nullable()();
  IntColumn get initialQuantityScaled => integer()();
  IntColumn get availableQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  BoolColumn get isDepleted => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {inventoryBatchId};
}

class InventoryAdjustments extends Table {
  TextColumn get adjustmentId => text()();
  TextColumn get inventoryBatchId => text()();
  TextColumn get medicationId => text()();
  IntColumn get previousQuantityScaled => integer()();
  IntColumn get deltaScaled => integer()();
  IntColumn get newQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  TextColumn get reason => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get actorPersonId => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {adjustmentId};
}

class Meals extends Table {
  TextColumn get mealId => text()();
  TextColumn get patientId => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text()();

  /// breakfast, lunch, dinner, snack or custom.
  TextColumn get mealType => text()();

  /// Local wall-clock `HH:mm`. When null the meal type default is used.
  TextColumn get defaultTime => text().nullable()();

  /// `daily` (same time every day) or `weekly` (per-weekday times).
  TextColumn get timeMode => text().withDefault(const Constant('daily'))();

  /// JSON map of ISO weekday → `HH:mm`, used when [timeMode] is weekly.
  TextColumn get weekdayTimes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {mealId};
}

class MedicationSchedules extends Table {
  TextColumn get scheduleId => text()();
  TextColumn get medicationId => text()();

  /// Schedules created together as one dose plan (e.g. 3 times a day after
  /// meals) share a group ID and are edited as a unit.
  TextColumn get groupId => text().nullable()();

  /// `fixed_time` or `meal_relative`.
  TextColumn get scheduleType => text()();
  TextColumn get fixedTime => text().nullable()();
  TextColumn get mealId => text().nullable()();

  /// before, with or after.
  TextColumn get timingRelation => text().nullable()();
  IntColumn get offsetMinutes => integer().nullable()();
  IntColumn get doseQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();

  /// JSON encoded [RecurrenceRule].
  TextColumn get recurrenceRule => text()();
  TextColumn get validFrom => text().nullable()();
  TextColumn get validUntil => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {scheduleId};
}

class DoseInstances extends Table {
  TextColumn get doseInstanceId => text()();
  TextColumn get patientId => text()();
  TextColumn get medicationId => text()();
  TextColumn get scheduleId => text().nullable()();

  /// Local calendar date the dose belongs to (patient timezone).
  TextColumn get localDate => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get requiredQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  IntColumn get actualQuantityScaled => integer().nullable()();

  /// SCHEDULED, TAKEN, MISSED or SKIPPED.
  TextColumn get status => text()();
  DateTimeColumn get takenAt => dateTime().nullable()();
  DateTimeColumn get skippedAt => dateTime().nullable()();
  DateTimeColumn get missedAt => dateTime().nullable()();
  IntColumn get lateMinutes => integer().nullable()();
  BoolColumn get isPrn => boolean().withDefault(const Constant(false))();
  TextColumn get loggedByPersonId => text().nullable()();

  /// When the intake was recorded in the app. Differs from [takenAt] when a
  /// caregiver records a dose the patient took earlier on their own.
  DateTimeColumn get loggedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {doseInstanceId};
}

@DataClassName('DoseConsumption')
class DoseInventoryConsumption extends Table {
  @override
  String get tableName => 'dose_inventory_consumption';

  TextColumn get consumptionId => text()();
  TextColumn get doseInstanceId => text()();
  TextColumn get inventoryBatchId => text()();
  IntColumn get quantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  BoolColumn get manuallySelected =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  /// Set when the dose is undone; the quantity was restored to this batch.
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {consumptionId};
}

class Appointments extends Table {
  TextColumn get appointmentId => text()();
  TextColumn get patientId => text()();
  TextColumn get doctorName => text()();
  TextColumn get specialty => text().nullable()();
  DateTimeColumn get scheduledTime => dateTime()();
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// scheduled, completed or cancelled.
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {appointmentId};
}

@DataClassName('VitalMeasurement')
class VitalsMeasurements extends Table {
  TextColumn get measurementId => text()();
  TextColumn get patientId => text()();
  TextColumn get measurementType => text()();
  RealColumn get value1 => real().named('value_1').nullable()();
  RealColumn get value2 => real().named('value_2').nullable()();
  TextColumn get unit => text().nullable()();

  /// fasting, before_meal, after_meal, after_medication or random.
  TextColumn get context => text().nullable()();
  TextColumn get relatedMealId => text().nullable()();
  TextColumn get relatedMedicationId => text().nullable()();

  /// Minutes after the related meal or medication.
  IntColumn get minutesAfter => integer().nullable()();
  DateTimeColumn get measuredAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {measurementId};
}

class DietaryRules extends Table {
  TextColumn get dietRuleId => text()();
  TextColumn get patientId => text()();
  TextColumn get foodItemEn => text()();
  TextColumn get foodItemAr => text().nullable()();

  /// avoid, limit, prefer or separate_from_medication.
  TextColumn get ruleType => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {dietRuleId};
}

class Prescriptions extends Table {
  TextColumn get prescriptionId => text()();
  TextColumn get patientId => text()();
  TextColumn get doctorName => text().nullable()();
  TextColumn get issueDate => text().nullable()();

  /// Path relative to the app-private prescriptions directory.
  TextColumn get filePath => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {prescriptionId};
}

@DataClassName('AppNotification')
class Notifications extends Table {
  TextColumn get notificationId => text()();
  TextColumn get patientId => text()();
  TextColumn get recipientPersonId => text().nullable()();
  TextColumn get notificationType => text()();

  /// Stable identity used to deduplicate generation across launches.
  TextColumn get dedupKey => text().unique()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();

  /// scheduled, delivered, cancelled or resolved.
  TextColumn get status => text()();
  TextColumn get doseInstanceId => text().nullable()();
  TextColumn get appointmentId => text().nullable()();
  TextColumn get inventoryBatchId => text().nullable()();
  TextColumn get medicationId => text().nullable()();
  TextColumn get titleEn => text().nullable()();
  TextColumn get titleAr => text().nullable()();
  TextColumn get bodyEn => text().nullable()();
  TextColumn get bodyAr => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {notificationId};
}

@DataClassName('NotificationPreference')
class PatientNotificationPreferences extends Table {
  TextColumn get preferenceId => text()();
  TextColumn get patientId => text()();
  TextColumn get notificationType => text()();
  BoolColumn get enabled => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {preferenceId};

  @override
  List<Set<Column>> get uniqueKeys => [
        {patientId, notificationType},
      ];
}

class AuditEvents extends Table {
  TextColumn get auditEventId => text()();
  TextColumn get patientId => text().nullable()();
  TextColumn get actorPersonId => text().nullable()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get metadataJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {auditEventId};
}

class TrashItems extends Table {
  TextColumn get trashItemId => text()();
  TextColumn get patientId => text().nullable()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get label => text().nullable()();
  DateTimeColumn get deletedAt => dateTime()();
  DateTimeColumn get restoredAt => dateTime().nullable()();
  DateTimeColumn get permanentlyDeletedAt => dateTime().nullable()();
  TextColumn get snapshotJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {trashItemId};
}

/// Device-level key/value settings (device caregiver identity, thresholds).
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
