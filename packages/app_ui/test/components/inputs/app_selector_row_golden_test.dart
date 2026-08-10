import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return SizedBox(
      key: galleryKey,
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSelectorRow(label: 'English', selected: true, onTap: () {}),
          AppSelectorRow(
            label: 'Português (Brasil)',
            selected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  testWidgets('AppSelectorRow - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_selector_row_light.png'),
    );
  });

  testWidgets('AppSelectorRow - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_selector_row_dark.png'),
    );
  });
}
