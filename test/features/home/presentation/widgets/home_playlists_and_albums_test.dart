import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/history/data/providers/history_data_providers.dart';
import 'package:music_app/src/features/home/presentation/widgets/home_playlists_and_albums.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';

import '../../../../helpers/fake_play_history_repository.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.albums);

  final List<Album> albums;

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(albums);

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

Album _album({required String id, required String title}) {
  return Album(
    id: id,
    sourceId: id,
    title: title,
    artistId: 'artist-1',
    trackCount: 3,
    totalDuration: const Duration(minutes: 9),
  );
}

Future<void> _pumpWidget(
  WidgetTester tester, {
  required List<Album> albums,
  required FakePlaylistRepository playlistRepository,
  GoRouter? router,
}) async {
  final overrides = [
    libraryRepositoryProvider.overrideWithValue(
      _FakeLibraryRepository(albums),
    ),
    playHistoryRepositoryProvider.overrideWithValue(
      FakePlayHistoryRepository(),
    ),
    playlistRepositoryProvider.overrideWithValue(playlistRepository),
  ];

  if (router != null) {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
  } else {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: HomePlaylistsAndAlbums()),
        ),
      ),
    );
  }
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders nothing when there are no playlists or albums', (
    tester,
  ) async {
    await _pumpWidget(
      tester,
      albums: const [],
      playlistRepository: FakePlaylistRepository(),
    );

    expect(find.text('Playlists'), findsNothing);
    expect(find.text('Albums'), findsNothing);
  });

  testWidgets('shows only the albums row when there are no playlists', (
    tester,
  ) async {
    await _pumpWidget(
      tester,
      albums: [_album(id: 'album-1', title: 'Chill Vibes')],
      playlistRepository: FakePlaylistRepository(),
    );

    expect(find.text('Playlists'), findsNothing);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Chill Vibes'), findsOneWidget);
  });

  testWidgets('shows both rows when there are playlists and albums', (
    tester,
  ) async {
    final playlistRepository = FakePlaylistRepository();
    await playlistRepository.createPlaylist('Road Trip');

    await _pumpWidget(
      tester,
      albums: [_album(id: 'album-1', title: 'Chill Vibes')],
      playlistRepository: playlistRepository,
    );

    expect(find.text('Playlists'), findsOneWidget);
    expect(find.text('Road Trip'), findsOneWidget);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Chill Vibes'), findsOneWidget);
  });

  testWidgets('renders a separator between multiple cards in a row', (
    tester,
  ) async {
    await _pumpWidget(
      tester,
      albums: [
        _album(id: 'album-1', title: 'Chill Vibes'),
        _album(id: 'album-2', title: 'Night Drive'),
      ],
      playlistRepository: FakePlaylistRepository(),
    );

    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
  });

  testWidgets('tapping an album opens its detail route', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: HomePlaylistsAndAlbums()),
        ),
        GoRoute(
          name: 'album',
          path: '/albums/:albumId',
          builder: (context, state) => Scaffold(
            body: Text('Album ${state.pathParameters['albumId']}'),
          ),
        ),
      ],
    );

    await _pumpWidget(
      tester,
      albums: [_album(id: 'album-1', title: 'Chill Vibes')],
      playlistRepository: FakePlaylistRepository(),
      router: router,
    );

    await tester.tap(find.text('Chill Vibes'));
    await tester.pumpAndSettle();

    expect(find.text('Album album-1'), findsOneWidget);
  });

  testWidgets('tapping a playlist opens its detail route', (tester) async {
    final playlistRepository = FakePlaylistRepository();
    final id = await playlistRepository.createPlaylist('Road Trip');

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: HomePlaylistsAndAlbums()),
        ),
        GoRoute(
          name: 'playlist',
          path: '/playlists/:playlistId',
          builder: (context, state) => Scaffold(
            body: Text('Playlist ${state.pathParameters['playlistId']}'),
          ),
        ),
      ],
    );

    await _pumpWidget(
      tester,
      albums: const [],
      playlistRepository: playlistRepository,
      router: router,
    );

    await tester.tap(find.text('Road Trip'));
    await tester.pumpAndSettle();

    expect(find.text('Playlist $id'), findsOneWidget);
  });
}
