import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/widgets/artists_tab.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.artists, {this.tracks});

  final List<Artist> artists;

  /// The library's tracks; two per artist by default, since an artist with
  /// nothing left on the device is not listed at all.
  final List<Track>? tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(
    tracks ??
        [
          for (final artist in artists) ...[
            _track(id: '${artist.id}-1', artistId: artist.id),
            _track(id: '${artist.id}-2', artistId: artist.id),
          ],
        ],
  );

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

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

Artist _artist({required String id, required String name}) {
  return Artist(
    id: id,
    sourceId: id,
    name: name,
    albumCount: 1,
    trackCount: 5,
  );
}

Track _track({
  required String id,
  required String artistId,
  bool isMissing = false,
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: 'Track $id',
    artistId: artistId,
    albumId: 'album-1',
    duration: const Duration(minutes: 4),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    isMissing: isMissing,
  );
}

Widget _app(List<Artist> artists, {GoRouter? router, List<Track>? tracks}) {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(artists, tracks: tracks),
      ),
    ],
    child: router == null
        ? MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: ArtistsTab()),
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
  testWidgets('lists every indexed artist', (tester) async {
    await tester.pumpWidget(
      _app([
        _artist(id: 'artist-1', name: 'Charcoal'),
        _artist(id: 'artist-2', name: 'Brambles'),
      ]),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Brambles'), findsOneWidget);
  });

  testWidgets('counts only the tracks still on the device', (tester) async {
    await tester.pumpWidget(
      _app(
        [_artist(id: 'artist-1', name: 'Charcoal')],
        tracks: [
          _track(id: 'track-1', artistId: 'artist-1'),
          _track(id: 'track-2', artistId: 'artist-1', isMissing: true),
        ],
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('1 track'), findsOneWidget);
  });

  testWidgets('leaves out an artist whose files are all gone', (tester) async {
    await tester.pumpWidget(
      _app(
        [
          _artist(id: 'artist-1', name: 'Charcoal'),
          _artist(id: 'artist-2', name: 'Brambles'),
        ],
        tracks: [
          _track(id: 'track-1', artistId: 'artist-1'),
          _track(id: 'track-2', artistId: 'artist-2', isMissing: true),
        ],
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Brambles'), findsNothing);
  });

  testWidgets('shows the empty state when there are no artists', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const []));
    await tester.pump();

    expect(find.text('No artists yet'), findsOneWidget);
  });

  testWidgets('tapping an artist opens its detail route', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: ArtistsTab()),
        ),
        GoRoute(
          name: 'artist',
          path: '/artists/:artistId',
          builder: (context, state) => Scaffold(
            body: Text('Artist ${state.pathParameters['artistId']}'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      _app([_artist(id: 'artist-1', name: 'Charcoal')], router: router),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Charcoal'));
    await tester.pumpAndSettle();

    expect(find.text('Artist artist-1'), findsOneWidget);
  });
}
