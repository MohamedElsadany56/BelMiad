/// Reads structured facts out of an Egyptian drug catalog name such as
/// `CONCOR 10 MG 30 F.C. TABS.` or `DESLORAT 2.5MG/5ML SYRUP 100ML`.
///
/// Names are typed by hand in the source data, so this is a best-effort
/// helper: every value is only a suggestion the user can change.
library;

/// Dosage form codes stored in the catalog (`form` column).
abstract final class DrugForms {
  static const tablet = 'tablet';
  static const capsule = 'capsule';
  static const sachet = 'sachet';
  static const ampoule = 'ampoule';
  static const vial = 'vial';
  static const syringe = 'syringe';
  static const pen = 'pen';
  static const suppository = 'suppository';
  static const lozenge = 'lozenge';
  static const patch = 'patch';
  static const film = 'film';
  static const piece = 'piece';
  static const teaBag = 'tea_bag';
  static const syrup = 'syrup';
  static const suspension = 'suspension';
  static const solution = 'solution';
  static const drops = 'drops';
  static const eyeDrops = 'eye_drops';
  static const earDrops = 'ear_drops';
  static const nasalSpray = 'nasal_spray';
  static const spray = 'spray';
  static const inhaler = 'inhaler';
  static const infusion = 'infusion';
  static const injection = 'injection';
  static const cream = 'cream';
  static const ointment = 'ointment';
  static const gel = 'gel';
  static const lotion = 'lotion';
  static const shampoo = 'shampoo';
  static const mouthwash = 'mouthwash';
  static const powder = 'powder';
  static const emulsion = 'emulsion';
  static const oil = 'oil';
  static const soap = 'soap';

  static const all = [
    tablet, capsule, sachet, ampoule, vial, syringe, pen, suppository,
    lozenge, patch, film, piece, teaBag, syrup, suspension, solution, drops,
    eyeDrops, earDrops, nasalSpray, spray, inhaler, infusion, injection,
    cream, ointment, gel, lotion, shampoo, mouthwash, powder, emulsion, oil,
    soap, //
  ];

  /// Forms counted one by one (a box of 30 tablets, 10 ampoules...).
  static const countable = {
    tablet, capsule, sachet, ampoule, vial, syringe, pen, suppository,
    lozenge, patch, film, piece, teaBag, //
  };
}

/// Form details (`form_details` column, comma separated).
abstract final class DrugFormDetails {
  static const filmCoated = 'film_coated';
  static const coated = 'coated';
  static const sugarCoated = 'sugar_coated';
  static const entericCoated = 'enteric_coated';
  static const extendedRelease = 'extended_release';
  static const delayedRelease = 'delayed_release';
  static const chewable = 'chewable';
  static const effervescent = 'effervescent';
  static const orodispersible = 'orodispersible';
  static const dispersible = 'dispersible';
  static const sublingual = 'sublingual';
  static const scored = 'scored';
  static const softGel = 'soft_gel';
  static const hardGelatin = 'hard_gelatin';
  static const vaginal = 'vaginal';
  static const rectal = 'rectal';
  static const paediatric = 'paediatric';
  static const intravenous = 'intravenous';
  static const intramuscular = 'intramuscular';
  static const subcutaneous = 'subcutaneous';
  static const transdermal = 'transdermal';

  static const all = [
    filmCoated, coated, sugarCoated, entericCoated, extendedRelease,
    delayedRelease, chewable, effervescent, orodispersible, dispersible,
    sublingual, scored, softGel, hardGelatin, vaginal, rectal, paediatric,
    intravenous, intramuscular, subcutaneous, transdermal, //
  ];
}

/// Catalog availability notes found in names, e.g. `(CANCELLED)`.
abstract final class DrugFlags {
  static const cancelled = 'cancelled';
  static const illegalImport = 'illegal_import';
  static const notAvailable = 'not_available';
  static const hospitalOnly = 'hospital_only';
}

/// Normalised route codes (`route` column).
abstract final class DrugRoutes {
  static const oral = 'oral';
  static const topical = 'topical';
  static const injection = 'injection';
  static const eye = 'eye';
  static const ear = 'ear';
  static const nasal = 'nasal';
  static const inhalation = 'inhalation';
  static const mouth = 'mouth';
  static const vaginal = 'vaginal';
  static const rectal = 'rectal';
}

class CatalogDrugFacts {
  const CatalogDrugFacts({
    required this.brand,
    this.strength,
    this.form,
    this.formDetails = const [],
    this.doseUnit,
    this.packCount,
    this.stripCount,
    this.unitsPerStrip,
    this.contentAmount,
    this.contentUnit,
    this.route,
    this.flags = const {},
  });

  /// Name without strength, pack size or notes, in title case
  /// ("CONCOR 10 MG 30 TABS." → "Concor").
  final String brand;

  /// Normalised strength: "500 mg", "160/25 mg", "250 mg/5 ml", "0.1%".
  final String? strength;

  /// A [DrugForms] code.
  final String? form;

  /// [DrugFormDetails] codes.
  final List<String> formDetails;

  /// The app's dose unit code (tablet, capsule, ml, drop, puff...).
  final String? doseUnit;

  /// Units in one pack (30 tablets, 10 ampoules...).
  final int? packCount;

  /// Strips in the box and units per strip, when the name says so
  /// ("25 STRIPS X 10 TAB").
  final int? stripCount;
  final int? unitsPerStrip;

  /// Size of a bottle, tube or vial: 120 (ml), 30 (g).
  final double? contentAmount;

  /// 'ml' or 'g'.
  final String? contentUnit;

  /// A [DrugRoutes] code.
  final String? route;

  /// [DrugFlags] codes.
  final Set<String> flags;
}

// ---------------------------------------------------------------- parsing

const _num = r'\d+(?:[.,]\d+)*';

/// Countable forms and the words used for them in the catalog, most specific
/// first.
final _countForms = <(String, String)>[
  (r'F\.?\s?C\.?\s*T(?:AB(?:LET)?S?)?', DrugForms.tablet),
  (r'CAPLETS?|ODTS?', DrugForms.tablet),
  (r'TAB(?:LET)?S?|TABLES|PILLS?|TB?S', DrugForms.tablet),
  (
    r'S\.?G\.?\s*CAPS?|SOFT\s*GEL(?:ATIN)?\s*CAP(?:SULE)?S?|SOFTGELS?|HGCS?',
    DrugForms.capsule
  ),
  (r'CAP(?:SULE)?S?', DrugForms.capsule),
  (
    r'(?:GRAN(?:ULES)?\.?\s*(?:IN\s*)?)?SACHETS?|SACH|STICK\s*PACKS?|PACKETS?',
    DrugForms.sachet
  ),
  (r'AMP(?:OULE)?S?', DrugForms.ampoule),
  (r'VIALS?', DrugForms.vial),
  (r'(?:PRE-?F(?:ILLED)?\.?\s*)?SYRINGES?', DrugForms.syringe),
  (r'(?:PRE-?FILLED\s*)?PENS?|CARTRIDGES?', DrugForms.pen),
  (
    r'SUPP(?:OSITOR(?:Y|IES))?S?|OVULES?|PESSAR(?:Y|IES)',
    DrugForms.suppository
  ),
  (r'LOZ(?:ENGE)?S?|PASTILLES?', DrugForms.lozenge),
  (r'PATCH(?:ES)?', DrugForms.patch),
  (r'FILMS?', DrugForms.film),
  (r'GUMMIES|GUMMY|CHEWS|JELL(?:Y|IES)|PIECES|PEICES|PCS', DrugForms.piece),
  (r'(?:TEA\s*|FILTER\s*)?BAGS', DrugForms.teaBag),
  (r'DOSES|PUFFS', DrugForms.inhaler),
];

final _countFormRx = _countForms.map((f) => '(?:${f.$1})').join('|');

/// Liquid and semi-solid forms, checked in order.
final _bulkForms = <(String, String)>[
  (r'EYE\s*(?:/\s*EAR\s*)?(?:DROPS?|DPS|GEL|OINT|SOL)', DrugForms.eyeDrops),
  (r'EAR\s*DROPS?', DrugForms.earDrops),
  (r'NASAL\s*(?:SPRAY|DROPS?)', DrugForms.nasalSpray),
  (r'INHAL(?:ER|ATION)|INH\b|AEROSOL|NEBUL', DrugForms.inhaler),
  (r'MOUTH\s*WASH|GARGLE', DrugForms.mouthwash),
  (r'SYRUP|SYR\b', DrugForms.syrup),
  (r'SUSP(?:ENSION)?\b', DrugForms.suspension),
  (r'DROPS?\b|DPS\b', DrugForms.drops),
  (r'INFUSION|I\.?V\.?\s*INF', DrugForms.infusion),
  (r'INJ(?:ECTION)?\b', DrugForms.injection),
  (r'EMULGEL|EMULSION', DrugForms.emulsion),
  (r'CREAM|CRM\b', DrugForms.cream),
  (r'OINT(?:MENT)?\b', DrugForms.ointment),
  (r'GEL\b', DrugForms.gel),
  (r'LOTION', DrugForms.lotion),
  (r'SHAMPOO', DrugForms.shampoo),
  (r'SPRAY', DrugForms.spray),
  (r'SOAP|SHOWER|WASH\b|CLEANSER', DrugForms.soap),
  (r'POWDER|\bPDR?\b|\bPWD\b', DrugForms.powder),
  (r'\bOIL\b', DrugForms.oil),
  (r'SOL(?:UTION|N)?\b|ELIXIR|LIQUID', DrugForms.solution),
];

/// Words between a count and its form ("30 EXT. REL. F.C. TABS").
final _details = <String, String>{
  'F.C': DrugFormDetails.filmCoated,
  'FC': DrugFormDetails.filmCoated,
  'FILM': DrugFormDetails.filmCoated,
  'COATED': DrugFormDetails.coated,
  'C': DrugFormDetails.coated,
  'SUGAR': DrugFormDetails.sugarCoated,
  'E.C': DrugFormDetails.entericCoated,
  'ENTERIC': DrugFormDetails.entericCoated,
  'ENTRIC': DrugFormDetails.entericCoated,
  'GASTRO-RESISTANT': DrugFormDetails.entericCoated,
  'GASTRO': DrugFormDetails.entericCoated,
  'GAST': DrugFormDetails.entericCoated,
  'EXT': DrugFormDetails.extendedRelease,
  'EXTENDED': DrugFormDetails.extendedRelease,
  'E.R': DrugFormDetails.extendedRelease,
  'ER': DrugFormDetails.extendedRelease,
  'XR': DrugFormDetails.extendedRelease,
  'PROLONGED': DrugFormDetails.extendedRelease,
  'PROLON': DrugFormDetails.extendedRelease,
  'SUSTAINED': DrugFormDetails.extendedRelease,
  'SUST': DrugFormDetails.extendedRelease,
  'S.R': DrugFormDetails.extendedRelease,
  'SR': DrugFormDetails.extendedRelease,
  'M.R': DrugFormDetails.extendedRelease,
  'MR': DrugFormDetails.extendedRelease,
  'MODIFIED': DrugFormDetails.extendedRelease,
  'CONTROLLED': DrugFormDetails.extendedRelease,
  'RETARD': DrugFormDetails.extendedRelease,
  'SLOW': DrugFormDetails.extendedRelease,
  'DEL': DrugFormDetails.delayedRelease,
  'DELA': DrugFormDetails.delayedRelease,
  'DELAYED': DrugFormDetails.delayedRelease,
  'D.R': DrugFormDetails.delayedRelease,
  'DR': DrugFormDetails.delayedRelease,
  'CHEW': DrugFormDetails.chewable,
  'CHEWABLE': DrugFormDetails.chewable,
  'CHEWBLE': DrugFormDetails.chewable,
  'CHEWING': DrugFormDetails.chewable,
  'EFF': DrugFormDetails.effervescent,
  'EFFERVESCENT': DrugFormDetails.effervescent,
  'ORODISPERSIBLE': DrugFormDetails.orodispersible,
  'ORO-DISPERSIBLE': DrugFormDetails.orodispersible,
  'ORODISPERSABLE': DrugFormDetails.orodispersible,
  'ODT': DrugFormDetails.orodispersible,
  'DISINTEGRATING': DrugFormDetails.orodispersible,
  'DISINTEG': DrugFormDetails.orodispersible,
  'ORALLY': DrugFormDetails.orodispersible,
  'DISCMELT': DrugFormDetails.orodispersible,
  'DISPERSIBLE': DrugFormDetails.dispersible,
  'DISPERSABLE': DrugFormDetails.dispersible,
  'DISP': DrugFormDetails.dispersible,
  'SUBLINGUAL': DrugFormDetails.sublingual,
  'SCORED': DrugFormDetails.scored,
  'BISCORED': DrugFormDetails.scored,
  'DIVIDABLE': DrugFormDetails.scored,
  'BREAKABLE': DrugFormDetails.scored,
  'S.G': DrugFormDetails.softGel,
  'SOFT': DrugFormDetails.softGel,
  'SOFTGEL': DrugFormDetails.softGel,
  'H.G': DrugFormDetails.hardGelatin,
  'HARD': DrugFormDetails.hardGelatin,
  'GELATIN': DrugFormDetails.hardGelatin,
  'VAG': DrugFormDetails.vaginal,
  'VAGINAL': DrugFormDetails.vaginal,
  'RECTAL': DrugFormDetails.rectal,
  'PED': DrugFormDetails.paediatric,
  'PAED': DrugFormDetails.paediatric,
  'PEDIATRIC': DrugFormDetails.paediatric,
  'INFANTILE': DrugFormDetails.paediatric,
  'KIDS': DrugFormDetails.paediatric,
  'I.V': DrugFormDetails.intravenous,
  'IV': DrugFormDetails.intravenous,
  'I.M': DrugFormDetails.intramuscular,
  'IM': DrugFormDetails.intramuscular,
  'S.C': DrugFormDetails.sugarCoated,
  'SUBCUTANEOUS': DrugFormDetails.subcutaneous,
  'TRANSDERMAL': DrugFormDetails.transdermal,
  'TRASDERMAL': DrugFormDetails.transdermal,
};

const _unitWords =
    r'(?:MG|MCG|GM|G|ML|L|IU|I\.U|M\.I\.U|MIU|UNITS?|MMOL|MEQ|BILLION|KG|CM|MM|%)\b';

/// Up to five words between a count and its form, never a unit.
const _detailWords = '(?:(?!$_unitWords)[A-Z][A-Z.\\-/]*\\.?\\s*){0,5}?';

final _strengthRx = RegExp(
  '($_num(?:\\s*/\\s*$_num)*)\\s*'
  r'(MG|MCG|µG|GM|G|I\.?U\.?|M\.?I\.?U\.?|IU|%|MMOL|MEQ|UNITS?)'
  // A second ingredient: "1GM/125MG".
  '(?:\\s*/\\s*($_num)\\s*(MG|MCG|GM|G|IU)\\b)?'
  // Per volume or dose: "250MG/5ML", "100 MCG/DOSE".
  '(?:\\s*/\\s*($_num)?\\s*(ML|GM|G|DOSE|ACTUATION|SPRAY|L)\\b)?'
  r'(?![A-Z])',
);

final _countRx = RegExp(
  '(?<![\\d./A-Z\\-])($_num)(?!\\s*$_unitWords)\\s*($_detailWords)'
  '($_countFormRx)(?![A-Z])',
);

final _stripsRx = RegExp(
  '\\b($_num)\\s*STRIPS?\\s*X\\s*($_num)\\s*$_detailWords(?:$_countFormRx)',
);
final _gridRx = RegExp(
  '\\b($_num)\\s*X\\s*($_num)\\s*$_detailWords(?:$_countFormRx)',
);
final _perStripRx = RegExp(
  '\\b($_num)\\s*$_detailWords(?:$_countFormRx)\\.?\\s*X\\s*($_num)\\s*STRIPS?',
);
final _timesVolumeRx = RegExp('\\b($_num)\\s*[*X]\\s*($_num)\\s*(ML|GM|G)\\b');
final _singleRx = RegExp(
  r'\b(VIAL|AMP(?:OULE)?|PRE-?FILLED\s*SYRINGE|PEN)\b\.?(?!\s*X)',
);
final _sizeRx = RegExp(
  '(?<![/\\d.,])($_num)\\s*(ML|LITRE|LITER|L|GM|G|KG)\\b(?!\\s*/)',
);
final _flagRx = <String, RegExp>{
  DrugFlags.cancelled: RegExp(r'CANCELL?ED'),
  DrugFlags.illegalImport: RegExp(r'ILLEGAL\s*IMPORT'),
  DrugFlags.notAvailable: RegExp(r'\(N/?A(?:\s*YET)?\)'),
  DrugFlags.hospitalOnly: RegExp(r'\(HOSPITALS?\b|HOSPITALS?\s*ONLY'),
};
final _notesRx =
    RegExp(r'\((?:N/?A(?:\s*YET)?|CANCELL?ED|ILLEGAL\s*IMPORT|NET\s*PRICE)\)');

/// "50.000" (thousands) → 50000, "0.5" → 0.5, "1,5" → 1.5.
double _number(String text) {
  if (RegExp(r'^\d{1,3}(?:\.\d{3})+$').hasMatch(text)) {
    return double.parse(text.replaceAll('.', ''));
  }
  return double.parse(text.replaceAll(',', '.'));
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    final whole = value.round();
    // 50000 → 50,000 for readability.
    return whole >= 10000
        ? whole.toString().replaceAllMapped(
              RegExp(r'\B(?=(\d{3})+$)'),
              (_) => ',',
            )
        : '$whole';
  }
  return value.toString();
}

String _normalUnit(String unit) {
  final u = unit.replaceAll('.', '');
  return switch (u) {
    'MG' => 'mg',
    'MCG' || 'µG' => 'mcg',
    'GM' || 'G' => 'g',
    'IU' => 'IU',
    'MIU' => 'MIU',
    'ML' => 'ml',
    'L' => 'L',
    'MMOL' => 'mmol',
    'MEQ' => 'mEq',
    'UNIT' || 'UNITS' => 'units',
    'DOSE' => 'dose',
    'ACTUATION' => 'actuation',
    'SPRAY' => 'spray',
    _ => u.toLowerCase(),
  };
}

String _strengthText(RegExpMatch m) {
  final values = m
      .group(1)!
      .split('/')
      .map((v) => _formatNumber(_number(v.trim())))
      .join('/');
  final unit = _normalUnit(m.group(2)!);
  var base = unit == '%' ? '$values%' : '$values $unit';
  if (m.group(3) case final second?) {
    base =
        '$base/${_formatNumber(_number(second))} ${_normalUnit(m.group(4)!)}';
  }
  final per = m.group(6);
  if (per == null) return base;
  final perAmount = m.group(5);
  return '$base/${perAmount == null ? '' : '${_formatNumber(_number(perAmount))} '}'
      '${_normalUnit(per)}';
}

/// "CONCOR PLUS" → "Concor Plus"; keeps short or dotted tokens ("B.C.G.",
/// "XR", "D3") as written.
String catalogTitleCase(String text) =>
    text.trim().split(RegExp(r'\s+')).map((word) {
      if (word.isEmpty) return word;
      final letters = word.replaceAll(RegExp(r'[^A-Za-z]'), '');
      if (letters.length <= 2 ||
          word.contains('.') ||
          RegExp(r'\d').hasMatch(word)) {
        return word;
      }
      return word.toLowerCase().replaceAllMapped(RegExp(r'(^|[-(/+&])([a-z])'),
          (m) => '${m.group(1)}${m.group(2)!.toUpperCase()}');
    }).join(' ');

String? _routeFor(String? csvRoute, String? form, List<String> details) {
  switch (form) {
    case DrugForms.eyeDrops:
      return DrugRoutes.eye;
    case DrugForms.earDrops:
      return DrugRoutes.ear;
    case DrugForms.nasalSpray:
      return DrugRoutes.nasal;
    case DrugForms.inhaler:
      return DrugRoutes.inhalation;
    case DrugForms.ampoule ||
          DrugForms.vial ||
          DrugForms.syringe ||
          DrugForms.pen ||
          DrugForms.infusion ||
          DrugForms.injection:
      if (csvRoute == 'INJECTION' || csvRoute == null || csvRoute.isEmpty) {
        return DrugRoutes.injection;
      }
  }
  if (details.contains(DrugFormDetails.vaginal)) return DrugRoutes.vaginal;
  if (details.contains(DrugFormDetails.rectal)) return DrugRoutes.rectal;
  return switch (csvRoute?.toUpperCase()) {
    'ORAL.SOLID' || 'ORAL.LIQUID' || 'EFF' => DrugRoutes.oral,
    'TOPICAL' || 'SOAP' || 'SPRAY' => DrugRoutes.topical,
    'INJECTION' => DrugRoutes.injection,
    'EYE' => DrugRoutes.eye,
    'EAR' => DrugRoutes.ear,
    'MOUTH' => DrugRoutes.mouth,
    'VAGINAL' => DrugRoutes.vaginal,
    'RECTAL' => DrugRoutes.rectal,
    _ => null,
  };
}

/// The app's dose unit for a catalog form.
String? doseUnitForForm(String? form, {String? route}) => switch (form) {
      DrugForms.tablet => 'tablet',
      DrugForms.capsule => 'capsule',
      DrugForms.sachet => 'sachet',
      DrugForms.suppository => 'suppository',
      DrugForms.patch => 'patch',
      DrugForms.ampoule ||
      DrugForms.vial ||
      DrugForms.syringe ||
      DrugForms.pen ||
      DrugForms.injection =>
        route == DrugRoutes.oral ? 'unit' : 'injection',
      DrugForms.syrup ||
      DrugForms.suspension ||
      DrugForms.solution ||
      DrugForms.emulsion ||
      DrugForms.infusion ||
      DrugForms.mouthwash =>
        'ml',
      DrugForms.drops || DrugForms.eyeDrops || DrugForms.earDrops => 'drop',
      DrugForms.nasalSpray || DrugForms.inhaler => 'puff',
      DrugForms.cream ||
      DrugForms.ointment ||
      DrugForms.gel ||
      DrugForms.lotion ||
      DrugForms.shampoo ||
      DrugForms.spray ||
      DrugForms.oil ||
      DrugForms.soap =>
        'application',
      DrugForms.lozenge ||
      DrugForms.film ||
      DrugForms.piece ||
      DrugForms.teaBag =>
        'unit',
      DrugForms.powder => route == DrugRoutes.injection ? 'injection' : 'unit',
      _ => null,
    };

/// Extracts what it can from a catalog name. [route] is the CSV `route`
/// column (e.g. `ORAL.SOLID`), used as a fallback.
CatalogDrugFacts parseCatalogName(String name, {String? route}) {
  final upper = ' ${name.toUpperCase().replaceAll(RegExp(r'\s+'), ' ')} ';
  final flags = {
    for (final entry in _flagRx.entries)
      if (entry.value.hasMatch(upper)) entry.key,
  };
  final clean = upper.replaceAll(_notesRx, ' ');

  // Strength.
  final strengthMatch = _strengthRx.firstMatch(clean);
  String? strength =
      strengthMatch == null ? null : _strengthText(strengthMatch);

  // Count and form.
  String? form;
  final details = <String>[];
  int? packCount;
  int? stripCount;
  int? unitsPerStrip;
  final counts = _countRx.allMatches(clean).toList();
  if (counts.isNotEmpty) {
    final c = counts.last;
    packCount = _number(c.group(1)!).round();
    final formText = c.group(3)!.trim();
    for (final (rx, code) in _countForms) {
      if (RegExp('^(?:$rx)\\.?\$').hasMatch(formText)) {
        form = code;
        break;
      }
    }
    for (final word in c.group(2)!.trim().split(RegExp(r'\s+'))) {
      final key = word.replaceAll(RegExp(r'\.+$'), '');
      for (final part in [key, ...key.split('.')]) {
        final detail = _details[part];
        if (detail != null) {
          if (!details.contains(detail)) details.add(detail);
          break;
        }
      }
    }
    if (RegExp(r'^F\.?\s?C').hasMatch(formText) &&
        !details.contains(DrugFormDetails.filmCoated)) {
      details.insert(0, DrugFormDetails.filmCoated);
    }
    if (RegExp(r'^S\.?G|^SOFT').hasMatch(formText) &&
        !details.contains(DrugFormDetails.softGel)) {
      details.add(DrugFormDetails.softGel);
    }
    if (RegExp(r'^HGC').hasMatch(formText)) {
      details.add(DrugFormDetails.hardGelatin);
    }
    if (formText.startsWith('ODT')) {
      details.add(DrugFormDetails.orodispersible);
    }
    final strips = _stripsRx.firstMatch(clean) ?? _gridRx.firstMatch(clean);
    final perStrip = _perStripRx.firstMatch(clean);
    if (strips != null) {
      stripCount = _number(strips.group(1)!).round();
      unitsPerStrip = _number(strips.group(2)!).round();
    } else if (perStrip != null) {
      stripCount = _number(perStrip.group(2)!).round();
      unitsPerStrip = _number(perStrip.group(1)!).round();
    }
    if (stripCount != null && unitsPerStrip != null) {
      packCount = stripCount * unitsPerStrip;
    }
  } else if (_timesVolumeRx.firstMatch(clean) case final times?) {
    // "10 AMP. X 25 ML", "30 X 0.4 ML".
    packCount = _number(times.group(1)!).round();
    for (final (rx, code) in _countForms) {
      if (RegExp('\\b(?:$rx)').hasMatch(clean)) {
        form = code;
        break;
      }
    }
  } else if (_singleRx.firstMatch(clean) case final single?) {
    packCount = 1;
    final word = single.group(1)!;
    form = word == 'VIAL'
        ? DrugForms.vial
        : word == 'PEN'
            ? DrugForms.pen
            : word.contains('SYRINGE')
                ? DrugForms.syringe
                : DrugForms.ampoule;
  }

  // Injectables: "S.C." is subcutaneous there, not sugar-coated.
  if (const {
    DrugForms.ampoule,
    DrugForms.vial,
    DrugForms.syringe,
    DrugForms.pen,
  }.contains(form)) {
    for (var i = 0; i < details.length; i++) {
      if (details[i] == DrugFormDetails.sugarCoated) {
        details[i] = DrugFormDetails.subcutaneous;
      }
    }
    if (RegExp(r'\bI\.?V\b').hasMatch(clean) &&
        !details.contains(DrugFormDetails.intravenous)) {
      details.add(DrugFormDetails.intravenous);
    }
    if (RegExp(r'\bI\.?M\b').hasMatch(clean) &&
        !details.contains(DrugFormDetails.intramuscular)) {
      details.add(DrugFormDetails.intramuscular);
    }
  }
  if (RegExp(r'\bEFF(?:\.|ERVESCENT)').hasMatch(clean) &&
      !details.contains(DrugFormDetails.effervescent)) {
    details.add(DrugFormDetails.effervescent);
  }

  // Liquids and semi-solids: form from keywords.
  if (form == null || !DrugForms.countable.contains(form)) {
    for (final (rx, code) in _bulkForms) {
      if (RegExp(rx).hasMatch(clean)) {
        // Counted doses ("200 DOSES") keep the inhaler form.
        form ??= code;
        if (form == DrugForms.inhaler && code != DrugForms.inhaler) break;
        form = code;
        break;
      }
    }
  }

  // Bottle, tube or vial size.
  double? contentAmount;
  String? contentUnit;
  final countableSolid = DrugForms.countable.contains(form) &&
      form != DrugForms.vial &&
      form != DrugForms.ampoule &&
      form != DrugForms.syringe;
  if (!countableSolid) {
    final sizes = _sizeRx.allMatches(clean).toList();
    if (sizes.isNotEmpty) {
      final size = sizes.last;
      var amount = _number(size.group(1)!);
      final unit = size.group(2)!;
      contentUnit = switch (unit) {
        'ML' => 'ml',
        'LITRE' || 'LITER' || 'L' => 'ml',
        _ => 'g',
      };
      if (unit == 'LITRE' || unit == 'LITER' || unit == 'L') amount *= 1000;
      if (unit == 'KG') amount *= 1000;
      contentAmount = amount;
      // "CREAM 30 GM": that weight is the tube, not a strength. A vial's
      // "1.2G" is its strength.
      final measuredForm = !const {
        DrugForms.vial,
        DrugForms.ampoule,
        DrugForms.syringe,
        DrugForms.injection,
        DrugForms.infusion,
      }.contains(form);
      if (strengthMatch != null &&
          measuredForm &&
          contentUnit == 'g' &&
          strengthMatch.group(0)!.replaceAll(' ', '') ==
              size.group(0)!.replaceAll(' ', '')) {
        strength = null;
      }
      // Grams on an injectable are the dose, not a volume to measure.
      if (!measuredForm && contentUnit == 'g') {
        contentAmount = null;
        contentUnit = null;
      }
    }
  }

  // Brand: the text before the first number, strength or note.
  final body = upper.substring(1);
  final cut = RegExp('\\s(?:\\d|\\()')
      .allMatches(body)
      .where((m) => RegExp('[A-Z]').hasMatch(body.substring(0, m.start)))
      .firstOrNull;
  var brand = (cut == null ? body : body.substring(0, cut.start)).trim();
  brand = brand.replaceAll(RegExp(r'[\s\-.]+$'), '');
  // "SANSOVIT PLUS SYRUP" → "SANSOVIT PLUS": the form is shown separately.
  final trailingForm = RegExp(
    r'\s+(?:SYRUP|SYR|SUSP|SUSPENSION|CREAM|OINT|OINTMENT|GEL|LOTION|'
    r'SPRAY|DROPS?|EYE|EAR|NASAL|ORAL|TOPICAL|TOP|VIAL|AMP|INJ|'
    r'SHAMPOO|POWDER|EMULGEL|SOLUTION|SOLN?|SACHETS?|TABS?|CAPS?|'
    r'EFF|GR|GRAN|GRANULES|DRY|PD|FOR)\.?$',
  );
  while (trailingForm.hasMatch(brand)) {
    final shorter = brand.replaceFirst(trailingForm, '');
    if (shorter.trim().isEmpty) break;
    brand = shorter;
  }
  if (brand.isEmpty) brand = name.trim();

  final routeCode = _routeFor(route, form, details);
  return CatalogDrugFacts(
    brand: catalogTitleCase(brand),
    strength: strength,
    form: form,
    formDetails: details,
    doseUnit: doseUnitForForm(form, route: routeCode),
    packCount: packCount,
    stripCount: stripCount,
    unitsPerStrip: unitsPerStrip,
    contentAmount: contentAmount,
    contentUnit: contentUnit,
    route: routeCode,
    flags: flags,
  );
}
