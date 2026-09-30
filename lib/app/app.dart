import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../core/settings/settings_repository.dart';
import '../features/notifications/application/notification_actions.dart';
import 'providers/app_providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class BelMiadApp extends ConsumerStatefulWidget {
  const BelMiadApp({super.key});

  @override
  ConsumerState<BelMiadApp> createState() => _BelMiadAppState();
}

class _BelMiadAppState extends ConsumerState<BelMiadApp>
    with WidgetsBindingObserver {
  Timer? _periodicSync;
  Timer? _inactivity;
  StreamSubscription<(String?, String?)>? _notificationTaps;

  /// "Take"/"Snooze" run in place; tapping the notification opens Today
  /// for that patient.
  Future<void> _onNotification((String?, String?) event) async {
    final (actionId, payload) = event;
    if (actionId == NotificationActionIds.take ||
        actionId == NotificationActionIds.snooze) {
      await ref.read(doseNotificationActionsProvider).handle(actionId, payload);
      ref.read(syncCoordinatorProvider).request();
      return;
    }
    _openFromNotification(payload);
  }

  void _openFromNotification(String? payload) {
    final patientId = NotificationPayload.decode(payload)?.patientId;
    if (patientId != null) {
      ref
          .read(settingsRepositoryProvider)
          .set(SettingKeys.currentPatientId, patientId);
    }
    ref.read(routerProvider).go('/today');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationTaps =
        ref.read(notificationTapsProvider).stream.listen(_onNotification);
    Future.microtask(() async {
      final notifier = ref.read(localNotifierProvider);
      await notifier.initialize();
      ref.read(syncCoordinatorProvider).request();
      // The app was opened by tapping a notification.
      final launch = await notifier.launchPayload();
      if (launch != null) _openFromNotification(launch);
    });
    // Keeps missed-dose marking and notifications current while open.
    _periodicSync = Timer.periodic(
      const Duration(minutes: 1),
      (_) => ref.read(syncCoordinatorProvider).request(),
    );
  }

  @override
  void dispose() {
    _notificationTaps?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _periodicSync?.cancel();
    _inactivity?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(syncCoordinatorProvider).request();
    }
  }

  /// Inactivity reset (spec §3): returns to the start screen. It is not a
  /// lock and never asks for credentials.
  void _resetInactivityTimer() {
    _inactivity?.cancel();
    final minutes =
        ref.read(settingsProvider).valueOrNull?.inactivityMinutes ?? 0;
    if (minutes <= 0) return;
    _inactivity = Timer(Duration(minutes: minutes), () {
      final navigator = rootNavigatorKey.currentState;
      navigator?.popUntil((route) => route.isFirst);
      ref.read(routerProvider).go('/today');
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);
    ref.listen(localeProvider, (_, __) {
      ref.read(syncCoordinatorProvider).request();
    });
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _resetInactivityTimer(),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
