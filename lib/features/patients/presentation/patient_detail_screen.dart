import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/database/app_database.dart';
import '../../audit/data/audit_log.dart';
import '../../caregivers/data/caregiver_repository.dart';
import '../domain/patient_profile.dart';

final _patientProvider = StreamProvider.family<PatientProfile?, String>(
  (ref, id) => ref.watch(patientRepositoryProvider).watch(id),
);

final _caregiversProvider = StreamProvider.family<List<CaregiverLink>, String>(
  (ref, id) => ref.watch(caregiverRepositoryProvider).watchAssignments(id),
);

final _allPersonsProvider = StreamProvider<List<Person>>(
  (ref) => ref.watch(caregiverRepositoryProvider).watchPersons(),
);

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({required this.patientId, super.key});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AsyncBody(
      value: ref.watch(_patientProvider(patientId)),
      builder: (profile) {
        if (profile == null || profile.patient.deletedAt != null) {
          return Scaffold(
            appBar: AppBar(),
            body: ReadableWidth(
                child: EmptyState(
                    icon: Icons.person_off, message: l10n.error_notFound)),
          );
        }
        final p = profile.patient;
        final details = <(String, String?)>[
          (
            l10n.dateOfBirth,
            p.dateOfBirth == null ? null : formatIsoDate(context, p.dateOfBirth)
          ),
          (
            l10n.sex,
            switch (p.sex) {
              'male' => l10n.sexMale,
              'female' => l10n.sexFemale,
              _ => null,
            }
          ),
          (l10n.bloodType, p.bloodType),
          (l10n.phone, profile.person.phone),
          (l10n.email, profile.person.email),
          (l10n.emergencyContactName, p.emergencyContactName),
          (l10n.emergencyContactPhone, p.emergencyContactPhone),
          (l10n.timezone, p.timezone),
          (l10n.notes, p.notes),
        ];
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(profile.name),
            actions: [
              IconButton(
                tooltip: l10n.edit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/more/patients/$patientId/edit'),
              ),
              IconButton(
                tooltip: l10n.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(context, ref, profile),
              ),
            ],
          ),
          body: ReadableWidth(
              child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              if (ref.watch(currentPatientIdProvider) != patientId)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton.icon(
                    onPressed: () => selectCurrentPatient(ref, patientId),
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(l10n.switchPatient),
                  ),
                ),
              for (final (label, value) in details)
                if (value != null && value.isNotEmpty)
                  ListTile(
                    dense: true,
                    title: Text(label,
                        style: Theme.of(context).textTheme.bodySmall),
                    subtitle: Text(value,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
              SectionHeader(
                l10n.caregivers,
                trailing: TextButton.icon(
                  onPressed: () => _addCaregiver(context, ref),
                  icon: const Icon(Icons.person_add_alt),
                  label: Text(l10n.addCaregiver),
                ),
              ),
              ...ref.watch(_caregiversProvider(patientId)).maybeWhen(
                    data: (links) => [
                      for (final link in links)
                        ListTile(
                          leading: const Icon(Icons.badge_outlined),
                          title: Text(link.person.fullName),
                          subtitle: Text(
                            link.assignment.relationship == 'self'
                                ? l10n.relationshipSelf
                                : link.assignment.relationship ?? '',
                          ),
                          trailing: IconButton(
                            tooltip: l10n.removeCaregiver,
                            icon: const Icon(Icons.person_remove_outlined),
                            onPressed: () =>
                                _removeCaregiver(context, ref, link),
                          ),
                        ),
                    ],
                    orElse: () => const [],
                  ),
            ],
          )),
        );
      },
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PatientProfile profile,
  ) async {
    final l10n = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l10n.deletePatientTitle,
      body: l10n.deletePatientBody(profile.name),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final done = await runGuarded(
      context,
      () => ref.read(trashRepositoryProvider).moveToTrash(
            entityType: EntityTypes.patient,
            entityId: profile.id,
            patientId: profile.id,
            label: profile.name,
          ),
      success: l10n.deletedMessage,
    );
    if (done && context.mounted) {
      ref.read(syncCoordinatorProvider).request();
      context.pop();
    }
  }

  Future<void> _removeCaregiver(
    BuildContext context,
    WidgetRef ref,
    CaregiverLink link,
  ) async {
    final l10n = context.l10n;
    final ok = await confirmDialog(
      context,
      title: l10n.removeCaregiver,
      body: l10n.removeCaregiverBody(link.person.fullName),
      confirmLabel: l10n.removeCaregiver,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    await runGuarded(
      context,
      () => ref
          .read(caregiverRepositoryProvider)
          .removeAssignment(link.assignment.assignmentId),
    );
  }

  Future<void> _addCaregiver(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final persons =
        ref.read(_allPersonsProvider).valueOrNull ?? const <Person>[];
    final name = TextEditingController();
    final relationship = TextEditingController();
    String? selected;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addCaregiver),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selected,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.selectPerson),
                items: [
                  for (final p in persons)
                    DropdownMenuItem(
                        value: p.personId, child: Text(p.fullName)),
                  DropdownMenuItem(value: '_new', child: Text(l10n.newPerson)),
                ],
                onChanged: (v) => setState(() => selected = v),
              ),
              if (selected == '_new') ...[
                const SizedBox(height: 12),
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: l10n.fullName),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: relationship,
                decoration: InputDecoration(labelText: l10n.relationship),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed:
                  selected == null ? null : () => Navigator.pop(context, true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    if (result != true || !context.mounted) return;
    await runGuarded(context, () async {
      final repo = ref.read(caregiverRepositoryProvider);
      var personId = selected!;
      if (personId == '_new') {
        personId = await repo.createPerson(fullName: name.text);
      }
      await repo.assign(
        patientId: patientId,
        caregiverPersonId: personId,
        relationship: relationship.text,
      );
    }, success: l10n.savedMessage);
  }
}
