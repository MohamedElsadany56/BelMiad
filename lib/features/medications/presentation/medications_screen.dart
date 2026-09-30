import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../inventory/domain/stock_forecast.dart';
import '../../reports/application/pdf_report_service.dart';
import '../data/medication_repository.dart';

enum MedicationFilter { active, archived, storage }

final _filterProvider =
    StateProvider<MedicationFilter>((ref) => MedicationFilter.active);
final _medicationQueryProvider = StateProvider<String>((ref) => '');

final patientMedicationsProvider =
    StreamProvider.family<List<Medication>, String>((ref, patientId) {
  return ref.watch(medicationRepositoryProvider).watchForPatient(patientId);
});

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(l10n.medications),
        actions: const [PatientSwitcher()],
      ),
      floatingActionButton: ref.watch(currentPatientIdProvider) == null
          ? null
          : FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => context.push('/medications/new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.addMedication),
            ),
      body: ReadableWidth(
          child: RequirePatient(
        builder: (patientId) => _MedicationList(patientId: patientId),
      )),
    );
  }
}

class _MedicationList extends ConsumerWidget {
  const _MedicationList({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(_filterProvider);
    final query = ref.watch(_medicationQueryProvider).trim().toLowerCase();
    final stock = ref.watch(inventoryDashboardProvider(patientId)).valueOrNull;
    final stockById = {
      for (final item in stock?.items ?? const [])
        item.medication.medicationId: item,
    };
    return AsyncBody(
      value: ref.watch(patientMedicationsProvider(patientId)),
      builder: (all) {
        final visible = all.where((m) {
          final archived = m.status == MedicationStatus.archived;
          final matches = switch (filter) {
            MedicationFilter.active => !archived && !m.storageOnly,
            MedicationFilter.archived => archived,
            MedicationFilter.storage => m.storageOnly && !archived,
          };
          if (!matches) return false;
          if (query.isEmpty) return true;
          return m.nameEn.toLowerCase().contains(query) ||
              (m.nameAr ?? '').contains(query);
        }).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.search,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) =>
                    ref.read(_medicationQueryProvider.notifier).state = v,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final (value, label) in [
                    (MedicationFilter.active, l10n.filterActive),
                    (MedicationFilter.storage, l10n.filterStorage),
                    (MedicationFilter.archived, l10n.filterArchived),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: filter == value,
                      onSelected: (_) =>
                          ref.read(_filterProvider.notifier).state = value,
                    ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? EmptyState(
                      icon: Icons.medication_outlined,
                      message: l10n.noMedications,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final medication = visible[index];
                        final summary =
                            stockById[medication.medicationId]?.summary;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                Icons.medication,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              medicationDisplayName(
                                medication,
                                arabic: context.isArabic,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  if (medication.storageOnly)
                                    StatusBadge(l10n.storageBadge),
                                  if (medication.isPrn)
                                    StatusBadge(l10n.prnBadge,
                                        tone: BadgeTone.brand),
                                  if (medication.status ==
                                      MedicationStatus.archived)
                                    StatusBadge(l10n.statusArchived),
                                  if (summary != null) ...[
                                    StockStateBadge(state: summary.state),
                                    if (summary.stockRecorded)
                                      Text(
                                        '${quantityWithUnit(summary.usableScaled, medication.doseUnit, l10n)} · '
                                        '${remainingDaysText(summary, l10n)}',
                                      ),
                                  ],
                                ],
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(
                              '/medications/${medication.medicationId}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class StockStateBadge extends StatelessWidget {
  const StockStateBadge({required this.state, super.key});

  final StockState state;

  @override
  Widget build(BuildContext context) {
    final tone = switch (state) {
      StockState.normal => BadgeTone.success,
      StockState.low || StockState.expiringSoon => BadgeTone.warning,
      StockState.empty || StockState.expiredOnly => BadgeTone.danger,
      StockState.noStockRecorded => BadgeTone.neutral,
    };
    return StatusBadge(stockStateLabel(state, context.l10n), tone: tone);
  }
}
