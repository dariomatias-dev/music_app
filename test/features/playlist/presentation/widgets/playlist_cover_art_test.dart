import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_cover_art.dart';

void main() {
  testWidgets('falls back to a single procedural cover when empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: PlaylistCoverArt(
            playlistId: 'playlist-1',
            tracks: [],
            size: 120,
          ),
        ),
      ),
    );

    expect(find.byType(AppArtwork), findsOneWidget);
  });

  testWidgets('renders a 2x2 mosaic from up to 4 tracks', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: PlaylistCoverArt(
            playlistId: 'playlist-1',
            tracks: [
              (seed: 'track-1', artworkPath: null),
              (seed: 'track-2', artworkPath: null),
              (seed: 'track-3', artworkPath: null),
            ],
            size: 120,
          ),
        ),
      ),
    );

    // 3 unique tracks repeat to fill all 4 quadrants.
    expect(find.byType(AppArtwork), findsNWidgets(4));
  });
}
