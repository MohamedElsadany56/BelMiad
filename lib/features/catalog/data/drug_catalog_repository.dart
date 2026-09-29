
import 'package:flutter/services.dart';

import 'csv_parser.dart';
import '../domain/drug_catalog_entry.dart';

class DrugCatalogRepository {
  List<DrugCatalogEntry>? _entries;

  Future<void> load() async {
    if (_entries != null) return;
    final source = await rootBundle.loadString('egyptian-drugs.csv');
    final rows = const CsvToListConverter().convert(source);
    if (rows.isEmpty) {
      _entries = [];
      return;
    }
    final header = rows.first.map((e) => e.toString().trim()).toList();
    final en = header.indexOf('commercial_name_en');
    final ar = header.indexOf('commercial_name_ar');
    final price = header.indexOf('price_egp');
    if (en < 0 || ar < 0 || price < 0) {
      throw const FormatException('Catalog columns are invalid');
    }
    final output = <DrugCatalogEntry>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length <= price) continue;
      final nameEn = row[en].toString().trim();
      final nameAr = row[ar].toString().trim();
      final amount = double.tryParse(row[price].toString().trim());
      if (nameEn.isEmpty || nameAr.isEmpty || amount == null) continue;
      output.add(
        DrugCatalogEntry(
          id: '$i',
          nameEn: nameEn,
          nameAr: nameAr,
          priceEgp: amount,
        ),
      );
    }
    _entries = output;
  }

  Future<List<DrugCatalogEntry>> search(String query, {int limit = 20}) async {
    await load();
    final needle = normalizeDrugSearch(query);
    if (needle.length < 2) return [];
    return _entries!
        .where(
          (e) =>
              normalizeDrugSearch(e.nameEn).contains(needle) ||
              normalizeDrugSearch(e.nameAr).contains(needle),
        )
        .take(limit)
        .toList();
  }
}
