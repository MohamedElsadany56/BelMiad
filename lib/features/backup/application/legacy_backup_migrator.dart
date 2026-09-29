import '../../../core/errors/domain_exceptions.dart';
import '../../../core/time/clock.dart';
import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/ids.dart';
import '../../doses/domain/dose_status.dart';
import 'backup_service.dart';

/// Migrates the version 1 prototype backup (a single JSON document with
/// `backup_version: 1`) into version 2 packages, one per patient
/// (edge case 35: backup contains an older schema version).
class LegacyBackupMigrator {
  LegacyBackupMigrator({Clock clock = systemClock}) : _clock = clock;

  final Clock _clock;

  List<BackupPackage> migrate(Map<String, dynamic> json) {
    if (json['backup_version'] != 1) {
      throw const ValidationException('invalidBackup');
    }
    final now = _seconds(_clock());
    List<Map<String, dynamic>> list(String key) => [
          for (final item in (json[key] as List? ?? const []))
            Map<String, dynamic>.from(item as Map),
        ];
    final patients = list('patients');
    if (patients.isEmpty) throw const ValidationException('invalidBackup');
    final medications = list('medications');
    final batches = list('inventory_batches');
    final doses = list('doses');
    final records = list('health_records');

    return [
      for (final patient in patients)
        _package(
          patient,
          medications.where((m) => m['patient_id'] == patient['id']).toList(),
          batches,
          doses.where((d) => d['patient_id'] == patient['id']).toList(),
          records.where((r) => r['patient_id'] == patient['id']).toList(),
          now,
        ),
    ];
  }

  BackupPackage _package(
    Map<String, dynamic> patient,
    List<Map<String, dynamic>> medications,
    List<Map<String, dynamic>> allBatches,
    List<Map<String, dynamic>> doses,
    List<Map<String, dynamic>> records,
    int now,
  ) {
    final patientId = patient['id'] as String;
    final timezone = (patient['timezone'] as String?) ?? defaultTimezone;
    final time = PatientTime(timezone);
    final medicationIds = {for (final m in medications) m['id'] as String};
    final units = <String, String>{};
    for (final b in allBatches) {
      final unit = b['unit'] as String?;
      if (unit != null) units[b['medication_id'] as String] = unit;
    }

    final appointments = <RawRow>[];
    final vitals = <RawRow>[];
    final illnesses = <RawRow>[];
    final diet = <RawRow>[];
    for (final r in records) {
      final type = (r['type'] as String? ?? '').toLowerCase();
      final at = _parseSeconds(r['occurred_at']) ?? now;
      final title = (r['title'] as String?) ?? '';
      final notes = r['notes'] as String?;
      if (type.contains('appoint')) {
        appointments.add({
          'appointment_id': r['id'] ?? newId(),
          'patient_id': patientId,
          'doctor_name': title.isEmpty ? '-' : title,
          'scheduled_time': at,
          'notes': notes,
          'status': 'scheduled',
          'created_at': now,
          'updated_at': now,
        });
      } else if (type.contains('vital')) {
        vitals.add({
          'measurement_id': r['id'] ?? newId(),
          'patient_id': patientId,
          'measurement_type': 'other',
          'value_1': double.tryParse(title),
          'measured_at': at,
          'notes': [title, if (notes != null) notes].join(' · '),
          'created_at': now,
          'updated_at': now,
        });
      } else if (type.contains('diet')) {
        diet.add({
          'diet_rule_id': r['id'] ?? newId(),
          'patient_id': patientId,
          'food_item_en': title.isEmpty ? '-' : title,
          'rule_type': 'avoid',
          'notes': notes,
          'created_at': now,
          'updated_at': now,
        });
      } else {
        illnesses.add({
          'illness_id': r['id'] ?? newId(),
          'patient_id': patientId,
          'condition_name': title.isEmpty ? type : title,
          'diagnosed_date': time.localDateOf(_fromSeconds(at)).toIso(),
          'notes': notes,
          'created_at': now,
          'updated_at': now,
        });
      }
    }

    return BackupPackage(
      manifest: {
        'format': BackupService.format,
        'version': BackupService.currentVersion,
        'migrated_from': 1,
        'patient_id': patientId,
        'patient_name': patient['name'],
      },
      files: {},
      tables: {
        'persons.json': [
          {
            'person_id': patientId,
            'full_name': patient['name'] ?? '-',
            'created_at': now,
            'updated_at': now,
          },
        ],
        'patients.json': [
          {
            'patient_id': patientId,
            'timezone': timezone,
            'notes': patient['relation'],
            'created_at': now,
            'updated_at': now,
          },
        ],
        'medications.json': [
          for (final m in medications)
            {
              'medication_id': m['id'],
              'patient_id': patientId,
              'name_en': m['name_en'] ?? '-',
              'name_ar': m['name_ar'],
              'strength': m['strength'],
              'dosage_form': m['dosage_form'],
              'dose_unit': units[m['id']] ?? 'unit',
              'is_prn': m['is_prn'] == true ? 1 : 0,
              'status': 'active',
              'created_at': now,
              'updated_at': now,
            },
        ],
        'inventory.json': [
          for (final b in allBatches)
            if (medicationIds.contains(b['medication_id']))
              {
                'inventory_batch_id': b['id'],
                'medication_id': b['medication_id'],
                'purchase_date': _isoDate(b['purchase_date']),
                'expiration_date': _isoDate(b['expiration_date']),
                'initial_quantity_scaled': b['available_quantity_scaled'] ?? 0,
                'available_quantity_scaled':
                    b['available_quantity_scaled'] ?? 0,
                'quantity_scale': b['quantity_scale'] ?? 1000,
                'is_depleted':
                    (b['available_quantity_scaled'] ?? 0) == 0 ? 1 : 0,
                'notes': b['source'],
                'created_at': now,
                'updated_at': now,
              },
        ],
        'doses.json': [
          for (final d in doses)
            if (medicationIds.contains(d['medication_id']))
              () {
                final at = _parseSeconds(d['scheduled_at']) ?? now;
                return <String, Object?>{
                  'dose_instance_id': d['id'],
                  'patient_id': patientId,
                  'medication_id': d['medication_id'],
                  'local_date': time.localDateOf(_fromSeconds(at)).toIso(),
                  'scheduled_at': at,
                  'required_quantity_scaled':
                      d['required_quantity_scaled'] ?? 1000,
                  'quantity_scale': 1000,
                  'status': DoseStatus.fromCode(
                    (d['status'] as String? ?? 'SCHEDULED').toUpperCase(),
                  ).code,
                  'is_prn': 0,
                  'created_at': now,
                  'updated_at': now,
                };
              }(),
        ],
        'appointments.json': appointments,
        'vitals.json': vitals,
        'illnesses.json': illnesses,
        'dietary_rules.json': diet,
      },
    );
  }

  static int _seconds(DateTime value) =>
      value.toUtc().millisecondsSinceEpoch ~/ 1000;

  static DateTime _fromSeconds(int seconds) =>
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  static int? _parseSeconds(Object? value) {
    if (value is! String) return null;
    final parsed = DateTime.tryParse(value);
    return parsed == null ? null : _seconds(parsed);
  }

  static String? _isoDate(Object? value) {
    if (value is! String) return null;
    final parsed = DateTime.tryParse(value);
    return parsed == null ? null : LocalDate.fromDateTime(parsed).toIso();
  }
}
