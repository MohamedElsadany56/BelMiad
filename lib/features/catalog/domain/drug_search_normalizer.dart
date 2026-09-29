/// Deterministic normalization shared by the catalog index builder and the
/// runtime search query (spec §4 "Arabic search normalization").
///
/// Only search/index copies are normalized; display strings are never
/// modified.
String normalizeForDrugSearch(String input) {
  var text = input.toLowerCase();
  text = _toAsciiDigits(text);
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    // Tatweel and Arabic diacritics (harakat, shadda, sukun, superscript alef).
    if (rune == 0x0640 ||
        (rune >= 0x064B && rune <= 0x065F) ||
        rune == 0x0670) {
      continue;
    }
    buffer.writeCharCode(_arabicFold[rune] ?? _latinFold[rune] ?? rune);
  }
  return buffer
      .toString()
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

/// Builds a bound FTS5 MATCH expression with prefix matching for every
/// token, e.g. `panad ext` → `"panad"* "ext"*`. Tokens are always quoted, so
/// user input can never inject FTS operators.
String? buildFtsPrefixQuery(String normalized, {int trimLastChars = 0}) {
  final tokens = normalized.split(' ').where((t) => t.isNotEmpty).map((t) {
    if (trimLastChars > 0 && t.length > trimLastChars + 2) {
      return t.substring(0, t.length - trimLastChars);
    }
    return t;
  }).toList();
  if (tokens.isEmpty) return null;
  return tokens.map((t) => '"${t.replaceAll('"', '""')}"*').join(' ');
}

/// Escapes a value for a SQL `LIKE ... ESCAPE '\'` pattern.
String escapeLike(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll('%', r'\%')
    .replaceAll('_', r'\_');

const _arabicFold = <int, int>{
  0x0623: 0x0627, // أ → ا
  0x0625: 0x0627, // إ → ا
  0x0622: 0x0627, // آ → ا
  0x0671: 0x0627, // ٱ → ا
  0x0649: 0x064A, // ى → ي
  0x0629: 0x0647, // ة → ه
  0x0624: 0x0648, // ؤ → و
  0x0626: 0x064A, // ئ → ي
};

const _latinFold = <int, int>{
  0x00E0: 0x61, 0x00E1: 0x61, 0x00E2: 0x61, 0x00E4: 0x61, // à á â ä
  0x00E7: 0x63, // ç
  0x00E8: 0x65, 0x00E9: 0x65, 0x00EA: 0x65, 0x00EB: 0x65, // è é ê ë
  0x00EC: 0x69, 0x00ED: 0x69, 0x00EE: 0x69, 0x00EF: 0x69, // ì í î ï
  0x00F1: 0x6E, // ñ
  0x00F2: 0x6F, 0x00F3: 0x6F, 0x00F4: 0x6F, 0x00F6: 0x6F, // ò ó ô ö
  0x00F9: 0x75, 0x00FA: 0x75, 0x00FB: 0x75, 0x00FC: 0x75, // ù ú û ü
};

String _toAsciiDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + rune - 0x0660);
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + rune - 0x06F0);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

final _arabicLetter = RegExp(r'[؀-ۿ]');

/// Detects UTF-8 Arabic that was mis-decoded as Windows-1252/Latin-1
/// ("mojibake", e.g. `Ø¥ÙƒØ³ØªØ±Ø§`).
bool looksLikeMojibake(String value) =>
    !_arabicLetter.hasMatch(value) && RegExp('[ØÙÚÛ][\u0080-˿ -⃿]').hasMatch(value);

/// Attempts a controlled recovery of mojibake by re-encoding as Windows-1252
/// and decoding as UTF-8. Returns null when recovery does not yield Arabic;
/// the row must then be reported, never guessed.
String? repairMojibake(String value) {
  final bytes = <int>[];
  for (final rune in value.runes) {
    final byte = _cp1252Reverse[rune] ?? (rune <= 0xFF ? rune : null);
    if (byte == null) return null;
    bytes.add(byte);
  }
  try {
    final decoded = String.fromCharCodes(_decodeUtf8Strict(bytes));
    return _arabicLetter.hasMatch(decoded) ? decoded : null;
  } on FormatException {
    return null;
  }
}

List<int> _decodeUtf8Strict(List<int> bytes) {
  final runes = <int>[];
  var i = 0;
  while (i < bytes.length) {
    final b = bytes[i];
    int length;
    int rune;
    if (b < 0x80) {
      runes.add(b);
      i++;
      continue;
    } else if (b & 0xE0 == 0xC0) {
      length = 2;
      rune = b & 0x1F;
    } else if (b & 0xF0 == 0xE0) {
      length = 3;
      rune = b & 0x0F;
    } else if (b & 0xF8 == 0xF0) {
      length = 4;
      rune = b & 0x07;
    } else {
      throw const FormatException('Invalid UTF-8');
    }
    if (i + length > bytes.length) throw const FormatException('Truncated');
    for (var k = 1; k < length; k++) {
      final c = bytes[i + k];
      if (c & 0xC0 != 0x80) throw const FormatException('Invalid UTF-8');
      rune = (rune << 6) | (c & 0x3F);
    }
    runes.add(rune);
    i += length;
  }
  return runes;
}

const _cp1252Reverse = <int, int>{
  0x20AC: 0x80, 0x201A: 0x82, 0x0192: 0x83, 0x201E: 0x84, 0x2026: 0x85,
  0x2020: 0x86, 0x2021: 0x87, 0x02C6: 0x88, 0x2030: 0x89, 0x0160: 0x8A,
  0x2039: 0x8B, 0x0152: 0x8C, 0x017D: 0x8E, 0x2018: 0x91, 0x2019: 0x92,
  0x201C: 0x93, 0x201D: 0x94, 0x2022: 0x95, 0x2013: 0x96, 0x2014: 0x97,
  0x02DC: 0x98, 0x2122: 0x99, 0x0161: 0x9A, 0x203A: 0x9B, 0x0153: 0x9C,
  0x017E: 0x9E, 0x0178: 0x9F,
};
