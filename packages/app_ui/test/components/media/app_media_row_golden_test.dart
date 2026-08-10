import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return SizedBox(
      key: galleryKey,
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppMediaRow(
            artworkSeed: 'track-1',
            title: 'Night Drive',
            subtitle: 'Chill Vibes',
            onTap: () {},
            trailing: const [
              AppPlaybackIndicator(playing: true, size: 14),
            ],
          ),
          AppMediaRow(
            artworkSeed: 'artist-1',
            title: 'Charcoal',
            subtitle: '3 albums',
            circle: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  testWidgets('AppMediaRow - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_media_row_light.png'),
    );
  });

  testWidgets('AppMediaRow - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_media_row_dark.png'),
    );
  });
}
