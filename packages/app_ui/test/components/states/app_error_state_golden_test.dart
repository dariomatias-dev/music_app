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
      height: 320,
      child: AppErrorState(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        message: 'We could not load your library. Please try again.',
        retryLabel: 'Try again',
        onRetry: () {},
        technicalDetails: 'FileSystemException: permission denied',
      ),
    );
  }

  testWidgets('AppErrorState - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_error_state_light.png'),
    );
  });

  testWidgets('AppErrorState - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_error_state_dark.png'),
    );
  });
}
