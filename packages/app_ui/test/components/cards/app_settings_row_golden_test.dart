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
      child: AppSectionContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSettingsRow(
              icon: Icons.person_outline_rounded,
              label: 'Name',
              value: 'Dario',
            ),
            const Divider(height: 1),
            AppSettingsRow(
              icon: Icons.language_rounded,
              label: 'Language',
              value: 'English',
              onTap: () {},
            ),
            const Divider(height: 1),
            AppSettingsRow(
              icon: Icons.dark_mode_outlined,
              label: 'Dark mode',
              trailing: AppSwitch(value: true, onChanged: (_) {}),
            ),
            const Divider(height: 1),
            AppSettingsRow(
              icon: Icons.delete_outline_rounded,
              label: 'Delete account',
              destructive: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('AppSettingsRow - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_settings_row_light.png'),
    );
  });

  testWidgets('AppSettingsRow - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_settings_row_dark.png'),
    );
  });
}
