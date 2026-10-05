import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../domain/strip_model.dart';
import 'blister_grid.dart';

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
class MedStrip extends StatefulWidget {
  const MedStrip({
    required this.state,
    required this.unitLabel,
    required this.onConsume,
    this.capsule = false,
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

  /// Draw capsules instead of round tablets.
  final bool capsule;

  /// Remaining units use the warning colour.
  final bool lowStock;

  /// False for expired or deleted stock: shown greyed out.
  final bool enabled;

  /// A consumption is being saved; taps are ignored until it completes.
  final bool busy;

  /// Explains why the strip is disabled.
  final String? disabledMessage;

  @override
  State<MedStrip> createState() => _MedStripState();
}

class _MedStripState extends State<MedStrip> {
  /// Which pockets are empty. The count always follows the database; only
  /// *which* pocket empties is local, so the tablet you touch is the one
  /// that disappears.
  late Set<int> _used = _canonical();

  Set<int> _canonical() => {for (var i = 0; i < widget.state.consumed; i++) i};

  bool get _interactive =>
      widget.enabled &&
      !widget.busy &&
      widget.onConsume != null &&
      widget.state.remaining > 0;

  Timer? _reconcile;

  @override
  void dispose() {
    _reconcile?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(MedStrip old) {
    super.didUpdateWidget(old);
    final consumed = widget.state.consumed;
    if (_used.length < consumed) {
      // Stock was used elsewhere: just follow the database.
      _used = _canonical();
    } else if (_used.length > consumed && !widget.busy) {
      // The picture is ahead of the database. Give the stream a moment to
      // catch up; if it never does (the save failed) fall back to it.
      _reconcile?.cancel();
      _reconcile = Timer(const Duration(milliseconds: 800), () {
        if (mounted && _used.length != widget.state.consumed) {
          setState(() => _used = _canonical());
        }
      });
    }
  }

  void _tap(int index) {
    if (!_interactive || _used.contains(index)) return;
    setState(() => _used = {..._used, index});
    widget.onConsume!();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final state = widget.state;
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
                widget.unitLabel,
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
            lowStock: widget.lowStock,
            enabled: widget.enabled,
            onConsume: _interactive ? widget.onConsume : null,
          )
        else
          BlisterGrid(
            capacity: state.capacity,
            used: _used,
            capsule: widget.capsule,
            pillColor: _remainingColor(
              context,
              widget.lowStock,
              widget.enabled,
            ),
            labelFor: (i, used) => used
                ? l10n.stripCellUsed(i + 1, state.capacity)
                : l10n.stripCellRemaining(i + 1, state.capacity),
            onTapCell: _interactive ? _tap : null,
          ),
        if (!widget.enabled && widget.disabledMessage != null) ...[
          const SizedBox(height: 4),
          Text(widget.disabledMessage!, style: theme.textTheme.bodySmall),
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
