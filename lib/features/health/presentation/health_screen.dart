import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/time/local_date.dart';
import '../../medications/data/medication_repository.dart';
import '../../medications/presentation/medication_detail_screen.dart';
import '../../medications/presentation/medications_screen.dart';
import '../application/prescription_documents.dart';
import '../domain/prescription_grouping.dart';
import 'health_forms.dart';

final appointmentsProvider = StreamProvider.family<List<Appointment>, String>(
  (ref, id) => ref.watch(appointmentRepositoryProvider).watchForPatient(id),
);
final vitalsProvider = StreamProvider.family<List<VitalMeasurement>, String>(
  (ref, id) => ref.watch(vitalsRepositoryProvider).watchForPatient(id),
);
final illnessesProvider = StreamProvider.family<List<Illness>, String>(
  (ref, id) => ref.watch(illnessRepositoryProvider).watchForPatient(id),
);
final dietRulesProvider = StreamProvider.family<List<DietaryRule>, String>(
  (ref, id) => ref.watch(dietaryRuleRepositoryProvider).watchForPatient(id),
);
final prescriptionsProvider = StreamProvider.family<List<Prescription>, String>(
  (ref, id) => ref.watch(prescriptionRepositoryProvider).watchForPatient(id),
);

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({this.initialTab = 0, super.key});

  final int initialTab;

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: 5,
    vsync: this,
    initialIndex: widget.initialTab.clamp(0, 4),
  );

  @override
  void initState() {
    super.initState();
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    final addLabels = [
      l10n.addAppointment,
      l10n.addVital,
      l10n.addIllness,
      l10n.addDietRule,
      l10n.addPrescription,
    ];
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(l10n.health),
        actions: const [PatientSwitcher()],
        bottom: AppTabBar(
          controller: _tabs,
          tabs: [
            (Icons.event_outlined, l10n.appointments),
            (Icons.monitor_heart_outlined, l10n.vitals),
            (Icons.healing_outlined, l10n.illnesses),
            (Icons.no_food_outlined, l10n.dietaryRules),
            (Icons.description_outlined, l10n.prescriptions),
          ],
        ),
      ),
      floatingActionButton: patientId == null
          ? null
          : FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => openHealthForm(context, _tabs.index, patientId),
              icon: const Icon(Icons.add),
              label: Text(addLabels[_tabs.index]),
            ),
      body: ReadableWidth(
          child: RequirePatient(
        builder: (id) => TabBarView(
          controller: _tabs,
          children: [
            _AppointmentsTab(patientId: id),
            _VitalsTab(patientId: id),
            _IllnessesTab(patientId: id),
            _DietTab(patientId: id),
            _PrescriptionsTab(patientId: id),
          ],
        ),
      )),
    );
  }
}

class _RecordList<T> extends StatelessWidget {
  const _RecordList({
    required this.value,
    required this.tile,
    this.header,
  });

  final AsyncValue<List<T>> value;
  final Widget Function(T item) tile;
  final Widget? header;

  @override
  Widget build(BuildContext context) => AsyncBody(
        value: value,
        builder: (items) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (header != null) header!,
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: EmptyState(
                  icon: Icons.folder_open_outlined,
                  message: context.l10n.noRecords,
                ),
              ),
            for (final item in items) tile(item),
          ],
        ),
      );
}

class _AppointmentsTab extends ConsumerWidget {
  const _AppointmentsTab({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(patientTimeProvider);
    return _RecordList<Appointment>(
      value: ref.watch(appointmentsProvider(patientId)),
      tile: (a) => Card(
        child: ListTile(
          leading: const Icon(Icons.event_note_outlined),
          title: Text(a.doctorName),
          subtitle: Text([
            formatDateTime(context, time.toLocal(a.scheduledTime)),
            if (a.specialty != null) a.specialty!,
            if (a.location != null) a.location!,
            if (a.notes != null) a.notes!,
          ].join('\n')),
          isThreeLine: true,
          trailing: StatusBadge(
            appointmentStatusLabel(a.status, context.l10n),
            tone: switch (a.status) {
              'completed' => BadgeTone.success,
              'cancelled' => BadgeTone.neutral,
              _ => BadgeTone.brand,
            },
          ),
          onTap: () => showAppointmentForm(context, patientId, a),
        ),
      ),
    );
  }
}

class _VitalsTab extends ConsumerWidget {
  const _VitalsTab({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(patientTimeProvider);
    final l10n = context.l10n;
    final mealNames = {
      for (final m in ref.watch(patientMealsProvider(patientId)).valueOrNull ??
          const <Meal>[])
        m.mealId: mealName(m, l10n),
    };
    final medicationNames = {
      for (final m
          in ref.watch(patientMedicationsProvider(patientId)).valueOrNull ??
              const <Medication>[])
        m.medicationId: medicationDisplayName(m, arabic: context.isArabic),
    };
    return _RecordList<VitalMeasurement>(
      value: ref.watch(vitalsProvider(patientId)),
      tile: (v) => Card(
        child: ListTile(
          leading: const Icon(Icons.monitor_heart_outlined),
          title: Text(vitalTypeLabel(v.measurementType, l10n)),
          subtitle: Text([
            formatDateTime(context, time.toLocal(v.measuredAt)),
            if (vitalContextText(
                  v,
                  l10n,
                  mealNames: mealNames,
                  medicationNames: medicationNames,
                ) !=
                null)
              vitalContextText(
                v,
                l10n,
                mealNames: mealNames,
                medicationNames: medicationNames,
              )!,
            if (v.notes != null) v.notes!,
          ].join('\n')),
          trailing: Text(
            vitalValueText(v),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onTap: () => showVitalForm(context, patientId, v),
        ),
      ),
    );
  }
}

class _IllnessesTab extends ConsumerWidget {
  const _IllnessesTab({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _RecordList<Illness>(
        value: ref.watch(illnessesProvider(patientId)),
        tile: (i) => Card(
          child: ListTile(
            leading: const Icon(Icons.healing_outlined),
            title: Text(i.conditionName),
            subtitle: Text([
              if (i.diagnosedDate != null)
                '${context.l10n.diagnosedDate}: ${formatIsoDate(context, i.diagnosedDate)}',
              if (i.notes != null) i.notes!,
            ].join('\n')),
            onTap: () => showIllnessForm(context, patientId, i),
          ),
        ),
      );
}

class _DietTab extends ConsumerWidget {
  const _DietTab({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return _RecordList<DietaryRule>(
      value: ref.watch(dietRulesProvider(patientId)),
      header: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(l10n.dietNoInferenceNote,
            style: Theme.of(context).textTheme.bodySmall),
      ),
      tile: (d) => Card(
        child: ListTile(
          leading: const Icon(Icons.restaurant_menu_outlined),
          title: Text(
            context.isArabic ? (d.foodItemAr ?? d.foodItemEn) : d.foodItemEn,
          ),
          subtitle: d.notes == null ? null : Text(d.notes!),
          trailing: StatusBadge(
            dietRuleLabel(d.ruleType, l10n),
            tone: d.ruleType == 'avoid' ? BadgeTone.danger : BadgeTone.brand,
          ),
          onTap: () => showDietRuleForm(context, patientId, d),
        ),
      ),
    );
  }
}

enum _RxGrouping { doctor, date, fileType }

final _rxGroupingProvider =
    StateProvider<_RxGrouping>((ref) => _RxGrouping.date);

/// Prescriptions categorised by doctor, by date (month) or by file type.
class _PrescriptionsTab extends ConsumerWidget {
  const _PrescriptionsTab({required this.patientId});

  final String patientId;

  /// Headers sit on the same edge as the cards below them (the list already
  /// has its own side padding).
  static const _headerPadding = EdgeInsetsDirectional.fromSTEB(0, 20, 0, 8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final grouping = ref.watch(_rxGroupingProvider);
    return AsyncBody(
      value: ref.watch(prescriptionsProvider(patientId)),
      builder: (items) {
        final groups = _groups(context, items, grouping);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            Text(
              l10n.prescriptionsPrivateNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            // Chips wrap onto a second line instead of clipping their text
            // in Arabic or at large font sizes.
            Text(
              l10n.groupBy,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (value, label) in [
                  (_RxGrouping.date, l10n.groupDate),
                  (_RxGrouping.doctor, l10n.groupDoctor),
                  (_RxGrouping.fileType, l10n.groupFileType),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: grouping == value,
                    onSelected: (_) =>
                        ref.read(_rxGroupingProvider.notifier).state = value,
                  ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: EmptyState(
                  icon: Icons.folder_open_outlined,
                  message: l10n.noRecords,
                ),
              ),
            for (final group in groups) ...[
              SectionHeader(
                group.label,
                padding: _headerPadding,
                trailing: StatusBadge('${group.items.length}'),
              ),
              for (final p in group.items)
                Card(
                  child: ListTile(
                    leading: Icon(
                      prescriptionFileKind(p.filePath) ==
                              PrescriptionFileKind.pdf
                          ? Icons.picture_as_pdf_outlined
                          : Icons.image_outlined,
                    ),
                    title: Text(p.doctorName ?? l10n.prescriptions),
                    subtitle: Text([
                      if (p.issueDate != null)
                        formatIsoDate(context, p.issueDate),
                      if (p.notes != null) p.notes!,
                    ].join('\n')),
                    onTap: () => showPrescriptionViewer(context, p),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  /// Labelled groups in display order. Dates are ordered by the real
  /// calendar month (never by the localized month name).
  List<({String label, List<Prescription> items})> _groups(
    BuildContext context,
    List<Prescription> items,
    _RxGrouping grouping,
  ) {
    final l10n = context.l10n;
    switch (grouping) {
      case _RxGrouping.date:
        final today = LocalDate.fromDateTime(DateTime.now());
        return [
          for (final group in groupByIssueMonth(items, (p) => p.issueDate))
            (
              label: group.month == null
                  ? l10n.noDate
                  : group.month!.year == today.year &&
                          group.month!.month == today.month
                      ? l10n.thisMonth
                      : DateFormat.yMMMM(context.localeName)
                          .format(group.month!.toDateTime()),
              items: group.items,
            ),
        ];
      case _RxGrouping.doctor:
        final byDoctor = <String, List<Prescription>>{};
        for (final p in _newestFirst(items)) {
          final name = p.doctorName?.trim() ?? '';
          byDoctor
              .putIfAbsent(name.isEmpty ? l10n.unknownDoctor : name, () => [])
              .add(p);
        }
        final names = byDoctor.keys.toList()..sort();
        return [for (final n in names) (label: n, items: byDoctor[n]!)];
      case _RxGrouping.fileType:
        final byKind = <PrescriptionFileKind, List<Prescription>>{};
        for (final p in _newestFirst(items)) {
          byKind.putIfAbsent(prescriptionFileKind(p.filePath), () => []).add(p);
        }
        return [
          for (final kind in PrescriptionFileKind.values)
            if (byKind[kind] != null)
              (
                label: switch (kind) {
                  PrescriptionFileKind.image => l10n.fileType_image,
                  PrescriptionFileKind.pdf => l10n.fileType_pdf,
                  PrescriptionFileKind.other => l10n.fileType_other,
                },
                items: byKind[kind]!,
              ),
        ];
    }
  }

  List<Prescription> _newestFirst(List<Prescription> items) => [...items]
    ..sort((a, b) => (b.issueDate ?? '').compareTo(a.issueDate ?? ''));
}
