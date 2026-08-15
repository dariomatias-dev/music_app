import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/playlist/presentation/screens/playlist_screen.dart';
import 'package:music_app/src/features/playlist/presentation/widgets/playlist_cover_art.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 2,
    ),
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {}
}

Track _track({required String id, required String title}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

Future<ProviderContainer> _pumpPlaylistScreen(
  WidgetTester tester, {
  required FakePlaylistRepository playlistRepository,
  required List<Track> tracks,
  required String playlistId,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(tracks),
        ),
        playlistRepositoryProvider.overrideWithValue(playlistRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PlaylistScreen(playlistId: playlistId),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump();

  final element = tester.element(find.byType(PlaylistScreen));
  return ProviderScope.containerOf(element);
}

void main() {
  testWidgets('shows the empty state for a playlist with no tracks', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: const [],
      playlistId: id,
    );

    expect(find.text('This playlist is empty'), findsOneWidget);
  });

  testWidgets('shows tracks and the total duration', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('2 tracks · 6:00'), findsOneWidget);
  });

  testWidgets('tapping a track plays from that position', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    final container = await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('removing a track requires confirmation', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pumpAndSettle();

    expect(find.text('Remove track?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await repository.watchPlaylistTrackIds(id).first, ['track-2']);
  });

  testWidgets('tapping Play plays the whole playlist from the start', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    final container = await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Play'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
    expect(service.snapshot.queueLength, 2);
  });

  testWidgets('tapping Shuffle plays the playlist in some order', (
    tester,
  ) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    final container = await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    await tester.tap(find.text('Shuffle'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
    expect(service.snapshot.queueLength, 2);
  });

  testWidgets('shows a composed cover for the playlist', (tester) async {
    final repository = FakePlaylistRepository();
    final id = await repository.createPlaylist('Road Trip');
    await repository.setPlaylistTracks(id, ['track-1', 'track-2']);

    await _pumpPlaylistScreen(
      tester,
      playlistRepository: repository,
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      playlistId: id,
    );

    expect(find.byType(PlaylistCoverArt), findsOneWidget);
  });
}
