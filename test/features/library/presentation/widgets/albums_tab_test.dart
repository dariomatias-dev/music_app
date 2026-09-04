import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/widgets/albums_tab.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.albums, {this.tracks});

  final List<Album> albums;

  /// The library's tracks; one per album by default, since an album with
  /// nothing left on the device is not listed at all.
  final List<Track>? tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(
    tracks ?? [for (final album in albums) _track(albumId: album.id)],
  );

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Charcoal',
      albumCount: 1,
      trackCount: 1,
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

Album _album({
  required String id,
  required String title,
  String? artworkPath,
}) {
  return Album(
    id: id,
    sourceId: id,
    title: title,
    artistId: 'artist-1',
    trackCount: 3,
    totalDuration: const Duration(minutes: 12),
    artworkPath: artworkPath,
  );
}

Track _track({required String albumId, bool isMissing = false}) {
  return Track(
    id: 'track-$albumId',
    sourceId: 'track-$albumId',
    filePath: '/music/$albumId.mp3',
    title: 'Track $albumId',
    artistId: 'artist-1',
    albumId: albumId,
    duration: const Duration(minutes: 4),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    isMissing: isMissing,
  );
}

Widget _app(List<Album> albums, {GoRouter? router, List<Track>? tracks}) {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(albums, tracks: tracks),
      ),
    ],
    child: router == null
        ? MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: AlbumsTab()),
          )
        : MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
  );
}

void main() {
  testWidgets('lists every indexed album', (tester) async {
    await tester.pumpWidget(
      _app([
        _album(id: 'album-1', title: 'Chill Vibes'),
        _album(id: 'album-2', title: 'Night Drive'),
      ]),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
  });

  testWidgets('leaves out an album whose files are all gone', (tester) async {
    await tester.pumpWidget(
      _app(
        [
          _album(id: 'album-1', title: 'Chill Vibes'),
          _album(id: 'album-2', title: 'Night Drive'),
        ],
        tracks: [
          _track(albumId: 'album-1'),
          _track(albumId: 'album-2', isMissing: true),
        ],
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Night Drive'), findsNothing);
  });

  testWidgets('shows the empty state when there are no albums', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const []));
    await tester.pump();

    expect(find.text('No albums yet'), findsOneWidget);
  });

  testWidgets('tapping an album opens its detail route', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: AlbumsTab()),
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

    await tester.pumpWidget(
      _app([_album(id: 'album-1', title: 'Chill Vibes')], router: router),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Chill Vibes'));
    await tester.pumpAndSettle();

    expect(find.text('Album album-1'), findsOneWidget);
  });

  testWidgets('shows the cover of an album that has one', (tester) async {
    await tester.pumpWidget(
      _app([
        _album(
          id: 'album-1',
          title: 'Chill Vibes',
          artworkPath: '/covers/album-1.jpg',
        ),
      ]),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(CachedSquareImage), findsOneWidget);
    expect(find.byType(AppArtwork), findsNothing);
    tester.takeException();
  });

  testWidgets('falls back to a procedural cover without one', (tester) async {
    await tester.pumpWidget(
      _app([_album(id: 'album-1', title: 'Chill Vibes')]),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(AppArtwork), findsOneWidget);
    expect(find.byType(CachedSquareImage), findsNothing);
  });
}
