import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/home/presentation/view_models/home_view_model.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks);

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => const Stream.empty();

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
}

Track _track(String id) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: id,
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

void main() {
  test('is loading before the library repository responds', () {
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository([]),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(homeViewModelProvider), HomeState.loading);
  });

  test('is empty when the library has no tracks', () async {
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          const _FakeLibraryRepository([]),
        ),
      ],
    )..listen(tracksStreamProvider, (_, _) {});
    addTearDown(container.dispose);
    await container.read(tracksStreamProvider.future);

    expect(container.read(homeViewModelProvider), HomeState.empty);
  });

  test('is ready when the library has tracks', () async {
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository([_track('track-1')]),
        ),
      ],
    )..listen(tracksStreamProvider, (_, _) {});
    addTearDown(container.dispose);
    await container.read(tracksStreamProvider.future);

    expect(container.read(homeViewModelProvider), HomeState.ready);
  });
}
