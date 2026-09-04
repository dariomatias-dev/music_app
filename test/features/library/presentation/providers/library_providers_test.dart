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

import '../../../../helpers/fake_favorite_repository.dart';

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

  final albumsTracks = [
    _track(
      id: 'z-1',
      title: 'On Zeta',
      artistId: 'artist-a',
      albumId: 'album-z',
    ),
    _track(
      id: 'a-1',
      title: 'On Alpha',
      artistId: 'artist-b',
      albumId: 'album-a',
    ),
  ];

  Future<ProviderContainer> buildContainer({
    List<Album> albums = const [],
    List<Track>? libraryTracks,
  }) async {
    // Without an external listener, a bare ProviderContainer disposes an
    // autoDispose StreamProvider before its stream gets a chance to emit.
    final container =
        ProviderContainer(
            overrides: [
              libraryRepositoryProvider.overrideWithValue(
                _FakeLibraryRepository(
                  libraryTracks ?? tracks,
                  artists,
                  albums,
                ),
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
    final container = await buildContainer(
      albums: albums,
      libraryTracks: albumsTracks,
    );
    addTearDown(container.dispose);

    expect(container.read(sortedAlbumsProvider).map((a) => a.title), [
      'Alpha',
      'Zeta',
    ]);
  });

  test('sortedAlbumsProvider leaves out an album with nothing left', () async {
    final container = await buildContainer(
      albums: albums,
      libraryTracks: [
        _track(
          id: 'z-1',
          title: 'On Zeta',
          artistId: 'artist-a',
          albumId: 'album-z',
        ),
        _track(
          id: 'a-1',
          title: 'Gone',
          artistId: 'artist-b',
          albumId: 'album-a',
          isMissing: true,
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(sortedAlbumsProvider).map((a) => a.title), ['Zeta']);
    expect(container.read(albumByIdProvider('album-a'))?.title, 'Alpha');
  });

  test(
    'sortedArtistsProvider leaves out an artist with nothing left',
    () async {
      final container = await buildContainer(
        libraryTracks: [
          _track(id: 'b-1', title: 'Zebra', artistId: 'artist-b'),
          _track(
            id: 'a-1',
            title: 'Gone',
            artistId: 'artist-a',
            isMissing: true,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(sortedArtistsProvider).map((a) => a.name), [
        'Brambles',
      ]);
    },
  );

  test('albumDurationProvider adds up the tracks still there', () async {
    final container = await buildContainer(
      albums: albums,
      libraryTracks: [
        _track(
          id: 'z-1',
          title: 'On Zeta',
          artistId: 'artist-a',
          albumId: 'album-z',
          duration: const Duration(minutes: 4),
        ),
        _track(
          id: 'z-2',
          title: 'Also Zeta',
          artistId: 'artist-a',
          albumId: 'album-z',
        ),
        _track(
          id: 'z-gone',
          title: 'Gone',
          artistId: 'artist-a',
          albumId: 'album-z',
          duration: const Duration(minutes: 10),
          isMissing: true,
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(albumDurationProvider('album-z')),
      const Duration(minutes: 7),
    );
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

  test('sortedArtistsProvider orders artists alphabetically', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    expect(container.read(sortedArtistsProvider).map((a) => a.name), [
      'Ambient Fog',
      'Brambles',
    ]);
  });

  test('artistByIdProvider finds an indexed artist', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    expect(container.read(artistByIdProvider('artist-a'))?.name, 'Ambient Fog');
  });

  test('artistByIdProvider returns null for an unknown id', () async {
    final container = await buildContainer();
    addTearDown(container.dispose);

    expect(container.read(artistByIdProvider('missing')), isNull);
  });

  test("artistAlbumsProvider only returns that artist's albums", () async {
    final container = await buildContainer(
      albums: albums,
      libraryTracks: albumsTracks,
    );
    addTearDown(container.dispose);

    expect(
      container.read(artistAlbumsProvider('artist-a')).map((a) => a.title),
      ['Zeta'],
    );
  });

  test(
    'artistTracksProvider orders by album title then track number, and '
    'excludes other artists and missing tracks',
    () async {
      const artistAlbums = [
        Album(
          id: 'album-beta',
          sourceId: 'album-beta',
          title: 'Beta',
          artistId: 'artist-a',
          trackCount: 1,
          totalDuration: Duration(minutes: 3),
        ),
        Album(
          id: 'album-zeta',
          sourceId: 'album-zeta',
          title: 'Zeta',
          artistId: 'artist-a',
          trackCount: 1,
          totalDuration: Duration(minutes: 3),
        ),
      ];
      final artistTracksFixture = [
        _track(
          id: 'zeta-track',
          title: 'From Zeta',
          artistId: 'artist-a',
          albumId: 'album-zeta',
        ),
        _track(
          id: 'beta-track',
          title: 'From Beta',
          artistId: 'artist-a',
          albumId: 'album-beta',
        ),
        _track(
          id: 'missing-track',
          title: 'Gone',
          artistId: 'artist-a',
          albumId: 'album-beta',
          isMissing: true,
        ),
        _track(
          id: 'other-artist-track',
          title: 'Not mine',
          artistId: 'artist-b',
          albumId: 'album-beta',
        ),
      ];
      final container =
          ProviderContainer(
              overrides: [
                libraryRepositoryProvider.overrideWithValue(
                  _FakeLibraryRepository(
                    artistTracksFixture,
                    artists,
                    artistAlbums,
                  ),
                ),
              ],
            )
            ..listen(tracksStreamProvider, (_, _) {})
            ..listen(albumsStreamProvider, (_, _) {});
      addTearDown(container.dispose);
      await Future.wait([
        container.read(tracksStreamProvider.future),
        container.read(albumsStreamProvider.future),
      ]);

      expect(
        container.read(artistTracksProvider('artist-a')).map((t) => t.id),
        ['beta-track', 'zeta-track'],
      );
    },
  );

  test(
    'favoriteTracksProvider resolves favorited ids to tracks in order, '
    'excluding missing tracks',
    () async {
      final favoriteRepository = FakeFavoriteRepository();
      final container =
          ProviderContainer(
              overrides: [
                libraryRepositoryProvider.overrideWithValue(
                  _FakeLibraryRepository(tracks, artists),
                ),
                favoriteRepositoryProvider.overrideWithValue(
                  favoriteRepository,
                ),
              ],
            )
            ..listen(tracksStreamProvider, (_, _) {})
            ..listen(favoriteTrackIdsProvider, (_, _) {});
      addTearDown(container.dispose);
      await Future.wait([
        container.read(tracksStreamProvider.future),
        container.read(favoriteTrackIdsProvider.future),
      ]);

      await favoriteRepository.setFavorite('track-2', isFavorite: true);
      await favoriteRepository.setFavorite('track-3', isFavorite: true);
      await favoriteRepository.setFavorite('track-1', isFavorite: true);
      // Let the broadcast stream's async delivery reach the provider.
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(favoriteTracksProvider).map((t) => t.id),
        ['track-1', 'track-2'],
      );
    },
  );
}
