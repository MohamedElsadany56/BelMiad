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
            if (patientId != null) ...[
              IconButton(
                tooltip: l10n.markAllRead,
                icon: const Icon(Icons.done_all),
                onPressed: () => ref
                    .read(notificationRepositoryProvider)
                    .markAllRead(patientId),
              ),
              PopupMenuButton<bool>(
                tooltip: l10n.moreOptions,
                onSelected: (readOnly) async {
                  final ok = await confirmDialog(
                    context,
                    title: readOnly
                        ? l10n.deleteReadNotifications
                        : l10n.deleteAllNotifications,
                    body: l10n.deleteNotificationsBody,
                    confirmLabel: l10n.delete,
                    destructive: true,
                  );
                  if (!ok) return;
                  await ref
                      .read(notificationRepositoryProvider)
                      .deleteAll(patientId, readOnly: readOnly);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: true,
                    child: Text(l10n.deleteReadNotifications),
                  ),
                  PopupMenuItem(
                    value: false,
                    child: Text(l10n.deleteAllNotifications),
                  ),
                ],
              ),
            ],
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
    final repo = ref.read(notificationRepositoryProvider);
    final scheme = Theme.of(context).colorScheme;
    return AsyncBody(
      value: ref.watch(_centreProvider(patientId)),
      builder: (items) => items.isEmpty
          ? EmptyState(
              icon: Icons.notifications_none,
              message: l10n.noNotifications,
            )
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              // The last row is the retention note.
              itemCount: items.length + 1,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.notificationRetentionNote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                final n = items[index];
                final title = context.isArabic ? n.titleAr : n.titleEn;
                final body = context.isArabic ? n.bodyAr : n.bodyEn;
                return Semantics(
                  label: n.isRead ? l10n.notificationRead : l10n.unread,
                  child: ColoredBox(
                    color: n.isRead
                        ? Colors.transparent
                        : scheme.primaryContainer.withValues(alpha: 0.45),
                    child: ListTile(
                      onTap: n.isRead
                          ? null
                          : () => repo.markRead(n.notificationId),
                      leading: Icon(
                        switch (n.notificationType) {
                          NotificationTypes.doseReminder => Icons.alarm,
                          NotificationTypes.missedDose => Icons.alarm_off,
                          NotificationTypes.appointmentReminder => Icons.event,
                          NotificationTypes.expiration => Icons.event_busy,
                          _ => Icons.inventory_2_outlined,
                        },
                        color:
                            n.isRead ? scheme.onSurfaceVariant : scheme.primary,
                      ),
                      title: Text(
                        title ??
                            notificationTypeLabel(n.notificationType, l10n),
                        style: TextStyle(
                          fontWeight:
                              n.isRead ? FontWeight.normal : FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${body ?? ''}\n'
                        '${formatDateTime(context, time.toLocal(n.scheduledAt))}',
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        tooltip: l10n.moreOptions,
                        onSelected: (value) => switch (value) {
                          'read' => repo.markRead(n.notificationId),
                          'unread' => repo.markUnread(n.notificationId),
                          _ => repo.delete(n.notificationId),
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: n.isRead ? 'unread' : 'read',
                            child: Text(
                              n.isRead ? l10n.markAsUnread : l10n.markAsRead,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
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
