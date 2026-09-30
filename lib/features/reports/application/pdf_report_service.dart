import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/time/local_date.dart';
import '../../../core/time/patient_time.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../../l10n/app_localizations.dart';
import '../../inventory/domain/stock_forecast.dart';
import '../domain/report_models.dart';
import '../../../app/localization/labels.dart';

/// Renders doctor and storage reports as PDF, entirely offline.
///
/// Arabic output needs an Arabic-capable TTF bundled under `assets/fonts/`
/// (for example `NotoNaskhArabic-Regular.ttf`); it is loaded when present.
class PdfReportService {
  static const _fontCandidates = [
    'assets/fonts/NotoNaskhArabic-Regular.ttf',
    'assets/fonts/NotoSansArabic-Regular.ttf',
    'assets/fonts/Cairo-Regular.ttf',
    'assets/fonts/Amiri-Regular.ttf',
  ];
  static const _boldCandidates = [
    'assets/fonts/NotoNaskhArabic-Bold.ttf',
    'assets/fonts/NotoSansArabic-Bold.ttf',
    'assets/fonts/Cairo-Bold.ttf',
    'assets/fonts/Amiri-Bold.ttf',
  ];

  static const _brand = PdfColor.fromInt(0xFF0064F6);

  pw.Font? _regular;
  pw.Font? _bold;
  bool _fontsLoaded = false;

  /// Whether an Arabic-capable font is bundled.
  Future<bool> hasArabicFont() async {
    await _loadFonts();
    return _regular != null;
  }

  Future<void> _loadFonts() async {
    if (_fontsLoaded) return;
    _fontsLoaded = true;
    Future<pw.Font?> load(List<String> paths) async {
      for (final path in paths) {
        try {
          return pw.Font.ttf(await rootBundle.load(path));
        } catch (_) {}
      }
      return null;
    }

    _regular = await load(_fontCandidates);
    _bold = await load(_boldCandidates) ?? _regular;
  }

  Future<pw.ThemeData> _theme() async {
    await _loadFonts();
    final regular = _regular;
    if (regular == null) return pw.ThemeData.base();
    return pw.ThemeData.withFont(
      base: regular,
      bold: _bold ?? regular,
      fontFallback: [pw.Font.helvetica()],
    );
  }

  pw.Widget _header(String title, List<String> lines) => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 8),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _brand, width: 2)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: const pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: _brand,
              ),
            ),
            for (final line in lines)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2),
                child: pw.Text(line, style: const pw.TextStyle(fontSize: 10)),
              ),
          ],
        ),
      );

  pw.Widget _section(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
        child: pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _brand,
          ),
        ),
      );

  pw.Widget _table(List<String> headers, List<List<String>> rows) =>
      pw.TableHelper.fromTextArray(
        headers: headers,
        data: rows,
        headerStyle: const pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(color: _brand),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellAlignment: pw.Alignment.centerLeft,
        headerAlignment: pw.Alignment.centerLeft,
        oddRowDecoration:
            const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF1F6FF)),
        border: null,
      );

  Future<Uint8List> doctorReport(
    DoctorReport report,
    AppLocalizations l10n,
  ) async {
    await initializeDateFormatting(l10n.localeName);
    final arabic = l10n.localeName == 'ar';
    final time = PatientTime(report.patient.timezone);
    final dateTime = DateFormat.yMMMd(l10n.localeName).add_Hm();
    final date = DateFormat.yMMMd(l10n.localeName);
    String local(DateTime instant) => dateTime.format(time.toLocal(instant));
    final doc = pw.Document(theme: await _theme());
    final period = report.periodFrom == null
        ? l10n.reportPeriodAll
        : l10n.reportPeriodRange(
            date.format(time.toLocal(report.periodFrom!)),
            date.format(time.toLocal(report.periodTo ?? report.generatedAt)),
          );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: arabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _header(
            '${l10n.doctorReport} — ${report.level == ReportLevel.summary ? l10n.summaryReport : l10n.detailedReport}',
            [
              '${l10n.patientSection}: ${report.patientName}',
              if (report.patient.dateOfBirth != null)
                '${l10n.dateOfBirth}: ${report.patient.dateOfBirth}',
              if (report.patient.bloodType != null)
                '${l10n.bloodType}: ${report.patient.bloodType}',
              period,
              l10n.reportGeneratedOn(local(report.generatedAt)),
            ],
          ),
          _section(l10n.overallAdherence),
          pw.Text(adherenceLine(report.overall, l10n)),
          _section(l10n.medicationsSection),
          if (report.medications.isEmpty)
            pw.Text(l10n.noData)
          else
            _table(
              [l10n.medication, l10n.schedules, l10n.adherence],
              [
                for (final m in report.medications)
                  [
                    [
                      m.displayName,
                      if (m.medication.isPrn) l10n.prnBadge,
                      if (m.instructions != null) m.instructions!,
                    ].join('\n'),
                    m.scheduleLines.isEmpty ? '-' : m.scheduleLines.join('\n'),
                    adherenceLine(m.adherence, l10n),
                  ],
              ],
            ),
          if (report.illnesses.isNotEmpty) ...[
            _section(l10n.illnessesSection),
            _table(
              [l10n.condition, l10n.diagnosedDate, l10n.notes],
              [
                for (final i in report.illnesses)
                  [i.conditionName, i.diagnosedDate ?? '-', i.notes ?? ''],
              ],
            ),
          ],
          if (report.dietaryRules.isNotEmpty) ...[
            _section(l10n.dietSection),
            _table(
              [l10n.ruleType, l10n.foodItemEn, l10n.notes],
              [
                for (final d in report.dietaryRules)
                  [
                    dietRuleLabel(d.ruleType, l10n),
                    arabic ? (d.foodItemAr ?? d.foodItemEn) : d.foodItemEn,
                    d.notes ?? '',
                  ],
              ],
            ),
          ],
          _section(l10n.vitalsSection),
          if (report.vitals.isEmpty)
            pw.Text(l10n.noData)
          else
            _table(
              [l10n.vitalType, l10n.value, l10n.measuredAt],
              [
                for (final v in report.vitals)
                  [
                    [
                      vitalTypeLabel(v.measurementType, l10n),
                      if (vitalContextText(
                            v,
                            l10n,
                            mealNames: report.mealNames,
                            medicationNames: report.medicationNames,
                          ) !=
                          null)
                        vitalContextText(
                          v,
                          l10n,
                          mealNames: report.mealNames,
                          medicationNames: report.medicationNames,
                        )!,
                    ].join('\n'),
                    vitalValueText(v),
                    local(v.measuredAt),
                  ],
              ],
            ),
          _section(l10n.appointmentsSection),
          if (report.appointments.isEmpty)
            pw.Text(l10n.noData)
          else
            _table(
              [l10n.dateAndTime, l10n.doctor, l10n.specialty, l10n.status],
              [
                for (final a in report.appointments)
                  [
                    local(a.scheduledTime),
                    a.doctorName,
                    a.specialty ?? '',
                    appointmentStatusLabel(a.status, l10n),
                  ],
              ],
            ),
          if (report.level == ReportLevel.detailed) ...[
            _section(l10n.doseHistorySection),
            if (report.doses.isEmpty)
              pw.Text(l10n.noData)
            else
              _table(
                [
                  l10n.dateAndTime,
                  l10n.medication,
                  l10n.status,
                  l10n.quantity,
                ],
                [
                  for (final d in report.doses)
                    [
                      local(d.scheduledAt),
                      d.medicationName,
                      doseOutcomeText(d, l10n),
                      d.actualScaled == null
                          ? formatScaled(d.requiredScaled)
                          : '${formatScaled(d.actualScaled)} / ${formatScaled(d.requiredScaled)}',
                    ],
                ],
              ),
          ],
        ],
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${l10n.appTitle} · ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ),
      ),
    );
    return doc.save();
  }

  Future<Uint8List> inventoryReport(
    InventoryReport report,
    AppLocalizations l10n, {
    required String timezone,
    required String Function(String unitCode) unitLabel,
  }) async {
    await initializeDateFormatting(l10n.localeName);
    final arabic = l10n.localeName == 'ar';
    final time = PatientTime(timezone);
    final doc = pw.Document(theme: await _theme());
    final generated = DateFormat.yMMMd(l10n.localeName)
        .add_Hm()
        .format(time.toLocal(report.generatedAt));
    List<String> row(InventoryReportRow r) => [
          r.displayName,
          '${formatScaled(r.summary.usableScaled)} ${unitLabel(r.medication.doseUnit)}',
          '${r.batchCount}',
          r.summary.earliestExpiration?.toIso() ?? '-',
          remainingDaysText(r.summary, l10n),
          stockStateLabel(r.summary.state, l10n),
          r.summary.expiredScaled == 0
              ? '-'
              : formatScaled(r.summary.expiredScaled),
          [
            if (r.lastPurchaseDate != null) r.lastPurchaseDate!,
            if (r.lastPurchasePrice != null)
              r.lastPurchasePrice!.toStringAsFixed(2),
          ].join(' · '),
        ];
    final headers = [
      l10n.medication,
      l10n.currentQuantity,
      l10n.batchCount,
      l10n.earliestExpiration,
      l10n.remainingDays,
      l10n.stockState,
      l10n.expiredQuantity,
      l10n.lastPurchase,
    ];
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        textDirection: arabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          _header(l10n.inventoryReport, [
            '${l10n.patientSection}: ${report.patientName}',
            l10n.reportGeneratedOn(generated),
          ]),
          _section(l10n.whatToBuy),
          if (report.toPurchase.isEmpty)
            pw.Text(l10n.nothingToBuy)
          else
            _table(headers, [for (final r in report.toPurchase) row(r)]),
          _section(l10n.whatWeHave),
          if (report.rows.isEmpty)
            pw.Text(l10n.noData)
          else
            _table(headers, [for (final r in report.rows) row(r)]),
        ],
      ),
    );
    return doc.save();
  }
}

String adherenceLine(AdherenceStats stats, AppLocalizations l10n) {
  final percent = stats.adherencePercent;
  return [
    if (percent != null) '$percent%',
    '${l10n.takenOnTime}: ${stats.takenOnTime}',
    '${l10n.takenLate}: ${stats.takenLate}',
    '${l10n.missed}: ${stats.missed}',
    '${l10n.skipped}: ${stats.skipped}',
  ].join(' · ');
}

String doseOutcomeText(ReportDose dose, AppLocalizations l10n) {
  final text = dose.isPrn
      ? l10n.prnTaken
      : switch (dose.outcome) {
          DoseOutcome.takenOnTime => l10n.takenOnTime,
          DoseOutcome.takenLate =>
            '${l10n.takenLate} (${l10n.lateBy(dose.lateMinutes ?? 0)})',
          DoseOutcome.missed => l10n.missed,
          DoseOutcome.skipped => l10n.skipped,
          DoseOutcome.pending => l10n.pending,
        };
  return dose.recordedLater ? '$text · ${l10n.recordedLater}' : text;
}

String remainingDaysText(StockSummary summary, AppLocalizations l10n) {
  final days = summary.remainingDays;
  if (days == null) return l10n.noForecast;
  if (days == 0) return l10n.lessThanDay;
  if (days == 1) return l10n.dayRemaining;
  return l10n.daysRemaining(days >= 730 ? '730+' : '$days');
}

String formatLocalDate(String? iso, String localeName) {
  final date = LocalDate.tryParse(iso);
  if (date == null) return '-';
  return DateFormat.yMMMd(localeName).format(date.toDateTime());
}
