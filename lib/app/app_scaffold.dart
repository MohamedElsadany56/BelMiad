import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.title, required this.child, super.key});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final route = GoRouterState.of(context).uri.path;
    final destinations = const <({String path, String label, IconData icon})>[
      ('/', 'Dashboard', Icons.dashboard_outlined),
      ('/medications', 'Medicines', Icons.medication_outlined),
      ('/inventory', 'Stock & batches', Icons.inventory_2_outlined),
      ('/schedule', 'Medicine schedule', Icons.schedule_outlined),
      ('/patients', 'Patients', Icons.people_outline),
      ('/records', 'Health records', Icons.favorite_outline),
      ('/settings', 'Settings', Icons.settings_outlined),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [TextButton(onPressed: () {}, child: const Text('عربي'))],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                title: Text('BelMiad'),
                subtitle: Text('بالميعاد'),
              ),
              ...destinations.map(
                (d) => ListTile(
                  leading: Icon(d.pathlabelicon$3),
                  title: Text(d.pathlabelicon$2),
                  selected: route == d.pathlabelicon$1,
                  onTap: () {
                    Navigator.pop(context);
                    context.go(d.pathlabelicon$1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }
}
