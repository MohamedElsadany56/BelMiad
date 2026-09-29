class InventoryReportRow {
  const InventoryReportRow({
    required this.medicationName,
    required this.quantity,
    required this.unit,
    required this.batchCount,
    this.earliestExpiration,
    required this.stockState,
  });
  final String medicationName;
  final int quantity;
  final String unit;
  final int batchCount;
  final DateTime? earliestExpiration;
  final String stockState;
}

class InventoryReport {
  const InventoryReport(this.rows);
  final List<InventoryReportRow> rows;
  int get totalUnits => rows.fold(0, (sum, row) => sum + row.quantity);
  List<InventoryReportRow> get lowStock =>
      rows.where((r) => r.stockState == 'LOW').toList();
}

