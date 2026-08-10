import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return const SizedBox(
      key: galleryKey,
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          AppIndexingProgress(
            processedCount: 120,
            totalCount: 400,
            message: 'Indexing your library',
          ),
          AppIndexingProgress(processedCount: 0, totalCount: null),
        ],
      ),
    );
  }

  testWidgets('AppIndexingProgress - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_indexing_progress_light.png'),
    );
  });

  testWidgets('AppIndexingProgress - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_indexing_progress_dark.png'),
    );
  });
}
