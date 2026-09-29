import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/app_scaffold.dart';
import '../../../app/localization/app_localization.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../patients/data/patient_providers.dart';

class DashboardData {
  final int todaysDoses;
  final int totalInStock;
  final int lowStock;
  final int expiringSoon;
  final List<DoseInstanceWithMedication> schedule;

  DashboardData({
    required this.todaysDoses,
    required this.totalInStock,
    required this.lowStock,
    required this.expiringSoon,
    required this.schedule,
  });
}

class DoseInstanceWithMedication {
  final DoseInstance instance;
  final Medication medication;
  
  DoseInstanceWithMedication(this.instance, this.medication);
}

final dashboardDataProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  final patientId = ref.watch(activePatientIdProvider);
  if (patientId == null) throw Exception('No active patient');

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final todaysDosesQuery = db.select(db.doseInstances)
    ..where((d) => d.patientId.equals(patientId) & d.scheduledAt.isBetweenValues(startOfDay, endOfDay));
  final todaysDoses = await todaysDosesQuery.get();

  final patientMeds = await (db.select(db.medications)
    ..where((m) => m.patientId.equals(patientId) & m.isActive.equals(true))).get();
  final patientMedIds = patientMeds.map((m) => m.id).toList();

  int totalInStockScaled = 0;
  int lowStockCount = 0;
  int expiringSoonCount = 0;
  final thirtyDaysFromNow = now.add(const Duration(days: 30));

  final Map<String, int> stockPerMed = { for (var id in patientMedIds) id: 0 };

  if (patientMedIds.isNotEmpty) {
    final batches = await (db.select(db.inventoryBatches)
      ..where((b) => b.medicationId.isIn(patientMedIds) & b.isDepleted.equals(false))).get();
    
    for (final batch in batches) {
      stockPerMed[batch.medicationId] = (stockPerMed[batch.medicationId] ?? 0) + batch.availableQuantityScaled;
      totalInStockScaled += batch.availableQuantityScaled;

      if (batch.expirationDate != null && batch.expirationDate!.isBefore(thirtyDaysFromNow)) {
        expiringSoonCount++;
      }
    }
  }

  for (final stock in stockPerMed.values) {
    if (stock <= 1000) {
      lowStockCount++;
    }
  }

  final scheduleQuery = db.select(db.doseInstances).join([
    drift.innerJoin(db.medications, db.medications.id.equalsExp(db.doseInstances.medicationId)),
  ])..where(
    db.doseInstances.patientId.equals(patientId) & 
    db.doseInstances.scheduledAt.isBetweenValues(startOfDay, endOfDay)
  )..orderBy([drift.OrderingTerm.asc(db.doseInstances.scheduledAt)]);

  final scheduleResult = await scheduleQuery.get();
  final schedule = scheduleResult.map((row) {
    return DoseInstanceWithMedication(
      row.readTable(db.doseInstances),
      row.readTable(db.medications),
    );
  }).toList();

  return DashboardData(
    todaysDoses: todaysDoses.length,
    totalInStock: totalInStockScaled ~/ 1000,
    lowStock: lowStockCount,
    expiringSoon: expiringSoonCount,
    schedule: schedule,
  );
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final strings = AppStrings(locale);
    final patientId = ref.watch(activePatientIdProvider);

    return AppScaffold(
      title: strings.text('dashboard'),
      child: patientId == null
          ? const Center(child: Text('Please select a patient first.'))
          : const _DashboardBody(),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(dashboardDataProvider);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (data) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Today at a glance', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          const Text('Everything for your current patient, in one calm view.'),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Stat(label: 'Today’s doses', value: data.todaysDoses.toString()),
              _Stat(label: 'In stock', value: data.totalInStock.toString()),
              _Stat(label: 'Low stock', value: data.lowStock.toString()),
              _Stat(label: 'Expiring soon', value: data.expiringSoon.toString()),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today’s medicine schedule',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (data.schedule.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('No doses scheduled for today.'),
                    )
                  else
                    ...data.schedule.map((item) {
                      final med = item.medication;
                      final inst = item.instance;
                      
                      final timeStr = '${inst.scheduledAt.hour.toString().padLeft(2, '0')}:${inst.scheduledAt.minute.toString().padLeft(2, '0')}';
                      final qty = inst.requiredQuantityScaled ~/ 1000;
                      final unit = med.doseUnit;
                      final name = med.nameEn;
                      
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.medication_outlined)),
                        title: Text(name),
                        subtitle: Text('$timeStr · $qty $unit'),
                        trailing: Chip(label: Text(inst.status)),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 165,
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label),
                    const SizedBox(height: 8),
                    Text(value, style: Theme.of(context).textTheme.headlineMedium)
                  ]))));
}
