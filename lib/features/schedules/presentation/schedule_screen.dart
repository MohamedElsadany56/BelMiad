import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/notifications/offline_notification_service.dart';
import '../data/schedule_service.dart';
import '../domain/recurrence_rule.dart';
import '../../doses/data/dose_repository.dart';
import '../../notifications/data/notification_preferences_repository.dart';
import '../../patients/data/patient_providers.dart';

Future<void> _addSchedule(BuildContext context, WidgetRef ref) async {
  final db = await ref.read(databaseProvider.future);
  final selectedPatientId = ref.read(activePatientIdProvider);
  final allMeds = await db.select(db.medications).get();
  final meds = selectedPatientId == null
      ? allMeds
      : allMeds.where((medication) => medication.patientId == selectedPatientId).toList();
  if (meds.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create a medicine first')));
    }
    return;
  }
  String medId = meds.first.id;
  final time = TextEditingController(text: '08:00');
  final qty = TextEditingController(text: '1000');
    var recurrence = RecurrenceType.daily;
    final weekdays = <int>{};
  final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) => AlertDialog(
              title: const Text('Add schedule'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                DropdownButtonFormField<String>(
                    initialValue: medId,
                    items: meds
                        .map((m) => DropdownMenuItem(
                            value: m.id, child: Text(m.nameEn)))
                        .toList(),
                    onChanged: (v) => medId = v!,
                    decoration: const InputDecoration(labelText: 'Medicine')),
                TextField(
                    controller: time,
                    decoration:
                        const InputDecoration(labelText: 'Time (HH:mm)')),
                TextField(
                    controller: qty,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Quantity scaled (1000 = 1 unit)'),
                DropdownButtonFormField<RecurrenceType>(
                    initialValue: recurrence,
                    items: RecurrenceType.values
                        .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value == RecurrenceType.everyNDays
                                ? 'Every N days'
                                : value.name)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => recurrence = value);
                    },
                    decoration: const InputDecoration(labelText: 'Repeat')),
                if (recurrence == RecurrenceType.weekly)
                  Wrap(
                    spacing: 4,
                    children: [
                      for (var day = 1; day <= 7; day++)
                        FilterChip(
                          label: Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1]),
                          selected: weekdays.contains(day),
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              weekdays.add(day);
                            } else {
                              weekdays.remove(day);
                            }
                          }),
                        ),
                    ],
                  )
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Save'))
              ])));
  if (ok == true) {
    final selectedMedication = meds.firstWhere((medication) => medication.id == medId);
    await ScheduleService(db).createSchedule(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        medicationId: medId,
        time: time.text,
        quantityScaled: int.tryParse(qty.text) ?? 1000,
        rule: RecurrenceRule(type: recurrence, weekdays: weekdays));
    await ScheduleService(db).generateDoses(
      patientId: selectedMedication.patientId,
      from: DateTime.now(),
      days: 7,
    );
    final notificationsEnabled = await NotificationPreferencesRepository(db)
        .isEnabled(selectedMedication.patientId, 'medications');
    if (notificationsEnabled) {
      final notificationService =
          OfflineNotificationService(FlutterLocalNotificationsPlugin());
      await notificationService.initialize();
      final generatedDoses = await (db.select(db.doseInstances)
            ..where((dose) => dose.patientId.equals(selectedMedication.patientId)))
          .get();
      final medicine = meds.firstWhere((med) => med.id == medId);
      for (final dose in generatedDoses.where(
        (dose) => dose.scheduledAt.isAfter(DateTime.now()),
      )) {
        await notificationService.scheduleDose(
          id: dose.id.hashCode & 0x7fffffff,
          patientName: 'patient',
          medicineName: medicine.nameEn,
          when: dose.scheduledAt,
        );
      }
    }
    ref.invalidate(todaysDosesProvider);
  }
}

Future<void> _cancelDoseReminder(String doseId) async {
  final service = OfflineNotificationService(FlutterLocalNotificationsPlugin());
  await service.initialize();
  await service.cancel(doseId.hashCode & 0x7fffffff);
}

final todaysDosesProvider = FutureProvider.autoDispose((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final selectedPatientId = ref.watch(activePatientIdProvider);
  final query = db.select(db.doseInstances);
  if (selectedPatientId != null) {
    query.where((dose) => dose.patientId.equals(selectedPatientId));
  }
  return query.get();
});

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doses = ref.watch(todaysDosesProvider);
    return AppScaffold(
      title: 'Medicine schedule',
      child: doses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Unable to load schedule: $e')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medicine schedule',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FilledButton.icon(
                  onPressed: () => _addSchedule(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add schedule'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Scheduled doses remain visible until they are taken, skipped, or marked missed.',
            ),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No dose instances have been generated yet.'),
                ),
              ),
            ...items.map(
              (dose) => Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.medication_outlined),
                  ),
                  title: Text(
                    'Dose at ${dose.scheduledAt.toLocal().toString().substring(11, 16)}',
                  ),
                  subtitle: Text(
                    '${dose.requiredQuantityScaled / dose.quantityScale} units · ${dose.status}',
                  ),
                  trailing: dose.status == 'SCHEDULED'
                      ? Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: 'Taken',
                              onPressed: () async {
                                final db = await ref.read(
                                  databaseProvider.future,
                                );
                                await DoseRepository(db).markTaken(
                                  dose.id,
                                  actualQuantityScaled:
                                      dose.requiredQuantityScaled,
                                );
                                await _cancelDoseReminder(dose.id);
                                ref.invalidate(todaysDosesProvider);
                              },
                              icon: const Icon(Icons.check_circle_outline),
                            ),
                            IconButton(
                              tooltip: 'Skip',
                              onPressed: () async {
                                final db = await ref.read(
                                  databaseProvider.future,
                                );
                                await DoseRepository(db).skip(dose.id);
                                await _cancelDoseReminder(dose.id);
                                ref.invalidate(todaysDosesProvider);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        )
                      : Chip(label: Text(dose.status)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
