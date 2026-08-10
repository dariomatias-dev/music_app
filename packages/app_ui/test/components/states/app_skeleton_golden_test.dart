import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return const SizedBox(
      key: galleryKey,
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          AppSkeleton(width: 160, height: 16),
          AppSkeleton(width: 100, height: 12),
        ],
      ),
    );
  }

  testWidgets('AppSkeleton - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_skeleton_light.png'),
    );
  });

  testWidgets('AppSkeleton - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_skeleton_dark.png'),
    );
  });
}
