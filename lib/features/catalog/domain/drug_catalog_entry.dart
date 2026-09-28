class DrugCatalogEntry {
  const DrugCatalogEntry({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.priceEgp,
  });
  final String id;
  final String nameEn;
  final String nameAr;
  final double priceEgp;
}

String normalizeDrugSearch(String value) => value
    .toLowerCase()
    .trim()
    .replaceAll(RegExp(r'ـ'), '')
    .replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '')
    .replaceAll('أ', 'ا')
    .replaceAll('إ', 'ا')
    .replaceAll('آ', 'ا')
    .replaceAll('ى', 'ي');

