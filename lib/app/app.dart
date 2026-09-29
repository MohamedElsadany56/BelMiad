import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/app_localization.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/medications/presentation/medications_screen.dart';
import '../features/patients/presentation/patients_screen.dart';
import '../features/records/presentation/records_screen.dart';
import '../features/schedules/presentation/schedule_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/backup/presentation/backup_screen.dart';

class BelMiadApp extends ConsumerWidget {
  const BelMiadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'BelMiad — بالميعاد',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0064f6),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
          GoRoute(
            path: '/medications',
            builder: (_, __) => const MedicationsScreen(),
          ),
          GoRoute(
            path: '/inventory',
            builder: (_, __) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/schedule',
            builder: (_, __) => const ScheduleScreen(),
          ),
          GoRoute(
            path: '/patients',
            builder: (_, __) => const PatientsScreen(),
          ),
          GoRoute(path: '/records', builder: (_, __) => const RecordsScreen()),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (_, __) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/backup',
            builder: (_, __) => const BackupScreen(),
          ),
        ],
      ),
    );
  }
}

