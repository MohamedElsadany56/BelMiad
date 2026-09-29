import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/notifications/offline_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../patients/data/patient_providers.dart';
import '../../notifications/data/notification_preferences_repository.dart';

final medicationNotificationsProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, patientId) async {
    final db = await ref.watch(databaseProvider.future);
    return NotificationPreferencesRepository(db)
        .isEnabled(patientId, 'medications');
  },
);

final inventoryNotificationsProvider = FutureProvider.autoDispose.family<bool, String>(
  (ref, patientId) async {
    final db = await ref.watch(databaseProvider.future);
    return NotificationPreferencesRepository(db)
        .isEnabled(patientId, 'inventory');
  },
);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    return AppScaffold(
      title: 'Settings',
      child: patients.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Unable to load patients: $error')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Create a patient before configuring notifications.'));
          }
            final selectedPatientId = ref.watch(activePatientIdProvider);
            final patientId = items.any((patient) => patient.id == selectedPatientId)
              ? selectedPatientId!
              : items.first.id;
          final medicationNotifications =
              ref.watch(medicationNotificationsProvider(patientId));
          final inventoryNotifications =
              ref.watch(inventoryNotificationsProvider(patientId));
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 18),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: medicationNotifications.value ?? true,
                      onChanged: (value) async {
                        final db = await ref.read(databaseProvider.future);
                        await NotificationPreferencesRepository(db).setEnabled(
                          patientId: patientId,
                          type: 'medications',
                          enabled: value,
                        );
                        if (!value) {
                          final notifications = OfflineNotificationService(
                            FlutterLocalNotificationsPlugin(),
                          );
                          await notifications.initialize();
                          await notifications.cancelAll();
                        }
                        ref.invalidate(medicationNotificationsProvider(patientId));
                      },
                      title: const Text('Medication reminders'),
                      subtitle: const Text(
                        'Receive offline reminders for scheduled doses',
                      ),
                    ),
                    SwitchListTile(
                      value: inventoryNotifications.value ?? true,
                      onChanged: (value) async {
                        final db = await ref.read(databaseProvider.future);
                        await NotificationPreferencesRepository(db).setEnabled(
                          patientId: patientId,
                          type: 'inventory',
                          enabled: value,
                        );
                        ref.invalidate(inventoryNotificationsProvider(patientId));
                      },
                      title: const Text('Stock and expiry alerts'),
                      subtitle: const Text('Warn when stock is low or expiring soon'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

