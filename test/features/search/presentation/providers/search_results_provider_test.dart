import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/playlist/data/providers/playlist_data_providers.dart';
import 'package:music_app/src/features/search/presentation/providers/search_results_provider.dart';
import 'package:music_app/src/features/search/presentation/view_models/search_view_model.dart';

import '../../../../helpers/fake_playlist_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository();

  @override
  Stream<List<Track>> watchTracks() => Stream.value([
    Track(
      id: 'track-1',
      sourceId: 'track-1',
      filePath: '/music/track-1.mp3',
      title: 'Night Drive',
      artistId: 'artist-1',
      albumId: 'album-1',
      duration: const Duration(minutes: 3),
      format: 'mp3',
      fileSize: 1000,
      hasEmbeddedArtwork: false,
      dateAdded: DateTime(2026),
      dateModified: DateTime(2026),
    ),
  ]);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const [
    Artist(
      id: 'artist-1',
      sourceId: 'artist-1',
      name: 'Nightbird',
      albumCount: 1,
      trackCount: 1,
    ),
  ]);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(const [
    Album(
      id: 'album-1',
      sourceId: 'album-1',
      title: 'Night Chill Vibes',
      artistId: 'artist-1',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    ),
  ]);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}

  @override
  Future<void> clearArtworkCache() async {}
}

void main() {
  ProviderContainer buildContainer() {
    final container =
        ProviderContainer(
            overrides: [
              libraryRepositoryProvider.overrideWithValue(
                const _FakeLibraryRepository(),
              ),
              playlistRepositoryProvider.overrideWithValue(
                FakePlaylistRepository(),
              ),
            ],
          )
          ..listen(searchViewModelProvider, (_, _) {})
          ..listen(searchResultsProvider, (_, _) {});
    return container;
  }

  test('is empty while the term is empty', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    expect(container.read(searchResultsProvider).isEmpty, isTrue);
  });

  test('matches tracks, albums and artists case-insensitively', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    container.read(searchViewModelProvider.notifier).updateTerm('night');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final results = container.read(searchResultsProvider);
    expect(results.tracks.map((t) => t.id), ['track-1']);
    expect(results.albums.map((a) => a.id), ['album-1']);
    expect(results.artists.map((a) => a.id), ['artist-1']);
  });

  test('excludes non-matching entries', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    container.read(searchViewModelProvider.notifier).updateTerm('zzz');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(container.read(searchResultsProvider).isEmpty, isTrue);
  });
}
