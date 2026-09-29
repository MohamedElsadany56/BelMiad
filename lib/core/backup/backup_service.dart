import 'dart:convert';

import '../../core/database/app_database.dart';

class BackupService {
  static const currentVersion = 1;
  Map<String, dynamic> encode({
    required List<PatientsData> patients,
    required List<MedicationsData> medications,
    required List<InventoryBatche> batches,
    required List<DoseInstancesData> doses,
    required List<HealthRecordsData> records,
  }) =>
      {
        'backup_version': currentVersion,
        'exported_at': DateTime.now().toUtc().toIso8601String(),
        'patients': patients
            .map(
              (p) => {
                'id': p.id,
                'name': p.name,
                'relation': p.relation,
                'timezone': p.timezone,
              },
            )
            .toList(),
        'medications': medications
            .map(
              (m) => {
                'id': m.id,
                'patient_id': m.patientId,
                'name_en': m.nameEn,
                'name_ar': m.nameAr,
                'strength': m.strength,
                'dosage_form': m.dosageForm,
                'is_prn': m.isPrn,
              },
            )
            .toList(),
        'inventory_batches': batches
            .map(
              (b) => {
                'id': b.id,
                'medication_id': b.medicationId,
                'available_quantity_scaled': b.availableQuantityScaled,
                'quantity_scale': b.quantityScale,
                'unit': b.unit,
                'purchase_date': b.purchaseDate.toIso8601String(),
                'expiration_date': b.expirationDate?.toIso8601String(),
                'source': b.source,
              },
            )
            .toList(),
        'doses': doses
            .map(
              (d) => {
                'id': d.id,
                'patient_id': d.patientId,
                'medication_id': d.medicationId,
                'scheduled_at': d.scheduledAt.toIso8601String(),
                'required_quantity_scaled': d.requiredQuantityScaled,
                'status': d.status,
              },
            )
            .toList(),
        'health_records': records
            .map(
              (r) => {
                'id': r.id,
                'patient_id': r.patientId,
                'type': r.type,
                'title': r.title,
                'notes': r.notes,
                'metadata_json': r.metadataJson,
                'occurred_at': r.occurredAt.toIso8601String(),
              },
            )
            .toList(),
      };

  String toJson(Map<String, dynamic> backup) =>
      const JsonEncoder.withIndent('  ').convert(backup);
  Map<String, dynamic> fromJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic> || decoded['backup_version'] is! int) {
      throw const FormatException('Invalid BelMiad backup');
    }
    if ((decoded['backup_version'] as int) > currentVersion) {
      throw const FormatException('Backup is from a newer version');
    }
    return decoded;
  }

}

