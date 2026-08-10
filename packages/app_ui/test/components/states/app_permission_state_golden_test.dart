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
      child: AppPermissionState(
        icon: Icons.folder_off,
        title: 'Media access needed',
        message: 'Music App needs access to your media to show your songs.',
        grantLabel: 'Grant access',
        onGrant: () {},
        openSettingsLabel: 'Open settings',
        onOpenSettings: () {},
      ),
    );
  }

  testWidgets('AppPermissionState - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_permission_state_light.png'),
    );
  });

  testWidgets('AppPermissionState - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_permission_state_dark.png'),
    );
  });
}
