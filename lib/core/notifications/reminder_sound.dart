import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Where the dose reminder sound comes from.
enum ReminderSoundKind {
  /// The phone's default notification sound.
  systemDefault,

  /// A tone bundled with the app (Android `res/raw`).
  builtIn,

  /// A ringtone or notification sound picked from the phone.
  device,

  /// No sound: the reminder still pops up and vibrates.
  silent,
}

/// Tones bundled in `android/app/src/main/res/raw`.
enum BuiltInTone {
  chime('belmiad_chime'),
  bell('belmiad_bell'),
  gentle('belmiad_gentle'),
  alert('belmiad_alert');

  const BuiltInTone(this.resource);

  /// Android raw resource name (file name without extension).
  final String resource;

  static BuiltInTone? byResource(String? name) {
    for (final tone in values) {
      if (tone.resource == name) return tone;
    }
    return null;
  }
}

/// The sound played by dose reminders and missed-dose alerts. It belongs to
/// the phone, not to a patient, so it is kept in shared preferences where the
/// background notification handler can read it too.
class ReminderSound {
  const ReminderSound._(this.kind, {this.value, this.title});

  const ReminderSound.systemDefault() : this._(ReminderSoundKind.systemDefault);

  const ReminderSound.silent() : this._(ReminderSoundKind.silent);

  ReminderSound.builtIn(BuiltInTone tone)
      : this._(ReminderSoundKind.builtIn, value: tone.resource);

  /// A sound picked from the phone, identified by its content URI.
  const ReminderSound.device({required String uri, String? title})
      : this._(ReminderSoundKind.device, value: uri, title: title);

  final ReminderSoundKind kind;

  /// Raw resource name for [ReminderSoundKind.builtIn], content URI for
  /// [ReminderSoundKind.device].
  final String? value;

  /// Display name of a sound picked from the phone.
  final String? title;

  static const preferenceKey = 'reminder_sound';

  BuiltInTone? get tone =>
      kind == ReminderSoundKind.builtIn ? BuiltInTone.byResource(value) : null;

  /// Stable identifier. Android fixes a channel's sound when the channel is
  /// created, so each sound gets its own channel named after this key.
  String get key => switch (kind) {
        ReminderSoundKind.systemDefault => 'default',
        ReminderSoundKind.silent => 'silent',
        ReminderSoundKind.builtIn => value!,
        ReminderSoundKind.device => 'device_${_hash(value ?? '')}',
      };

  String encode() => jsonEncode({
        'kind': kind.name,
        if (value != null) 'value': value,
        if (title != null) 'title': title,
      });

  static ReminderSound decode(String? raw) {
    if (raw == null || raw.isEmpty) return const ReminderSound.systemDefault();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final kind = ReminderSoundKind.values.byName(map['kind'] as String);
      final value = map['value'] as String?;
      return switch (kind) {
        ReminderSoundKind.systemDefault => const ReminderSound.systemDefault(),
        ReminderSoundKind.silent => const ReminderSound.silent(),
        ReminderSoundKind.builtIn => BuiltInTone.byResource(value) == null
            ? const ReminderSound.systemDefault()
            : ReminderSound.builtIn(BuiltInTone.byResource(value)!),
        ReminderSoundKind.device => value == null || value.isEmpty
            ? const ReminderSound.systemDefault()
            : ReminderSound.device(uri: value, title: map['title'] as String?),
      };
    } catch (_) {
      return const ReminderSound.systemDefault();
    }
  }

  static ReminderSound read(SharedPreferences prefs) =>
      decode(prefs.getString(preferenceKey));

  Future<void> save(SharedPreferences prefs) =>
      prefs.setString(preferenceKey, encode());

  @override
  bool operator ==(Object other) =>
      other is ReminderSound && other.kind == kind && other.value == value;

  @override
  int get hashCode => Object.hash(kind, value);

  static String _hash(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }
}
