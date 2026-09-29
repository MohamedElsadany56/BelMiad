import 'dart:convert';

import 'package:belmiad/app/localization/labels.dart';
import 'package:belmiad/features/inventory/data/inventory_repository.dart';
import 'package:belmiad/features/reports/application/pdf_report_service.dart';
import 'package:belmiad/features/reports/application/report_service.dart';
import 'package:belmiad/features/reports/domain/report_models.dart';
import 'package:belmiad/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestHarness h;
  late String patientId;

  setUp(() async {
    h = TestHarness(now: DateTime.utc(2026, 9, 28, 6));
    await h.createCaregiver();
    patientId = await h.createPatient('Mother');
    final medicationId = await h.createMedication(patientId);
    await h.inventory.addBatch(BatchInput(
      medicationId: medicationId,
      quantityScaled: 3000,
      expirationDate: '2026-10-10',
    ));
  });

  tearDown(() => h.close());

  bool isPdf(List<int> bytes) =>
      bytes.length > 1000 && ascii.decode(bytes.take(5).toList()) == '%PDF-';

  for (final language in ['en', 'ar']) {
    test('doctor and storage PDFs render offline ($language)', () async {
      final l10n = lookupAppLocalizations(Locale(language));
      final service = ReportService(h.db, h.forecast, clock: h.clock);
      final pdf = PdfReportService();
      expect(await pdf.hasArabicFont(), isTrue);

      for (final level in ReportLevel.values) {
        final report = await service.doctorReport(
          patientId: patientId,
          level: level,
          arabic: language == 'ar',
          describeSchedule: (s, m, meal) => '',
        );
        expect(isPdf(await pdf.doctorReport(report, l10n)), isTrue);
      }

      final storage = await service.inventoryReport(
        patientId: patientId,
        arabic: language == 'ar',
      );
      final bytes = await pdf.inventoryReport(
        storage,
        l10n,
        timezone: 'Africa/Cairo',
        unitLabel: (code) => unitLabel(code, l10n),
      );
      expect(isPdf(bytes), isTrue);
    });
  }
}
