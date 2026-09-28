class CsvToListConverter {
  const CsvToListConverter();
  List<List<String>> convert(String source) => source
      .split(RegExp(r'\r?\n'))
      .where((line) => line.trim().isNotEmpty)
      .map(_row)
      .toList();
  List<String> _row(String line) {
    final fields = <String>[];
    var current = StringBuffer();
    var quoted = false;
    for (var i = 0; i < line.length; i++) {
      final c = line[i];
      if (c == '"') {
        quoted = !quoted;
      } else if (c == ',' && !quoted) {
        fields.add(current.toString().trim());
        current = StringBuffer();
      } else {
        current.write(c);
      }
    }
    fields.add(current.toString().trim());
    return fields;
  }
}

