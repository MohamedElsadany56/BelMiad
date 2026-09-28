import 'package:flutter_test/flutter_test.dart';
import 'package:belmiad/features/inventory/domain/scaled_quantity.dart';
import 'package:belmiad/features/schedules/domain/recurrence_rule.dart';
import 'package:belmiad/features/doses/domain/dose_state_machine.dart';

void main() {
  test('scaled quantities preserve fractional doses', () {
    expect((const ScaledQuantity(250) + const ScaledQuantity(500)).value, 750);
    expect((const ScaledQuantity(750) - const ScaledQuantity(250)).asDouble, .5);
  });
  test('weekly recurrence matches selected weekdays', () {
    const rule = RecurrenceRule(type: RecurrenceType.weekly, weekdays: {1, 3});
    expect(rule.occursOn(DateTime(2026, 9, 28)), isTrue);
    expect(rule.occursOn(DateTime(2026, 9, 29)), isFalse);
  });
  test('dose transitions reject taking a missed dose', () {
    expect(DoseStateMachine.canTransition(DoseStatus.missed, DoseStatus.taken), isFalse);
    expect(DoseStateMachine.canTransition(DoseStatus.scheduled, DoseStatus.taken), isTrue);
  });
}
