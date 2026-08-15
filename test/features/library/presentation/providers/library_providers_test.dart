import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';
import 'package:music_app/src/features/library/domain/repositories/library_repository.dart';
import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:music_app/src/features/library/presentation/view_models/track_sort_view_model.dart';

class _FakeLibraryRepository implements LibraryRepository {
  const _FakeLibraryRepository(this.tracks, this.artists);

  final List<Track> tracks;
  final List<Artist> artists;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

  @override
  Stream<List<Album>> watchAlbums() => const Stream.empty();

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
}

Track _track({
  required String id,
  required String title,
  required String artistId,
  Duration duration = const Duration(minutes: 3),
  DateTime? dateAdded,
  bool isMissing = false,
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: artistId,
    albumId: 'album-1',
    duration: duration,
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: dateAdded ?? DateTime(2026),
    dateModified: DateTime(2026),
    isMissing: isMissing,
  );
}

void main() {
  const artists = [
    Artist(
      id: 'artist-b',
      sourceId: 'artist-b',
      name: 'Brambles',
      albumCount: 1,
      trackCount: 1,
    ),
    Artist(
      id: 'artist-a',
      sourceId: 'artist-a',
      name: 'Ambient Fog',
      albumCount: 1,
      trackCount: 1,
    ),
  ];

  final tracks = [
    _track(
      id: 'track-1',
      title: 'Zebra',
      artistId: 'artist-b',
      duration: const Duration(minutes: 2),
    ),
    _track(
      id: 'track-2',
      title: 'Apple',
      artistId: 'artist-a',
      duration: const Duration(minutes: 5),
      dateAdded: DateTime(2026, 3),
    ),
    _track(
      id: 'track-3',
      title: 'Missing',
      artistId: 'artist-a',
      isMissing: true,
    ),
  ];

  Future<ProviderContainer> buildContainer() async {
    // Without an external listener, a bare ProviderContainer disposes an
    // autoDispose StreamProvider before its stream gets a chance to emit.
    final container =
        ProviderContainer(
            overrides: [
              libraryRepositoryProvider.overrideWithValue(
                _FakeLibraryRepository(tracks, artists),
              ),
            ],
          )
          ..listen(tracksStreamProvider, (_, _) {})
          ..listen(artistsStreamProvider, (_, _) {});
    await Future.wait([
      container.read(tracksStreamProvider.future),
      container.read(artistsStreamProvider.future),
    ]);
    return container;
  }

  test('excludes missing tracks', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    expect(
      container.read(sortedTracksProvider).map((t) => t.id),
      isNot(contains('track-3')),
    );
  });

  test('sorts by title', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    expect(container.read(sortedTracksProvider).map((t) => t.title), [
      'Apple',
      'Zebra',
    ]);
  });

  test('sorts by artist name', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);
    container.read(trackSortViewModelProvider.notifier).order =
        TrackSort.artist;

    expect(container.read(sortedTracksProvider).map((t) => t.id), [
      'track-2',
      'track-1',
    ]);
  });

  test('sorts by date added, most recent first', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);
    container.read(trackSortViewModelProvider.notifier).order =
        TrackSort.dateAdded;

    expect(container.read(sortedTracksProvider).map((t) => t.id), [
      'track-2',
      'track-1',
    ]);
  });

  test('sorts by duration, longest first', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);
    container.read(trackSortViewModelProvider.notifier).order =
        TrackSort.duration;

    expect(container.read(sortedTracksProvider).map((t) => t.id), [
      'track-2',
      'track-1',
    ]);
  });
}
