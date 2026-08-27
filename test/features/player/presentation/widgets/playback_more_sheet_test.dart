import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/queue_media_item.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/player/presentation/widgets/playback_more_sheet.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> updateTrackTags(
    String trackId, {
    required String title,
    required String artist,
    required String album,
  }) async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Track _track() {
  return Track(
    id: 'track-1',
    sourceId: 'track-1',
    filePath: '/music/night-drive.flac',
    title: 'Night Drive',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'flac',
    fileSize: 12000000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

const _item = QueueMediaItem(
  id: 'track-1',
  filePath: '/music/night-drive.flac',
  title: 'Night Drive',
  artist: 'Charcoal',
);

Widget _app({
  FakePlaylistRepository? playlistRepository,
  List<Track> tracks = const [],
  FakeAudioPlayerService? audioService,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => showPlaybackMoreSheet(context, ref, _item),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        name: 'queue',
        path: '/player/queue',
        builder: (context, state) => const Scaffold(body: Text('Queue screen')),
      ),
      GoRoute(
        name: 'lyrics',
        path: '/player/lyrics',
        builder: (context, state) =>
            const Scaffold(body: Text('Lyrics screen')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      playlistRepositoryProvider.overrideWithValue(
        playlistRepository ?? FakePlaylistRepository(),
      ),
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(tracks),
      ),
      audioPlayerServiceProvider.overrideWithValue(
        audioService ?? FakeAudioPlayerService(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows the track and every action', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Queue'), findsOneWidget);
    expect(find.text('Add to playlist'), findsOneWidget);
    expect(find.text('Lyrics'), findsOneWidget);
    expect(find.text('Sleep timer'), findsOneWidget);
    expect(find.text('File information'), findsOneWidget);
  });

  testWidgets('view queue closes the sheet and navigates to the queue', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Queue'));
    await tester.pumpAndSettle();

    expect(find.text('Queue screen'), findsOneWidget);
    expect(find.text('Add to playlist'), findsNothing);
  });

  testWidgets('open lyrics closes the sheet and navigates to lyrics', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lyrics'));
    await tester.pumpAndSettle();

    expect(find.text('Lyrics screen'), findsOneWidget);
  });

  testWidgets('add to playlist closes the sheet and opens the picker', (
    tester,
  ) async {
    final playlistRepository = FakePlaylistRepository();
    await playlistRepository.createPlaylist('Road Trip');

    await tester.pumpWidget(_app(playlistRepository: playlistRepository));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to playlist'));
    await tester.pumpAndSettle();

    expect(find.text('Queue'), findsNothing);
    expect(find.text('Road Trip'), findsOneWidget);
  });

  testWidgets('sleep timer closes the sheet and opens the timer', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sleep timer'));
    await tester.pumpAndSettle();

    expect(find.text('Queue'), findsNothing);
    expect(find.text('15 min'), findsOneWidget);
  });

  testWidgets('file information closes the sheet and opens the dialog', (
    tester,
  ) async {
    await tester.pumpWidget(_app(tracks: [_track()]));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('File information'));
    await tester.pumpAndSettle();

    expect(find.text('Queue'), findsNothing);
    expect(find.textContaining('FLAC'), findsOneWidget);
  });
}
