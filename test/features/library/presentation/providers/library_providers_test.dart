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
  const _FakeLibraryRepository(
    this.tracks,
    this.artists, [
    this.albums = const [],
  ]);

  final List<Track> tracks;
  final List<Artist> artists;
  final List<Album> albums;

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks);

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists);

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(albums);

  @override
  Stream<IndexingProgress> reindex() => const Stream.empty();

  @override
  Future<void> purgeMissingTracks() async {}
}

Track _track({
  required String id,
  required String title,
  required String artistId,
  String albumId = 'album-1',
  Duration duration = const Duration(minutes: 3),
  DateTime? dateAdded,
  int? discNumber,
  int? trackNumber,
  bool isMissing = false,
}) {
  return Track(
    id: id,
    sourceId: id,
    filePath: '/music/$id.mp3',
    title: title,
    artistId: artistId,
    albumId: albumId,
    duration: duration,
    format: 'mp3',
    fileSize: 1000,
    hasEmbeddedArtwork: false,
    dateAdded: dateAdded ?? DateTime(2026),
    dateModified: DateTime(2026),
    discNumber: discNumber,
    trackNumber: trackNumber,
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

  const albums = [
    Album(
      id: 'album-z',
      sourceId: 'album-z',
      title: 'Zeta',
      artistId: 'artist-a',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    ),
    Album(
      id: 'album-a',
      sourceId: 'album-a',
      title: 'Alpha',
      artistId: 'artist-b',
      trackCount: 1,
      totalDuration: Duration(minutes: 3),
    ),
  ];

  Future<ProviderContainer> buildContainer({
    List<Album> albums = const [],
  }) async {
    // Without an external listener, a bare ProviderContainer disposes an
    // autoDispose StreamProvider before its stream gets a chance to emit.
    final container =
        ProviderContainer(
            overrides: [
              libraryRepositoryProvider.overrideWithValue(
                _FakeLibraryRepository(tracks, artists, albums),
              ),
            ],
          )
          ..listen(tracksStreamProvider, (_, _) {})
          ..listen(artistsStreamProvider, (_, _) {})
          ..listen(albumsStreamProvider, (_, _) {});
    await Future.wait([
      container.read(tracksStreamProvider.future),
      container.read(artistsStreamProvider.future),
      container.read(albumsStreamProvider.future),
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

  test('sortedAlbumsProvider orders albums alphabetically', () async {
    final container = await buildContainer(albums: albums);
    addTearDown(container.dispose);

    expect(container.read(sortedAlbumsProvider).map((a) => a.title), [
      'Alpha',
      'Zeta',
    ]);
  });

  test('albumByIdProvider finds an indexed album', () async {
    final container = await buildContainer(albums: albums);
    addTearDown(container.dispose);

    expect(container.read(albumByIdProvider('album-z'))?.title, 'Zeta');
  });

  test('albumByIdProvider returns null for an unknown id', () async {
    final container = await buildContainer(albums: albums);
    addTearDown(container.dispose);

    expect(container.read(albumByIdProvider('missing')), isNull);
  });

  test(
    'albumTracksProvider orders by disc then track number and excludes '
    'other albums and missing tracks',
    () async {
      final albumTracks = [
        _track(
          id: 'a-2',
          title: 'Second',
          artistId: 'artist-a',
          albumId: 'album-z',
          discNumber: 1,
          trackNumber: 2,
        ),
        _track(
          id: 'a-1',
          title: 'First',
          artistId: 'artist-a',
          albumId: 'album-z',
          discNumber: 1,
          trackNumber: 1,
        ),
        _track(
          id: 'a-missing',
          title: 'Gone',
          artistId: 'artist-a',
          albumId: 'album-z',
          isMissing: true,
        ),
        _track(
          id: 'other-album',
          title: 'Elsewhere',
          artistId: 'artist-a',
          albumId: 'album-a',
        ),
      ];
      final container = ProviderContainer(
        overrides: [
          libraryRepositoryProvider.overrideWithValue(
            _FakeLibraryRepository(albumTracks, artists, albums),
          ),
        ],
      )..listen(tracksStreamProvider, (_, _) {});
      addTearDown(container.dispose);
      await container.read(tracksStreamProvider.future);

      expect(
        container.read(albumTracksProvider('album-z')).map((t) => t.id),
        ['a-1', 'a-2'],
      );
    },
  );
}
