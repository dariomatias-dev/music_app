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
        AppTextField(
          controller: TextEditingController(),
          hintText: 'Playlist name',
        ),
        AppTextField(
          controller: TextEditingController(text: 'Chill vibes'),
          hintText: 'Playlist name',
        ),
        AppTextField(
          controller: TextEditingController(text: 'a'),
          hintText: 'Playlist name',
          errorText: 'Name is too short',
        ),
      ],
    );
  }

  testWidgets('AppTextField - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_text_field_light.png'),
    );
  });

  testWidgets('AppTextField - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_text_field_dark.png'),
    );
  });
}
