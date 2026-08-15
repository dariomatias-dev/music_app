import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/home/presentation/widgets/home_library_summary.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository({
    required this.tracks,
    required this.albums,
    required this.artists,
  });

  final List<Track> tracks;
  final List<Album> albums;
  final List<Artist> artists;

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
}

Track _track({required String id, Duration? duration, bool isMissing = false}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: id,
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: duration ?? const Duration(minutes: 30),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    isMissing: isMissing,
  );
}

void main() {
  testWidgets('shows counts and total duration, excluding missing tracks', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryRepositoryProvider.overrideWithValue(
            _FakeLibraryRepository(
              tracks: [
                _track(id: 'track-1', duration: const Duration(hours: 1)),
                _track(id: 'track-2', duration: const Duration(minutes: 30)),
                _track(id: 'track-3', isMissing: true),
              ],
              albums: const [
                Album(
                  id: 'album-1',
                  sourceId: 'album-1',
                  title: 'Chill Vibes',
                  artistId: 'artist-1',
                  trackCount: 2,
                  totalDuration: Duration(hours: 1, minutes: 30),
                ),
              ],
              artists: const [
                Artist(
                  id: 'artist-1',
                  sourceId: 'artist-1',
                  name: 'Charcoal',
                  albumCount: 1,
                  trackCount: 2,
                ),
              ],
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: HomeLibrarySummary()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
    expect(find.text('Tracks'), findsOneWidget);
    // Both albums and artists count 1 in this fixture.
    expect(find.text('1'), findsNWidgets(2));
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Artists'), findsOneWidget);
    expect(find.text('1h 30m'), findsOneWidget);
    expect(find.text('Total time'), findsOneWidget);
  });

  testWidgets('tapping storage opens the storage route', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: HomeLibrarySummary()),
        ),
        GoRoute(
          path: '/storage',
          builder: (context, state) =>
              const Scaffold(body: Text('Storage screen reached')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryRepositoryProvider.overrideWithValue(
            const _FakeLibraryRepository(tracks: [], albums: [], artists: []),
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

    await tester.tap(find.text('Storage'));
    await tester.pumpAndSettle();

    expect(find.text('Storage screen reached'), findsOneWidget);
  });
}
