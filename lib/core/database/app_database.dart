import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dart:io';

part 'app_database.g.dart';

class Patients extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get relation => text().nullable()();
  TextColumn get timezone =>
      text().withDefault(const Constant('Africa/Cairo'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get catalogId => text().nullable()();
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get route => text().nullable()();
  TextColumn get doseUnit => text().withDefault(const Constant('unit'))();
  TextColumn get instructionsEn => text().nullable()();
  TextColumn get instructionsAr => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isPrn => boolean().withDefault(const Constant(false))();
  IntColumn get maxDailyQuantityScaled => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class MedicationSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();
  TextColumn get scheduleType => text()();
  TextColumn get fixedTime => text().nullable()();
  TextColumn get recurrenceRule => text()();
  IntColumn get doseQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  DateTimeColumn get validFrom => dateTime().nullable()();
  DateTimeColumn get validUntil => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}

class InventoryBatches extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();
  IntColumn get availableQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  TextColumn get unit => text()();
  TextColumn get packagingType => text().nullable()();
  IntColumn get packageCount => integer().nullable()();
  IntColumn get unitsPerPackage => integer().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  RealColumn get purchasePrice => real().nullable()();
  DateTimeColumn get expirationDate => dateTime().nullable()();
  TextColumn get source => text().nullable()();
  BoolColumn get isDepleted => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class DoseInstances extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get medicationId => text().references(Medications, #id)();
  TextColumn get scheduleId => text().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get requiredQuantityScaled => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(1000))();
  IntColumn get actualQuantityScaled => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('SCHEDULED'))();
  DateTimeColumn get takenAt => dateTime().nullable()();
  IntColumn get lateMinutes => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class HealthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Prescriptions extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get doctorName => text().nullable()();
  DateTimeColumn get issueDate => dateTime().nullable()();
  TextColumn get filePath => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class NotificationPreferences extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get notificationType => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}

class AuditEvents extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().nullable()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get metadataJson => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Patients,
    Medications,
    MedicationSchedules,
    InventoryBatches,
    DoseInstances,
    HealthRecords,
    Prescriptions,
    NotificationPreferences,
    AuditEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(prescriptions);
            await m.createTable(notificationPreferences);
          }
        },
      );

  Future<List<PatientsData>> watchPatients() => select(patients).get();
  Future<List<MedicationsData>> medicationsForPatient(String patientId) =>
      (select(medications)
            ..where(
              (m) => m.patientId.equals(patientId) & m.isActive.equals(true),
            ))
          .get();
  Future<List<InventoryBatchesData>> batchesForMedication(
          String medicationId) =>
      (select(
        inventoryBatches,
      )..where((b) => b.medicationId.equals(medicationId)))
          .get();

  Future<void> consumeInventory({
    required String batchId,
    required int quantityScaled,
  }) async {
    await transaction(() async {
      final batch = await (select(
        inventoryBatches,
      )..where((b) => b.id.equals(batchId)))
          .getSingle();
      final next = batch.availableQuantityScaled - quantityScaled;
      if (next < 0) throw StateError('Inventory cannot become negative');
      await (update(
        inventoryBatches,
      )..where((b) => b.id.equals(batchId)))
          .write(
        InventoryBatchesCompanion(
          availableQuantityScaled: Value(next),
          isDepleted: Value(next == 0),
        ),
      );
    });
  }
}

Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'belmiad.sqlite'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}
