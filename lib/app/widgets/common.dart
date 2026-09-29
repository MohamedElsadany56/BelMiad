import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            if (trailing != null) trailing!,
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
          Text(
            label,
            style:
                TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
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
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: Text(
                current.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
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
