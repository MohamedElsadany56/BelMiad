import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../domain/drug_search_normalizer.dart';

/// SQL for the read-only catalog database (spec §4, §46).
abstract final class CatalogSchema {
  static const version = 1;

  static const statements = [
    'CREATE TABLE IF NOT EXISTS drug_catalog ('
        'rowid INTEGER PRIMARY KEY, '
        'catalog_id TEXT NOT NULL UNIQUE, '
        'commercial_name_en TEXT NOT NULL, '
        'commercial_name_ar TEXT NOT NULL, '
        'price_egp REAL NOT NULL, '
        'search_en TEXT NOT NULL, '
        'search_ar TEXT NOT NULL)',
    "CREATE VIRTUAL TABLE IF NOT EXISTS drug_catalog_fts USING fts5("
        "search_en, search_ar, content='drug_catalog', content_rowid='rowid', "
        "tokenize='unicode61 remove_diacritics 2')",
    'CREATE TABLE IF NOT EXISTS catalog_meta (key TEXT PRIMARY KEY, value TEXT)',
  ];

  static const insert =
      'INSERT OR IGNORE INTO drug_catalog (catalog_id, commercial_name_en, '
      'commercial_name_ar, price_egp, search_en, search_ar) '
      'VALUES (?, ?, ?, ?, ?, ?)';

  static const rebuildFts =
      "INSERT INTO drug_catalog_fts(drug_catalog_fts) VALUES('rebuild')";
}

class CatalogRow {
  const CatalogRow({
    required this.catalogId,
    required this.nameEn,
    required this.nameAr,
    required this.priceEgp,
    required this.searchEn,
    required this.searchAr,
  });

  final String catalogId;
  final String nameEn;
  final String nameAr;
  final double priceEgp;
  final String searchEn;
  final String searchAr;

  List<Object> get parameters =>
      [catalogId, nameEn, nameAr, priceEgp, searchEn, searchAr];
}

class RejectedRow {
  const RejectedRow(this.line, this.reason, [this.raw]);

  final int line;
  final String reason;
  final String? raw;

  @override
  String toString() => 'line $line: $reason${raw == null ? '' : ' ($raw)'}';
}

class CatalogImportReport {
  int accepted = 0;
  int duplicates = 0;
  int repaired = 0;
  final rejected = <RejectedRow>[];

  @override
  String toString() => 'accepted=$accepted duplicates=$duplicates '
      'repaired=$repaired rejected=${rejected.length}';
}

/// Destination for imported rows (SQLite in the build tool and tests).
abstract class CatalogSink {
  FutureOr<void> insertBatch(List<CatalogRow> rows);
}

/// Streaming CSV reader supporting RFC 4180 quoting, escaped quotes and
/// quoted line breaks, without loading the whole file into memory.
class CsvRowReader {
  CsvRowReader();

  /// Emits `(lineNumber, fields)`; malformed rows are emitted with a
  /// [FormatException] instead of fields.
  Stream<(int, List<String>?, FormatException?)> rows(
    Stream<String> lines,
  ) async* {
    var fields = <String>[];
    var current = StringBuffer();
    var inQuotes = false;
    var lineNumber = 0;
    var startLine = 0;
    await for (final line in lines) {
      lineNumber++;
      if (!inQuotes) {
        startLine = lineNumber;
        if (line.trim().isEmpty) continue;
      } else {
        current.write('\n');
      }
      var i = 0;
      var error = false;
      while (i < line.length) {
        final char = line[i];
        if (inQuotes) {
          if (char == '"') {
            if (i + 1 < line.length && line[i + 1] == '"') {
              current.write('"');
              i++;
            } else {
              inQuotes = false;
              if (i + 1 < line.length && line[i + 1] != ',') {
                error = true;
                break;
              }
            }
          } else {
            current.write(char);
          }
        } else if (char == '"') {
          if (current.isNotEmpty) {
            error = true;
            break;
          }
          inQuotes = true;
        } else if (char == ',') {
          fields.add(current.toString());
          current = StringBuffer();
        } else {
          current.write(char);
        }
        i++;
      }
      if (error) {
        yield (startLine, null, const FormatException('invalid quoting'));
        fields = <String>[];
        current = StringBuffer();
        inQuotes = false;
        continue;
      }
      if (inQuotes) continue;
      fields.add(current.toString());
      yield (startLine, fields, null);
      fields = <String>[];
      current = StringBuffer();
    }
    if (inQuotes) {
      yield (startLine, null, const FormatException('unterminated quote'));
    }
  }
}

/// Projects the source CSV to the three runtime fields, validates, normalizes
/// search copies, deduplicates and writes in batches (spec §4, §46).
class CatalogImporter {
  CatalogImporter({this.batchSize = 500});

  final int batchSize;

  static const requiredColumns = [
    'commercial_name_en',
    'commercial_name_ar',
    'price_egp',
  ];

  /// Stable ID derived from the dedup identity, so rebuilding the catalog
  /// never re-points existing medications to a different drug.
  static String catalogIdFor(String searchEn, String searchAr, double price) {
    final digest = sha1.convert(
      utf8.encode('$searchEn|$searchAr|${price.toStringAsFixed(2)}'),
    );
    return 'eg_${digest.toString().substring(0, 16)}';
  }

  Future<CatalogImportReport> import(
    Stream<String> lines,
    CatalogSink sink,
  ) async {
    final report = CatalogImportReport();
    final seen = <String>{};
    var batch = <CatalogRow>[];
    List<String>? header;
    late int en, ar, price;

    await for (final (line, fields, error) in CsvRowReader().rows(lines)) {
      if (error != null) {
        report.rejected.add(RejectedRow(line, error.message));
        continue;
      }
      var row = fields!;
      if (header == null) {
        header = [
          for (final h in row) h.replaceFirst('﻿', '').trim().toLowerCase(),
        ];
        final missing =
            requiredColumns.where((c) => !header!.contains(c)).toList();
        if (missing.isNotEmpty) {
          throw FormatException('Missing required columns: $missing');
        }
        en = header.indexOf('commercial_name_en');
        ar = header.indexOf('commercial_name_ar');
        price = header.indexOf('price_egp');
        continue;
      }
      if (row.length != header.length) {
        report.rejected.add(RejectedRow(line, 'invalid column count'));
        continue;
      }
      row = [for (final f in row) f.trim()];
      final nameEn = row[en];
      var nameAr = row[ar];
      final priceValue = double.tryParse(row[price].replaceAll(',', ''));
      if (nameEn.isEmpty) {
        report.rejected.add(RejectedRow(line, 'missing English name'));
        continue;
      }
      if (nameAr.isEmpty) {
        report.rejected.add(RejectedRow(line, 'missing Arabic name', nameEn));
        continue;
      }
      if (priceValue == null || priceValue.isNaN || priceValue < 0) {
        report.rejected.add(RejectedRow(line, 'price is not numeric', nameEn));
        continue;
      }
      if (nameAr.contains('�')) {
        report.rejected.add(RejectedRow(line, 'invalid UTF-8', nameEn));
        continue;
      }
      if (looksLikeMojibake(nameAr)) {
        final repaired = repairMojibake(nameAr);
        if (repaired == null) {
          report.rejected.add(
            RejectedRow(line, 'suspicious encoding (mojibake)', nameAr),
          );
          continue;
        }
        nameAr = repaired;
        report.repaired++;
      }
      final searchEn = normalizeForDrugSearch(nameEn);
      final searchAr = normalizeForDrugSearch(nameAr);
      final id = catalogIdFor(searchEn, searchAr, priceValue);
      if (!seen.add(id)) {
        report.duplicates++;
        continue;
      }
      batch.add(CatalogRow(
        catalogId: id,
        nameEn: nameEn,
        nameAr: nameAr,
        priceEgp: priceValue,
        searchEn: searchEn,
        searchAr: searchAr,
      ));
      report.accepted++;
      if (batch.length >= batchSize) {
        await sink.insertBatch(batch);
        batch = <CatalogRow>[];
      }
    }
    if (header == null) throw const FormatException('Empty CSV');
    if (batch.isNotEmpty) await sink.insertBatch(batch);
    return report;
  }
}
