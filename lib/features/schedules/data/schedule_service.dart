import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/recurrence_rule.dart';

class ScheduleService {
  ScheduleService(this.database);
  final AppDatabase database;
  Future<void> createSchedule(
          {required String id,
          required String medicationId,
          required String time,
          required int quantityScaled,
          required RecurrenceRule rule}) =>
      database.into(database.medicationSchedules).insert(
          MedicationSchedulesCompanion.insert(
              id: id,
              medicationId: medicationId,
              scheduleType: rule.type.name,
              fixedTime: Value(time),
              recurrenceRule: rule.weekdays.join(','),
              doseQuantityScaled: quantityScaled));
  Future<int> generateDoses(
      {required String patientId,
      required DateTime from,
      required int days}) async {
    final schedules = await (database.select(database.medicationSchedules)
          ..where((s) => s.isActive.equals(true)))
        .get();
    var created = 0;
    for (final s in schedules) {
      final med = await (database.select(database.medications)
            ..where((m) => m.id.equals(s.medicationId)))
          .getSingleOrNull();
      if (med == null || med.patientId != patientId) continue;
      final scheduleType = RecurrenceType.values.firstWhere(
        (type) => type.name == s.scheduleType,
        orElse: () => RecurrenceType.daily,
      );
      final weekdays = s.recurrenceRule
          .split(',')
          .where((value) => value.isNotEmpty)
          .map(int.tryParse)
          .whereType<int>()
          .toSet();
      final rule = RecurrenceRule(type: scheduleType, weekdays: weekdays);
      final p = (s.fixedTime ?? '08:00').split(':');
      for (var d = 0; d < days; d++) {
        final date = DateTime(from.year, from.month, from.day + d,
            int.tryParse(p[0]) ?? 8, int.tryParse(p[1]) ?? 0);
        if (!rule.occursOn(date, anchor: from)) continue;
        final exists = await (database.select(database.doseInstances)
              ..where((x) =>
                  x.medicationId.equals(med.id) & x.scheduledAt.equals(date)))
            .getSingleOrNull();
        if (exists == null) {
          await database.into(database.doseInstances).insert(
              DoseInstancesCompanion.insert(
                  id: '${s.id}-${date.millisecondsSinceEpoch}',
                  patientId: patientId,
                  medicationId: med.id,
                  scheduledAt: date,
                  requiredQuantityScaled: s.doseQuantityScaled));
          created++;
        }
      }
    }
    return created;
  }
}
