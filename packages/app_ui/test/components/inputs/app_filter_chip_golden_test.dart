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
        AppFilterChip(label: 'Songs', onTap: () {}),
        AppFilterChip(label: 'Albums', selected: true, onTap: () {}),
      ],
    );
  }

  testWidgets('AppFilterChip - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_filter_chip_light.png'),
    );
  });

  testWidgets('AppFilterChip - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_filter_chip_dark.png'),
    );
  });
}
