import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Combines captured prescription pages into a single PDF, one image per
/// A4 page, entirely offline.
Future<Uint8List> imagesToPdf(List<Uint8List> pages) async {
  final doc = pw.Document();
  for (final bytes in pages) {
    final image = pw.MemoryImage(bytes);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );
  }
  return doc.save();
}

enum PrescriptionFileKind { image, pdf, other }

PrescriptionFileKind prescriptionFileKind(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.pdf')) return PrescriptionFileKind.pdf;
  if (RegExp(r'\.(jpe?g|png|heic|webp|gif|bmp)$').hasMatch(lower)) {
    return PrescriptionFileKind.image;
  }
  return PrescriptionFileKind.other;
}
