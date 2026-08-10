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
      height: 260,
      child: AppRetryState(
        icon: Icons.refresh,
        title: 'Scan your library again',
        message: 'Re-scan your device to pick up new or changed files.',
        retryLabel: 'Scan now',
        onRetry: () {},
      ),
    );
  }

  testWidgets('AppRetryState - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_retry_state_light.png'),
    );
  });

  testWidgets('AppRetryState - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_retry_state_dark.png'),
    );
  });
}
