import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return const Row(
      key: galleryKey,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        AppPlaybackIndicator(playing: false),
        AppPlaybackIndicator(playing: true),
      ],
    );
  }

  testWidgets('AppPlaybackIndicator - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_playback_indicator_light.png'),
    );
  });

  testWidgets('AppPlaybackIndicator - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_playback_indicator_dark.png'),
    );
  });
}
