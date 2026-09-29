import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      await ref.read(localNotifierProvider).initialize();
      ref.read(syncCoordinatorProvider).request();
    });
    // Keeps missed-dose marking and notifications current while open.
    _periodicSync = Timer.periodic(
      const Duration(minutes: 1),
      (_) => ref.read(syncCoordinatorProvider).request(),
    );
  }

  @override
  void dispose() {
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
