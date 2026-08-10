import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  Widget buildGallery() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        AppIconButton(
          icon: Icons.favorite_border,
          semanticLabel: 'Favorite',
          onPressed: () {},
        ),
        const AppIconButton(
          icon: Icons.favorite_border,
          semanticLabel: 'Favorite',
          onPressed: null,
        ),
      ],
    );
  }

  testWidgets('AppIconButton - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/app_icon_button_light.png'),
    );
  });

  testWidgets('AppIconButton - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/app_icon_button_dark.png'),
    );
  });
}
