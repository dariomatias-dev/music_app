import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/artwork_cache/artwork_cache.dart';
import 'package:music_app/src/core/services/id_generator/id_generator.dart';
import 'package:music_app/src/core/services/media_scanner/media_scanner.dart';
import 'package:music_app/src/core/services/metadata_reader/metadata_reader.dart';
import 'package:music_app/src/features/library/data/data_sources/library_local_data_source.dart';
import 'package:music_app/src/features/library/data/indexing/library_indexer.dart';
import 'package:music_app/src/features/library/domain/entities/album.dart';
import 'package:music_app/src/features/library/domain/entities/artist.dart';
import 'package:music_app/src/features/library/domain/entities/track.dart';

class _FakeMediaScanner implements MediaScanner {
  _FakeMediaScanner(this.files);

  final List<ScannedAudioFile> files;

  @override
  Future<List<ScannedAudioFile>> scan({
    List<String> includedFolders = const [],
    List<String> excludedFolders = const [],
    Duration minimumDuration = Duration.zero,
  }) async => files;

  @override
  Future<void> notifyFileRemoved(String path) async {}
}

class _FakeMetadataReader implements MetadataReader {
  _FakeMetadataReader(this.metadataByPath);

  final Map<String, TrackMetadata> metadataByPath;

  @override
  Future<TrackMetadata> read(String filePath) async =>
      metadataByPath[filePath] ?? const TrackMetadata();
}

class _FakeArtworkCache implements ArtworkCache {
  final Map<String, Uint8List> saved = {};

  @override
  Future<String> save({
    required String id,
    required Uint8List data,
    required String mimeType,
  }) async {
    saved[id] = data;
    return '/cache/$id.jpg';
  }

  @override
  Future<String?> pathFor(String id) async =>
      saved.containsKey(id) ? '/cache/$id.jpg' : null;

  @override
  Future<void> delete(String id) async => saved.remove(id);

  @override
  Future<void> clear() async => saved.clear();
}

class _FakeLibraryLocalDataSource implements LibraryLocalDataSource {
  final Map<String, Artist> artists = {};
  final Map<String, Album> albums = {};
  final Map<String, Track> tracks = {};

  /// Every write in the order it happened, as `'kind:id'`.
  ///
  /// Tracks reference an album and an artist by id, so the rows they point
  /// at have to exist first. Only the order reveals that, not the final
  /// contents.
  final List<String> writes = [];

  @override
  Future<Artist?> findArtistBySourceId(String sourceId) async =>
      artists[sourceId];

  @override
  Future<void> upsertArtist(Artist artist) async {
    writes.add('artist:${artist.id}');
    if (_transactionDepth == 0) {
      writesOutsideTransaction.add('artist:${artist.id}');
    }
    artists[artist.sourceId] = artist;
  }

  @override
  Future<Album?> findAlbumBySourceId(String sourceId) async => albums[sourceId];

  @override
  Future<void> upsertAlbum(Album album) async {
    writes.add('album:${album.id}');
    if (_transactionDepth == 0) {
      writesOutsideTransaction.add('album:${album.id}');
    }
    albums[album.sourceId] = album;
  }

  @override
  Future<Track?> findTrackBySourceId(String sourceId) async {
    for (final track in tracks.values) {
      if (track.sourceId == sourceId) return track;
    }
    return null;
  }

  @override
  Future<Track?> findTrackById(String id) async => tracks[id];

  @override
  Future<List<Track>> findAllTracks() async => tracks.values.toList();

  @override
  Future<void> upsertTrack(Track track) async {
    writes.add('track:${track.id}');
    if (_transactionDepth == 0) {
      writesOutsideTransaction.add('track:${track.id}');
    }
    tracks[track.id] = track;
  }

  @override
  Future<void> deleteTrack(String id) async {
    tracks.remove(id);
  }

  @override
  Stream<List<Track>> watchTracks() => Stream.value(tracks.values.toList());

  @override
  Stream<List<Album>> watchAlbums() => Stream.value(albums.values.toList());

  @override
  Stream<List<Artist>> watchArtists() => Stream.value(artists.values.toList());

  var _transactionDepth = 0;

  /// How many transactions the run opened.
  int transactions = 0;

  /// Writes that happened with no transaction open.
  final List<String> writesOutsideTransaction = [];

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) async {
    transactions++;
    _transactionDepth++;
    try {
      return await action();
    } finally {
      _transactionDepth--;
    }
  }

  @override
  Future<void> clearAlbumArtworkPaths() async {
    for (final entry in albums.entries.toList()) {
      albums[entry.key] = entry.value.copyWith(artworkPath: null);
    }
  }
}

class _CountingArtworkCache extends _FakeArtworkCache {
  int saveCalls = 0;

  @override
  Future<String> save({
    required String id,
    required Uint8List data,
    required String mimeType,
  }) {
    saveCalls++;
    return super.save(id: id, data: data, mimeType: mimeType);
  }
}

class _FakeIdGenerator implements IdGenerator {
  var _counter = 0;

  @override
  String generate() => 'id-${_counter++}';
}

ScannedAudioFile _file({
  required int mediaStoreId,
  required String filePath,
  required String title,
  required Duration duration,
  String? artist = 'Charcoal',
  String? album = 'Chill Vibes',
}) {
  return ScannedAudioFile(
    mediaStoreId: mediaStoreId,
    filePath: filePath,
    title: title,
    duration: duration,
    fileExtension: 'mp3',
    fileSize: 1000,
    dateAdded: DateTime(2026),
    dateModified: DateTime(2026),
    artist: artist,
    album: album,
  );
}

void main() {
  test('indexes tracks, grouping them by artist and album', () async {
    final files = [
      _file(
        mediaStoreId: 1,
        filePath: '/music/a.mp3',
        title: 'A',
        duration: const Duration(minutes: 3),
      ),
      _file(
        mediaStoreId: 2,
        filePath: '/music/b.mp3',
        title: 'B',
        duration: const Duration(minutes: 4),
      ),
    ];

    final metadataByPath = {
      '/music/a.mp3': TrackMetadata(
        title: 'Night Drive',
        artist: 'Charcoal',
        album: 'Chill Vibes',
        trackNumber: 1,
        artwork: EmbeddedArtwork(
          data: Uint8List.fromList([1, 2, 3]),
          mimeType: 'image/jpeg',
        ),
      ),
      '/music/b.mp3': const TrackMetadata(
        title: 'Sunset',
        artist: 'Charcoal',
        album: 'Chill Vibes',
        trackNumber: 2,
      ),
    };

    final dataSource = _FakeLibraryLocalDataSource();

    final indexer = LibraryIndexer(
      mediaScanner: _FakeMediaScanner(files),
      metadataReader: _FakeMetadataReader(metadataByPath),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );

    final progress = await indexer.indexLibrary().toList();

    expect(progress, hasLength(2));
    expect(progress.last.processed, 2);
    expect(progress.last.total, 2);

    expect(dataSource.artists, hasLength(1));
    final artist = dataSource.artists.values.single;
    expect(artist.name, 'Charcoal');
    expect(artist.albumCount, 1);
    expect(artist.trackCount, 2);

    expect(dataSource.albums, hasLength(1));
    final album = dataSource.albums.values.single;
    expect(album.title, 'Chill Vibes');
    expect(album.trackCount, 2);
    expect(album.totalDuration, const Duration(minutes: 7));
    expect(album.artworkPath, '/cache/${album.id}.jpg');

    expect(dataSource.tracks, hasLength(2));
    final trackTitles = dataSource.tracks.values.map((t) => t.title);
    expect(trackTitles, containsAll(['Night Drive', 'Sunset']));
    for (final track in dataSource.tracks.values) {
      expect(track.artistId, artist.id);
      expect(track.albumId, album.id);
    }
  });

  test('groups unknown artist and album under stable placeholders', () async {
    final files = [
      _file(
        mediaStoreId: 1,
        filePath: '/music/a.mp3',
        title: 'A',
        duration: const Duration(minutes: 2),
        artist: null,
        album: null,
      ),
    ];

    final dataSource = _FakeLibraryLocalDataSource();
    final indexer = LibraryIndexer(
      mediaScanner: _FakeMediaScanner(files),
      metadataReader: _FakeMetadataReader(const {}),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    );

    await indexer.indexLibrary().toList();

    expect(dataSource.artists.values.single.name, 'Unknown Artist');
    expect(dataSource.albums.values.single.title, 'Unknown Album');
  });

  test(
    'writes an album and its artist before any track pointing at them',
    () async {
      final files = [
        _file(
          mediaStoreId: 1,
          filePath: '/music/a.mp3',
          title: 'A',
          duration: const Duration(minutes: 3),
        ),
        _file(
          mediaStoreId: 2,
          filePath: '/music/b.mp3',
          title: 'B',
          duration: const Duration(minutes: 4),
          album: 'Afterglow',
        ),
      ];

      final dataSource = _FakeLibraryLocalDataSource();
      final indexer = LibraryIndexer(
        mediaScanner: _FakeMediaScanner(files),
        metadataReader: _FakeMetadataReader(const {}),
        artworkCache: _FakeArtworkCache(),
        dataSource: dataSource,
        idGenerator: _FakeIdGenerator(),
      );

      await indexer.indexLibrary().toList();

      for (final track in dataSource.tracks.values) {
        final trackAt = dataSource.writes.indexOf('track:${track.id}');
        final albumAt = dataSource.writes.indexOf('album:${track.albumId}');
        final artistAt = dataSource.writes.indexOf('artist:${track.artistId}');

        expect(albumAt, isNonNegative, reason: 'album row never written');
        expect(artistAt, isNonNegative, reason: 'artist row never written');
        expect(albumAt, lessThan(trackAt), reason: 'album written after track');
        expect(
          artistAt,
          lessThan(trackAt),
          reason: 'artist written after track',
        );
      }
    },
  );

  test(
    're-indexing keeps each track id and does not double aggregates',
    () async {
      final files = [
        _file(
          mediaStoreId: 1,
          filePath: '/music/a.mp3',
          title: 'A',
          duration: const Duration(minutes: 3),
        ),
        _file(
          mediaStoreId: 2,
          filePath: '/music/b.mp3',
          title: 'B',
          duration: const Duration(minutes: 4),
        ),
      ];

      final dataSource = _FakeLibraryLocalDataSource();
      LibraryIndexer buildIndexer() => LibraryIndexer(
        mediaScanner: _FakeMediaScanner(files),
        metadataReader: _FakeMetadataReader(const {}),
        artworkCache: _FakeArtworkCache(),
        dataSource: dataSource,
        idGenerator: _FakeIdGenerator(),
      );

      await buildIndexer().indexLibrary().toList();
      final idsAfterFirst = dataSource.tracks.values
          .map((t) => '${t.sourceId}:${t.id}')
          .toSet();

      await buildIndexer().indexLibrary().toList();

      expect(
        dataSource.tracks.values.map((t) => '${t.sourceId}:${t.id}').toSet(),
        idsAfterFirst,
        reason: 'a re-scan must not churn ids other rows point at',
      );
      expect(dataSource.tracks, hasLength(2));
      expect(dataSource.albums.values.single.trackCount, 2);
      expect(
        dataSource.albums.values.single.totalDuration,
        const Duration(minutes: 7),
      );
      expect(dataSource.artists.values.single.trackCount, 2);
      expect(dataSource.artists.values.single.albumCount, 1);
    },
  );

  test('counts one album per distinct album of the same artist', () async {
    final files = [
      _file(
        mediaStoreId: 1,
        filePath: '/music/a.mp3',
        title: 'A',
        duration: const Duration(minutes: 3),
      ),
      _file(
        mediaStoreId: 2,
        filePath: '/music/b.mp3',
        title: 'B',
        duration: const Duration(minutes: 3),
        album: 'Afterglow',
      ),
    ];

    final dataSource = _FakeLibraryLocalDataSource();
    await LibraryIndexer(
      mediaScanner: _FakeMediaScanner(files),
      metadataReader: _FakeMetadataReader(const {}),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    ).indexLibrary().toList();

    expect(dataSource.albums, hasLength(2));
    expect(dataSource.artists.values.single.albumCount, 2);
    expect(dataSource.artists.values.single.trackCount, 2);
  });

  test('saves an album cover once, not once per track on it', () async {
    final files = [
      _file(
        mediaStoreId: 1,
        filePath: '/music/a.mp3',
        title: 'A',
        duration: const Duration(minutes: 3),
      ),
      _file(
        mediaStoreId: 2,
        filePath: '/music/b.mp3',
        title: 'B',
        duration: const Duration(minutes: 3),
      ),
    ];
    final artwork = EmbeddedArtwork(
      data: Uint8List.fromList([1, 2, 3]),
      mimeType: 'image/jpeg',
    );

    final artworkCache = _CountingArtworkCache();
    final dataSource = _FakeLibraryLocalDataSource();
    await LibraryIndexer(
      mediaScanner: _FakeMediaScanner(files),
      metadataReader: _FakeMetadataReader({
        '/music/a.mp3': TrackMetadata(artwork: artwork),
        '/music/b.mp3': TrackMetadata(artwork: artwork),
      }),
      artworkCache: artworkCache,
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    ).indexLibrary().toList();

    expect(artworkCache.saveCalls, 1);
  });

  test('does not write an album or artist row per track', () async {
    const trackCount = 600;
    const albumCount = 40;
    const artistCount = 8;
    final files = [
      for (var i = 0; i < trackCount; i++)
        _file(
          mediaStoreId: i,
          filePath: '/music/$i.mp3',
          title: 'T$i',
          duration: const Duration(minutes: 3),
          artist: 'Artist ${i % artistCount}',
          album: 'Album ${i % albumCount}',
        ),
    ];

    final dataSource = _FakeLibraryLocalDataSource();
    await LibraryIndexer(
      mediaScanner: _FakeMediaScanner(files),
      metadataReader: _FakeMetadataReader(const {}),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    ).indexLibrary().toList();

    int writesOf(String kind) =>
        dataSource.writes.where((w) => w.startsWith('$kind:')).length;

    // Two per album and per artist: the row the tracks reference, then the
    // final totals. Anything approaching `trackCount` means the per-file
    // upserts are back.
    expect(writesOf('album'), albumCount * 2);
    expect(writesOf('artist'), artistCount * 2);
    expect(writesOf('track'), trackCount);

    expect(dataSource.albums, hasLength(albumCount));
    expect(dataSource.artists, hasLength(artistCount));
    for (final album in dataSource.albums.values) {
      expect(album.trackCount, trackCount ~/ albumCount);
    }
    for (final artist in dataSource.artists.values) {
      expect(artist.trackCount, trackCount ~/ artistCount);
    }
  });

  test('commits in batches rather than once per write', () async {
    const trackCount = 120;
    final files = [
      for (var i = 0; i < trackCount; i++)
        _file(
          mediaStoreId: i,
          filePath: '/music/$i.mp3',
          title: 'T$i',
          duration: const Duration(minutes: 3),
        ),
    ];

    final dataSource = _FakeLibraryLocalDataSource();
    await LibraryIndexer(
      mediaScanner: _FakeMediaScanner(files),
      metadataReader: _FakeMetadataReader(const {}),
      artworkCache: _FakeArtworkCache(),
      dataSource: dataSource,
      idGenerator: _FakeIdGenerator(),
    ).indexLibrary().toList();

    expect(
      dataSource.writesOutsideTransaction,
      isEmpty,
      reason: 'every write should be inside a transaction',
    );
    // Batches of 25 over 120 files, plus the closing totals.
    expect(dataSource.transactions, 6);
    expect(dataSource.writes.length, greaterThan(trackCount));
  });
}
