import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common.dart';

/// Primary navigation for the five main areas: a bottom bar on phones and a
/// side rail on tablets and landscape screens.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  void _select(int index) => shell.goBranch(
        index,
        initialLocation: index == shell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      (Icons.today_outlined, Icons.today, l10n.navToday),
      (Icons.medication_outlined, Icons.medication, l10n.navMedications),
      (Icons.inventory_2_outlined, Icons.inventory_2, l10n.navInventory),
      (Icons.favorite_outline, Icons.favorite, l10n.navHealth),
      (Icons.menu, Icons.menu_open, l10n.navMore),
    ];
    final width = MediaQuery.sizeOf(context).width;

    // Tablets and landscape screens: navigation on the side.
    if (width >= Breakpoints.rail) {
      final extended = width >= Breakpoints.extendedRail;
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              right: false,
              // Fills the height and scrolls on short landscape screens.
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: shell.currentIndex,
                        onDestinationSelected: _select,
                        extended: extended,
                        groupAlignment: -1,
                        labelType: extended
                            ? NavigationRailLabelType.none
                            : NavigationRailLabelType.all,
                        destinations: [
                          for (final (icon, selected, label) in destinations)
                            NavigationRailDestination(
                              icon: Icon(icon),
                              selectedIcon: Icon(selected),
                              label: Text(label),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }

    // Five labels share the phone's width: cap how far large system fonts
    // grow them so none is cut off (icons stay the main cue).
    final labelScale = (width / destinations.length / 62).clamp(1.0, 1.5);
    return Scaffold(
      body: shell,
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: labelScale,
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: _select,
          destinations: [
            for (final (icon, selected, label) in destinations)
              NavigationDestination(
                icon: Icon(icon),
                selectedIcon: Icon(selected),
                label: label,
              ),
          ],
        ),
      ),
    );
  }
}
