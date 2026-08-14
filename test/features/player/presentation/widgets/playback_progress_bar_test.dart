import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_progress_bar.dart';

import '../../../../helpers/fake_audio_player_service.dart';

const _item = QueueMediaItem(
  id: 'track-1',
  filePath: '/music/track-1.mp3',
  title: 'Night Drive',
);

void main() {
  testWidgets('shows elapsed and total time, toggling to remaining', (
    tester,
  ) async {
    final service = FakeAudioPlayerService();
    await service.setQueue(
      ['a.mp3'],
      initialPosition: const Duration(minutes: 1),
    );
    service.setDurationForTesting(const Duration(minutes: 3, seconds: 30));
    await service.play();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: PlaybackProgressBar(item: _item)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('1:00'), findsOneWidget);
    expect(find.text('3:30'), findsOneWidget);

    await tester.tap(find.text('3:30'));
    // The label swap animates; give it a moment to finish instead of
    // pumpAndSettle, since the waveform's breathing animation never
    // settles while playing.
    await tester.pump(AppDurations.fast);

    expect(find.text('-2:30'), findsOneWidget);
  });

  testWidgets('tapping the waveform seeks the player', (tester) async {
    final service = FakeAudioPlayerService();
    await service.setQueue(['a.mp3']);
    service.setDurationForTesting(const Duration(minutes: 4));
    await service.play();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: PlaybackProgressBar(item: _item)),
        ),
      ),
    );
    await tester.pump();

    final seekBar = find.byType(AppWaveformSeekBar);
    final topRight = tester.getTopRight(seekBar);
    final bottomLeft = tester.getBottomLeft(seekBar);
    await tester.tapAt(Offset(topRight.dx - 5, bottomLeft.dy - 5));
    await tester.pump();

    expect(service.snapshot.position, isNot(Duration.zero));
  });
}
