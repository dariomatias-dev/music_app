import 'dart:math' as math;
import 'dart:ui';

import 'package:app_ui/src/tokens/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

double _linearize(double channel) {
  return channel <= 0.03928
      ? channel / 12.92
      : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
}

double _relativeLuminance(Color color) {
  final r = _linearize(color.r);
  final g = _linearize(color.g);
  final b = _linearize(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// WCAG 2.x contrast ratio between two colors, from 1 (no contrast) to 21
/// (black on white).
double contrastRatio(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  // This package's flutter_test_config.dart loads fonts in a setUpAll that
  // needs the test binding; these are plain logic tests with no widgets,
  // so nothing else triggers that initialization.
  TestWidgetsFlutterBinding.ensureInitialized();

  // WCAG AA for normal text.
  const minTextContrast = 4.5;

  for (final entry in {
    'light': AppColors.light,
    'dark': AppColors.dark,
  }.entries) {
    final theme = entry.key;
    final colors = entry.value;
    final backgrounds = {
      'background': colors.background,
      'surface': colors.surface,
      'card': colors.card,
    };
    final textColors = {
      'textPrimary': colors.textPrimary,
      'textSecondary': colors.textSecondary,
      'textTertiary': colors.textTertiary,
      'warning': colors.warning,
    };

    for (final bgEntry in backgrounds.entries) {
      for (final textEntry in textColors.entries) {
        test(
          '$theme: ${textEntry.key} on ${bgEntry.key} meets $minTextContrast:1',
          () {
            final ratio = contrastRatio(textEntry.value, bgEntry.value);
            expect(
              ratio,
              greaterThanOrEqualTo(minTextContrast),
              reason:
                  '${textEntry.key} on ${bgEntry.key} in $theme theme is '
                  'only ${ratio.toStringAsFixed(2)}:1',
            );
          },
        );
      }
    }
  }
}
