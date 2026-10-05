import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../core/time/local_date.dart';
import '../../core/utilities/scaled_quantity.dart';
import '../../l10n/app_localizations.dart';
import '../localization/labels.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isArabic => AppLocalizations.of(this).localeName == 'ar';
  String get localeName => AppLocalizations.of(this).localeName;
}

String formatIsoDate(BuildContext context, String? iso) {
  final date = LocalDate.tryParse(iso);
  if (date == null) return context.l10n.notSet;
  return DateFormat.yMMMd(context.localeName).format(date.toDateTime());
}

String formatDateTime(BuildContext context, DateTime local) =>
    DateFormat.yMMMd(context.localeName).add_jm().format(local);

String formatClock(BuildContext context, DateTime local) =>
    DateFormat.jm(context.localeName).format(local);

String formatHHmm(BuildContext context, String? hhmm) {
  final time = LocalTime.tryParse(hhmm);
  if (time == null) return context.l10n.notSet;
  return DateFormat.jm(context.localeName)
      .format(DateTime(2000, 1, 1, time.hour, time.minute));
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void showError(BuildContext context, Object error) {
  final colors = context.statusColors;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: colors.dangerContainer,
        content: Text(
          errorMessage(error, context.l10n),
          style: TextStyle(color: colors.danger),
        ),
      ),
    );
}

/// Runs [action], reporting domain errors as a snack bar. Returns true on
/// success.
Future<bool> runGuarded(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (context.mounted && success != null) showMessage(context, success);
    return true;
  } catch (error) {
    if (context.mounted) showError(context, error);
    return false;
  }
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  String? confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel ?? context.l10n.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: context.statusColors.danger,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel ?? context.l10n.confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({required this.value, required this.builder, super.key});

  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) => value.when(
        data: builder,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorMessage(error, context.l10n),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: scheme.primaryContainer,
              child: Icon(icon, size: 36, color: scheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.title, {
    this.trailing,
    this.padding = const EdgeInsetsDirectional.fromSTEB(16, 20, 8, 8),
    super.key,
  });

  final String title;
  final Widget? trailing;

  /// Defaults to the inset used on full-width lists; pass a smaller start
  /// inset inside lists that already have their own side padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: MixedText(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      );
}

enum BadgeTone { success, warning, danger, neutral, brand }

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.label,
      {this.tone = BadgeTone.neutral, this.icon, super.key});

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;
    final scheme = Theme.of(context).colorScheme;
    final (fg, bg) = switch (tone) {
      BadgeTone.success => (colors.success, colors.successContainer),
      BadgeTone.warning => (colors.warning, colors.warningContainer),
      BadgeTone.danger => (colors.danger, colors.dangerContainer),
      BadgeTone.neutral => (colors.neutral, colors.neutralContainer),
      BadgeTone.brand => (
          scheme.brightness == Brightness.light
              ? BrandColors.blue
              : BrandColors.blueOnDark,
          scheme.primaryContainer,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date form field storing an ISO `yyyy-MM-dd` string.
class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.clearable = true,
    super.key,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool clearable;

  @override
  Widget build(BuildContext context) {
    final date = LocalDate.tryParse(value);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date?.toDateTime() ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
        );
        if (picked != null) onChanged(LocalDate.fromDateTime(picked).toIso());
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.event_outlined),
          suffixIcon: clearable && date != null
              ? IconButton(
                  tooltip: context.l10n.delete,
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                )
              : null,
        ),
        child: Text(
            date == null ? context.l10n.notSet : formatIsoDate(context, value)),
      ),
    );
  }
}

/// Time form field storing a wall-clock `HH:mm` string.
class TimeField extends StatelessWidget {
  const TimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final time = LocalTime.tryParse(value);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: time?.hour ?? 8,
            minute: time?.minute ?? 0,
          ),
        );
        if (picked != null) {
          onChanged(LocalTime(picked.hour, picked.minute).toHHmm());
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.schedule),
        ),
        child: Text(formatHHmm(context, value)),
      ),
    );
  }
}

/// Picks a local date and time; returns a local `DateTime`.
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

String? validateQuantity(
  String? text,
  AppLocalizations l10n, {
  bool allowZero = false,
  bool required = true,
}) {
  if (text == null || text.trim().isEmpty) {
    return required ? l10n.error_quantityRequired : null;
  }
  final quantity = ScaledQuantity.tryParse(text);
  if (quantity == null) return l10n.error_invalidQuantity;
  if (!allowZero && quantity.isZero) return l10n.error_quantityRequired;
  return null;
}

String? requiredText(String? text, AppLocalizations l10n) =>
    text == null || text.trim().isEmpty ? l10n.error_nameRequired : null;

/// App bar action showing the current patient with a quick switcher.
class PatientSwitcher extends ConsumerWidget {
  const PatientSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final current = ref.watch(currentPatientProvider);
    if (current == null) return const SizedBox.shrink();
    final compact = MediaQuery.sizeOf(context).width /
            MediaQuery.textScalerOf(context).scale(1) <
        340;
    return PopupMenuButton<String>(
      tooltip: context.l10n.switchPatient,
      onSelected: (id) {
        if (id == '_manage') {
          context.push('/more/patients');
        } else {
          selectCurrentPatient(ref, id);
        }
      },
      itemBuilder: (context) => [
        for (final p in patients)
          CheckedPopupMenuItem(
            value: p.id,
            checked: p.id == current.id,
            child: Text(p.name),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: '_manage',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.group_outlined),
            title: Text(context.l10n.patients),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Text(
                current.name.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: BrandColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            // Narrow screens or large fonts: the avatar initial is enough,
            // leaving room for the screen title.
            if (!compact) ...[
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 110),
                child: Text(
                  current.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

/// Wraps a screen that needs a current patient.
class RequirePatient extends ConsumerWidget {
  const RequirePatient({required this.builder, super.key});

  final Widget Function(String patientId) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(currentPatientIdProvider);
    if (id == null) {
      return EmptyState(
        icon: Icons.person_add_alt_1_outlined,
        message: context.l10n.noPatientSelected,
        action: FilledButton.icon(
          onPressed: () => context.push('/more/patients/new'),
          icon: const Icon(Icons.add),
          label: Text(context.l10n.addPatient),
        ),
      );
    }
    return builder(id);
  }
}

/// A padded, width-constrained form body.
class FormBody extends StatelessWidget {
  const FormBody({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              for (final child in children)
                Padding(
                    padding: const EdgeInsets.only(bottom: 12), child: child),
            ],
          ),
        ),
      );
}

/// App bar title that never hides words on narrow phones or with large
/// system fonts: it first shrinks, then wraps onto a second line.
class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final base = DefaultTextStyle.of(context).style;
          final baseSize = base.fontSize ?? 22;
          final scaler = MediaQuery.textScalerOf(context);
          final direction = Directionality.of(context);
          bool fits(TextStyle style, int lines) {
            final painter = TextPainter(
              text: TextSpan(text: text, style: style),
              maxLines: lines,
              textDirection: direction,
              textScaler: scaler,
            )..layout(maxWidth: constraints.maxWidth);
            final ok = !painter.didExceedMaxLines &&
                painter.height <= constraints.maxHeight;
            painter.dispose();
            return ok;
          }

          const candidates = [(1.0, 1), (0.85, 1), (0.75, 2), (0.65, 2)];
          for (final (factor, lines) in candidates) {
            final style = base.copyWith(
              fontSize: baseSize * factor,
              height: lines > 1 ? 1.15 : null,
            );
            if (fits(style, lines)) {
              return Text(
                text,
                style: style,
                maxLines: lines,
                softWrap: lines > 1,
              );
            }
          }
          return Text(
            text,
            style: base.copyWith(fontSize: baseSize * 0.65, height: 1.15),
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          );
        },
      );
}

/// Screen widths used to adapt layouts from phones to tablets.
abstract final class Breakpoints {
  /// Side navigation instead of the bottom bar.
  static const rail = 600.0;

  /// Navigation rail with labels next to the icons.
  static const extendedRail = 1000.0;

  /// Widest a column of content gets, so lines stay easy to read.
  static const content = 840.0;
}

/// Centers content and caps its width on tablets and landscape screens.
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({
    required this.child,
    this.maxWidth = Breakpoints.content,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
}

/// Tab bar for blue app bars: tabs share the width evenly when every label
/// fits, and scroll (starting at the edge) when they would be cut off.
class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({required this.tabs, this.controller, super.key});

  /// Icon (optional) and label of each tab.
  final List<(IconData?, String)> tabs;
  final TabController? controller;

  bool get _hasIcons => tabs.any((t) => t.$1 != null);

  @override
  Size get preferredSize => Size.fromHeight(_hasIcons ? 72 : 46);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final theme = Theme.of(context);
          final style = theme.tabBarTheme.labelStyle ??
              theme.textTheme.titleSmall ??
              const TextStyle(fontSize: 14);
          final scaler = MediaQuery.textScalerOf(context);
          var widest = 0.0;
          for (final (_, label) in tabs) {
            final painter = TextPainter(
              text: TextSpan(text: label, style: style),
              textDirection: Directionality.of(context),
              textScaler: scaler,
              maxLines: 1,
            )..layout();
            if (painter.width > widest) widest = painter.width;
            painter.dispose();
          }
          // 16 px label padding on each side of every tab.
          final fits = widest + 32 <= constraints.maxWidth / tabs.length;
          return TabBar(
            controller: controller,
            isScrollable: !fits,
            tabAlignment: fits ? TabAlignment.fill : TabAlignment.start,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              for (final (icon, label) in tabs)
                Tab(icon: icon == null ? null : Icon(icon), text: label),
            ],
          );
        },
      );
}

/// Direction of [text] from its first letter, so English (or "500 mg") shown
/// inside the Arabic interface keeps its word order and punctuation.
TextDirection? contentDirection(String text) {
  for (final rune in text.runes) {
    final isArabic = (rune >= 0x0600 && rune <= 0x06FF) ||
        (rune >= 0x0750 && rune <= 0x077F) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF);
    if (isArabic) return TextDirection.rtl;
    final isLatin = (rune >= 0x41 && rune <= 0x5A) ||
        (rune >= 0x61 && rune <= 0x7A) ||
        (rune >= 0xC0 && rune <= 0x24F);
    if (isLatin) return TextDirection.ltr;
  }
  return null;
}

/// Text that keeps its own reading direction but lines up with the rest of
/// the screen (right in Arabic, left in English).
class MixedText extends StatelessWidget {
  const MixedText(this.text, {this.style, super.key});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final screen = Directionality.of(context);
    return Text(
      text,
      style: style,
      textDirection: contentDirection(text) ?? screen,
      textAlign: screen == TextDirection.rtl ? TextAlign.right : TextAlign.left,
    );
  }
}
