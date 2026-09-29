import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';

import 'catalog_asset_stub.dart' if (dart.library.io) 'catalog_asset_io.dart'
    as asset;
import 'catalog_importer.dart';

part 'drug_catalog_database.g.dart';

const catalogAssetPath = 'assets/data/drug_catalog.sqlite';

/// Bump when regenerating `assets/data/drug_catalog.sqlite` so devices copy
/// the new catalog. Patient data lives in a separate database and is never
/// touched by a catalog replacement (UC-DRUG-07).
const catalogAssetVersion = 1;

/// Read-only reference database holding the static drug catalog and its FTS5
/// index. Queried with bound SQL only; the schema lives in [CatalogSchema].
@DriftDatabase()
class DrugCatalogDatabase extends _$DrugCatalogDatabase {
  DrugCatalogDatabase(super.executor);

  @override
  int get schemaVersion => CatalogSchema.version;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Only runs when the bundled asset is unavailable; creates an empty,
        // valid catalog so custom medications still work.
        onCreate: (m) async {
          for (final statement in CatalogSchema.statements) {
            await customStatement(statement);
          }
        },
        onUpgrade: (m, from, to) async {},
      );
}

Future<Uint8List> _loadAssetBytes() async {
  final data = await rootBundle.load(catalogAssetPath);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

DrugCatalogDatabase openDrugCatalogDatabase() {
  return DrugCatalogDatabase(
    driftDatabase(
      name: 'drug_catalog_v$catalogAssetVersion',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        initializeDatabase: _loadAssetBytes,
      ),
      native: DriftNativeOptions(
        databasePath: () => asset.prepareCatalogFile(
          version: catalogAssetVersion,
          loadAsset: _loadAssetBytes,
        ),
      ),
    ),
  );
}
