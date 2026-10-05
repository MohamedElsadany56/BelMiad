import 'package:belmiad/app/theme/typography.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double scale(double sys, FontSizeOption o, double w) =>
      AppTypography.effectiveScale(systemScale: sys, option: o, screenWidth: w);

  test('default, medium and maximum', () {
    expect(scale(1, FontSizeOption.standard, 400), 1.0);
    expect(scale(1, FontSizeOption.medium, 400), closeTo(1.15, 1e-9));
    expect(scale(1, FontSizeOption.maximum, 400), closeTo(1.75, 1e-9));
  });

  test('capped for narrow screens and overall', () {
    expect(scale(2, FontSizeOption.maximum, 320),
        AppTypography.narrowMaximumScale);
    expect(scale(2, FontSizeOption.maximum, 400), AppTypography.maximumScale);
    expect(
        scale(0.1, FontSizeOption.standard, 400), AppTypography.minimumScale);
  });

  test('fromCode falls back to standard', () {
    expect(FontSizeOption.fromCode('nope'), FontSizeOption.standard);
    expect(FontSizeOption.fromCode('maximum'), FontSizeOption.maximum);
  });
}
