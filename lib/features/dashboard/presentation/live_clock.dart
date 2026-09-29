import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/providers/app_providers.dart';
import '../../../app/widgets/common.dart';

/// Live clock in the patient's timezone. When the patient lives in another
/// timezone than the phone, the zone name is shown too.
class LiveClock extends ConsumerStatefulWidget {
  const LiveClock({super.key});

  @override
  ConsumerState<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends ConsumerState<LiveClock> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final time = ref.watch(patientTimeProvider);
    final local = time.toLocal(_now);
    final differentZone = local.timeZoneOffset != _now.timeZoneOffset;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Icon(Icons.access_time_filled, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.jms(context.localeName).format(local),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  DateFormat.yMMMMEEEEd(context.localeName).format(local),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (differentZone)
                  Text(
                    l10n.timeInZone(time.location.name),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
