import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';
import 'package:music_app/src/features/search/presentation/widgets/search_results_list.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_key_value_storage.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository({
    this.tracks = const [],
    this.albums = const [],
    this.artists = const [],
  });

  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(albums);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

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

Track _track({
  required String id,
  required String title,
  String artistId = 'artist-1',
  String albumId = 'album-1',
  bool isMissing = false,
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: artistId,
    albumId: albumId,
    duration: const Duration(minutes: 3, seconds: 5),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    isMissing: isMissing,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

const _artist = Artist(
  id: 'artist-1',
  sourceId: 'artist-1',
  name: 'Charcoal',
  albumCount: 1,
  trackCount: 1,
);

const _album = Album(
  id: 'album-1',
  sourceId: 'album-1',
  title: 'Chill Vibes',
  artistId: 'artist-1',
  trackCount: 1,
  totalDuration: Duration(minutes: 3, seconds: 5),
);

/// Routes the detail screens the result rows push, so a tap can be asserted
/// by the destination it lands on.
GoRouter _router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: SearchResultsList()),
      ),
      GoRoute(
        name: RouteNames.album,
        path: '/albums/:albumId',
        builder: (context, state) =>
            Scaffold(body: Text('Album ${state.pathParameters['albumId']}')),
      ),
      GoRoute(
        name: RouteNames.artist,
        path: '/artists/:artistId',
        builder: (context, state) =>
            Scaffold(body: Text('Artist ${state.pathParameters['artistId']}')),
      ),
      GoRoute(
        name: RouteNames.playlist,
        path: '/playlists/:playlistId',
        builder: (context, state) => Scaffold(
          body: Text('Playlist ${state.pathParameters['playlistId']}'),
        ),
      ),
    ],
  );
}

/// Pumps the results list and, when [term] is not empty, submits it.
///
/// The playlist stream only starts once a non-empty term makes the results
/// provider watch it, so the tree is settled before returning.
Future<ProviderContainer> _pumpResults(
  WidgetTester tester, {
  String term = '',
  List<Track> tracks = const [],
  List<Album> albums = const [],
  List<Artist> artists = const [],
  List<String> playlistNames = const [],
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  final playlistRepository = FakePlaylistRepository();
  for (final name in playlistNames) {
    await playlistRepository.createPlaylist(name);
  }

  final router = _router();
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(
            tracks: tracks,
            albums: albums,
            artists: artists,
          ),
        ),
        playlistRepositoryProvider.overrideWithValue(playlistRepository),
        keyValueStorageProvider.overrideWithValue(FakeKeyValueStorage()),
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();

  final container = ProviderScope.containerOf(
    tester.element(find.byType(SearchResultsList)),
  );
  if (term.isNotEmpty) {
    container.read(searchViewModelProvider.notifier).submit(term);
    await tester.pumpAndSettle();
  }
  return container;
}

void main() {
  testWidgets('renders nothing while the term is empty', (tester) async {
    await _pumpResults(
      tester,
      tracks: [_track(id: 'track-1', title: 'Night Drive')],
    );

    expect(find.text('Night Drive'), findsNothing);
    expect(find.byType(AppEmptyState), findsNothing);
  });

  testWidgets('shows the empty state when the term matches nothing', (
    tester,
  ) async {
    await _pumpResults(
      tester,
      term: 'nothing here',
      tracks: [_track(id: 'track-1', title: 'Night Drive')],
    );

    expect(find.byType(AppEmptyState), findsOneWidget);
  });

  testWidgets('groups matches under a heading per type', (tester) async {
    await _pumpResults(
      tester,
      term: 'ch',
      tracks: [
        _track(id: 'track-1', title: 'Chasing Cars', artistId: 'artist-2'),
      ],
      albums: const [_album],
      artists: const [_artist],
      playlistNames: const ['Chill Mix'],
    );

    expect(find.text('Tracks'), findsOneWidget);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Artists'), findsOneWidget);
    expect(find.text('Playlists'), findsOneWidget);

    expect(find.text('Chasing Cars'), findsOneWidget);
    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Chill Mix'), findsOneWidget);
  });

  testWidgets('omits the heading of a group with no matches', (tester) async {
    await _pumpResults(
      tester,
      term: 'night',
      tracks: [_track(id: 'track-1', title: 'Night Drive')],
      albums: const [_album],
      artists: const [_artist],
    );

    expect(find.text('Tracks'), findsOneWidget);
    expect(find.text('Albums'), findsNothing);
    expect(find.text('Artists'), findsNothing);
    expect(find.text('Playlists'), findsNothing);
  });

  testWidgets('shows a track row with its artist and duration', (tester) async {
    await _pumpResults(
      tester,
      term: 'night',
      tracks: [_track(id: 'track-1', title: 'Night Drive')],
      artists: const [_artist],
    );

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('3:05'), findsOneWidget);
  });

  testWidgets('leaves missing tracks out of the results', (tester) async {
    await _pumpResults(
      tester,
      term: 'night',
      tracks: [
        _track(id: 'track-1', title: 'Night Drive', isMissing: true),
        _track(id: 'track-2', title: 'Night Shift'),
      ],
    );

    expect(find.text('Night Drive'), findsNothing);
    expect(find.text('Night Shift'), findsOneWidget);
  });

  testWidgets('tapping a track plays the results from that position', (
    tester,
  ) async {
    final container = await _pumpResults(
      tester,
      term: 'night',
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Night Shift'),
      ],
    );

    await tester.tap(find.text('Night Shift'));
    await tester.pump(const Duration(milliseconds: 50));

    final snapshot = container.read(audioPlayerServiceProvider).snapshot;
    expect(snapshot.queueLength, 2);
    expect(snapshot.currentIndex, 1);
    expect(snapshot.playing, isTrue);
  });

  testWidgets('tapping an album opens its detail route', (tester) async {
    await _pumpResults(tester, term: 'chill', albums: const [_album]);

    await tester.tap(find.text('Chill Vibes'));
    await tester.pumpAndSettle();

    expect(find.text('Album album-1'), findsOneWidget);
  });

  testWidgets('tapping an artist opens its detail route', (tester) async {
    await _pumpResults(tester, term: 'charcoal', artists: const [_artist]);

    await tester.tap(find.text('Charcoal'));
    await tester.pumpAndSettle();

    expect(find.text('Artist artist-1'), findsOneWidget);
  });

  testWidgets('tapping a playlist opens its detail route', (tester) async {
    await _pumpResults(
      tester,
      term: 'road',
      playlistNames: const ['Road Trip'],
    );

    await tester.tap(find.text('Road Trip'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Playlist '), findsOneWidget);
  });
}
