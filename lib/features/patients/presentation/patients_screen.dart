import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';

/// Multiple patients on one phone; the selected one drives every
/// patient-specific screen.
class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(currentPatientIdProvider);
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(l10n.patients)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => context.push('/more/patients/new'),
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(l10n.addPatient),
      ),
      body: ReadableWidth(
          child: AsyncBody(
        value: ref.watch(patientsProvider),
        builder: (patients) => patients.isEmpty
            ? EmptyState(icon: Icons.group_outlined, message: l10n.noPatients)
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                children: [
                  for (final p in patients)
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(p.name.characters.first.toUpperCase()),
                        ),
                        title: Text(p.name),
                        subtitle: Text(p.timezone),
                        selected: p.id == current,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (p.id == current)
                              StatusBadge(l10n.currentPatient,
                                  tone: BadgeTone.brand)
                            else
                              TextButton(
                                onPressed: () =>
                                    selectCurrentPatient(ref, p.id),
                                child: Text(l10n.switchPatient),
                              ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => context.push('/more/patients/${p.id}'),
                      ),
                    ),
                ],
              ),
      )),
    );
  }
}
