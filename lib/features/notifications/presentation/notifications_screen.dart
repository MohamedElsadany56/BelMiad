import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import 'reminder_sound_picker.dart';
import '../../../core/database/app_database.dart';
import '../domain/notification_types.dart';

final _centreProvider = StreamProvider.family<List<AppNotification>, String>(
  (ref, id) => ref.watch(notificationRepositoryProvider).watchCentre(id),
);

final _preferencesProvider = StreamProvider.family<Map<String, bool>, String>(
  (ref, id) => ref.watch(notificationRepositoryProvider).watchPreferences(id),
);

/// In-app notification centre and per-patient preferences (spec §27).
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(l10n.notifications),
          actions: [
            if (patientId != null)
              IconButton(
                tooltip: l10n.markAllRead,
                icon: const Icon(Icons.done_all),
                onPressed: () => ref
                    .read(notificationRepositoryProvider)
                    .markAllRead(patientId),
              ),
          ],
          bottom: AppTabBar(
            tabs: [
              (null, l10n.notifications),
              (null, l10n.notificationSettings),
            ],
          ),
        ),
        body: ReadableWidth(
            child: RequirePatient(
          builder: (id) => TabBarView(
            children: [_Centre(patientId: id), _Preferences(patientId: id)],
          ),
        )),
      ),
    );
  }
}

class _Centre extends ConsumerWidget {
  const _Centre({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final time = ref.watch(patientTimeProvider);
    return AsyncBody(
      value: ref.watch(_centreProvider(patientId)),
      builder: (items) => items.isEmpty
          ? EmptyState(
              icon: Icons.notifications_none,
              message: l10n.noNotifications,
            )
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final n = items[index];
                final title = context.isArabic ? n.titleAr : n.titleEn;
                final body = context.isArabic ? n.bodyAr : n.bodyEn;
                return ListTile(
                  leading: Icon(
                    switch (n.notificationType) {
                      NotificationTypes.doseReminder => Icons.alarm,
                      NotificationTypes.missedDose => Icons.alarm_off,
                      NotificationTypes.appointmentReminder => Icons.event,
                      NotificationTypes.expiration => Icons.event_busy,
                      _ => Icons.inventory_2_outlined,
                    },
                    color:
                        n.isRead ? null : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    title ?? notificationTypeLabel(n.notificationType, l10n),
                    style: TextStyle(
                      fontWeight:
                          n.isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${body ?? ''}\n${formatDateTime(context, time.toLocal(n.scheduledAt))}',
                  ),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}

class _Preferences extends ConsumerWidget {
  const _Preferences({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AsyncBody(
      value: ref.watch(_preferencesProvider(patientId)),
      builder: (prefs) => ListView(
        children: [
          // The sound applies to the whole phone, not only this patient.
          const ReminderSoundTile(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.notificationsPerPatient),
          ),
          for (final type in NotificationTypes.all)
            SwitchListTile(
              value: prefs[type] ?? true,
              title: Text(notificationTypeLabel(type, l10n)),
              onChanged: (enabled) async {
                await ref
                    .read(notificationRepositoryProvider)
                    .setPreference(patientId, type, enabled);
                ref.read(syncCoordinatorProvider).request();
              },
            ),
        ],
      ),
    );
  }
}
