import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_cover.dart';

const _item = QueueMediaItem(
  id: 'track-1',
  filePath: '/music/track-1.mp3',
  title: 'Night Drive',
);

void main() {
  testWidgets('stops the breathing animation when playback is paused', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: PlaybackCover(item: _item, playing: true)),
      ),
    );
    await tester.pump();
    // An active repeating AnimationController keeps a transient frame
    // callback registered for as long as it's ticking.
    expect(SchedulerBinding.instance.transientCallbackCount, greaterThan(0));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: PlaybackCover(item: _item, playing: false),
        ),
      ),
    );
    await tester.pump();

    expect(SchedulerBinding.instance.transientCallbackCount, 0);
  });

  testWidgets('does not animate when reduced motion is enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: PlaybackCover(item: _item, playing: true),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(SchedulerBinding.instance.transientCallbackCount, 0);
  });
}
