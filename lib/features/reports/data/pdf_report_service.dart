import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../domain/inventory_report.dart';

class PdfReportService {
  Future<Uint8List> buildInventoryReport({
    required String patientName,
    required InventoryReport report,
  }) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, child: pw.Text('BelMiad inventory report')),
          pw.Text('Patient: $patientName'),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: const ['Medicine', 'Quantity', 'Unit', 'Batches', 'State'],
            data: report.rows
                .map(
                  (row) => [
                    row.medication,
                    row.quantity.toString(),
                    row.unit,
                    row.batchCount.toString(),
                    row.stockState,
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Total units: ${report.totalUnits}'),
        ],
      ),
    );
    return document.save();
  }
}
