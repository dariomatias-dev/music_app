import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return Row(
      key: galleryKey,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        AppSwitch(value: false, onChanged: (_) {}),
        AppSwitch(value: true, onChanged: (_) {}),
      ],
    );
  }

  testWidgets('AppSwitch - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_switch_light.png'),
    );
  });

  testWidgets('AppSwitch - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_switch_dark.png'),
    );
  });
}
