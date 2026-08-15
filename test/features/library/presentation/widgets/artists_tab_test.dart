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
  const _FakeLibraryRepository(this.artists);

  final List<Artist> artists;

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

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

Widget _app(List<Artist> artists, {GoRouter? router}) {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(artists),
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

    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Brambles'), findsOneWidget);
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

    await tester.tap(find.text('Charcoal'));
    await tester.pumpAndSettle();

    expect(find.text('Artist artist-1'), findsOneWidget);
  });
}
