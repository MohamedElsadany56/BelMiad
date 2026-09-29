import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utilities/scaled_quantity.dart';
import '../../audit/data/audit_log.dart';
import '../../doses/data/dose_repository.dart';
import '../../doses/domain/dose_status.dart';
import '../../doses/presentation/take_dose_sheet.dart';
import '../../inventory/presentation/medication_stock_tab.dart';
import '../../schedules/presentation/schedule_describer.dart';
import '../data/medication_repository.dart';

final medicationProvider = StreamProvider.family<Medication?, String>(
  (ref, id) => ref.watch(medicationRepositoryProvider).watch(id),
);

final medicationSchedulesProvider =
    StreamProvider.family<List<MedicationSchedule>, String>(
  (ref, id) => ref.watch(scheduleRepositoryProvider).watchForMedication(id),
);

final patientMealsProvider = StreamProvider.family<List<Meal>, String>(
  (ref, patientId) =>
      ref.watch(mealRepositoryProvider).watchForPatient(patientId),
);

final _historyProvider = StreamProvider.family<List<DoseView>, String>(
  (ref, id) => ref.watch(doseRepositoryProvider).watchMedicationHistory(id),
);

class MedicationDetailScreen extends ConsumerWidget {
  const MedicationDetailScreen({
    required this.medicationId,
    this.initialTab = 0,
    super.key,
  });

  final String medicationId;
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final medication = ref.watch(medicationProvider(medicationId));
    return AsyncBody(
      value: medication,
      builder: (m) {
        if (m == null || m.deletedAt != null) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyState(
              icon: Icons.medication_outlined,
              message: l10n.error_notFound,
            ),
          );
        }
        return DefaultTabController(
          length: 4,
          initialIndex: initialTab.clamp(0, 3),
          child: Scaffold(
            appBar: AppBar(
              title: Text(medicationDisplayName(m, arabic: context.isArabic)),
              actions: [
                IconButton(
                  tooltip: l10n.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.push('/medications/$medicationId/edit'),
                ),
                _MenuButton(medication: m),
              ],
              bottom: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: l10n.overview),
                  Tab(text: l10n.schedules),
                  Tab(text: l10n.inventory),
                  Tab(text: l10n.doseHistory),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _Overview(medication: m),
                _Schedules(medication: m),
                MedicationStockTab(medication: m),
                _History(medication: m),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuButton extends ConsumerWidget {
  const _MenuButton({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final archived = medication.status == MedicationStatus.archived;
    return PopupMenuButton<String>(
      onSelected: (value) async {
        final sync = ref.read(syncCoordinatorProvider);
        switch (value) {
          case 'archive':
            final ok = await runGuarded(
              context,
              () => ref
                  .read(medicationRepositoryProvider)
                  .setArchived(medication.medicationId, !archived),
              success: l10n.savedMessage,
            );
            if (ok) sync.request(regeneratePatientId: medication.patientId);
          case 'delete':
            final confirmed = await confirmDialog(
              context,
              title: l10n.deleteMedicationTitle,
              body: l10n.deleteMedicationBody,
              confirmLabel: l10n.delete,
              destructive: true,
            );
            if (!confirmed || !context.mounted) return;
            final ok = await runGuarded(
              context,
              () => ref.read(trashRepositoryProvider).moveToTrash(
                    entityType: EntityTypes.medication,
                    entityId: medication.medicationId,
                    patientId: medication.patientId,
                    label: medication.nameEn,
                  ),
              success: l10n.deletedMessage,
            );
            if (ok) {
              sync.request(regeneratePatientId: medication.patientId);
              if (context.mounted) context.pop();
            }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'archive',
          child: Text(archived ? l10n.unarchive : l10n.archive),
        ),
        PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
      ],
    );
  }
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final m = medication;
    final primaryInstructions = context.isArabic
        ? (m.instructionsAr ?? m.instructionsEn)
        : (m.instructionsEn ?? m.instructionsAr);
    Widget row(String label, String? value) => value == null || value.isEmpty
        ? const SizedBox.shrink()
        : ListTile(
            dense: true,
            title: Text(label, style: Theme.of(context).textTheme.bodySmall),
            subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          );
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            children: [
              StatusBadge(
                m.status == MedicationStatus.archived
                    ? l10n.statusArchived
                    : l10n.statusActive,
                tone: m.status == MedicationStatus.archived
                    ? BadgeTone.neutral
                    : BadgeTone.success,
              ),
              if (m.isPrn) StatusBadge(l10n.prnBadge, tone: BadgeTone.brand),
            ],
          ),
        ),
        if (primaryInstructions != null)
          Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(primaryInstructions),
            ),
          ),
        row(l10n.nameEn, m.nameEn),
        row(l10n.nameAr, m.nameAr),
        row(l10n.strength, m.strength),
        row(l10n.doseUnit, unitLabel(m.doseUnit, l10n)),
        row(l10n.dosageForm, m.dosageForm),
        row(l10n.route, m.route),
        row(l10n.scientificName, m.scientificName),
        row(l10n.instructionsEn, m.instructionsEn),
        row(l10n.instructionsAr, m.instructionsAr),
        row(l10n.startDate,
            m.startDate == null ? null : formatIsoDate(context, m.startDate)),
        row(l10n.endDate,
            m.endDate == null ? null : formatIsoDate(context, m.endDate)),
        row(
          l10n.maximumDaily,
          m.maximumDailyQuantityScaled == null
              ? null
              : quantityWithUnit(
                  m.maximumDailyQuantityScaled, m.doseUnit, l10n),
        ),
        if (m.catalogPriceEgp != null)
          row(
            l10n.fromCatalog,
            '${l10n.catalogPrice(m.catalogPriceEgp!.toStringAsFixed(2))}\n${l10n.referencePriceNote}',
          ),
        if (m.isPrn && m.status == MedicationStatus.active)
          Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton.icon(
              onPressed: () =>
                  showPrnSheet(context, ref, medicationId: m.medicationId),
              icon: const Icon(Icons.add_task),
              label: Text(l10n.logPrn),
            ),
          ),
      ],
    );
  }
}

class _Schedules extends ConsumerWidget {
  const _Schedules({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final meals =
        ref.watch(patientMealsProvider(medication.patientId)).valueOrNull ??
            const [];
    final mealsById = {for (final m in meals) m.mealId: m};
    return AsyncBody(
      value: ref.watch(medicationSchedulesProvider(medication.medicationId)),
      builder: (schedules) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          if (medication.isPrn)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(l10n.prnPlannedNote),
            ),
          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.noSchedules, textAlign: TextAlign.center),
            ),
          for (final s in schedules)
            Card(
              child: ListTile(
                leading: Icon(
                  s.scheduleType == 'meal_relative'
                      ? Icons.restaurant_outlined
                      : Icons.alarm,
                ),
                title: Text(describeTiming(s, mealsById[s.mealId], l10n)),
                subtitle: Text(
                  describeSchedule(s, medication, mealsById[s.mealId], l10n)
                      .split(' · ')
                      .skip(1)
                      .join(' · '),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  '/medications/${medication.medicationId}/schedules/${s.scheduleId}',
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (medication.status == MedicationStatus.active)
            OutlinedButton.icon(
              onPressed: () => context.push(
                '/medications/${medication.medicationId}/schedules/new',
              ),
              icon: const Icon(Icons.add_alarm),
              label: Text(l10n.addSchedule),
            ),
        ],
      ),
    );
  }
}

class _History extends ConsumerWidget {
  const _History({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final time = ref.watch(patientTimeProvider);
    return AsyncBody(
      value: ref.watch(_historyProvider(medication.medicationId)),
      builder: (doses) => doses.isEmpty
          ? EmptyState(icon: Icons.history, message: l10n.noData)
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: doses.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final dose = doses[index].dose;
                final status = DoseStatus.fromCode(dose.status);
                final (label, tone) = switch (status) {
                  DoseStatus.taken => dose.isPrn
                      ? (l10n.prnTaken, BadgeTone.brand)
                      : isTakenLate(dose.lateMinutes)
                          ? (
                              l10n.lateBy(dose.lateMinutes ?? 0),
                              BadgeTone.warning
                            )
                          : (l10n.takenOnTime, BadgeTone.success),
                  DoseStatus.missed => (l10n.missed, BadgeTone.danger),
                  DoseStatus.skipped => (l10n.skipped, BadgeTone.neutral),
                  DoseStatus.scheduled => (l10n.pending, BadgeTone.brand),
                };
                return ListTile(
                  title: Text(
                      formatDateTime(context, time.toLocal(dose.scheduledAt))),
                  subtitle: Text(
                    dose.actualQuantityScaled == null
                        ? quantityWithUnit(dose.requiredQuantityScaled,
                            medication.doseUnit, l10n)
                        : '${formatScaled(dose.actualQuantityScaled)} / ${quantityWithUnit(dose.requiredQuantityScaled, medication.doseUnit, l10n)}',
                  ),
                  trailing: StatusBadge(label, tone: tone),
                );
              },
            ),
    );
  }
}
