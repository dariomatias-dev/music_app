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
      child: AppNavigationBar(
        items: const [
          AppNavigationItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
          ),
          AppNavigationItem(
            icon: Icons.search,
            activeIcon: Icons.search,
            label: 'Search',
          ),
          AppNavigationItem(
            icon: Icons.library_music_outlined,
            activeIcon: Icons.library_music,
            label: 'Library',
          ),
        ],
        index: 0,
        onChanged: (_) {},
      ),
    );
  }

  testWidgets('AppNavigationBar - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_navigation_bar_light.png'),
    );
  });

  testWidgets('AppNavigationBar - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_navigation_bar_dark.png'),
    );
  });
}
