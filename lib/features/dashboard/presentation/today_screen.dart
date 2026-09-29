import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../../core/time/local_date.dart';
import '../../doses/data/dose_repository.dart';
import '../../doses/domain/dose_status.dart';
import '../../doses/presentation/take_dose_sheet.dart';
import '../../health/data/health_repositories.dart';
import '../../medications/data/medication_repository.dart';
import 'live_clock.dart';

final _selectedDateProvider = StateProvider<LocalDate?>((ref) => null);

final _dayDosesProvider =
    StreamProvider.family<List<DoseView>, (String, String)>((ref, key) {
  return ref.watch(doseRepositoryProvider).watchDay(key.$1, key.$2);
});

final _nextAppointmentProvider =
    StreamProvider.family<Appointment?, String>((ref, patientId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.appointments)
        ..where(
          (a) =>
              a.patientId.equals(patientId) &
              a.deletedAt.isNull() &
              a.status.equals(AppointmentStatus.scheduled) &
              a.scheduledTime.isBiggerThanValue(DateTime.now().toUtc()),
        )
        ..orderBy([(a) => OrderingTerm.asc(a.scheduledTime)])
        ..limit(1))
      .watchSingleOrNull();
});

final _prnMedicationsProvider =
    StreamProvider.family<List<Medication>, String>((ref, patientId) {
  return ref
      .watch(medicationRepositoryProvider)
      .watchForPatient(patientId, includeArchived: false)
      .map((list) => list.where((m) => m.isPrn && !m.storageOnly).toList());
});

final unreadNotificationsProvider =
    StreamProvider.family<int, String>((ref, patientId) {
  return ref.watch(notificationRepositoryProvider).watchUnreadCount(patientId);
});

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    final unread = patientId == null
        ? 0
        : ref.watch(unreadNotificationsProvider(patientId)).valueOrNull ?? 0;
    final prn = patientId == null
        ? const <Medication>[]
        : ref.watch(_prnMedicationsProvider(patientId)).valueOrNull ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todayTitle),
        actions: [
          IconButton(
            tooltip: l10n.notifications,
            onPressed: () => context.push('/more/notifications'),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          const PatientSwitcher(),
        ],
      ),
      floatingActionButton: prn.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _logPrn(context, ref, prn),
              icon: const Icon(Icons.add_task),
              label: Text(l10n.logPrn),
            ),
      body: RequirePatient(builder: (id) => _TodayBody(patientId: id)),
    );
  }

  Future<void> _logPrn(
    BuildContext context,
    WidgetRef ref,
    List<Medication> medications,
  ) async {
    String? medicationId =
        medications.length == 1 ? medications.single.medicationId : null;
    medicationId ??= await showModalBottomSheet<String>(
      useRootNavigator: true,
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(context.l10n.selectMedication)),
            for (final m in medications)
              ListTile(
                leading: const Icon(Icons.medication_outlined),
                title: Text(medicationDisplayName(m, arabic: context.isArabic)),
                onTap: () => Navigator.pop(context, m.medicationId),
              ),
          ],
        ),
      ),
    );
    if (medicationId == null || !context.mounted) return;
    await showPrnSheet(context, ref, medicationId: medicationId);
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final time = ref.watch(patientTimeProvider);
    final today = time.today(DateTime.now().toUtc());
    final date = ref.watch(_selectedDateProvider) ?? today;
    final doses = ref.watch(_dayDosesProvider((patientId, date.toIso())));
    final dashboard =
        ref.watch(inventoryDashboardProvider(patientId)).valueOrNull;
    final appointment =
        ref.watch(_nextAppointmentProvider(patientId)).valueOrNull;

    String dayLabel() {
      if (date == today) return l10n.today;
      if (date == today.addDays(1)) return l10n.tomorrow;
      if (date == today.addDays(-1)) return l10n.yesterday;
      return DateFormat.MMMEd(context.localeName).format(date.toDateTime());
    }

    void setDate(LocalDate value) =>
        ref.read(_selectedDateProvider.notifier).state = value;

    return RefreshIndicator(
      onRefresh: () => ref.read(syncCoordinatorProvider).run(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          const LiveClock(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: l10n.back,
                  onPressed: () => setDate(date.addDays(-1)),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date.toDateTime(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDate(LocalDate.fromDateTime(picked));
                      }
                    },
                    child: Text(
                      dayLabel(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.next,
                  onPressed: () => setDate(date.addDays(1)),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          doses.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text(errorMessage(e, l10n)),
            data: (list) => _SummaryCard(doses: list),
          ),
          if (dashboard != null &&
              (dashboard.lowStock > 0 ||
                  dashboard.emptyStock > 0 ||
                  dashboard.expiringSoon > 0))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.warning_amber_rounded,
                    color: context.statusColors.warning,
                  ),
                  title: Text(l10n.alerts),
                  subtitle: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (dashboard.lowStock > 0)
                        StatusBadge(
                          '${l10n.lowStock}: ${dashboard.lowStock}',
                          tone: BadgeTone.warning,
                        ),
                      if (dashboard.emptyStock > 0)
                        StatusBadge(
                          '${l10n.emptyStock}: ${dashboard.emptyStock}',
                          tone: BadgeTone.danger,
                        ),
                      if (dashboard.expiringSoon > 0)
                        StatusBadge(
                          '${l10n.expiringSoon}: ${dashboard.expiringSoon}',
                          tone: BadgeTone.warning,
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/inventory'),
                ),
              ),
            ),
          if (appointment != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available_outlined),
                  title: Text(l10n.upcomingAppointment),
                  subtitle: Text(
                    '${appointment.doctorName} · '
                    '${formatDateTime(context, time.toLocal(appointment.scheduledTime))}',
                  ),
                  onTap: () => context.go('/health?tab=0'),
                ),
              ),
            ),
          doses.maybeWhen(
            data: (list) => list.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: EmptyState(
                      icon: Icons.event_available_outlined,
                      message: l10n.noDoses,
                    ),
                  )
                : Column(
                    children: [
                      for (final view in list) _DoseTile(view: view),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.doses});

  final List<DoseView> doses;

  @override
  Widget build(BuildContext context) {
    final scheduled = doses.where((d) => !d.dose.isPrn).toList();
    if (scheduled.isEmpty) return const SizedBox.shrink();
    final taken = scheduled.where((d) => d.status == DoseStatus.taken).length;
    final progress = taken / scheduled.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Card(
        color: BrandColors.blue,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.dosesDone(taken, scheduled.length),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoseTile extends ConsumerWidget {
  const _DoseTile({required this.view});

  final DoseView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final time = ref.watch(patientTimeProvider);
    final dose = view.dose;
    final medication = view.medication;
    final status = view.status;
    final scheduledLocal = time.toLocal(dose.scheduledAt);

    final (badge, tone, icon) = switch (status) {
      DoseStatus.taken => (
          dose.isPrn
              ? l10n.prnTaken
              : isTakenLate(dose.lateMinutes)
                  ? l10n.lateBy(dose.lateMinutes ?? 0)
                  : l10n.taken,
          isTakenLate(dose.lateMinutes) ? BadgeTone.warning : BadgeTone.success,
          Icons.check_circle,
        ),
      DoseStatus.missed => (l10n.missed, BadgeTone.danger, Icons.cancel),
      DoseStatus.skipped => (
          l10n.skipped,
          BadgeTone.neutral,
          Icons.remove_circle
        ),
      DoseStatus.scheduled => (
          scheduledLocal.isBefore(DateTime.now())
              ? l10n.pending
              : l10n.scheduled,
          BadgeTone.brand,
          Icons.schedule,
        ),
    };

    final quantity = dose.actualQuantityScaled != null &&
            dose.actualQuantityScaled != dose.requiredQuantityScaled
        ? l10n.partialDose(
            quantityWithUnit(
                dose.actualQuantityScaled, medication.doseUnit, l10n),
            quantityWithUnit(
                dose.requiredQuantityScaled, medication.doseUnit, l10n),
          )
        : quantityWithUnit(
            dose.requiredQuantityScaled, medication.doseUnit, l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(
                      formatClock(context, scheduledLocal),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push(
                        '/medications/${medication.medicationId}',
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicationDisplayName(
                              medication,
                              arabic: context.isArabic,
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(quantity),
                          if (status == DoseStatus.taken &&
                              dose.takenAt != null)
                            Text(
                              l10n.takenAt(
                                formatClock(
                                    context, time.toLocal(dose.takenAt!)),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                  StatusBadge(badge, tone: tone, icon: icon),
                ],
              ),
              if (status == DoseStatus.scheduled || status == DoseStatus.taken)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == DoseStatus.scheduled) ...[
                      TextButton(
                        onPressed: () => _skip(context, ref),
                        child: Text(l10n.skip),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () => showTakeDoseSheet(
                          context,
                          ref,
                          doseInstanceId: dose.doseInstanceId,
                        ),
                        icon: const Icon(Icons.check),
                        label: Text(l10n.take),
                      ),
                    ] else
                      TextButton.icon(
                        onPressed: () => _undo(context, ref),
                        icon: const Icon(Icons.undo),
                        label: Text(l10n.undoTake),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _skip(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l10n.skipDoseTitle,
      body: l10n.skipDoseBody,
      confirmLabel: l10n.skip,
    );
    if (!ok || !context.mounted) return;
    final done = await runGuarded(
      context,
      () => ref.read(doseServiceProvider).skipDose(view.dose.doseInstanceId),
      success: l10n.doseSkippedMessage,
    );
    if (done) ref.read(syncCoordinatorProvider).request();
  }

  Future<void> _undo(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l10n.undoTake,
      body: l10n.undoTakeBody,
      confirmLabel: l10n.undo,
    );
    if (!ok || !context.mounted) return;
    final done = await runGuarded(
      context,
      () => ref.read(doseServiceProvider).undoDose(view.dose.doseInstanceId),
      success: l10n.doseUndone,
    );
    if (done) ref.read(syncCoordinatorProvider).request();
  }
}
