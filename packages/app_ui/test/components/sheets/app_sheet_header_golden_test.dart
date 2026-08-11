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
      child: AppSheetHeader(
        artworkSeed: 'track-1',
        title: 'Night Drive',
        subtitle: 'Chill Vibes · Charcoal',
      ),
    );
  }

  testWidgets('AppSheetHeader - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_sheet_header_light.png'),
    );
  });

  testWidgets('AppSheetHeader - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_sheet_header_dark.png'),
    );
  });
}
