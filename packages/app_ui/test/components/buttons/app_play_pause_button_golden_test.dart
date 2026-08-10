import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_golden.dart';

void main() {
  Widget buildGallery() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        AppPlayPauseButton(isPlaying: false, onTap: () {}),
        AppPlayPauseButton(isPlaying: true, onTap: () {}),
        AppPlayPauseButton(isPlaying: true, progress: 0.4, onTap: () {}),
        AppPlayPauseButton(isPlaying: false, filled: false, onTap: () {}),
      ],
    );
  }

  testWidgets('AppPlayPauseButton - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/app_play_pause_button_light.png'),
    );
  });

  testWidgets('AppPlayPauseButton - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/app_play_pause_button_dark.png'),
    );
  });
}
