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
import 'package:music_app/src/features/library/presentation/screens/library_screen.dart';
import 'package:music_app/src/features/library/presentation/view_models/library_view_model.dart';
import 'package:music_app/src/features/library/presentation/widgets/favorites_tab.dart';
import 'package:music_app/src/features/library/presentation/widgets/playlists_tab.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';

import '../../../../helpers/fake_favorite_repository.dart';
import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => const Stream.empty();

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

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

Widget _app() {
  return ProviderScope(
    overrides: [
      libraryRepositoryProvider.overrideWithValue(
        const _FakeLibraryRepository(),
      ),
      playlistRepositoryProvider.overrideWithValue(FakePlaylistRepository()),
      favoriteRepositoryProvider.overrideWithValue(FakeFavoriteRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LibraryScreen(),
    ),
  );
}

void main() {
  testWidgets('shows every section label', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Tracks'), findsOneWidget);
    expect(find.text('Albums'), findsOneWidget);
    expect(find.text('Artists'), findsOneWidget);
    expect(find.text('Playlists'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
  });

  testWidgets('tapping a label switches the section', (tester) async {
    await tester.pumpWidget(_app());

    final element = tester.element(find.byType(LibraryScreen));
    final container = ProviderScope.containerOf(element);
    expect(
      container.read(libraryViewModelProvider),
      LibrarySection.playlists,
    );

    await tester.tap(find.text('Albums'));
    await tester.pump();

    expect(
      container.read(libraryViewModelProvider),
      LibrarySection.albums,
    );
  });

  testWidgets('the favorites section renders the favorites tab', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();
    expect(find.byType(PlaylistsTab), findsOneWidget);

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.byType(FavoritesTab), findsOneWidget);
    expect(find.byType(PlaylistsTab), findsNothing);
  });
}
