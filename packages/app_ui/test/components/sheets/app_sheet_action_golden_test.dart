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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSheetAction(
            icon: Icons.playlist_add,
            label: 'Add to playlist',
            onTap: () {},
          ),
          AppSheetAction(
            icon: Icons.queue_music,
            label: 'Play next',
            trailing: '3 in queue',
            onTap: () {},
          ),
          AppSheetAction(
            icon: Icons.delete_outline,
            label: 'Remove from playlist',
            destructive: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  testWidgets('AppSheetAction - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_sheet_action_light.png'),
    );
  });

  testWidgets('AppSheetAction - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_sheet_action_dark.png'),
    );
  });
}
