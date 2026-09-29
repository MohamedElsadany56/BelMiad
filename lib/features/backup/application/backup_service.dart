import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/domain_exceptions.dart';
import '../../../core/files/app_file_store.dart';
import '../../../core/time/clock.dart';
import '../../../core/utilities/ids.dart';
import '../../audit/data/audit_log.dart';
import '../../health/data/health_repositories.dart';
import 'legacy_backup_migrator.dart';

typedef RawRow = Map<String, Object?>;

/// A decoded backup: one patient profile as raw SQL rows per table, plus
/// stored files.
class BackupPackage {
  BackupPackage({
    required this.manifest,
    required this.tables,
    required this.files,
  });

  final Map<String, Object?> manifest;
  final Map<String, List<RawRow>> tables;
  final Map<String, Uint8List> files;

  String get patientId => manifest['patient_id']! as String;
  String get patientName => (manifest['patient_name'] as String?) ?? '';
}

class BackupImportResult {
  const BackupImportResult({
    required this.patientId,
    required this.patientName,
    this.added = 0,
    this.updated = 0,
  });

  final String patientId;
  final String patientName;
  final int added;
  final int updated;
}

class _TableSpec {
  const _TableSpec(
    this.file,
    this.table,
    this.primaryKey,
    this.scope, {
    this.references = const [],
  });

  final String file;
  final String table;
  final String primaryKey;

  /// SQL predicate selecting this patient's rows (`?` = patient id).
  final String scope;

  /// Columns holding IDs of other backed-up records.
  final List<String> references;
}

/// Versioned, portable, unencrypted backup (spec §34):
/// `backup.zip` with `manifest.json`, one JSON file per table and `files/`.
class BackupService {
  BackupService(
    this._db,
    this._files,
    this._audit, {
    Clock clock = systemClock,
    this.appVersion = '1.0.0',
  }) : _clock = clock;

  static const format = 'belmiad-backup';
  static const currentVersion = 2;

  final AppDatabase _db;
  final AppFileStore _files;
  final AuditLog _audit;
  final Clock _clock;
  final String appVersion;

  static const _medicationScope =
      'medication_id IN (SELECT medication_id FROM medications WHERE patient_id = ?)';

  /// Ordered so referenced tables come before referencing ones.
  static const _specs = [
    _TableSpec('persons.json', 'persons', 'person_id', ''),
    _TableSpec('patients.json', 'patients', 'patient_id', 'patient_id = ?'),
    _TableSpec(
      'caregivers.json',
      'caregiver_assignments',
      'assignment_id',
      'patient_id = ?',
      references: ['patient_id', 'caregiver_person_id'],
    ),
    _TableSpec(
      'illnesses.json',
      'patient_illnesses',
      'illness_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'medications.json',
      'medications',
      'medication_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'inventory.json',
      'medication_inventory_batches',
      'inventory_batch_id',
      _medicationScope,
      references: ['medication_id'],
    ),
    _TableSpec(
      'inventory_adjustments.json',
      'inventory_adjustments',
      'adjustment_id',
      _medicationScope,
      references: ['inventory_batch_id', 'medication_id', 'actor_person_id'],
    ),
    _TableSpec(
      'meals.json',
      'meals',
      'meal_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'schedules.json',
      'medication_schedules',
      'schedule_id',
      _medicationScope,
      references: ['medication_id', 'meal_id'],
    ),
    _TableSpec(
      'doses.json',
      'dose_instances',
      'dose_instance_id',
      'patient_id = ?',
      references: [
        'patient_id',
        'medication_id',
        'schedule_id',
        'logged_by_person_id',
      ],
    ),
    _TableSpec(
      'consumption.json',
      'dose_inventory_consumption',
      'consumption_id',
      'dose_instance_id IN (SELECT dose_instance_id FROM dose_instances '
          'WHERE patient_id = ?)',
      references: ['dose_instance_id', 'inventory_batch_id'],
    ),
    _TableSpec(
      'appointments.json',
      'appointments',
      'appointment_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'vitals.json',
      'vitals_measurements',
      'measurement_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'dietary_rules.json',
      'dietary_rules',
      'diet_rule_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'prescriptions.json',
      'prescriptions',
      'prescription_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'notifications.json',
      'patient_notification_preferences',
      'preference_id',
      'patient_id = ?',
      references: ['patient_id'],
    ),
    _TableSpec(
      'audit.json',
      'audit_events',
      'audit_event_id',
      'patient_id = ?',
      references: ['patient_id', 'actor_person_id', 'entity_id'],
    ),
    _TableSpec(
      'trash.json',
      'trash_items',
      'trash_item_id',
      'patient_id = ? AND permanently_deleted_at IS NULL',
      references: ['patient_id', 'entity_id'],
    ),
  ];

  // ---------------------------------------------------------------- export

  Future<List<RawRow>> _select(String sql, List<Object?> args) async {
    final rows = await _db
        .customSelect(sql, variables: [for (final a in args) _variable(a)])
        .get();
    return [for (final r in rows) Map<String, Object?>.of(r.data)];
  }

  Variable<Object> _variable(Object? value) => switch (value) {
        null => const Variable(null),
        final String v => Variable.withString(v),
        final int v => Variable.withInt(v),
        final double v => Variable.withReal(v),
        final bool v => Variable.withBool(v),
        _ => Variable.withString(value.toString()),
      };

  Future<BackupPackage> buildPackage(String patientId) async {
    final tables = <String, List<RawRow>>{};
    for (final spec in _specs.skip(1)) {
      tables[spec.file] = await _select(
        'SELECT * FROM ${spec.table} WHERE ${spec.scope}',
        [patientId],
      );
    }
    // Persons: the patient, their caregivers and every historical actor.
    final personIds = <String>{patientId};
    for (final row in tables['caregivers.json']!) {
      personIds.add(row['caregiver_person_id']! as String);
    }
    for (final (file, column) in const [
      ('doses.json', 'logged_by_person_id'),
      ('inventory_adjustments.json', 'actor_person_id'),
      ('audit.json', 'actor_person_id'),
    ]) {
      for (final row in tables[file]!) {
        final id = row[column];
        if (id is String && id.isNotEmpty) personIds.add(id);
      }
    }
    final placeholders = List.filled(personIds.length, '?').join(', ');
    tables['persons.json'] = await _select(
      'SELECT * FROM persons WHERE person_id IN ($placeholders)',
      personIds.toList(),
    );
    final patientRows = tables['patients.json']!;
    if (patientRows.isEmpty) throw NotFoundException('patient');

    final files = <String, Uint8List>{};
    for (final row in tables['prescriptions.json']!) {
      final path = row['file_path']! as String;
      final bytes = await _files.read(path);
      if (bytes != null) files[path] = bytes;
    }
    final patientName = tables['persons.json']!
        .firstWhere((p) => p['person_id'] == patientId)['full_name'];
    return BackupPackage(
      manifest: {
        'format': format,
        'version': currentVersion,
        'schema_version': _db.schemaVersion,
        'app_version': appVersion,
        'created_at': _clock().toUtc().toIso8601String(),
        'patient_id': patientId,
        'patient_name': patientName,
        'counts': {for (final e in tables.entries) e.key: e.value.length},
        'files': files.keys.toList(),
      },
      tables: tables,
      files: files,
    );
  }

  Future<Uint8List> exportPatient(String patientId) async {
    final package = await buildPackage(patientId);
    return encode(package);
  }

  Uint8List encode(BackupPackage package) {
    final archive = Archive();
    const encoder = JsonEncoder.withIndent('  ');
    archive.addFile(
      ArchiveFile.string('manifest.json', encoder.convert(package.manifest)),
    );
    for (final entry in package.tables.entries) {
      archive.addFile(
        ArchiveFile.string(entry.key, encoder.convert(entry.value)),
      );
    }
    for (final entry in package.files.entries) {
      archive.addFile(ArchiveFile.bytes('files/${entry.key}', entry.value));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  // ---------------------------------------------------------------- decode

  /// Decodes a ZIP backup, or a legacy v1 JSON backup, validating the format
  /// and migrating old versions (spec §34 "validate schema", "migrate").
  List<BackupPackage> decode(Uint8List bytes) {
    final isZip = bytes.length > 4 && bytes[0] == 0x50 && bytes[1] == 0x4B;
    if (!isZip) {
      try {
        final json = jsonDecode(utf8.decode(bytes));
        if (json is Map<String, dynamic>) {
          return LegacyBackupMigrator(clock: _clock).migrate(json);
        }
      } on FormatException {
        // fall through
      }
      throw const ValidationException('invalidBackup');
    }
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const ValidationException('invalidBackup');
    }
    Map<String, Object?> readJson(String name) {
      final file = archive.findFile(name);
      if (file == null) return const {};
      return jsonDecode(utf8.decode(file.content)) as Map<String, Object?>;
    }

    final manifest = readJson('manifest.json');
    if (manifest['format'] != format || manifest['patient_id'] is! String) {
      throw const ValidationException('invalidBackup');
    }
    final version = manifest['version'];
    if (version is! int) throw const ValidationException('invalidBackup');
    if (version > currentVersion) {
      throw const ValidationException('newerBackup');
    }
    final tables = <String, List<RawRow>>{};
    for (final spec in _specs) {
      final file = archive.findFile(spec.file);
      if (file == null) {
        tables[spec.file] = [];
        continue;
      }
      final decoded = jsonDecode(utf8.decode(file.content));
      if (decoded is! List) throw const ValidationException('invalidBackup');
      tables[spec.file] = [
        for (final row in decoded) Map<String, Object?>.from(row as Map),
      ];
    }
    final files = <String, Uint8List>{};
    for (final file in archive.files) {
      if (file.isFile && file.name.startsWith('files/')) {
        files[file.name.substring(6)] = file.content;
      }
    }
    final package = BackupPackage(
      manifest: manifest,
      tables: tables,
      files: files,
    );
    return [_upgrade(package, version)];
  }

  /// Hook for future format upgrades (v2 is current).
  BackupPackage _upgrade(BackupPackage package, int fromVersion) => package;

  // ---------------------------------------------------------------- import

  Future<Set<String>> _columnsOf(String table) async {
    final rows = await _db.customSelect('PRAGMA table_info($table)').get();
    return {for (final r in rows) r.read<String>('name')};
  }

  Future<void> _insert(
    String table,
    RawRow row,
    Set<String> columns, {
    String mode = 'INSERT OR IGNORE',
  }) async {
    final keys = row.keys.where(columns.contains).toList();
    if (keys.isEmpty) return;
    await _db.customInsert(
      '$mode INTO $table (${keys.join(', ')}) '
      'VALUES (${List.filled(keys.length, '?').join(', ')})',
      variables: [for (final k in keys) _variable(row[k])],
    );
  }

  /// Imports a backup as a brand-new patient profile, generating new IDs
  /// while preserving every relationship.
  Future<BackupImportResult> importAsNew(BackupPackage package) async {
    final idMap = <String, String>{};
    final oldPatientId = package.patientId;
    final newPatientId = newId();
    idMap[oldPatientId] = newPatientId;

    for (final spec in _specs.skip(2)) {
      for (final row in package.tables[spec.file] ?? const <RawRow>[]) {
        final oldId = row[spec.primaryKey];
        if (oldId is! String) continue;
        if (spec.table == 'dose_instances' && row['schedule_id'] is String) {
          final schedule = idMap[row['schedule_id']] ?? row['schedule_id'];
          idMap[oldId] = '$schedule@${row['local_date']}';
        } else {
          idMap[oldId] = newId();
        }
      }
    }

    final prescriptionFiles = <String, String>{};
    for (final row in package.tables['prescriptions.json'] ?? const []) {
      final oldPath = row['file_path'] as String?;
      final bytes = oldPath == null ? null : package.files[oldPath];
      if (oldPath == null || bytes == null) continue;
      final extension =
          oldPath.contains('.') ? oldPath.substring(oldPath.lastIndexOf('.')) : '';
      prescriptionFiles[oldPath] = await _files.save(
        PrescriptionRepository.folder,
        '${idMap[row['prescription_id']]}$extension',
        bytes,
      );
    }

    var added = 0;
    await _db.transaction(() async {
      for (final spec in _specs) {
        final columns = await _columnsOf(spec.table);
        for (final source in package.tables[spec.file] ?? const <RawRow>[]) {
          final row = RawRow.of(source);
          if (spec.table == 'persons') {
            final personId = row['person_id'];
            if (personId == oldPatientId) {
              row['person_id'] = newPatientId;
            }
            // Other persons (caregivers, actors) keep their identity; an
            // existing local record is left untouched.
          } else {
            row[spec.primaryKey] = idMap[row[spec.primaryKey]];
            for (final column in spec.references) {
              final value = row[column];
              if (value is String && idMap.containsKey(value)) {
                row[column] = idMap[value];
              }
            }
          }
          if (spec.table == 'prescriptions') {
            row['file_path'] =
                prescriptionFiles[row['file_path']] ?? row['file_path'];
          }
          await _insert(spec.table, row, columns);
          added++;
        }
      }
      await _audit.record(
        patientId: newPatientId,
        entityType: EntityTypes.patient,
        entityId: newPatientId,
        action: AuditActions.imported,
        metadata: {'source_patient_id': oldPatientId, 'rows': added},
      );
    });
    return BackupImportResult(
      patientId: newPatientId,
      patientName: package.patientName,
      added: added,
    );
  }

  /// Merges a backup of the same patient: mutable records keep the latest
  /// `updated_at`; unique historical events are added, never duplicated.
  Future<BackupImportResult> mergeSamePatient(BackupPackage package) async {
    final patientId = package.patientId;
    final exists = await _select(
      'SELECT patient_id FROM patients WHERE patient_id = ?',
      [patientId],
    );
    if (exists.isEmpty) {
      throw const ValidationException('backupPatientMissing');
    }
    var added = 0;
    var updated = 0;
    for (final row in package.tables['prescriptions.json'] ?? const []) {
      final path = row['file_path'] as String?;
      final bytes = path == null ? null : package.files[path];
      if (path != null && bytes != null && !await _files.exists(path)) {
        final slash = path.lastIndexOf('/');
        await _files.save(
          slash < 0 ? PrescriptionRepository.folder : path.substring(0, slash),
          path.substring(slash + 1),
          bytes,
        );
      }
    }
    await _db.transaction(() async {
      for (final spec in _specs) {
        final columns = await _columnsOf(spec.table);
        final mutable = columns.contains('updated_at');
        for (final row in package.tables[spec.file] ?? const <RawRow>[]) {
          final id = row[spec.primaryKey];
          if (id is! String) continue;
          final local = await _select(
            'SELECT * FROM ${spec.table} WHERE ${spec.primaryKey} = ?',
            [id],
          );
          if (local.isEmpty) {
            await _insert(spec.table, row, columns);
            added++;
            continue;
          }
          final current = local.single;
          final bool replace;
          if (mutable) {
            replace = _asInt(row['updated_at']) > _asInt(current['updated_at']);
          } else if (spec.table == 'dose_inventory_consumption') {
            replace =
                current['reversed_at'] == null && row['reversed_at'] != null;
          } else {
            replace = false;
          }
          if (replace) {
            await _insert(spec.table, row, columns, mode: 'INSERT OR REPLACE');
            updated++;
          }
        }
      }
      await _audit.record(
        patientId: patientId,
        entityType: EntityTypes.patient,
        entityId: patientId,
        action: AuditActions.merged,
        metadata: {'added': added, 'updated': updated},
      );
    });
    return BackupImportResult(
      patientId: patientId,
      patientName: package.patientName,
      added: added,
      updated: updated,
    );
  }

  static int _asInt(Object? value) => switch (value) {
        final int v => v,
        final double v => v.toInt(),
        final String v => int.tryParse(v) ?? 0,
        _ => 0,
      };

  String fileNameFor(String patientName) {
    final now = _clock().toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    final safe = patientName
        .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return 'belmiad_${safe.isEmpty ? 'patient' : safe}_'
        '${now.year}${two(now.month)}${two(now.day)}_${two(now.hour)}${two(now.minute)}.zip';
  }
}
