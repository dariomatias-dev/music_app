import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  const galleryKey = Key('gallery');

  Widget buildGallery() {
    return const AppSectionContainer(
      key: galleryKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text('Row one')),
          ListTile(title: Text('Row two')),
        ],
      ),
    );
  }

  testWidgets('AppSectionContainer - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_section_container_light.png'),
    );
  });

  testWidgets('AppSectionContainer - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_section_container_dark.png'),
    );
  });
}
