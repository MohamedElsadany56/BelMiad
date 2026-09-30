import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/settings/settings_repository.dart';
import '../../notifications/presentation/reminder_sound_picker.dart';

final _catalogCountProvider = FutureProvider<int>(
  (ref) => ref.watch(catalogRepositoryProvider).count(),
);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const AppSettingsData();
    final repo = ref.read(settingsRepositoryProvider);
    final persons = ref.watch(_personsProvider).valueOrNull ?? const [];
    final catalogCount = ref.watch(_catalogCountProvider).valueOrNull;

    Future<void> setInt(String key, int value) async {
      await repo.set(key, '$value');
      ref.read(syncCoordinatorProvider).request();
    }

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(l10n.settings)),
      body: ReadableWidth(
          child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SectionHeader(l10n.language),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'en', label: Text(l10n.english)),
                ButtonSegment(value: 'ar', label: Text(l10n.arabic)),
              ],
              selected: {locale.languageCode},
              onSelectionChanged: (v) =>
                  ref.read(localeProvider.notifier).set(v.first),
            ),
          ),
          SectionHeader(l10n.theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_outlined),
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_outlined),
                  label: Text(l10n.themeDark),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto_outlined),
                  label: Text(l10n.themeSystem),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (v) =>
                  ref.read(themeModeProvider.notifier).set(v.first),
            ),
          ),
          SectionHeader(l10n.notifications),
          const ReminderSoundTile(),
          SectionHeader(l10n.deviceCaregiver),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue:
                  persons.any((p) => p.personId == settings.devicePersonId)
                      ? settings.devicePersonId
                      : null,
              decoration: InputDecoration(
                labelText: l10n.changeCaregiver,
                helperText: l10n.whoAreYouHint,
              ),
              items: [
                for (final p in persons)
                  DropdownMenuItem(value: p.personId, child: Text(p.fullName)),
                DropdownMenuItem(value: '_new', child: Text(l10n.newPerson)),
              ],
              onChanged: (value) async {
                if (value == null) return;
                final caregivers = ref.read(caregiverRepositoryProvider);
                var id = value;
                if (value == '_new') {
                  final name = await _askName(context);
                  if (name == null) return;
                  id = await caregivers.createPerson(fullName: name);
                }
                await caregivers.setDeviceCaregiver(id);
                final person = await caregivers.getPerson(id);
                if (context.mounted && person != null) {
                  showMessage(context, l10n.caregiverSwitched(person.fullName));
                }
              },
            ),
          ),
          SectionHeader(l10n.expiryThreshold),
          _ChoiceRow(
            values: const [7, 14, 30, 60, 90],
            selected: settings.expiringWithinDays,
            label: (v) => l10n.daysCount(v),
            onSelected: (v) => setInt(SettingKeys.expiringWithinDays, v),
          ),
          SectionHeader(l10n.missedGrace),
          _ChoiceRow(
            values: const [60, 120, 180, 240, 360],
            selected: settings.missedGraceMinutes,
            label: (v) =>
                v % 60 == 0 ? l10n.hoursCount(v ~/ 60) : l10n.minutesCount(v),
            onSelected: (v) => setInt(SettingKeys.missedGraceMinutes, v),
          ),
          SectionHeader(l10n.inactivityReset),
          _ChoiceRow(
            values: const [0, 2, 5, 10, 15, 30],
            selected: settings.inactivityMinutes,
            label: (v) => v == 0 ? l10n.off : l10n.minutesCount(v),
            onSelected: (v) => setInt(SettingKeys.inactivityMinutes, v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.inactivityResetNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SectionHeader(l10n.about),
          ListTile(
            leading: const Icon(Icons.offline_bolt_outlined),
            title: Text(l10n.aboutBody),
          ),
          if (catalogCount != null)
            ListTile(
              leading: const Icon(Icons.local_pharmacy_outlined),
              title: Text(l10n.catalogEntries(catalogCount)),
            ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version('1.0.0')),
          ),
        ],
      )),
    );
  }

  Future<String?> _askName(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.newPerson),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.fullName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
  }
}

final _personsProvider = StreamProvider(
  (ref) => ref.watch(caregiverRepositoryProvider).watchPersons(),
);

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final List<int> values;
  final int selected;
  final String Function(int) label;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final v in values)
              ChoiceChip(
                label: Text(label(v)),
                selected: v == selected,
                onSelected: (_) => onSelected(v),
              ),
          ],
        ),
      );
}
