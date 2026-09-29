import 'package:flutter_test/flutter_test.dart';
import 'package:belmiad/core/backup/backup_service.dart';
import 'package:belmiad/features/backup/data/backup_merge_service.dart';
import 'package:belmiad/features/catalog/data/csv_parser.dart';

void main() {
  test('CSV parser preserves quoted commas', () {
    final rows = const CsvToListConverter().convert(
      'commercial_name_en,commercial_name_ar,price_egp\n"Test, Plus","اختبار",12',
    );
    expect(rows[1][0], 'Test, Plus');
    expect(rows[1][2], '12');
  });
  test('backup merge preserves unique history and latest duplicate values', () {
    final merged = BackupMergeService().merge(
      {
        'backup_version': 1,
        'doses': [
          {'id': 'a', 'status': 'TAKEN'},
          {'id': 'b', 'status': 'SKIPPED'},
        ],
      },
      {
        'backup_version': 1,
        'doses': [
          {'id': 'a', 'status': 'SCHEDULED'},
          {'id': 'c', 'status': 'TAKEN'},
        ],
      },
    );
    final rows = (merged['doses'] as List).cast<Map>();
    expect(rows, hasLength(3));
    expect(rows.firstWhere((r) => r['id'] == 'a')['status'], 'SCHEDULED');
  });
  test('backup JSON round trip preserves the version marker', () {
    final service = BackupService();
    final source = service.encode(
      patients: const [],
      medications: const [],
      batches: const [],
      doses: const [],
      records: const [],
    );

    final decoded = service.fromJson(service.toJson(source));

    expect(decoded['backup_version'], BackupService.currentVersion);
    expect(decoded['patients'], isEmpty);
  });
}

