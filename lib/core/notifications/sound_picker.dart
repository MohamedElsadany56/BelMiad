import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'reminder_sound.dart';

/// Picks and previews reminder sounds through the Android host
/// (`MainActivity`, channel `belmiad/sounds`). Other platforms play the
/// system notification sound, so only "default" and "silent" apply there.
class SoundPicker {
  const SoundPicker();

  static const _channel = MethodChannel('belmiad/sounds');

  /// Whether custom tones and phone ringtones can be used.
  static bool get supportsCustomSounds =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Opens the phone's sound picker. Returns null when cancelled.
  Future<ReminderSound?> pickFromPhone({
    ReminderSound? current,
    String? title,
  }) async {
    if (!supportsCustomSounds) return null;
    try {
      final picked = await _channel.invokeMapMethod<String, Object?>('pick', {
        if (current?.kind == ReminderSoundKind.device)
          'current': current!.value,
        'title': title,
      });
      final uri = picked?['uri'] as String?;
      if (uri == null || uri.isEmpty) return null;
      return ReminderSound.device(uri: uri, title: picked?['title'] as String?);
    } on PlatformException catch (error) {
      debugPrint('Sound picker unavailable: $error');
      return null;
    }
  }

  /// Plays a short preview of [sound]; silent does nothing.
  Future<void> preview(ReminderSound sound) async {
    if (!supportsCustomSounds || sound.kind == ReminderSoundKind.silent) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('play', {
        'kind': sound.kind.name,
        'value': sound.value,
      });
    } on PlatformException catch (error) {
      debugPrint('Sound preview failed: $error');
    }
  }

  Future<void> stop() async {
    if (!supportsCustomSounds) return;
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException catch (_) {}
  }
}
