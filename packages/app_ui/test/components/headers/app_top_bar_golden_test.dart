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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          AppTopBar(title: 'Queue', backButtonSemanticLabel: 'Back'),
          AppTopBar(
            title: 'Search',
            showBack: false,
            backButtonSemanticLabel: 'Back',
          ),
        ],
      ),
    );
  }

  testWidgets('AppTopBar - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_top_bar_light.png'),
    );
  });

  testWidgets('AppTopBar - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_top_bar_dark.png'),
    );
  });
}
