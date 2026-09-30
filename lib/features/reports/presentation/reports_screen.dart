import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../app/widgets/file_actions.dart';
import '../../schedules/presentation/schedule_describer.dart';
import '../application/pdf_report_service.dart';
import '../domain/report_models.dart';

enum _Period { all, days7, days30, days90 }

/// Summary and detailed doctor reports, in-app and as PDF (spec §31).
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportLevel _level = ReportLevel.summary;
  _Period _period = _Period.all;
  Future<DoctorReport>? _report;
  bool? _hasArabicFont;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh(rebuild: false);
    ref.read(pdfReportServiceProvider).hasArabicFont().then((value) {
      if (mounted) setState(() => _hasArabicFont = value);
    });
  }

  void _refresh({bool rebuild = true}) {
    final patientId = ref.read(currentPatientIdProvider);
    if (patientId == null) return;
    final l10n = context.l10n;
    final now = DateTime.now().toUtc();
    final from = switch (_period) {
      _Period.all => null,
      _Period.days7 => now.subtract(const Duration(days: 7)),
      _Period.days30 => now.subtract(const Duration(days: 30)),
      _Period.days90 => now.subtract(const Duration(days: 90)),
    };
    _report = ref.read(reportServiceProvider).doctorReport(
          patientId: patientId,
          level: _level,
          arabic: context.isArabic,
          from: from,
          to: from == null ? null : now,
          describeSchedule: (s, m, meal) => describeSchedule(s, m, meal, l10n),
        );
    if (rebuild) setState(() {});
  }

  Future<void> _exportPdf(DoctorReport report) async {
    final l10n = context.l10n;
    try {
      final bytes =
          await ref.read(pdfReportServiceProvider).doctorReport(report, l10n);
      if (!mounted) return;
      await saveOrShareFile(
        context,
        bytes: bytes,
        fileName:
            'belmiad_${_level == ReportLevel.summary ? 'summary' : 'detailed'}_report.pdf',
        mimeType: 'application/pdf',
      );
    } catch (error) {
      if (mounted) showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final time = ref.watch(patientTimeProvider);
    ref.listen(currentPatientIdProvider, (_, __) => _refresh());
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(l10n.reports),
        actions: [
          IconButton(
            tooltip: l10n.storageReport,
            icon: const Icon(Icons.inventory_outlined),
            onPressed: () => context.push('/inventory/report'),
          ),
        ],
      ),
      body: ReadableWidth(
          child: FutureBuilder<DoctorReport>(
        future: _report,
        builder: (context, snapshot) {
          final report = snapshot.data;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              SegmentedButton<ReportLevel>(
                segments: [
                  ButtonSegment(
                    value: ReportLevel.summary,
                    label: Text(l10n.summaryReport),
                  ),
                  ButtonSegment(
                    value: ReportLevel.detailed,
                    label: Text(l10n.detailedReport),
                  ),
                ],
                selected: {_level},
                onSelectionChanged: (v) {
                  _level = v.first;
                  _refresh();
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  for (final (p, label) in [
                    (_Period.all, l10n.periodAll),
                    (_Period.days7, l10n.period7),
                    (_Period.days30, l10n.period30),
                    (_Period.days90, l10n.period90),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: _period == p,
                      onSelected: (_) {
                        _period = p;
                        _refresh();
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: report == null ? null : () => _exportPdf(report),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: Text(l10n.exportPdf),
              ),
              if (_hasArabicFont == false && context.isArabic)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.pdfArabicFontMissing,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (snapshot.hasError)
                Text(errorMessage(snapshot.error!, l10n))
              else if (report != null)
                ..._preview(context, report, time.toLocal),
            ],
          );
        },
      )),
    );
  }

  List<Widget> _preview(
    BuildContext context,
    DoctorReport report,
    DateTime Function(DateTime) local,
  ) {
    final l10n = context.l10n;
    return [
      SectionHeader(l10n.patientSection),
      ListTile(
        title: Text(report.patientName),
        subtitle: Text([
          if (report.patient.dateOfBirth != null)
            '${l10n.dateOfBirth}: ${formatIsoDate(context, report.patient.dateOfBirth)}',
          if (report.patient.bloodType != null)
            '${l10n.bloodType}: ${report.patient.bloodType}',
          l10n.reportGeneratedOn(
              formatDateTime(context, local(report.generatedAt))),
        ].join('\n')),
      ),
      SectionHeader(l10n.overallAdherence),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(adherenceLine(report.overall, l10n)),
        ),
      ),
      SectionHeader(l10n.medicationsSection),
      if (report.medications.isEmpty) Text(l10n.noData),
      for (final m in report.medications)
        Card(
          child: ListTile(
            title: Text(m.displayName),
            subtitle: Text([
              ...m.scheduleLines,
              if (m.instructions != null) m.instructions!,
              adherenceLine(m.adherence, l10n),
            ].join('\n')),
          ),
        ),
      if (report.illnesses.isNotEmpty) ...[
        SectionHeader(l10n.illnessesSection),
        for (final i in report.illnesses)
          ListTile(
            dense: true,
            title: Text(i.conditionName),
            subtitle: i.diagnosedDate == null
                ? null
                : Text(formatIsoDate(context, i.diagnosedDate)),
          ),
      ],
      if (report.dietaryRules.isNotEmpty) ...[
        SectionHeader(l10n.dietSection),
        for (final d in report.dietaryRules)
          ListTile(
            dense: true,
            title: Text(context.isArabic
                ? (d.foodItemAr ?? d.foodItemEn)
                : d.foodItemEn),
            trailing: Text(dietRuleLabel(d.ruleType, l10n)),
          ),
      ],
      SectionHeader(l10n.vitalsSection),
      if (report.vitals.isEmpty) Text(l10n.noData),
      for (final v in report.vitals)
        ListTile(
          dense: true,
          title: Text(vitalTypeLabel(v.measurementType, l10n)),
          subtitle: Text([
            formatDateTime(context, local(v.measuredAt)),
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
          ].join('\n')),
          trailing: Text(vitalValueText(v)),
        ),
      SectionHeader(l10n.appointmentsSection),
      if (report.appointments.isEmpty) Text(l10n.noData),
      for (final a in report.appointments)
        ListTile(
          dense: true,
          title: Text(a.doctorName),
          subtitle: Text(formatDateTime(context, local(a.scheduledTime))),
          trailing: Text(appointmentStatusLabel(a.status, l10n)),
        ),
      if (report.level == ReportLevel.detailed) ...[
        SectionHeader(l10n.doseHistorySection),
        if (report.doses.isEmpty) Text(l10n.noData),
        for (final d in report.doses)
          ListTile(
            dense: true,
            title: Text(d.medicationName),
            subtitle: Text(formatDateTime(context, local(d.scheduledAt))),
            trailing: Text(doseOutcomeText(d, l10n)),
          ),
      ],
    ];
  }
}
