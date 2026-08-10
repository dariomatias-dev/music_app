import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  Widget buildGallery() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        AppSecondaryButton(label: 'Shuffle', onPressed: () {}),
        AppSecondaryButton(
          label: 'Shuffle',
          icon: Icons.shuffle,
          onPressed: () {},
        ),
        const AppSecondaryButton(label: 'Shuffle', onPressed: null),
        AppSecondaryButton(
          label: 'Shuffle',
          onPressed: () {},
          isLoading: true,
        ),
      ],
    );
  }

  testWidgets('AppSecondaryButton - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/app_secondary_button_light.png'),
    );
  });

  testWidgets('AppSecondaryButton - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/app_secondary_button_dark.png'),
    );
  });
}
