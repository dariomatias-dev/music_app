import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/audio/audio_providers.dart';
import 'package:music_app/src/core/audio/music_audio_handler.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/widgets/favorites_tab.dart';

import '../../../../helpers/fake_audio_player_service.dart';
import '../../../../helpers/fake_favorite_repository.dart';

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
      trackCount: 2,
    ),
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const []);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
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

Future<
  ({ProviderContainer container, FakeFavoriteRepository favoriteRepository})
>
_pumpFavoritesTab(WidgetTester tester, List<Track> tracks) async {
  final service = FakeAudioPlayerService();
  final handler = MusicAudioHandler(service);
  addTearDown(handler.dispose);
  final favoriteRepository = FakeFavoriteRepository();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(service),
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(tracks),
        ),
        favoriteRepositoryProvider.overrideWithValue(favoriteRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: FavoritesTab()),
      ),
    ),
  );
  await tester.pump();

  final element = tester.element(find.byType(FavoritesTab));
  return (
    container: ProviderScope.containerOf(element),
    favoriteRepository: favoriteRepository,
  );
}

void main() {
  testWidgets('shows the empty state when there are no favorites', (
    tester,
  ) async {
    await _pumpFavoritesTab(tester, [
      _track(id: 'track-1', title: 'Night Drive'),
    ]);

    expect(find.text('No favorites yet'), findsOneWidget);
  });

  testWidgets('lists favorited tracks', (tester) async {
    final result = await _pumpFavoritesTab(tester, [
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ]);
    await result.favoriteRepository.setFavorite(
      'track-1',
      isFavorite: true,
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Night Drive'), findsOneWidget);
    expect(find.text('Sunset'), findsNothing);
  });

  testWidgets('tapping the heart unfavorites the track', (tester) async {
    final result = await _pumpFavoritesTab(tester, [
      _track(id: 'track-1', title: 'Night Drive'),
    ]);
    await result.favoriteRepository.setFavorite(
      'track-1',
      isFavorite: true,
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Night Drive'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    await tester.pump();

    expect(find.text('Night Drive'), findsNothing);
    expect(find.text('No favorites yet'), findsOneWidget);
  });

  testWidgets('tapping a favorite plays from that position', (tester) async {
    final result = await _pumpFavoritesTab(tester, [
      _track(id: 'track-1', title: 'Night Drive'),
      _track(id: 'track-2', title: 'Sunset'),
    ]);
    await result.favoriteRepository.setFavorite(
      'track-2',
      isFavorite: true,
    );
    await result.favoriteRepository.setFavorite(
      'track-1',
      isFavorite: true,
    );
    await tester.pumpAndSettle();

    // Most recently favorited first, so track-1 leads.
    await tester.tap(find.text('Sunset'));
    await tester.pump(const Duration(milliseconds: 50));

    final service = result.container.read(audioPlayerServiceProvider);
    expect(service.snapshot.currentIndex, 1);
  });
}
