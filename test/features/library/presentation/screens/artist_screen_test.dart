import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/screens/artist_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.artists, this.albums, this.tracks);

  final List<Artist> artists;
  final List<Album> albums;
  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

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

Track _track({required String id, required String title, String? albumId}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: 'artist-1',
    albumId: albumId ?? 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
  );
}

/// Pumps the screen behind a router, so an album card has somewhere to go.
Future<void> _pumpRoutedArtistScreen(
  WidgetTester tester, {
  required List<Artist> artists,
  required List<Album> albums,
  required List<Track> tracks,
  required String artistId,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  tester.view.physicalSize = const Size(800, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => ArtistScreen(artistId: artistId),
      ),
      GoRoute(
        name: 'album',
        path: '/albums/:albumId',
        builder: (context, state) =>
            Scaffold(body: Text('Album ${state.pathParameters['albumId']}')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(artists, albums, tracks),
        ),
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
  await tester.pump();
  await tester.pump();
}

Future<ProviderContainer> _pumpArtistScreen(
  WidgetTester tester, {
  required List<Artist> artists,
  required List<Album> albums,
  required List<Track> tracks,
  required String artistId,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  // The default 800x600 test surface leaves the last row a few pixels
  // short with real fonts loaded (vs. the fallback test font).
  tester.view.physicalSize = const Size(800, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(artists, albums, tracks),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ArtistScreen(artistId: artistId),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump();

  final element = tester.element(find.byType(ArtistScreen));
  return ProviderScope.containerOf(element);
}

void main() {
  const artist = Artist(
    id: 'artist-1',
    sourceId: 'artist-1',
    name: 'Charcoal',
    albumCount: 1,
    trackCount: 2,
  );
  const album = Album(
    id: 'album-1',
    sourceId: 'album-1',
    title: 'Chill Vibes',
    artistId: 'artist-1',
    trackCount: 2,
    totalDuration: Duration(minutes: 6),
  );

  testWidgets('shows the not-found state for an unknown artist', (
    tester,
  ) async {
    await _pumpArtistScreen(
      tester,
      artists: const [],
      albums: const [],
      tracks: const [],
      artistId: 'missing',
    );

    expect(find.text('Artist not found'), findsOneWidget);
  });

  testWidgets('shows the artist name, albums and tracks', (tester) async {
    await _pumpArtistScreen(
      tester,
      artists: const [artist],
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      artistId: 'artist-1',
    );

    expect(find.text('Charcoal'), findsWidgets);
    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
  });

  testWidgets('tapping Play plays the whole discography', (tester) async {
    final container = await _pumpArtistScreen(
      tester,
      artists: const [artist],
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      artistId: 'artist-1',
    );

    await tester.tap(find.text('Play'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
    expect(service.snapshot.queueLength, 2);
  });

  testWidgets('tapping a track plays from that position', (tester) async {
    final container = await _pumpArtistScreen(
      tester,
      artists: const [artist],
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      artistId: 'artist-1',
    );

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('shows a playback indicator on the currently playing row', (
    tester,
  ) async {
    await _pumpArtistScreen(
      tester,
      artists: const [artist],
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      artistId: 'artist-1',
    );

    expect(find.byType(AppPlaybackIndicator), findsNothing);

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(AppPlaybackIndicator), findsOneWidget);
  });

  testWidgets('shows tracks with no albums row when the artist has none', (
    tester,
  ) async {
    await _pumpArtistScreen(
      tester,
      artists: const [artist],
      albums: const [],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive'),
        _track(id: 'track-2', title: 'Sunset'),
      ],
      artistId: 'artist-1',
    );

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('Albums'), findsNothing);
  });

  testWidgets(
    'lazily builds a large discography, not every row upfront',
    (tester) async {
      final tracks = [
        for (var i = 0; i < 500; i++) _track(id: 'track-$i', title: 'Track $i'),
      ];

      await _pumpArtistScreen(
        tester,
        artists: const [artist],
        albums: const [],
        tracks: tracks,
        artistId: 'artist-1',
      );

      // Only rows near the top of the viewport are actually built, not
      // all 500 upfront.
      expect(find.textContaining('Track ').evaluate().length, lessThan(50));
      expect(find.text('Track 499'), findsNothing);
    },
  );

  testWidgets('tapping an album opens it', (tester) async {
    await _pumpRoutedArtistScreen(
      tester,
      artists: const [artist],
      albums: const [album],
      tracks: [_track(id: 'track-1', title: 'Night Drive')],
      artistId: 'artist-1',
    );

    await tester.tap(find.text('Chill Vibes'));
    await tester.pumpAndSettle();

    expect(find.text('Album album-1'), findsOneWidget);
  });

  testWidgets('spaces the discography carousel between albums', (
    tester,
  ) async {
    await _pumpArtistScreen(
      tester,
      artists: const [artist],
      albums: const [
        album,
        Album(
          id: 'album-2',
          sourceId: 'album-2',
          title: 'Night Shift',
          artistId: 'artist-1',
          trackCount: 1,
          totalDuration: Duration(minutes: 4),
        ),
      ],
      tracks: [_track(id: 'track-1', title: 'Night Drive')],
      artistId: 'artist-1',
    );

    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Night Shift'), findsOneWidget);
  });
}
