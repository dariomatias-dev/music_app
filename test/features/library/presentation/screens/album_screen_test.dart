import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/screens/album_screen.dart';

import '../../../../helpers/fake_audio_player_service.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.albums, this.tracks);

  final List<Album> albums;
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

Track _track({required String id, required String title, int? trackNumber}) {
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
    trackNumber: trackNumber,
  );
}

Future<ProviderContainer> _pumpAlbumScreen(
  WidgetTester tester, {
  required List<Album> albums,
  required List<Track> tracks,
  required String albumId,
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
          _FakeLibraryRepository(albums, tracks),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AlbumScreen(albumId: albumId),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();

  final element = tester.element(find.byType(AlbumScreen));
  return ProviderScope.containerOf(element);
}

/// Pumps the screen behind a router, so the artist link has somewhere to go.
Future<void> _pumpRoutedAlbumScreen(
  WidgetTester tester, {
  required List<Album> albums,
  required List<Track> tracks,
  required String albumId,
}) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => AlbumScreen(albumId: albumId),
      ),
      GoRoute(
        name: RouteNames.artist,
        path: '/artists/:artistId',
        builder: (context, state) =>
            Scaffold(body: Text('Artist ${state.pathParameters['artistId']}')),
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
          _FakeLibraryRepository(albums, tracks),
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
}

void main() {
  const album = Album(
    id: 'album-1',
    sourceId: 'album-1',
    title: 'Chill Vibes',
    artistId: 'artist-1',
    trackCount: 2,
    totalDuration: Duration(minutes: 6),
  );

  testWidgets('shows the not-found state for an unknown album', (
    tester,
  ) async {
    await _pumpAlbumScreen(
      tester,
      albums: const [],
      tracks: const [],
      albumId: 'missing',
    );

    expect(find.text('Album not found'), findsOneWidget);
  });

  testWidgets('shows the album header, artist and tracks', (tester) async {
    await _pumpAlbumScreen(
      tester,
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive', trackNumber: 1),
        _track(id: 'track-2', title: 'Sunset', trackNumber: 2),
      ],
      albumId: 'album-1',
    );

    expect(find.text('Chill Vibes'), findsWidgets);
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
  });

  testWidgets('tapping Play starts playback from the first track', (
    tester,
  ) async {
    final container = await _pumpAlbumScreen(
      tester,
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive', trackNumber: 1),
        _track(id: 'track-2', title: 'Sunset', trackNumber: 2),
      ],
      albumId: 'album-1',
    );

    await tester.tap(find.text('Play'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 0);
    expect(service.snapshot.queueLength, 2);
  });

  testWidgets('tapping a track plays from that position', (tester) async {
    final container = await _pumpAlbumScreen(
      tester,
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive', trackNumber: 1),
        _track(id: 'track-2', title: 'Sunset', trackNumber: 2),
      ],
      albumId: 'album-1',
    );

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 1);
  });

  testWidgets('shows a playback indicator on the currently playing row', (
    tester,
  ) async {
    await _pumpAlbumScreen(
      tester,
      albums: const [album],
      tracks: [
        _track(id: 'track-1', title: 'Night Drive', trackNumber: 1),
        _track(id: 'track-2', title: 'Sunset', trackNumber: 2),
      ],
      albumId: 'album-1',
    );

    expect(find.byType(AppPlaybackIndicator), findsNothing);

    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(AppPlaybackIndicator), findsOneWidget);
  });

  testWidgets('tapping the artist opens their screen', (tester) async {
    await _pumpRoutedAlbumScreen(
      tester,
      albums: const [album],
      tracks: [_track(id: 'track-1', title: 'Night Drive', trackNumber: 1)],
      albumId: 'album-1',
    );

    await tester.tap(find.text('Charcoal'));
    await tester.pumpAndSettle();

    expect(find.text('Artist artist-1'), findsOneWidget);
  });

  testWidgets('shows the embedded cover when the album has one', (
    tester,
  ) async {
    await _pumpAlbumScreen(
      tester,
      albums: const [
        Album(
          id: 'album-1',
          sourceId: 'album-1',
          title: 'Chill Vibes',
          artistId: 'artist-1',
          trackCount: 1,
          totalDuration: Duration(minutes: 3),
          artworkPath: '/covers/album-1.jpg',
        ),
      ],
      tracks: [_track(id: 'track-1', title: 'Night Drive', trackNumber: 1)],
      albumId: 'album-1',
    );

    expect(find.byType(CachedSquareImage), findsOneWidget);
    tester.takeException();
  });
}
