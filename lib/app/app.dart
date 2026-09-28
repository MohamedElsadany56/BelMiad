import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/medications/presentation/medications_screen.dart';
import '../features/patients/presentation/patients_screen.dart';
import '../features/records/presentation/records_screen.dart';
import '../features/schedules/presentation/schedule_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class BelMiadApp extends ConsumerWidget {
  const BelMiadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'BelMiad — بالميعاد',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff12b8b0), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xfff7faf9),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      routerConfig: GoRouter(routes: [
        GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/medications', builder: (_, __) => const MedicationsScreen()),
        GoRoute(path: '/inventory', builder: (_, __) => const InventoryScreen()),
        GoRoute(path: '/schedule', builder: (_, __) => const ScheduleScreen()),
        GoRoute(path: '/patients', builder: (_, __) => const PatientsScreen()),
        GoRoute(path: '/records', builder: (_, __) => const RecordsScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ]),
    );
  }
}
