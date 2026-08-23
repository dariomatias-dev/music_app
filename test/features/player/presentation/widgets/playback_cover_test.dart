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

  group('dragging the cover', () {
    /// The horizontal offset the cover is currently translated by.
    double translationOf(WidgetTester tester) {
      final transform = tester.widget<Transform>(
        find
            .descendant(
              of: find.byType(PlaybackCover),
              matching: find.byType(Transform),
            )
            .first,
      );
      return transform.transform.getTranslation().x;
    }

    testWidgets('follows the finger, damped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: PlaybackCover(item: _item, playing: false),
          ),
        ),
      );
      await tester.pump();

      final drag = await tester.startGesture(
        tester.getCenter(find.byType(PlaybackCover)),
      );
      await drag.moveBy(const Offset(60, 0));
      await tester.pump();

      final offset = translationOf(tester);
      expect(offset, greaterThan(0));
      expect(offset, lessThan(60));

      await drag.up();
      await tester.pumpAndSettle();
    });

    testWidgets('never runs off further than the rubber band allows', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: PlaybackCover(item: _item, playing: false),
          ),
        ),
      );
      await tester.pump();

      final drag = await tester.startGesture(
        tester.getCenter(find.byType(PlaybackCover)),
      );
      await drag.moveBy(const Offset(600, 0));
      await tester.pump();

      expect(translationOf(tester), lessThanOrEqualTo(90));

      await drag.up();
      await tester.pumpAndSettle();
    });

    testWidgets('snaps back once the finger lifts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: PlaybackCover(item: _item, playing: false),
          ),
        ),
      );
      await tester.pump();

      final drag = await tester.startGesture(
        tester.getCenter(find.byType(PlaybackCover)),
      );
      await drag.moveBy(const Offset(-60, 0));
      await tester.pump();
      expect(translationOf(tester), lessThan(0));

      await drag.up();
      await tester.pumpAndSettle();

      expect(translationOf(tester), 0);
    });
  });
}
