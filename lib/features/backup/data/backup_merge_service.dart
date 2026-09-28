import 'dart:convert';

class BackupMergeService {
  Map<String, dynamic> merge(Map<String, dynamic> current, Map<String, dynamic> incoming) {
    final merged = Map<String, dynamic>.from(current);
    for (final key in ['patients', 'medications', 'inventory_batches', 'doses', 'health_records']) {
      final oldRows = (current[key] as List? ?? const []).cast<Map>().map(Map<String, dynamic>.from).toList();
      final newRows = (incoming[key] as List? ?? const []).cast<Map>().map(Map<String, dynamic>.from).toList();
      final byId = <String, Map<String, dynamic>>{for (final row in oldRows) '${row['id']}': row};
      for (final row in newRows) { byId['${row['id']}'] = {...byId['${row['id']}'] ?? {}, ...row}; }
      merged[key] = byId.values.toList();
    }
    merged['backup_version'] = current['backup_version'] ?? incoming['backup_version'] ?? 1;
    merged['merged_at'] = DateTime.now().toUtc().toIso8601String();
    return jsonDecode(jsonEncode(merged)) as Map<String, dynamic>;
  }
}
