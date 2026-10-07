import 'package:drift/drift.dart';

import '../domain/catalog_name_parser.dart';
import '../domain/drug_search_normalizer.dart';

/// Only the columns needed by a result card (never `SELECT *`).
class DrugSearchResult {
  const DrugSearchResult({
    required this.catalogId,
    required this.nameEn,
    required this.nameAr,
    required this.priceEgp,
    this.facts,
    this.scientificName,
  });

  final String catalogId;
  final String nameEn;
  final String nameAr;

  /// Reference price only; never used as the actual purchase price.
  final double priceEgp;

  /// Brand, strength, form and pack size read from the name. A suggestion
  /// for the user, who can change any of it. Null for catalogs built before
  /// these facts were stored.
  final CatalogDrugFacts? facts;

  final String? scientificName;

  @override
  bool operator ==(Object other) =>
      other is DrugSearchResult && other.catalogId == catalogId;

  @override
  int get hashCode => catalogId.hashCode;
}

/// Bounded FTS5 search over the read-only catalog (spec §4, §46).
class DrugCatalogRepository {
  DrugCatalogRepository(this._db);

  static const minimumQueryLength = 2;
  static const defaultLimit = 20;
  static const maximumLimit = 50;

  final GeneratedDatabase _db;

  static const _columns = 'c.catalog_id, c.commercial_name_en, '
      'c.commercial_name_ar, c.price_egp, c.brand, c.strength, c.form, '
      'c.form_details, c.dose_unit, c.pack_count, c.strip_count, '
      'c.units_per_strip, c.content_amount, c.content_unit, c.route, '
      'c.scientific_name, c.flags';

  DrugSearchResult _map(QueryRow row) {
    final brand = row.readNullable<String>('brand');
    List<String> list(String column) => (row.readNullable<String>(column) ?? '')
        .split(',')
        .where((v) => v.isNotEmpty)
        .toList();
    return DrugSearchResult(
      catalogId: row.read<String>('catalog_id'),
      nameEn: row.read<String>('commercial_name_en'),
      nameAr: row.read<String>('commercial_name_ar'),
      priceEgp: row.read<double>('price_egp'),
      scientificName: row.readNullable<String>('scientific_name'),
      facts: brand == null
          ? null
          : CatalogDrugFacts(
              brand: brand,
              strength: row.readNullable<String>('strength'),
              form: row.readNullable<String>('form'),
              formDetails: list('form_details'),
              doseUnit: row.readNullable<String>('dose_unit'),
              packCount: row.readNullable<int>('pack_count'),
              stripCount: row.readNullable<int>('strip_count'),
              unitsPerStrip: row.readNullable<int>('units_per_strip'),
              contentAmount: row.readNullable<double>('content_amount'),
              contentUnit: row.readNullable<String>('content_unit'),
              route: row.readNullable<String>('route'),
              flags: list('flags').toSet(),
            ),
    );
  }

  /// Searches English and Arabic commercial names with prefix matching.
  /// Exact matches rank first, then prefix matches, then FTS relevance.
  /// When nothing matches, a typo-tolerant retry trims the end of each term.
  Future<List<DrugSearchResult>> search(
    String query, {
    int limit = defaultLimit,
    int offset = 0,
  }) async {
    final normalized = normalizeForDrugSearch(query);
    if (normalized.length < minimumQueryLength) return const [];
    final boundedLimit = limit.clamp(1, maximumLimit);
    var results = await _match(normalized, boundedLimit, offset, 0);
    if (results.isEmpty && offset == 0) {
      for (var trim = 1; trim <= 2 && results.isEmpty; trim++) {
        results = await _match(normalized, boundedLimit, offset, trim);
      }
    }
    return results;
  }

  Future<List<DrugSearchResult>> _match(
    String normalized,
    int limit,
    int offset,
    int trim,
  ) async {
    final fts = buildFtsPrefixQuery(normalized, trimLastChars: trim);
    if (fts == null) return const [];
    final prefix = '${escapeLike(normalized)}%';
    try {
      final rows = await _db.customSelect(
        'SELECT $_columns FROM drug_catalog_fts f '
        'JOIN drug_catalog c ON c.rowid = f.rowid '
        'WHERE drug_catalog_fts MATCH ? '
        'ORDER BY CASE '
        'WHEN c.search_en = ? OR c.search_ar = ? THEN 0 '
        "WHEN c.search_en LIKE ? ESCAPE '\\' OR c.search_ar LIKE ? ESCAPE '\\' "
        'THEN 1 ELSE 2 END, bm25(drug_catalog_fts), c.commercial_name_en '
        'LIMIT ? OFFSET ?',
        variables: [
          Variable.withString(fts),
          Variable.withString(normalized),
          Variable.withString(normalized),
          Variable.withString(prefix),
          Variable.withString(prefix),
          Variable.withInt(limit),
          Variable.withInt(offset),
        ],
      ).get();
      return rows.map(_map).toList();
    } catch (_) {
      return const [];
    }
  }

  /// Entries for an empty query (recently selected), without scanning the
  /// whole table.
  Future<List<DrugSearchResult>> byIds(List<String> catalogIds) async {
    if (catalogIds.isEmpty) return const [];
    final ids = catalogIds.take(maximumLimit).toList();
    final placeholders = List.filled(ids.length, '?').join(', ');
    final rows = await _db.customSelect(
      'SELECT $_columns FROM drug_catalog c '
      'WHERE c.catalog_id IN ($placeholders)',
      variables: [for (final id in ids) Variable.withString(id)],
    ).get();
    final byId = {for (final r in rows.map(_map)) r.catalogId: r};
    return [
      for (final id in ids)
        if (byId[id] != null) byId[id]!
    ];
  }

  /// Other entries of the same medicine (same brand): other strengths,
  /// forms (syrup, tablets, drops...) and pack sizes. Includes [entry].
  Future<List<DrugSearchResult>> variantsOf(
    DrugSearchResult entry, {
    int limit = maximumLimit,
  }) async {
    final brand = entry.facts?.brand;
    if (brand == null || brand.isEmpty) return [entry];
    try {
      final rows = await _db.customSelect(
        'SELECT $_columns FROM drug_catalog c WHERE c.brand_key = ? '
        'ORDER BY c.form, c.strength, c.pack_count, c.content_amount '
        'LIMIT ?',
        variables: [
          Variable.withString(normalizeForDrugSearch(brand)),
          Variable.withInt(limit),
        ],
      ).get();
      final variants = rows.map(_map).toList();
      return variants.contains(entry) ? variants : [entry, ...variants];
    } catch (_) {
      return [entry];
    }
  }

  Future<DrugSearchResult?> byId(String catalogId) async =>
      (await byIds([catalogId])).firstOrNull;

  Future<int> count() async {
    final row = await _db
        .customSelect('SELECT COUNT(*) AS n FROM drug_catalog')
        .getSingle();
    return row.read<int>('n');
  }
}
