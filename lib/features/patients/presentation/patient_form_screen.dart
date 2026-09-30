import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/settings/settings_repository.dart';
import '../../../core/time/patient_time.dart';
import '../data/patient_repository.dart';

const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

class PatientFormScreen extends ConsumerStatefulWidget {
  const PatientFormScreen({this.patientId, super.key});

  final String? patientId;

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();
  final _notes = TextEditingController();
  final _relationship = TextEditingController();
  String? _dob;
  String? _sex;
  String? _bloodType;
  String _timezone = defaultTimezone;
  bool _loading = true;
  bool _busy = false;

  bool get _editing => widget.patientId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.patientId;
    if (id != null) {
      final profile = await ref.read(patientRepositoryProvider).get(id);
      if (profile != null) {
        _name.text = profile.person.fullName;
        _phone.text = profile.person.phone ?? '';
        _email.text = profile.person.email ?? '';
        _emergencyName.text = profile.patient.emergencyContactName ?? '';
        _emergencyPhone.text = profile.patient.emergencyContactPhone ?? '';
        _notes.text = profile.patient.notes ?? '';
        _dob = profile.patient.dateOfBirth;
        _sex = profile.patient.sex;
        _bloodType = profile.patient.bloodType;
        _timezone = profile.patient.timezone;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _phone,
      _email,
      _emergencyName,
      _emergencyPhone,
      _notes,
      _relationship,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final input = PatientInput(
      fullName: _name.text,
      phone: _phone.text,
      email: _email.text,
      dateOfBirth: _dob,
      sex: _sex,
      bloodType: _bloodType,
      emergencyContactName: _emergencyName.text,
      emergencyContactPhone: _emergencyPhone.text,
      notes: _notes.text,
      timezone: _timezone,
    );
    setState(() => _busy = true);
    final repo = ref.read(patientRepositoryProvider);
    final ok = await runGuarded(context, () async {
      if (_editing) {
        final timezoneChanged = await repo.update(widget.patientId!, input);
        if (timezoneChanged) {
          ref
              .read(syncCoordinatorProvider)
              .request(regeneratePatientId: widget.patientId);
        }
      } else {
        final settings = await ref.read(settingsRepositoryProvider).load();
        final id = await repo.create(
          input,
          caregiverPersonId: settings.devicePersonId,
          relationship: _relationship.text,
        );
        await ref
            .read(settingsRepositoryProvider)
            .set(SettingKeys.currentPatientId, id);
      }
    }, success: context.l10n.savedMessage);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) context.pop();
  }

  Future<void> _pickTimezone() async {
    final zones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    final picked = await showDialog<String>(
      context: context,
      builder: (context) => _TimezoneDialog(zones: zones, selected: _timezone),
    );
    if (picked != null) setState(() => _timezone = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
          title: AppBarTitle(_editing ? l10n.editPatient : l10n.addPatient)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: _busy || _loading ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(l10n.save),
      ),
      body: ReadableWidth(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _form,
                  child: FormBody(
                    children: [
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: l10n.fullName),
                        validator: (v) => requiredText(v, l10n),
                      ),
                      if (!_editing)
                        TextFormField(
                          controller: _relationship,
                          decoration: InputDecoration(
                              labelText: l10n.relationshipLabel),
                        ),
                      DateField(
                        label: l10n.dateOfBirth,
                        value: _dob,
                        lastDate: DateTime.now(),
                        onChanged: (v) => setState(() => _dob = v),
                      ),
                      DropdownButtonFormField<String?>(
                        isExpanded: true,
                        initialValue: _sex,
                        decoration: InputDecoration(labelText: l10n.sex),
                        items: [
                          DropdownMenuItem(
                              value: null, child: Text(l10n.notSet)),
                          DropdownMenuItem(
                              value: 'male', child: Text(l10n.sexMale)),
                          DropdownMenuItem(
                              value: 'female', child: Text(l10n.sexFemale)),
                        ],
                        onChanged: (v) => setState(() => _sex = v),
                      ),
                      DropdownButtonFormField<String?>(
                        isExpanded: true,
                        initialValue: _bloodType,
                        decoration: InputDecoration(labelText: l10n.bloodType),
                        items: [
                          DropdownMenuItem(
                              value: null, child: Text(l10n.notSet)),
                          for (final b in _bloodTypes)
                            DropdownMenuItem(value: b, child: Text(b)),
                        ],
                        onChanged: (v) => setState(() => _bloodType = v),
                      ),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: l10n.phone),
                      ),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: l10n.email),
                      ),
                      TextFormField(
                        controller: _emergencyName,
                        decoration: InputDecoration(
                            labelText: l10n.emergencyContactName),
                      ),
                      TextFormField(
                        controller: _emergencyPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: l10n.emergencyContactPhone),
                      ),
                      InkWell(
                        onTap: _pickTimezone,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.timezone,
                            helperText: l10n.timezoneHint,
                            prefixIcon: const Icon(Icons.public),
                          ),
                          child: Text(_timezone),
                        ),
                      ),
                      TextFormField(
                        controller: _notes,
                        maxLines: 4,
                        minLines: 2,
                        decoration: InputDecoration(labelText: l10n.notes),
                      ),
                    ],
                  ),
                )),
    );
  }
}

class _TimezoneDialog extends StatefulWidget {
  const _TimezoneDialog({required this.zones, required this.selected});

  final List<String> zones;
  final String selected;

  @override
  State<_TimezoneDialog> createState() => _TimezoneDialogState();
}

class _TimezoneDialogState extends State<_TimezoneDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.zones
        .where((z) => z.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return AlertDialog(
      title: Text(context.l10n.timezone),
      content: SizedBox(
        width: 400,
        height: 480,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.search,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(filtered[index]),
                  selected: filtered[index] == widget.selected,
                  onTap: () => Navigator.pop(context, filtered[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
