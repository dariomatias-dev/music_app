import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/statistics/data/providers/statistics_data_providers.dart';
import 'package:music_app/src/features/statistics/domain/entities/track_play_count.dart';
import 'package:music_app/src/features/statistics/presentation/providers/statistics_providers.dart';

import '../../../../helpers/fake_statistics_repository.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository({
    this.tracks = const [],
    this.artists = const [],
  });

  final List<Track> tracks;
  final List<Artist> artists;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

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

Track _track(String id, {required String artistId, bool isMissing = false}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: 'Track $id',
    artistId: artistId,
    albumId: 'album-1',
    duration: const Duration(minutes: 3),
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    isMissing: isMissing,
  );
}

void main() {
  test('mostPlayedTracksProvider ranks resolved, non-missing tracks', () async {
    final container = ProviderContainer(
      overrides: [
        statisticsRepositoryProvider.overrideWithValue(
          FakeStatisticsRepository(
            trackPlayCounts: const [
              TrackPlayCount(trackId: 'a', playCount: 5),
              TrackPlayCount(trackId: 'missing', playCount: 4),
              TrackPlayCount(trackId: 'b', playCount: 2),
            ],
          ),
        ),
        libraryRepositoryProvider.overrideWithValue(
          _FakeLibraryRepository(
            tracks: [
              _track('a', artistId: 'artist-1'),
              _track('b', artistId: 'artist-1'),
              _track('missing', artistId: 'artist-1', isMissing: true),
            ],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    container
      ..listen(trackPlayCountsProvider, (_, _) {})
      ..listen(tracksStreamProvider, (_, _) {});
    await container.read(trackPlayCountsProvider.future);
    await container.read(tracksStreamProvider.future);

    final tracks = container.read(mostPlayedTracksProvider);

    expect(tracks.map((t) => t.id), ['a', 'b']);
  });

  test(
    'mostPlayedArtistsProvider ranks artists by combined track plays',
    () async {
      final container = ProviderContainer(
        overrides: [
          statisticsRepositoryProvider.overrideWithValue(
            FakeStatisticsRepository(
              trackPlayCounts: const [
                TrackPlayCount(trackId: 'a', playCount: 3),
                TrackPlayCount(trackId: 'b', playCount: 4),
                TrackPlayCount(trackId: 'c', playCount: 10),
              ],
            ),
          ),
          libraryRepositoryProvider.overrideWithValue(
            _FakeLibraryRepository(
              tracks: [
                _track('a', artistId: 'artist-1'),
                _track('b', artistId: 'artist-1'),
                _track('c', artistId: 'artist-2'),
              ],
              artists: const [
                Artist(
                  id: 'artist-1',
                  sourceId: 'artist-1',
                  name: 'Charcoal',
                  albumCount: 1,
                  trackCount: 2,
                ),
                Artist(
                  id: 'artist-2',
                  sourceId: 'artist-2',
                  name: 'Nightbird',
                  albumCount: 1,
                  trackCount: 1,
                ),
              ],
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      container
        ..listen(trackPlayCountsProvider, (_, _) {})
        ..listen(tracksStreamProvider, (_, _) {})
        ..listen(artistsStreamProvider, (_, _) {});
      await container.read(trackPlayCountsProvider.future);
      await container.read(tracksStreamProvider.future);
      await container.read(artistsStreamProvider.future);

      final artists = container.read(mostPlayedArtistsProvider);

      // artist-1: 3 + 4 = 7 plays; artist-2: 10 plays.
      expect(artists.map((a) => a.id), ['artist-2', 'artist-1']);
    },
  );

  test(
    'mostPlayedArtistsProvider excludes missing tracks from the total',
    () async {
      final container = ProviderContainer(
        overrides: [
          statisticsRepositoryProvider.overrideWithValue(
            FakeStatisticsRepository(
              trackPlayCounts: const [
                TrackPlayCount(trackId: 'a', playCount: 3),
                TrackPlayCount(trackId: 'missing', playCount: 100),
              ],
            ),
          ),
          libraryRepositoryProvider.overrideWithValue(
            _FakeLibraryRepository(
              tracks: [
                _track('a', artistId: 'artist-1'),
                _track('missing', artistId: 'artist-1', isMissing: true),
              ],
              artists: const [
                Artist(
                  id: 'artist-1',
                  sourceId: 'artist-1',
                  name: 'Charcoal',
                  albumCount: 1,
                  trackCount: 1,
                ),
              ],
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      container
        ..listen(trackPlayCountsProvider, (_, _) {})
        ..listen(tracksStreamProvider, (_, _) {})
        ..listen(artistsStreamProvider, (_, _) {});
      await container.read(trackPlayCountsProvider.future);
      await container.read(tracksStreamProvider.future);
      await container.read(artistsStreamProvider.future);

      final artists = container.read(mostPlayedArtistsProvider);

      expect(artists.map((a) => a.id), ['artist-1']);
    },
  );
}
