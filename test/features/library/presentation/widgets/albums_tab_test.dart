import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_names.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/widgets/albums_tab.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.albums);

  final List<Album> albums;

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

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
  Future<void> clearArtworkCache() async {}
}

Album _album({required String id, required String title}) {
  return Album(
    id: id,
    sourceId: id,
    title: title,
    artistId: 'artist-1',
    trackCount: 3,
    totalDuration: const Duration(minutes: 12),
  );
}

Widget _app(List<Album> albums, {GoRouter? router}) {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(albums),
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

    expect(find.text('Chill Vibes'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
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
          name: RouteNames.album,
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

    await tester.tap(find.text('Chill Vibes'));
    await tester.pumpAndSettle();

    expect(find.text('Album album-1'), findsOneWidget);
  });
}
