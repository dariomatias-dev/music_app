import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return Center(
      key: galleryKey,
      child: AppDialog(
        title: 'Discard changes?',
        message: 'Your edits have not been saved yet.',
        actions: [
          AppTextButton(label: 'Cancel', onPressed: () {}),
          AppPrimaryButton(label: 'Discard', height: 40, onPressed: () {}),
        ],
      ),
    );
  }

  testWidgets('AppDialog - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_dialog_light.png'),
    );
  });

  testWidgets('AppDialog - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_dialog_dark.png'),
    );
  });
}
