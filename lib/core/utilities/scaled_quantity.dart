/// Medication quantities are never stored as floating point values.
///
/// A quantity is an integer multiplied by [quantityScale]
/// (1 tablet = 1000, 0.25 tablet = 250).
const int quantityScale = 1000;

class ScaledQuantity implements Comparable<ScaledQuantity> {
  const ScaledQuantity(this.scaled);

  const ScaledQuantity.zero() : scaled = 0;

  factory ScaledQuantity.units(int units) =>
      ScaledQuantity(units * quantityScale);

  /// Parses user input such as `1`, `0.5`, `1.25`, `½` or `1,5`.
  ///
  /// Only decimal arithmetic on the text is performed; no floating point
  /// value is ever produced. Returns null for invalid or overly precise input.
  static ScaledQuantity? tryParse(String? input) {
    if (input == null) return null;
    var text = input.trim().replaceAll(',', '.').replaceAll('٫', '.');
    text = _toAsciiDigits(text);
    const fractions = {'¼': '.25', '½': '.5', '¾': '.75'};
    for (final entry in fractions.entries) {
      if (text.endsWith(entry.key)) {
        final whole = text.substring(0, text.length - 1).trim();
        text = '${whole.isEmpty ? '0' : whole}${entry.value}';
      }
    }
    final match = RegExp(r'^(\d*)(?:\.(\d*))?$').firstMatch(text);
    if (match == null || text.isEmpty || text == '.') return null;
    final wholePart = match.group(1)!.isEmpty ? '0' : match.group(1)!;
    final fractionPart = match.group(2) ?? '';
    if (fractionPart.length > 3) return null;
    final whole = int.parse(wholePart);
    final fraction = int.parse(fractionPart.padRight(3, '0'));
    return ScaledQuantity(whole * quantityScale + fraction);
  }

  final int scaled;

  bool get isZero => scaled == 0;
  bool get isNegative => scaled < 0;
  bool get isPositive => scaled > 0;

  ScaledQuantity operator +(ScaledQuantity other) =>
      ScaledQuantity(scaled + other.scaled);
  ScaledQuantity operator -(ScaledQuantity other) =>
      ScaledQuantity(scaled - other.scaled);
  ScaledQuantity operator *(int factor) => ScaledQuantity(scaled * factor);
  bool operator <(ScaledQuantity other) => scaled < other.scaled;
  bool operator >(ScaledQuantity other) => scaled > other.scaled;
  bool operator <=(ScaledQuantity other) => scaled <= other.scaled;
  bool operator >=(ScaledQuantity other) => scaled >= other.scaled;

  static ScaledQuantity min(ScaledQuantity a, ScaledQuantity b) =>
      a <= b ? a : b;

  /// Package conversion: `2 boxes × 20 tablets = 40 tablets`.
  static ScaledQuantity fromPackages({
    required int packages,
    required int unitsPerPackage,
  }) =>
      ScaledQuantity.units(packages * unitsPerPackage);

  /// Human readable representation without trailing zeros (`1.5`, `0.25`).
  String format() {
    final negative = scaled < 0;
    final value = scaled.abs();
    final whole = value ~/ quantityScale;
    final fraction = value % quantityScale;
    var text = '$whole';
    if (fraction != 0) {
      final digits =
          fraction.toString().padLeft(3, '0').replaceFirst(RegExp(r'0+$'), '');
      text = '$whole.$digits';
    }
    return negative ? '-$text' : text;
  }

  @override
  int compareTo(ScaledQuantity other) => scaled.compareTo(other.scaled);

  @override
  bool operator ==(Object other) =>
      other is ScaledQuantity && other.scaled == scaled;

  @override
  int get hashCode => scaled.hashCode;

  @override
  String toString() => format();
}

String formatScaled(int? scaled) =>
    scaled == null ? '—' : ScaledQuantity(scaled).format();

String _toAsciiDigits(String input) {
  const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
  const easternArabicIndic = '۰۱۲۳۴۵۶۷۸۹';
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final char = String.fromCharCode(rune);
    var index = arabicIndic.indexOf(char);
    if (index < 0) index = easternArabicIndic.indexOf(char);
    buffer.write(index >= 0 ? '$index' : char);
  }
  return buffer.toString();
}
