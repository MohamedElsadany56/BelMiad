import 'package:flutter/material.dart';

/// Physical-looking blister pack: a foil panel with one pocket per unit.
/// Remaining units show a tablet or capsule, used ones leave an empty pocket.
///
/// Purely visual. The owner decides which positions are used and what a tap
/// does, so the persisted quantity stays the only source of truth.
class BlisterGrid extends StatelessWidget {
  const BlisterGrid({
    required this.capacity,
    required this.used,
    required this.pillColor,
    required this.labelFor,
    this.capsule = false,
    this.onTapCell,
    this.tapUsed = false,
    super.key,
  });

  /// Number of pockets in the pack.
  final int capacity;

  /// Zero-based positions that are already empty.
  final Set<int> used;

  final Color pillColor;

  /// Capsules are drawn two-tone and lying down; everything else as a round
  /// tablet.
  final bool capsule;

  /// Called with the tapped position. Null makes the pack read-only.
  final ValueChanged<int>? onTapCell;

  /// Whether an already empty pocket can be tapped (to put the unit back
  /// while editing). Off for real stock, where a unit cannot come back.
  final bool tapUsed;

  /// Spoken label for one pocket.
  final String Function(int index, bool used) labelFor;

  static const _foil = Color(0xFFDCE2EA);
  static const _foilEdge = Color(0xFFBFC8D4);
  static const double _pad = 10;
  static const double _gap = 8;

  /// Columns grow with the pack so it stays compact (10 → 2, 14 → 3).
  static int columnsFor(int capacity) =>
      (((capacity + 4) ~/ 5).clamp(2, 6)).clamp(1, capacity < 1 ? 1 : capacity);

  @override
  Widget build(BuildContext context) {
    final cols = columnsFor(capacity);
    return LayoutBuilder(
      builder: (context, constraints) {
        final available =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0;
        final inner = available - 2 * _pad;
        final cell =
            ((inner - _gap * (cols - 1)) / cols).clamp(30.0, 54.0).toDouble();
        final height = capsule ? cell * 0.66 : cell;
        final panelWidth = cols * cell + _gap * (cols - 1) + 2 * _pad;
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: panelWidth,
            padding: const EdgeInsets.all(_pad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _foilEdge),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE8ECF2), _foil],
              ),
            ),
            child: Wrap(
              spacing: _gap,
              runSpacing: _gap,
              children: [
                for (var i = 0; i < capacity; i++)
                  _Pocket(
                    width: cell,
                    height: height,
                    used: used.contains(i),
                    capsule: capsule,
                    pillColor: pillColor,
                    label: labelFor(i, used.contains(i)),
                    onTap: onTapCell == null || (used.contains(i) && !tapUsed)
                        ? null
                        : () => onTapCell!(i),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Pocket extends StatelessWidget {
  const _Pocket({
    required this.width,
    required this.height,
    required this.used,
    required this.capsule,
    required this.pillColor,
    required this.label,
    required this.onTap,
  });

  final double width;
  final double height;
  final bool used;
  final bool capsule;
  final Color pillColor;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);
    return Semantics(
      label: label,
      button: onTap != null,
      enabled: onTap != null,
      excludeSemantics: true,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: capsule
                ? RoundedRectangleBorder(borderRadius: radius)
                : const CircleBorder(),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                shape: capsule ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: capsule ? radius : null,
                color: used ? const Color(0xFFC6CED9) : const Color(0xFFF2F5F9),
                border: Border.all(
                  color:
                      used ? const Color(0xFFA9B3C1) : const Color(0xFFB4BDCA),
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Torn-foil dent left behind by a used unit.
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: used ? 1 : 0,
                    child: Container(
                      width: width * 0.5,
                      height: capsule ? height * 0.42 : width * 0.5,
                      decoration: BoxDecoration(
                        shape: capsule ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius:
                            capsule ? BorderRadius.circular(height) : null,
                        color: const Color(0xFFB2BCCA),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    scale: used ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    curve: used ? Curves.easeIn : Curves.easeOutBack,
                    child: capsule
                        ? _Capsule(
                            width: width * 0.84,
                            height: height * 0.6,
                            color: pillColor,
                          )
                        : _Tablet(size: width * 0.7, color: pillColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tablet extends StatelessWidget {
  const _Tablet({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.4),
          colors: [Color.lerp(color, Colors.white, 0.45)!, color],
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Transform.rotate(
        angle: -0.5,
        child: Container(
          width: size * 0.62,
          height: 1.5,
          color: Colors.black.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

class _Capsule extends StatelessWidget {
  const _Capsule({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          children: [
            Expanded(
                child:
                    ColoredBox(color: color, child: const SizedBox.expand())),
            Expanded(
              child: ColoredBox(
                color: Color.lerp(color, Colors.white, 0.78)!,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
