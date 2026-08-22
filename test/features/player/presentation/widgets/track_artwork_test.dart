import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/player/presentation/widgets/track_artwork.dart';

Future<void> _pumpArtwork(WidgetTester tester, QueueMediaItem item) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(child: TrackArtwork(item: item, size: 64, radius: 12)),
      ),
    ),
  );
}

void main() {
  testWidgets('draws a procedural cover when nothing is cached', (
    tester,
  ) async {
    await _pumpArtwork(
      tester,
      const QueueMediaItem(
        id: 'track-1',
        filePath: '/music/a.mp3',
        title: 'Night Drive',
      ),
    );

    expect(find.byType(AppArtwork), findsOneWidget);
    expect(find.byType(CachedSquareImage), findsNothing);
  });

  testWidgets('draws the cached artwork when there is one', (tester) async {
    await _pumpArtwork(
      tester,
      const QueueMediaItem(
        id: 'track-1',
        filePath: '/music/a.mp3',
        title: 'Night Drive',
        artworkPath: '/covers/album-1.jpg',
      ),
    );

    expect(find.byType(CachedSquareImage), findsOneWidget);
    expect(find.byType(AppArtwork), findsNothing);
    expect(find.byType(ClipRRect), findsOneWidget);
    tester.takeException();
  });

  testWidgets('is laid out at the requested size', (tester) async {
    await _pumpArtwork(
      tester,
      const QueueMediaItem(
        id: 'track-1',
        filePath: '/music/a.mp3',
        title: 'Night Drive',
      ),
    );

    expect(tester.getSize(find.byType(TrackArtwork)), const Size(64, 64));
  });
}
