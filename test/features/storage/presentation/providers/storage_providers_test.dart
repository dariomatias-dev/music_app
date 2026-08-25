import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/storage/data/providers/storage_data_providers.dart';
import 'package:music_app/src/features/storage/presentation/providers/storage_providers.dart';

import '../../../../helpers/fake_excluded_folder_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository({this.tracks = const []});

  final List<Track> tracks;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(const []);

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

Track _track(
  String id, {
  required String filePath,
  required int fileSize,
  bool isMissing = false,
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: filePath,
    title: 'Track $id',
    artistId: 'artist-1',
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: fileSize,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    isMissing: isMissing,
  );
}

ProviderContainer _container({
  List<Track> tracks = const [],
  List<String> excludedFolders = const [],
}) {
  final container =
      ProviderContainer(
          overrides: [
            libraryRepositoryProvider.overrideWithValue(
              _FakeLibraryRepository(tracks: tracks),
            ),
            excludedFolderRepositoryProvider.overrideWithValue(
              FakeExcludedFolderRepository(excludedFolders),
            ),
          ],
        )
        ..listen(tracksStreamProvider, (_, _) {})
        ..listen(excludedFoldersProvider, (_, _) {});
  return container;
}

void main() {
  test('totalStorageUsageProvider sums non-missing track sizes', () async {
    final container = _container(
      tracks: [
        _track('a', filePath: '/music/rock/a.mp3', fileSize: 1000),
        _track('b', filePath: '/music/rock/b.mp3', fileSize: 2000),
        _track(
          'c',
          filePath: '/music/pop/c.mp3',
          fileSize: 5000,
          isMissing: true,
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(tracksStreamProvider.future);
    await container.read(excludedFoldersProvider.future);

    expect(container.read(totalStorageUsageProvider), 3000);
  });

  test(
    'folderUsageProvider groups tracks by directory, largest first',
    () async {
      final container = _container(
        tracks: [
          _track('a', filePath: '/music/rock/a.mp3', fileSize: 1000),
          _track('b', filePath: '/music/rock/b.mp3', fileSize: 2000),
          _track('c', filePath: '/music/pop/c.mp3', fileSize: 500),
          _track(
            'd',
            filePath: '/music/pop/d.mp3',
            fileSize: 9999,
            isMissing: true,
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(tracksStreamProvider.future);
      await container.read(excludedFoldersProvider.future);

      final usage = container.read(folderUsageProvider);

      expect(usage.map((u) => u.path), ['/music/rock', '/music/pop']);
      expect(usage.map((u) => u.sizeBytes), [3000, 500]);
      expect(usage.map((u) => u.trackCount), [2, 1]);
      expect(usage.every((u) => u.isIncluded), isTrue);
    },
  );

  test('folderUsageProvider reflects excluded folders', () async {
    final container = _container(
      tracks: [
        _track('a', filePath: '/music/rock/a.mp3', fileSize: 1000),
        _track('b', filePath: '/music/pop/b.mp3', fileSize: 2000),
      ],
      excludedFolders: ['/music/pop'],
    );
    addTearDown(container.dispose);
    await container.read(tracksStreamProvider.future);
    await container.read(excludedFoldersProvider.future);

    final usage = container.read(folderUsageProvider);

    final rock = usage.firstWhere((u) => u.path == '/music/rock');
    final pop = usage.firstWhere((u) => u.path == '/music/pop');
    expect(rock.isIncluded, isTrue);
    expect(pop.isIncluded, isFalse);
  });

  test('is empty when the library has no tracks', () async {
    final container = _container();
    addTearDown(container.dispose);
    await container.read(tracksStreamProvider.future);
    await container.read(excludedFoldersProvider.future);

    expect(container.read(totalStorageUsageProvider), 0);
    expect(container.read(folderUsageProvider), isEmpty);
  });
}
