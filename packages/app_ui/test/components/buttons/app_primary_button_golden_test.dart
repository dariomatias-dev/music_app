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
        AppPrimaryButton(label: 'Play all', onPressed: () {}),
        AppPrimaryButton(
          label: 'Play all',
          icon: Icons.play_arrow,
          onPressed: () {},
        ),
        const AppPrimaryButton(label: 'Play all', onPressed: null),
        AppPrimaryButton(label: 'Play all', onPressed: () {}, isLoading: true),
      ],
    );
  }

  testWidgets('AppPrimaryButton - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/app_primary_button_light.png'),
    );
  });

  testWidgets('AppPrimaryButton - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/app_primary_button_dark.png'),
    );
  });
}
