import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/audit/presentation/audit_screen.dart';
import '../../features/backup/presentation/backup_screen.dart';
import '../../features/caregivers/presentation/onboarding_screen.dart';
import '../../features/dashboard/presentation/today_screen.dart';
import '../../features/health/presentation/health_screen.dart';
import '../../features/inventory/presentation/batch_form_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/meals/presentation/meals_screen.dart';
import '../../features/medications/presentation/medication_detail_screen.dart';
import '../../features/medications/presentation/medication_form_screen.dart';
import '../../features/medications/presentation/medications_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/patients/presentation/patient_detail_screen.dart';
import '../../features/patients/presentation/patient_form_screen.dart';
import '../../features/patients/presentation/patients_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/schedules/presentation/schedule_form_screen.dart';
import '../../features/settings/presentation/more_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/trash/presentation/trash_screen.dart';
import '../providers/app_providers.dart';
import 'home_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Notifies the router when onboarding state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(settingsProvider, (_, __) => notifyListeners());
    ref.listen(patientsProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final settings = ref.read(settingsProvider);
    final patients = ref.read(patientsProvider);
    if (!settings.hasValue || !patients.hasValue) return null;
    final needsOnboarding =
        settings.value!.devicePersonId == null || patients.value!.isEmpty;
    final atWelcome = state.matchedLocation == '/welcome';
    if (needsOnboarding && !atWelcome) return '/welcome';
    if (!needsOnboarding && atWelcome) return '/today';
    return null;
  }

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/today',
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/today'),
      GoRoute(
        path: '/welcome',
        builder: (_, __) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/today',
              builder: (_, __) => const TodayScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/medications',
              builder: (_, __) => const MedicationsScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const MedicationFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => MedicationDetailScreen(
                    medicationId: state.pathParameters['id']!,
                    initialTab: int.tryParse(
                          state.uri.queryParameters['tab'] ?? '',
                        ) ??
                        0,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, state) => MedicationFormScreen(
                        medicationId: state.pathParameters['id'],
                      ),
                    ),
                    GoRoute(
                      path: 'schedules/new',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, state) => ScheduleFormScreen(
                        medicationId: state.pathParameters['id']!,
                      ),
                    ),
                    GoRoute(
                      path: 'schedules/:scheduleId',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, state) => ScheduleFormScreen(
                        medicationId: state.pathParameters['id']!,
                        scheduleId: state.pathParameters['scheduleId'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/inventory',
              builder: (_, __) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => BatchFormScreen(
                    medicationId: state.uri.queryParameters['medicationId'],
                  ),
                ),
                GoRoute(
                  path: 'batches/:batchId',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, state) => BatchFormScreen(
                    batchId: state.pathParameters['batchId'],
                  ),
                ),
                GoRoute(
                  path: 'report',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const InventoryReportScreen(),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/health',
              builder: (_, state) => HealthScreen(
                initialTab: int.tryParse(
                      state.uri.queryParameters['tab'] ?? '',
                    ) ??
                    0,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/more',
              builder: (_, __) => const MoreScreen(),
              routes: [
                GoRoute(
                  path: 'patients',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const PatientsScreen(),
                  routes: [
                    GoRoute(
                      path: 'new',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, __) => const PatientFormScreen(),
                    ),
                    GoRoute(
                      path: ':id',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (_, state) => PatientDetailScreen(
                        patientId: state.pathParameters['id']!,
                      ),
                      routes: [
                        GoRoute(
                          path: 'edit',
                          parentNavigatorKey: rootNavigatorKey,
                          builder: (_, state) => PatientFormScreen(
                            patientId: state.pathParameters['id'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'meals',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const MealsScreen(),
                ),
                GoRoute(
                  path: 'reports',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const ReportsScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const NotificationsScreen(),
                ),
                GoRoute(
                  path: 'backup',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const BackupScreen(),
                ),
                GoRoute(
                  path: 'trash',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const TrashScreen(),
                ),
                GoRoute(
                  path: 'audit',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const AuditScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, __) => const SettingsScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
