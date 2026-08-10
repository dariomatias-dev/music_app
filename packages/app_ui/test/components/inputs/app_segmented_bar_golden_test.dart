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
      child: AppSegmentedBar(
        labels: const ['Day', 'Week', 'Month'],
        index: 1,
        onChanged: (_) {},
      ),
    );
  }

  testWidgets('AppSegmentedBar - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_segmented_bar_light.png'),
    );
  });

  testWidgets('AppSegmentedBar - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_segmented_bar_dark.png'),
    );
  });
}
