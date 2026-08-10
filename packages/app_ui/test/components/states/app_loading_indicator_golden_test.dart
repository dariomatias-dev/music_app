import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return const SizedBox(
      key: galleryKey,
      width: 200,
      height: 100,
      child: AppLoadingIndicator(message: 'Loading library'),
    );
  }

  testWidgets('AppLoadingIndicator - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_loading_indicator_light.png'),
    );
  });

  testWidgets('AppLoadingIndicator - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_loading_indicator_dark.png'),
    );
  });
}
