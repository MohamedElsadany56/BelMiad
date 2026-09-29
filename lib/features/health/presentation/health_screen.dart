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
        title: Text(l10n.health),
        actions: const [PatientSwitcher()],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
                icon: const Icon(Icons.event_outlined),
                text: l10n.appointments),
            Tab(
                icon: const Icon(Icons.monitor_heart_outlined),
                text: l10n.vitals),
            Tab(icon: const Icon(Icons.healing_outlined), text: l10n.illnesses),
            Tab(
                icon: const Icon(Icons.no_food_outlined),
                text: l10n.dietaryRules),
            Tab(
                icon: const Icon(Icons.description_outlined),
                text: l10n.prescriptions),
          ],
        ),
      ),
      floatingActionButton: patientId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => openHealthForm(context, _tabs.index, patientId),
              icon: const Icon(Icons.add),
              label: Text(addLabels[_tabs.index]),
            ),
      body: RequirePatient(
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
      ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final grouping = ref.watch(_rxGroupingProvider);
    return AsyncBody(
      value: ref.watch(prescriptionsProvider(patientId)),
      builder: (items) {
        String keyOf(Prescription p) => switch (grouping) {
              _RxGrouping.doctor => (p.doctorName?.trim().isEmpty ?? true)
                  ? l10n.unknownDoctor
                  : p.doctorName!.trim(),
              _RxGrouping.date => p.issueDate == null
                  ? l10n.noDate
                  : DateFormat.yMMMM(context.localeName).format(
                      LocalDate.parse(p.issueDate!).toDateTime(),
                    ),
              _RxGrouping.fileType => switch (
                    prescriptionFileKind(p.filePath)) {
                  PrescriptionFileKind.image => l10n.fileType_image,
                  PrescriptionFileKind.pdf => l10n.fileType_pdf,
                  PrescriptionFileKind.other => l10n.fileType_other,
                },
            };
        final sorted = [...items]..sort(
            (a, b) => (b.issueDate ?? '').compareTo(a.issueDate ?? ''),
          );
        final groups = <String, List<Prescription>>{};
        for (final p in sorted) {
          groups.putIfAbsent(keyOf(p), () => []).add(p);
        }
        final keys = groups.keys.toList();
        if (grouping == _RxGrouping.doctor) keys.sort();
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            Text(
              l10n.prescriptionsPrivateNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(l10n.groupBy),
                const SizedBox(width: 8),
                Expanded(
                  child: SegmentedButton<_RxGrouping>(
                    segments: [
                      ButtonSegment(
                        value: _RxGrouping.doctor,
                        label: Text(l10n.groupDoctor),
                      ),
                      ButtonSegment(
                        value: _RxGrouping.date,
                        label: Text(l10n.groupDate),
                      ),
                      ButtonSegment(
                        value: _RxGrouping.fileType,
                        label: Text(l10n.groupFileType),
                      ),
                    ],
                    selected: {grouping},
                    onSelectionChanged: (v) =>
                        ref.read(_rxGroupingProvider.notifier).state = v.first,
                  ),
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
            for (final key in keys) ...[
              SectionHeader(
                key,
                trailing: StatusBadge('${groups[key]!.length}'),
              ),
              for (final p in groups[key]!)
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
}
