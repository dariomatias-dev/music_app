import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/search/data/providers/search_data_providers.dart';
import 'package:music_app/src/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';

import '../../../../helpers/fake_playlist_repository.dart';
import '../../../../helpers/fake_search_history_repository.dart';

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
      trackCount: 1,
    ),
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

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

Widget _app({
  List<Track> tracks = const [],
  List<String> recentSearches = const [],
}) {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        _FakeLibraryRepository(tracks),
      ),
      playlistRepositoryProvider.overrideWithValue(FakePlaylistRepository()),
      searchHistoryRepositoryProvider.overrideWithValue(
        FakeSearchHistoryRepository(recentSearches),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SearchScreen()),
    ),
  );
}

void main() {
  testWidgets('shows the search field with its hint', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Search your library'), findsOneWidget);
  });

  testWidgets('typing updates the term after the debounce settles', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    final element = tester.element(find.byType(SearchScreen));
    final container = ProviderScope.containerOf(element)
      ..listen(searchViewModelProvider, (_, _) {});

    await tester.enterText(find.byType(TextField), 'Chill');
    await tester.pump(const Duration(milliseconds: 400));

    expect(container.read(searchViewModelProvider), 'Chill');
  });

  testWidgets('tapping clear empties the field and the term', (tester) async {
    await tester.pumpWidget(_app());

    final element = tester.element(find.byType(SearchScreen));
    final container = ProviderScope.containerOf(element)
      ..listen(searchViewModelProvider, (_, _) {});

    await tester.enterText(find.byType(TextField), 'Chill');
    await tester.pump(const Duration(milliseconds: 400));
    expect(container.read(searchViewModelProvider), 'Chill');

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(container.read(searchViewModelProvider), '');
  });

  testWidgets('shows grouped results once the term settles', (tester) async {
    await tester.pumpWidget(
      _app(
        tracks: [_track(id: 'track-1', title: 'Night Drive')],
      ),
    );

    await tester.enterText(find.byType(TextField), 'Night');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('Tracks'), findsOneWidget);
    expect(find.text('Night Drive'), findsOneWidget);
  });

  testWidgets('shows the empty state when nothing matches', (tester) async {
    await tester.pumpWidget(
      _app(
        tracks: [_track(id: 'track-1', title: 'Night Drive')],
      ),
    );

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('shows recent searches while the field is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(recentSearches: ['chill', 'night drive']),
    );
    await tester.pump();

    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('chill'), findsOneWidget);
    expect(find.text('night drive'), findsOneWidget);
  });

  testWidgets('tapping a recent search fills the field and its results', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        tracks: [_track(id: 'track-1', title: 'Night Drive')],
        recentSearches: ['night'],
      ),
    );
    await tester.pump();

    await tester.tap(find.text('night'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Night Drive'), findsOneWidget);
  });

  testWidgets('removing a recent search drops it from the list', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(recentSearches: ['chill', 'night drive']),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pump();

    expect(find.text('chill'), findsNothing);
    expect(find.text('night drive'), findsOneWidget);
  });

  testWidgets('submitting the field records the term to history', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.enterText(find.byType(TextField), 'Chill');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(find.text('Chill'), findsOneWidget);
  });
}
