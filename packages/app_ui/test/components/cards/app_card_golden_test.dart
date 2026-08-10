import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return Column(
      key: galleryKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const AppCard(child: Text('Static card')),
        AppCard(onTap: () {}, child: const Text('Tappable card')),
      ],
    );
  }

  testWidgets('AppCard - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_card_light.png'),
    );
  });

  testWidgets('AppCard - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_card_dark.png'),
    );
  });
}
