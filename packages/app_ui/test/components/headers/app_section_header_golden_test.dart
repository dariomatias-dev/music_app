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
          const AppSectionHeader(title: 'Recently played'),
          AppSectionHeader(
            title: 'Playlists',
            actionLabel: 'See all',
            onAction: () {},
          ),
        ],
      ),
    );
  }

  testWidgets('AppSectionHeader - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_section_header_light.png'),
    );
  });

  testWidgets('AppSectionHeader - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_section_header_dark.png'),
    );
  });
}
