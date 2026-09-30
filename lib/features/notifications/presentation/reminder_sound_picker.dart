import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/notifications/reminder_sound.dart';
import '../../../core/notifications/sound_picker.dart';
import '../../../l10n/app_localizations.dart';

String reminderSoundLabel(ReminderSound sound, AppLocalizations l10n) =>
    switch (sound.kind) {
      ReminderSoundKind.systemDefault => l10n.soundDefault,
      ReminderSoundKind.silent => l10n.soundSilent,
      ReminderSoundKind.device => sound.title ?? l10n.soundPhonePicked,
      ReminderSoundKind.builtIn => builtInToneLabel(sound.tone!, l10n),
    };

String builtInToneLabel(BuiltInTone tone, AppLocalizations l10n) =>
    switch (tone) {
      BuiltInTone.chime => l10n.soundChime,
      BuiltInTone.bell => l10n.soundBell,
      BuiltInTone.gentle => l10n.soundGentle,
      BuiltInTone.alert => l10n.soundAlert,
    };

/// Settings row showing the current reminder sound.
class ReminderSoundTile extends ConsumerWidget {
  const ReminderSoundTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sound = ref.watch(reminderSoundProvider);
    return ListTile(
      leading: Icon(
        sound.kind == ReminderSoundKind.silent
            ? Icons.notifications_off_outlined
            : Icons.music_note_outlined,
      ),
      title: Text(l10n.reminderSound),
      subtitle: Text(reminderSoundLabel(sound, l10n)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showReminderSoundSheet(context),
    );
  }
}

Future<void> showReminderSoundSheet(BuildContext context) async {
  const player = SoundPicker();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _ReminderSoundSheet(player: player),
  );
  await player.stop();
}

class _ReminderSoundSheet extends ConsumerWidget {
  const _ReminderSoundSheet({required this.player});

  final SoundPicker player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(reminderSoundProvider);
    final controller = ref.read(reminderSoundProvider.notifier);
    final custom = SoundPicker.supportsCustomSounds;

    Future<void> choose(ReminderSound sound) async {
      await controller.set(sound);
      await player.preview(sound);
    }

    Widget option({
      required ReminderSound sound,
      required String label,
      required IconData icon,
      String? subtitle,
      bool selected = false,
      VoidCallback? onTap,
    }) =>
        ListTile(
          leading: Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? Theme.of(context).colorScheme.primary : null,
          ),
          title: Text(label),
          subtitle: subtitle == null ? null : Text(subtitle),
          selected: selected,
          onTap: onTap ?? () => choose(sound),
          trailing: custom &&
                  sound.kind != ReminderSoundKind.silent &&
                  (sound.value?.isNotEmpty ?? true)
              ? IconButton(
                  tooltip: l10n.soundPreview,
                  icon: Icon(icon),
                  onPressed: () => player.preview(sound),
                )
              : null,
        );

    final picked = current.kind == ReminderSoundKind.device ? current : null;
    return SafeArea(
      child: ReadableWidth(
        maxWidth: 640,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l10n.reminderSound,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
              child: Text(
                l10n.reminderSoundHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            option(
              sound: const ReminderSound.systemDefault(),
              label: l10n.soundDefault,
              icon: Icons.play_arrow,
              selected: current.kind == ReminderSoundKind.systemDefault,
            ),
            if (custom) ...[
              for (final tone in BuiltInTone.values)
                option(
                  sound: ReminderSound.builtIn(tone),
                  label: builtInToneLabel(tone, l10n),
                  icon: Icons.play_arrow,
                  selected: current.tone == tone,
                ),
              option(
                sound:
                    picked ?? const ReminderSound.device(uri: '', title: null),
                label: l10n.soundFromPhone,
                subtitle:
                    picked == null ? null : reminderSoundLabel(picked, l10n),
                icon: Icons.play_arrow,
                selected: picked != null,
                onTap: () async {
                  await player.stop();
                  final chosen = await player.pickFromPhone(
                    current: current,
                    title: l10n.reminderSound,
                  );
                  if (chosen != null) await controller.set(chosen);
                },
              ),
            ],
            option(
              sound: const ReminderSound.silent(),
              label: l10n.soundSilent,
              icon: Icons.play_arrow,
              selected: current.kind == ReminderSoundKind.silent,
            ),
            if (!custom)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Text(
                  l10n.soundCustomAndroidOnly,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
