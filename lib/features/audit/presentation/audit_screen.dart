import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';

final _auditProvider = StreamProvider.family<List<AuditEvent>, String>(
  (ref, patientId) => ref.watch(auditLogProvider).watchForPatient(patientId),
);

/// Activity history with the actor of each action (spec §33).
class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final names = ref.watch(personNamesProvider).valueOrNull ?? const {};
    final time = ref.watch(patientTimeProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.auditLog)),
      body: RequirePatient(
        builder: (patientId) => AsyncBody(
          value: ref.watch(_auditProvider(patientId)),
          builder: (events) => events.isEmpty
              ? EmptyState(icon: Icons.history, message: l10n.auditEmpty)
              : ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final e = events[index];
                    final actor = e.actorPersonId == null
                        ? l10n.systemActor
                        : names[e.actorPersonId] ?? l10n.unknownActor;
                    final metadata = _summary(e.metadataJson);
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.fiber_manual_record, size: 12),
                      title: Text(
                        '${auditActionLabel(e.action, l10n)} · '
                        '${entityLabel(e.entityType, l10n)}',
                      ),
                      subtitle: Text([
                        '$actor · ${formatDateTime(context, time.toLocal(e.occurredAt))}',
                        if (metadata.isNotEmpty) metadata,
                      ].join('\n')),
                    );
                  },
                ),
        ),
      ),
    );
  }

  String _summary(String? json) {
    if (json == null) return '';
    try {
      final data = jsonDecode(json);
      if (data is! Map) return '';
      final name = data['medication'] ??
          data['name'] ??
          data['label'] ??
          data['doctor'] ??
          data['condition'] ??
          data['food'];
      return name?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }
}
