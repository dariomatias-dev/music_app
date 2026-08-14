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
      spacing: 16,
      children: [
        SizedBox(
          width: 280,
          child: AppWaveformSeekBar(
            progress: 0.3,
            isPlaying: false,
            seed: 1,
            onSeek: (_) {},
          ),
        ),
        SizedBox(
          width: 280,
          child: AppWaveformSeekBar(
            progress: 0.6,
            isPlaying: true,
            seed: 2,
            onSeek: (_) {},
          ),
        ),
      ],
    );
  }

  testWidgets('AppWaveformSeekBar - light', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.light);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_waveform_seek_bar_light.png'),
    );
  });

  testWidgets('AppWaveformSeekBar - dark', (tester) async {
    await pumpGolden(tester, buildGallery(), theme: AppTheme.dark);
    await expectLater(
      find.byKey(galleryKey),
      matchesGoldenFile('goldens/app_waveform_seek_bar_dark.png'),
    );
  });
}
