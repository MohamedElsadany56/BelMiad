import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';

final _trashProvider = StreamProvider.family<List<TrashItem>, String?>(
  (ref, patientId) =>
      ref.watch(trashRepositoryProvider).watchActive(patientId: patientId),
);

/// Restore or permanently delete (spec §32).
class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patientId = ref.watch(currentPatientIdProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trash)),
      body: AsyncBody(
        value: ref.watch(_trashProvider(patientId)),
        builder: (items) => items.isEmpty
            ? EmptyState(icon: Icons.delete_outline, message: l10n.trashEmpty)
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: const Icon(Icons.restore_from_trash_outlined),
                    title:
                        Text(item.label ?? entityLabel(item.entityType, l10n)),
                    subtitle: Text(
                      '${entityLabel(item.entityType, l10n)} · '
                      '${l10n.deletedOn(formatDateTime(context, item.deletedAt.toLocal()))}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l10n.restore,
                          icon: const Icon(Icons.restore),
                          onPressed: () async {
                            final ok = await runGuarded(
                              context,
                              () => ref
                                  .read(trashRepositoryProvider)
                                  .restore(item.trashItemId),
                              success: l10n.restored,
                            );
                            if (ok) {
                              ref.read(syncCoordinatorProvider).request(
                                    regeneratePatientId: item.patientId,
                                  );
                            }
                          },
                        ),
                        IconButton(
                          tooltip: l10n.permanentlyDelete,
                          icon: Icon(
                            Icons.delete_forever,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () async {
                            final ok = await confirmDialog(
                              context,
                              title: l10n.permanentDeleteTitle,
                              body: l10n.permanentDeleteBody,
                              confirmLabel: l10n.permanentlyDelete,
                              destructive: true,
                            );
                            if (!ok || !context.mounted) return;
                            await runGuarded(
                              context,
                              () => ref
                                  .read(trashRepositoryProvider)
                                  .permanentlyDelete(item.trashItemId),
                              success: l10n.deletedPermanently,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
