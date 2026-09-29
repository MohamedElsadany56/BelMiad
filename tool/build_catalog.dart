// Builds the read-only Egyptian drug catalog asset from the source CSV.
//
//   dart run tool/build_catalog.dart [input.csv] [output.sqlite]
//
// Pipeline (spec §46): CSV → stream reader → validate/project 3 fields →
// normalize search fields → batched INSERT in a transaction → FTS5 rebuild →
// read-only SQLite asset. The app never parses the CSV at runtime.
import 'dart:convert';
import 'dart:io';

import 'package:belmiad/features/catalog/data/catalog_importer.dart';
import 'package:sqlite3/sqlite3.dart';

class _SqliteSink implements CatalogSink {
  _SqliteSink(this.db) : insert = db.prepare(CatalogSchema.insert);

  final Database db;
  final PreparedStatement insert;

  @override
  void insertBatch(List<CatalogRow> rows) {
    for (final row in rows) {
      insert.execute(row.parameters);
    }
  }
}

Future<void> main(List<String> args) async {
  final input =
      File(args.isNotEmpty ? args[0] : 'assets/data/egyptian-drugs.csv');
  final output =
      File(args.length > 1 ? args[1] : 'assets/data/drug_catalog.sqlite');
  if (!input.existsSync()) {
    stderr.writeln('Input CSV not found: ${input.path}');
    exitCode = 2;
    return;
  }
  final temp = File('${output.path}.tmp');
  if (temp.existsSync()) temp.deleteSync();

  final db = sqlite3.open(temp.path);
  final stopwatch = Stopwatch()..start();
  try {
    db.execute('PRAGMA journal_mode = OFF');
    db.execute('PRAGMA synchronous = OFF');
    for (final statement in CatalogSchema.statements) {
      db.execute(statement);
    }
    final sink = _SqliteSink(db);
    db.execute('BEGIN');
    final lines = input
        .openRead()
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter());
    final report = await CatalogImporter().import(lines, sink);
    sink.insert.close();
    db.execute(CatalogSchema.rebuildFts);
    db.execute(
      'INSERT OR REPLACE INTO catalog_meta (key, value) VALUES (?, ?), (?, ?)',
      [
        'schema_version',
        '${CatalogSchema.version}',
        'row_count',
        '${report.accepted}',
      ],
    );
    db.execute('COMMIT');
    db.execute(
        "INSERT INTO drug_catalog_fts(drug_catalog_fts) VALUES('optimize')");
    db.execute('PRAGMA user_version = ${CatalogSchema.version}');
    db.execute('VACUUM');

    stdout.writeln(
        'Catalog built in ${stopwatch.elapsedMilliseconds} ms: $report');
    for (final rejected in report.rejected.take(50)) {
      stdout.writeln('  rejected $rejected');
    }
    if (report.rejected.length > 50) {
      stdout.writeln('  ... ${report.rejected.length - 50} more');
    }
  } catch (error) {
    db.close();
    if (temp.existsSync()) temp.deleteSync();
    stderr.writeln('Catalog build failed: $error');
    exitCode = 1;
    return;
  }
  db.close();
  if (output.existsSync()) output.deleteSync();
  temp.renameSync(output.path);
  stdout.writeln('Wrote ${output.path} (${output.lengthSync()} bytes)');
}
