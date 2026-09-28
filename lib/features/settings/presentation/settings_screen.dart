import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../notifications/data/notification_preferences_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => AppScaffold(
        title: 'Settings',
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 18),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (value) async {
                      final db = await ref.read(databaseProvider.future);
                      await NotificationPreferencesRepository(db).setEnabled(
                        patientId: 'current-patient',
                        type: 'medication',
                        enabled: value,
                      );
                    },
                    title: const Text('Medication reminders'),
                    subtitle: const Text(
                      'Receive offline reminders for scheduled doses',
                    ),
                  ),
                  SwitchListTile(
                    value: true,
                    onChanged: (value) async {
                      final db = await ref.read(databaseProvider.future);
                      await NotificationPreferencesRepository(db).setEnabled(
                        patientId: 'current-patient',
                        type: 'inventory',
                        enabled: value,
                      );
                    },
                    title: const Text('Stock and expiry alerts'),
                    subtitle:
                        const Text('Warn when stock is low or expiring soon'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
