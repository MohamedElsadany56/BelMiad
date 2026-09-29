import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/app_localization.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({required this.title, required this.child, super.key});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = GoRouterState.of(context).uri.path;
    final locale = ref.watch(localeProvider);
    final strings = AppStrings(locale);
    const destinations = [
      ('/', 'dashboard', Icons.dashboard_outlined),
      ('/medications', 'medicines', Icons.medication_outlined),
      ('/inventory', 'stock', Icons.inventory_2_outlined),
      ('/schedule', 'schedule', Icons.schedule_outlined),
      ('/patients', 'patients', Icons.people_outline),
      ('/records', 'records', Icons.favorite_outline),
      ('/settings', 'settings', Icons.settings_outlined),
      ('/reports', 'reports', Icons.assessment_outlined),
      ('/backup', 'backup', Icons.backup_outlined),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.text(titleKey(title))),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(localeProvider.notifier).state =
                  locale.languageCode == 'ar'
                      ? const Locale('en')
                      : const Locale('ar');
            },
            child: Text(
              locale.languageCode == 'ar'
                  ? strings.text('english')
                  : strings.text('arabic'),
            ),
          ),
        ],
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
                  leading: Icon(d.$3),
                  title: Text(strings.text(d.$2)),
                  selected: route == d.$1,
                  onTap: () {
                    Navigator.pop(context);
                    context.go(d.$1);
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

  String titleKey(String title) {
    const keys = {
      'Dashboard': 'dashboard',
      'Medicines': 'medicines',
      'Stock & batches': 'stock',
      'Medicine schedule': 'schedule',
      'Patients': 'patients',
      'Health records': 'records',
      'Settings': 'settings',
      'Reports': 'reports',
      'Backup': 'backup',
    };
    return keys[title] ?? title;
  }
}

