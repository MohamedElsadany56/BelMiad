import 'dart:math' as math;

import 'package:flutter/material.dart';

/// How a unit is drawn inside its pocket.
enum PillShape { tablet, capsule }

/// What a pocket holds.
enum PocketState { full, half, empty }

/// Colours of one medication's tablets or capsules.
class PillLook {
  const PillLook(this.primary, this.secondary);

  /// Tablet colour, or the first half of a capsule.
  final Color primary;

  /// Second half of a capsule.
  final Color secondary;

  /// Greyed out (expired or deleted stock).
  PillLook get muted => const PillLook(Color(0xFFB7BEC9), Color(0xFFDCE0E6));

  static const _palette = [
    PillLook(Color(0xFF0064F6), Color(0xFFFFFFFF)),
    PillLook(Color(0xFFF59E0B), Color(0xFFEF4444)),
    PillLook(Color(0xFFF472B6), Color(0xFFFFFFFF)),
    PillLook(Color(0xFF22C55E), Color(0xFFFFFFFF)),
    PillLook(Color(0xFFFACC15), Color(0xFFEF4444)),
    PillLook(Color(0xFF38BDF8), Color(0xFFFFFFFF)),
  ];

  /// A stable colour for [seed] (a medication or batch id), so the same
  /// medicine always looks the same.
  static PillLook forSeed(String seed) {
    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return _palette[hash % _palette.length];
  }
}

/// Physical-looking blister pack: a foil card with one pocket per unit and
/// perforation lines. Remaining units show a tablet or capsule; used units
/// leave an empty, pressed-in pocket.
///
/// Adapts to the available width (pockets shrink on narrow screens, the
/// card never grows beyond a natural size) and is purely visual: the owner
/// decides which positions are used and what a tap does.
class BlisterGrid extends StatelessWidget {
  const BlisterGrid({
    required this.capacity,
    required this.used,
    required this.look,
    required this.labelFor,
    this.half = const {},
    this.shape = PillShape.tablet,
    this.onTapCell,
    this.tapUsed = false,
    super.key,
  });

  final int capacity;

  /// Zero-based positions that are already empty.
  final Set<int> used;

  /// Positions holding half a tablet (tablets only).
  final Set<int> half;

  final PillLook look;
  final PillShape shape;

  /// Called with the tapped position. Null makes the pack read-only.
  final ValueChanged<int>? onTapCell;

  /// Whether an empty pocket can be tapped again (to put the unit back
  /// while editing). Off for real stock, where a unit cannot come back.
  final bool tapUsed;

  final String Function(int index, PocketState state) labelFor;

  static const double _pad = 14;
  static const double _gap = 10;

  /// Real packs are two columns wide up to 16 units, then wider.
  static int columnsFor(int capacity) {
    if (capacity <= 16) return capacity <= 1 ? 1 : 2;
    if (capacity <= 24) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final cols = columnsFor(capacity);
    final rows = (capacity + cols - 1) ~/ cols;
    final capsule = shape == PillShape.capsule;
    return LayoutBuilder(
      builder: (context, constraints) {
        final available =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final maxCell = capsule ? 84.0 : 56.0;
        final fit = (available - 2 * _pad - _gap * (cols - 1)) / cols;
        final cell = math.min(maxCell, math.max(28.0, fit));
        final cellHeight = capsule ? cell * 0.62 : cell;
        final width = cols * cell + (cols - 1) * _gap + 2 * _pad;
        final height = rows * cellHeight + (rows - 1) * _gap + 2 * _pad;
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: CustomPaint(
            painter: _FoilPainter(
              rows: rows,
              cols: cols,
              pad: _pad,
              gap: _gap,
              cellHeight: cellHeight,
            ),
            child: SizedBox(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(_pad),
                child: Column(
                  children: [
                    for (var r = 0; r < rows; r++) ...[
                      if (r > 0) const SizedBox(height: _gap),
                      Row(
                        children: [
                          for (var c = 0; c < cols; c++) ...[
                            if (c > 0) const SizedBox(width: _gap),
                            SizedBox(
                              width: cell,
                              height: cellHeight,
                              child: r * cols + c < capacity
                                  ? _cell(r * cols + c)
                                  : null,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cell(int index) {
    final isUsed = used.contains(index);
    final state = isUsed
        ? PocketState.empty
        : (half.contains(index) && shape == PillShape.tablet
            ? PocketState.half
            : PocketState.full);
    return _Pocket(
      state: state,
      shape: shape,
      look: look,
      label: labelFor(index, state),
      onTap: onTapCell == null || (isUsed && !tapUsed)
          ? null
          : () => onTapCell!(index),
    );
  }
}

class _FoilPainter extends CustomPainter {
  _FoilPainter({
    required this.rows,
    required this.cols,
    required this.pad,
    required this.gap,
    required this.cellHeight,
  });

  final int rows;
  final int cols;
  final double pad;
  final double gap;
  final double cellHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final card = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );
    canvas.drawShadow(
        Path()..addRRect(card), const Color(0x55000000), 3, false);
    canvas.drawRRect(
      card,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1F3F6), Color(0xFFDDE1E7)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawRRect(
      card.deflate(0.6),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFFC4CAD3),
    );

    // Perforation lines between rows (and down the middle of a two-column
    // pack), like the tear-off lines of a real blister.
    final dash = Paint()
      ..strokeWidth = 1
      ..color = const Color(0xFFB9C0CB);
    for (var r = 1; r < rows; r++) {
      final y = pad + r * (cellHeight + gap) - gap / 2;
      _dashed(
          canvas, Offset(pad / 2, y), Offset(size.width - pad / 2, y), dash);
    }
    if (cols == 2) {
      final x = size.width / 2;
      _dashed(
          canvas, Offset(x, pad / 2), Offset(x, size.height - pad / 2), dash);
    }
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    const on = 4.0;
    const off = 3.0;
    final total = (b - a).distance;
    final dir = (b - a) / total;
    for (double d = 0; d < total; d += on + off) {
      canvas.drawLine(a + dir * d, a + dir * math.min(d + on, total), paint);
    }
  }

  @override
  bool shouldRepaint(_FoilPainter old) =>
      old.rows != rows ||
      old.cols != cols ||
      old.cellHeight != cellHeight ||
      old.gap != gap ||
      old.pad != pad;
}

class _Pocket extends StatelessWidget {
  const _Pocket({
    required this.state,
    required this.shape,
    required this.look,
    required this.label,
    required this.onTap,
  });

  final PocketState state;
  final PillShape shape;
  final PillLook look;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final capsule = shape == PillShape.capsule;
    final used = state == PocketState.empty;
    return Semantics(
      label: label,
      button: onTap != null,
      enabled: onTap != null,
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;
          final radius = BorderRadius.circular(h / 2);
          return Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: capsule
                  ? RoundedRectangleBorder(borderRadius: radius)
                  : const CircleBorder(),
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The moulded bubble: a raised rim when full, pressed in
                  // (dark at the top) once the unit has been pushed out.
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      shape: capsule ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: capsule ? radius : null,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: used
                            ? const [Color(0xFFAFB7C3), Color(0xFFF4F6F9)]
                            : const [Color(0xFFFFFFFF), Color(0xFFB4BCC8)],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: w - 5,
                    height: h - 5,
                    decoration: BoxDecoration(
                      shape: capsule ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: capsule ? BorderRadius.circular(h) : null,
                      gradient: RadialGradient(
                        center: const Alignment(-0.3, -0.4),
                        radius: 1.0,
                        colors: used
                            ? const [Color(0xFFC3CAD4), Color(0xFFDCE0E7)]
                            : const [Color(0xFFFAFBFC), Color(0xFFE6E9EE)],
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: used
                        ? const SizedBox.shrink(key: ValueKey('empty'))
                        : KeyedSubtree(
                            key: ValueKey(state),
                            child: capsule
                                ? _Capsule(
                                    width: w * 0.8,
                                    height: h * 0.55,
                                    look: look,
                                  )
                                : _Tablet(
                                    size: math.min(w, h) * 0.66,
                                    look: look,
                                    half: state == PocketState.half,
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

const _pillShadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1.5)),
];

/// Round tablet with a score line and a glossy highlight.
class _Tablet extends StatelessWidget {
  const _Tablet({
    required this.size,
    required this.look,
    this.half = false,
  });

  final double size;
  final PillLook look;

  /// Half a tablet: the same tablet cut along its score line.
  final bool half;

  @override
  Widget build(BuildContext context) {
    final base = look.primary;
    final whole = _whole(base);
    if (!half) return whole;
    return ClipRect(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: 0.5,
        child: whole,
      ),
    );
  }

  Widget _whole(Color base) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: _pillShadow,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1.0,
          colors: [
            Color.lerp(base, Colors.white, 0.45)!,
            base,
            Color.lerp(base, Colors.black, 0.18)!,
          ],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.6,
            child: Container(
              width: size * 0.78,
              height: 1.6,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Positioned(
            left: size * 0.16,
            top: size * 0.12,
            child: Container(
              width: size * 0.28,
              height: size * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Two-tone capsule lying at an angle with a glossy stripe.
class _Capsule extends StatelessWidget {
  const _Capsule(
      {required this.width, required this.height, required this.look});

  final double width;
  final double height;
  final PillLook look;

  Widget _half(Color color) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(color, Colors.white, 0.35)!,
              color,
              Color.lerp(color, Colors.black, 0.16)!,
            ],
            stops: const [0, 0.5, 1],
          ),
        ),
        child: const SizedBox.expand(),
      );

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height);
    return Transform.rotate(
      angle: -0.42,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: radius, boxShadow: _pillShadow),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(child: _half(look.primary)),
                  Expanded(child: _half(look.secondary)),
                ],
              ),
              Positioned(
                left: width * 0.1,
                right: width * 0.1,
                top: height * 0.14,
                height: height * 0.18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height),
                    color: Colors.white.withValues(alpha: 0.42),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
