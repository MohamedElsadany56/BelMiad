import 'package:flutter/material.dart';

/// Brand palette: BelMiad blue (#0064F6) on white.
abstract final class BrandColors {
  static const blue = Color(0xFF0064F6);
  static const blueDark = Color(0xFF004BB8);
  static const blueLight = Color(0xFFE6F0FF);
  static const blueOnDark = Color(0xFF7DB0FF);
  static const white = Colors.white;

  static const success = Color(0xFF12805C);
  static const warning = Color(0xFFB45309);
  static const danger = Color(0xFFC62828);
}

/// Semantic status colors that adapt to light/dark mode.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.neutral,
    required this.neutralContainer,
  });

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color danger;
  final Color dangerContainer;
  final Color neutral;
  final Color neutralContainer;

  static const light = StatusColors(
    success: BrandColors.success,
    successContainer: Color(0xFFE3F5EE),
    warning: BrandColors.warning,
    warningContainer: Color(0xFFFFF1DB),
    danger: BrandColors.danger,
    dangerContainer: Color(0xFFFDE7E7),
    neutral: Color(0xFF5B6475),
    neutralContainer: Color(0xFFF0F2F6),
  );

  static const dark = StatusColors(
    success: Color(0xFF5FD3A5),
    successContainer: Color(0xFF123A2C),
    warning: Color(0xFFF5B85C),
    warningContainer: Color(0xFF3F2B0D),
    danger: Color(0xFFFF8A80),
    dangerContainer: Color(0xFF4A1616),
    neutral: Color(0xFFA9B2C3),
    neutralContainer: Color(0xFF232A36),
  );

  @override
  StatusColors copyWith() => this;

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) =>
      t < 0.5 ? this : (other as StatusColors? ?? this);
}

extension StatusColorsX on BuildContext {
  StatusColors get statusColors =>
      Theme.of(this).extension<StatusColors>() ?? StatusColors.light;
}

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: BrandColors.blue,
      brightness: Brightness.light,
    ).copyWith(
      primary: BrandColors.blue,
      onPrimary: BrandColors.white,
      primaryContainer: BrandColors.blueLight,
      onPrimaryContainer: const Color(0xFF002A6B),
      secondary: BrandColors.blueDark,
      onSecondary: BrandColors.white,
      tertiary: BrandColors.blueDark,
      onTertiary: BrandColors.white,
      tertiaryContainer: BrandColors.blueLight,
      onTertiaryContainer: const Color(0xFF002A6B),
      surface: BrandColors.white,
      onSurface: const Color(0xFF111827),
      surfaceContainerLowest: BrandColors.white,
      surfaceContainerLow: const Color(0xFFF7F9FC),
      surfaceContainer: const Color(0xFFF2F5FA),
      surfaceContainerHigh: const Color(0xFFECF0F7),
      surfaceContainerHighest: const Color(0xFFE5EAF3),
      outlineVariant: const Color(0xFFDDE3EE),
      error: BrandColors.danger,
    );
    return _build(scheme, StatusColors.light).copyWith(
      scaffoldBackgroundColor: BrandColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: BrandColors.blue,
        foregroundColor: BrandColors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: BrandColors.blue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: BrandColors.blue,
      onPrimary: BrandColors.white,
      primaryContainer: const Color(0xFF0B2E66),
      onPrimaryContainer: const Color(0xFFD6E5FF),
      secondary: BrandColors.blueOnDark,
      onSecondary: const Color(0xFF001A43),
      tertiary: BrandColors.blueOnDark,
      onTertiary: const Color(0xFF001A43),
      tertiaryContainer: const Color(0xFF0B2E66),
      onTertiaryContainer: const Color(0xFFD6E5FF),
      surface: const Color(0xFF0F141C),
      onSurface: const Color(0xFFE7ECF4),
      surfaceContainerLowest: const Color(0xFF0B0F15),
      surfaceContainerLow: const Color(0xFF151B25),
      surfaceContainer: const Color(0xFF19202B),
      surfaceContainerHigh: const Color(0xFF202834),
      surfaceContainerHighest: const Color(0xFF28313E),
      outlineVariant: const Color(0xFF2E3846),
      error: const Color(0xFFFF8A80),
    );
    final base = _build(scheme, StatusColors.dark);
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainerLow,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: BrandColors.blueOnDark),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.blueOnDark,
          side: const BorderSide(color: BrandColors.blueOnDark),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData _build(ColorScheme scheme, StatusColors status) {
    final radius = BorderRadius.circular(12);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // Bundled Arabic-capable font so Arabic renders fully offline.
      fontFamilyFallback: const ['NotoNaskhArabic'],
      extensions: [status],
      visualDensity: VisualDensity.standard,
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLowest,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandColors.blue,
          foregroundColor: BrandColors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BrandColors.blue,
        foregroundColor: BrandColors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: BrandColors.blue,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? BrandColors.white
                : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? (scheme.brightness == Brightness.light
                    ? BrandColors.blue
                    : BrandColors.blueOnDark)
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: BrandColors.blue, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? BrandColors.blue : null,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? BrandColors.white
                : null,
          ),
          iconColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? BrandColors.white
                : null,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? BrandColors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? BrandColors.blue : null,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      snackBarTheme:
          const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
