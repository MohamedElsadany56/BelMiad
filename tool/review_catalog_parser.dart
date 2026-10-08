// Runs the catalog name parser over the source CSV and prints coverage;
// with an output path it also writes every extracted field for review.
//
//   dart run tool/review_catalog_parser.dart [review.csv]
import 'dart:convert';
import 'dart:io';

import 'package:belmiad/features/catalog/data/catalog_importer.dart';
import 'package:belmiad/features/catalog/domain/catalog_name_parser.dart';

Future<void> main(List<String> args) async {
  final lines = File('assets/data/egyptian-drugs.csv')
      .openRead()
      .transform(const Utf8Decoder(allowMalformed: true))
      .transform(const LineSplitter());
  List<String>? header;
  final out = StringBuffer(
      'name,route,brand,strength,form,details,unit,pack,strips,per_strip,content,flags\n');
  final stats = <String, int>{};
  void count(String k) => stats[k] = (stats[k] ?? 0) + 1;
  await for (final (_, fields, _) in CsvRowReader().rows(lines)) {
    if (fields == null) continue;
    if (header == null) {
      header = fields;
      continue;
    }
    final name = fields[0];
    final route = fields[5];
    final f = parseCatalogName(name, route: route);
    count('rows');
    if (f.strength != null) count('strength');
    if (f.form != null) count('form');
    if (f.doseUnit != null) count('doseUnit');
    if (f.packCount != null) count('pack');
    if (f.contentAmount != null) count('content');
    if (f.route != null) count('route');
    if (route == 'ORAL.SOLID') {
      count('oral_solid');
      if (f.packCount != null) count('oral_solid_pack');
    }
    String q(Object? v) => '"${'${v ?? ''}'.replaceAll('"', '""')}"';
    out.writeln([
      q(name),
      q(route),
      q(f.brand),
      q(f.strength),
      q(f.form),
      q(f.formDetails.join(';')),
      q(f.doseUnit),
      q(f.packCount),
      q(f.stripCount),
      q(f.unitsPerStrip),
      q(f.contentAmount == null ? null : '${f.contentAmount} ${f.contentUnit}'),
      q(f.flags.join(';')),
    ].join(','));
  }
  stdout.writeln(stats);
  if (args.isNotEmpty) File(args.first).writeAsStringSync(out.toString());
}
