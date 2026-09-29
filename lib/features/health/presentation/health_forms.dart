import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/labels.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../app/widgets/file_actions.dart';
import '../../../core/database/app_database.dart';
import '../../audit/data/audit_log.dart';
import '../data/health_repositories.dart';

void openHealthForm(BuildContext context, int tab, String patientId) {
  switch (tab) {
    case 0:
      showAppointmentForm(context, patientId, null);
    case 1:
      showVitalForm(context, patientId, null);
    case 2:
      showIllnessForm(context, patientId, null);
    case 3:
      showDietRuleForm(context, patientId, null);
    default:
      showPrescriptionForm(context, patientId);
  }
}

Future<void> _sheet(BuildContext context, Widget child) =>
    showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SafeArea(child: child),
      ),
    );

/// Shared sheet layout with save and optional delete (to trash).
class _EditorSheet extends ConsumerStatefulWidget {
  const _EditorSheet({
    required this.title,
    required this.fields,
    required this.onSave,
    this.trash,
  });

  final String title;
  final List<Widget> Function(StateSetter setState) fields;
  final Future<void> Function(WidgetRef ref) onSave;
  final ({
    String entityType,
    String entityId,
    String patientId,
    String label
  })? trash;

  @override
  ConsumerState<_EditorSheet> createState() => _EditorSheetState();
}

class _EditorSheetState extends ConsumerState<_EditorSheet> {
  final _form = GlobalKey<FormState>();
  bool _busy = false;

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final ok = await runGuarded(
      context,
      () => widget.onSave(ref),
      success: context.l10n.savedMessage,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      ref.read(syncCoordinatorProvider).request();
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final trash = widget.trash!;
    final ok = await runGuarded(
      context,
      () => ref.read(trashRepositoryProvider).moveToTrash(
            entityType: trash.entityType,
            entityId: trash.entityId,
            patientId: trash.patientId,
            label: trash.label,
          ),
      success: context.l10n.deletedMessage,
    );
    if (ok && mounted) {
      ref.read(syncCoordinatorProvider).request();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _form,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (widget.trash != null)
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: _busy ? null : _delete,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: 12),
          StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final field in widget.fields(setState))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: field,
                  ),
              ],
            ),
          ),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

Future<void> showAppointmentForm(
  BuildContext context,
  String patientId,
  Appointment? existing,
) {
  final l10n = context.l10n;
  final doctor = TextEditingController(text: existing?.doctorName);
  final specialty = TextEditingController(text: existing?.specialty);
  final location = TextEditingController(text: existing?.location);
  final notes = TextEditingController(text: existing?.notes);
  var when = existing?.scheduledTime.toLocal() ??
      DateTime.now().add(const Duration(days: 1));
  var status = existing?.status ?? AppointmentStatus.scheduled;
  return _sheet(
    context,
    _EditorSheet(
      title: existing == null ? l10n.addAppointment : l10n.edit,
      trash: existing == null
          ? null
          : (
              entityType: EntityTypes.appointment,
              entityId: existing.appointmentId,
              patientId: patientId,
              label: existing.doctorName,
            ),
      fields: (setState) => [
        TextFormField(
          controller: doctor,
          decoration: InputDecoration(labelText: l10n.doctor),
          validator: (v) =>
              v == null || v.trim().isEmpty ? l10n.error_doctorRequired : null,
        ),
        TextFormField(
          controller: specialty,
          decoration: InputDecoration(labelText: l10n.specialty),
        ),
        Builder(
          builder: (context) => InkWell(
            onTap: () async {
              final picked = await pickDateTime(context, when);
              if (picked != null) setState(() => when = picked);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.dateAndTime,
                prefixIcon: const Icon(Icons.event),
              ),
              child: Text(formatDateTime(context, when)),
            ),
          ),
        ),
        TextFormField(
          controller: location,
          decoration: InputDecoration(labelText: l10n.location),
        ),
        DropdownButtonFormField<String>(
          initialValue: status,
          decoration: InputDecoration(labelText: l10n.status),
          items: [
            for (final s in AppointmentStatus.all)
              DropdownMenuItem(
                  value: s, child: Text(appointmentStatusLabel(s, l10n))),
          ],
          onChanged: (v) => status = v ?? status,
        ),
        TextFormField(
          controller: notes,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(labelText: l10n.notes),
        ),
      ],
      onSave: (ref) => ref.read(appointmentRepositoryProvider).save(
            appointmentId: existing?.appointmentId,
            patientId: patientId,
            doctorName: doctor.text,
            specialty: specialty.text,
            scheduledTime: when,
            location: location.text,
            notes: notes.text,
            status: status,
          ),
    ),
  );
}

Future<void> showVitalForm(
  BuildContext context,
  String patientId,
  VitalMeasurement? existing,
) {
  final l10n = context.l10n;
  var type = existing?.measurementType ?? VitalTypes.bloodPressure;
  final value1 = TextEditingController(
    text: existing?.value1 == null ? '' : '${existing!.value1}',
  );
  final value2 = TextEditingController(
    text: existing?.value2 == null ? '' : '${existing!.value2}',
  );
  final unit = TextEditingController(
    text: existing?.unit ?? VitalTypes.defaultUnit(type),
  );
  final notes = TextEditingController(text: existing?.notes);
  var when = existing?.measuredAt.toLocal() ?? DateTime.now();
  double? parse(String text) => double.tryParse(text.replaceAll(',', '.'));
  return _sheet(
    context,
    _EditorSheet(
      title: existing == null ? l10n.addVital : l10n.edit,
      trash: existing == null
          ? null
          : (
              entityType: EntityTypes.vital,
              entityId: existing.measurementId,
              patientId: patientId,
              label: vitalTypeLabel(existing.measurementType, l10n),
            ),
      fields: (setState) => [
        DropdownButtonFormField<String>(
          initialValue: type,
          decoration: InputDecoration(labelText: l10n.vitalType),
          items: [
            for (final t in VitalTypes.all)
              DropdownMenuItem(value: t, child: Text(vitalTypeLabel(t, l10n))),
          ],
          onChanged: (v) => setState(() {
            type = v ?? type;
            unit.text = VitalTypes.defaultUnit(type);
          }),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: value1,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: VitalTypes.hasSecondValue(type)
                      ? l10n.systolic
                      : l10n.value,
                ),
                validator: (v) =>
                    parse(v ?? '') == null ? l10n.error_valueRequired : null,
              ),
            ),
            if (VitalTypes.hasSecondValue(type)) ...[
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: value2,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.diastolic),
                  validator: (v) =>
                      parse(v ?? '') == null ? l10n.error_valueRequired : null,
                ),
              ),
            ],
          ],
        ),
        TextFormField(
          controller: unit,
          decoration: InputDecoration(labelText: l10n.unit),
        ),
        Builder(
          builder: (context) => InkWell(
            onTap: () async {
              final picked = await pickDateTime(context, when);
              if (picked != null) setState(() => when = picked);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.measuredAt,
                prefixIcon: const Icon(Icons.schedule),
              ),
              child: Text(formatDateTime(context, when)),
            ),
          ),
        ),
        TextFormField(
          controller: notes,
          decoration: InputDecoration(labelText: l10n.notes),
        ),
      ],
      onSave: (ref) => ref.read(vitalsRepositoryProvider).save(
            measurementId: existing?.measurementId,
            patientId: patientId,
            measurementType: type,
            value1: parse(value1.text),
            value2: VitalTypes.hasSecondValue(type) ? parse(value2.text) : null,
            unit: unit.text,
            measuredAt: when,
            notes: notes.text,
          ),
    ),
  );
}

Future<void> showIllnessForm(
  BuildContext context,
  String patientId,
  Illness? existing,
) {
  final l10n = context.l10n;
  final condition = TextEditingController(text: existing?.conditionName);
  final notes = TextEditingController(text: existing?.notes);
  var diagnosed = existing?.diagnosedDate;
  return _sheet(
    context,
    _EditorSheet(
      title: existing == null ? l10n.addIllness : l10n.edit,
      trash: existing == null
          ? null
          : (
              entityType: EntityTypes.illness,
              entityId: existing.illnessId,
              patientId: patientId,
              label: existing.conditionName,
            ),
      fields: (setState) => [
        TextFormField(
          controller: condition,
          decoration: InputDecoration(labelText: l10n.condition),
          validator: (v) => requiredText(v, l10n),
        ),
        DateField(
          label: l10n.diagnosedDate,
          value: diagnosed,
          onChanged: (v) => setState(() => diagnosed = v),
        ),
        TextFormField(
          controller: notes,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(labelText: l10n.notes),
        ),
      ],
      onSave: (ref) => ref.read(illnessRepositoryProvider).save(
            illnessId: existing?.illnessId,
            patientId: patientId,
            conditionName: condition.text,
            diagnosedDate: diagnosed,
            notes: notes.text,
          ),
    ),
  );
}

Future<void> showDietRuleForm(
  BuildContext context,
  String patientId,
  DietaryRule? existing,
) {
  final l10n = context.l10n;
  final foodEn = TextEditingController(text: existing?.foodItemEn);
  final foodAr = TextEditingController(text: existing?.foodItemAr);
  final notes = TextEditingController(text: existing?.notes);
  var rule = existing?.ruleType ?? DietRuleTypes.avoid;
  return _sheet(
    context,
    _EditorSheet(
      title: existing == null ? l10n.addDietRule : l10n.edit,
      trash: existing == null
          ? null
          : (
              entityType: EntityTypes.dietRule,
              entityId: existing.dietRuleId,
              patientId: patientId,
              label: existing.foodItemEn,
            ),
      fields: (setState) => [
        Text(l10n.dietNoInferenceNote,
            style: Theme.of(context).textTheme.bodySmall),
        TextFormField(
          controller: foodEn,
          decoration: InputDecoration(labelText: l10n.foodItemEn),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) && foodAr.text.trim().isEmpty
                  ? l10n.error_nameRequired
                  : null,
        ),
        TextFormField(
          controller: foodAr,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(labelText: l10n.foodItemAr),
        ),
        DropdownButtonFormField<String>(
          initialValue: rule,
          decoration: InputDecoration(labelText: l10n.ruleType),
          items: [
            for (final r in DietRuleTypes.all)
              DropdownMenuItem(value: r, child: Text(dietRuleLabel(r, l10n))),
          ],
          onChanged: (v) => rule = v ?? rule,
        ),
        TextFormField(
          controller: notes,
          decoration: InputDecoration(labelText: l10n.notes),
        ),
      ],
      onSave: (ref) => ref.read(dietaryRuleRepositoryProvider).save(
            dietRuleId: existing?.dietRuleId,
            patientId: patientId,
            foodItemEn: foodEn.text,
            foodItemAr: foodAr.text,
            ruleType: rule,
            notes: notes.text,
          ),
    ),
  );
}

Future<void> showPrescriptionForm(BuildContext context, String patientId) {
  final l10n = context.l10n;
  final doctor = TextEditingController();
  final notes = TextEditingController();
  String? issueDate;
  PickedFile? file;
  return _sheet(
    context,
    _EditorSheet(
      title: l10n.addPrescription,
      fields: (setState) => [
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await pickFile(
              extensions: const ['jpg', 'jpeg', 'png', 'heic', 'webp', 'pdf'],
            );
            if (picked != null) setState(() => file = picked);
          },
          icon: const Icon(Icons.attach_file),
          label: Text(
              file == null ? l10n.pickFile : l10n.fileSelected(file!.name)),
        ),
        FormField<PickedFile>(
          validator: (_) => file == null ? l10n.requiredField : null,
          builder: (state) => state.hasError
              ? Text(
                  state.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                )
              : const SizedBox.shrink(),
        ),
        TextFormField(
          controller: doctor,
          decoration: InputDecoration(labelText: l10n.doctor),
        ),
        DateField(
          label: l10n.issueDate,
          value: issueDate,
          onChanged: (v) => setState(() => issueDate = v),
        ),
        TextFormField(
          controller: notes,
          decoration: InputDecoration(labelText: l10n.notes),
        ),
        Text(l10n.prescriptionsPrivateNote,
            style: Theme.of(context).textTheme.bodySmall),
      ],
      onSave: (ref) => ref.read(prescriptionRepositoryProvider).create(
            patientId: patientId,
            fileName: file!.name,
            bytes: file!.bytes,
            doctorName: doctor.text,
            issueDate: issueDate,
            notes: notes.text,
          ),
    ),
  );
}

/// Shows a stored prescription; a missing file is reported, not fatal.
Future<void> showPrescriptionViewer(
  BuildContext context,
  Prescription prescription,
) =>
    showDialog<void>(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(prescription.doctorName ?? l10n.prescriptions),
            content: FutureBuilder(
              future: ref
                  .read(prescriptionRepositoryProvider)
                  .readFile(prescription),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final bytes = snapshot.data;
                if (bytes == null) {
                  return ListTile(
                    leading: Icon(
                      Icons.broken_image_outlined,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(l10n.fileMissing),
                  );
                }
                final isPdf =
                    prescription.filePath.toLowerCase().endsWith('.pdf');
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isPdf)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 420),
                        child: InteractiveViewer(
                          child: Image.memory(
                            bytes,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.description_outlined,
                                size: 64),
                          ),
                        ),
                      )
                    else
                      const Icon(Icons.picture_as_pdf_outlined, size: 64),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => saveOrShareFile(
                        context,
                        bytes: bytes,
                        fileName: prescription.filePath.split('/').last,
                        mimeType: isPdf ? 'application/pdf' : 'image/*',
                      ),
                      icon: const Icon(Icons.open_in_new),
                      label: Text(l10n.openFile),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(trashRepositoryProvider).moveToTrash(
                        entityType: EntityTypes.prescription,
                        entityId: prescription.prescriptionId,
                        patientId: prescription.patientId,
                        label: prescription.doctorName ?? l10n.prescriptions,
                      );
                },
                child: Text(l10n.delete),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          );
        },
      ),
    );
