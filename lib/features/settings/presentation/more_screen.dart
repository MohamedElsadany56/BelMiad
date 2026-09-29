import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final device = ref.watch(devicePersonProvider).valueOrNull;
    final items = [
      (Icons.group_outlined, l10n.patients, '/more/patients'),
      (Icons.restaurant_outlined, l10n.meals, '/more/meals'),
      (Icons.assessment_outlined, l10n.reports, '/more/reports'),
      (Icons.notifications_outlined, l10n.notifications, '/more/notifications'),
      (Icons.backup_outlined, l10n.backup, '/more/backup'),
      (Icons.history, l10n.auditLog, '/more/audit'),
      (Icons.delete_outline, l10n.trash, '/more/trash'),
      (Icons.settings_outlined, l10n.settings, '/more/settings'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navMore),
        actions: const [PatientSwitcher()],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (device != null)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.badge_outlined)),
              title: Text(device.fullName),
              subtitle: Text(l10n.deviceCaregiver),
              trailing: TextButton(
                onPressed: () => context.push('/more/settings'),
                child: Text(l10n.changeCaregiver),
              ),
            ),
          const Divider(),
          for (final (icon, label, path) in items)
            ListTile(
              leading: Icon(icon),
              title: Text(label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(path),
            ),
        ],
      ),
    );
  }
}
