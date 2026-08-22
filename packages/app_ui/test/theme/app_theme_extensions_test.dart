import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const light = AppColorsExtension(AppColors.light);
  const dark = AppColorsExtension(AppColors.dark);

  test('copyWith swaps the wrapped tokens', () {
    expect(light.copyWith(colors: AppColors.dark).colors, AppColors.dark);
  });

  test('copyWith keeps the current tokens when given none', () {
    expect(light.copyWith().colors, AppColors.light);
  });

  group('lerp', () {
    test('keeps the starting tokens before the midpoint', () {
      expect(light.lerp(dark, 0.49).colors, AppColors.light);
    });

    test('snaps to the target tokens at the midpoint', () {
      expect(light.lerp(dark, 0.5).colors, AppColors.dark);
    });

    test('keeps the current tokens when there is nothing to lerp to', () {
      expect(light.lerp(null, 1).colors, AppColors.light);
    });
  });

  testWidgets('context.colors reads the tokens off the theme', (tester) async {
    late AppColors colors;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) {
            colors = context.colors;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(colors, AppColors.dark);
  });
}
