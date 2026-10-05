import 'package:flutter/widgets.dart';

/// User-selectable text size (Settings → Font size). One central scale feeds
/// Flutter's own text scaling, so every screen follows it without any
/// widget hard-coding a larger font.
enum FontSizeOption {
  standard('standard', 1.0),
  medium('medium', 1.15),
  large('large', 1.3),
  larger('larger', 1.5),
  maximum('maximum', 1.75);

  const FontSizeOption(this.code, this.factor);

  final String code;

  /// Multiplier applied on top of the system font size.
  final double factor;

  static FontSizeOption fromCode(String? code) => FontSizeOption.values
      .firstWhere((o) => o.code == code, orElse: () => FontSizeOption.standard);
}

abstract final class AppTypography {
  /// Smallest effective text scale.
  static const minimumScale = 0.85;

  /// Largest effective text scale the layouts are built for (user choice
  /// combined with the phone's own accessibility font size).
  static const maximumScale = 2.2;

  /// Narrow phones cap earlier so buttons, cards and the navigation bar keep
  /// working.
  static const narrowMaximumScale = 1.9;
  static const narrowWidth = 360.0;

  /// The scale to apply: the phone's own text size times the in-app choice,
  /// kept inside the range the layouts support for this screen width.
  static double effectiveScale({
    required double systemScale,
    required FontSizeOption option,
    required double screenWidth,
  }) {
    final cap = screenWidth < narrowWidth ? narrowMaximumScale : maximumScale;
    return (systemScale * option.factor).clamp(minimumScale, cap).toDouble();
  }

  /// Replaces the ambient [MediaQueryData.textScaler] with the effective
  /// scale. Called once, above the whole app.
  static MediaQueryData apply(MediaQueryData data, FontSizeOption option) {
    final systemScale = data.textScaler.scale(14) / 14;
    final scale = effectiveScale(
      systemScale: systemScale,
      option: option,
      screenWidth: data.size.width,
    );
    return data.copyWith(textScaler: TextScaler.linear(scale));
  }
}
