import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return const SizedBox(
      key: galleryKey,
      width: 320,
      height: 260,
      child: AppEmptyState(
        icon: Icons.music_off,
        title: 'No songs found',
        message: 'Music files added to your device will show up here.',
      ),
    );
  }

  testWidgets('AppEmptyState - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_empty_state_light.png'),
    );
  });

  testWidgets('AppEmptyState - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_empty_state_dark.png'),
    );
  });
}
