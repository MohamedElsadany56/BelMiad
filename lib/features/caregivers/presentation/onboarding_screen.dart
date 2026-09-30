import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../../../core/settings/settings_repository.dart';
import '../../patients/data/patient_repository.dart';

/// First-run flow: choose language, identify the caregiver on this phone
/// (attribution only, no authentication) and create the first patient.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _caregiverForm = GlobalKey<FormState>();
  final _patientForm = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _patientName = TextEditingController();
  final _relationship = TextEditingController();
  bool _isSelf = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _patientName.dispose();
    _relationship.dispose();
    super.dispose();
  }

  Future<void> _saveCaregiver() async {
    if (!_caregiverForm.currentState!.validate()) return;
    setState(() => _busy = true);
    final ok = await runGuarded(context, () async {
      final repo = ref.read(caregiverRepositoryProvider);
      final id = await repo.createPerson(
        fullName: _name.text,
        phone: _phone.text,
        preferredLanguage: ref.read(localeProvider).languageCode,
      );
      await repo.setDeviceCaregiver(id);
    });
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) _step = 2;
    });
  }

  Future<void> _savePatient() async {
    if (!_isSelf && !_patientForm.currentState!.validate()) return;
    final settings = await ref.read(settingsRepositoryProvider).load();
    final device = settings.devicePersonId;
    if (device == null || !mounted) return;
    setState(() => _busy = true);
    await runGuarded(context, () async {
      final person =
          await ref.read(caregiverRepositoryProvider).getPerson(device);
      final id = await ref.read(patientRepositoryProvider).create(
            PatientInput(
              fullName: _isSelf ? person!.fullName : _patientName.text,
            ),
            existingPersonId: _isSelf ? device : null,
            caregiverPersonId: device,
            relationship: _relationship.text,
          );
      await ref
          .read(settingsRepositoryProvider)
          .set(SettingKeys.currentPatientId, id);
    });
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final hasIdentity = settings?.devicePersonId != null;
    final step = hasIdentity && _step < 2 ? 2 : _step;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: ReadableWidth(
          child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'en', label: Text(l10n.english)),
                      ButtonSegment(value: 'ar', label: Text(l10n.arabic)),
                    ],
                    selected: {locale.languageCode},
                    onSelectionChanged: (value) =>
                        ref.read(localeProvider.notifier).set(value.first),
                  ),
                ),
                const SizedBox(height: 32),
                const CircleAvatar(
                  radius: 44,
                  backgroundColor: BrandColors.blue,
                  child: Icon(Icons.medication, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? BrandColors.blue
                            : BrandColors.blueOnDark,
                      ),
                ),
                Text(
                  l10n.appTagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                if (step == 0) ..._welcome(),
                if (step == 1) ..._caregiver(),
                if (step == 2) ..._patient(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  List<Widget> _welcome() => [
        Text(
          context.l10n.welcomeTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(context.l10n.welcomeBody, textAlign: TextAlign.center),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => setState(() => _step = 1),
          child: Text(context.l10n.getStarted),
        ),
      ];

  List<Widget> _caregiver() {
    final l10n = context.l10n;
    return [
      Form(
        key: _caregiverForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.whoAreYou, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l10n.whoAreYouHint),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.yourName),
              validator: (v) => requiredText(v, l10n),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: '${l10n.phone} (${l10n.optional})',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _saveCaregiver,
              child: Text(l10n.continueAction),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _patient() {
    final l10n = context.l10n;
    return [
      Form(
        key: _patientForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.firstPatientTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  icon: const Icon(Icons.people_outline),
                  label: Text(l10n.patientIsSomeoneElse),
                ),
                ButtonSegment(
                  value: true,
                  icon: const Icon(Icons.person_outline),
                  label: Text(l10n.patientIsMe),
                ),
              ],
              selected: {_isSelf},
              onSelectionChanged: (value) =>
                  setState(() => _isSelf = value.first),
            ),
            const SizedBox(height: 16),
            if (!_isSelf) ...[
              TextFormField(
                controller: _patientName,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l10n.fullName),
                validator: (v) => requiredText(v, l10n),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _relationship,
                decoration: InputDecoration(labelText: l10n.relationshipLabel),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _savePatient,
              child: Text(l10n.continueAction),
            ),
          ],
        ),
      ),
    ];
  }
}
