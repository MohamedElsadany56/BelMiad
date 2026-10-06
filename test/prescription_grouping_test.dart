import 'package:belmiad/features/health/domain/prescription_grouping.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('groups by month, newest first, undated last, stable ties', () {
    final items = [
      ('a', '2026-01-05'),
      ('b', '2026-03-01'),
      ('c', null),
      ('d', '2026-03-20'),
      ('e', '2026-03-20'),
      ('f', '2025-12-31'),
    ];
    final groups = groupByIssueMonth(items, (i) => i.$2);
    expect(groups.map((g) => g.month?.month), [3, 1, 12, null]);
    expect(groups[0].items.map((i) => i.$1), ['d', 'e', 'b']);
    expect(groups.last.items.map((i) => i.$1), ['c']);
  });

  test('empty input gives no groups', () {
    expect(groupByIssueMonth<String>([], (_) => null), isEmpty);
  });
}
