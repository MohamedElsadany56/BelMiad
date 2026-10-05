import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../domain/strip_model.dart';

/// Above this many positions a strip stops being drawn tablet by tablet and
/// switches to a compact bar with a "use one" button.
const maxInteractiveStripCells = 40;

/// A blister strip: one position per tablet/capsule of the strip in use.
/// Remaining units are filled, used ones are empty; tapping a remaining one
/// asks the owner to consume one unit.
///
/// Purely presentational. The owner computes [state] from the persisted
/// inventory and performs the consumption, so this widget is never the
/// source of truth.
class MedStrip extends StatelessWidget {
  const MedStrip({
    required this.state,
    required this.unitLabel,
    required this.onConsume,
    this.lowStock = false,
    this.enabled = true,
    this.busy = false,
    this.disabledMessage,
    super.key,
  });

  final StripState state;

  /// Localized unit name for the strip, already singular/plural as needed.
  final String unitLabel;

  /// Called when a remaining unit is tapped. Null disables interaction.
  final VoidCallback? onConsume;

  /// Remaining units use the warning colour.
  final bool lowStock;

  /// False for expired or deleted stock: shown greyed out.
  final bool enabled;

  /// A consumption is being saved; taps are ignored until it completes.
  final bool busy;

  /// Explains why the strip is disabled.
  final String? disabledMessage;

  bool get _interactive =>
      enabled && !busy && onConsume != null && state.remaining > 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final compact = state.capacity > maxInteractiveStripCells;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              l10n.stripRemaining(
                state.remaining,
                state.capacity,
                unitLabel,
              ),
              style: theme.textTheme.titleSmall,
            ),
            if (state.extraFullStrips > 0)
              Text(
                l10n.stripExtra(state.extraFullStrips),
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (compact)
          _CompactStrip(
            state: state,
            lowStock: lowStock,
            enabled: enabled,
            onConsume: _interactive ? onConsume : null,
          )
        else
          _CellStrip(
            state: state,
            lowStock: lowStock,
            enabled: enabled,
            onConsume: _interactive ? onConsume : null,
          ),
        if (!enabled && disabledMessage != null) ...[
          const SizedBox(height: 4),
          Text(disabledMessage!, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}

Color _remainingColor(BuildContext context, bool lowStock, bool enabled) {
  final scheme = Theme.of(context).colorScheme;
  if (!enabled) return scheme.onSurface.withValues(alpha: 0.28);
  return lowStock ? context.statusColors.warning : scheme.primary;
}

class _CellStrip extends StatelessWidget {
  const _CellStrip({
    required this.state,
    required this.lowStock,
    required this.enabled,
    required this.onConsume,
  });

  final StripState state;
  final bool lowStock;
  final bool enabled;
  final VoidCallback? onConsume;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Cells grow a little with the font size so they stay easy to hit, and
    // the Wrap flows onto more rows instead of overflowing.
    final size = MediaQuery.textScalerOf(context).scale(36).clamp(36.0, 52.0);
    final fill = _remainingColor(context, lowStock, enabled);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < state.capacity; i++)
          _Cell(
            // Used positions come first, like pushing tablets out in order.
            used: i < state.consumed,
            size: size,
            fill: fill,
            label: i < state.consumed
                ? l10n.stripCellUsed(i + 1, state.capacity)
                : l10n.stripCellRemaining(i + 1, state.capacity),
            onTap: i < state.consumed ? null : onConsume,
          ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.used,
    required this.size,
    required this.fill,
    required this.label,
    required this.onTap,
  });

  final bool used;
  final double size;
  final Color fill;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: label,
      button: !used,
      enabled: onTap != null,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: used ? scheme.surfaceContainerHighest : fill,
              border: Border.all(
                color: used ? scheme.outlineVariant : fill,
                width: 1.5,
              ),
            ),
            child: used
                ? null
                : Container(
                    width: size * 0.34,
                    height: size * 0.34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.38),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CompactStrip extends StatelessWidget {
  const _CompactStrip({
    required this.state,
    required this.lowStock,
    required this.enabled,
    required this.onConsume,
  });

  final StripState state;
  final bool lowStock;
  final bool enabled;
  final VoidCallback? onConsume;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:
                  (state.remaining / state.capacity).clamp(0.0, 1.0).toDouble(),
              minHeight: 12,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                _remainingColor(context, lowStock, enabled),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonal(
          onPressed: onConsume,
          child: Text(l10n.stripUseOne),
        ),
      ],
    );
  }
}
